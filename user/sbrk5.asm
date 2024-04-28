
sbrk5:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test1>:
#include "user.h"

int i = 1;

void test1()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
  char* a = sbrk (0);
   7:	6a 00                	push   $0x0
   9:	e8 42 01 00 00       	call   150 <sbrk>
   e:	89 c3                	mov    %eax,%ebx

  printf (1, "Debe fallar ahora:\n");
  10:	83 c4 08             	add    $0x8,%esp
  13:	68 84 03 00 00       	push   $0x384
  18:	6a 01                	push   $0x1
  1a:	e8 04 02 00 00       	call   223 <printf>
  *(a+1) = 1;  // Debe fallar
  1f:	c6 43 01 01          	movb   $0x1,0x1(%ebx)
}
  23:	83 c4 10             	add    $0x10,%esp
  26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  29:	c9                   	leave  
  2a:	c3                   	ret    

0000002b <test2>:

void test2()
{
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	83 ec 10             	sub    $0x10,%esp
  // PÃ¡gina de guarda:
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  31:	68 9c 03 00 00       	push   $0x39c
  36:	6a 01                	push   $0x1
  38:	e8 e6 01 00 00       	call   223 <printf>
  char* a = (char*)((int)&i + 4095);
  printf (1, "%d\n", a);
  3d:	83 c4 0c             	add    $0xc,%esp
  40:	68 a3 15 00 00       	push   $0x15a3
  45:	68 98 03 00 00       	push   $0x398
  4a:	6a 01                	push   $0x1
  4c:	e8 d2 01 00 00       	call   223 <printf>
  *a = 1;
  51:	c6 05 a3 15 00 00 01 	movb   $0x1,0x15a3
}
  58:	83 c4 10             	add    $0x10,%esp
  5b:	c9                   	leave  
  5c:	c3                   	ret    

0000005d <test3>:

void test3()
{
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	83 ec 10             	sub    $0x10,%esp
  // Acceder al nÃºcleo
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  63:	68 9c 03 00 00       	push   $0x39c
  68:	6a 01                	push   $0x1
  6a:	e8 b4 01 00 00       	call   223 <printf>
  char* a = (char*)0x80000001;
  *(a+1) = 1;  // Debe fallar (si lo anterior no ha fallado)
  6f:	c6 05 02 00 00 80 01 	movb   $0x1,0x80000002
}
  76:	83 c4 10             	add    $0x10,%esp
  79:	c9                   	leave  
  7a:	c3                   	ret    

0000007b <main>:


int
main(int argc, char *argv[])
{
  7b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7f:	83 e4 f0             	and    $0xfffffff0,%esp
  82:	ff 71 fc             	push   -0x4(%ecx)
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	51                   	push   %ecx
  89:	83 ec 0c             	sub    $0xc,%esp
  printf (1, "Este programa primero intenta acceder mas alla de sz.\n");
  8c:	68 d4 03 00 00       	push   $0x3d4
  91:	6a 01                	push   $0x1
  93:	e8 8b 01 00 00       	call   223 <printf>

  // MÃ¡s allÃ¡ de sz
  test1(); //110
  98:	e8 63 ff ff ff       	call   0 <test1>

  // Guarda
  test2(); //111
  9d:	e8 89 ff ff ff       	call   2b <test2>

  // NÃºcleo
  test3(); //111
  a2:	e8 b6 ff ff ff       	call   5d <test3>

  exit (0);
  a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ae:	e8 15 00 00 00       	call   c8 <exit>
}
  b3:	b8 00 00 00 00       	mov    $0x0,%eax
  b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  bb:	c9                   	leave  
  bc:	8d 61 fc             	lea    -0x4(%ecx),%esp
  bf:	c3                   	ret    

000000c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  c0:	b8 01 00 00 00       	mov    $0x1,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <exit>:
SYSCALL(exit)
  c8:	b8 02 00 00 00       	mov    $0x2,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <wait>:
SYSCALL(wait)
  d0:	b8 03 00 00 00       	mov    $0x3,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <pipe>:
