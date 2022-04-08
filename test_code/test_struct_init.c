#include <stdio.h>

struct mystruct 
{
	int a;
	int b;
	int c;
};
	
int main ()
{
	struct mystruct mystr;
	mystr.a = mystr.b = mystr.c = 255;
	printf("%d\n", mystr.c);
	return 0;
}
