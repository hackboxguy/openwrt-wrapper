include $(TOPDIR)/rules.mk

PKG_NAME:=gloox
PKG_VERSION:=1.0.24
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_SOURCE_URL:=http://camaya.net/download/gloox-1.0.24.tar.bz2
PKG_SOURCE_URL:=https://camaya.net/download/
PKG_LICENSE:=LGPL-2.1
PKG_LICENSE_FILES:=COPYING.txt

PKG_MAINTAINER:=Albert David <albert dot david at gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
#CMAKE_INSTALL:=1

PKG_FIXUP:=autoreconf
include $(INCLUDE_DIR)/package.mk

#include $(INCLUDE_DIR)/uclibc++.mk
#include $(INCLUDE_DIR)/package.mk
#include $(INCLUDE_DIR)/cmake.mk

define Package/gloox
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=C++ xmpp client library.
  URL:=https://camaya.net/gloox/
  DEPENDS:=+libstdcpp +zlib +libopenssl
  #+libopenssl 
endef

define Package/gloox/description
  libgloox provides library functionality for implmenting xmpp client in c++.
endef

CONFIGURE_ARGS += \
		--with-tests="no" \
		--with-examples="no" \
		--with-openssl="$(STAGING_DIR)/usr"
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/gloox
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/include/gloox/*.h* $(1)/usr/include/gloox/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgloox.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/gloox.pc $(1)/usr/lib/pkgconfig/

endef

define Package/gloox/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgloox.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,gloox))

