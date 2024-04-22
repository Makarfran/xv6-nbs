
sbrk4:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 18             	sub    $0x18,%esp
  char* a = sbrk (15000);
  13:	68 98 3a 00 00       	push   $0x3a98
  18:	e8 db 01 00 00       	call   1f8 <sbrk>
  1d:	89 c3                	mov    %eax,%ebx

  fork();
  1f:	e8 44 01 00 00       	call   168 <fork>

  a[500] = 1;
  24:	c6 83 f4 01 00 00 01 	movb   $0x1,0x1f4(%ebx)

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  2b:	8d b3 98 3a 00 00    	lea    0x3a98(%ebx),%esi
  31:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  38:	e8 bb 01 00 00       	call   1f8 <sbrk>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 c6                	cmp    %eax,%esi
  42:	0f 85 fd 00 00 00    	jne    145 <main+0x145>
  {
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
    exit(1);
  }

  if (a != sbrk (0))
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	6a 00                	push   $0x0
  4d:	e8 a6 01 00 00       	call   1f8 <sbrk>
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 c3                	cmp    %eax,%ebx
  57:	74 1e                	je     77 <main+0x77>
  {
    printf (1, "sbrk() con cero fallÃ³.\n");
  59:	83 ec 08             	sub    $0x8,%esp
  5c:	68 55 04 00 00       	push   $0x455
  61:	6a 01                	push   $0x1
  63:	e8 63 02 00 00       	call   2cb <printf>
    exit(2);
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 fc 00 00 00       	call   170 <exit>
  74:	83 c4 10             	add    $0x10,%esp
  }

  if (a != sbrk (15000))
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	68 98 3a 00 00       	push   $0x3a98
  7f:	e8 74 01 00 00       	call   1f8 <sbrk>
  84:	83 c4 10             	add    $0x10,%esp
  87:	39 c3                	cmp    %eax,%ebx
  89:	74 1e                	je     a9 <main+0xa9>
  {
    printf (1, "sbrk() negativo fallÃ³.\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 70 04 00 00       	push   $0x470
  93:	6a 01                	push   $0x1
  95:	e8 31 02 00 00       	call   2cb <printf>
    exit(3);
  9a:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  a1:	e8 ca 00 00 00       	call   170 <exit>
  a6:	83 c4 10             	add    $0x10,%esp
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]);
  a9:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  af:	40                   	inc    %eax
  b0:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  b6:	83 ec 04             	sub    $0x4,%esp
  b9:	0f be c0             	movsbl %al,%eax
  bc:	50                   	push   %eax
  bd:	68 8b 04 00 00       	push   $0x48b
  c2:	6a 01                	push   $0x1
  c4:	e8 02 02 00 00       	call   2cb <printf>

  a=sbrk (-15000);
  c9:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  d0:	e8 23 01 00 00       	call   1f8 <sbrk>

  a=sbrk(1024*4096*2);
  d5:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
  dc:	e8 17 01 00 00       	call   1f8 <sbrk>
  e1:	89 c3                	mov    %eax,%ebx

  fork();
  e3:	e8 80 00 00 00       	call   168 <fork>

  a[600*4096*2] = 1;
  e8:	c6 83 00 00 4b 00 01 	movb   $0x1,0x4b0000(%ebx)

  sbrk(-1024*4096*2);
  ef:	c7 04 24 00 00 80 ff 	movl   $0xff800000,(%esp)
  f6:	e8 fd 00 00 00       	call   1f8 <sbrk>

  a=sbrk(1024*4096*2);
  fb:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
 102:	e8 f1 00 00 00       	call   1f8 <sbrk>

  printf (1, "Debe imprimir 1: %d.\n", ++a[600*4096*2]);
 107:	8a 88 00 00 4b 00    	mov    0x4b0000(%eax),%cl
 10d:	8d 51 01             	lea    0x1(%ecx),%edx
 110:	88 90 00 00 4b 00    	mov    %dl,0x4b0000(%eax)
 116:	83 c4 0c             	add    $0xc,%esp
 119:	0f be d2             	movsbl %dl,%edx
 11c:	52                   	push   %edx
 11d:	68 8b 04 00 00       	push   $0x48b
 122:	6a 01                	push   $0x1
 124:	e8 a2 01 00 00       	call   2cb <printf>
 

  exit(0);
 129:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 130:	e8 3b 00 00 00       	call   170 <exit>
}
 135:	b8 00 00 00 00       	mov    $0x0,%eax
 13a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13d:	59                   	pop    %ecx
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5d                   	pop    %ebp
 141:	8d 61 fc             	lea    -0x4(%ecx),%esp
 144:	c3                   	ret    
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
 145:	83 ec 08             	sub    $0x8,%esp
 148:	68 2c 04 00 00       	push   $0x42c
 14d:	6a 01                	push   $0x1
 14f:	e8 77 01 00 00       	call   2cb <printf>
    exit(1);
 154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15b:	e8 10 00 00 00       	call   170 <exit>
 160:	83 c4 10             	add    $0x10,%esp
 163:	e9 e0 fe ff ff       	jmp    48 <main+0x48>