SYSCALL(pipe)
  d8:	b8 04 00 00 00       	mov    $0x4,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <read>:
SYSCALL(read)
  e0:	b8 05 00 00 00       	mov    $0x5,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <write>:
SYSCALL(write)
  e8:	b8 10 00 00 00       	mov    $0x10,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <close>:
SYSCALL(close)
  f0:	b8 15 00 00 00       	mov    $0x15,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <kill>:
SYSCALL(kill)
  f8:	b8 06 00 00 00       	mov    $0x6,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <exec>:
SYSCALL(exec)
 100:	b8 07 00 00 00       	mov    $0x7,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <open>:
SYSCALL(open)
 108:	b8 0f 00 00 00       	mov    $0xf,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <mknod>:
SYSCALL(mknod)
 110:	b8 11 00 00 00       	mov    $0x11,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <unlink>:
SYSCALL(unlink)
 118:	b8 12 00 00 00       	mov    $0x12,%eax
 11d:	cd 40                	int    $0x40
 11f:	c3                   	ret    

00000120 <fstat>:
SYSCALL(fstat)
 120:	b8 08 00 00 00       	mov    $0x8,%eax
 125:	cd 40                	int    $0x40
 127:	c3                   	ret    

00000128 <link>:
SYSCALL(link)
 128:	b8 13 00 00 00       	mov    $0x13,%eax
 12d:	cd 40                	int    $0x40
 12f:	c3                   	ret    

00000130 <mkdir>:
SYSCALL(mkdir)
 130:	b8 14 00 00 00       	mov    $0x14,%eax
 135:	cd 40                	int    $0x40
 137:	c3                   	ret    

00000138 <chdir>:
SYSCALL(chdir)
 138:	b8 09 00 00 00       	mov    $0x9,%eax
 13d:	cd 40                	int    $0x40
 13f:	c3                   	ret    

00000140 <dup>:
SYSCALL(dup)
 140:	b8 0a 00 00 00       	mov    $0xa,%eax
 145:	cd 40                	int    $0x40
 147:	c3                   	ret    

00000148 <getpid>:
SYSCALL(getpid)
 148:	b8 0b 00 00 00       	mov    $0xb,%eax
 14d:	cd 40                	int    $0x40
 14f:	c3                   	ret    

00000150 <sbrk>:
SYSCALL(sbrk)
 150:	b8 0c 00 00 00       	mov    $0xc,%eax
 155:	cd 40                	int    $0x40
 157:	c3                   	ret    

00000158 <sleep>:
SYSCALL(sleep)
 158:	b8 0d 00 00 00       	mov    $0xd,%eax
 15d:	cd 40                	int    $0x40
 15f:	c3                   	ret    

00000160 <uptime>:
SYSCALL(uptime)
 160:	b8 0e 00 00 00       	mov    $0xe,%eax
 165:	cd 40                	int    $0x40
 167:	c3                   	ret    

00000168 <date>:
SYSCALL(date)
 168:	b8 16 00 00 00       	mov    $0x16,%eax
 16d:	cd 40                	int    $0x40
 16f:	c3                   	ret    

00000170 <dup2>:
SYSCALL(dup2)
 170:	b8 17 00 00 00       	mov    $0x17,%eax
 175:	cd 40                	int    $0x40
 177:	c3                   	ret    

00000178 <phmem>:
SYSCALL(phmem)
 178:	b8 18 00 00 00       	mov    $0x18,%eax
 17d:	cd 40                	int    $0x40
 17f:	c3                   	ret    

00000180 <getprio>:
SYSCALL(getprio)
 180:	b8 19 00 00 00       	mov    $0x19,%eax
 185:	cd 40                	int    $0x40
 187:	c3                   	ret    

00000188 <setprio>:
SYSCALL(setprio)
 188:	b8 1a 00 00 00       	mov    $0x1a,%eax
 18d:	cd 40                	int    $0x40
 18f:	c3                   	ret    

