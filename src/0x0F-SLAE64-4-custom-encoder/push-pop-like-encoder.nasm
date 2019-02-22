; idea for an encoder: make all the encoded bytes look like regular instructions
; one way of achieving this I came up with is to use the push/pop instructions
; they all are like :
;   0x5X where X can be anything from 0 to F
; so I could take every single NIBBLE and add the 5 as a prefix
; this encoder would duplicate the original shellcode size

; some ideas of how to decode the payload:
; (asume rsi points to the start of the encoded shellcode and rcx is the offset)

decode:
    xor al, al
    mov al, [rsi+rcx] ; [rsi+ecx] would have something like, i.e 0x5b. al = 0x5b
    xor al, 0x50  ; xor with 0x50 to wipe the upper nibble, now al = 0x0b
    shl al, 4     ; shift 8 bits left, now al = 0xb0  

    inc rcx       ; take next instruction

    ; repeat the process for the next 4 bits
    xor bl, bl
    mov bl, [rsi+rcx] ; [rsi+ecx] would have something like, i.e 0x55. bl = 0x55
    xor bl, 0x50  ; xor with 0x50 to wipe the upper nibble, now bl = 0x05

    lea dl, [al+bl] ; dl = al + bl = 0xb0 + 0x05 = 0xb5
    mov BYTE [rsi+rcx-1], dl

    inc rcx
    ; add here the loop end condition
    jmp decode