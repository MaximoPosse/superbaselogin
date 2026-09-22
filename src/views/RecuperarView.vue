<script setup>
import { ref } from 'vue'
import { supabase } from '@/supabase'

const correo = ref('')
const cargando = ref(false)
const mensaje = ref('')
const envioExitoso = ref(false)

async function enviarCorreo() {
  mensaje.value = ''
  envioExitoso.value = false
  try {
    cargando.value = true
    const { error } = await supabase.auth.resetPasswordForEmail(correo.value, {
      redirectTo: `${window.location.origin}/restablecer`,
    })
    if (error) {
      throw error
    }
    envioExitoso.value = true
    mensaje.value =
      'Te enviamos un correo electrónico para restablecer tu contraseña.'
    correo.value = ''
  } catch (error) {
    mensaje.value = error.message
  } finally {
    cargando.value = false
  }
}
</script>

<template>
  <main class="pagina-recuperar">
    <section class="tarjeta-recuperar">
      <h1>Recuperar contraseña</h1>
      <p class="descripcion">
        Escribí tu correo y te enviamos un enlace para crear una contraseña
        nueva.
      </p>
      <form @submit.prevent="enviarCorreo">
        <div class="campo">
          <label for="correo">Correo electrónico</label>
          <input
            id="correo"
            v-model="correo"
            type="email"
            placeholder="nombre@correo.com"
            autocomplete="email"
            required
          />
        </div>
        <button type="submit" :disabled="cargando">
          {{ cargando ? 'Enviando...' : 'Enviar enlace' }}
        </button>
      </form>
      <p
        v-if="mensaje"
        class="mensaje"
        :class="{ exito: envioExitoso, error: !envioExitoso }"
      >
        {{ mensaje }}
      </p>
      <p class="enlace-registro">
        <RouterLink to="/login">Volver a iniciar sesión</RouterLink>
      </p>
    </section>
  </main>
</template>