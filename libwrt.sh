sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls}
rm -rf package/passwall-packages
rm -rf package/luci-app-passwall2
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall2 package/luci-app-passwall2

# 应用 LibWrt 仓库自带的 feeds-overrides，把 packages feed 的 Go 默认版本升到 1.27。
# 原因：xray-core 26.9.30 的 go.mod 声明 go >= 1.27，而上游 immortalwrt/packages
# 的 GO_DEFAULT_VERSION 还是 1.26，直接编会失败。
# 注意顺序：feeds 已由 workflow 的 "Install Feeds" 步骤 update 过，这里补丁 + install 即可，
# 这样新增的 golang1.27 才会被链接进 package/ 并被 make 识别。
if [ -x ./feeds-overrides/apply.sh ]; then
  ./feeds-overrides/apply.sh
  ./scripts/feeds install -a
fi
