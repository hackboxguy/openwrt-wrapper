#!/bin/bash
#this is a top-level script to build openwrt based images for different hw-configs
OPENWRT_SYSTEM_CONFIG=gl-mt300nv2-awsiot #defautl config to build if not specified
OPENWRT_IMAGE_VERSION=00.01 #default version will be 00.01.<build_num>
OPENWRT_FOLDER=./openwrt
PREPARE_ONLY=0
KEY_FILE="none"
PRIVKEY_FILE="none"
FULL_BUILD="yes"

while getopts ir:o:k:b:v:p f
do
    case $f in
	b) OPENWRT_SYSTEM_CONFIG=$OPTARG;;  #board/system type for different application
	v) OPENWRT_IMAGE_VERSION=$OPTARG ;; #image version
	p) PREPARE_ONLY=1 ;; #dont build image, just prepare needed folders/files
	k) KEY_FILE=$OPTARG ;; #public key file for image signature verification
	r) PRIVKEY_FILE=$OPTARG ;; #private key for signing the image
	i) FULL_BUILD="no";; #image-only: dont do full build - generate image only
	o) OPENWRT_VERSION=$OPTARG;;
    esac
done

#prepare a buildnumber for the image
git pull > /dev/null
BUILDNUMBER=$(git rev-list --count --first-parent HEAD)
BUILDNUMBER=$(printf "$OPENWRT_IMAGE_VERSION.%04d" $BUILDNUMBER)

#./openwrt folder mus exist - use git --recursive to clone openwrt-wrapper
[ ! -d  "$OPENWRT_FOLDER" ] && { echo "Error: folder $OPENWRT_FOLDER not found!"   ; exit -1; }

if [ -z "$OPENWRT_VERSION" ]; then
        echo "custom-openwrt-version is not requested hence proceed with existing openwrt submodule version"
else
        echo "checkout specific version of openwrt: $OPENWRT_VERSION"
	pushd .;cd $OPENWRT_FOLDER;git checkout -b $OPENWRT_VERSION;popd
fi

#see if custom patch needs to be applied to mainline-openwrt
if [ -f configs/$OPENWRT_SYSTEM_CONFIG/patches/custom-patch.sh ]; then
	./configs/$OPENWRT_SYSTEM_CONFIG/patches/custom-patch.sh
	echo "custom patch applied!!"
fi

pushd .
cd $OPENWRT_FOLDER
ln -s ../configs/$OPENWRT_SYSTEM_CONFIG/rootfs_overlay files #create custom-files overlay
cp ../configs/$OPENWRT_SYSTEM_CONFIG/*.dts  target/linux/ramips/dts/
cp ../configs/$OPENWRT_SYSTEM_CONFIG/*.dtsi target/linux/ramips/dts/
[ $FULL_BUILD = "yes" ] && ./scripts/feeds update -a

#update luci packages
./scripts/feeds update packages luci
./scripts/feeds install -a -p luci

#update feeds/package.index with sw packages that are not part of standard openwrt packages
../configs/update-custom-package-index.sh

#install other openwrt-packages that are needed for building the image
EXTRA_PKGS=$(cat ../configs/extra_packages)
[ $FULL_BUILD = "yes" ] && ./scripts/feeds install $EXTRA_PKGS

BOARD_CONFIG_PKGS=$(cat ../configs/$OPENWRT_SYSTEM_CONFIG/extra_packages)
if [ -z "$BOARD_CONFIG_PKGS" ]; then
	echo "board specific package installation is not requested"
else
	echo "Installing board specific packages"
	[ $FULL_BUILD = "yes" ] && ./scripts/feeds install $BOARD_CONFIG_PKGS
fi

#before starting the build, copy needed open-wrt-config file to openwrt folder
cp ../configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG ./.config

#before starting the build, override default linux config with custom-linux-config if available
LINUX_CONFIG_DEST=$(cat ../configs/$OPENWRT_SYSTEM_CONFIG/linux-config-destination.txt)
if [ ! -z $LINUX_CONFIG_DEST ]; then
	cp ../configs/$OPENWRT_SYSTEM_CONFIG/config-* $LINUX_CONFIG_DEST
fi

#copy buildversion to overlay /etc/version.txt file
echo $BUILDNUMBER > files/etc/version.txt
#copy system-config-type to overlay files/boot/sysconfig.txt
echo "$OPENWRT_SYSTEM_CONFIG" > files/etc/sysconfig.txt

#if provided, include public-key in rootfs for image signature verification during update
if [ $KEY_FILE != "none" ]; then
	cp $KEY_FILE files/etc/update_signature.txt
fi

[ $FULL_BUILD = "yes" ] && make defconfig

if [ $PREPARE_ONLY = 1 ]; then
	popd
	exit 0
fi

#build the image -j value depends on number of available cores/threads
if [ $FULL_BUILD = "yes" ]; then
	make PKG_HASH=skip -j$(nproc)
	BUILD_RESULT=$?
else
	BUILD_RESULT=0 #just go ahead with image creation
fi

popd

#if private key file is provided, then sign the image and create mipsProj.bin
if [ $BUILD_RESULT = "0" ]; then
	if [ -f  "$PRIVKEY_FILE"  ]; then
		#variables for image creation
		OUT_BIN_PATH=$(cat ./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars | grep output-binary-file | awk '{print $3}')
		MKUIMG_UTIL=$(cat ./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars | grep mkuimg-util | awk '{print $3}')
		MKIMAGE_UTIL=$(cat ./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars | grep mkimage-util | awk '{print $3}')
		IMG_CREATOR=$(cat ./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars | grep image-creator | awk '{print $3}')
		IMG_TYPE=$(cat ./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars | grep mkimage-type | awk '{print $3}')
		$IMG_CREATOR --type=$IMG_TYPE --infile=$OUT_BIN_PATH --private=$PRIVKEY_FILE --mkimage=$MKIMAGE_UTIL --mkuimg=$MKUIMG_UTIL --version=$BUILDNUMBER --outfile=./$OPENWRT_SYSTEM_CONFIG.uimg
	fi
fi
