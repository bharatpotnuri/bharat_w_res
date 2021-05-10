#include <stdio.h>
#include <math.h>

int main ()
{
#define roundup(x, y) (					\
{							\
	typeof(y) __y = y;				\
	(((x) + (__y - 1)) / __y) * __y;		\
}							\
)
	int i, r = 0;

	for (r; r<=256; r++) {
		i = roundup(r, 32);
		printf("roundup %d\n", i);
	}
}
