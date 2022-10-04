include $(TOPDIR)/rules.mk

PKG_NAME:=sshpass
PKG_VERSION:=1.06
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://sourceforge.net/projects/sshpass/files/latest/download/sshpass-1.06.tar.gz

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

define Package/sshpass
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=ssh access without login prompt
  URL:=https://sourceforge.net/projects/sshpass
  DEPENDS:=+libstdcpp
  #+zlib +libopenssl 
endef

define Package/sshpass/description
  SSHPass is a tiny utility, which allows you to provide the ssh password without using the prompt.
endef

#CONFIGURE_ARGS += \
#		--with-tests="no" \
#		--with-examples="no" \
#		--with-openssl="$(STAGING_DIR)/usr"
define Package/sshpass/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/sshpass $(1)/usr/bin/
endef


$(eval $(call BuildPackage,sshpass))

