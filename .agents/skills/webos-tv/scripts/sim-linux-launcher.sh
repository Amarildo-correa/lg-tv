#!/bin/bash
# Lançador do webOS TV Simulator para sessões Linux sem tela (Claude Code na nuvem).
#
# O ares-launch executa "<simulador>.appimage" "<pasta-do-app>" "<params JSON>" e
# espera 1 s: se o processo sair com erro antes disso, ele mostra o erro. Este
# script ocupa o lugar desse .appimage (via symlink criado pelo SessionStart hook):
# valida o appinfo.json, encerra um Simulator anterior e sobe um novo em segundo
# plano dentro do Xvfb, sempre com Chrome DevTools Protocol ligado.
#
# Variáveis:
#   WEBOS_SIM_DIR            pasta extraída do AppImage (padrão: /opt/webos-sim/.../squashfs-root)
#   WEBOS_SIM_CDP_PORT       porta do CDP das páginas (padrão 9333)
#   WEBOS_SIM_INSPECT_PORT   porta do inspector do processo principal (padrão 9229)
#   WEBOS_SIM_LOG            log do Simulator (padrão /tmp/webos-sim.log)
#   WEBOS_SIM_DISPLAY        display do Xvfb (padrão :77)
set -uo pipefail

SIM_DIR="${WEBOS_SIM_DIR:-/opt/webos-sim/webOS_TV_26_Simulator_1.5.0/squashfs-root}"
SIM_BIN="$SIM_DIR/webOS_TV_26_Simulator_1.5.0"
CDP_PORT="${WEBOS_SIM_CDP_PORT:-9333}"
INSPECT_PORT="${WEBOS_SIM_INSPECT_PORT:-9229}"
LOG="${WEBOS_SIM_LOG:-/tmp/webos-sim.log}"
APP_DIR="${1:-}"

if [ ! -x "$SIM_BIN" ]; then
  echo "webOS Simulator não encontrado em $SIM_BIN (rode .claude/hooks/session-start.sh)" >&2
  exit 1
fi

# Em modo headless os diálogos de erro do Simulator ficam invisíveis, então
# repetimos aqui a validação que ele faz ao abrir o app.
if [ -n "$APP_DIR" ]; then
  node - "$APP_DIR" <<'EOF' || exit 1
const fs = require('fs'), path = require('path');
const dir = path.resolve(process.argv[2]);
const file = path.join(dir, 'appinfo.json');
let info;
try { info = JSON.parse(fs.readFileSync(file, 'utf8')); }
catch (e) { console.error(`appinfo.json inválido ou ausente em ${dir}: ${e.message}`); process.exit(1); }
const missing = ['id', 'title', 'type', 'main', 'icon', 'version'].filter(k => !info[k]);
if (missing.length) { console.error(`appinfo.json: campo(s) obrigatório(s) ausente(s): ${missing.join(', ')}`); process.exit(1); }
const absent = ['main', 'icon', 'largeIcon'].filter(k => info[k] && !fs.existsSync(path.resolve(dir, info[k])));
if (absent.length) { console.error(`appinfo.json: arquivo(s) não encontrado(s): ${absent.map(k => `${k}=${info[k]}`).join(', ')}`); process.exit(1); }
EOF
fi

# Uma instância por vez: libera as portas e o Xvfb anteriores.
pkill -f "[s]quashfs-root/webOS_TV_26_Simulator" 2>/dev/null
if [ -f /tmp/webos-sim-xvfb.pid ]; then
  kill "$(cat /tmp/webos-sim-xvfb.pid)" 2>/dev/null
  rm -f /tmp/webos-sim-xvfb.pid
fi
sleep 1

# Xvfb próprio (não xvfb-run, que deixa o Xvfb órfão quando é encerrado).
DISPLAY_NUM="${WEBOS_SIM_DISPLAY:-:77}"
nohup Xvfb "$DISPLAY_NUM" -screen 0 1920x1080x24 -nolisten tcp > /dev/null 2>&1 < /dev/null &
echo $! > /tmp/webos-sim-xvfb.pid
for _ in $(seq 1 20); do
  [ -e "/tmp/.X11-unix/X${DISPLAY_NUM#:}" ] && break
  sleep 0.2
done

cd "$SIM_DIR" || exit 1
# A pasta do app precisa ser o primeiro argumento (o Simulator lê process.argv[1]).
DISPLAY="$DISPLAY_NUM" nohup "$SIM_BIN" "$@" \
  --no-sandbox --ozone-platform=x11 \
  --remote-debugging-port="$CDP_PORT" --inspect="$INSPECT_PORT" \
  > "$LOG" 2>&1 < /dev/null &

for _ in $(seq 1 30); do
  curl -s "http://127.0.0.1:$CDP_PORT/json/version" > /dev/null && exit 0
  sleep 1
done
echo "Simulator não respondeu na porta $CDP_PORT; veja $LOG" >&2
exit 1
