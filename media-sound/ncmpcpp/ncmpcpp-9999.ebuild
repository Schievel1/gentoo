# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="Featureful ncurses based MPD client inspired by ncmpc"
HOMEPAGE="
	https://rybczak.net/ncmpcpp/
	https://github.com/ncmpcpp/ncmpcpp/
"
EGIT_REPO_URI="https://github.com/ncmpcpp/ncmpcpp"

LICENSE="GPL-2+"
SLOT="0"
IUSE="clock outputs taglib visualizer"

RDEPEND="
	>=media-libs/libmpdclient-2.1
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/readline:=
	taglib? ( media-libs/taglib:= )
	visualizer? ( sci-libs/fftw:3.0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf

	sed -i -e '/^docdir/d' {,doc/}Makefile{.am,.in} || die
	sed -i -e 's|COPYING||g' Makefile{.am,.in} || die
}

src_configure() {
	# --with-lto only appends -flto
	econf \
		$(use_enable clock) \
		$(use_enable outputs) \
		$(use_enable visualizer) \
		--without-lto \
		$(use_with taglib) \
		$(use_with visualizer fftw)
}

src_install() {
	default

	dodoc doc/{bindings,config}
}

pkg_postinst() {
	echo
	elog "Example configuration files have been installed at"
	elog "${EROOT}/usr/share/doc/${PF}"
	elog "${P} uses ~/.ncmpcpp/config and ~/.ncmpcpp/bindings"
	elog "as user configuration files."
	echo
	if use visualizer; then
	elog "If you want to use the visualizer, you need mpd with fifo enabled."
	echo
	fi
}
