# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="
	https://opendev.org/openstack/python-novaclient/
	https://github.com/openstack/python-novaclient/
	https://pypi.org/project/python-novaclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	>dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/stevedore-2.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/bandit[${PYTHON_USEDEP}]
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/python-keystoneclient[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/openstacksdk[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/tempest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	sed -e 's/test_osprofiler/_&/' -i novaclient/tests/unit/test_shell.py || die
	sed -e 's/novaclient\.tests\.unit\.//' -i novaclient/tests/unit/test_api_versions.py || die
	distutils-r1_src_prepare
}

python_test() {
	# functional tests require cloud instance access
	eunittest -b novaclient/tests/unit
}
