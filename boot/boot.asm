[org 0x7c00]    ; Tell assembler where this code will be loaded
[bits 16]      ; We're in 16-bit real mode

; Main entry point where BIOS loads us
start:
    ; Set up segment registers
    xor ax, ax  ; Zero ax register
    mov ds, ax  ; Set Data Segment to 0
    mov es, ax  ; Set Extra Segment to 0
    mov ss, ax  ; Set Stack Segment to 0
    mov sp, 0x7c00  ; Set up stack pointer

    ; Print message
    mov si, msg     ; Load message address into SI register
    call print_string

    ; Infinite loop - hang the system
    jmp $

; Function to print a string
print_string:
    pusha           ; Save all registers
    mov ah, 0x0e    ; BIOS teletype output

.loop:
    lodsb           ; Load next character from SI into AL
    test al, al     ; Check if character is null (string end)
    jz .done        ; If so, we're done
    int 0x10        ; Otherwise, print the character
    jmp .loop       ; And continue with next character

.done:
    popa            ; Restore all registers
    ret

; Our message
msg: db 'Welcome to SimoneOS!', 0

; Padding and magic number
times 510-($-$$) db 0   ; Pad with zeros up to 510 bytes
dw 0xaa55              ; Boot signature at the end of bootloader
