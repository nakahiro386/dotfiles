#!/usr/bin/env bash
set -e

bin_dir=$(cd "$(dirname $0)" && pwd)
mitamae_version='1.12.10'
mitamae_bin="${bin_dir}/mitamae-x86_64-linux-${mitamae_version}"
mitamae_sha256='c174931e3d6265ce2f266d80271c1f2b182354d4d75f3c5f849b167d6bc7a505'
mitamae_sha256_file="${bin_dir}/mitamae.sha256"

if [ ! -e "${mitamae_bin}" ]; then
    wget -q -O "${mitamae_bin}" https://github.com/itamae-kitchen/mitamae/releases/download/v${mitamae_version}/mitamae-x86_64-linux
    chmod +x "${mitamae_bin}"
    echo "${mitamae_sha256} *${mitamae_bin}" > ${mitamae_sha256_file}
fi

if ! sha256sum --quiet --status -c ${mitamae_sha256_file}; then
    echo "checksum verificatoin failed!"
    exit 1
fi

${mitamae_bin} $@
