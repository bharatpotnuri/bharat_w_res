#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main ()
{
int a=35, b=-34, c=-35, d, e;
printf("a&&b %u a&&c %u a&b %d a&c %d\n", a&&b, a&&c, a&b, a&c);
d = c && a != abs(c);
e = b && a != abs(b);

printf("d = %d e = %d\n", d, e);

return 0;
}


