# login-supabase

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VS Code](https://code.visualstudio.com/) + [Vue (Official)](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Recommended Browser Setup

- Chromium-based browsers (Chrome, Edge, Brave, etc.):
  - [Vue.js devtools](https://chromewebstore.google.com/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)
  - [Turn on Custom Object Formatter in Chrome DevTools](http://bit.ly/object-formatters)
- Firefox:
  - [Vue.js devtools](https://addons.mozilla.org/en-US/firefox/addon/vue-js-devtools/)
  - [Turn on Custom Object Formatter in Firefox DevTools](https://fxdx.dev/firefox-devtools-custom-object-formatters/)

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Project Setup

```sh
npm install
```

Crear `.env.local` en la carpeta del proyecto con los valores del proyecto
Supabase:

```dotenv
VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=tu-clave-publicable
```

En el SQL Editor de Supabase, ejecutar [`supabase/setup.sql`](supabase/setup.sql).
Configura la tabla `productos`, políticas RLS por usuario y el bucket público
`productos` para imágenes JPG, PNG o WEBP de hasta 5 MB.

En Supabase Authentication, usar `http://localhost:5173` como Site URL y
permitirla en Redirect URLs para confirmación y recuperación de contraseña.
Si la tabla ya tiene productos sin `user_id`, hacer una copia y asignar cada fila
a la cuenta propietaria antes de probar: las políticas RLS ocultan filas sin
propietario.

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```
