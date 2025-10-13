# 🛠️ ComfyUI – Crear app de recuperación (“Recovery”) en macOS

Esta guía te permite crear una aplicación llamada  
**Recovery ComfyUI.app**, que repara tu instalación de ComfyUI  
si deja de funcionar tras una actualización, error o cambio de sistema.

---

## 🧠 ¿Qué hace esta app?

- Comprueba si ComfyUI está instalado correctamente en tu Mac.  
- Restaura el entorno de ejecución de Python (venv) si se ha dañado o borrado.  
- Reinstala las dependencias necesarias (`torch`, `gradio`, etc.) compatibles con tu Mac.  
- Si el proyecto se instaló desde GitHub, actualiza los archivos del repositorio.  
- Muestra una notificación cuando la recuperación termina.

> 💡 Piensa en ella como el “**modo Recovery de ComfyUI**”:  
> no borra nada, no cambia tus flujos ni modelos,  
> simplemente repara el entorno para que vuelva a arrancar correctamente.

---

## 🧩 Cuándo usarla

Solo necesitas abrir **Recovery ComfyUI.app** si ocurre alguno de estos casos:

| Situación | ¿Usar Recovery? |
|------------|-----------------|
| ComfyUI no arranca o muestra errores raros de librerías | ✅ Sí |
| macOS o Python se han actualizado | ✅ Sí |
| Se ha borrado o movido la carpeta `venv` | ✅ Sí |
| Se han añadido nodos nuevos que rompen dependencias | ✅ Sí |
| Todo funciona normalmente | ❌ No hace falta |

---

## 🧱 Cómo crear la app en Automator

1️⃣ Abre **Automator** → **Nueva aplicación**.  
2️⃣ En el buscador (izquierda), escribe **“Ejecutar script de Shell”** y arrastra la acción al área principal.  
3️⃣ Configura:
   - **Shell:** `/bin/zsh`  
   - **Pasar entrada:** *ninguna*  
4️⃣ Copia y pega el siguiente script:

```bash
set -e
ROOT="$HOME/Documents/ComfyUI"
cd "$ROOT" 2>/dev/null || {
  osascript -e 'display alert "No encuentro ~/Documents/ComfyUI.\nAsegúrate de que está ahí o ajusta la ruta dentro del script." as warning'
  exit 1
}

# === ComfyUI Recovery ===

# 1. Si hay repo Git, sincroniza código
if [ -d ".git" ]; then
  git pull --ff-only || true
fi

# 2. Crear o reparar entorno virtual
if [ ! -d "venv" ]; then
  /usr/bin/python3 -m venv venv || python3 -m venv venv
fi
source "venv/bin/activate" 2>/dev/null || true

# 3. Reinstalar pip y dependencias
python -m pip install --upgrade pip >/dev/null 2>&1 || true
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt >/dev/null 2>&1 || true
fi

# 4. Reinstalar PyTorch (compatible con Apple Silicon o Intel)
pip install -U torch torchvision >/dev/null 2>&1 || true

# 5. Notificación final
osascript -e 'display notification "ComfyUI se ha recuperado correctamente" with title "ComfyUI Recovery" subtitle "Entorno reparado y actualizado"'
