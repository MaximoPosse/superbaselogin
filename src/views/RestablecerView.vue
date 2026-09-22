<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/supabase'

const router = useRouter()
const contrasena = ref('')
const repetirContrasena = ref('')
const cargando = ref(false)
const mensaje = ref('')
const mostrandoFormulario = ref(false)
const restablecimientoExitoso = ref(false)

let quitarSuscripcion

function activarManejoAuth() {
  const { data } = supabase.auth.onAuthStateChange((evento) => {
    if (evento === 'PASSWORD_RECOVERY') {
      mostrandoFormulario.value = true
    }
  })
  quitarSuscripcion = data.subscription.unsubscribe
}

onMounted(async () => {
  activarManejoAuth()
  const {
    data: { session },
  } = await supabase.auth.getSession()
  if (session) {
    mostrandoFormulario.value = true
  }
})

onUnmounted(() => {
  if (quitarSuscripcion) {
    quitarSuscripcion()
  }
})

async function restablecerContrasena() {
  mensaje.value = ''
  restablecimientoExitoso.value = false
  if (contrasena.value !== repetirContrasena.value) {
    mensaje.value = 'Las contraseñas no coinciden.'
    return
  }
  if (contrasena.value.length < 6) {
    mensaje.value = 'La contraseña debe tener al menos 6 caracteres.'
    return
  }
  try {
    cargando.value = true
    const { error } = await supabase.auth.updateUser({
      password: contrasena.value,
    })
    if (error) {
      throw error
    }
    restablecimientoExitoso.value = true
    mensaje.value = 'Contraseña actualizada. Ya podés iniciar sesión.'
    setTimeout(() => router.push('/login'), 2000)
  } catch (error) {
    mensaje.value = error.message
  } finally {
    cargando.value = false
  }
}
</script>

<template>
  <main class="pagina-restablecer">
    <section class="tarjeta-restablecer">
      <template v-if="mostrandoFormulario">
        <h1>Crear contraseña nueva</h1>
        <p class="descripcion">
          Escribí la nueva contraseña para tu cuenta.
        </p>
        <form @submit.prevent="restablecerContrasena">
          <div class="campo">
            <label for="contrasena">Contraseña nueva</label>
            <input
              id="contrasena"
              v-model="contrasena"
              type="password"
              placeholder="Mínimo 6 caracteres"
              autocomplete="new-password"
              required
            />
          </div>
          <div class="campo">
            <label for="repetir-contrasena">Repetir contraseña</label>
            <input
              id="repetir-contrasena"
              v-model="repetirContrasena"
              type="password"
              placeholder="Volvé a escribir la contraseña"
              autocomplete="new-password"
              required
            />
          </div>
          <button type="submit" :disabled="cargando">
            {{ cargando ? 'Guardando...' : 'Guardar contraseña' }}
          </button>
        </form>
        <p
          v-if="mensaje"
          class="mensaje"
          :class="{ exito: restablecimientoExitoso, error: !restablecimientoExitoso }"
        >
          {{ mensaje }}
        </p>
      </template>
      <template v-else>
        <h1>Recuperar contraseña</h1>
        <p class="descripcion">
          Abrí el enlace de recuperación que enviamos a tu correo para crear
          una contraseña nueva.
        </p>
      </template>
    </section>
  </main>
</template>