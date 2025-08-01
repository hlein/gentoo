# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

CRATES="
	adler32@1.2.0
	adler@1.0.2
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	autocfg@1.3.0
	base64@0.21.7
	bindgen@0.65.1
	bit_field@0.10.2
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	bumpalo@3.16.0
	bytemuck@1.21.0
	byteorder@1.5.0
	bytes@1.9.0
	bzip2-rs@0.1.2
	cbindgen@0.25.0
	cc@1.0.97
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.38
	clang-sys@1.7.0
	color_quant@1.1.0
	core-foundation-sys@0.8.6
	cpufeatures@0.2.12
	crc32fast@1.4.0
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crunchy@0.2.2
	crypto-common@0.1.6
	delharc@0.6.1
	digest@0.10.7
	either@1.11.0
	encoding_rs@0.8.34
	enum-primitive-derive@0.2.2
	errno@0.3.8
	exr@1.72.0
	fastrand@2.1.0
	fdeflate@0.3.4
	flate2@1.0.30
	flume@0.11.0
	generic-array@0.14.7
	gif@0.13.1
	glob@0.3.1
	half@2.4.1
	hashbrown@0.12.3
	heck@0.4.1
	hex-literal@0.4.1
	hex@0.4.3
	home@0.5.9
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	image@0.24.9
	indexmap@1.9.3
	inflate@0.4.5
	itertools@0.10.5
	itoa@1.0.11
	jpeg-decoder@0.3.1
	js-sys@0.3.69
	lazy_static@1.4.0
	lazycell@1.3.0
	lebe@0.5.2
	libc@0.2.155
	libloading@0.8.3
	linux-raw-sys@0.4.13
	lock_api@0.4.12
	log@0.4.21
	memchr@2.7.2
	minimal-lexical@0.2.1
	miniz_oxide@0.7.2
	nom@7.1.3
	num-complex@0.4.5
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.19.0
	paste@1.0.14
	peeking_take_while@0.1.2
	png@0.17.13
	prettyplease@0.2.19
	primal-check@0.3.3
	proc-macro2@1.0.81
	qoi@0.4.1
	quote@1.0.36
	rayon-core@1.12.1
	rayon@1.10.0
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustc-hash@1.1.0
	rustdct@0.7.1
	rustfft@6.2.0
	rustix@0.38.34
	ryu@1.0.17
	scopeguard@1.2.0
	serde@1.0.200
	serde_derive@1.0.200
	serde_json@1.0.116
	sha1@0.10.6
	sha2@0.10.8
	shlex@1.3.0
	simd-adler32@0.3.7
	smallvec@1.13.2
	spin@0.9.8
	strength_reduce@0.2.4
	syn@1.0.109
	syn@2.0.60
	tempfile@3.10.1
	thiserror-impl@1.0.59
	thiserror@1.0.59
	tiff@0.9.1
	tinyvec@1.6.0
	toml@0.5.11
	transpose@0.2.3
	typenum@1.17.0
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	uuid@1.8.0
	version_check@0.9.4
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	weezl@0.1.8
	which@4.4.2
	widestring@1.1.0
	windows-core@0.52.0
	windows-sys@0.52.0
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	zune-inflate@0.2.54
"

# Get the commit from the CLAM-2329-new-from-slice branch
declare -A GIT_CRATES=(
	[onenote_parser]='https://github.com/Cisco-Talos/onenote.rs;8b450447e58143004b68dd21c11b710fdb79be92;onenote.rs-%commit%'
)

inherit cargo cmake eapi9-ver flag-o-matic python-any-r1 systemd tmpfiles

MY_P=${P//_/-}

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
	${CARGO_CRATE_URIS}"
S=${WORKDIR}/clamav-${MY_P}

LICENSE="Apache-2.0 BSD GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
# 0/sts (short term support) if not an LTS release
SLOT="0/sts"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

IUSE="doc clamonacc +clamapp experimental libclamav-only milter rar selinux +system-mspack systemd test"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamapp !milter )
	clamonacc? ( clamapp )
	milter? ( clamapp )
	test? ( !libclamav-only )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
COMMON_DEPEND="
	acct-group/clamav
	acct-user/clamav
	app-arch/bzip2
	dev-libs/json-c:=
	dev-libs/libltdl
	dev-libs/libpcre2:=
	dev-libs/libxml2:=
	dev-libs/openssl:=
	>=sys-libs/zlib-1.2.2:=
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	clamapp? ( sys-libs/ncurses:= net-misc/curl )
	elibc_musl? ( sys-libs/fts-standalone )
	milter? ( mail-filter/libmilter:= )
	rar? ( app-arch/unrar )
	system-mspack? ( dev-libs/libmspack )
	test? ( dev-python/pytest )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

