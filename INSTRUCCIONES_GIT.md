# 📚 Guía para subir el proyecto a GitHub

## Paso 1: Crear repositorio en GitHub

1. Ve a https://github.com
2. Inicia sesión en tu cuenta
3. Haz clic en el botón **"New"** o **"+"** → **"New repository"**
4. Configura tu repositorio:
   - **Repository name**: `app-electoral-peru-2026` (o el nombre que prefieras)
   - **Description**: "Aplicación móvil para las Elecciones Presidenciales Perú 2026"
   - **Public** o **Private** (elige según prefieras)
   - ❌ NO marques "Initialize this repository with a README" (ya tenemos uno)
5. Haz clic en **"Create repository"**

## Paso 2: Configurar Git localmente

Abre tu terminal en la carpeta del proyecto y ejecuta:

### 2.1 Inicializar Git (si no está inicializado)
```bash
git init
```

### 2.2 Configurar tu identidad (si es primera vez)
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-email@ejemplo.com"
```

## Paso 3: Preparar archivos

### 3.1 Agregar todos los archivos
```bash
git add .
```

### 3.2 Hacer el primer commit
```bash
git commit -m "Initial commit: App Electoral Perú 2026"
```

## Paso 4: Conectar con GitHub

Reemplaza `TU_USUARIO` con tu nombre de usuario de GitHub:

```bash
git remote add origin https://github.com/TU_USUARIO/app-electoral-peru-2026.git
```

## Paso 5: Subir el código

### 5.1 Cambiar a la rama main (si es necesario)
```bash
git branch -M main
```

### 5.2 Subir los archivos
```bash
git push -u origin main
```

Si te pide autenticación:
- **Usuario**: Tu nombre de usuario de GitHub
- **Contraseña**: Usa un **Personal Access Token** (no tu contraseña)

### Crear Personal Access Token:
1. Ve a GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Selecciona: `repo` (todos los permisos de repositorio)
4. Copia el token y úsalo como contraseña

## 🎉 ¡Listo!

Tu proyecto ahora está en GitHub. Puedes verlo en:
```
https://github.com/TU_USUARIO/app-electoral-peru-2026
```

## 📝 Comandos útiles para el futuro

### Agregar cambios nuevos
```bash
git add .
git commit -m "Descripción de los cambios"
git push
```

### Ver estado de los archivos
```bash
git status
```

### Ver historial de commits
```bash
git log
```

### Crear una nueva rama
```bash
git checkout -b nombre-de-rama
```

### Cambiar de rama
```bash
git checkout main
```

## ⚠️ IMPORTANTE: Seguridad

Antes de subir, verifica que:

1. ✅ El archivo `.gitignore` está creado
2. ✅ Tu API key de Gemini NO está en el código
3. ✅ No hay información sensible (contraseñas, tokens, etc.)

Si accidentalmente subiste una API key:
1. Revoca la API key inmediatamente en Google AI Studio
2. Crea una nueva API key
3. Actualiza tu código local
4. Sube los cambios

## 🔄 Actualizar el repositorio después de cambios

```bash
# 1. Ver qué archivos cambiaron
git status

# 2. Agregar los cambios
git add .

# 3. Hacer commit con mensaje descriptivo
git commit -m "Descripción de lo que cambiaste"

# 4. Subir a GitHub
git push
```

## 🌿 Trabajar con ramas (opcional pero recomendado)

```bash
# Crear rama para nueva funcionalidad
git checkout -b feature/nueva-funcionalidad

# Hacer cambios y commits
git add .
git commit -m "Agregar nueva funcionalidad"

# Subir la rama
git push -u origin feature/nueva-funcionalidad

# Luego en GitHub puedes crear un Pull Request para fusionar con main
```

## 📱 Clonar el repositorio en otro dispositivo

```bash
git clone https://github.com/TU_USUARIO/app-electoral-peru-2026.git
cd app-electoral-peru-2026
flutter pub get
```

## 🆘 Solución de problemas comunes

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/TU_USUARIO/app-electoral-peru-2026.git
```

### Error: "failed to push some refs"
```bash
git pull origin main --rebase
git push
```

### Deshacer último commit (sin perder cambios)
```bash
git reset --soft HEAD~1
```

### Ver diferencias antes de commit
```bash
git diff
```

---

¿Necesitas ayuda? Abre un issue en el repositorio o consulta la documentación de Git: https://git-scm.com/doc
