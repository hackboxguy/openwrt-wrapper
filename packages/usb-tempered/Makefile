include $(TOPDIR)/rules.mk

PKG_NAME:=usb-tempered
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://gitlab.com/mulx/TEMPered.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=e1354b775816c7b3e6f5c56405898a7762d51a46

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
  URL:=https://gitlab.com/mulx/TEMPered.git
  DEPENDS:=+libc +libstdcpp +hidapi
endef

define Package/usb-tempered/description
  usb-tempered is a utility for reading temperature from TEMPer usb device
endef


define Package/usb-tempered/install
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/*.h* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/tempered $(1)/usr/bin
endef

$(eval $(call BuildPackage,usb-tempered))
