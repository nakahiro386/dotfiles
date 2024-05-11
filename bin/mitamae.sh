#!/usr/bin/env bash
set -e

bin_dir=$(cd "$(dirname $0)" && pwd)
mitamae_version='1.14.1'
mitamae_bin="${bin_dir}/mitamae-x86_64-linux-${mitamae_version}"
mitamae_sha256='ce5d10e2fde981707067da454aa845df02bdbcfba1ea2cba46b0ff1412f20016'

if [ ! -e "${mitamae_bin}" ]; then
    wget -q -O "${mitamae_bin}" https://github.com/itamae-kitchen/mitamae/releases/download/v${mitamae_version}/mitamae-x86_64-linux
    chmod +x "${mitamae_bin}"
fi

if ! echo "${mitamae_sha256} *${mitamae_bin}" | sha256sum --quiet --status -c; then
    echo "checksum verificatoin failed!"
    exit 1
fi

${mitamae_bin} $@
