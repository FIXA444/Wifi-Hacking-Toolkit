#!/bin/bash
#
# WiFi Hacking Toolkit - Instalador
# Instala todas las herramientas necesarias
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           INSTALADOR - WiFi Hacking Toolkit                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verificar root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}[!] Ejecuta como root: sudo ./install.sh${NC}"
    exit 1
fi

# Verificar conexión
echo -e "${CYAN}[*] Verificando conexión a internet...${NC}"
ping -c 1 google.com &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Sin conexión a internet${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] Conexión OK${NC}"
echo ""

# Actualizar sistema
echo -e "${YELLOW}[1/8] Actualizando sistema...${NC}"
apt update -qq && apt upgrade -y -qq
echo -e "${GREEN}[✓] Sistema actualizado${NC}"
echo ""

# Instalar aircrack-ng
echo -e "${YELLOW}[2/8] Instalando aircrack-ng suite...${NC}"
apt install -y aircrack-ng &>/dev/null
echo -e "${GREEN}[✓] aircrack-ng instalado${NC}"
echo ""

# Instalar hcxdumptool + hcxtools
echo -e "${YELLOW}[3/8] Instalando hcxdumptool + hcxtools...${NC}"
apt install -y hcxdumptool hcxtools &>/dev/null
echo -e "${GREEN}[✓] hcx tools instalados${NC}"
echo ""

# Instalar hashcat
echo -e "${YELLOW}[4/8] Instalando hashcat...${NC}"
apt install -y hashcat &>/dev/null
echo -e "${GREEN}[✓] hashcat instalado${NC}"
echo ""

# Instalar wifite
echo -e "${YELLOW}[5/8] Instalando wifite...${NC}"
apt install -y wifite &>/dev/null
echo -e "${GREEN}[✓] wifite instalado${NC}"
echo ""

# Instalar reaver (WPS)
echo -e "${YELLOW}[6/8] Instalando reaver (WPS attack)...${NC}"
apt install -y reaver pixiewps &>/dev/null
echo -e "${GREEN}[✓] reaver instalado${NC}"
echo ""

# Clonar Fluxion
echo -e "${YELLOW}[7/8] Clonando Fluxion...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$SCRIPT_DIR/fluxion" ]; then
    git clone -q https://github.com/FluxionNetwork/fluxion.git "$SCRIPT_DIR/fluxion"
    echo -e "${GREEN}[✓] Fluxion clonado${NC}"
else
    echo -e "${GREEN}[✓] Fluxion ya existe${NC}"
fi
echo ""

# Crear scripts
echo -e "${YELLOW}[8/8] Creando scripts de ataque...${NC}"
mkdir -p "$SCRIPT_DIR/scripts"
mkdir -p "$SCRIPT_DIR/logs"
mkdir -p "$SCRIPT_DIR/wordlists"

# Crear wordlist básico
cat > "$SCRIPT_DIR/wordlists/common_passwords.txt" << 'WORDLIST'
12345678
password
123456789
12345
password123
qwerty
abc123
admin
admin123
root
1234567890
welcome
WORDLIST

echo -e "${GREEN}[✓] Scripts creados${NC}"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}               ${GREEN}✓ INSTALACIÓN COMPLETA${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Herramientas instaladas:${NC}"
echo -e "  ${GREEN}✓${NC} aircrack-ng"
echo -e "  ${GREEN}✓${NC} hcxdumptool + hcxtools"
echo -e "  ${GREEN}✓${NC} hashcat"
echo -e "  ${GREEN}✓${NC} wifite"
echo -e "  ${GREEN}✓${NC} reaver + pixiewps"
echo -e "  ${GREEN}✓${NC} fluxion"
echo ""
echo -e "${CYAN}Ejecuta ahora: ${YELLOW}sudo ./wifi_cracker.sh${NC}"
echo ""
