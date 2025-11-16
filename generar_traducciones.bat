@echo off
echo ========================================
echo Generando archivos de traduccion...
echo ========================================
echo.

echo Buscando Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Flutter no esta en el PATH
    echo.
    echo Por favor ejecuta estos comandos desde:
    echo 1. Terminal de Android Studio
    echo 2. Terminal de VS Code
    echo 3. CMD donde Flutter este configurado
    echo.
    echo Comandos a ejecutar:
    echo   flutter pub get
    echo   flutter gen-l10n
    echo   flutter run
    echo.
    pause
    exit /b 1
)

echo [1/2] Obteniendo dependencias...
call flutter pub get

echo.
echo [2/2] Generando localizaciones...
call flutter gen-l10n

echo.
echo ========================================
echo Traducciones generadas exitosamente!
echo ========================================
echo.
echo Ahora puedes ejecutar: flutter run
pause
