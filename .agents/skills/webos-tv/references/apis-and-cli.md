# APIs e CLI — mapa oficial

Fonte: https://webostv.developer.lge.com/develop/references e https://webostv.developer.lge.com/develop/tools/cli-introduction — resumido em 2026-09-27.

## webOSTV.js — biblioteca JS do app

Introdução: https://webostv.developer.lge.com/develop/references/webostvjs-introduction

| Módulo | O que é | Link |
|---|---|---|
| **webOS API** | Métodos compatíveis com a antiga `webOS.js`; exclui métodos que não rodam na TV. | /develop/references/webostvjs-webos |
| **webOSDev API** | Métodos novos, que não existiam na `webOS.js`. | /develop/references/webostvjs-webosdev |
| **DRMAgent** | Classe para gerenciar um agente DRM, usada dentro de webOSDev. | /develop/references/webostvjs-drm-agent |

`webOSTV.js` e `webOSTV-dev.js` (build de debug) são os dois arquivos usados no `<script>` do `index.html` — o projeto `webos-test-app` já os carrega dessa forma.

## Luna Service API — serviços do sistema

Introdução: https://webostv.developer.lge.com/develop/references/luna-service-introduction

Acessados via `webOS.service.request(...)` (webOSTV.js) ou diretamente por Luna bus.

| Serviço | Para que serve | Link |
|---|---|---|
| Activity Manager | Coordena trabalho em background no sistema | /develop/references/activity-manager |
| Application Manager | Lança apps e gerencia comandos/recursos entre eles | /develop/references/application-manager |
| Audio | Controle de volume | /develop/references/audio |
| BLE GATT | Operações Bluetooth LE GATT | /develop/references/ble-gatt |
| Camera | Info de câmera e microfone | /develop/references/camera |
| Connection Manager | Status das conexões de internet disponíveis | /develop/references/connection-manager |
| Database (DB8) | Armazenamento persistente para apps | /develop/references/database |
| Device Unique ID | Identificação do dispositivo | /develop/references/device-unique-id |
| DRM | Gerencia clientes DRM e direitos | /develop/references/drm |
| Keymanager3 | Criptografia, decriptografia, geração de chaves | /develop/references/keymanager3 |
| Magic Remote | Sensores e pareamento do controle | /develop/references/magic-remote |
| Media Database | Armazena datasets grandes relacionados a mídia | /develop/references/media-database |
| Settings Service | Lê valores de configuração do sistema | /develop/references/settings-service |
| System Service | Informação de hora do sistema | /develop/references/system-service |
| TV Device Information | Informações do sistema da TV | /develop/references/tv-device-information |

Outras referências relacionadas:
- **webOS Events** (eventos que o app pode escutar): https://webostv.developer.lge.com/develop/references/webos-event
- **DRM Messages** (formato das mensagens trocadas com o DRM Client): https://webostv.developer.lge.com/develop/references/drm-message
- **services.json** (declaração de serviços do app): https://webostv.developer.lge.com/develop/references/services-json
- **webos-service (Node.js)** — módulo para o *lado do serviço* (JS Service) falar com o bus do sistema, idiomas Node.js: https://webostv.developer.lge.com/develop/references/webos-service-introduction

## CLI (`ares-*`)

Introdução: https://webostv.developer.lge.com/develop/tools/cli-introduction — referência completa de flags: https://webostv.developer.lge.com/develop/tools/cli-dev-guide

Todos precisam de `source ~/.bashrc &&` neste ambiente (ver `~/.claude/CLAUDE.md`).

| Comando | Para que serve |
|---|---|
| `ares-generate` | Cria um app novo a partir de um template |
| `ares-package` | Empacota o app numa `.ipk` (ou analisa um pacote existente) |
| `ares-setup-device` | Gerencia a lista de devices/simulators configurados (`ares-setup-device -R` reseta) |
| `ares-install` | Instala o app (`.ipk`) num device de destino |
| `ares-launch` | Abre ou fecha o app — usado no `SKILL.md` principal para o Simulator |
| `ares-inspect` | Abre o Web Inspector (app) ou Node Inspector (JS service) num device físico — **não é o caminho usado para o Simulator local**, que usa CDP direto (ver `SKILL.md`) |
| `ares-server` | Sobe um servidor web local para testar os arquivos do app |
| `ares-novacom` | Controla o device por linha de comando (baixo nível) |
| `ares-device` | Lê info do sistema do device e monitora uso de recursos |
| `ares-config` | Configura a CLI (ex.: caminho do Simulator — ver `~/.webos/tv/simulator-config.json`) |

Referência completa (todas as flags de cada comando): https://webostv.developer.lge.com/develop/tools/cli-dev-guide
