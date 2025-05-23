# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1

DESCRIPTION="An MkDocs plugin to minify HTML and/or JS files prior to being written to disk"
HOMEPAGE="
	https://github.com/byrnereese/mkdocs-minify-plugin
	https://pypi.org/project/mkdocs-minify-plugin/
"
# pypi sdist lacks tests, as of 0.6.4
SRC_URI="
	https://github.com/byrnereese/mkdocs-minify-plugin/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
# https://bugs.gentoo.org/931325
RESTRICT="test"

RDEPEND="
	>=dev-python/csscompressor-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.1[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.13[${PYTHON_USEDEP}]
	>=dev-python/jsmin-3.0.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PATH=${T}:${PATH}
	cat > "${T}"/mkdocs <<-EOF || die
		#!/bin/sh
		exec "${EPYTHON}" -m mkdocs "\${@}"
	EOF
	chmod +x "${T}"/mkdocs || die
	epytest
}
