#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

int main ()
{
uint64_t *a, *b;
uint32_t *p, *q;
int len=4;

//for(int i=0; i<4; i++)
//	a[i]=b[i]=0;

*p = 32;
*q = 33;

a = (uint64_t *)p;
b = (uint64_t *)q;
printf("a(%p) = %d, b(%p) = %d\n", a, *a, b, *b);


*b++ = *a++;
printf("a(%p), b(%p) \n", *a, *b);
*b++ = *a++;
printf("a(%p), b(%p) \n", *a, *b);

return 0;
}


