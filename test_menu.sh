#!/bin/bash
# Test simple del menú

clear
echo "================================="
echo "   TEST MENU - WiFi Hacking"
echo "================================="
echo ""
echo "[1] Test Evil Twin"
echo "[2] Test PMKID"
echo "[3] Test Handshake"
echo "[4] Test Wifite"
echo "[0] Salir"
echo ""
read -p "Opcion: " opt

case $opt in
    1)
        echo ""
        echo "[*] Probando Evil Twin..."
        echo "[*] Script: scripts/evil_twin.sh"
        if [ -f "scripts/evil_twin.sh" ]; then
            echo "[OK] Script encontrado"
            bash scripts/evil_twin.sh
        else
            echo "[ERROR] Script no encontrado"
            ls -la scripts/
        fi
        ;;
    2)
        echo ""
        echo "[*] Probando PMKID..."
        if [ -f "scripts/pmkid_attack.sh" ]; then
            echo "[OK] Script encontrado"
            bash scripts/pmkid_attack.sh
        else
            echo "[ERROR] Script no encontrado"
        fi
        ;;
    3)
        echo ""
        echo "[*] Probando Handshake..."
        if [ -f "scripts/handshake_attack.sh" ]; then
            echo "[OK] Script encontrado"
            bash scripts/handshake_attack.sh
        else
            echo "[ERROR] Script no encontrado"
        fi
        ;;
    4)
        echo ""
        echo "[*] Probando Wifite..."
        if [ -f "scripts/wifite_auto.sh" ]; then
            echo "[OK] Script encontrado"
            bash scripts/wifite_auto.sh
        else
            echo "[ERROR] Script no encontrado"
        fi
        ;;
    0)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opcion invalida"
        ;;
esac

echo ""
read -p "Presiona Enter para continuar..."
