---
name: webos-tv
description: Como planejar, abrir, testar e depurar apps webOS TV (LG) — mapa comentado com links para a documentação oficial da LG (getting started, guides, APIs Luna/webOSTV.js, CLI, tools, samples) para consultar ANTES de começar um projeto novo ou adicionar/alterar uma feature, e o passo a passo de abrir o webOS TV Simulator a partir do WSL com Chrome DevTools Protocol (ares-launch, console, rede, JS, screenshots, teclas do controle via CLI chrome-devtools) e o que o Simulator NÃO reproduz da TV física (motor Chromium diferente, DRM, codecs, APIs Luna). Use sempre que o usuário mencionar webOS, LG TV, Smart TV, ares-cli/ares-launch/ares-package/ares-generate, .ipk, appinfo.json, webOSTV.js, PalmSystem, Luna Service, Enact, ou pedir para planejar, criar, rodar, testar, ver o visual, ler logs ou debugar um app de TV — mesmo que não diga "Simulator" ou "documentação".
---

# webOS TV: documentação oficial, Simulator, debug e limites

Há dois ambientes, e os passos de Simulator mudam entre eles:

- **WSL local** (padrão das seções abaixo): o Simulator e o Chrome rodam no **Windows**. Comandos que usam ares-cli precisam de `source ~/.bashrc &&` (senão resolvem para binários do Windows).
- **Claude Code na nuvem** (`CLAUDE_CODE_REMOTE=true`, container Linux sem tela): siga `references/cloud-linux.md` em vez das seções de Simulator/debug abaixo. As seções de documentação e de limites do Simulator valem igual.

Em qualquer ambiente, o Simulator recusa abrir um app cujo `appinfo.json` não tenha `id`, `title`, `type`, `main`, `icon` e `version`, ou cujos arquivos `main`/`icon`/`largeIcon` não existam.

## Antes de começar um projeto novo, ou adicionar/mudar uma feature

A LG documenta bem a plataforma, e boa parte dos erros mais comuns (campo errado no `appinfo.json`, tipo de app errado, API que não existe onde se procurou) se evita consultando a doc oficial antes de escrever código — não depois, quando já apareceu um comportamento estranho. Os arquivos abaixo são um índice comentado, com resumo e link direto para cada assunto; foram gerados a partir da doc oficial em 2026-09-27, então tratam-nos como um mapa para achar a página certa rápido, e sempre abrem o link antes de implementar um detalhe fino — a doc muda, e um resumo automático pode ter perdido algo.

| Situação | Ler primeiro |
|---|---|
| Projeto novo do zero | `references/getting-started.md` (ordem recomendada, tipos de app, `appinfo.json`) |
| Feature de UI, remoto, DRM, mídia, DB local, serviço em background | `references/guides.md` |
| Chamar uma API do sistema (volume, rede, DRM, câmera…) ou comando `ares-*` | `references/apis-and-cli.md` |
| Escolher ferramenta (CLI, Simulator, webOS Studio, monitor de recursos) | `references/tools.md` |
| Ver um exemplo pronto antes de implementar do zero | `references/samples.md` |

Para o app de streaming deste projeto (`app-streaming`), os assuntos mais prováveis são media playback, DRM, controle remoto e voltar — comece por `references/guides.md` e `references/samples.md`.

## Instalação local (já feita — só conserte se quebrar)

