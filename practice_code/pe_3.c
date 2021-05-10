// ProjectEuler
#include <stdio.h>
#include <math.h>
#include <stdint.h>

int main ()
{
	uint64_t n = 0;
	printf("Enter any number to print Prime factors: ");
	scanf("%lu", &n);

	if ( n%2 == 0 )
		n/=2;

	for ( int i=3; i <= sqrt(n); i+=2) {
		while ( n%i == 0 ) {
			n/=i;
			printf ("%lu ", i);
		}		
	}

	if ( n > 2 )
		printf("%lu\n", n);
	return 0;
}
