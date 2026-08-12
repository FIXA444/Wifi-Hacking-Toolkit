# 🔥 WiFi Hacking Toolkit

**Herramienta profesional para auditoría de seguridad WiFi en Kali Linux**

[![Kali Linux](https://img.shields.io/badge/Platform-Kali%20Linux-blue)](https://www.kali.org/)
[![License](https://img.shields.io/badge/License-Educational-red)](LICENSE)
[![Bash](https://img.shields.io/badge/Language-Bash-green)](https://www.gnu.org/software/bash/)

---

## 📋 Descripción

Suite completa de herramientas automatizadas para auditoría de seguridad WiFi. Incluye 5 métodos de ataque diferentes con instalación automática de dependencias.

### ⚡ Métodos de Ataque Incluidos:

1. **Evil Twin Attack (Fluxion)** ⭐ 90% tasa de éxito
   - Sin wordlist necesario
   - Portal cautivo automático
   - Usuario entrega la contraseña voluntariamente

2. **PMKID Attack**
   - Sin clientes conectados necesarios
   - Crackeo con GPU (Hashcat)
   - Más rápido que handshake tradicional

3. **Handshake Clásico (Aircrack-ng)**
   - Método tradicional probado
   - Compatible con cualquier red WPA/WPA2
   - Requiere clientes conectados

4. **Wifite Automático**
   - Todo en uno
   - Detecta automáticamente el mejor método
   - Ataque completamente automatizado

5. **WPS Pixie Dust**
   - Explota vulnerabilidad WPS
   - Sin wordlist
   - Funciona en routers vulnerables

---

## 🚀 Instalación Rápida

```bash
# Clonar repositorio
git clone https://github.com/TU_USUARIO/WiFi-Hacking-Toolkit.git
cd WiFi-Hacking-Toolkit

# Dar permisos
chmod +x install.sh
chmod +x wifi_cracker.sh

# Instalar herramientas (primera vez)
sudo ./install.sh

# Ejecutar
sudo ./wifi_cracker.sh
```

---

## 📖 Uso

### Método 1: Script Interactivo

```bash
sudo ./wifi_cracker.sh
```

El script mostrará un menú con todas las opciones disponibles.

### Método 2: Comandos Directos

```bash
# Evil Twin Attack
sudo ./scripts/evil_twin.sh

# PMKID Attack
sudo ./scripts/pmkid_attack.sh

# Handshake Clásico
sudo ./scripts/handshake_attack.sh

# Wifite
sudo ./scripts/wifite_auto.sh
```

---

## 🛠️ Requisitos

### Sistema Operativo
- **Kali Linux** (recomendado)
- Parrot Security OS
- BlackArch
- Cualquier distro con kernel compatible

### Hardware
- Adaptador WiFi con soporte modo monitor
- Recomendado: Alfa AWUS036ACH, TP-Link TL-WN722N v1

### Software (se instala automáticamente)
- aircrack-ng
- hcxdumptool + hcxtools
- hashcat
- wifite
- fluxion
- Wordlist rockyou.txt

---

## 📊 Comparación de Métodos

| Método          | Éxito | Tiempo    | Wordlist | Dificultad | GPU |
|-----------------|-------|-----------|----------|------------|-----|
| Evil Twin       | 90%   | 5-10 min  | ❌       | Fácil      | ❌  |
| PMKID           | 70%   | 10-60 min | ✅       | Media      | ✅  |
| Handshake       | 80%   | 15-120min | ✅       | Media      | ❌  |
| Wifite          | 75%   | Variable  | ✅       | Fácil      | ❌  |
| WPS Pixie Dust  | 50%   | 5-30 min  | ❌       | Fácil      | ❌  |

---

## 🎯 Características

✅ **Instalación automática** de todas las dependencias  
✅ **Menú interactivo** fácil de usar  
✅ **5 métodos de ataque** diferentes  
✅ **Sin wordlist** (Evil Twin, WPS)  
✅ **Soporte GPU** para crackeo rápido  
✅ **Scripts modulares** para cada método  
✅ **Detección automática** de interfaces WiFi  
✅ **Logs detallados** de cada ataque  
✅ **Restauración automática** de modo normal  

---

## 📁 Estructura del Proyecto

```
WiFi-Hacking-Toolkit/
│
├── wifi_cracker.sh          # Script principal
├── install.sh               # Instalador de herramientas
├── README.md                # Este archivo
├── LICENSE                  # Licencia
│
├── scripts/
│   ├── evil_twin.sh         # Evil Twin Attack
│   ├── pmkid_attack.sh      # PMKID Attack
│   ├── handshake_attack.sh  # Handshake clásico
│   ├── wifite_auto.sh       # Wifite automático
│   └── wps_attack.sh        # WPS Pixie Dust
│
├── wordlists/
│   └── common_passwords.txt # Wordlist básico
│
├── docs/
│   ├── INSTALLATION.md      # Guía de instalación
│   ├── USAGE.md             # Guía de uso
│   └── TROUBLESHOOTING.md   # Solución de problemas
│
└── logs/
    └── .gitkeep
```

---

## ⚠️ Advertencia Legal

**Este proyecto es solo para propósitos educativos y auditorías de seguridad autorizadas.**

- ✅ Usar en tus propias redes
- ✅ Usar con permiso explícito por escrito
- ✅ Fines educativos en laboratorio
- ❌ **NO** usar en redes ajenas sin autorización
- ❌ **ILEGAL** en la mayoría de países

**El autor no se hace responsable del mal uso de estas herramientas.**

---

## 🔧 Solución de Problemas

### Mi adaptador WiFi no entra en modo monitor

```bash
# Verificar si tu adaptador soporta modo monitor
iw list | grep "Supported interface modes" -A 8

# Si dice "monitor" estás OK
# Si no, necesitas otro adaptador
```

### No captura handshake

```bash
# Incrementa potencia de transmisión
sudo iwconfig wlan0mon txpower 30

# Acércate más al router
# Espera más tiempo (clientes deben reconectarse)
```

### Hashcat no usa mi GPU

```bash
# Instalar drivers NVIDIA/AMD
sudo apt install ocl-icd-libopencl1 nvidia-driver

# Verificar
hashcat -I
```

---

## 📚 Recursos Adicionales

- [Documentación Aircrack-ng](https://www.aircrack-ng.org/)
- [Hashcat Wiki](https://hashcat.net/wiki/)
- [Fluxion GitHub](https://github.com/FluxionNetwork/fluxion)
- [Kali Linux Docs](https://www.kali.org/docs/)

---

## 🤝 Contribuir

Las contribuciones son bienvenidas:

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-funcion`)
3. Commit tus cambios (`git commit -m 'Agregar nueva función'`)
4. Push a la rama (`git push origin feature/nueva-funcion`)
5. Abre un Pull Request

---

## 📝 Changelog

### v1.0.0 (2024)
- ✅ Lanzamiento inicial
- ✅ 5 métodos de ataque
- ✅ Instalación automática
- ✅ Scripts modulares

---

## 👤 Autor

**Jason's Cybersecurity Tools**

---

## 📄 Licencia

Este proyecto está bajo licencia **Educational Use Only**.

Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## ⭐ Agradecimientos

- Aircrack-ng team
- Hashcat team
- Fluxion Network
- Kali Linux team
- Comunidad de seguridad informática

---

<p align="center">
  <strong>⚡ Hecho con 💀 para la comunidad de hacking ético ⚡</strong>
</p>
