#!/bin/bash
# Prepara o webOS TV Simulator 26 + ares-cli em sessões do Claude Code na nuvem.
# Idempotente: cada etapa só roda se o resultado ainda não existir.
# Baixar o Simulator implica aceitar a LG SDK License Agreement
# (https://webostv.developer.lge.com/develop/tools/simulator-installation).
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

SIM_NAME="webOS_TV_26_Simulator_1.5.0"
SIM_FILE_ID="RF00021103"   # id do ${SIM_NAME}_linux.zip no site da LG; muda a cada versão
SIM_ROOT="/opt/webos-sim"
SIM_DIR="$SIM_ROOT/$SIM_NAME/squashfs-root"
WRAPPER_DIR="$HOME/.local/share/webos-simulator"
LAUNCHER="$CLAUDE_PROJECT_DIR/.agents/skills/webos-tv/scripts/sim-linux-launcher.sh"

# 1. ares-cli
if ! command -v ares-launch > /dev/null; then
  npm install -g @webos-tools/cli
fi

# 2. Simulator (zip Linux da LG → AppImage extraído, sem FUSE)
if [ ! -x "$SIM_DIR/$SIM_NAME" ]; then
  mkdir -p "$SIM_ROOT"
  ua='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/130 Safari/537.36'
  enc=$(curl -fsS -X POST https://webostv.developer.lge.com/api/downloadSDK \
    -H 'Content-Type: application/json' -d "{\"fileId\":\"$SIM_FILE_ID\"}" |
    node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>console.log(JSON.parse(s).fileIdEnc))')
  url=$(curl -fsS -X POST https://developer.lge.com/common/file/DownloadFilePath.ajax \
    -H 'Origin: https://webostv.developer.lge.com' -H 'Referer: https://webostv.developer.lge.com/' \
    -H "User-Agent: $ua" --data-urlencode "fileId=$enc" |
    grep -oE 'gftsUrl="[^"]+"' | cut -d'"' -f2 | sed 's/&amp;/\&/g')
  curl -fsS -L -o "$SIM_ROOT/sim.zip" -H 'Referer: https://webostv.developer.lge.com/' "$url"
  unzip -q -o "$SIM_ROOT/sim.zip" -d "$SIM_ROOT"
  rm -f "$SIM_ROOT/sim.zip"
  (cd "$SIM_ROOT/$SIM_NAME" && chmod +x "$SIM_NAME.AppImage" &&
    "./$SIM_NAME.AppImage" --appimage-extract > /dev/null && rm -f "$SIM_NAME.AppImage")
fi

# 3. ares-launch -s 26 → lançador headless (Xvfb + CDP)
mkdir -p "$WRAPPER_DIR" "$HOME/.webos/tv"
chmod +x "$LAUNCHER"
ln -sfn "$LAUNCHER" "$WRAPPER_DIR/$SIM_NAME.appimage"
echo "{\"26\": \"$WRAPPER_DIR\"}" > "$HOME/.webos/tv/simulator-config.json"

# 4. Confiança do Chromium do Simulator nas CAs do proxy de saída do container (NSS),
#    para apps que buscam dados por HTTPS funcionarem.
if ! command -v certutil > /dev/null; then
  (apt-get install -y -q libnss3-tools > /dev/null 2>&1 ||
    (apt-get update -q > /dev/null 2>&1 && apt-get install -y -q libnss3-tools > /dev/null 2>&1)) || true
fi
if command -v certutil > /dev/null && [ -f /root/.ccr/ca-bundle.crt ]; then
  nssdb="$HOME/.pki/nssdb"
  mkdir -p "$nssdb"
  [ -f "$nssdb/cert9.db" ] || certutil -d "sql:$nssdb" -N --empty-password
  tmp=$(mktemp -d)
  awk -v d="$tmp" '/BEGIN CERT/{n++} n{print > (d "/" n ".pem")}' /root/.ccr/ca-bundle.crt
  for pem in "$tmp"/*.pem; do
    if openssl x509 -noout -subject -in "$pem" 2>/dev/null | grep -q 'O *= *Anthropic'; then
      certutil -d "sql:$nssdb" -A -t "C,," -n "ccr-proxy-ca-$(basename "$pem" .pem)" -i "$pem"
    fi
  done
  rm -rf "$tmp"
fi
