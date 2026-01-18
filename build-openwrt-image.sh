#!/bin/bash
set -eu  # Exit on error (-e) and undefined variables (-u)
#this is a top-level script to build openwrt based images for different hw-configs

# Color definitions (disabled if not a terminal)
if [ -t 1 ]; then
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	YELLOW='\033[0;33m'
	BLUE='\033[0;34m'
	BOLD='\033[1m'
	NC='\033[0m' # No Color
else
	RED=''
	GREEN=''
	YELLOW=''
	BLUE=''
	BOLD=''
	NC=''
fi

# Helper functions for colored output
print_ok()   { echo -e "  ${GREEN}[OK]${NC} $1"; }
print_warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; }
print_fail() { echo -e "  ${RED}[FAIL]${NC} $1"; }
print_info() { echo -e "${BLUE}==>${NC} $1"; }
print_error() { echo -e "${RED}Error:${NC} $1"; }

usage() {
	echo "Usage: $(basename "$0") [OPTIONS]"
	echo ""
	echo "Build OpenWRT images for different router hardware configurations."
	echo ""
	echo "Options:"
	echo "  -b CONFIG   Board/system config name (default: gl-mt300nv2-awsiot)"
	echo "  -v VERSION  Image version prefix (default: 00.01)"
	echo "  -o VERSION  OpenWRT version to checkout (optional)"
	echo "  -k FILE     Public key file for image signature verification"
	echo "  -r FILE     Private key file for signing the image"
	echo "  -p          Prepare only - don't build, just setup folders/files"
	echo "  -i          Image only - skip full build, generate image only"
	echo "  -c          Check/validate configuration only (no changes made)"
	echo "  -h, --help  Show this help message"
	echo ""
	echo "Example:"
	echo "  $(basename "$0") -b raspi4-remote-kit -v 01.00"
}

# Show help if --help is passed or no arguments provided
if [ $# -eq 0 ] || [ "$1" = "--help" ]; then
	usage
	exit 0
fi

OPENWRT_SYSTEM_CONFIG=gl-mt300nv2-awsiot #default config to build if not specified
OPENWRT_IMAGE_VERSION=00.01 #default version will be 00.01.<build_num>
OPENWRT_FOLDER=./openwrt
OPENWRT_VERSION=""  # Empty by default (use submodule version)
PREPARE_ONLY=0
CHECK_ONLY=0
KEY_FILE="none"
PRIVKEY_FILE="none"
FULL_BUILD="yes"

while getopts chir:o:k:b:v:p f
do
	case $f in
		h) usage; exit 0;;
		c) CHECK_ONLY=1;;  #validate configuration only
		b) OPENWRT_SYSTEM_CONFIG=$OPTARG;;  #board/system type for different application
		v) OPENWRT_IMAGE_VERSION=$OPTARG;;  #image version
		p) PREPARE_ONLY=1;;  #dont build image, just prepare needed folders/files
		k) KEY_FILE=$OPTARG;;  #public key file for image signature verification
		r) PRIVKEY_FILE=$OPTARG;;  #private key for signing the image
		i) FULL_BUILD="no";;  #image-only: dont do full build - generate image only
		o) OPENWRT_VERSION=$OPTARG;;
		\?) usage; exit 1;;  #invalid option
	esac
done

