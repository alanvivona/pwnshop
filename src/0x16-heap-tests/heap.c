#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
	char *p1, *p2;

	p1 = malloc(16);
	p2 = malloc(1024);

	// create a vuln by allowing user to input values into p1
	if (argc > 1)
		strcpy(p1, argv[1]);

	free(p2);
	free(p1);

	return 0;	
}
