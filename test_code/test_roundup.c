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
	int i, r = 0, ret, det;

	for (r; r<=50; r++) {
		i = roundup(r, 16);
		ret =  (((r) + (16 -1)) / 16);
		det =  (((r) + (16 -1)) / 16) * 16;
		printf("roundup of %d = %d %d %d\n", r, i, ret, det);
	}
}
