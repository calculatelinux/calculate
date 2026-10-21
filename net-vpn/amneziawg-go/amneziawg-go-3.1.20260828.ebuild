# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

DESCRIPTION="Userspace Go implementation of the AmneziaWG VPN protocol"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-go"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="net-vpn/amneziawg-tools"

CONFIG_CHECK="~TUN"

S="${WORKDIR}/${PN}-${PV}"

EGO_SUM=(
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/goccy/go-yaml v1.17.1"
	"github.com/goccy/go-yaml v1.17.1/go.mod"
	"github.com/golang/protobuf v1.5.3"
	"github.com/golang/protobuf v1.5.3/go.mod"
	"github.com/go-logr/logr v1.2.4"
	"github.com/go-logr/logr v1.2.4/go.mod"
	"github.com/google/btree v1.1.3"
	"github.com/google/btree v1.1.3/go.mod"
	"github.com/google/go-cmp v0.6.0"
	"github.com/google/go-cmp v0.6.0/go.mod"
	"github.com/google/gopacket v1.1.19"
	"github.com/google/gopacket v1.1.19/go.mod"
	"github.com/google/pprof v0.0.0-20211214055906-6f57359322fd"
	"github.com/google/pprof v0.0.0-20211214055906-6f57359322fd/go.mod"
	"github.com/gorilla/websocket v1.5.3"
	"github.com/gorilla/websocket v1.5.3/go.mod"
	"github.com/go-task/slim-sprig v0.0.0-20230315185526-52ccab3ef572"
	"github.com/go-task/slim-sprig v0.0.0-20230315185526-52ccab3ef572/go.mod"
	"github.com/ianlancetaylor/demangle v0.0.0-20210905161508-09a460cdf81d/go.mod"
	"github.com/onsi/ginkgo/v2 v2.12.0"
	"github.com/onsi/ginkgo/v2 v2.12.0/go.mod"
	"github.com/onsi/gomega v1.27.10"
	"github.com/onsi/gomega v1.27.10/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/quic-go/qpack v0.5.1"
	"github.com/quic-go/qpack v0.5.1/go.mod"
	"github.com/quic-go/quic-go v0.48.1"
	"github.com/quic-go/quic-go v0.48.1/go.mod"
	"github.com/riobard/go-bloom v0.0.0-20200614022211-cdc8013cb5b3"
	"github.com/riobard/go-bloom v0.0.0-20200614022211-cdc8013cb5b3/go.mod"
	"github.com/shadowsocks/go-shadowsocks2 v0.1.5"
	"github.com/shadowsocks/go-shadowsocks2 v0.1.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.10.0"
	"github.com/stretchr/testify v1.10.0/go.mod"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/things-go/go-socks5 v0.0.5"
	"github.com/things-go/go-socks5 v0.0.5/go.mod"
	"golang.getoutline.org/sdk v0.0.23"
	"golang.getoutline.org/sdk v0.0.23/go.mod"
	"golang.getoutline.org/sdk/x v0.2.0"
	"golang.getoutline.org/sdk/x v0.2.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20210220033148-5ea612d1eb83/go.mod"
	"golang.org/x/crypto v0.42.0"
	"golang.org/x/crypto v0.42.0/go.mod"
	"golang.org/x/exp v0.0.0-20240506185415-9bf2ced13842"
	"golang.org/x/exp v0.0.0-20240506185415-9bf2ced13842/go.mod"
	"golang.org/x/mobile v0.0.0-20240520174638-fa72addaaa1b"
	"golang.org/x/mobile v0.0.0-20240520174638-fa72addaaa1b/go.mod"
	"golang.org/x/mod v0.28.0"
	"golang.org/x/mod v0.28.0/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.44.0"
	"golang.org/x/net v0.44.0/go.mod"
	"golang.org/x/sync v0.17.0"
	"golang.org/x/sync v0.17.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20211007075335-d3039528d8ac/go.mod"
	"golang.org/x/sys v0.36.0"
	"golang.org/x/sys v0.36.0/go.mod"
	"golang.org/x/term v0.0.0-20201117132131-f5c789dd3221/go.mod"
	"golang.org/x/text v0.29.0"
	"golang.org/x/text v0.29.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/time v0.9.0"
	"golang.org/x/time v0.9.0/go.mod"
	"golang.org/x/tools/go/expect v0.1.1-deprecated"
	"golang.org/x/tools/go/expect v0.1.1-deprecated/go.mod"
	"golang.org/x/tools/go/packages/packagestest v0.1.1-deprecated"
	"golang.org/x/tools/go/packages/packagestest v0.1.1-deprecated/go.mod"
	"golang.org/x/tools v0.37.0"
	"golang.org/x/tools v0.37.0/go.mod"
	"golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2"
	"golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2/go.mod"
	"google.golang.org/protobuf v1.33.0"
	"google.golang.org/protobuf v1.33.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	"go.uber.org/atomic v1.11.0"
	"go.uber.org/atomic v1.11.0/go.mod"
	"go.uber.org/mock v0.4.0"
	"go.uber.org/mock v0.4.0/go.mod"
	"gvisor.dev/gvisor v0.0.0-20231202080848-1f7806d17489"
	"gvisor.dev/gvisor v0.0.0-20231202080848-1f7806d17489/go.mod"
)
_GOMODULE_GOPROXY_BASEURI="https://proxy.golang.org/"
go-module_set_globals
SRC_URI+=" ${EGO_SUM_SRC_URI}"

src_compile() {
	emake amneziawg-go
}

src_install() {
	dobin amneziawg-go
	newinitd "${FILESDIR}/amneziawg-go.initd" amneziawg-go
	newconfd "${FILESDIR}/amneziawg-go.confd" amneziawg-go
	keepdir /etc/amneziawg
	dodoc README.md
}

pkg_postinst() {
	elog "Run one service instance per tunnel interface:"
	elog "    ln -s /etc/init.d/amneziawg-go /etc/init.d/amneziawg-go.wg0"
	elog "Place the tunnel config in /etc/amneziawg/wg0.conf (directory is created by this package), then:"
	elog "    rc-update add amneziawg-go.wg0 default"
	elog "    /etc/init.d/amneziawg-go.wg0 start"
	elog
	elog "With AWG_QUICK=\"yes\" (default) the service also brings the tunnel"
	elog "up via awg-quick(8) once the daemon control socket appears."
	elog "Use a separate awg-quick.<iface> service when AWG_QUICK=\"no\"."
}
