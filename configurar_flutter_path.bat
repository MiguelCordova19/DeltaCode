@echo off
echo ========================================
echo Configurando Flutter en el PATH
echo ========================================
echo.

set FLUTTER_PATH=E:\Proyectos\Proyecto DeltaCode\flutter\bin

echo Verificando que Flutter existe en: %FLUTTER_PATH%
if not exist "%FLUTTER_PATH%\flutter.bat" (
    echo.
    echo ERROR: No se encontro Flutter en esa ruta
    echo Por favor edita este archivo y cambia FLUTTER_PATH a la ruta correcta
    echo.
    pause
    exit /b 1
)

echo.
echo Flutter encontrado!
echo.
echo Agregando al PATH del usuario...
echo.

:: Agregar al PATH del usuario (permanente)
setx PATH "%PATH%;%FLUTTER_PATH%"

echo.
echo ========================================
echo PATH configurado exitosamente!
echo ========================================
echo.
echo IMPORTANTE: 
echo 1. Cierra esta ventana
echo 2. Abre una NUEVA terminal/PowerShell
echo 3. Ejecuta: flutter --version
echo.
echo Si ves la version de Flutter, esta listo!
echo.
pause
