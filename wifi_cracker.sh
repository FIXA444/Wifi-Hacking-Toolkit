#!/bin/bash
#
# WiFi Hacking Toolkit - Script Principal
# Autor: Jason's Cybersecurity Tools
# Descripción: Suite completa para auditoría WiFi
#

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Directorio base
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
LOGS_DIR="$SCRIPT_DIR/logs"
WORDLISTS_DIR="$SCRIPT_DIR/wordlists"

# Crear directorios si no existen
mkdir -p "$LOGS_DIR"
mkdir -p "$WORDLISTS_DIR"

# Banner
show_banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          ██╗    ██╗██╗███████╗██╗                           ║
║          ██║    ██║██║██╔════╝██║                           ║
║          ██║ █╗ ██║██║█████╗  ██║                           ║
║          ██║███╗██║██║██╔══╝  ██║                           ║
║          ╚███╔███╔╝██║██║     ██║                           ║
║           ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝                           ║
║                                                              ║
║        HACKING TOOLKIT - Auditoría de Seguridad WiFi        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}        [ Pentesting Tool - Educational Use Only ]${NC}"
    echo ""
}

# Verificar root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Este script debe ejecutarse como root${NC}"
        echo -e "${YELLOW}[*] Usa: sudo ./wifi_cracker.sh${NC}"
        exit 1
    fi
}