00000168 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 168:	b8 01 00 00 00       	mov    $0x1,%eax
 16d:	cd 40                	int    $0x40
 16f:	c3                   	ret    

00000170 <exit>:
SYSCALL(exit)
 170:	b8 02 00 00 00       	mov    $0x2,%eax
 175:	cd 40                	int    $0x40
 177:	c3                   	ret    

00000178 <wait>:
SYSCALL(wait)
 178:	b8 03 00 00 00       	mov    $0x3,%eax
 17d:	cd 40                	int    $0x40
 17f:	c3                   	ret    

00000180 <pipe>:
SYSCALL(pipe)
 180:	b8 04 00 00 00       	mov    $0x4,%eax
 185:	cd 40                	int    $0x40
 187:	c3                   	ret    

00000188 <read>:
SYSCALL(read)
 188:	b8 05 00 00 00       	mov    $0x5,%eax
 18d:	cd 40                	int    $0x40
 18f:	c3                   	ret    

00000190 <write>:
SYSCALL(write)
 190:	b8 10 00 00 00       	mov    $0x10,%eax
 195:	cd 40                	int    $0x40
 197:	c3                   	ret    

00000198 <close>:
SYSCALL(close)
 198:	b8 15 00 00 00       	mov    $0x15,%eax
 19d:	cd 40                	int    $0x40
 19f:	c3                   	ret    

000001a0 <kill>:
SYSCALL(kill)
 1a0:	b8 06 00 00 00       	mov    $0x6,%eax
 1a5:	cd 40                	int    $0x40
 1a7:	c3                   	ret    

000001a8 <exec>:
SYSCALL(exec)
 1a8:	b8 07 00 00 00       	mov    $0x7,%eax
 1ad:	cd 40                	int    $0x40
 1af:	c3                   	ret    

000001b0 <open>:
SYSCALL(open)
 1b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 1b5:	cd 40                	int    $0x40
 1b7:	c3                   	ret    

000001b8 <mknod>:
SYSCALL(mknod)
 1b8:	b8 11 00 00 00       	mov    $0x11,%eax
 1bd:	cd 40                	int    $0x40
 1bf:	c3                   	ret    

000001c0 <unlink>:
SYSCALL(unlink)
 1c0:	b8 12 00 00 00       	mov    $0x12,%eax
 1c5:	cd 40                	int    $0x40
 1c7:	c3                   	ret    

000001c8 <fstat>:
SYSCALL(fstat)
 1c8:	b8 08 00 00 00       	mov    $0x8,%eax
 1cd:	cd 40                	int    $0x40
 1cf:	c3                   	ret    

000001d0 <link>:
SYSCALL(link)
 1d0:	b8 13 00 00 00       	mov    $0x13,%eax
 1d5:	cd 40                	int    $0x40
 1d7:	c3                   	ret    

000001d8 <mkdir>:
SYSCALL(mkdir)
 1d8:	b8 14 00 00 00       	mov    $0x14,%eax
 1dd:	cd 40                	int    $0x40
 1df:	c3                   	ret    

000001e0 <chdir>:
SYSCALL(chdir)
 1e0:	b8 09 00 00 00       	mov    $0x9,%eax
 1e5:	cd 40                	int    $0x40
 1e7:	c3                   	ret    

000001e8 <dup>:
SYSCALL(dup)
 1e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <getpid>:
SYSCALL(getpid)
 1f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <sbrk>:
SYSCALL(sbrk)
 1f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <sleep>:
SYSCALL(sleep)
 200:	b8 0d 00 00 00       	mov    $0xd,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <uptime>:
