
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
   9:	e8 38 01 00 00       	call   146 <sbrk>
   e:	89 c3                	mov    %eax,%ebx

  printf (1, "Debe fallar ahora:\n");
  10:	83 c4 08             	add    $0x8,%esp
  13:	68 7c 03 00 00       	push   $0x37c
  18:	6a 01                	push   $0x1
  1a:	e8 fa 01 00 00       	call   219 <printf>
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
  31:	68 94 03 00 00       	push   $0x394
  36:	6a 01                	push   $0x1
  38:	e8 dc 01 00 00       	call   219 <printf>
  char* a = (char*)((int)&i + 4095);
  printf (1, "%d\n", a);
  3d:	83 c4 0c             	add    $0xc,%esp
  40:	68 9b 15 00 00       	push   $0x159b
  45:	68 90 03 00 00       	push   $0x390
  4a:	6a 01                	push   $0x1
  4c:	e8 c8 01 00 00       	call   219 <printf>
  *a = 1;
  51:	c6 05 9b 15 00 00 01 	movb   $0x1,0x159b
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
  63:	68 94 03 00 00       	push   $0x394
  68:	6a 01                	push   $0x1
  6a:	e8 aa 01 00 00       	call   219 <printf>
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
  8c:	68 cc 03 00 00       	push   $0x3cc
  91:	6a 01                	push   $0x1
  93:	e8 81 01 00 00       	call   219 <printf>

  // MÃ¡s allÃ¡ de sz
  //test1();

  // Guarda
  test2();
  98:	e8 8e ff ff ff       	call   2b <test2>

  // NÃºcleo
  //test3();

  exit (0);
  9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a4:	e8 15 00 00 00       	call   be <exit>
}
  a9:	b8 00 00 00 00       	mov    $0x0,%eax
  ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  b1:	c9                   	leave  
  b2:	8d 61 fc             	lea    -0x4(%ecx),%esp
  b5:	c3                   	ret    

000000b6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  b6:	b8 01 00 00 00       	mov    $0x1,%eax
  bb:	cd 40                	int    $0x40
  bd:	c3                   	ret    

000000be <exit>:
SYSCALL(exit)
  be:	b8 02 00 00 00       	mov    $0x2,%eax
  c3:	cd 40                	int    $0x40
  c5:	c3                   	ret    

000000c6 <wait>:
SYSCALL(wait)
  c6:	b8 03 00 00 00       	mov    $0x3,%eax
  cb:	cd 40                	int    $0x40
  cd:	c3                   	ret    

000000ce <pipe>:
SYSCALL(pipe)
  ce:	b8 04 00 00 00       	mov    $0x4,%eax
  d3:	cd 40                	int    $0x40
  d5:	c3                   	ret    

000000d6 <read>:
SYSCALL(read)
  d6:	b8 05 00 00 00       	mov    $0x5,%eax
  db:	cd 40                	int    $0x40
  dd:	c3                   	ret    

000000de <write>:
SYSCALL(write)
  de:	b8 10 00 00 00       	mov    $0x10,%eax
  e3:	cd 40                	int    $0x40
  e5:	c3                   	ret    

000000e6 <close>:
SYSCALL(close)
  e6:	b8 15 00 00 00       	mov    $0x15,%eax
  eb:	cd 40                	int    $0x40
  ed:	c3                   	ret    

000000ee <kill>:
SYSCALL(kill)
  ee:	b8 06 00 00 00       	mov    $0x6,%eax
  f3:	cd 40                	int    $0x40
  f5:	c3                   	ret    

000000f6 <exec>:
SYSCALL(exec)
  f6:	b8 07 00 00 00       	mov    $0x7,%eax
  fb:	cd 40                	int    $0x40
  fd:	c3                   	ret    

000000fe <open>:
SYSCALL(open)
  fe:	b8 0f 00 00 00       	mov    $0xf,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <mknod>:
SYSCALL(mknod)
 106:	b8 11 00 00 00       	mov    $0x11,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <unlink>:
SYSCALL(unlink)
 10e:	b8 12 00 00 00       	mov    $0x12,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <fstat>:
SYSCALL(fstat)
 116:	b8 08 00 00 00       	mov    $0x8,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    

0000011e <link>:
SYSCALL(link)
 11e:	b8 13 00 00 00       	mov    $0x13,%eax
 123:	cd 40                	int    $0x40
 125:	c3                   	ret    

00000126 <mkdir>:
SYSCALL(mkdir)
 126:	b8 14 00 00 00       	mov    $0x14,%eax
 12b:	cd 40                	int    $0x40
 12d:	c3                   	ret    

0000012e <chdir>:
SYSCALL(chdir)
 12e:	b8 09 00 00 00       	mov    $0x9,%eax
 133:	cd 40                	int    $0x40
 135:	c3                   	ret    

