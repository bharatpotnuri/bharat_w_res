#include <stdio.h>
#include<stdlib.h>
#include <math.h>
#define UPDBGLARDPTR_M 0xfff
int main ()
{
	unsigned int a = 10;
	long long int b = 20;
	u_int64_t c = 30;
	printf("size of unsigned int %d\n", sizeof(a));
	printf("size of long long int %d\n", sizeof(b));
	printf("size of uint64 %d\n", sizeof(c));

	return 0;
}