SYSCALL(uptime)
 208:	b8 0e 00 00 00       	mov    $0xe,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <date>:
SYSCALL(date)
 210:	b8 16 00 00 00       	mov    $0x16,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <dup2>:
SYSCALL(dup2)
 218:	b8 17 00 00 00       	mov    $0x17,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <phmem>:
SYSCALL(phmem)
 220:	b8 18 00 00 00       	mov    $0x18,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <getprio>:
SYSCALL(getprio)
 228:	b8 19 00 00 00       	mov    $0x19,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <setprio>:
SYSCALL(setprio)
 230:	b8 1a 00 00 00       	mov    $0x1a,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 1c             	sub    $0x1c,%esp
 23e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 241:	6a 01                	push   $0x1
 243:	8d 55 f4             	lea    -0xc(%ebp),%edx
 246:	52                   	push   %edx
 247:	50                   	push   %eax
 248:	e8 43 ff ff ff       	call   190 <write>
}
 24d:	83 c4 10             	add    $0x10,%esp
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	57                   	push   %edi
 256:	56                   	push   %esi
 257:	53                   	push   %ebx
 258:	83 ec 2c             	sub    $0x2c,%esp
 25b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 25e:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 264:	74 04                	je     26a <printint+0x18>
 266:	85 d2                	test   %edx,%edx
 268:	78 3c                	js     2a6 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 26a:	89 d1                	mov    %edx,%ecx
  neg = 0;
 26c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 273:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 278:	89 c8                	mov    %ecx,%eax
 27a:	ba 00 00 00 00       	mov    $0x0,%edx
 27f:	f7 f6                	div    %esi
 281:	89 df                	mov    %ebx,%edi
 283:	43                   	inc    %ebx
 284:	8a 92 00 05 00 00    	mov    0x500(%edx),%dl
 28a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 28e:	89 ca                	mov    %ecx,%edx
 290:	89 c1                	mov    %eax,%ecx
 292:	39 d6                	cmp    %edx,%esi
 294:	76 e2                	jbe    278 <printint+0x26>
  if(neg)
 296:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 29a:	74 24                	je     2c0 <printint+0x6e>
    buf[i++] = '-';
 29c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2a1:	8d 5f 02             	lea    0x2(%edi),%ebx
 2a4:	eb 1a                	jmp    2c0 <printint+0x6e>
    x = -xx;
 2a6:	89 d1                	mov    %edx,%ecx
 2a8:	f7 d9                	neg    %ecx
    neg = 1;
 2aa:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 2b1:	eb c0                	jmp    273 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 2b3:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2bb:	e8 78 ff ff ff       	call   238 <putc>
  while(--i >= 0)
 2c0:	4b                   	dec    %ebx
 2c1:	79 f0                	jns    2b3 <printint+0x61>
}
 2c3:	83 c4 2c             	add    $0x2c,%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	57                   	push   %edi
 2cf:	56                   	push   %esi
 2d0:	53                   	push   %ebx
 2d1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2d4:	8d 45 10             	lea    0x10(%ebp),%eax
 2d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2da:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2df:	bb 00 00 00 00       	mov    $0x0,%ebx
 2e4:	eb 12                	jmp    2f8 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2e6:	89 fa                	mov    %edi,%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	e8 48 ff ff ff       	call   238 <putc>
 2f0:	eb 05                	jmp    2f7 <printf+0x2c>
      }
    } else if(state == '%'){
 2f2:	83 fe 25             	cmp    $0x25,%esi
 2f5:	74 22                	je     319 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 2f7:	43                   	inc    %ebx
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2fe:	84 c0                	test   %al,%al
 300:	0f 84 1d 01 00 00    	je     423 <printf+0x158>
    c = fmt[i] & 0xff;
 306:	0f be f8             	movsbl %al,%edi
 309:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 30c:	85 f6                	test   %esi,%esi
 30e:	75 e2                	jne    2f2 <printf+0x27>
      if(c == '%'){
 310:	83 f8 25             	cmp    $0x25,%eax
 313:	75 d1                	jne    2e6 <printf+0x1b>
        state = '%';
 315:	89 c6                	mov    %eax,%esi
 317:	eb de                	jmp    2f7 <printf+0x2c>
      if(c == 'd'){
 319:	83 f8 25             	cmp    $0x25,%eax
 31c:	0f 84 cc 00 00 00    	je     3ee <printf+0x123>
 322:	0f 8c da 00 00 00    	jl     402 <printf+0x137>
 328:	83 f8 78             	cmp    $0x78,%eax
 32b:	0f 8f d1 00 00 00    	jg     402 <printf+0x137>
 331:	83 f8 63             	cmp    $0x63,%eax
 334:	0f 8c c8 00 00 00    	jl     402 <printf+0x137>
 33a:	83 e8 63             	sub    $0x63,%eax
 33d:	83 f8 15             	cmp    $0x15,%eax
 340:	0f 87 bc 00 00 00    	ja     402 <printf+0x137>
 346:	ff 24 85 a8 04 00 00 	jmp    *0x4a8(,%eax,4)
        printint(fd, *ap, 10, 1);
 34d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 350:	8b 17                	mov    (%edi),%edx
 352:	83 ec 0c             	sub    $0xc,%esp
 355:	6a 01                	push   $0x1
 357:	b9 0a 00 00 00       	mov    $0xa,%ecx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	e8 ee fe ff ff       	call   252 <printint>
        ap++;
 364:	83 c7 04             	add    $0x4,%edi
 367:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 36a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 36d:	be 00 00 00 00       	mov    $0x0,%esi
 372:	eb 83                	jmp    2f7 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 377:	8b 17                	mov    (%edi),%edx
 379:	83 ec 0c             	sub    $0xc,%esp
 37c:	6a 00                	push   $0x0
 37e:	b9 10 00 00 00       	mov    $0x10,%ecx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	e8 c7 fe ff ff       	call   252 <printint>
        ap++;
 38b:	83 c7 04             	add    $0x4,%edi
 38e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 391:	83 c4 10             	add    $0x10,%esp
      state = 0;
 394:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 399:	e9 59 ff ff ff       	jmp    2f7 <printf+0x2c>
        s = (char*)*ap;
 39e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3a1:	8b 30                	mov    (%eax),%esi
        ap++;
 3a3:	83 c0 04             	add    $0x4,%eax
 3a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3a9:	85 f6                	test   %esi,%esi
 3ab:	75 13                	jne    3c0 <printf+0xf5>
          s = "(null)";
 3ad:	be a1 04 00 00       	mov    $0x4a1,%esi
 3b2:	eb 0c                	jmp    3c0 <printf+0xf5>
          putc(fd, *s);
 3b4:	0f be d2             	movsbl %dl,%edx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	e8 79 fe ff ff       	call   238 <putc>
          s++;
 3bf:	46                   	inc    %esi
        while(*s != 0){
 3c0:	8a 16                	mov    (%esi),%dl
 3c2:	84 d2                	test   %dl,%dl
 3c4:	75 ee                	jne    3b4 <printf+0xe9>
      state = 0;
 3c6:	be 00 00 00 00       	mov    $0x0,%esi
 3cb:	e9 27 ff ff ff       	jmp    2f7 <printf+0x2c>
        putc(fd, *ap);
 3d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d3:	0f be 17             	movsbl (%edi),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	e8 5a fe ff ff       	call   238 <putc>
        ap++;
 3de:	83 c7 04             	add    $0x4,%edi
 3e1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3e4:	be 00 00 00 00       	mov    $0x0,%esi
 3e9:	e9 09 ff ff ff       	jmp    2f7 <printf+0x2c>
        putc(fd, c);
 3ee:	89 fa                	mov    %edi,%edx
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	e8 40 fe ff ff       	call   238 <putc>
      state = 0;
 3f8:	be 00 00 00 00       	mov    $0x0,%esi
 3fd:	e9 f5 fe ff ff       	jmp    2f7 <printf+0x2c>
        putc(fd, '%');
 402:	ba 25 00 00 00       	mov    $0x25,%edx
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	e8 29 fe ff ff       	call   238 <putc>
        putc(fd, c);
 40f:	89 fa                	mov    %edi,%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	e8 1f fe ff ff       	call   238 <putc>
      state = 0;
 419:	be 00 00 00 00       	mov    $0x0,%esi
 41e:	e9 d4 fe ff ff       	jmp    2f7 <printf+0x2c>
    }
  }
}
 423:	8d 65 f4             	lea    -0xc(%ebp),%esp
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    
