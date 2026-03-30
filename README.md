# 🐻 BearWithMe - Tu Acompañante Terapéutico con IA

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Groq](https://img.shields.io/badge/AI-Groq%20Llama%203-orange?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)

**BearWithMe** es una aplicación de bienestar emocional impulsada por Inteligencia Artificial que utiliza protocolos de **Terapia Cognitivo-Conductual (TCC)** para ayudarte a navegar tus emociones, identificar distorsiones cognitivas y mejorar tu salud mental diaria.

---

## ✨ Características Principales

- **🤖 Terapeuta IA Experto**: Conversaciones fluidas basadas en TCC impulsadas por Llama 3 (vía Groq) para una respuesta ultra rápida.
- **📊 Reportes Clínicos PDF**: Generación automática de informes de evolución emocional y patrones de pensamiento detectados.
- **🧠 Análisis de Personalidad**: Test integrado basado en MBTI para personalizar la experiencia terapéutica.
- **📔 Diario de Ánimo**: Registro interactivo de emociones con seguimiento histórico.
- **🎮 Tareas Cognitivas**: Ejercicios diseñados para mejorar el procesamiento emocional y la atención.
- **🎨 Interfaz Fluida**: Experiencia de usuario inmersiva con fondos dinámicos y micro-animaciones.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **IA**: Groq Cloud API (Llama 3.3 70B)
- **Estado**: Provider / Services Pattern
- **Persistencia**: Firebase / Local Preferences
- **Estilo**: Custom Theme con animaciones avanzadas (AnimateDo, Lottie)

---

## 🚀 Instalación y Configuración

Sigue estos pasos para ejecutar el proyecto localmente:

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/bear_with_me.git
cd bear_with_me
```

### 2. Configurar variables de entorno
Crea un archivo llamado `env` en la raíz del proyecto (o usa el comando `cp env.example env` si existe) y añade tu API Key de Groq:

```env
GROQ_API_KEY=tu_api_key_aqui
```

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Ejecutar la aplicación
```bash
flutter run
```

---

## 📸 Capturas de Pantalla

| Login | Chat Terapéutico | Diario de Ánimo |
| :---: | :---: | :---: |
| ![Login](https://via.placeholder.com/200x400?text=Login) | ![Chat](https://via.placeholder.com/200x400?text=Chat) | ![Mood](https://via.placeholder.com/200x400?text=Mood) |

---

## 📝 Roadmap

- [ ] Integración de análisis de voz.
- [ ] Modo de meditación guiada por IA.
- [ ] Sincronización con dispositivos vestibles (Apple Health / Google Fit).
- [ ] Soporte multi-idioma completo.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE](LICENSE) para detalles.

---

Desarrollado con ❤️ por el equipo de **BearWithMe**. Si te gusta este proyecto, ¡danos una ⭐ en GitHub!
