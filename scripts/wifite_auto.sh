#!/bin/bash
# Wifite - Ataque completamente automatizado

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                   WIFITE AUTOMÁTICO                          ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Descripción:${NC}"
echo "  • Herramienta TODO EN UNO"
echo "  • Detecta automáticamente mejor método"
echo "  • Ataca WPA, WPA2, WPS, WEP"
echo "  • ${GREEN}Completamente automatizado${NC}"
echo ""

if ! command -v wifite &>/dev/null; then
    echo -e "${RED}[!] wifite no instalado${NC}"
    echo -e "${YELLOW}[*] Ejecuta: sudo ./install.sh${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Instrucciones:${NC}"
echo "  1. Wifite escaneará redes automáticamente"
echo "  2. Presiona Ctrl+C cuando veas tu objetivo"
echo "  3. Ingresa el número de la red"
echo "  4. Wifite atacará automáticamente"
echo ""
echo -e "${CYAN}[*] Iniciando Wifite...${NC}"
echo ""
sleep 3

wifite --kill

echo ""
read -p "Presiona Enter para continuar..."
