#!/bin/zsh
set -e

ROOT="$HOME/Documents/ComfyUI"

# Comprobar que existe la instalación
if [ ! -f "$ROOT/main.py" ]; then
  osascript -e 'display alert "No encuentro ComfyUI en ~/Documents/ComfyUI.\nAjusta la ruta dentro del script si está en otro sitio." as warning'
  exit 1
fi

cd "$ROOT"

# Activa venv si existe (si no, arrancará con python3 del sistema)
if [ -d "venv" ]; then
  source "venv/bin/activate" 2>/dev/null || true
fi

# Lanza ComfyUI en segundo plano (sin bloquear)
nohup python3 main.py >/dev/null 2>&1 &

# Espera a que el servidor responda y abre el navegador
for i in {1..90}; do
  if /usr/bin/curl -sf "http://127.0.0.1:8188" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

open "http://127.0.0.1:8188"
