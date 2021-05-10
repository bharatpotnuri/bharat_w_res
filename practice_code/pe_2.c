// ProjectEuler
#include <stdio.h>
#include <math.h>

int main ()
{
	int fib[4000000] = {0};
	int next_fib = 0;
	int sum = 2;
	fib[0] = 1;
	fib[1] = 2;
	int i = 1;

	while ( next_fib <= 4000000 ) {
		next_fib = fib[i] + fib[i-1];
		printf("fib %d\n", next_fib);
		i++;
		if ( next_fib%2 == 0) {
			sum+= next_fib;
			printf("even fib %d\n", next_fib);
		}
		fib[i] = next_fib;
	}
	printf("Sum is %d\n", sum);
	return 0;
}
