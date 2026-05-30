@echo off
chcp 65001 >nul
title Publicar MiGasto

echo.
echo ================================
echo   PUBLICAR MIGASTO
echo ================================
echo.

cd /d "C:\Users\ASUS\Mi unidad\proyecto-mm\Gastos"

:: Pedir descripcion del cambio
set /p MENSAJE="Que cambiaste? (Enter para continuar): "
if "%MENSAJE%"=="" set MENSAJE=actualizacion

:: Actualizar version del cache usando PowerShell (compatible con Windows 11)
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMddHHmm"') do set VERSION=%%I
powershell -NoProfile -Command "$content = Get-Content 'sw.js' -Raw; $content = $content -replace \"const CACHE = 'migasto-v[^']*';\", \"const CACHE = 'migasto-v%VERSION%';\"; Set-Content 'sw.js' $content -NoNewline"
echo Cache version actualizada: migasto-v%VERSION%

:: Git - con esto solo ya se publica en GitHub Pages
echo.
echo Subiendo a GitHub Pages...
git add -A
git commit -m "%MENSAJE%"
git push

echo.
echo ================================
echo  Listo! App actualizada en:
echo  https://cristiansilval.github.io/migasto/
echo.
echo  En el celular: usa el boton
echo  girar del header para actualizar
echo ================================
echo.
pause
