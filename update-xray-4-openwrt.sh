#/bin/bash
#update-xray

#openwrt版
wget -O /tmp/xray.tar.gz https://github.com/felix-fly/xray-openwrt/releases/latest/download/xray-linux-amd64.tar.gz
#AMD64版
#wget -O /tmp/xray.tar.gz https://github.com/XTLS/Xray-core/releases/latest/download/xray-linux-amd64.tar.gz
tar -xzvf xray.tar.gz
#unzip xray.zip /usr/bin/
chmod 755 /usr/bin/xray
