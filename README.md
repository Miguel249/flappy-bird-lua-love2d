# 🎮 Flappy Bird OOP - Love2D

Un clon del clásico **Flappy Bird**, desarrollado con **Lua** y el framework **LÖVE2D**, utilizando un enfoque limpio de **programación orientada a objetos (OOP)**. Este proyecto está diseñado desde cero sin librerías externas, y con recursos visuales personalizados en estilo pixel art.

---

## 📸 Captura de Pantalla

![Captura del menú](assets/examples/screenshot_menu.png)

---

## ✨ Características

- 🐤 Mecánica de juego fluida tipo Flappy Bird
- 🧱 Obstáculos generados dinámicamente
- 💥 Colisiones con tubos, suelo y techo
- 🎨 Pixel art propio y estilo visual profesional
- 🖼️ Menú principal con botones personalizados:
  - Iniciar juego
  - Salir
- 🔄 Estados del juego:
  - Menú
  - Jugando
  - Game Over
- 🖱️ Controles intuitivos:
  - Click del mouse o tecla **espacio** para saltar

---

## 🗂️ Estructura del Proyecto

``` plaintext
flappy-bird-lua-love2d/
│
├── assets/
│   └── examples/
│       └── screenshot_menu.png
│   └── ui/
│       ├── background.png
│       ├── button_exit_hover.png
│       ├── button_exit.png
│       ├── button_play_hover.png
│       ├── button_play.png
│       └── logo.png
│
├── src/
│   ├── Bird.lua
│   ├── GameState.lua
│   └── Pipe.lua
│
├── .luarc.json
├── conf.lua
├── main.lua
└── README.md
```

---

## 🚀 Requisitos

- [Love2D](https://love2d.org/) (versión 11.x recomendada)

---

## ▶️ Cómo Ejecutar

Abre una terminal en la carpeta del proyecto y ejecuta:

```bash
love .
```

**Alternativa:** Si `love` no está en tu PATH, arrastra la carpeta del proyecto directamente al ejecutable de LÖVE2D.

---

## 🛠️ Tecnologías Usadas

- **Lenguaje:** Lua
- **Motor:** Love2D
- **Paradigma:** Programación orientada a objetos (con clases simples)
- **Recursos visuales:** Pixel art personalizado

---

## 🎮 Controles

| Acción | Tecla/Mouse |
|--------|-------------|
| Saltar | `Espacio` o `Click izquierdo` |
| Menú   | `Escape` (desde el juego) |

---

## 📁 Descripción de Archivos

### Clases Principales (src/)

- Bird.lua - Lógica del pájaro (física, animación, colisiones)
- Pipe.lua - Tubo individual con detección de colisiones
- GameState.lua - Gestión de estados del juego (Menú, Jugando, Game Over)

### Configuración

- conf.lua - Configuración de ventana y Love2D
- main.lua - Punto de entrada principal del juego
- .luarc.json - Configuración del entorno Lua para desarrollo

---

## 🚧 Características Futuras

- Sistema de puntuación
- Efectos de sonido
- Música de fondo
- Mejores animaciones
- Sistema de records/highscores

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Puedes usar el código como base para tus propios juegos o estudios.

---

## 🙌 Créditos

**Desarrollado por:** Miguel Angel Charris Carmona
**Sprites y diseño gráfico:** Hechos a mano para este proyecto

---

## 🐛 Reportar Bugs

Si encuentras algún error o tienes sugerencias, puedes:

- Abrir un issue en este repositorio
- Contactarme directamente

¡Gracias por jugar! 🎮