00000136 <dup>:
SYSCALL(dup)
 136:	b8 0a 00 00 00       	mov    $0xa,%eax
 13b:	cd 40                	int    $0x40
 13d:	c3                   	ret    

0000013e <getpid>:
SYSCALL(getpid)
 13e:	b8 0b 00 00 00       	mov    $0xb,%eax
 143:	cd 40                	int    $0x40
 145:	c3                   	ret    

00000146 <sbrk>:
SYSCALL(sbrk)
 146:	b8 0c 00 00 00       	mov    $0xc,%eax
 14b:	cd 40                	int    $0x40
 14d:	c3                   	ret    

0000014e <sleep>:
SYSCALL(sleep)
 14e:	b8 0d 00 00 00       	mov    $0xd,%eax
 153:	cd 40                	int    $0x40
 155:	c3                   	ret    

00000156 <uptime>:
SYSCALL(uptime)
 156:	b8 0e 00 00 00       	mov    $0xe,%eax
 15b:	cd 40                	int    $0x40
 15d:	c3                   	ret    

0000015e <date>:
SYSCALL(date)
 15e:	b8 16 00 00 00       	mov    $0x16,%eax
 163:	cd 40                	int    $0x40
 165:	c3                   	ret    

00000166 <dup2>:
SYSCALL(dup2)
 166:	b8 17 00 00 00       	mov    $0x17,%eax
 16b:	cd 40                	int    $0x40
 16d:	c3                   	ret    

0000016e <phmem>:
SYSCALL(phmem)
 16e:	b8 18 00 00 00       	mov    $0x18,%eax
 173:	cd 40                	int    $0x40
 175:	c3                   	ret    

00000176 <getprio>:
SYSCALL(getprio)
 176:	b8 19 00 00 00       	mov    $0x19,%eax
 17b:	cd 40                	int    $0x40
 17d:	c3                   	ret    

0000017e <setprio>:
SYSCALL(setprio)
 17e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 183:	cd 40                	int    $0x40
 185:	c3                   	ret    

00000186 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 1c             	sub    $0x1c,%esp
 18c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 18f:	6a 01                	push   $0x1
 191:	8d 55 f4             	lea    -0xc(%ebp),%edx
 194:	52                   	push   %edx
 195:	50                   	push   %eax
 196:	e8 43 ff ff ff       	call   de <write>
}
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
 1a6:	83 ec 2c             	sub    $0x2c,%esp
 1a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1ac:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1b2:	74 04                	je     1b8 <printint+0x18>
 1b4:	85 d2                	test   %edx,%edx
 1b6:	78 3c                	js     1f4 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 1b8:	89 d1                	mov    %edx,%ecx
  neg = 0;
 1ba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 1c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1c6:	89 c8                	mov    %ecx,%eax
 1c8:	ba 00 00 00 00       	mov    $0x0,%edx
 1cd:	f7 f6                	div    %esi
 1cf:	89 df                	mov    %ebx,%edi
 1d1:	43                   	inc    %ebx
 1d2:	8a 92 64 04 00 00    	mov    0x464(%edx),%dl
 1d8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1dc:	89 ca                	mov    %ecx,%edx
 1de:	89 c1                	mov    %eax,%ecx
 1e0:	39 d6                	cmp    %edx,%esi
 1e2:	76 e2                	jbe    1c6 <printint+0x26>
  if(neg)
 1e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1e8:	74 24                	je     20e <printint+0x6e>
    buf[i++] = '-';
 1ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1ef:	8d 5f 02             	lea    0x2(%edi),%ebx
 1f2:	eb 1a                	jmp    20e <printint+0x6e>
    x = -xx;
 1f4:	89 d1                	mov    %edx,%ecx
 1f6:	f7 d9                	neg    %ecx
    neg = 1;
 1f8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1ff:	eb c0                	jmp    1c1 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 201:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 206:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 209:	e8 78 ff ff ff       	call   186 <putc>
  while(--i >= 0)
 20e:	4b                   	dec    %ebx
 20f:	79 f0                	jns    201 <printint+0x61>
}
 211:	83 c4 2c             	add    $0x2c,%esp
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    

