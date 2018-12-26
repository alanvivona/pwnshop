#include <stdio.h>

realThing(){
    char *syscallArgs[2];
    syscallArgs[0] = "/bin/sh";
    syscallArgs[1] = NULL;
    execve(syscallArgs[0], syscallArgs, syscallArgs[1]);
}

main(int argc, char const *argv[]) {
    realThing();
}