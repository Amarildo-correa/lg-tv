# Getting Started — mapa oficial

Fonte: https://webostv.developer.lge.com/develop/getting-started (índice) e subpáginas. Resumido por um modelo em 2026-09-27 — trate como mapa para achar a página certa, não como especificação exata; abra o link antes de implementar um detalhe fino (formato de campo, valor exato, etc.).

## Ordem recomendada num projeto novo

1. **Developer Workflow** — visão geral do processo, do zero até a publicação.
   https://webostv.developer.lge.com/develop/getting-started/developer-workflow
2. **Web App Types** — escolher o tipo de app antes de estruturar o projeto (ver abaixo).
   https://webostv.developer.lge.com/develop/getting-started/web-app-types
3. **Build Your First Web App** — tutorial do Hello World, útil como checklist mesmo em projeto maior.
   https://webostv.developer.lge.com/develop/getting-started/build-your-first-web-app
4. **App Resources** — que arquivos/assets preparar e onde colocá-los.
   https://webostv.developer.lge.com/develop/getting-started/app-resources
5. **App Lifecycle** — estados do app (launch, pause, resume, close) e os eventos webOS correspondentes.
   https://webostv.developer.lge.com/develop/getting-started/app-lifecycle
6. **App Templates** — estruturas prontas (via `ares-generate`).
   https://webostv.developer.lge.com/develop/getting-started/app-template
7. **App Debugging** — ver abaixo.
   https://webostv.developer.lge.com/develop/getting-started/app-debugging
8. **Developer Mode App** — como habilitar e testar numa TV física de verdade (fora do Simulator).
   https://webostv.developer.lge.com/develop/getting-started/developer-mode-app

## Tipos de web app

| Tipo | Como funciona | Quando usar |
|---|---|---|
| **Basic (Packaged)** | Todos os recursos empacotados no `.ipk`. Atualizar exige gerar e reenviar novo pacote. | App com features estáveis, sem necessidade de atualização frequente. |
| **Hosted Web App** | O `.ipk` instala só um app local que redireciona para conteúdo hospedado num servidor remoto. | App que muda com frequência — atualiza no servidor, sem reinstalar na TV. Depende de conexão de rede em runtime. |

Detalhes: https://webostv.developer.lge.com/develop/getting-started/web-app-types

## Debugging oficial (Web Inspector / Node Inspector)

- **Web Inspector**: debuga o app web rodando no device/TV, via Chromium — a versão do Chromium compatível varia por ano da webOS TV (ex.: webOS 25 usa Chrome mais recente; versões antigas usam Chrome ~38).
- **Node Inspector**: debuga JS services (backend) rodando no device.
- **Requisito prático**: empacotar o `.ipk` **sem minificação** para poder debugar de verdade (nomes de variáveis/breakpoints legíveis).
- Isso é sobre TV/Developer Mode App, não sobre o Simulator local — para o Simulator via CDP, ver o `SKILL.md` principal.

Detalhes: https://webostv.developer.lge.com/develop/getting-started/app-debugging

## appinfo.json — campos mais usados

Fonte completa: https://webostv.developer.lge.com/develop/references/appinfo-json

| Campo | Significado |
|---|---|
| `id` | ID do app, DNS reverso (`com.empresa.app`). |
| `version` | Três inteiros separados por ponto. |
| `type` | Categoria do app; hoje só `"web"` é suportado. |
| `main` | Arquivo de entrada, tipicamente `index.html`. |
| `title` | Nome mostrado no Launcher e na janela do app. |
| `icon` / `largeIcon` | PNG 80×80 / 130×130. |
| `vendor` | Dono do app, aparece no Launcher e em diálogos de deviceinfo. |
| `resolution` | `"1920x1080"` (FHD) ou `"1280x720"` (HD). |
| `appDescription` | Tagline curta, até 60 caracteres. |
| `requiredMemory` | RAM mínima em MB. |
| `disableBackHistoryAPI` | Ver `references/guides.md` → Back Button. |

Sempre conferir a página oficial antes de adicionar um campo novo — a lista completa tem mais opções (splash screen, `deeplinkingParams`, permissões, etc.) que não foram resumidas aqui.