#validate configuration function
validate_config() {
	local errors=0
	echo -e "${BOLD}=== Configuration Validation ===${NC}"
	echo ""
	echo -e "${BOLD}Build Settings:${NC}"
	echo "  Board config:      $OPENWRT_SYSTEM_CONFIG"
	echo "  Image version:     $OPENWRT_IMAGE_VERSION"
	echo "  OpenWRT version:   ${OPENWRT_VERSION:-<submodule default>}"
	echo "  Full build:        $FULL_BUILD"
	echo "  Prepare only:      $PREPARE_ONLY"
	echo ""

	echo -e "${BOLD}Checking required files and directories...${NC}"

	# Check openwrt folder
	if [ -d "$OPENWRT_FOLDER" ]; then
		print_ok "OpenWRT folder: $OPENWRT_FOLDER"
	else
		print_fail "OpenWRT folder not found: $OPENWRT_FOLDER"
		errors=$((errors + 1))
	fi

	# Check config directory
	if [ -d "configs/$OPENWRT_SYSTEM_CONFIG" ]; then
		print_ok "Config directory: configs/$OPENWRT_SYSTEM_CONFIG"
	else
		print_fail "Config directory not found: configs/$OPENWRT_SYSTEM_CONFIG"
		errors=$((errors + 1))
	fi

	# Check main config file
	if [ -f "configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG" ]; then
		print_ok "Main config file: configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG"
	else
		print_fail "Main config file not found: configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG"
		errors=$((errors + 1))
	fi

	# Check rootfs overlay
	if [ -d "configs/$OPENWRT_SYSTEM_CONFIG/rootfs_overlay" ]; then
		print_ok "Rootfs overlay: configs/$OPENWRT_SYSTEM_CONFIG/rootfs_overlay"
	else
		print_warn "Rootfs overlay not found: configs/$OPENWRT_SYSTEM_CONFIG/rootfs_overlay"
	fi

	# Check optional symlinks for build cache
	if [ -L "openwrt-dl" ] || [ -d "openwrt-dl" ]; then
		print_ok "Download cache: openwrt-dl"
	else
		print_warn "Download cache not found: openwrt-dl (builds will download fresh)"
	fi

	if [ -L "openwrt-packages" ] || [ -d "openwrt-packages" ]; then
		print_ok "Packages cache: openwrt-packages"
	else
		print_warn "Packages cache not found: openwrt-packages"
	fi

	# Check OpenWRT version if specified
	if [ -n "$OPENWRT_VERSION" ] && [ -d "$OPENWRT_FOLDER" ]; then
		pushd "$OPENWRT_FOLDER" > /dev/null 2>&1 || true
		git fetch --tags > /dev/null 2>&1 || true
		if git rev-parse "$OPENWRT_VERSION" > /dev/null 2>&1; then
			print_ok "OpenWRT version exists: $OPENWRT_VERSION"
		else
			print_fail "OpenWRT version not found: $OPENWRT_VERSION"
			errors=$((errors + 1))
		fi
		popd > /dev/null 2>&1 || true
	fi

	# Check key files if specified
	if [ "$KEY_FILE" != "none" ]; then
		if [ -f "$KEY_FILE" ]; then
			print_ok "Public key file: $KEY_FILE"
		else
			print_fail "Public key file not found: $KEY_FILE"
			errors=$((errors + 1))
		fi
	fi

	if [ "$PRIVKEY_FILE" != "none" ]; then
		if [ -f "$PRIVKEY_FILE" ]; then
			print_ok "Private key file: $PRIVKEY_FILE"
		else
			print_fail "Private key file not found: $PRIVKEY_FILE"
			errors=$((errors + 1))
		fi
	fi

	echo ""
	if [ $errors -eq 0 ]; then
		echo -e "${GREEN}${BOLD}=== Validation PASSED ===${NC}"
		return 0
	else
		echo -e "${RED}${BOLD}=== Validation FAILED ($errors error(s)) ===${NC}"
		return 1
	fi
}

# Run validation if -c flag is set
if [ "$CHECK_ONLY" = 1 ]; then
	set +e  # Disable exit on error for validation
	validate_config
	exit $?
fi

#prepare a buildnumber for the image
git pull > /dev/null 2>&1 || print_warn "git pull failed, continuing with local version"
BUILDNUMBER=$(git rev-list --count --first-parent HEAD)
BUILDNUMBER=$(printf "$OPENWRT_IMAGE_VERSION.%04d" $BUILDNUMBER)

#./openwrt folder must exist - use git --recursive to clone openwrt-wrapper
if [ ! -d "$OPENWRT_FOLDER" ]; then
	print_error "folder $OPENWRT_FOLDER not found!"
	exit 1
fi

#config directory must exist
if [ ! -d "configs/$OPENWRT_SYSTEM_CONFIG" ]; then
	print_error "config directory not found: configs/$OPENWRT_SYSTEM_CONFIG"
	echo "Available configs:"
	ls -1 configs/ 2>/dev/null | head -10 || true
	exit 1
fi

#main config file must exist
if [ ! -f "configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG" ]; then
	print_error "main config file not found: configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG"
	exit 1
fi

if [ -z "$OPENWRT_VERSION" ]; then
	print_info "Using existing openwrt submodule version"
else
	print_info "Checking out OpenWRT version: $OPENWRT_VERSION"
	pushd "$OPENWRT_FOLDER" > /dev/null || { print_error "failed to enter $OPENWRT_FOLDER"; exit 1; }
	git fetch --tags > /dev/null 2>&1 || true
	if ! git checkout "$OPENWRT_VERSION" 2>/dev/null; then
		print_error "failed to checkout OpenWRT version '$OPENWRT_VERSION'"
		echo "Available tags:"
		git tag | grep -E "^v[0-9]+\." | tail -10 || true
		popd > /dev/null
		exit 1
	fi
	print_ok "Checked out OpenWRT $OPENWRT_VERSION"
	popd > /dev/null
fi

#see if custom patch needs to be applied to mainline-openwrt
if [ -f "configs/$OPENWRT_SYSTEM_CONFIG/patches/custom-patch.sh" ]; then
	print_info "Applying custom patch..."
	"./configs/$OPENWRT_SYSTEM_CONFIG/patches/custom-patch.sh"
	print_ok "Custom patch applied"
fi

