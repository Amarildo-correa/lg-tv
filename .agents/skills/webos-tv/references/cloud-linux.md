# Simulator no Claude Code na nuvem (Linux headless)

Verificado em 2026-09-28 com o webOS TV 26 Simulator v1.5.0 (build Linux) e `@webos-tools/cli` 3.2.6.

## O que o SessionStart hook deixa pronto

`.claude/hooks/session-start.sh` roda no início de cada sessão na nuvem (só quando `CLAUDE_CODE_REMOTE=true`) e é idempotente:

- `ares-cli` global via npm.
- Simulator baixado do site da LG (baixar implica aceitar a LG SDK License Agreement) e extraído em `/opt/webos-sim/webOS_TV_26_Simulator_1.5.0/squashfs-root` — o AppImage é extraído porque o container não tem FUSE.
- `~/.local/share/webos-simulator/webOS_TV_26_Simulator_1.5.0.appimage` → symlink para `scripts/sim-linux-launcher.sh`, e `~/.webos/tv/simulator-config.json` apontando a versão `26` para essa pasta. Assim `ares-launch -s 26` funciona sem `-sp`.
- CAs do proxy de saída do container importadas no NSS (`~/.pki/nssdb`), senão o Chromium do Simulator recusa todo HTTPS (`net_error -202`).

Para outra versão do Simulator: troque `SIM_NAME` e `SIM_FILE_ID` no hook (o `fileId` do zip Linux aparece no HTML da página de instalação da LG, junto do nome do arquivo) e o caminho padrão no lançador.

## Abrir o app

```bash
ares-launch -s 26 <pasta-do-app>
```

Mesma regra de pasta do WSL: a que contém `appinfo.json` e `index.html` (a gerada pelo build, nunca `src`).

O lançador valida o `appinfo.json` antes de subir o Simulator e faz o `ares-launch` falhar com a mensagem. Isso importa porque, sem tela, os diálogos de erro do Simulator ficam invisíveis: o app simplesmente não aparece.

Ele sempre sobe num Xvfb próprio (display `:77`, 1920×1080; `WEBOS_SIM_DISPLAY`), encerra uma instância anterior e liga:
- CDP das páginas em `127.0.0.1:9333` (`WEBOS_SIM_CDP_PORT`)
- inspector do processo principal do Electron em `127.0.0.1:9229` (`WEBOS_SIM_INSPECT_PORT`)
- log em `/tmp/webos-sim.log` (`WEBOS_SIM_LOG`); erros de `bus.cc`, GPU e do Google Analytics (405) são ruído normal

## Debug: Playwright via CDP

Não há CLI `chrome-devtools` aqui; use o Playwright global (`/opt/node22/lib/node_modules/playwright`) com `connectOverCDP`. A página do app é a única cuja URL **não** contém `app.asar`:

```js
// node app-debug.mjs
import { createRequire } from 'module';
const require = createRequire('/opt/node22/lib/node_modules/');
const { chromium } = require('playwright');
const b = await chromium.connectOverCDP('http://127.0.0.1:9333');
const p = b.contexts().flatMap(c => c.pages()).find(p => !p.url().includes('app.asar'));
p.on('console', m => console.log('console:', m.type(), m.text()));
p.on('requestfailed', r => console.log('falhou:', r.url(), r.failure()?.errorText));
await p.reload();                    // captura logs de inicialização
await p.waitForTimeout(1500);
await p.keyboard.press('ArrowDown'); // chega ao app com keyCode 40; Enter = 13
await p.screenshot({ path: '/tmp/app.png' });   // depois abra com Read
console.log(await p.evaluate(() => typeof PalmSystem));
await b.close();                     // desconecta sem fechar o Simulator
```

Se o app não aparecer na lista mesmo com o `appinfo.json` válido, o inspector do processo principal permite ver o que o Simulator tentou mostrar: conecte em `http://127.0.0.1:9229/json/list` (WebSocket) e, com `Runtime.evaluate`, use `process.mainModule.require('electron')` — por exemplo substitua `dialog.showMessageBox` para registrar as mensagens e dispare `ipcMain.emit('main-screen-loaded', {})` para ele tentar abrir o app de novo.

A screenshot da página do app mostra só a tela do app, sem o controle remoto ao redor.

## Encerrar

```bash
pkill -f '[s]quashfs-root/webOS_TV_26_Simulator'; kill $(cat /tmp/webos-sim-xvfb.pid) 2>/dev/null; rm -f /tmp/webos-sim-xvfb.pid
```

## Limites

Os mesmos da seção "O Simulator não é a TV física" do `SKILL.md` (Chromium 120 real com UA de 132, sem DRM, APIs Luna parciais). Além disso, aqui não há GPU (renderização por software) nem áudio, então desempenho e animações são ainda menos representativos.
