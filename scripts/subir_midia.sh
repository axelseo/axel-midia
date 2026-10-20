#!/usr/bin/env bash
# Sobe um vídeo (e opcionalmente a capa) para o repositório público axel-midia,
# para servir de URL pública que a Meta consegue baixar.
#
# Uso:
#   scripts/subir_midia.sh <codigo> <arquivo.mp4> [arquivo-capa.jpg]
#
# Exemplo:
#   scripts/subir_midia.sh A5 "~/Downloads/.../Reels-A5-...mp4" "~/Downloads/.../Capa-A5-...jpg"
#
# O <codigo> vira o nome do arquivo em /v/<codigo>.mp4 e /c/<codigo>.jpg.
# Só ASCII, sem espaço, sem acento (ex.: A1, B10, K3).
#
# O script copia, confere, faz commit e dá push. Depois disso a URL pública é:
#   https://axelseo.github.io/axel-midia/v/<codigo>.mp4
#   https://axelseo.github.io/axel-midia/c/<codigo>.jpg
#
# As entradas correspondentes em agenda.json (no repo axel-social-direto)
# precisam ser adicionadas à parte, manualmente.

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Uso: $0 <codigo> <arquivo.mp4> [arquivo-capa.jpg]" >&2
  exit 1
fi

CODIGO="$1"
VIDEO="$2"
CAPA="${3:-}"

# Valida que o código é só ASCII (letras e números), sem espaço nem acento.
if ! [[ "$CODIGO" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "Código inválido: '$CODIGO'. Use só letras/números ASCII, sem espaço ou acento (ex.: A1, K10)." >&2
  exit 1
fi

if [ ! -f "$VIDEO" ]; then
  echo "Vídeo não encontrado: $VIDEO" >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_V="$REPO_DIR/v/${CODIGO}.mp4"

cp "$VIDEO" "$DEST_V"
echo "Copiado: $DEST_V"

if [ -n "$CAPA" ]; then
  if [ ! -f "$CAPA" ]; then
    echo "Capa não encontrada: $CAPA" >&2
    exit 1
  fi
  DEST_C="$REPO_DIR/c/${CODIGO}.jpg"
  cp "$CAPA" "$DEST_C"
  echo "Copiado: $DEST_C"
fi

cd "$REPO_DIR"
git add "v/${CODIGO}.mp4"
[ -n "$CAPA" ] && git add "c/${CODIGO}.jpg"

if git diff --cached --quiet; then
  echo "Nada novo para commitar (arquivo já estava igual no repositório)."
else
  git commit -m "Sobe mídia ${CODIGO}"
  git push
  echo "Enviado. URL pública:"
  echo "  https://axelseo.github.io/axel-midia/v/${CODIGO}.mp4"
  [ -n "$CAPA" ] && echo "  https://axelseo.github.io/axel-midia/c/${CODIGO}.jpg"
  echo ""
  echo "Lembrete: o GitHub Pages leva alguns minutos para publicar depois do push."
  echo "Confira com: curl -I https://axelseo.github.io/axel-midia/v/${CODIGO}.mp4"
fi
