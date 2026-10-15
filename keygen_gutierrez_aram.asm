; =========================================================================
; PROYECTO MÓDULO 2 - KEYGEN BÁSICO (SUMA ASCII + DUAL OUTPUT XOR)
; Materia: Lenguajes de Interfaz (SCC-1014)
; Autor: Aram Gutiérrez
; Ensamblador: UASM64 / Enlazador: GoLink
; =========================================================================

extrn GetStdHandle: proc
extrn ReadConsoleA: proc
extrn WriteConsoleA: proc
extrn ExitProcess: proc

.data
    prompt          db 'Ingresa tu nombre de usuario: ', 0
    prompt_len      dq $ - prompt - 1

    buffer          db 64 DUP (0)
    buffer_len      dq 64
    leidos          dq 0
    escritos        dq 0

    msg_suma        db 'Suma ASCII:      ', 0
    len_msg_suma    dq $ - msg_suma - 1

    msg_llave       db 'Llave final XOR: ', 0
    len_msg_llave   dq $ - msg_llave - 1

    newline         db 13, 10, 0
    newline_len     dq $ - newline - 1

    error_vacio     db 'Error: Nombre no valido.', 13, 10, 0
    error_len       dq $ - error_vacio - 1

    suma            dq 0
    hex_buffer      db 17 DUP (0)    ; 16 dígitos HEX + terminador NULL
    hex_chars       db '0123456789ABCDEF'

    XOR_CONST       equ 0ABCDh       ; Constante para la transformación extra

.code

; =========================================================================
; PROCEDIMIENTO PRINCIPAL (main)
; =========================================================================
main proc
    sub rsp, 28h                     ; Reservar espacio en la pila (Shadow Space)

    ; 1. Obtener los identificadores (handles) de la consola
    mov rcx, -11                     ; STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rbx, rax                     ; RBX = Handle de salida (stdout)

    mov rcx, -10                     ; STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax                     ; RSI = Handle de entrada (stdin)

    ; 2. Mostrar mensaje pidiendo el nombre
    mov rcx, rbx
    lea rdx, prompt
    mov r8, [prompt_len]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; 3. Leer la entrada del usuario desde la consola
    mov rcx, rsi
    lea rdx, buffer
    mov r8, [buffer_len]
    lea r9, leidos
    mov qword ptr [rsp + 20h], 0
    call ReadConsoleA

    ; 4. Validar si el usuario ingresó un nombre vacío (solo presionar Enter)
    mov rax, [leidos]
    cmp rax, 2                       ; \r\n equivale a 2 bytes
    jle error_nombre_vacio

    ; ------------------------------------------------------------
    ; 5. CALCULAR Y MOSTRAR LA SUMA ASCII PURA
    ; ------------------------------------------------------------
    call CalcularSumaASCII          ; RAX contiene la suma ASCII limpia
    mov [suma], rax

    call ConvertirHexadecimal        ; Convierte el valor en [suma] a hex_buffer

    ; Imprimir "Suma ASCII:      "
    mov rcx, rbx
    lea rdx, msg_suma
    mov r8, [len_msg_suma]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Imprimir resultado hex (16 dígitos)
    mov rcx, rbx
    lea rdx, hex_buffer
    mov r8, 16
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Imprimir salto de línea
    mov rcx, rbx
    lea rdx, newline
    mov r8, [newline_len]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; ------------------------------------------------------------
    ; 6. APLICAR TRANSFORMACIÓN XOR Y MOSTRAR LLAVE FINAL
    ; ------------------------------------------------------------
    mov rax, [suma]
    xor rax, XOR_CONST              ; Aplicar XOR 0xABCD
    mov [suma], rax

    call ConvertirHexadecimal        ; Convierte la nueva suma en [suma] a hex_buffer

    ; Imprimir "Llave final XOR: "
    mov rcx, rbx
    lea rdx, msg_llave
    mov r8, [len_msg_llave]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Imprimir resultado hex (16 dígitos)
    mov rcx, rbx
    lea rdx, hex_buffer
    mov r8, 16
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    ; Imprimir salto de línea
    mov rcx, rbx
    lea rdx, newline
    mov r8, [newline_len]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

    jmp fin

error_nombre_vacio:
    ; Mostrar mensaje de error si el nombre está vacío
    mov rcx, rbx
    lea rdx, error_vacio
    mov r8, [error_len]
    lea r9, escritos
    mov qword ptr [rsp + 20h], 0
    call WriteConsoleA

fin:
    xor ecx, ecx
    call ExitProcess
main endp

; =========================================================================
; PROCEDIMIENTO: CalcularSumaASCII
; Recorre el buffer, suma los valores ASCII y retorna el total en RAX
; =========================================================================
CalcularSumaASCII proc
    lea rsi, buffer                  ; Apuntar al inicio del buffer
    mov rcx, [leidos]
    sub rcx, 2                       ; Descontar \r y \n
    xor rax, rax                     ; Limpiar acumulador

suma_loop:
    movzx rdx, byte ptr [rsi]        ; Obtener carácter
    add rax, rdx                     ; Sumar valor ASCII
    inc rsi                          ; Avanzar puntero
    loop suma_loop

    ret
CalcularSumaASCII endp

; =========================================================================
; PROCEDIMIENTO: ConvertirHexadecimal
; Convierte el valor de 64 bits guardado en [suma] a 16 caracteres HEX
; =========================================================================
ConvertirHexadecimal proc
    mov rax, [suma]
    lea rdi, hex_buffer
    add rdi, 15                      ; Apuntar al último dígito
    mov rcx, 16                      ; 16 dígitos (64 bits)
    lea r10, hex_chars               ; Tabla '0123456789ABCDEF'

hex_loop:
    mov rdx, rax
    and rdx, 0Fh                     ; Extraer los 4 bits menos significativos
    mov dl, [r10 + rdx]              ; Convertir a carácter ASCII
    mov [rdi], dl                    ; Guardar en el buffer
    dec rdi                          ; Mover puntero hacia la izquierda
    shr rax, 4                       ; Desplazar 4 bits a la derecha
    loop hex_loop

    mov byte ptr [hex_buffer + 16], 0; Terminador nulo
    ret
ConvertirHexadecimal endp

end
