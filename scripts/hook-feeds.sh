#!/bin/bash
# Svn checkout packages from immortalwrt's repository
pushd customfeeds

# Add luci-proto-modemmanager
svn co https://github.com/immortalwrt/luci/trunk/protocols/luci-proto-modemmanager luci/protocols/luci-proto-modemmanager

# Add tmate
git clone --depth=1 https://github.com/immortalwrt/openwrt-tmate

# Add minieap
rm -rf packages/net/minieap
svn co https://github.com/immortalwrt/packages/trunk/net/minieap packages/net/minieap

# Replace smartdns with the official version
rm -rf packages/net/smartdns
svn co https://github.com/openwrt/packages/trunk/net/smartdns packages/net/smartdns
popd

# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
