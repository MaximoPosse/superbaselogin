import { createClient } from '@supabase/supabase-js'

async function main() {
  const correo = process.argv[2]
  const contrasena = process.argv[3]

  if (!correo || !contrasena) {
    console.error('Uso: npm run reset-password <correo> <nueva-contrasena>')
    process.exitCode = 1
    return
  }

  const urlSupabase = process.env.VITE_SUPABASE_URL
  const claveServicio = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!urlSupabase || !claveServicio) {
    console.error('Faltan variables. Completá .env.local')
    process.exitCode = 1
    return
  }

  const supabase = createClient(urlSupabase, claveServicio, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  const {
    data: { users },
    error: errorLista,
  } = await supabase.auth.admin.listUsers()

  if (errorLista) {
    console.error(`Error de conexión: ${errorLista.message}`)
    process.exitCode = 1
    return
  }

  const usuario = users.find((item) => item.email === correo)

  if (!usuario) {
    console.error(`No existe un usuario con el correo ${correo}`)
    process.exitCode = 1
    return
  }

  const { error } = await supabase.auth.admin.updateUserById(usuario.id, {
    password: contrasena,
  })

  if (error) {
    console.error(error.message)
    process.exitCode = 1
    return
  }

  console.log(`Contraseña actualizada para ${correo}. Ya podés iniciar sesión.`)
}

main()