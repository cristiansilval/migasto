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

:: Git
echo.
echo Subiendo a GitHub...
git add -A
git commit -m "%MENSAJE%"
git push

:: Netlify
echo.
echo Publicando en Netlify...
call netlify deploy --dir . --prod

echo.
echo ================================
echo  Listo! App actualizada en:
echo  https://migasto-cristian.netlify.app
echo ================================
echo.
pause
