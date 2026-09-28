# Guides — mapa oficial

Fonte: https://webostv.developer.lge.com/develop/guides (índice completo) — resumido em 2026-09-27. Cada linha é um link direto; abra a página antes de implementar, este arquivo só ajuda a achar o assunto certo rápido.

## Design e Sistema

| Assunto | O que cobre | Link |
|---|---|---|
| Design Principles | Princípios gerais de design para TV | /develop/guides/design-principles |
| Home Screen | Aparência e layout da Home do webOS TV | /develop/guides/home-screen |
| Notifications | Notificações do sistema para apps | /develop/guides/notifications |
| Interacting with Apps | Padrões de interação e engajamento do usuário | /develop/guides/interacting-with-apps |
| Virtual Keyboard | Entrada de texto na TV | /develop/guides/virtual-keyboard |
| Magic Remote | Design para o controle remoto da LG | /develop/guides/magic-remote |
| Icon | Especificação de ícones | /develop/guides/icon |
| Overscan | Área segura de tela | /develop/guides/overscan |
| Color | Uso de cores na interface | /develop/guides/color |
| System UI Visibility | Controlar visibilidade de elementos do sistema | /develop/guides/system-ui-visibility |
| Screensaver | Implementar proteção de tela | /develop/guides/screensaver |

## Controle remoto e navegação

| Assunto | O que cobre | Link |
|---|---|---|
| **Back Button** | Ver resumo completo abaixo | /develop/guides/back-button |
| Motion Sensor Overview / Sensor Data / Implementation | Sensor de movimento do Magic Remote | /develop/guides/motion-sensor-overview, -sensor-data, -implementation |

### Back Button (resumo)

- Por padrão, o webOS usa a History API do DOM para tratar o botão Voltar do Magic Remote.
- Evento: `keydown` com **keyCode 461** (hex `0x1CD`).
- Para tratar manualmente: definir `"disableBackHistoryAPI": true` no `appinfo.json` e escutar o evento:
  ```js
  window.addEventListener("keydown", function (e) {
    if (e.keyCode === 461) doBack();
  });
  ```
- Para sair do app: `webOS.platformBack()` — no webOS 6.0+ mostra popup de confirmação; no 5.0 e anteriores, vai para a Home. Alternativa: diálogo próprio + `window.close()`.
- Recomendado para SPA com estado complexo, onde seguir a History API pura não é prático.
- Link completo: https://webostv.developer.lge.com/develop/guides/back-button

## Mídia e DRM

| Assunto | O que cobre | Link |
|---|---|---|
| **DRM Content Playback** | Ver resumo completo abaixo | /develop/guides/drm-content-playback |
| mediaOption Parameters | Opções de configuração de playback | /develop/guides/mediaoption-parameter |
| Resuming Media with mediaOption | Retomar playback de forma eficiente | /develop/guides/resuming-media-with-mediaoption |
| Multi-Sound Playback | Múltiplos áudios simultâneos (Web Audio API) | /develop/guides/multi-sound-playback |

### DRM Content Playback (resumo)

- **Sistema DRM suportado: PlayReady** (Microsoft).
- Fluxo: DRM Service gerencia instâncias de DRM Client → web app pede playback e manda DRM message com dados de licenciamento → DRM Client busca a chave de licença no servidor → media pipeline decripta e renderiza.
- Passos: `load()` especificando tipo PlayReady → `sendDrmMessage()` com dados do iniciador em XML → assinar `getRightsError()` para erros de licenciamento → montar `mediaOption` com `drm.type` e `drm.clientId`, serializar como JSON string e colocar no atributo `type` da fonte de vídeo → `unload()` antes de encerrar o app ou trocar de conteúdo DRM.
- Cuidado: erros de licenciamento são transmitidos a todos os apps inscritos — validar pelo message ID antes de agir.
- **Importante para este projeto (streaming)**: o Simulator não reproduz DRM de verdade (ver `SKILL.md` principal) — validar playback com DRM só em TV física.
- Link completo: https://webostv.developer.lge.com/develop/guides/drm-content-playback

## Dados e serviços em background

| Assunto | O que cobre | Link |
|---|---|---|
| JS Service Basics / Usage / FAQ | Como criar e usar um serviço JS (processo separado, roda em background) | /develop/guides/js-service-basics, -usage, -faq |
| DB8 Basic / Usage / FAQ | Banco de dados NoSQL embutido do webOS | /develop/guides/db8-basic, -usage, -faq |
| BLE GATT | Bluetooth Low Energy | /develop/guides/ble-gatt |

## Outros

| Assunto | O que cobre | Link |
|---|---|---|
| Privacy Guideline | Padrões de privacidade e proteção de dados | /develop/guides/privacy-guideline |
| App Lifecycle Management | Gerenciar estados do app (mais aprofundado que o de Getting Started) | /develop/guides/app-lifecycle-management |
| Localization | Múltiplos idiomas/regiões | /develop/guides/app-localization |
| In-App Purchase | Produtos pagos em app VOD/jogo | /develop/guides/in-app-purchase |
| Backward Compatibility | Manter compatibilidade entre versões webOS | /develop/guides/backward-compatibility |
| Enyo and Enact Guide | Frameworks legado (Enyo) e atual (Enact) da LG | /develop/guides/enyo-enact-guide |
| Flutter for webOS | Desenvolver com Flutter | /develop/guides/flutter-for-webos |
| ACG Guide | Access Control Group (segurança/permissões) | /develop/guides/acg-guide |
| StanbyME Overview / Portrait Mode / Touch Screen | Requisitos para os modelos portáteis StanbyME | /develop/guides/stanbyme-overview, -portrait-mode, -touch-screen |

Prefixo comum a todos os links relativos acima: `https://webostv.developer.lge.com`
