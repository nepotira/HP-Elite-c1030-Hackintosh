# 🎮 Guia e Ferramentas do GameSir Nova Lite no macOS (HP Elite c1030)

Este pacote reúne todas as ferramentas, scripts e instruções para utilizar o controle **GameSir Nova Lite** com seu **Dongle USB 2.4 GHz (Modo XInput)** com latência mínima no **Google Chrome** (Xbox Cloud Gaming / xCloud) no macOS, sem abrir mão da reprodução de vídeos protegidos por DRM (Netflix / Prime Video).

---

## 📌 Contexto Técnico: Por que isso acontece?

O **GameSir Nova Lite** possui um dongle USB 2.4 GHz que opera no protocolo **XInput (padrão Xbox 360 / Xbox One)** com o LED na cor verde fixa (`Home + X`).

No macOS:
1. O protocolo XInput não é mapeado nativamente pelo navegador Google Chrome sem um driver, ponte ou daemon em segundo plano.
2. Quando uma ponte de controle ou script roda no macOS, o subsistema de segurança **AMFI (Apple Mobile File Integrity)** bloqueia códigos não assinados oficialmente pela Apple com o erro `Killed: 9`.
3. Se você desativa a validação do AMFI adicionando o boot-arg `amfi_get_out_of_my_way=1` na EFI, o controle com dongle funciona perfeitamente no Chrome, mas o plugin **Widevine** da Google recusa carregar, impedindo a reprodução da **Netflix no Chrome**.

---

## 🚀 As Soluções para ter GameSir com Dongle E Netflix:

### Solução 1: A Solução Imediata (Recomendada!)
Mantenha o perfil com `amfi_get_out_of_my_way=1` ativo na EFI:
* **Para Jogar:** Abra o **Google Chrome** e jogue no **xCloud** com o dongle espetado. Latência ultrabaixa e resposta instantânea!
* **Para Assistir à Netflix:** Abra o **Safari**!
  * **Por que funciona?** O Safari **NÃO usa o plugin Widevine**. Ele utiliza o decodificador nativo por hardware **Apple FairPlay** (que deixamos 100% acelerado pela GPU Intel UHD 630 com o argumento `unfairgva=1`). No Safari, a Netflix toca em **1080p Full HD fluido e com som cristalino** mesmo com o AMFI contornado!

---

### Solução 2: A Solução Definitiva (Ambos funcionando no Google Chrome)
Se você faz questão de assistir à Netflix dentro do próprio Google Chrome:
1. Mantenha a **EFI Padrão v1.2.0** (sem o argumento `amfi_get_out_of_my_way=1`).
2. Abra o script **`setup_gamesir_dongle.command`** contido nesta pasta dando dois cliques no macOS.
3. Escolha a **Opção [1]** e selecione o executável da sua ferramenta de controle.
4. O script aplicará a assinatura digital local (**Ad-Hoc Signing**) e removerá os atributos de quarentena:
   ```bash
   sudo xattr -cr "/caminho/do/programa"
   sudo codesign --force --deep --sign - "/caminho/do/programa"
   ```
5. Com a assinatura local válida, o macOS executa o programa de controle sem bloqueios, mantendo o AMFI ligado e o Widevine da Netflix 100% ativo no Chrome!

---

### Solução 3: Alternador de Perfis de EFI no Windows (`ALTERNAR_EFI.bat`)
Se você está no Windows em dual-boot:
1. Execute o script **`ALTERNAR_EFI.bat`** como Administrador.
2. Escolha:
   * **[1] EFI PADRÃO ESTÁVEL v1.2.0:** Para uso diário, estudos, Netflix no Chrome e reuniões com WhatsApp Microfone.
   * **[2] EFI COM BYPASS XINPUT:** Para sessões de jogos no xCloud usando o dongle de 2.4 GHz no Chrome.
3. O script substitui o `config.plist` na partição `Y:\EFI\OC\` instantaneamente.

---

## 📦 Conteúdo deste Pacote:
* **`setup_gamesir_dongle.command`**: Script executável do macOS para assinatura ad-hoc e diagnóstico USB.
* **`ALTERNAR_EFI.bat`**: Script de automação do Windows para troca de perfis de EFI na partição `Y:`.
* **`configs/config_padrao_v1.2.0.plist`**: Arquivo de configuração padrão oficial (DRM e TCC 100%).
* **`configs/config_gamesir_xinput.plist`**: Arquivo de configuração com `amfi_get_out_of_my_way=1` para testes de dongle.
