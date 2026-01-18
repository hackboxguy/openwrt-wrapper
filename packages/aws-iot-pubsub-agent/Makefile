include $(TOPDIR)/rules.mk

PKG_NAME:=aws-iot-pubsub-agent
PKG_VERSION:=1.2
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/aws-iot-pubsub-agent.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=dfe9403a50d68a8b57943ed3e61514241b2f94d2

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/aws-iot-pubsub-agent
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=aws-iot-pubsub-agent
  URL:=https://github.com/hackboxguy/aws-iot-pubsub-agent
  DEPENDS:=+libc +libstdcpp +cJSON +aws-iot-device-sdk-cpp-v2
endef

define Package/aws-iot-pubsub-agent/description
  A demot publish/subscribe agent to work with AWS-IoT-Core.
endef

CMAKE_OPTIONS += -DCMAKE_PREFIX_PATH=$(BUILD_DIR)/aws-iot-device-sdk-cpp-v2-v1.1/ipkg-install/usr

define Package/aws-iot-pubsub-agent/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/* $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(CP) $(PKG_INSTALL_DIR)/usr/etc/* $(1)/etc/
endef

$(eval $(call BuildPackage,aws-iot-pubsub-agent))
