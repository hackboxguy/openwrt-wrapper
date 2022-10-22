include $(TOPDIR)/rules.mk

PKG_NAME:=awsiot-openwrt-extensions
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/awsiot-openwrt-extensions.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=18316d3ff6c867dc56e252a4377db2bd06e3778c

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1
#TARGET_LDFLAGS += -largp
include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

#DEPENDS:=+libc +hidapi +libusb-1.0 +libusb-compat +cJSON
define Package/awsiot-openwrt-extensions
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=awsiot-openwrt-extensions
  URL:=https://github.com/hackboxguy/awsiot-openwrt-extensions
  DEPENDS:=+libc
endef

define Package/awsiot-openwrt-extensions/description
  awsiot-openwrt-extensions provides a layer for openwrt to add aws-iot-demo specific functionality.
endef

define Package/awsiot-openwrt-extensions/install
	$(INSTALL_DIR) $(1)/etc/triggerhappy/triggers.d
	$(CP) $(PKG_INSTALL_DIR)/usr/etc/triggerhappy/triggers.d/* $(1)/etc/triggerhappy/triggers.d/
	
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_INSTALL_DIR)/usr/etc/config/* $(1)/etc/config/
	
	$(INSTALL_DIR) $(1)/etc/rc.button
	$(CP) $(PKG_INSTALL_DIR)/usr/etc/rc.button/* $(1)/etc/rc.button/
	
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/upgrade/keep.d/* $(1)/lib/upgrade/keep.d/
	
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/usr/sbin/* $(1)/usr/sbin/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/awsiot
	$(CP) $(PKG_INSTALL_DIR)/usr/usr/lib/lua/luci/controller/awsiot/* $(1)/usr/lib/lua/luci/controller/awsiot/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/awsiot_cbi
	$(CP) $(PKG_INSTALL_DIR)/usr/usr/lib/lua/luci/model/cbi/awsiot_cbi/* $(1)/usr/lib/lua/luci/model/cbi/awsiot_cbi/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/awsiot_view
	$(CP) $(PKG_INSTALL_DIR)/usr/usr/lib/lua/luci/view/awsiot_view/* $(1)/usr/lib/lua/luci/view/awsiot_view/
endef

$(eval $(call BuildPackage,awsiot-openwrt-extensions))
