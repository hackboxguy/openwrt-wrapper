include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-base-scripts
PKG_VERSION:=1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/openwrt-base-scripts.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7eaacde0cc6bc119cce3c97c4942dd6dd25918ab

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=+argp-standalone
CMAKE_INSTALL:=1
TARGET_LDFLAGS += -largp
include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/openwrt-base-scripts
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=openwrt-base-scripts
  URL:=https://github.com/hackboxguy/openwrt-base-scripts
  DEPENDS:=+libc +hidapi +libusb-1.0 +libusb-compat +cJSON
endef

define Package/openwrt-base-scripts/description
  openwrt-base-scripts provides basic set of scripts for openwrt-linux-system.
endef
# Workaround for CMake 3.30+ removing compatibility with old cmake_minimum_required
CMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5
CMAKE_OPTIONS += -DCMAKE_CXX_COMPILER_FORCED=TRUE
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
