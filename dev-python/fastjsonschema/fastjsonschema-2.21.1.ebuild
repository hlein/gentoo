# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fast JSON schema validator for Python"
HOMEPAGE="
	https://github.com/horejsek/python-fastjsonschema/
	https://pypi.org/project/fastjsonschema/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/benchmarks
)
