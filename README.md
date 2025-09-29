# 📱 Práctica Flutter - CRUD con API REST

Este proyecto es una aplicación Flutter que implementa un **CRUD (Crear,
Leer, Actualizar y Eliminar)** de productos, consumiendo la API pública
[DummyJSON](https://dummyjson.com/).

La app permite:\
- Listar productos desde la API.\
- Ver el detalle de cada producto.\
- Crear y editar productos mediante un formulario.\
- Eliminar productos desde la vista de detalle.

> ⚠️ Nota: DummyJSON no persiste cambios en su base de datos. Las
> operaciones **POST, PUT y DELETE son simuladas**.\
> Por eso, la app mantiene los cambios localmente para que se reflejen
> en la UI aunque la API devuelva error (ej. 404).

------------------------------------------------------------------------

## 🚀 Características principales

-   **Pantalla de lista**: muestra los productos obtenidos de la API.\
-   **Pantalla de detalle**: despliega la información completa de un
    producto.\
-   **Pantalla de formulario**: permite crear o editar un producto.\
-   **Acción de eliminación**: disponible en la pantalla de detalle.\
-   **Gestión de estado** con `Provider`.\
-   **Diseño responsivo** con `Material Design`.

------------------------------------------------------------------------

## 📂 Estructura del proyecto

    lib/
    ├── main.dart                # App principal y rutas
    ├── models/
    │   └── product.dart          # Modelo de producto
    ├── providers/
    │   └── product_provider.dart # Lógica de negocio y estado
    ├── screens/
    │   ├── product_list_screen.dart
    │   ├── product_detail_screen.dart
    │   └── product_form_screen.dart
    └── services/
        └── api_service.dart      # Conexión con la API DummyJSON

------------------------------------------------------------------------

## ⚙️ Requisitos

-   Flutter SDK 3.x en adelante\
-   Emulador Android/iOS o dispositivo físico

------------------------------------------------------------------------

## ▶️ Ejecución

1.  Clonar el repositorio:

    ``` bash
    git clone https://github.com/MiguelHerazo/practica_flutter
    cd practica_flutter
    ```

2.  Instalar dependencias:

    ``` bash
    flutter pub get
    ```

3.  Ejecutar en un emulador o dispositivo:

    ``` bash
    flutter run
    ```



## 👨‍💻 Autor

### Miguel Herazo
#### Universidad De Medellín
#### 2025

Proyecto desarrollado como práctica de **Flutter + API REST**.
