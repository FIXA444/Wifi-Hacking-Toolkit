#!/bin/bash
# Evil Twin Attack usando Fluxion

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
FLUXION_DIR="$SCRIPT_DIR/fluxion"
LOG_FILE="$SCRIPT_DIR/logs/evil_twin_$(date +%Y%m%d_%H%M%S).log"

clear
echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                 EVIL TWIN ATTACK (FLUXION)                   ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Descripción:${NC}"
echo "  • Crea un AP falso idéntico al objetivo"
echo "  • Desconecta usuarios del AP real"
echo "  • Portal cautivo captura contraseña"
echo "  • ${GREEN}90% tasa de éxito${NC}"
echo "  • ${GREEN}NO requiere wordlist${NC}"
echo ""

if [ ! -d "$FLUXION_DIR" ]; then
    echo -e "${RED}[!] Fluxion no encontrado${NC}"
    echo -e "${YELLOW}[*] Ejecuta: sudo ./install.sh${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Iniciando Fluxion...${NC}"
echo -e "${CYAN}[*] Log guardado en: $LOG_FILE${NC}"
echo ""
sleep 2

cd "$FLUXION_DIR"
./fluxion.sh 2>&1 | tee "$LOG_FILE"

echo ""
echo -e "${GREEN}[✓] Ataque finalizado${NC}"
echo -e "${CYAN}[*] Revisa el log: $LOG_FILE${NC}"
read -p "Presiona Enter para continuar..."
