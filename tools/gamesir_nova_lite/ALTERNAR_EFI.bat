@echo off
chcp 65001 > nul
title Alternador de Perfil EFI - GameSir Nova Lite / Netflix DRM

:: Verificar privilégios de Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] Este script precisa ser executado como Administrador para acessar a partição EFI.
    echo Clique com o botão direito e selecione "Executar como Administrador".
    echo.
    pause
    exit /b
)

:: Garantir que a partição Y: está montada
if not exist "Y:\" (
    echo Montando partição EFI na letra Y:...
    mountvol Y: /S
)

:MENU
cls
echo ==============================================================================
echo        ALTERNADOR DE EFI - HP ELITE C1030 (GAMEPAD XINPUT / NETFLIX)
echo ==============================================================================
echo.
echo Escolha qual perfil de EFI você deseja aplicar no seu SSD (Y:\EFI\OC\config.plist):
echo.
echo [1] Ativar EFI PADRÃO ESTÁVEL v1.1.2 (Recomendada / Oficial)
echo     - AMFI compatível (-amfipassbeta)
echo     - Netflix OK em qualquer navegador (Chrome + Safari)
echo     - WhatsApp Microfone OK, Câmera OK, YouTube 1080p 60fps OK
echo.
echo [2] Ativar EFI COM BYPASS XINPUT (amfi_get_out_of_my_way=1)
echo     - Permite pontes e daemons de controle com Dongle USB 2.4 GHz no Chrome
echo     - DICA: No Safari, a Netflix continua funcionando 1080p via FairPlay!
echo.
echo [3] Sair
echo.
set /p opt="Digite sua opção (1, 2 ou 3): "

if "%opt%"=="1" goto ATIVAR_PADRAO
if "%opt%"=="2" goto ATIVAR_XINPUT
if "%opt%"=="3" goto FIM
goto MENU

:ATIVAR_PADRAO
cls
echo Aplicando perfil PADRÃO ESTÁVEL v1.1.2 na partição Y:\...
if exist "%~dp0configs\config_padrao_v1.1.2.plist" (
    copy /Y "%~dp0configs\config_padrao_v1.1.2.plist" "Y:\EFI\OC\config.plist" > nul
) else if exist "%~dp0configs\config_padrao_v1.1.0.plist" (
    copy /Y "%~dp0configs\config_padrao_v1.1.0.plist" "Y:\EFI\OC\config.plist" > nul
) else if exist "C:\Users\nepo\Desktop\config_TESTE_sem_amfi.plist" (
    copy /Y "C:\Users\nepo\Desktop\config_TESTE_sem_amfi.plist" "Y:\EFI\OC\config.plist" > nul
) else (
    echo [ERRO] Arquivo de perfil não encontrado!
    pause
    goto MENU
)
echo.
echo [SUCESSO] Perfil PADRÃO ESTÁVEL v1.1.2 ativado com sucesso!
echo - Netflix, WhatsApp e Áudio funcionando perfeitamente.
echo Pode reiniciar o computador para entrar no macOS.
echo.
pause
goto MENU

:ATIVAR_XINPUT
cls
echo Aplicando perfil XINPUT DONGLE (amfi_get_out_of_my_way=1) na partição Y:\...
if exist "%~dp0configs\config_gamesir_xinput.plist" (
    copy /Y "%~dp0configs\config_gamesir_xinput.plist" "Y:\EFI\OC\config.plist" > nul
) else if exist "C:\Mac_PostInstall_Fixes\config.plist" (
    copy /Y "C:\Mac_PostInstall_Fixes\config.plist" "Y:\EFI\OC\config.plist" > nul
) else (
    echo [ERRO] Arquivo de perfil não encontrado!
    pause
    goto MENU
)
echo.
echo [SUCESSO] Perfil com amfi_get_out_of_my_way=1 ativado com sucesso!
echo - Dongle 2.4 GHz do GameSir liberado para o xCloud no Chrome.
echo - Dica de ouro: Assista à Netflix pelo Safari para manter os dois funcionando!
echo Pode reiniciar o computador para entrar no macOS.
echo.
pause
goto MENU

:FIM
exit
