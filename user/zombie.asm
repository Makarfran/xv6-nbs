
zombie:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 2a 00 00 00       	call   40 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 17                	jg     31 <main+0x31>
    sleep(5);  // Let child exit before parent.
  exit(0);
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 00                	push   $0x0
  1f:	e8 24 00 00 00       	call   48 <exit>
}
  24:	b8 00 00 00 00       	mov    $0x0,%eax
  29:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  2c:	c9                   	leave  
  2d:	8d 61 fc             	lea    -0x4(%ecx),%esp
  30:	c3                   	ret    
    sleep(5);  // Let child exit before parent.
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	6a 05                	push   $0x5
  36:	e8 9d 00 00 00       	call   d8 <sleep>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb da                	jmp    1a <main+0x1a>

00000040 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  40:	b8 01 00 00 00       	mov    $0x1,%eax
  45:	cd 40                	int    $0x40
  47:	c3                   	ret    

00000048 <exit>:
SYSCALL(exit)
  48:	b8 02 00 00 00       	mov    $0x2,%eax
  4d:	cd 40                	int    $0x40
  4f:	c3                   	ret    

00000050 <wait>:
SYSCALL(wait)
  50:	b8 03 00 00 00       	mov    $0x3,%eax
  55:	cd 40                	int    $0x40
  57:	c3                   	ret    

00000058 <pipe>:
SYSCALL(pipe)
  58:	b8 04 00 00 00       	mov    $0x4,%eax
  5d:	cd 40                	int    $0x40
  5f:	c3                   	ret    

00000060 <read>:
SYSCALL(read)
  60:	b8 05 00 00 00       	mov    $0x5,%eax
  65:	cd 40                	int    $0x40
  67:	c3                   	ret    

00000068 <write>:
SYSCALL(write)
  68:	b8 10 00 00 00       	mov    $0x10,%eax
  6d:	cd 40                	int    $0x40
  6f:	c3                   	ret    

00000070 <close>:
SYSCALL(close)
  70:	b8 15 00 00 00       	mov    $0x15,%eax
  75:	cd 40                	int    $0x40
  77:	c3                   	ret    

00000078 <kill>:
SYSCALL(kill)
  78:	b8 06 00 00 00       	mov    $0x6,%eax
  7d:	cd 40                	int    $0x40
  7f:	c3                   	ret    

00000080 <exec>:
SYSCALL(exec)
  80:	b8 07 00 00 00       	mov    $0x7,%eax
  85:	cd 40                	int    $0x40
  87:	c3                   	ret    

00000088 <open>:
SYSCALL(open)
  88:	b8 0f 00 00 00       	mov    $0xf,%eax
  8d:	cd 40                	int    $0x40
  8f:	c3                   	ret    

00000090 <mknod>:
SYSCALL(mknod)
  90:	b8 11 00 00 00       	mov    $0x11,%eax
  95:	cd 40                	int    $0x40
  97:	c3                   	ret    

00000098 <unlink>:
SYSCALL(unlink)
  98:	b8 12 00 00 00       	mov    $0x12,%eax
  9d:	cd 40                	int    $0x40
  9f:	c3                   	ret    

000000a0 <fstat>:
SYSCALL(fstat)
  a0:	b8 08 00 00 00       	mov    $0x8,%eax
  a5:	cd 40                	int    $0x40
  a7:	c3                   	ret    

000000a8 <link>:
SYSCALL(link)
  a8:	b8 13 00 00 00       	mov    $0x13,%eax
  ad:	cd 40                	int    $0x40
  af:	c3                   	ret    

000000b0 <mkdir>:
SYSCALL(mkdir)
  b0:	b8 14 00 00 00       	mov    $0x14,%eax
  b5:	cd 40                	int    $0x40
  b7:	c3                   	ret    

000000b8 <chdir>:
SYSCALL(chdir)
  b8:	b8 09 00 00 00       	mov    $0x9,%eax
  bd:	cd 40                	int    $0x40
  bf:	c3                   	ret    

000000c0 <dup>:
SYSCALL(dup)
  c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <getpid>:
SYSCALL(getpid)
  c8:	b8 0b 00 00 00       	mov    $0xb,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <sbrk>:
SYSCALL(sbrk)
  d0:	b8 0c 00 00 00       	mov    $0xc,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <sleep>:
SYSCALL(sleep)
  d8:	b8 0d 00 00 00       	mov    $0xd,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <uptime>:
SYSCALL(uptime)
  e0:	b8 0e 00 00 00       	mov    $0xe,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <date>:
SYSCALL(date)
  e8:	b8 16 00 00 00       	mov    $0x16,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <dup2>:
SYSCALL(dup2)
  f0:	b8 17 00 00 00       	mov    $0x17,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <phmem>:
SYSCALL(phmem)
  f8:	b8 18 00 00 00       	mov    $0x18,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <getprio>:
SYSCALL(getprio)
 100:	b8 19 00 00 00       	mov    $0x19,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <setprio>:
SYSCALL(setprio)
 108:	b8 1a 00 00 00       	mov    $0x1a,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    
