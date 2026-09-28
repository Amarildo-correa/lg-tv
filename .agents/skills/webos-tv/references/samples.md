# Samples oficiais — mapa

Fonte: https://webostv.developer.lge.com/develop/samples — todos em https://github.com/webOS-TV-app-samples/ — resumido em 2026-09-27.

Antes de implementar uma feature do zero (DRM, media, sensor, teclado virtual, etc.), vale checar se já existe um sample oficial cobrindo o mesmo caso — geralmente é a forma mais direta de ver a API certa em uso.

| Sample | Demonstra | Link |
|---|---|---|
| Accessibility | Ler as configurações de acessibilidade do sistema | https://github.com/webOS-TV-app-samples/Accessibility |
| App Lifecycle | Transições de estado do app via eventos de launch | https://github.com/webOS-TV-app-samples/AppLifecycle |
| Back Button Control | Comportamento do botão Voltar do Magic Remote e efeito do `appinfo.json` | https://github.com/webOS-TV-app-samples/BackButtonControl |
| Database (DB8) | Criar "kinds" (tabelas) com `putKind()` | https://github.com/webOS-TV-app-samples/DB8 |
| Hello World Service | Criar um serviço webOS TV e chamá-lo a partir do app web | https://github.com/webOS-TV-app-samples/HelloWorldService |
| Hosted Web App | Redirecionamento de URL via JS/meta tag HTML5 | https://github.com/webOS-TV-app-samples/HostedWebApp |
| HexGL | Jogo de corrida em HTML5 (exemplo de app mais pesado/gráfico) | https://github.com/webOS-TV-app-samples/HexGL |
| Luna Service | Chamadas de API Luna usando webOSTV.js | https://github.com/webOS-TV-app-samples/LunaService |
| **Media Playback** | Implementação de playback de mídia — relevante para este projeto (streaming) | https://github.com/webOS-TV-app-samples/MediaPlayback |
| MRCU Sensor | Uso da Motion Sensor API do Magic Remote | https://github.com/webOS-TV-app-samples/MrcuSensor |
| Multi-Sound | Múltiplos áudios simultâneos via Web Audio API | https://github.com/webOS-TV-app-samples/MultiSound |
| Portrait Mode | Suporte a modo retrato (StanbyME) | https://github.com/webOS-TV-app-samples/PortraitMode |
| Remote Control | Tratar entradas do Magic Remote e exibir keycodes | https://github.com/webOS-TV-app-samples/RemoteControl |
| Resolution | Obter resolução de vídeo/UI via webOSTV.js | https://github.com/webOS-TV-app-samples/Resolution |
| Virtual Keyboard | Método principal de entrada de texto do webOS TV | https://github.com/webOS-TV-app-samples/VirtualKeyboard |
| Web Storage | `localStorage`/`sessionStorage` | https://github.com/webOS-TV-app-samples/WebStorage |
| webOSTV.js Library | Uso geral e capacidades da biblioteca | https://github.com/webOS-TV-app-samples/webOSTVJSLibrary |

Para um app de **streaming/VOD**, os mais relevantes são: Media Playback, Remote Control, Back Button Control, Resolution e (quando entrar DRM) a leitura de `references/guides.md` → DRM Content Playback.
