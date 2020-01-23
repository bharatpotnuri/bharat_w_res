#include <stdio.h>
#include<stdlib.h>
#include <math.h>
#define UPDBGLARDPTR_M 0xfff
int main ()
{
	unsigned long long int a;
	long long int b;
	u_int64_t page_mask;
	a = 112574691000000000;
	b = a;
	printf("a %llu  b %lld\n", a, b);
	page_mask = ~(0x40000000 - 1);
	printf("page mask %llx\n", page_mask);

	return 0;
}


