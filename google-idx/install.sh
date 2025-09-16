#!/usr/bin/env sh

PORT="${PORT:-8080}"
UUID="${UUID:-2584b733-9095-4bec-a7d5-62b473540f7a}"

# 1. 初始化目录
mkdir -p app/xray
cd app/xray

# 2. 下载并解压 Xray
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip Xray-linux-64.zip
rm -f Xray-linux-64.zip

# 3. 添加配置文件
wget -O config.json https://raw.githubusercontent.com/duduskying/one-node/refs/heads/main/google-idx/xray-config-template.json
sed -i 's/$PORT/'$PORT'/g' config.json
sed -i 's/$UUID/'$UUID'/g' config.json

# 4. 创建启动脚本
wget https://raw.githubusercontent.com/duduskying/one-node/refs/heads/main/google-idx/startup.sh
sed -i 's#$PWD#'$PWD'#g' startup.sh
chmod +x startup.sh

# 5. 启动 Xray
$PWD/startup.sh

# 6. 打印节点信息
echo '---------------------------------------------------------------'
echo "vmess://$(echo -n '{\"v\": \"2\", \"ps\": \"idx-vmess-ws\", \"add\": \"your_server_ip\", \"port\": \"$PORT\", \"id\": \"$UUID\", \"aid\": \"0\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"\", \"path\": \"/\", \"tls\": \"none\"}' | base64 -w 0)#idx-vmess-ws"
echo '---------------------------------------------------------------'
