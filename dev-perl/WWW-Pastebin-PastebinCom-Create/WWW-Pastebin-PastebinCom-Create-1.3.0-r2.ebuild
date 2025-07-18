# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZOFFIX
DIST_VERSION=1.003
inherit perl-module

DESCRIPTION="Paste on www.pastebin.com without API keys"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

RDEPEND="
	>=dev-perl/Moo-1.4.1
	>=dev-perl/WWW-Mechanize-1.730.0
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
"

src_test() {
	local my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if ! has network ${my_test_control} ; then
		einfo "Supressing Network Test without DIST_TEST_OVERRIDE =~ network"
		perl_rm_files t/01-paste.t
	fi
	perl-module_src_test
}
