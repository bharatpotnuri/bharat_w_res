#include <stdio.h>
#include <math.h>

int main ()
{
#define roundup(x, y) (					\
{							\
	/*typeof(y) __y = y;		*/		\
	/*(((x) + (__y - 1)) / __y) * __y;	*/	\
	(((x) + (y - 1)) / y) * y;		\
}							\
)
	int i, r = 0;

	for (r; r<=50; r++) {
		i = roundup(r, 16);
		printf("roundup of %d = %d\n", r, i);
	}
}
