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

# === Iniciar ComfyUI (ruta fija y zsh compatible) ===
set -e
set -o pipefail

# Ruta exacta de tu instalación
ROOT="/Users/lucaselser/Documents/ComfyUI"

# Verificar que existe main.py
if [ ! -f "$ROOT/main.py" ]; then
  osascript -e 'display alert "No encuentro ComfyUI en /Users/lucaselser/Documents/ComfyUI.\nRevisa la ruta o ajusta el script." as warning'
  exit 1
fi

cd "$ROOT"

# Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
  /usr/bin/python3 -m venv venv
fi

# Activar entorno virtual (si existe)
if [ -f "venv/bin/activate" ]; then
  source "venv/bin/activate"
fi

# Lanzar ComfyUI en segundo plano
nohup python3 main.py >/tmp/comfyui.log 2>&1 &

# Esperar hasta que el servidor responda y abrir navegador
URL="http://127.0.0.1:8188"
COUNT=0
MAX_WAIT=90

while [ $COUNT -lt $MAX_WAIT ]; do
  if /usr/bin/curl -sf --max-time 1 "$URL" >/dev/null 2>&1; then
    break
  fi
  COUNT=$((COUNT + 1))
  sleep 1
done

open "$URL"
