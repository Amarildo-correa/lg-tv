# Tools — mapa oficial

Fonte: https://webostv.developer.lge.com/develop/tools — resumido em 2026-09-27.

## Em uso / recomendados

| Ferramenta | Para que serve | Link |
|---|---|---|
| **SDK** | Kit completo de desenvolvimento webOS TV (reúne CLI + Simulator + docs) | /develop/tools/sdk-introduction |
| **webOS CLI** | Coleção de comandos `ares-*` — ver `references/apis-and-cli.md` | /develop/tools/cli-introduction |
| **webOS Studio** | Extensão do VS Code para o fluxo de desenvolvimento (gerar, empacotar, instalar, debugar direto do editor) | /develop/tools/webos-studio-introduction |
| **Simulator** | Testar o app no computador sem TV física — é o que o `SKILL.md` principal automatiza via CDP | /develop/tools/simulator-introduction |
| **Resource Monitor** | Mede uso de recursos (CPU/memória) do app em execução | /develop/tools/resource-monitor-introduction |

**webOS Studio** vale conferir se o projeto for trabalhado também pela IDE (VS Code) e não só pelo Claude Code via CLI — pode simplificar empacotamento e instalação em device físico.

## Deprecados (não usar em projeto novo, mas podem aparecer em código antigo)

| Ferramenta | Substituída por |
|---|---|
| webOS TV CLI (antigo) | webOS CLI atual |
| Beanviser | Resource Monitor |
| Emulator | Simulator |
| IDE (antiga) | webOS Studio |
| Sublime Text Plugin | webOS Studio / webOS CLI |
| VS Code Extension (antiga) | webOS Studio |

Se encontrar referência a alguma dessas num projeto existente, é sinal de código/tooling desatualizado — vale sinalizar ao usuário antes de migrar.

Índice completo: https://webostv.developer.lge.com/develop/tools
