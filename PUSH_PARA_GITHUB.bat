@echo off
title Enviando EFI para o GitHub...
echo ========================================================
echo   Enviando EFI HP Elite c1030 para o GitHub (nepotira)
echo ========================================================
echo.
cd /d "%~dp0"
git push -u origin main
echo.
if %ERRORLEVEL% equ 0 (
    echo ========================================================
    echo   SUCESSO! O repositorio foi enviado para o GitHub!
    echo   Acesse: https://github.com/nepotira/HP-Elite-c1030-Hackintosh
    echo ========================================================
) else (
    echo ========================================================
    echo   Ops! O repositorio ainda nao foi criado no GitHub.
    echo   Crie o repositorio com o nome: HP-Elite-c1030-Hackintosh
    echo   no link: https://github.com/new
    echo   Depois execute este arquivo novamente!
    echo ========================================================
)
echo.
pause
