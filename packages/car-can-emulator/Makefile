include $(TOPDIR)/rules.mk

PKG_NAME:=car-can-emulator
PKG_VERSION:=1.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/hackboxguy/car-can-emulator.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7228469ceb1d495e005a7067691da3132b84a4d2

PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
#PKG_BUILD_DEPENDS:=+argp-standalone
CMAKE_INSTALL:=1
#TARGET_LDFLAGS += -largp
include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/car-can-emulator
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=car-can-emulator
  URL:=https://github.com/hackboxguy/car-can-emulator
  DEPENDS:=+libc +libstdcpp 
endef

define Package/car-can-emulator/description
  car-can-emulator provides a car emulation service for testeing CAN based devices.
endef
CMAKE_OPTIONS += -DCMAKE_CXX_COMPILER_FORCED=TRUE
define Package/car-can-emulator/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/usr/sbin/* $(1)/usr/sbin/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/etc/init.d/Wrt* $(1)/etc/init.d/
endef

$(eval $(call BuildPackage,car-can-emulator))
