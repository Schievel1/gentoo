# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.7.20
	annotate-snippets@0.9.1
	bitflags@1.3.2
	bitflags@2.2.1
	block@0.1.6
	cc@1.0.78
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.4.0
	clap@4.1.4
	clap_complete@4.2.0
	clap_derive@4.1.0
	clap_lex@0.3.1
	either@1.8.1
	env_logger@0.10.0
	env_logger@0.8.4
	errno-dragonfly@0.1.2
	errno@0.3.1
	fastrand@1.8.0
	getrandom@0.2.8
	glob@0.3.1
	heck@0.4.0
	hermit-abi@0.3.2
	humantime@2.1.0
	instant@0.1.12
	io-lifetimes@1.0.4
	is-terminal@0.4.7
	itertools@0.12.1
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.139
	libloading@0.7.4
	linux-raw-sys@0.1.4
	linux-raw-sys@0.3.8
	log@0.4.17
	malloc_buf@0.0.6
	memchr@2.5.0
	minimal-lexical@0.2.1
	nom@7.1.3
	objc@0.2.7
	once_cell@1.17.0
	os_str_bytes@6.4.1
	owo-colors@3.5.0
	prettyplease@0.2.7
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.60
	quickcheck@1.0.3
	quote@1.0.28
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.2.16
	regex-syntax@0.6.28
	regex@1.7.1
	rustc-hash@1.1.0
	rustix@0.36.16
	rustix@0.37.3
	shlex@1.3.0
	similar@2.2.1
	strsim@0.10.0
	syn@1.0.107
	syn@2.0.18
	tempfile@3.4.0
	termcolor@1.2.0
	unicode-ident@1.0.6
	unicode-width@0.1.10
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	which@4.4.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	yansi-term@0.1.2
"

inherit rust-toolchain cargo

DESCRIPTION="Automatically generates Rust FFI bindings to C and C++ libraries."
HOMEPAGE="https://rust-lang.github.io/rust-bindgen/"
SRC_URI="https://github.com/rust-lang/rust-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/rust-${P}

LICENSE="BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"

DEPEND="${RUST_DEPEND}"
RDEPEND="${DEPEND}
	llvm-core/clang:*"

QA_FLAGS_IGNORED="usr/bin/bindgen"

src_test () {
	# required by clang during tests
	local -x TARGET=$(rust_abi)

	cargo_src_test --bins --lib
}

src_install () {
	cargo_src_install --path "${S}/bindgen-cli"

	einstalldocs
}
