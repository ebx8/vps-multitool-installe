
#!/bin/bash
# -----------------------------------------
# Instalador Avanzado BADVPN-UDPGW (Github)
# -----------------------------------------

set -e

echo ""
echo "=====> Instalando dependencias..."
apt update -y
apt install -y build-essential cmake pkg-config git ufw

echo ""
echo "=====> Limpiando instalaciones previas..."
systemctl stop badvpn-udpgw 2>/dev/null || true
systemctl disable badvpn-udpgw 2>/dev/null || true
rm -rf /usr/bin/badvpn-udpgw /etc/systemd/system/badvpn-udpgw.service ~/badvpn

echo ""
echo "=====> Descargando código BADVPN desde Github..."
cd ~
git clone https://github.com/ambrop72/badvpn.git
cd badvpn
mkdir -p build
cd build

echo ""
echo "=====> Compilando sólo BADVPN-UDPGW..."
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make

echo ""
echo "=====> Instalando el binario..."
cp udpgw/badvpn-udpgw /usr/bin/
chmod +x /usr/bin/badvpn-udpgw

echo ""
echo "=====> Creando servicio systemd..."
cat >/etc/systemd/system/badvpn-udpgw.service <<EOF
[Unit]
Description=BADVPN UDPGW Service
After=network.target

[Service]
ExecStart=/usr/bin/badvpn-udpgw --listen-addr 0.0.0.0:7300 --max-clients 2048 --max-connections-for-client 256
Restart=always
User=nobody
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

echo ""
echo "=====> Activando y arrancando el servicio..."
systemctl daemon-reload
systemctl enable badvpn-udpgw
systemctl restart badvpn-udpgw

# Abrir puerto con UFW (opcional, si existe)
if command -v ufw >/dev/null 2>&1; then
    ufw allow 7300/tcp || true
fi

echo ""
echo "--------------------------------------"
echo " BADVPN-UDPGW instalado y ejecutándose"
echo " Puerto UDPGW: 7300 (0.0.0.0:7300)"
echo " Compatible con HTTP Injector/Juegos"
echo " Verifica con: systemctl status badvpn-udpgw"
echo "--------------------------------------"

systemctl status badvpn-udpgw --no-pager