00000219 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	57                   	push   %edi
 21d:	56                   	push   %esi
 21e:	53                   	push   %ebx
 21f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 222:	8d 45 10             	lea    0x10(%ebp),%eax
 225:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 228:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 22d:	bb 00 00 00 00       	mov    $0x0,%ebx
 232:	eb 12                	jmp    246 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 234:	89 fa                	mov    %edi,%edx
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	e8 48 ff ff ff       	call   186 <putc>
 23e:	eb 05                	jmp    245 <printf+0x2c>
      }
    } else if(state == '%'){
 240:	83 fe 25             	cmp    $0x25,%esi
 243:	74 22                	je     267 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 245:	43                   	inc    %ebx
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	8a 04 18             	mov    (%eax,%ebx,1),%al
 24c:	84 c0                	test   %al,%al
 24e:	0f 84 1d 01 00 00    	je     371 <printf+0x158>
    c = fmt[i] & 0xff;
 254:	0f be f8             	movsbl %al,%edi
 257:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 25a:	85 f6                	test   %esi,%esi
 25c:	75 e2                	jne    240 <printf+0x27>
      if(c == '%'){
 25e:	83 f8 25             	cmp    $0x25,%eax
 261:	75 d1                	jne    234 <printf+0x1b>
        state = '%';
 263:	89 c6                	mov    %eax,%esi
 265:	eb de                	jmp    245 <printf+0x2c>
      if(c == 'd'){
 267:	83 f8 25             	cmp    $0x25,%eax
 26a:	0f 84 cc 00 00 00    	je     33c <printf+0x123>
 270:	0f 8c da 00 00 00    	jl     350 <printf+0x137>
 276:	83 f8 78             	cmp    $0x78,%eax
 279:	0f 8f d1 00 00 00    	jg     350 <printf+0x137>
 27f:	83 f8 63             	cmp    $0x63,%eax
 282:	0f 8c c8 00 00 00    	jl     350 <printf+0x137>
 288:	83 e8 63             	sub    $0x63,%eax
 28b:	83 f8 15             	cmp    $0x15,%eax
 28e:	0f 87 bc 00 00 00    	ja     350 <printf+0x137>
 294:	ff 24 85 0c 04 00 00 	jmp    *0x40c(,%eax,4)
        printint(fd, *ap, 10, 1);
 29b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29e:	8b 17                	mov    (%edi),%edx
 2a0:	83 ec 0c             	sub    $0xc,%esp
 2a3:	6a 01                	push   $0x1
 2a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	e8 ee fe ff ff       	call   1a0 <printint>
        ap++;
 2b2:	83 c7 04             	add    $0x4,%edi
 2b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2b8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 2bb:	be 00 00 00 00       	mov    $0x0,%esi
 2c0:	eb 83                	jmp    245 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 2c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c5:	8b 17                	mov    (%edi),%edx
 2c7:	83 ec 0c             	sub    $0xc,%esp
 2ca:	6a 00                	push   $0x0
 2cc:	b9 10 00 00 00       	mov    $0x10,%ecx
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	e8 c7 fe ff ff       	call   1a0 <printint>
        ap++;
 2d9:	83 c7 04             	add    $0x4,%edi
 2dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2e2:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2e7:	e9 59 ff ff ff       	jmp    245 <printf+0x2c>
        s = (char*)*ap;
 2ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ef:	8b 30                	mov    (%eax),%esi
        ap++;
 2f1:	83 c0 04             	add    $0x4,%eax
 2f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2f7:	85 f6                	test   %esi,%esi
 2f9:	75 13                	jne    30e <printf+0xf5>
          s = "(null)";
 2fb:	be 03 04 00 00       	mov    $0x403,%esi
 300:	eb 0c                	jmp    30e <printf+0xf5>
          putc(fd, *s);
 302:	0f be d2             	movsbl %dl,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	e8 79 fe ff ff       	call   186 <putc>
          s++;
 30d:	46                   	inc    %esi
        while(*s != 0){
 30e:	8a 16                	mov    (%esi),%dl
 310:	84 d2                	test   %dl,%dl
 312:	75 ee                	jne    302 <printf+0xe9>
      state = 0;
 314:	be 00 00 00 00       	mov    $0x0,%esi
 319:	e9 27 ff ff ff       	jmp    245 <printf+0x2c>
        putc(fd, *ap);
 31e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 321:	0f be 17             	movsbl (%edi),%edx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	e8 5a fe ff ff       	call   186 <putc>
        ap++;
 32c:	83 c7 04             	add    $0x4,%edi
 32f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 332:	be 00 00 00 00       	mov    $0x0,%esi
 337:	e9 09 ff ff ff       	jmp    245 <printf+0x2c>
        putc(fd, c);
 33c:	89 fa                	mov    %edi,%edx
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	e8 40 fe ff ff       	call   186 <putc>
      state = 0;
 346:	be 00 00 00 00       	mov    $0x0,%esi
 34b:	e9 f5 fe ff ff       	jmp    245 <printf+0x2c>
        putc(fd, '%');
 350:	ba 25 00 00 00       	mov    $0x25,%edx
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	e8 29 fe ff ff       	call   186 <putc>
        putc(fd, c);
 35d:	89 fa                	mov    %edi,%edx
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	e8 1f fe ff ff       	call   186 <putc>
      state = 0;
 367:	be 00 00 00 00       	mov    $0x0,%esi
 36c:	e9 d4 fe ff ff       	jmp    245 <printf+0x2c>
    }
  }
}
 371:	8d 65 f4             	lea    -0xc(%ebp),%esp
 374:	5b                   	pop    %ebx
 375:	5e                   	pop    %esi
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
