# Proyecto Módulo 2 - Keygen Básico 

**Materia:** Lenguajes de Interfaz (SCC-1014)  
**Alumno:** Aram Gutiérrez Alcantar
**No.control** 23490544
**Archivo fuente:** `keygen_gutierrez_aram.asm`

## 🎯 Descripción del Proyecto
Este proyecto es un generador de claves (Keygen) desarrollado en ensamblador puro (x86-64) para Windows. Su objetivo es solicitar un nombre de usuario por consola y generar una llave de validación única de 16 dígitos en formato hexadecimal. El programa utiliza llamadas directas a la API de Windows (`kernel32.dll`) para la entrada y salida de datos, prescindiendo del uso de macros.

## 🛠️ Instrucciones de Compilación
Para compilar y enlazar este código, es necesario tener instalados **UASM64** y **GoLink**. Abre tu consola (CMD o PowerShell), navega a la carpeta del proyecto y ejecuta los siguientes comandos:

## 🛠️ Instrucciones de Compilación y Enlazado
Para compilar y ejecutar este proyecto se requieren **UASM64** y **GoLink**:

```cmd
uasm64 -win64 keygen_gutierrez_aram.asm
GoLink.exe keygen_gutierrez_aram.obj kernel32.dll /fo keygen_gutierrez_aram.exe /console /entry main
keygen_gutierrez_aram.exe

Explicación del Algoritmo
El algoritmo de generación de la llave funciona mediante los siguientes pasos:

Captura: Lee el nombre de usuario ingresado ignorando saltos de línea.

Acumulación ASCII: Recorre la cadena capturada byte por byte y suma el valor ASCII de cada carácter en un registro acumulador (RAX).

Transformación (Bonus): Una vez finalizada la suma, se aplica una operación lógica XOR con la constante 0xABCD para hacer la validación más robusta.

Conversión a Hexadecimal: El valor numérico resultante (64 bits) se procesa extrayendo bloques de 4 bits (nibbles). Estos se convierten a caracteres ASCII correspondientes al sistema hexadecimal (0-9 y A-F), rellenando con ceros a la izquierda para garantizar siempre un formato exacto de 16 dígitos.
