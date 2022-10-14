include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-base-scripts
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/openwrt-base-scripts.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=09a43c330c14e82a0a438f02299da0b7e24836f1

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/openwrt-base-scripts
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=openwrt-base-scripts
  URL:=https://github.com/hackboxguy/openwrt-base-scripts
  DEPENDS:=+libc
endef

define Package/openwrt-base-scripts/description
  openwrt-base-scripts provides basic set of scripts for openwrt-linux-system.
endef

CMAKE_OPTIONS += -DAUTO_SVN_VERSION=OFF
#CMAKE_OPTIONS += -DINSTALL_CLIENT=ON
#CMAKE_OPTIONS += -DCMAKE_CXX_COMPILER=mipsel-openwrt-linux-g++
#CMAKE_OPTIONS += -DSDSRV_USE_MUSL=ON
#CMAKE_OPTIONS += -DMINIMUM_BRBOX_SYSTEM=ON
#CMAKE_OPTIONS += -DBRBOX_MIPS_UPDATE_UTILS=ON
#CMAKE_OPTIONS += -DMKIMG_HOST_BUILD=OFF
#CMAKE_OPTIONS += -DSDSRV_OPENWRT_SYSTEM=ON
#CMAKE_OPTIONS += -DCMAKE_INSTALL_PREFIX=/

define Package/openwrt-base-scripts/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/usr/sbin/* $(1)/usr/sbin/
	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/usr/bin/* $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc
	$(CP) $(PKG_INSTALL_DIR)/usr/etc/* $(1)/etc/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/etc/init.d/Wrt* $(1)/etc/init.d/
endef

$(eval $(call BuildPackage,openwrt-base-scripts))
