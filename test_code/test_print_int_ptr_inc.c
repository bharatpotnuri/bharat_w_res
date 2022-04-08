#include <stdio.h>
#include<stdlib.h>
#include <math.h>
#define UPDBGLARDPTR_M 0xfff
int main ()
{

	int a = 10;
	int *b = &a;

	(*b)++;		// correct
	//*b++;		// wrong
	//*(b)++;	// wrong
	printf("b %d a %d\n", *b, a);

	return 0;
}


