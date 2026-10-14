#!/usr/bin/env bash
# Sube a IONOS (producción) ficheros de la web por SFTP y comprueba la web en vivo.
#
# Uso:
#   scripts/deploy.sh USUARIO_SFTP HOST_SFTP [CARPETA_REMOTA] [DOMINIO] [-- fichero ...]
#
# Ejemplos:
#   scripts/deploy.sh u123456 access-xxxx.webspace-host.com . victoriasmashburger.es
#   scripts/deploy.sh u123456 access-xxxx.webspace-host.com . victoriasmashburger.es -- assets/menus/menu-smash.pdf
#
# Sin lista de ficheros sube index.html y assets/css/style.css.
# Las rutas son relativas a la raíz del repo y se suben a la misma ruta en IONOS.
# La contraseña se pide en el terminal; no se guarda en ningún sitio.
set -euo pipefail

USER_SFTP=${1:?usuario SFTP}; HOST=${2:?host SFTP}
shift 2
DIR=.; DOMAIN=
if [ $# -gt 0 ] && [ "$1" != "--" ]; then DIR=$1; shift; fi
if [ $# -gt 0 ] && [ "$1" != "--" ]; then DOMAIN=$1; shift; fi
[ "${1:-}" = "--" ] && shift
FILES=("$@")
[ ${#FILES[@]} -eq 0 ] && FILES=(index.html assets/css/style.css)

DOMAIN=${DOMAIN#http://}; DOMAIN=${DOMAIN#https://}; DOMAIN=${DOMAIN%/}
SITE="$(cd "$(dirname "$0")/.." && pwd)"

for f in "${FILES[@]}"; do
  [ -f "$SITE/$f" ] || { echo "No existe: $f" >&2; exit 1; }
done

BATCH=$(mktemp); trap 'rm -f "$BATCH"' EXIT
echo "cd $DIR" > "$BATCH"
for f in "${FILES[@]}"; do
  echo "put \"$SITE/$f\" \"$f\"" >> "$BATCH"
done
for f in "${FILES[@]}"; do
  echo "ls -l \"$f\"" >> "$BATCH"
done

# Sin -b: -b fuerza BatchMode y no deja escribir la contraseña.
sftp "$USER_SFTP@$HOST" < "$BATCH"

if [ -n "$DOMAIN" ]; then
  echo "--- Comprobando https://$DOMAIN"
  for f in "${FILES[@]}"; do
    path=$f; [ "$f" = index.html ] && path=
    if curl -fsSL "https://$DOMAIN/$path?nocache=$(date +%s)" | cmp -s - "$SITE/$f"; then
      echo "OK      $f"
    else
      echo "DISTINTO $f  (caché, carpeta equivocada o subida fallida)"
    fi
  done
fi
