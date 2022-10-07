include $(TOPDIR)/rules.mk

PKG_NAME:=aws-iot-device-sdk-cpp-v2
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/aws/aws-iot-device-sdk-cpp-v2.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=4b42edc5e04d08946fd428c07c1d69e823e6749c

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/aws-iot-device-sdk-cpp-v2
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=aws-iot-device-sdk-cpp-v2
  URL:=https://github.com/aws/aws-iot-device-sdk-cpp-v2
  DEPENDS:=+libc +libstdcpp +libcurl +zlib +libopenssl
endef

define Package/aws-iot-device-sdk-cpp-v2/description
  aws-iot-device-sdk-cpp-v2 provides AWS-IoT connectivity api interface
endef


define Package/aws-iot-device-sdk-cpp-v2/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib $(1)/usr/
endef

$(eval $(call BuildPackage,aws-iot-device-sdk-cpp-v2))
