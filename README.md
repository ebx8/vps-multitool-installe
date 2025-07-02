# BADVPN-UDPGW Installer - EBX8 Edition

Instalador automático avanzado para BADVPN-UDPGW (protocolo compatible con HTTP Injector, juegos, tun2socks, etc).

## Características

- Descarga y compila el código oficial de BADVPN desde GitHub.
- Instala solo el módulo udpgw (UDP Gateway).
- Crea un servicio systemd para que se ejecute siempre.
- Abre el puerto 7300/tcp en el firewall (UFW).
- Limpia instalaciones previas automáticamente.
- 100% compatible con HTTP Injector y juegos móviles.

## Instalación rápida

```bash
wget -O install-badvpn.sh https://raw.githubusercontent.com/ebx8/BADVPN-ebx/main/install-badvpn.sh
chmod +x install-badvpn.sh
./install-badvpn.sh




##Verifica el estado
systemctl status badvpn-udpgw
ss -tulpn | grep 7300
