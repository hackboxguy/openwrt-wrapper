include $(TOPDIR)/rules.mk

PKG_NAME:=blinkone
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/todbot/blink1-tool.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=69561a9ed9e83ff67c95cc70187c394150f51cd5

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

#CMAKE_INSTALL:=1

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
#include $(INCLUDE_DIR)/cmake.mk

define Package/blinkone
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=blinkone
  URL:=https://github.com/todbot/blink1-tool.git
  DEPENDS:=+libc +libstdcpp +libudev-zero +hidapi
endef

define Package/blinkone/description
  blinkone is a utility for controlling USB based led lights
endef

define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR) \
                CC="$(TARGET_CC)" \
                CFLAGS="$(TARGET_CFLAGS) -Wall" \
                LDFLAGS="$(TARGET_LDFLAGS)"
endef

#define Build/Compile
#        $(MAKE) -C $(PKG_BUILD_DIR)/ \
#                CC="$(TARGET_CC)" \
#                TARGET=Linux \
#                CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
#                LDFLAGS="$(TARGET_LDFLAGS)"
#endef
#define Build/Compile
#        $(MAKE) -C $(PKG_BUILD_DIR) \
#                CC="$(TARGET_CC)" \
#                CFLAGS="$(TARGET_CFLAGS) -Wall"
#endef

define Package/blinkone/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/blink1-tool $(1)/usr/sbin
endef

$(eval $(call BuildPackage,blinkone))
