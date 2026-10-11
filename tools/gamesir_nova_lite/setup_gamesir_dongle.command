#!/bin/bash
# ==============================================================================
# GameSir Nova Lite - Utilitário de Configuração do Dongle USB 2.4 GHz no macOS
# HP Elite c1030 Hackintosh (Jinlon) - Projeto por nepotira
# ==============================================================================

clear
echo "=============================================================================="
echo "    🎮 GameSir Nova Lite - Ferramenta de Otimização do Dongle (macOS)"
echo "=============================================================================="
echo ""
echo "Este script auxilia na configuração do seu controle GameSir Nova Lite usando"
echo "o Dongle USB 2.4 GHz (Modo XInput) para o xCloud no Google Chrome sem conflitos."
echo ""

show_menu() {
    echo "Escolha uma opção:"
    echo "  [1] Assinar aplicativo/daemon de controle (Ad-Hoc Signing - Mantém Netflix OK)"
    echo "  [2] Verificar se o Dongle USB 2.4 GHz está conectado e detectado"
    echo "  [3] Exibir guia de compatibilidade Netflix + GameSir Dongle"
    echo "  [4] Sair"
    echo ""
    read -p "Digite a opção desejada [1-4]: " opcao
}

while true; do
    show_menu
    case $opcao in
        1)
            echo ""
            echo "--- [1] Assinatura Digital Local (Ad-Hoc Codesign) ---"
            echo "Para rodar binários de ponte de controle sem precisar de amfi_get_out_of_my_way=1"
            echo "(o que mantém a Netflix funcionando no Google Chrome):"
            echo ""
            read -p "Arraste o arquivo .app ou executável da ferramenta aqui e pressione Enter: " ALVO
            # Remove aspas caso o usuário arraste pelo Finder
            ALVO=$(echo "$ALVO" | sed "s/'//g; s/\"//g")
            
            if [ -e "$ALVO" ]; then
                echo "Removendo quarentena do Gatekeeper..."
                sudo xattr -cr "$ALVO"
                echo "Aplicando assinatura Ad-Hoc..."
                sudo codesign --force --deep --sign - "$ALVO"
                echo ""
                echo "✅ [SUCESSO] O arquivo foi assinado localmente com sucesso!"
                echo "O macOS agora confia na execução do programa com o AMFI ativo."
            else
                echo "❌ [ERRO] Caminho não encontrado: $ALVO"
            fi
            echo ""
            read -p "Pressione Enter para voltar ao menu..."
            clear
            ;;
        2)
            echo ""
            echo "--- [2] Diagnóstico de Dispositivos USB ---"
            echo "Procurando dispositivos GameSir, Xbox ou Receptores Sem Fio USB..."
            echo ""
            system_profiler SPUSBDataType | grep -E "GameSir|Wireless Receiver|Xbox|Controller|Gamepad|Product ID|Vendor ID" -B 2 -A 4
            echo ""
            read -p "Pressione Enter para voltar ao menu..."
            clear
            ;;
        3)
            echo ""
            echo "--- [3] Guia de Compatibilidade: GameSir Dongle + Netflix ---"
            echo ""
            echo "💡 Entendendo os Dois Cenários:"
            echo ""
            echo "▶ CENÁRIO 1: O Dongle com amfi_get_out_of_my_way=1 (Mais prático para xCloud)"
            echo "  * xCloud no Chrome: Funciona com latência mínima via Dongle USB 2.4 GHz."
            echo "  * Netflix: Assista diretamente pelo SAFARI! O Safari utiliza o decodificador"
            echo "    Apple FairPlay nativo por hardware (Intel UHD 630 com unfairgva=1),"
            echo "    tocando em 1080p Full HD fluido sem depender do Widevine do Chrome."
            echo ""
            echo "▶ CENÁRIO 2: Ambos funcionando dentro do Google Chrome"
            echo "  * Mantenha a EFI Padrão v1.1.0 (sem o boot-arg amfi_get_out_of_my_way=1)."
            echo "  * Utilize a opção [1] deste script para assinar o executável da ponte XInput."
            echo "  * Assim, o Widevine do Chrome valida o DRM da Netflix e o controle funciona!"
            echo ""
            read -p "Pressione Enter para voltar ao menu..."
            clear
            ;;
        4)
            echo "Encerrando. Bom jogo!"
            exit 0
            ;;
        *)
            echo "Opção inválida."
            sleep 1
            clear
            ;;
    esac
done
