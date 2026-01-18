include $(TOPDIR)/rules.mk

PKG_NAME:=brbox
PKG_VERSION:=1.1
PKG_RELEASE:=1

#PKG_SOURCE:=brbox-v1.1.tar.gz
#PKG_SOURCE_URL:=https://github.com/hackboxguy/brbox/archive/refs/tags/

PKG_SOURCE_URL:=https://github.com/hackboxguy/brbox.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=ba3850807067b7f623ead5f65dad9c0bf0b3ec2d

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/brbox
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=brbox
  URL:=https://github.com/hackboxguy/brbox
  DEPENDS:=+libc +libstdcpp +libjson-c +zlib +gloox +libmodbus
endef

define Package/brbox/description
  brbox provides basic set of services like sysmgr/xmproxy/dispsrv etc.
endef

# Workaround for CMake 3.30+ removing compatibility with old cmake_minimum_required
CMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5

CMAKE_OPTIONS += -DAUTO_SVN_VERSION=OFF
CMAKE_OPTIONS += -DINSTALL_CLIENT=ON
#CMAKE_OPTIONS += -DINSTALL_MY_HEADERS=OFF
#CMAKE_OPTIONS += -DSTARTNUM=71
CMAKE_OPTIONS += -DCMAKE_CXX_COMPILER=$(TARGET_CROSS)g++
CMAKE_OPTIONS += -DSDSRV_USE_MUSL=ON
#CMAKE_OPTIONS += -DMINIMUM_BRBOX_SYSTEM=ON
CMAKE_OPTIONS += -DBRBOX_MIPS_UPDATE_UTILS=ON
CMAKE_OPTIONS += -DMKIMG_HOST_BUILD=OFF
#CMAKE_OPTIONS += -DSDSRV_OPENWRT_SYSTEM=ON

define Package/brbox/install
	$(INSTALL_DIR) $(1)/opt/fmw/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/opt/fmw/bin/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/brbox-mkimage $(1)/usr/sbin/
	
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/mips-update.sh $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/etc/init.d/Wrt* $(1)/etc/init.d/
endef

$(eval $(call BuildPackage,brbox))
