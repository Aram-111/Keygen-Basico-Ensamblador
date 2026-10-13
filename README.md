# Proyecto Módulo 2 - Keygen Básico 

**Materia:** Lenguajes de Interfaz (SCC-1014)  
**Alumno:** Aram Gutiérrez  
**Archivo fuente:** `keygen_gutierrez_aram.asm`

## 🎯 Descripción del Proyecto
Este proyecto es un generador de claves (Keygen) desarrollado en ensamblador puro (x86-64) para Windows. Su objetivo es solicitar un nombre de usuario por consola y generar una llave de validación única de 16 dígitos en formato hexadecimal. El programa utiliza llamadas directas a la API de Windows (`kernel32.dll`) para la entrada y salida de datos, prescindiendo del uso de macros.

## 🛠️ Instrucciones de Compilación
Para compilar y enlazar este código, es necesario tener instalados **UASM64** y **GoLink**. Abre tu consola (CMD o PowerShell), navega a la carpeta del proyecto y ejecuta los siguientes comandos:

**1. Ensamblado:**
```bash
uasm64 -win64 keygen_gutierrez_aram.asm# Keygen-Basico-Ensamblador
