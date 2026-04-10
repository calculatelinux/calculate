# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
DESCRIPTION="Grafana Alloy: A modern distribution of the OpenTelemetry Collector"
HOMEPAGE="https://github.com/grafana/alloy"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

SRC_URI="https://github.com/grafana/alloy/releases/download/v${PV}/alloy-linux-amd64.zip -> ${P}.zip"
S="${WORKDIR}"

src_unpack() {
	unpack "${P}.zip"
}

src_install() {
	mkdir -p "${ED}/opt/grafana-alloy/bin" || die "Failed to create bin directory"
	exeinto "/opt/grafana-alloy/bin"
	doexe "${S}/alloy-linux-amd64"
	mv "${ED}/opt/grafana-alloy/bin/alloy-linux-amd64" "${ED}/opt/grafana-alloy/bin/alloy" || die "Failed to rename installed binary"

	insinto /etc/grafana-alloy
	newins "${FILESDIR}/config.alloy" config.alloy || die "Failed to install config file"

	newinitd "${FILESDIR}/grafana-alloy.init" grafana-alloy || die "Failed to install init script"
}

pkg_postinst() {
	elog "The default Grafana Alloy configuration has been installed to /etc/grafana-alloy/config.alloy."
	elog "Please edit this file to configure data collection."

	einfo "Creating data storage directory /var/lib/grafana-alloy..."
	mkdir -p /var/lib/grafana-alloy || die "Failed to create data directory"

	elog "To enable the service to start at boot, run:"
	elog "  # rc-update add grafana-alloy default"
	elog "To start the service now, run:"
	elog "  # rc-service grafana-alloy start"
}
