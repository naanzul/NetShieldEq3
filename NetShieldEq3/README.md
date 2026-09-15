# NetShield

## Descripción

NetShield es una aplicación móvil de ciberseguridad que permite a los usuarios reportar sitios web y enlaces sospechosos de phishing, consultar si una URL ya fue reportada por la comunidad, y ver alertas públicas de fraudes verificados por un administrador. El objetivo es reducir el tiempo entre que aparece un sitio fraudulento y que la comunidad se entera de su existencia.

## Integrantes del equipo

- Flor Blacina Rodriguez Hernandez
- Ximena Itzel Camacho Flores
- Jose Leonardo Salinas Ramirez
- Randy Angelo Rojas Tolentino

## Entorno de desarrollo

- **Versión de Xcode:** `Xcode v.26.5`
- **Modelo de iPhone utilizado en el simulador:** `iPhone 17 Pro`

## Funcionalidades asignadas (detalle)

- [Flor Blacina] Hacer la vista Login y darle funcionalidad al boton -Iniciar Sesion-
- [Ximena Itzel] Hacer la vista Registro de usuario, darle funcionalidad al botón -Registrar- agregar un botón para visualizar y ocultar el password y mostrar mensajes de error cuando los campos estén vacíos o no se el formato adecuado.
- [Jose Leonardo Salinas] Hacer la creacion de reporte para que lo usuarios hagan su formato y como deben de realizarlo brindando las herramientas necesarias para el usuario
- [Randy Angelo] Hacer la vista Consulta de URL, dar funcionalidad al boton
- [ ] Home / pantalla principal
- [ ] Nuevo reporte (URL + evidencia + subcategoría)
- [ ] Consultar URL
- [ ] Alertas (feed de reportes aprobados)
- [ ] Estadísticas (dashboard)
- [ ] Perfil de usuario
  

## Convención de nombres de ramas

```
main                → rama principal

feature/login   → Flor
feature/registro → Ximena
feature/ConsultaURL1.1 → Randy
feature/creadordereporte → Leonardo
fix/<nombre-corto>       → corrección de bug, ej. fix/crash-nuevo-reporte
chore/<nombre-corto>     → tareas de mantenimiento (configuración, dependencias)
```

## Acuerdos básicos de colaboración

1. Ninguna rama se mergea directo a `main` sin al menos una revisión (Pull Request) de otro integrante del equipo.
2. Cada Pull Request debe describir brevemente qué se hizo y, si aplica, qué pantalla o funcionalidad afecta.
3. Antes de empezar una tarea nueva, se actualiza la rama local para evitar conflictos innecesarios.
4. Los commits deben tener mensajes claros y en español consistente con el resto del equipo (ej. `agrega validación de URL en formulario de reporte`).
5. Cualquier cambio en el modelo de datos o en la arquitectura se discute con el equipo antes de implementarlo.
