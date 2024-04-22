#include "types.h"
#include "user.h"
#include "date.h"
int
main (int argc , char *argv[])
{
  struct rtcdate r;
  if(date(&r)) {
  	printf(2 , "date failed\n") ;
  	exit(0);
  }
  printf(0, "Año:%d  Mes:%d  Dia:%d  Hora: %d:%d:%d  ", r.year, r.month, r.day, r.hour, r.minute, r.second);
  exit(0);
}