pushd "$OPENWRT_FOLDER" > /dev/null
ln -sf "../configs/$OPENWRT_SYSTEM_CONFIG/rootfs_overlay" files #create custom-files overlay
cp "../configs/$OPENWRT_SYSTEM_CONFIG"/*.dts target/linux/ramips/dts/ 2>/dev/null || true
cp "../configs/$OPENWRT_SYSTEM_CONFIG"/*.dtsi target/linux/ramips/dts/ 2>/dev/null || true
[ "$FULL_BUILD" = "yes" ] && ./scripts/feeds update -a

#update luci packages
./scripts/feeds update packages luci
./scripts/feeds install -a -p luci

#update feeds/package.index with sw packages that are not part of standard openwrt packages
../configs/update-custom-package-index.sh

#install other openwrt-packages that are needed for building the image
if [ -f ../configs/extra_packages ]; then
	EXTRA_PKGS=$(cat ../configs/extra_packages)
	[ "$FULL_BUILD" = "yes" ] && ./scripts/feeds install $EXTRA_PKGS
else
	print_warn "../configs/extra_packages not found, skipping global extra packages"
fi

if [ -f "../configs/$OPENWRT_SYSTEM_CONFIG/extra_packages" ]; then
	BOARD_CONFIG_PKGS=$(cat "../configs/$OPENWRT_SYSTEM_CONFIG/extra_packages")
else
	BOARD_CONFIG_PKGS=""
fi
if [ -z "$BOARD_CONFIG_PKGS" ]; then
	print_info "No board specific packages requested"
else
	print_info "Installing board specific packages"
	[ "$FULL_BUILD" = "yes" ] && ./scripts/feeds install $BOARD_CONFIG_PKGS
fi

#before starting the build, copy needed open-wrt-config file to openwrt folder
cp "../configs/$OPENWRT_SYSTEM_CONFIG/$OPENWRT_SYSTEM_CONFIG" ./.config

#before starting the build, override default linux config with custom-linux-config if available
if [ -f "../configs/$OPENWRT_SYSTEM_CONFIG/linux-config-destination.txt" ]; then
	LINUX_CONFIG_DEST=$(cat "../configs/$OPENWRT_SYSTEM_CONFIG/linux-config-destination.txt")
	if [ -n "$LINUX_CONFIG_DEST" ]; then
		cp "../configs/$OPENWRT_SYSTEM_CONFIG"/config-* "$LINUX_CONFIG_DEST" 2>/dev/null || true
	fi
fi

#copy buildversion to overlay /etc/version.txt file
echo "$BUILDNUMBER" > files/etc/version.txt
#copy system-config-type to overlay files/boot/sysconfig.txt
echo "$OPENWRT_SYSTEM_CONFIG" > files/etc/sysconfig.txt

#if provided, include public-key in rootfs for image signature verification during update
if [ "$KEY_FILE" != "none" ]; then
	cp "$KEY_FILE" files/etc/update_signature.txt
fi

[ "$FULL_BUILD" = "yes" ] && make defconfig

if [ "$PREPARE_ONLY" = 1 ]; then
	popd > /dev/null
	print_ok "Preparation complete (build skipped)"
	exit 0
fi

#build the image -j value depends on number of available cores/threads
if [ "$FULL_BUILD" = "yes" ]; then
	print_info "Building with $(nproc) parallel jobs..."
	set +e  # Disable exit on error for make (we handle it ourselves)
	make PKG_HASH=skip -j$(nproc)
	BUILD_RESULT=$?
	set -e
	if [ "$BUILD_RESULT" = "0" ]; then
		print_ok "Build completed successfully"
	else
		print_error "Build failed with exit code $BUILD_RESULT"
	fi
else
	BUILD_RESULT=0 #just go ahead with image creation
fi

popd > /dev/null

#if private key file is provided, then sign the image and create mipsProj.bin
if [ "$BUILD_RESULT" = "0" ]; then
	if [ -f "$PRIVKEY_FILE" ]; then
		print_info "Signing image with private key..."
		#read all variables from package-creator-vars in a single pass
		PACKAGE_VARS_FILE="./configs/$OPENWRT_SYSTEM_CONFIG/package-creator-vars"
		if [ ! -f "$PACKAGE_VARS_FILE" ]; then
			print_error "package-creator-vars not found: $PACKAGE_VARS_FILE"
			exit 1
		fi
		eval "$(awk '
			/output-binary-file/ { print "OUT_BIN_PATH=\"" $3 "\"" }
			/mkuimg-util/        { print "MKUIMG_UTIL=\"" $3 "\"" }
			/mkimage-util/       { print "MKIMAGE_UTIL=\"" $3 "\"" }
			/image-creator/      { print "IMG_CREATOR=\"" $3 "\"" }
			/mkimage-type/       { print "IMG_TYPE=\"" $3 "\"" }
		' "$PACKAGE_VARS_FILE")"
		"$IMG_CREATOR" --type="$IMG_TYPE" --infile="$OUT_BIN_PATH" --private="$PRIVKEY_FILE" --mkimage="$MKIMAGE_UTIL" --mkuimg="$MKUIMG_UTIL" --version="$BUILDNUMBER" --outfile="./$OPENWRT_SYSTEM_CONFIG.uimg"
		print_ok "Signed image created: ./$OPENWRT_SYSTEM_CONFIG.uimg"
	fi
fi