# Verificar instalación
check_installation() {
    # Verificar que existen los scripts
    if [ ! -f "$SCRIPTS_DIR/evil_twin.sh" ]; then
        echo -e "${YELLOW}[!] Scripts no encontrados en: $SCRIPTS_DIR${NC}"
        echo -e "${CYAN}[*] Asegúrate de estar en la carpeta correcta${NC}"
        echo -e "${CYAN}[*] Ejecuta: cd ~/WiFi-Hacking-Toolkit${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    # Dar permisos si no los tienen
    chmod +x "$SCRIPTS_DIR"/*.sh 2>/dev/null
}

# Menú principal
show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${YELLOW}MENÚ PRINCIPAL${NC}                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}[1]${NC} Evil Twin Attack ${YELLOW}(Fluxion)${NC}       ${MAGENTA}★ 90% Éxito${NC}"
    echo -e "    └─ Portal cautivo, sin wordlist, 5-10 min"
    echo ""
    echo -e "${GREEN}[2]${NC} PMKID Attack ${YELLOW}(hcxdumptool)${NC}      ${MAGENTA}★ Sin clientes${NC}"
    echo -e "    └─ GPU cracking, requiere wordlist"
    echo ""
    echo -e "${GREEN}[3]${NC} Handshake Clásico ${YELLOW}(aircrack)${NC}    ${MAGENTA}★ Tradicional${NC}"
    echo -e "    └─ Captura handshake, requiere wordlist"
    echo ""
    echo -e "${GREEN}[4]${NC} Wifite Automático                ${MAGENTA}★ Todo en uno${NC}"
    echo -e "    └─ Detecta mejor método automáticamente"
    echo ""
    echo -e "${GREEN}[5]${NC} WPS Pixie Dust Attack"
    echo -e "    └─ Explota vulnerabilidad WPS"
    echo ""
    echo -e "${CYAN}───────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${GREEN}[6]${NC} Ver redes WiFi disponibles"
    echo -e "${GREEN}[7]${NC} Verificar adaptador WiFi"
    echo -e "${GREEN}[8]${NC} Descargar wordlists"
    echo -e "${GREEN}[9]${NC} Ver logs de ataques"
    echo ""
    echo -e "${RED}[0]${NC} Salir"
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Escanear redes
scan_networks() {
    echo -e "${CYAN}[*] Escaneando redes WiFi...${NC}"
    echo ""
    
    # Detectar interfaz
    interface=$(iw dev | grep Interface | awk '{print $2}' | head -1)
    
    if [ -z "$interface" ]; then
        echo -e "${RED}[!] No se detectó interfaz WiFi${NC}"
        return
    fi
    
    echo -e "${GREEN}[✓] Interfaz detectada: $interface${NC}"
    echo ""
    
    # Escanear
    nmcli dev wifi list 2>/dev/null || iwlist $interface scan | grep -E "ESSID|Quality|Encryption"
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Verificar adaptador
check_adapter() {
    echo -e "${CYAN}[*] Verificando adaptador WiFi...${NC}"
    echo ""
    
    # Listar interfaces
    echo -e "${YELLOW}Interfaces detectadas:${NC}"
    iw dev
    echo ""
    
    # Verificar modo monitor
    echo -e "${YELLOW}Verificando soporte modo monitor:${NC}"
    iw list | grep "Supported interface modes" -A 8
    echo ""
    
    # Test modo monitor
    interface=$(iw dev | grep Interface | awk '{print $2}' | head -1)
    if [ ! -z "$interface" ]; then
        echo -e "${CYAN}[*] Probando modo monitor en $interface...${NC}"
        airmon-ng start $interface 2>&1 | tail -5
        sleep 2
        airmon-ng stop ${interface}mon 2>&1 | tail -3
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Descargar wordlists
download_wordlists() {
    echo -e "${CYAN}[*] Descargando wordlists...${NC}"
    echo ""
    
    # RockYou
    if [ ! -f "$WORDLISTS_DIR/rockyou.txt" ]; then
        echo -e "${YELLOW}[*] Descargando rockyou.txt (143 MB)...${NC}"
        wget -q --show-progress -O "$WORDLISTS_DIR/rockyou.txt" \
            "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓] rockyou.txt descargado${NC}"
        fi
    else
        echo -e "${GREEN}[✓] rockyou.txt ya existe${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Wordlists disponibles en: $WORDLISTS_DIR${NC}"
    ls -lh "$WORDLISTS_DIR"
    echo ""
    
    read -p "Presiona Enter para continuar..."
}

# Ver logs
view_logs() {
    echo -e "${CYAN}[*] Logs de ataques:${NC}"
    echo ""
    
    if [ "$(ls -A $LOGS_DIR)" ]; then
        ls -lht "$LOGS_DIR" | head -20
        echo ""
        read -p "¿Ver log específico? (nombre o Enter para salir): " logfile
        
        if [ ! -z "$logfile" ] && [ -f "$LOGS_DIR/$logfile" ]; then
            less "$LOGS_DIR/$logfile"
        fi
    else
        echo -e "${YELLOW}[*] No hay logs disponibles${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Main
main() {
    check_root
    show_banner
    check_installation
    
    while true; do
        show_banner
        show_menu
        
        read -p "Selecciona opción [0-9]: " option
        
        case $option in
            1)
                if [ -f "$SCRIPTS_DIR/evil_twin.sh" ]; then
                    bash "$SCRIPTS_DIR/evil_twin.sh"
                else
                    echo -e "${RED}[!] Script no encontrado: $SCRIPTS_DIR/evil_twin.sh${NC}"
                    read -p "Presiona Enter..."
                fi
                ;;
            2)
                if [ -f "$SCRIPTS_DIR/pmkid_attack.sh" ]; then
                    bash "$SCRIPTS_DIR/pmkid_attack.sh"
                else
                    echo -e "${RED}[!] Script no encontrado: $SCRIPTS_DIR/pmkid_attack.sh${NC}"
                    read -p "Presiona Enter..."
                fi
                ;;
            3)
                if [ -f "$SCRIPTS_DIR/handshake_attack.sh" ]; then
                    bash "$SCRIPTS_DIR/handshake_attack.sh"
                else
                    echo -e "${RED}[!] Script no encontrado: $SCRIPTS_DIR/handshake_attack.sh${NC}"
                    read -p "Presiona Enter..."
                fi
                ;;
            4)
                if [ -f "$SCRIPTS_DIR/wifite_auto.sh" ]; then
                    bash "$SCRIPTS_DIR/wifite_auto.sh"
                else
                    echo -e "${RED}[!] Script no encontrado: $SCRIPTS_DIR/wifite_auto.sh${NC}"
                    read -p "Presiona Enter..."
                fi
                ;;
            5)
                if [ -f "$SCRIPTS_DIR/wps_attack.sh" ]; then
                    bash "$SCRIPTS_DIR/wps_attack.sh"
                else
                    echo -e "${RED}[!] Script no encontrado: $SCRIPTS_DIR/wps_attack.sh${NC}"
                    read -p "Presiona Enter..."
                fi
                ;;
            6)
                scan_networks
                ;;
            7)
                check_adapter
                ;;
            8)
                download_wordlists
                ;;
            9)
                view_logs
                ;;
            0)
                echo -e "${GREEN}[✓] Saliendo...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Opción inválida${NC}"
                sleep 2
                ;;
        esac
    done
}

# Ejecutar
main