- Simulator: `C:\Program Files\webOS_TV_26_Simulator_1.5.0\` (Electron; v1.5.0 é a mais recente em 2026-09).
- `ares-cli` no Linux espera um `.appimage`, então existe um wrapper em `~/.local/share/webos-simulator/webOS_TV_26_Simulator_1.5.0.appimage` que chama o `.exe` convertendo o caminho do app com `wslpath -w`. Se o Simulator mudar de lugar, atualize a linha `EXE=` dele.
- `~/.webos/tv/simulator-config.json` aponta a versão `26` para essa pasta, por isso não se usa `-sp`.
- Instalar outra versão do Simulator exige um wrapper novo com as mesmas linhas e trocar o `-s 26`.

## Qual pasta passar ao Simulator

O Simulator abre a **pasta do app** (a que contém `appinfo.json` e `index.html`), não o `.ipk`. O `.ipk` é só o pacote para instalar em TV física; não extraia um `.ipk` para testar um projeto cujo código você tem.

Se o projeto tem etapa de build (Enact, React, Vite…), passe a pasta **gerada pelo build**, nunca `src` — é ela que tem o `appinfo.json` e o `index.html` finais.

## Só abrir o app

```bash
source ~/.bashrc && ares-launch -s 26 <pasta-do-app>
```

## Abrir com debug (console, rede, JS, screenshot, teclas)

O Simulator expõe o Chrome DevTools Protocol quando recebe `--remote-debugging-port`. O `ares-launch` descarta flags extras (monta um comando fixo `"<sim>" "<appDir>" "<params JSON>"`), então o wrapper lê a porta da variável `WEBOS_SIM_CDP_PORT`.

Use a CLI `chrome-devtools` via Bash, não as ferramentas MCP `mcp__chrome-devtools__*` (vale também para sub-agents).

1. Conferir que não há daemon ativo: `chrome-devtools status`.
2. Abrir e esperar a porta:
   ```bash
   source ~/.bashrc && WEBOS_SIM_CDP_PORT=9333 ares-launch -s 26 <pasta-do-app>
   for i in $(seq 1 20); do powershell.exe -c 'try{(Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://127.0.0.1:9333/json/version).StatusCode}catch{0}' | grep -q 200 && break; sleep 1; done
   ```
3. Conectar: `chrome-devtools start --browserUrl http://127.0.0.1:9333` (não `--autoConnect` nem `--userDataDir`: isso abriria um Chrome em vez de usar o Simulator).
4. Achar o app: `chrome-devtools list_pages`. São ~12 páginas; a do app é a que **não** contém `app.asar` (as outras são a UI do Simulator: controle, teclado virtual, `jsService`…). O pageId muda a cada abertura, então consulte sempre.
5. Nesse modo o pageId é **argumento posicional obrigatório** (sem ele a CLI dá erro de argumentos):
   - `chrome-devtools list_console_messages <id>`
   - `chrome-devtools list_network_requests <id>`
   - `chrome-devtools navigate_page <id> --type reload` — recarregue para capturar logs de inicialização, que acontecem antes de você conectar
   - `chrome-devtools take_screenshot <id> --filePath 'C:\Users\amari\AppData\Local\Temp\websim.png'` (caminho Windows; leia pelo espelho `/mnt/c/Users/amari/AppData/Local/Temp/`)
   - `chrome-devtools take_snapshot <id>` para a árvore do DOM
   - `chrome-devtools press_key <id> ArrowDown` (setas e `Enter` chegam ao app com keyCode 37–40 e 13)
   - Exceção: `chrome-devtools evaluate_script --pageId <id> '() => ...'`
   `window.webOS` e `window.PalmSystem` existem na página (ex.: `PalmSystem.launchParams`).
6. Se a saída da CLI vier cortada ou só com a dica genérica de uso, rode de novo como `rtk proxy chrome-devtools ...`.
7. Encerrar sempre:
   ```bash
   chrome-devtools stop
   powershell.exe -c 'Get-Process | ?{$_.ProcessName -like "webOS_TV*"} | Stop-Process'
   ```

O que isso não cobre: breakpoints com pausa passo a passo (a CLI não tem); a screenshot mostra só a tela do app, não o controle ao redor; o botão Voltar da LG (keyCode 461) não é tecla padrão do `press_key` — dispare o evento por `evaluate_script` se precisar (não testado); logs dos serviços JS do app ficam na página `jsService` (não testado).

## O Simulator não é a TV física

Verificado em 2026-09-27 no Simulator 26 v1.5.0:

- O motor real é **Chromium 120** (Electron 28.3.3; `/json/version` e `navigator.userAgentData` dizem 120), mas o UA do app informa `Chrome/132`, que é o da TV. Pela [tabela da LG](https://webostv.developer.lge.com/develop/specifications/web-api-and-web-engine): TV 26 = Chromium 132, TV 25 = 120, TV 24 = 108.
- Por isso, recurso JS/CSS do Chromium 121–132 (ex.: `Array.fromAsync`, `Set.prototype.union`, `Promise.try`, `field-sizing`, `light-dark()`, anchor positioning) **falha no Simulator e funciona na TV 26**. Antes de chamar algo de bug, considere isso. No código do app, detecte recursos (feature detection), nunca pelo UA — o UA mente sobre o motor.
- Se o app precisa rodar em TVs mais antigas (ex.: 24 = Chromium 108), passar no Simulator 26 não prova nada; confira o suporte da versão mais baixa no caniuse/MDN.
- Limites declarados pela LG: sem DRM, especificações de áudio/vídeo diferentes, sem `mediaOption`, parte das APIs Luna e webOSSystem ausente. Desempenho também não é representativo.
- Conclusão para o usuário: reprodução de vídeo, DRM, APIs de sistema e desempenho só se validam numa TV física.
