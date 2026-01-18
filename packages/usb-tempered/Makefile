include $(TOPDIR)/rules.mk

PKG_NAME:=usb-tempered
PKG_VERSION:=1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/usb-tempered.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=b7ccc208b0365313c3884934c92eb8457fda261b

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/usb-tempered
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=usb-tempered
  URL:=https://github.com/hackboxguy/usb-tempered.git
  DEPENDS:=+libc +libstdcpp +hidapi
endef

define Package/usb-tempered/description
  usb-tempered is a utility for reading temperature from TEMPer usb device
endef

# Workaround for CMake 3.30+ removing compatibility with old cmake_minimum_required
CMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5

define Package/usb-tempered/install
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/*.h* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/tempered $(1)/usr/bin
endef

$(eval $(call BuildPackage,usb-tempered))