00000190 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 1c             	sub    $0x1c,%esp
 196:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 199:	6a 01                	push   $0x1
 19b:	8d 55 f4             	lea    -0xc(%ebp),%edx
 19e:	52                   	push   %edx
 19f:	50                   	push   %eax
 1a0:	e8 43 ff ff ff       	call   e8 <write>
}
 1a5:	83 c4 10             	add    $0x10,%esp
 1a8:	c9                   	leave  
 1a9:	c3                   	ret    

000001aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	57                   	push   %edi
 1ae:	56                   	push   %esi
 1af:	53                   	push   %ebx
 1b0:	83 ec 2c             	sub    $0x2c,%esp
 1b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1b6:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1bc:	74 04                	je     1c2 <printint+0x18>
 1be:	85 d2                	test   %edx,%edx
 1c0:	78 3c                	js     1fe <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 1c2:	89 d1                	mov    %edx,%ecx
  neg = 0;
 1c4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 1cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1d0:	89 c8                	mov    %ecx,%eax
 1d2:	ba 00 00 00 00       	mov    $0x0,%edx
 1d7:	f7 f6                	div    %esi
 1d9:	89 df                	mov    %ebx,%edi
 1db:	43                   	inc    %ebx
 1dc:	8a 92 6c 04 00 00    	mov    0x46c(%edx),%dl
 1e2:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1e6:	89 ca                	mov    %ecx,%edx
 1e8:	89 c1                	mov    %eax,%ecx
 1ea:	39 d6                	cmp    %edx,%esi
 1ec:	76 e2                	jbe    1d0 <printint+0x26>
  if(neg)
 1ee:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1f2:	74 24                	je     218 <printint+0x6e>
    buf[i++] = '-';
 1f4:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1f9:	8d 5f 02             	lea    0x2(%edi),%ebx
 1fc:	eb 1a                	jmp    218 <printint+0x6e>
    x = -xx;
 1fe:	89 d1                	mov    %edx,%ecx
 200:	f7 d9                	neg    %ecx
    neg = 1;
 202:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 209:	eb c0                	jmp    1cb <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 20b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 210:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 213:	e8 78 ff ff ff       	call   190 <putc>
  while(--i >= 0)
 218:	4b                   	dec    %ebx
 219:	79 f0                	jns    20b <printint+0x61>
}
 21b:	83 c4 2c             	add    $0x2c,%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    

