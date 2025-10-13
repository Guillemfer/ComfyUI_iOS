# 🎨 ComfyUI – Añadir el icono a tus apps en macOS

Puedes usar la imagen **comfyuilogo.png** incluida en esta carpeta  
para personalizar el icono de las apps:

- 🟢 `Iniciar ComfyUI.app`  
- 🛠️ `Recovery ComfyUI.app`

---

## 🧩 Opción 1 — Método rápido (recomendado)

macOS permite usar **cualquier imagen PNG** como icono de una aplicación.

1️⃣ Abre el archivo `comfyuilogo.png` con **Vista Previa (Preview)**.  
2️⃣ Pulsa `⌘ + A` (seleccionar todo).  
3️⃣ Pulsa `⌘ + C` (copiar).  
4️⃣ Haz clic derecho sobre tu app (`Iniciar ComfyUI.app` o `Recovery ComfyUI.app`) → **Obtener información (⌘ + I)**.  
5️⃣ Haz un clic sobre el icono pequeño que aparece arriba a la izquierda (debería quedar resaltado).  
6️⃣ Pulsa `⌘ + V` para **pegar** el icono.  

✅ ¡Listo! La app ahora mostrará el nuevo icono en el Finder y el Dock.

---

## 🧩 Opción 2 — Crear un icono `.icns` (opcional)

Si prefieres un formato profesional de icono, puedes convertir el PNG a `.icns`.

1️⃣ En un Mac, abre **Terminal**.  
2️⃣ Coloca `comfyuilogo.png` en el Escritorio.  
3️⃣ Ejecuta estos comandos:

```bash
mkdir -p ~/Desktop/icon.iconset
sips -z 16 16     ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_16x16.png
sips -z 32 32     ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_16x16@2x.png
sips -z 32 32     ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_32x32.png
sips -z 64 64     ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_32x32@2x.png
sips -z 128 128   ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_128x128.png
sips -z 256 256   ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_128x128@2x.png
sips -z 256 256   ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_256x256.png
sips -z 512 512   ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_256x256@2x.png
sips -z 512 512   ~/Desktop/comfyuilogo.png --out ~/Desktop/icon.iconset/icon_512x512.png
cp ~/Desktop/comfyuilogo.png ~/Desktop/icon.iconset/icon_512x512@2x.png
iconutil -c icns ~/Desktop/icon.iconset
