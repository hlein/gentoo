# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Liberally licensed VNC server library with a clean interface"
HOMEPAGE="https://github.com/any1/neatvnc/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/any1/neatvnc.git"
else
	SRC_URI="https://github.com/any1/neatvnc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="examples gbm h264 jpeg ssl test tracing websockets"
REQUIRED_USE="h264? ( gbm )"
RESTRICT="!test? ( test )"

RDEPEND="
	=dev-libs/aml-0.3*
	sys-libs/zlib
	x11-libs/pixman
	examples? (
		media-libs/libpng:=
	)
	gbm? ( media-libs/mesa )
	h264? (
		media-video/ffmpeg:=
		x11-libs/libdrm
	)
	jpeg? ( media-libs/libjpeg-turbo:= )
	ssl? ( net-libs/gnutls:= )
	tracing? ( dev-debug/systemtap )
	websockets? (
		dev-libs/gmp:=
		dev-libs/nettle:=[gmp]
	)
"
DEPEND="
	${RDEPEND}
	x11-libs/libdrm
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	# useful soname (https://github.com/any1/neatvnc/issues/124)
	sed -i -e "s/'0.0.0'/meson.project_version()/" meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use test tests)
		$(meson_feature jpeg)
		$(meson_feature ssl tls)
		$(meson_feature websockets nettle)
		$(meson_use tracing systemtap)
		$(meson_feature gbm)
		$(meson_feature h264)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	einstalldocs

	if use examples; then
		newbin "${BUILD_DIR}"/examples/draw neatvnc-example-draw
		newbin "${BUILD_DIR}"/examples/png-server neatvnc-example-png-server
	fi
}