DEPEND="${COMMON_DEPEND}
	test? ( dev-libs/check )"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-clamav )"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-pointer-types.patch"
)

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	rust_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DBYTECODE_RUNTIME="interpreter" # https://github.com/Cisco-Talos/clamav/issues/581 (does not support modern llvm)
		-DCLAMAV_GROUP="clamav"
		-DCLAMAV_USER="clamav"
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_EXPERIMENTAL=$(usex experimental ON OFF)
		-DENABLE_EXTERNAL_MSPACK=$(usex system-mspack ON OFF)
		-DENABLE_JSON_SHARED=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_SHARED_LIB=ON
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DOPTIMIZE=ON
	)

	if use test ; then
		# https://bugs.gentoo.org/818673
		# Used to enable some more tests but doesn't behave well in
		# sandbox necessarily(?) + needs certain debug symbols present
		# in e.g. glibc.
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Valgrind=ON
			-DPYTHON_FIND_VERSION="${EPYTHON#python}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# init scripts
	newinitd "${FILESDIR}/clamd.initd" clamd
	newinitd "${FILESDIR}/freshclam.initd" freshclam
	use clamonacc && \
		newinitd "${FILESDIR}/clamonacc.initd" clamonacc
	use milter && \
		newinitd "${FILESDIR}/clamav-milter.initd" clamav-milter

	if ! use libclamav-only ; then
		if use systemd ; then
			# OpenRC services ensure their own permissions, so we can avoid
			# a dependency on sys-apps/systemd-utils[tmpfiles] here, though
			# we can change our minds and use it if we want to.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav-r1.conf"
		fi

		if use clamapp ; then
			# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/clamd.pid:" \
				-e "s/^#\(LocalSocket .*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
				-e "s:^\#\(LogTime\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/clamd.conf.sample > \
				"${ED}"/etc/clamav/clamd.conf || die

			sed -e "s:^\(Example\):\# \1:" \
				-e "s:^#\(PidFile\) .*:\1 ${EPREFIX}/run/freshclam.pid:" \
				-e "s/^#\(DatabaseOwner .*\)/\1/" \
				-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:" \
				-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/freshclam.conf.sample > \
				"${ED}"/etc/clamav/freshclam.conf || die

			if use milter ; then
				# Note: only keep the "unix" ClamdSocket and MilterSocket!
				sed -e "s:^\(Example\):\# \1:" \
					-e "s:^\#\(PidFile\) .*:\1 ${EPREFIX}/run/clamav-milter.pid:" \
					-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
					-e "s/^#\(User .*\)/\1/" \
					-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
					"${ED}"/etc/clamav/clamav-milter.conf.sample > \
					"${ED}"/etc/clamav/clamav-milter.conf || die

				systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" clamav-milter.service
			fi

			local i
			for i in clamd freshclam clamav-milter
			do
				if [[ -f "${ED}"/etc/"${i}".conf.sample ]] ; then
					mv "${ED}"/etc/"${i}".conf{.sample,} || die
				fi
			done

			# These both need to be writable by the clamav user
			# TODO: use syslog by default; that's what it's for.
			diropts -o clamav -g clamav
			keepdir /var/lib/clamav
			keepdir /var/log/clamav
		fi
	fi

	if use doc ; then
		local HTML_DOCS=( docs/html/. )
		einstalldocs
	fi

	# Don't install man pages for utilities we didn't install
	if use libclamav-only ; then
		rm -r "${ED}"/usr/share/man || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process clamav-r1.conf
		fi
	fi

	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi

	local databases=( "${EROOT}"/var/lib/clamav/main.c[lv]d )
	if [[ ! -f "${databases}" ]] ; then
		ewarn "You must run freshclam manually to populate the virus database"
		ewarn "before starting clamav for the first time."
	fi

	if ! systemd_is_booted ; then
		ewarn "This version of ClamAV provides separate OpenRC services"
		ewarn "for clamd, freshclam, clamav-milter, and clamonacc. The"
		ewarn "clamd service now starts only the clamd daemon itself. You"
		ewarn "should add freshclam (and perhaps clamav-milter) to any"
		ewarn "runlevels that previously contained clamd."
	else
		if ver_replacing -le 1.3.1; then
			ewarn "From 1.3.1-r1 the Gentoo-provided systemd services have been"
			ewarn "Retired in favour of using the units shipped by upstream."
			ewarn "Ensure that any required services are configured and started."
			ewarn "clamd@.service has been retired as part of this transition."
		fi
	fi

	if [[ -z ${REPLACING_VERSIONS} ]] && use clamonacc; then
		einfo "'clamonacc' requires additional configuration before it"
		einfo "can be enabled, and may not produce any output if not properly"
		einfo "configured. Read the appropriate man page if clamonacc is desired."
	fi

}
