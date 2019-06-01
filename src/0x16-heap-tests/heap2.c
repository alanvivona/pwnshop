#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct salesItem
{
	int productNumber;
	float price;
	int quantity;
	char description[20];
} myItem;

int main(int argc, char** argv)
{
	char *p1, *p2;
	struct salesItem myItem;
	struct salesItem *pMyItem;

	p1 = malloc(16);
	p2 = malloc(1024);

	myItem.productNumber =1;
	myItem.price=1.00;
	myItem.quantity=1;
	strcpy(myItem.description, "Sample Item");
	
	memcpy(p2, &myItem, sizeof(struct salesItem));

	// create a vuln by allowing user to input values into p1
	if (argc > 1)
		strcpy(p1, argv[1]);

	// display possibly modified item
	pMyItem = (struct salesItem*)p2;
	printf("My Item is now: %s %6.2f %d\n", pMyItem->description, pMyItem->price, pMyItem->quantity);

	free(p2);
	free(p1);

	return 0;	
}
