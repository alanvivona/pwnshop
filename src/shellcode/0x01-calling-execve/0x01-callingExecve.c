#include <stdio.h>

main(int argc, char const *argv[])
{
    execve("/bin/sh", "/bin/sh", NULL);
}