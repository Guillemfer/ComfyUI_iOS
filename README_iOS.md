# 🧠 ComfyUI – Crear app de inicio rápido en macOS

Esta guía te permite crear una **aplicación de doble clic** para lanzar ComfyUI en tu Mac,  
sin abrir Terminal ni usar comandos.

---

## 🚀 ¿Qué vas a conseguir?

Una app llamada **iOS_ComfyUI.app** que:
- Abre ComfyUI automáticamente.
- Espera a que esté listo y abre el navegador en `http://127.0.0.1:8188`.
- No muestra ventana de Terminal.
- Funciona en cualquier Mac (Intel o Apple Silicon).

---

## 🧩 Qué necesitas

- ComfyUI ya instalado en:  
  `~/Documents/ComfyUI`  
  (Si lo tienes en otra carpeta, podrás cambiar la ruta más abajo).
- macOS 12 o superior (Ventura, Sonoma, Sequoia…)
- Python 3 instalado (lo normal en todos los Macs modernos)

---

## 🧱 Pasos para crear la app (solo una vez)

1️⃣ Abre **Automator** (búscalo con Spotlight o en Aplicaciones).  
2️⃣ Clic en **“Nueva aplicación”**.  
3️⃣ En la izquierda, busca **“Ejecutar script de Shell”** y arrástralo al área principal.  
4️⃣ En la parte superior del bloque:
   - **Shell:** `/bin/zsh`  
   - **Pasar entrada:** *ninguna*  
5️⃣ Copia y pega el siguiente script:

# Iniciar ComfyUI (Automator, zsh)
set -e
set -o pipefail

# 1) Detectar carpeta (Documents o Documentos)
ROOT="$HOME/Documents/ComfyUI"
if [ ! -d "$ROOT" ]; then
  ALT="$HOME/Documentos/ComfyUI"
  if [ -d "$ALT" ]; then
    ROOT="$ALT"
  fi
fi

# 2) Validar que existe main.py
if [ ! -f "$ROOT/main.py" ]; then
  osascript -e 'display alert "No encuentro ComfyUI en:\n~/Documents/ComfyUI\nni en ~/Documentos/ComfyUI.\n\nAjusta la ruta en la app de Automator." as warning'
  exit 1
fi

cd "$ROOT"

# 3) Localizar python3
PY="/usr/bin/python3"
if ! [ -x "$PY" ]; then
  if command -v python3 >/dev/null 2>&1; then
    PY="$(command -v python3)"
  else
    osascript -e 'display alert "No se encontró python3 en el sistema." as critical'
    exit 1
  fi
fi

# 4) Crear/activar venv (idempotente)
if [ ! -d "venv" ]; then
  "$PY" -m venv venv
fi
if [ -f "venv/bin/activate" ]; then
  source "venv/bin/activate"
fi

# 5) Lanzar ComfyUI en background (silencioso)
nohup python main.py >/tmp/comfyui.log 2>&1 &

# 6) Esperar a que el puerto responda y abrir navegador
URL="http://127.0.0.1:8188"
for i in {1..120}; do
  if /usr/bin/curl -sf --max-time 1 "$URL" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

open "$URL"
