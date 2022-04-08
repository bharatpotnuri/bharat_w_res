#include <stdio.h>
#include<stdlib.h>
#include <math.h>
#define UPDBGLARDPTR_M 0xfff
int main ()
{
	int a = 8191;

//#1
//	if(a&(1<<13)) {
//		printf("inside if\n");
//		a = a &~(1<<13);
//	}
//#2
	a = a & ~(1<<13); 
	printf("Bhar: a=%d\n", a);
	return 0;
}


