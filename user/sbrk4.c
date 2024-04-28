#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  char* a = sbrk (15000);

  fork();

  a[500] = 1;

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  {
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
    exit(1);
  }

  if (a != sbrk (0))
  {
    printf (1, "sbrk() con cero fallÃ³.\n");
    exit(2);
  }

  if (a != sbrk (15000))
  {
    printf (1, "sbrk() negativo fallÃ³.\n");
    exit(3);
  }
  
  printf (1, "? Debe imprimir 1: %d.\n", ++a[500]);

  a=sbrk (-15000);

  a=sbrk(1024*4096*2);

  fork();
 
  a[600*4096*2] = 1;

  sbrk(-1024*4096*2);

  a=sbrk(1024*4096*2);
  
  printf (1, "! Debe imprimir 1: %d.\n", ++a[600*4096*2]);
 

  exit(0);
}
