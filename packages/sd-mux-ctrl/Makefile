include $(TOPDIR)/rules.mk

PKG_NAME:=sd-mux-ctrl
PKG_VERSION:=v1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/sd-mux-ctrl.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=e31d553c8500a80d1ac6617ec98a550aa405ee1c

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

CMAKE_INSTALL:=1
include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

#DEPENDS:=+libftdi1 +libpopt
define Package/sd-mux-ctrl
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=sd-mux-ctrl
  URL:=https://github.com/hackboxguy/sd-mux-ctrl
  DEPENDS:=+libftdi1 +libpopt
endef

define Package/sd-mux-ctrl/description
  sd-mux-ctrl is a control utility for accessing SDWire hardware.
endef

define Package/sd-mux-ctrl/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/* $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,sd-mux-ctrl))
