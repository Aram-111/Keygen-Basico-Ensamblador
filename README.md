# Proyecto Módulo 2 - Keygen Básico 

**Materia:** Lenguajes de Interfaz (SCC-1014)  
**Alumno:** Aram Gutiérrez Alcantar
**No.control** 23490544
**Archivo fuente:** `keygen_gutierrez_aram.asm`

## 🎯 Descripción del Proyecto
Este proyecto es un generador de claves (Keygen) desarrollado en ensamblador puro (x86-64) para Windows. Su objetivo es solicitar un nombre de usuario por consola y generar una llave de validación única de 16 dígitos en formato hexadecimal. El programa utiliza llamadas directas a la API de Windows (`kernel32.dll`) para la entrada y salida de datos, prescindiendo del uso de macros.

## 🛠️ Instrucciones de Compilación
Para compilar y enlazar este código, es necesario tener instalados **UASM64** y **GoLink**. Abre tu consola (CMD o PowerShell), navega a la carpeta del proyecto y ejecuta los siguientes comandos:

🛠️ Instrucciones de Compilación y Enlazado
Para compilar y ejecutar este proyecto se requieren **UASM64** y **GoLink**:

```cmd
uasm64 -win64 keygen_gutierrez_aram.asm
GoLink.exe keygen_gutierrez_aram.obj kernel32.dll /fo keygen_gutierrez_aram.exe /console /entry main
keygen_gutierrez_aram.exe
```

**Explicación del Algoritmo**
Captura y Validación: Lee la entrada con ReadConsoleA. Si los bytes leídos son menores o iguales a 2 (cmp rax, 2), detecta un nombre vacío (solo \r\n) y salta al mensaje de error.

Suma ASCII: Recorre la cadena byte por byte descontando el salto de línea (sub rcx, 2). Acumula los valores numéricos ASCII de cada letra en RAX mediante add rax, rdx.

Transformación XOR (Bonus): Aplica la instrucción xor rax, 0ABCDh sobre el acumulador para enmascarar la suma y generar una clave cifrada no lineal.

Conversión a Hexadecimal (16 dígitos): Procesa el registro de 64 bits en bloques de 4 bits (nibbles) mediante AND 0Fh y desplazamientos SHR rax, 4. Mapea cada bloque con la tabla hex_chars ('0123456789ABCDEF') y escribe de derecha a izquierda en hex_buffer, rellenando con ceros a la izquierda.

**Video del proyecto**
https://drive.google.com/file/d/1kO9bB23fbIvs4a_pwubJUEa89cH_9W5x/view?usp=sharing

**capturas**
<img width="1902" height="932" alt="image" src="https://github.com/user-attachments/assets/894c069b-80b0-4569-92e6-31b9f5daaeda" />
<img width="1701" height="894" alt="image" src="https://github.com/user-attachments/assets/1c232e9e-7fd2-4945-b8b1-0478da9fba73" />


