# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=IGUTHRIE
DIST_VERSION=0.92
inherit perl-module

DESCRIPTION="Disk free based on Filesys::Statvfs"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
