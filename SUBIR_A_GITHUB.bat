@echo off
title Subir WiFi-Hacking-Toolkit a GitHub
color 0A

echo.
echo ============================================================
echo    SUBIR REPOSITORIO A GITHUB
echo ============================================================
echo.

REM Verificar si git está instalado
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git no esta instalado
    echo.
    echo Descarga Git desde: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [OK] Git instalado
echo.

REM Pedir datos
set /p GITHUB_USER="Ingresa tu usuario de GitHub: "
set /p REPO_NAME="Nombre del repo (por defecto WiFi-Hacking-Toolkit): "

if "%REPO_NAME%"=="" set REPO_NAME=WiFi-Hacking-Toolkit

echo.
echo ============================================================
echo PASOS A REALIZAR:
echo.
echo 1. Inicializar repositorio Git
echo 2. Agregar todos los archivos
echo 3. Commit inicial
echo 4. Conectar con GitHub
echo 5. Subir archivos
echo ============================================================
echo.
pause

REM Inicializar repo
echo.
echo [1/5] Inicializando repositorio...
git init
if errorlevel 1 goto error

REM Agregar archivos
echo.
echo [2/5] Agregando archivos...
git add .
if errorlevel 1 goto error

REM Commit
echo.
echo [3/5] Creando commit inicial...
git commit -m "Initial commit - WiFi Hacking Toolkit for Kali Linux"
if errorlevel 1 goto error

REM Renombrar rama a main
echo.
echo [4/5] Configurando rama main...
git branch -M main
if errorlevel 1 goto error

REM Agregar remote
echo.
echo [5/5] Conectando con GitHub...
git remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
if errorlevel 1 (
    echo [WARNING] Remote ya existe o error
    git remote set-url origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
)

echo.
echo ============================================================
echo    CONFIGURACION COMPLETA
echo ============================================================
echo.
echo IMPORTANTE: Antes de continuar, crea el repositorio en GitHub:
echo.
echo 1. Ve a https://github.com
echo 2. Click en "+" ^> "New repository"
echo 3. Nombre: %REPO_NAME%
echo 4. Descripcion: Professional WiFi auditing toolkit for Kali Linux
echo 5. NO marques "Initialize with README"
echo 6. Create repository
echo.
pause

REM Push
echo.
echo [*] Subiendo archivos a GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo [ERROR] No se pudo subir. Posibles causas:
    echo  - El repositorio no existe en GitHub
    echo  - Credenciales incorrectas
    echo  - Sin permisos
    echo.
    echo Solucion:
    echo 1. Verifica que el repo este creado en GitHub
    echo 2. Usa "git push -u origin main" manualmente
    goto error
)

echo.
echo ============================================================
echo    SUBIDA EXITOSA!
echo ============================================================
echo.
echo Tu repositorio esta en:
echo https://github.com/%GITHUB_USER%/%REPO_NAME%
echo.
echo Para clonarlo en Kali:
echo git clone https://github.com/%GITHUB_USER%/%REPO_NAME%.git
echo.
pause
exit /b 0

:error
echo.
echo [ERROR] Algo salio mal
echo.
echo Ejecuta manualmente:
echo   git init
echo   git add .
echo   git commit -m "Initial commit"
echo   git branch -M main
echo   git remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
echo   git push -u origin main
echo.
pause
exit /b 1
