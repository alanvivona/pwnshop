## Install
    r2pm -i f2frida

## Starting a session
    
### Attach to existing process in the host
    r2 frida://Twitter  
    r2 frida://<pid>  


### Attach to existing process on a device
    r2 frida://<deviceID>/Twitter  
    r2 frida://<deviceID>/<pid>  

### Spawn a process on the host
    r2 frida:///usr/bin/ls
    r2 "frida:///usr/bin/ls -al"


### Spawn a process on a device
    r2 frida://<device_name>//your.package.name  
When spawning a process it's started in suspended mode. It must be resumed using the `\dc` command  

## Configs
Is recomended to activate ESIL emulation anotations using `e asm.emu=true`  

## Commands
All r2frida commands are precedded with a `\`  

#### HELP
    \?      Show help

#### REMOTE DEVICE ARCH
    .\i*    To tell radare2 the arch of the process (useful for remote devices)  

#### SEARCH
    \/[x][j] <string|hexpairs>  Search hex/string pattern in memory ranges (see `search.in=?`)  

#### INSPECT
Don't use `aaa`, is too time consuming and complex for large apps!!!  
Use frida inspect capabilities instead  
    
    \i                               Show target information    
    \ii[*]                           List imports    
    \il                              List libraries    
    \is[*] <lib>                     List symbols of lib (local and global ones)    
      \i; echo *****; \il            List target info and list libraries  
      \is target.o                   List sections for target.o  
      \is target.o ~ f               Same but for functions only  
      \is target.o ~ f~ someF[0]     Extract function address  

#### FUNCTION ANALYSIS
    s `\is target.o ~ f~ someF[0]`   Jump to function  
    af; pdf                          Analyze and disassembly  

#### FUNCTION INSTRUMENTATION
    \dtf `s` ^x                      Trace the function using frida, print one argument as hex value  
    \dxc `s` 0xffffffff              Call the funtion with the param 0xffffffff  

#### DEBUG
    \db (<addr>|<sym>)              List or place breakpoint
    \db- (<addr>|<sym>)|*           Remove breakpoint(s)
    \dc                             Continue breakpoints or resume a spawned process
    \dm[.|j|*]                      Show memory regions
    \dpt                            Show threads

#### TRACING
    \dt (<addr>|<sym>) ..           Trace list of addresses or symbols
                                    Example: \dt <address> Triggers every time the address is executed
    \dtf <addr> [fmt]               Trace address with format (^ixzO) (see dtf?)
                                    Example: \dtf 0x00000010bb7777 xzOO
    \dtr <address> <format>         Trace registers values

#### SCRIPTING
    \. script                       Run script
    \eval code..                    Evaluate Javascript code in agent side

#### RESOLVE THINGS AT RUNTIME
    \eval new ApiResolver('objc').enumerateMatchesSync('*[* sharedTwitter]')
    This will resolve the class names+methods+address that matches the provided query
    (all methods matching 'sharedTwitter' from all classes)

#### FILE DESCRIPTOR MANIPULATION
    \dd[j-][fd] ([newfd])       List, dup2 or close filedescriptors (ddj for JSON) 
    
    Replace file descriptors (change input and output destinations of ANY function)
    - Start the target app
    - While suspended:
        \dmas output.txt                                Allocates the string "output.txt" in the heap
        \dxc open <addres from prev command> 0x202      Call open with given permissions
        \dd <fd from prev command> 1                    Replace the fd=1(stdout) with the result of the previous command
        \dc                                             Resume. Now all the output goes to the specified file!
