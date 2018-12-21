#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

void getpath()
{
    char buffer[64];
    unsigned int ret;

    printf("input path please: ");
    fflush(stdout);

    gets(buffer);

    ret = __builtin_return_address(0);

    if ((ret & 0xbf000000) == 0xbf000000)
    {
        printf("bzzzt (%p)\n", ret);
        _exit(1);
    }

    printf("got path %s\n", buffer);
}

int main(int argc, char **argv)
{
    getpath();
}