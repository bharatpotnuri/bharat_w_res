#include <stdio.h>

main()
{
	int a[5] = {75, 56, 0, 6, 2};
	printf("%d\n", a[a[a[4]]]);
}
