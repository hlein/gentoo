# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic optfeature strip-linguas xdg

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko ku lb lt mn nl nn pl pt pt_BR ro ru si sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="https://www.geany.org"
if [[ "${PV}" = 9999* ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/geany/geany.git"
else
	[[ "${PV}" == *_pre* ]] && inherit autotools
	SRC_URI="https://download.geany.org/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
fi
LICENSE="GPL-2+ HPND"
SLOT="0"

IUSE="+vte wayland X"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.24:3[wayland?,X?]
	vte? ( x11-libs/vte:2.91 )
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${P}-gcc15.patch" )

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	xdg_environment_reset #588570
	default

	# Syntax highlighting for Portage
	sed -i -e "s:*.sh;:*.sh;*.ebuild;*.eclass;:" \
		data/filetype_extensions.conf || die

	if [[ ${PV} = *_pre* ]] || [[ ${PV} = 9999* ]] ; then
		eautoreconf
	fi
}

src_configure() {
	use X || append-cflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	local myeconfargs=(
		--disable-html-docs
		--disable-pdf-docs
		--disable-static
		$(use_enable vte)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "editing files outside the local filesystem" gnome-base/gvfs
}

pkg_postrm() {
	xdg_pkg_postrm
}
