#include <stdio.h>

int main()
{
	int x = 1;
	int y = 2;
 
	y = x<<y;
	printf("y = %d, x = %d\n", y, x);
	
	return 0;
}
