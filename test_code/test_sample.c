#include <stdio.h>
#define twice(a, b) a*2
int main ()
{
	char x = 0x80;
	int a = x;
	printf("0x%x\n", a);
	//printf("%d %d\n", ~a+1, 'a'+1);

	//printf("%d %d %d\n", twice(a+1), twice(a++), twice(a));


	int p = 0xdeadbeaf;
	char y = p;
	printf("%x\n", y);
	return 0;
}
