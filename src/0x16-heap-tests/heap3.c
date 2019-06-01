#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct candidate
{
	char name[20];
	int votes;
} candidate;

candidate *pCandidates;

int vote(int candidateNumber)
{
	pCandidates[candidateNumber].votes++;
}

int main(int argc, char** argv)
{
	char *p1;
	int i;

	p1 = malloc(16);
	pCandidates = (candidate*) malloc(sizeof(candidate)*50);

	strcpy(pCandidates[0].name, "Phil Polstra");
	pCandidates[0].votes=1;

	strcpy(pCandidates[1].name, "Billary Rotten");
	pCandidates[1].votes=2;

	// simulate some voting
	vote(0);
	vote(1);
	vote(1);

	// create a vuln by allowing user to input values into p1
	if (argc > 1)
		strcpy(p1, argv[1]);

	// display election results
	for (i=0; i < 2; i++)
	{
		printf("Candidate %s has %d votes\n", pCandidates[i].name, pCandidates[i].votes);
	}

	free(pCandidates);
	free(p1);

	return 0;	
}
