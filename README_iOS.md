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

```bash
set -e
ROOT="$HOME/Documents/ComfyUI"

if [ ! -f "$ROOT/main.py" ]; then
  osascript -e 'display alert "No encuentro ComfyUI en ~/Documents/ComfyUI.\nAjusta la ruta dentro del script si está en otro sitio." as warning'
  exit 1
fi

cd "$ROOT"

if [ -d "venv" ]; then
  source "venv/bin/activate" 2>/dev/null || true
fi

nohup python3 main.py >/dev/null 2>&1 &

for i in {1..90}; do
  if /usr/bin/curl -sf "http://127.0.0.1:8188" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

open "http://127.0.0.1:8188"
