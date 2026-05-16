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

:: Actualizar version del cache en sw.js para forzar actualizacion en celulares
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
set VERSION=%dt:~0,12%
powershell -Command "$content = Get-Content 'sw.js' -Raw; $content = $content -replace \"const CACHE = 'migasto-v[^']*';\", \"const CACHE = 'migasto-v%VERSION%';\"; Set-Content 'sw.js' $content -NoNewline"
echo Cache version actualizada: migasto-v%VERSION%

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
echo.
echo  En el celular: desliza para
echo  refrescar y veran los cambios.
echo ================================
echo.
pause
