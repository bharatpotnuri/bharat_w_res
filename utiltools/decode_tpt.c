#include <math.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <string.h>
#include <malloc.h>
#include <netdb.h>
#include <signal.h>
#include <assert.h>
#include <endian.h>

#include <sys/errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/poll.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>

#define u8 uint8_t
#define u32 uint32_t
#define u64 uint64_t
#define TPT_RAW_SIZE 32

void print_tpt(u8 *tpt);
static int get_bit64(unsigned char *A, u32 sizebytes, int bit)
{
        int ret = 0;
        int ix, shift;
        u32 sizebits = sizebytes * 8;

        ix = (sizebits - 1 - bit) >> 3;
        shift = bit & 0x7;
        ret = (A[ix] >> shift) & 1;

        return ret;
}

/* get_bits64  : gets value from low to high bits range from array of bytes
 *
 * A           : Array of bytes
 * sizebytes   : number of bytes
 * hi          : high bit
 * lo          : low bit
 */
u64 get_bits64(unsigned char  *A, u32 sizebytes, int hi, int lo)
{
        u64 ret = 0;
        int temp;

        if (lo > hi) {
                temp = lo;
                lo = hi;
                hi = temp;
        }

        while (hi >= lo) {
                ret = (ret<<1) | get_bit64(A, sizebytes, hi);
                --hi;
        }

        return ret;
}


u64 get_tpt_bits(u8 *tpt, int hi, int lo)
{
        return get_bits64((unsigned char *)tpt, TPT_RAW_SIZE, hi, lo);
}

void print_tpt(u8 *tpt)
{
        printf("Valid       =   %-16llu Key         = 0x%-16llx State        ="\
               "   %llu\n",  get_tpt_bits(tpt, 255, 255),
               get_tpt_bits(tpt, 254, 247), get_tpt_bits(tpt, 246, 246));

        printf("Type        =   %-16llu PDID        = 0x%-16llx Local_Read   ="\
               "   %llu\n", get_tpt_bits(tpt, 245, 244),
               get_tpt_bits(tpt, 243, 224), get_tpt_bits(tpt, 223, 223));

        printf("Local_Write =   %-16llu Remote_Read =   %-16llu Remote_Write ="\
               "   %llu\n", get_tpt_bits(tpt, 222, 222),
               get_tpt_bits(tpt, 221, 221), get_tpt_bits(tpt, 220, 220));

        printf("RInvld Dsbl =   %-16llu Addr Type   =   %-16llu MW Bind En   ="\
               "   %llu\n", get_tpt_bits(tpt, 219, 219),
               get_tpt_bits(tpt, 218, 218), get_tpt_bits(tpt, 217, 217));

        printf("Page Size   = 0x%-16llx QPID        = 0x%-16llx NoSnoop      ="\
               "   %llu\n", get_tpt_bits(tpt, 216, 212),
               get_tpt_bits(tpt, 211, 192), get_tpt_bits(tpt, 191, 191));

        printf("DCA fld HI  =   %-16llu PBL_addr    = 0x%-16llx LLength      ="\
               " 0x%llx\n", get_tpt_bits(tpt, 190, 189),
               get_tpt_bits(tpt, 188, 160), get_tpt_bits(tpt, 159, 128));

        printf("VA          = 0x%-16llx VA/FBO      = 0x%-16llx DCA fld LOW  ="\
               " 0x%llx\n", get_tpt_bits(tpt, 127, 96),
               get_tpt_bits(tpt, 95, 64), get_tpt_bits(tpt, 63, 56));

        printf("MW bind cnt = 0x%-16llx HLength     = 0x%-16llx\n",
               get_tpt_bits(tpt, 55, 32), get_tpt_bits(tpt, 31, 0));

}

int main ()
{
	u8 tpte[32] = {0x8a, 0xc0, 0x00, 0x01, 0xf5, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0c, 0xff, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa4, 0x70, 0x90, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03};
	print_tpt(tpte);
	return 0;
}

