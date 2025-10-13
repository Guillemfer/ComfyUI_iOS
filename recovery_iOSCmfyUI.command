#!/bin/zsh
set -e

ROOT="$HOME/Documents/ComfyUI"

# Comprobar que existe ComfyUI
if [ ! -d "$ROOT" ]; then
  osascript -e 'display alert "No encuentro la carpeta ~/Documents/ComfyUI.\nAsegúrate de que está en ese lugar o ajusta la ruta dentro del script." as warning'
  exit 1
fi

cd "$ROOT"

# Si es un repo git, actualiza el código
if [ -d ".git" ]; then
  git pull --ff-only || true
fi

# (Re)crear entorno virtual si no existe
if [ ! -d "venv" ]; then
  /usr/bin/python3 -m venv venv || python3 -m venv venv
fi
source "venv/bin/activate" 2>/dev/null || true

# Actualiza pip y dependencias
python -m pip install --upgrade pip >/dev/null 2>&1 || true
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt >/dev/null 2>&1 || true
fi

# Actualiza PyTorch si procede
pip install -U torch torchvision >/dev/null 2>&1 || true

osascript -e 'display notification "ComfyUI actualizado correctamente" with title "ComfyUI" subtitle "Dependencias sincronizadas"'
