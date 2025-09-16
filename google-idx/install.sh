#!/usr/bin/env sh

PORT="${PORT:-443}"
UUID="${UUID:-2584b733-9095-4bec-a7d5-62b473540f7a}"
PRIVATE_KEY="KN0QU1GAbmFAI80ACtxYZkiWELNSobaxxbH7tB11FD4"
PUBLIC_KEY="pxABKc0tXE3aGvIntvIn2u2JfecUrENUeaRJqukoqQI"
SNI="time.is"

# 1. init directory
mkdir -p app/xray
cd app/xray

# 2. download and extract Xray
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip Xray-linux-64.zip
rm -f Xray-linux-64.zip

# 3. add config file (using local template with fixed shortIds, or download and replace)
# Assuming you save the above template as xray-config-template.json in the same dir
wget -O config.json https://raw.githubusercontent.com/duduskying/one-node/refs/heads/main/google-idx/xray-config-template.json
sed -i 's/$PORT/'$PORT'/g' config.json
sed -i 's/$UUID/'$UUID'/g' config.json
sed -i 's/$PRIVATE_KEY/'$PRIVATE_KEY'/g' config.json
sed -i 's/$SNI/'$SNI'/g' config.json

# 4. create startup.sh
wget https://raw.githubusercontent.com/duduskying/one-node/refs/heads/main/google-idx/startup.sh
sed -i 's#$PWD#'$PWD'#g' startup.sh
chmod +x startup.sh

# 5. start Xray
$PWD/startup.sh

# 6. print node info
echo '---------------------------------------------------------------'
echo "vless://$UUID@example.domain.com:$PORT?type=tcp&encryption=none&flow=xtls-rprx-vision&security=reality&pbk=$PUBLIC_KEY&fp=chrome&sni=$SNI#idx-reality-vision"
echo '---------------------------------------------------------------'
echo "Generated shortIds (for reference, if needed in client):"
echo "5ecabccf64e7cbf1, 006b6e109ce652e2, 898bdda8de4abec8, 0bb5c753ced6badd"