00000223 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
 226:	57                   	push   %edi
 227:	56                   	push   %esi
 228:	53                   	push   %ebx
 229:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 22c:	8d 45 10             	lea    0x10(%ebp),%eax
 22f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 232:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 237:	bb 00 00 00 00       	mov    $0x0,%ebx
 23c:	eb 12                	jmp    250 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 23e:	89 fa                	mov    %edi,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	e8 48 ff ff ff       	call   190 <putc>
 248:	eb 05                	jmp    24f <printf+0x2c>
      }
    } else if(state == '%'){
 24a:	83 fe 25             	cmp    $0x25,%esi
 24d:	74 22                	je     271 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 24f:	43                   	inc    %ebx
 250:	8b 45 0c             	mov    0xc(%ebp),%eax
 253:	8a 04 18             	mov    (%eax,%ebx,1),%al
 256:	84 c0                	test   %al,%al
 258:	0f 84 1d 01 00 00    	je     37b <printf+0x158>
    c = fmt[i] & 0xff;
 25e:	0f be f8             	movsbl %al,%edi
 261:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 264:	85 f6                	test   %esi,%esi
 266:	75 e2                	jne    24a <printf+0x27>
      if(c == '%'){
 268:	83 f8 25             	cmp    $0x25,%eax
 26b:	75 d1                	jne    23e <printf+0x1b>
        state = '%';
 26d:	89 c6                	mov    %eax,%esi
 26f:	eb de                	jmp    24f <printf+0x2c>
      if(c == 'd'){
 271:	83 f8 25             	cmp    $0x25,%eax
 274:	0f 84 cc 00 00 00    	je     346 <printf+0x123>
 27a:	0f 8c da 00 00 00    	jl     35a <printf+0x137>
 280:	83 f8 78             	cmp    $0x78,%eax
 283:	0f 8f d1 00 00 00    	jg     35a <printf+0x137>
 289:	83 f8 63             	cmp    $0x63,%eax
 28c:	0f 8c c8 00 00 00    	jl     35a <printf+0x137>
 292:	83 e8 63             	sub    $0x63,%eax
 295:	83 f8 15             	cmp    $0x15,%eax
 298:	0f 87 bc 00 00 00    	ja     35a <printf+0x137>
 29e:	ff 24 85 14 04 00 00 	jmp    *0x414(,%eax,4)
        printint(fd, *ap, 10, 1);
 2a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a8:	8b 17                	mov    (%edi),%edx
 2aa:	83 ec 0c             	sub    $0xc,%esp
 2ad:	6a 01                	push   $0x1
 2af:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	e8 ee fe ff ff       	call   1aa <printint>
        ap++;
 2bc:	83 c7 04             	add    $0x4,%edi
 2bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2c2:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 2c5:	be 00 00 00 00       	mov    $0x0,%esi
 2ca:	eb 83                	jmp    24f <printf+0x2c>
        printint(fd, *ap, 16, 0);
 2cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2cf:	8b 17                	mov    (%edi),%edx
 2d1:	83 ec 0c             	sub    $0xc,%esp
 2d4:	6a 00                	push   $0x0
 2d6:	b9 10 00 00 00       	mov    $0x10,%ecx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	e8 c7 fe ff ff       	call   1aa <printint>
        ap++;
 2e3:	83 c7 04             	add    $0x4,%edi
 2e6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ec:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2f1:	e9 59 ff ff ff       	jmp    24f <printf+0x2c>
        s = (char*)*ap;
 2f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f9:	8b 30                	mov    (%eax),%esi
        ap++;
 2fb:	83 c0 04             	add    $0x4,%eax
 2fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 301:	85 f6                	test   %esi,%esi
 303:	75 13                	jne    318 <printf+0xf5>
          s = "(null)";
 305:	be 0b 04 00 00       	mov    $0x40b,%esi
 30a:	eb 0c                	jmp    318 <printf+0xf5>
          putc(fd, *s);
 30c:	0f be d2             	movsbl %dl,%edx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	e8 79 fe ff ff       	call   190 <putc>
          s++;
 317:	46                   	inc    %esi
        while(*s != 0){
 318:	8a 16                	mov    (%esi),%dl
 31a:	84 d2                	test   %dl,%dl
 31c:	75 ee                	jne    30c <printf+0xe9>
      state = 0;
 31e:	be 00 00 00 00       	mov    $0x0,%esi
 323:	e9 27 ff ff ff       	jmp    24f <printf+0x2c>
        putc(fd, *ap);
 328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32b:	0f be 17             	movsbl (%edi),%edx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	e8 5a fe ff ff       	call   190 <putc>
        ap++;
 336:	83 c7 04             	add    $0x4,%edi
 339:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 33c:	be 00 00 00 00       	mov    $0x0,%esi
 341:	e9 09 ff ff ff       	jmp    24f <printf+0x2c>
        putc(fd, c);
 346:	89 fa                	mov    %edi,%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	e8 40 fe ff ff       	call   190 <putc>
      state = 0;
 350:	be 00 00 00 00       	mov    $0x0,%esi
 355:	e9 f5 fe ff ff       	jmp    24f <printf+0x2c>
        putc(fd, '%');
 35a:	ba 25 00 00 00       	mov    $0x25,%edx
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	e8 29 fe ff ff       	call   190 <putc>
        putc(fd, c);
 367:	89 fa                	mov    %edi,%edx
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	e8 1f fe ff ff       	call   190 <putc>
      state = 0;
 371:	be 00 00 00 00       	mov    $0x0,%esi
 376:	e9 d4 fe ff ff       	jmp    24f <printf+0x2c>
    }
  }
}
 37b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37e:	5b                   	pop    %ebx
 37f:	5e                   	pop    %esi
 380:	5f                   	pop    %edi
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    
