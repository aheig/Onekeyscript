#/bin/bash
#update-xray

#openwrt版
wget -O /tmp/xray.tar.gz https://github.com/felix-fly/xray-openwrt/releases/latest/download/xray-linux-amd64.tar.gz
tar -xzvf /tmp/xray.tar.gz
rm -rf /tmp/xray.tar.gz
mv xray /usr/bin/xray
#AMD64版
#wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/xray-linux-64.zip
#unzip xray.zip /usr/bin/
#rm -rf /tmp/xray.zip
chmod 755 /usr/bin/xray
