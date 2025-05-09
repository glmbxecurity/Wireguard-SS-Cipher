## Wireguard-SS-Cipher

Wireguard-SS-Cipher es una herramienta diseñada para cifrar de manera segura las claves privadas de los clientes de WireGuard y gestionar configuraciones de túneles VPN. La herramienta facilita la creación y gestión de configuraciones de clientes WireGuard cifrando las claves privadas con una passphrase aleatoria generada desde un diccionario y cifrada utilizando GPG. Ideal para administradores de redes que necesitan mantener la seguridad de sus claves privadas mientras gestionan múltiples túneles VPN.
----------------
### 🚀 ¿Qué hace Wireguard-SS-Cipher?

Wireguard-SS-Cipher permite realizar las siguientes acciones:

* Cifrar claves privadas de clientes WireGuard: Usando GPG, las claves privadas se cifran y almacenan de forma segura.

* Generación de passphrase aleatoria: La passphrase utilizada para cifrar las claves privadas se genera automáticamente a partir de un diccionario de palabras.

* Crear copias de las configuraciones de clientes: Al cifrar una clave privada, el script genera una copia del archivo .conf del cliente, reemplazando la clave privada con un marcador de posición PrivateKey = __REPLACE_WITH_DECRYPTED_KEY__.

* Soporte para múltiples túneles: El script puede trabajar con múltiples túneles, facilitando la administración de configuraciones y clientes.

### 📦 Requisitos

Para usar Wireguard-SS-Cipher, necesitarás:

* **WireGuard** debe estar instalado en tu servidor y en las máquinas cliente. (para luego realizar la conexion, no para cifrar el tunel)

* **GPG** debe estar instalado para cifrar y descifrar las claves privadas.

* Un sistema compatible con **POSIX** (Linux, macOS, etc.).

* Un **diccionario** de palabras (archivo de texto) para generar passphrases aleatorias.
----------------
### 🔧 Instalación

Clonar el repositorio:
```bash
git clone https://github.com/tu_usuario/Wireguard-SS-Cipher.git
cd Wireguard-SS-Cipher
```
Asegurarse de tener los requisitos:

* Instalar GPG si no lo tienes ya:
```bash
    sudo apt install gnupg  # En sistemas basados en Debian/Ubuntu
```
* También necesitarás tener un archivo de **diccionario** de palabras (por ejemplo, diccionario.txt) en el mismo directorio que el script.
----------------
### 📋 Instrucciones de Uso
#### 1. Cifrar una clave privada

Para cifrar la clave privada de un cliente, simplemente ejecuta el script y sigue los pasos interactivos.
```bash
./Wireguard-SS-Cipher.sh
```

##### El script hará lo siguiente:

* Te pedirá que selecciones un túnel de los disponibles.

* Luego, te pedirá que elijas un cliente .conf (configuración de cliente) dentro del túnel.

* El script generará una passphrase aleatoria y cifrará la clave privada de ese cliente utilizando GPG.

* El archivo .conf del cliente será modificado para sustituir la clave privada con el marcador PrivateKey = __REPLACE_WITH_DECRYPTED_KEY__.

* El script creará los siguientes archivos:

    * **cliente.key.gpg**: la clave privada cifrada.

    * **cliente.pass**: el archivo con la passphrase generada.

    * **cliente.conf.secured**: una copia de la configuración del cliente con la clave privada cifrada sustituida por el marcador.

#### 2. Consideraciones importantes

* Diccionario de palabras: Asegúrate de tener un archivo de diccionario de palabras (por ejemplo, diccionario.txt) en el mismo directorio que el script. Si no tienes uno, el script no podrá generar passphrases aleatorias.

* Estructura de directorios: El script espera encontrar los archivos de configuración de cliente en el directorio **wg_secure_configs/NOMBRE_DEL_TUNEL/clients/**.
----------------
### 🛠️ Flujo de trabajo

* Crear configuraciones: Al ejecutar el script, se te pedirá que selecciones el túnel y el cliente.

* Cifrado de clave privada: La clave privada del cliente será cifrada y guardada en un archivo .gpg.

* Modificar el archivo .conf: El archivo de configuración del cliente será modificado para reemplazar la clave privada por un marcador.

* Almacenamiento seguro: El archivo de passphrase y los archivos cifrados se guardan en el directorio del cliente.

### 📂 Estructura de Archivos

El script crea los siguientes archivos:

* cliente.key.gpg: El archivo de clave privada cifrada utilizando GPG.

* cliente.pass: El archivo que contiene la passphrase utilizada para cifrar la clave.

* cliente.conf.secured: Una copia de la configuración del cliente con la clave privada reemplazada por el marcador PrivateKey = __REPLACE_WITH_DECRYPTED_KEY__.

### 🔒 Seguridad

**Cifrado de claves privadas**: Las claves privadas de los clientes son cifradas utilizando GPG con una passphrase generada de manera aleatoria. Esto garantiza que las claves privadas estén protegidas incluso si los archivos de configuración se distribuyen.  
**Marcador de clave privada**: En lugar de incluir la clave privada en los archivos .conf, se inserta un marcador PrivateKey = __REPLACE_WITH_DECRYPTED_KEY__, lo que indica que la clave debe ser descifrada y reemplazada cuando se necesite.  

### 📝 Notas adicionales

* **Modularidad**: El script es flexible y puede trabajar con cualquier nombre de archivo .conf para los clientes, lo que lo hace más modular.  

* **Compatibilidad**: El script es compatible con sistemas POSIX, como Linux y macOS.

* **Sin modificaciones globales**: El script no realiza cambios globales en el sistema y trabaja en directorios específicos, lo que minimiza el riesgo de modificaciones no deseadas.

----------------
### 💬 Contribuciones

Si encuentras algún error o deseas mejorar la herramienta, no dudes en hacer un pull request o abrir un issue en GitHub.
### 📜 Changelog

* Versión 1.0: Creación del script con funciones básicas para cifrar claves privadas y generar archivos de configuración seguros.

* Versión 1.1: Añadida la capacidad para manejar múltiples túneles y archivos de configuración de cliente con nombres variables.
