# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="vdr"
PKG_VERSION="2.4.4"
PKG_SHA256="8a04d12af73d15daed2f9864a9ca0cfb25400da388c41e8476048c61b7ee2c5a"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvdr.de"
PKG_URL="http://ftp.tvdr.de/vdr-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain bzip2 fontconfig freetype libcap libiconv libjpeg-turbo"
PKG_LONGDESC="A DVB TV server application."
PKG_TOOLCHAIN="manual"

post_unpack() {
  rm -rf $PKG_BUILD/PLUGINS/src/skincurses
}

pre_configure_target() {
  export LDFLAGS="$(echo $LDFLAGS | sed -e "s|-Wl,--as-needed||") -L$SYSROOT_PREFIX/usr/lib/iconv"
}

pre_make_target() {
  cat > Make.config <<EOF
  PLUGINLIBDIR = /usr/lib/vdr
  PREFIX = /usr
  VIDEODIR = /storage/videos
  CONFDIR = /storage/.config/vdr
  LOCDIR = /usr/share/locale
  LIBS += -liconv
  NO_KBD=yes
  VDR_USER=root
EOF
}

make_target() {
  make vdr vdr.pc
  make include-dir
}
