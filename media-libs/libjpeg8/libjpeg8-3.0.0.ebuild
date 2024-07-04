# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: This is a version of `media-libs/libjpeg-turbo-3.0.0::gentoo` with slot and dependencies edits

EAPI=8

inherit cmake

MY_P=libjpeg-turbo

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${MY_P}/${MY_P}-${PV}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_arm_neon"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"
DEPEND=""
RDEPEND=""
BDEPEND="
	amd64? ( ${ASM_DEPEND} )
"

S=${WORKDIR}/${MY_P}-${PV}

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

src_configure() {

	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCMAKE_SKIP_RPATH=YES
		-DENABLE_STATIC=OFF
		-DWITH_JAVA=OFF
		-DWITH_JPEG8=1
	)

	# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON, bug #792810
	if use arm || use arm64; then
		mycmakeargs+=(
			-DWITH_SIMD=$(usex cpu_flags_arm_neon)
			-DNEON_INTRINSICS=$(usex cpu_flags_arm_neon)
		)
	fi

	# We should tell the test suite which floating-point flavor we are
	# expecting: https://github.com/libjpeg-turbo/libjpeg-turbo/issues/597
	# For now, mark loong as fp-contract.
	if use loong; then
		mycmakeargs+=(
			-DFLOATTEST=fp-contract
		)
	fi

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

src_install() {
	dolib.so "${WORKDIR}/libjpeg-turbo-${PV}_build/libjpeg.so.8.3.2"
	dosym libjpeg.so.8.3.2 /usr/$(get_libdir)/libjpeg.so.8
}
