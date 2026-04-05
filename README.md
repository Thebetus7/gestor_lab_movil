# App Móvil - GestorLab

Aplicación móvil desarrollada en **Flutter** incorporando una arquitectura limpia y manejo de estado a través de `Provider`.

## Arquitectura Modular (Módulos y Capas)
1. **Core**: Base de red (`ApiClient`) genérico para procesar todas las solicitudes a Internet, sin importar a qué endpoint vayan.
2. **Data**: Funciones (`Services`) que consumen los módulos API estipulados y parsean todo tipo de dato hacia la aplicación. `Repositories` que encapsulan estas llamadas con manejo final de errores.
3. **Presentation**: Providers (Store global y persistente), Paginas y Elementos Modulares de UI.

## Ciclo de Vida del Token e Inyección de Dependencias
Para asegurar que todo el sistema móvil es consciente del estado de autenticación de un usuario, el ciclo del token (JWT) es el siguiente:
1. **LoginPage**: Envía usuario/contraseña usando `auth.login(...)` gestionado por el AuthProvider.
2. **AuthService**: Recibe el token JWT (access y refresh) del servidor Django (`AuthApi`) y lo almacena permanentemente de forma segura o local usando `SharedPreferences`.
3. **ApiClient (Inyección Transparente)**: Todas las solicitudes subsiguientes consultan `SharedPreferences` por el `access_token`. Si existe, se añade automáticamente la cabecera `Authorization: Bearer <TOKEN>` antes de lanzar la solicitud HTTP REST. Nunca verás un token pasándose por parámetros o en widgets de UI.
4. **Cierre de Sesión**: Un borrado sobre `SharedPreferences` en el `AuthService` que notifica a la variable `isAuthenticated` del `AuthProvider`, empujando automáticamente al usuario de regreso a `./login` en UI mediante ruteo.

## Diseño Implementado
Se implementó un diseño puramente funcional y minimalista, con delineados (`OutlineInputBorder`), tipografía negra, fondos en blanco puro y un `BottomNavigationBar` flotante encapsulado tipo "pastilla" en el Dashboard.
