// ProjectEuler
#include <stdio.h>
#include <math.h>

int main ()
{
	int sum = 0;

	for ( int i=1; i<1000; i++ ) {
		if ( i%3 == 0 || i%5 == 0 ) {
			printf("mult %d\n", i);
			sum+=i;
		}
	}
	printf("Sum is %d\n", sum);
	return 0;
}
