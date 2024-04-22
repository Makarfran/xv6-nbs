
sbrk3:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fcntl.h"
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
  10:	83 ec 14             	sub    $0x14,%esp
  int fh = open ("README", O_RDONLY);
  13:	6a 00                	push   $0x0
  15:	68 48 03 00 00       	push   $0x348
  1a:	e8 ab 00 00 00       	call   ca <open>
  1f:	89 c3                	mov    %eax,%ebx

  char* a = sbrk (15000);
  21:	c7 04 24 98 3a 00 00 	movl   $0x3a98,(%esp)
  28:	e8 e5 00 00 00       	call   112 <sbrk>

  read (fh, a+8192, 50);
  2d:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  33:	83 c4 0c             	add    $0xc,%esp
  36:	6a 32                	push   $0x32
  38:	56                   	push   %esi
  39:	53                   	push   %ebx
  3a:	e8 63 00 00 00       	call   a2 <read>

  // Debe imprimir los 50 primeros caracteres de README
  printf (1, "Debe imprimir los 50 primeros caracteres de README:\n");
  3f:	83 c4 08             	add    $0x8,%esp
  42:	68 54 03 00 00       	push   $0x354
  47:	6a 01                	push   $0x1
  49:	e8 97 01 00 00       	call   1e5 <printf>
  printf (1, "%s\n", a+8192);
  4e:	83 c4 0c             	add    $0xc,%esp
  51:	56                   	push   %esi
  52:	68 4f 03 00 00       	push   $0x34f
  57:	6a 01                	push   $0x1
  59:	e8 87 01 00 00       	call   1e5 <printf>

  close (fh);
  5e:	89 1c 24             	mov    %ebx,(%esp)
  61:	e8 4c 00 00 00       	call   b2 <close>

  exit(0);
  66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6d:	e8 18 00 00 00       	call   8a <exit>
}
  72:	b8 00 00 00 00       	mov    $0x0,%eax
  77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  7a:	59                   	pop    %ecx
  7b:	5b                   	pop    %ebx
  7c:	5e                   	pop    %esi
  7d:	5d                   	pop    %ebp
  7e:	8d 61 fc             	lea    -0x4(%ecx),%esp
  81:	c3                   	ret    

00000082 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  82:	b8 01 00 00 00       	mov    $0x1,%eax
  87:	cd 40                	int    $0x40
  89:	c3                   	ret    

0000008a <exit>:
SYSCALL(exit)
  8a:	b8 02 00 00 00       	mov    $0x2,%eax
  8f:	cd 40                	int    $0x40
  91:	c3                   	ret    

00000092 <wait>:
SYSCALL(wait)
  92:	b8 03 00 00 00       	mov    $0x3,%eax
  97:	cd 40                	int    $0x40
  99:	c3                   	ret    

0000009a <pipe>:
SYSCALL(pipe)
  9a:	b8 04 00 00 00       	mov    $0x4,%eax
  9f:	cd 40                	int    $0x40
  a1:	c3                   	ret    

000000a2 <read>:
SYSCALL(read)
  a2:	b8 05 00 00 00       	mov    $0x5,%eax
  a7:	cd 40                	int    $0x40
  a9:	c3                   	ret    

000000aa <write>:
SYSCALL(write)
  aa:	b8 10 00 00 00       	mov    $0x10,%eax
  af:	cd 40                	int    $0x40
  b1:	c3                   	ret    

000000b2 <close>:
SYSCALL(close)
  b2:	b8 15 00 00 00       	mov    $0x15,%eax
  b7:	cd 40                	int    $0x40
  b9:	c3                   	ret    

000000ba <kill>:
SYSCALL(kill)
  ba:	b8 06 00 00 00       	mov    $0x6,%eax
  bf:	cd 40                	int    $0x40
  c1:	c3                   	ret    

000000c2 <exec>:
SYSCALL(exec)
  c2:	b8 07 00 00 00       	mov    $0x7,%eax
  c7:	cd 40                	int    $0x40
  c9:	c3                   	ret    

000000ca <open>:
SYSCALL(open)
  ca:	b8 0f 00 00 00       	mov    $0xf,%eax
  cf:	cd 40                	int    $0x40
  d1:	c3                   	ret    

000000d2 <mknod>:
SYSCALL(mknod)
  d2:	b8 11 00 00 00       	mov    $0x11,%eax
  d7:	cd 40                	int    $0x40
  d9:	c3                   	ret    

000000da <unlink>:
SYSCALL(unlink)
  da:	b8 12 00 00 00       	mov    $0x12,%eax
  df:	cd 40                	int    $0x40
  e1:	c3                   	ret    

000000e2 <fstat>:
SYSCALL(fstat)
  e2:	b8 08 00 00 00       	mov    $0x8,%eax
  e7:	cd 40                	int    $0x40
  e9:	c3                   	ret    

000000ea <link>:
SYSCALL(link)
  ea:	b8 13 00 00 00       	mov    $0x13,%eax
  ef:	cd 40                	int    $0x40
  f1:	c3                   	ret    

000000f2 <mkdir>:
SYSCALL(mkdir)
  f2:	b8 14 00 00 00       	mov    $0x14,%eax
  f7:	cd 40                	int    $0x40
  f9:	c3                   	ret    

000000fa <chdir>:
SYSCALL(chdir)
  fa:	b8 09 00 00 00       	mov    $0x9,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <dup>:
SYSCALL(dup)
 102:	b8 0a 00 00 00       	mov    $0xa,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <getpid>:
SYSCALL(getpid)
 10a:	b8 0b 00 00 00       	mov    $0xb,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <sbrk>:
SYSCALL(sbrk)
 112:	b8 0c 00 00 00       	mov    $0xc,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <sleep>:
SYSCALL(sleep)
 11a:	b8 0d 00 00 00       	mov    $0xd,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <uptime>:
SYSCALL(uptime)
 122:	b8 0e 00 00 00       	mov    $0xe,%eax
 127:	cd 40                	int    $0x40
 129:	c3                   	ret    

0000012a <date>:
SYSCALL(date)
 12a:	b8 16 00 00 00       	mov    $0x16,%eax
 12f:	cd 40                	int    $0x40
 131:	c3                   	ret    

00000132 <dup2>:
SYSCALL(dup2)
 132:	b8 17 00 00 00       	mov    $0x17,%eax
 137:	cd 40                	int    $0x40
 139:	c3                   	ret    

0000013a <phmem>:
SYSCALL(phmem)
 13a:	b8 18 00 00 00       	mov    $0x18,%eax
 13f:	cd 40                	int    $0x40
 141:	c3                   	ret    

00000142 <getprio>:
SYSCALL(getprio)
 142:	b8 19 00 00 00       	mov    $0x19,%eax
 147:	cd 40                	int    $0x40
 149:	c3                   	ret    

0000014a <setprio>:
SYSCALL(setprio)
 14a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	83 ec 1c             	sub    $0x1c,%esp
 158:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 15b:	6a 01                	push   $0x1
 15d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 160:	52                   	push   %edx
 161:	50                   	push   %eax
 162:	e8 43 ff ff ff       	call   aa <write>
}
 167:	83 c4 10             	add    $0x10,%esp
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	57                   	push   %edi
 170:	56                   	push   %esi
 171:	53                   	push   %ebx
 172:	83 ec 2c             	sub    $0x2c,%esp
 175:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 178:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 17a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 17e:	74 04                	je     184 <printint+0x18>
 180:	85 d2                	test   %edx,%edx
 182:	78 3c                	js     1c0 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 184:	89 d1                	mov    %edx,%ecx
  neg = 0;
 186:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 18d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 192:	89 c8                	mov    %ecx,%eax
 194:	ba 00 00 00 00       	mov    $0x0,%edx
 199:	f7 f6                	div    %esi
 19b:	89 df                	mov    %ebx,%edi
 19d:	43                   	inc    %ebx
 19e:	8a 92 e8 03 00 00    	mov    0x3e8(%edx),%dl
 1a4:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1a8:	89 ca                	mov    %ecx,%edx
 1aa:	89 c1                	mov    %eax,%ecx
 1ac:	39 d6                	cmp    %edx,%esi
 1ae:	76 e2                	jbe    192 <printint+0x26>
  if(neg)
 1b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1b4:	74 24                	je     1da <printint+0x6e>
    buf[i++] = '-';
 1b6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1bb:	8d 5f 02             	lea    0x2(%edi),%ebx
 1be:	eb 1a                	jmp    1da <printint+0x6e>
    x = -xx;
 1c0:	89 d1                	mov    %edx,%ecx
 1c2:	f7 d9                	neg    %ecx
    neg = 1;
 1c4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1cb:	eb c0                	jmp    18d <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1cd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1d5:	e8 78 ff ff ff       	call   152 <putc>
  while(--i >= 0)
 1da:	4b                   	dec    %ebx
 1db:	79 f0                	jns    1cd <printint+0x61>
}
 1dd:	83 c4 2c             	add    $0x2c,%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	57                   	push   %edi
 1e9:	56                   	push   %esi
 1ea:	53                   	push   %ebx
 1eb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1ee:	8d 45 10             	lea    0x10(%ebp),%eax
 1f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1f4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1f9:	bb 00 00 00 00       	mov    $0x0,%ebx
 1fe:	eb 12                	jmp    212 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 200:	89 fa                	mov    %edi,%edx
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	e8 48 ff ff ff       	call   152 <putc>
 20a:	eb 05                	jmp    211 <printf+0x2c>
      }
    } else if(state == '%'){
 20c:	83 fe 25             	cmp    $0x25,%esi
 20f:	74 22                	je     233 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 211:	43                   	inc    %ebx
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	8a 04 18             	mov    (%eax,%ebx,1),%al
 218:	84 c0                	test   %al,%al
 21a:	0f 84 1d 01 00 00    	je     33d <printf+0x158>
    c = fmt[i] & 0xff;
 220:	0f be f8             	movsbl %al,%edi
 223:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 226:	85 f6                	test   %esi,%esi
 228:	75 e2                	jne    20c <printf+0x27>
      if(c == '%'){
 22a:	83 f8 25             	cmp    $0x25,%eax
 22d:	75 d1                	jne    200 <printf+0x1b>
        state = '%';
 22f:	89 c6                	mov    %eax,%esi
 231:	eb de                	jmp    211 <printf+0x2c>
      if(c == 'd'){
 233:	83 f8 25             	cmp    $0x25,%eax
 236:	0f 84 cc 00 00 00    	je     308 <printf+0x123>
 23c:	0f 8c da 00 00 00    	jl     31c <printf+0x137>
 242:	83 f8 78             	cmp    $0x78,%eax
 245:	0f 8f d1 00 00 00    	jg     31c <printf+0x137>
 24b:	83 f8 63             	cmp    $0x63,%eax
 24e:	0f 8c c8 00 00 00    	jl     31c <printf+0x137>
 254:	83 e8 63             	sub    $0x63,%eax
 257:	83 f8 15             	cmp    $0x15,%eax
 25a:	0f 87 bc 00 00 00    	ja     31c <printf+0x137>
 260:	ff 24 85 90 03 00 00 	jmp    *0x390(,%eax,4)
        printint(fd, *ap, 10, 1);
 267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 26a:	8b 17                	mov    (%edi),%edx
 26c:	83 ec 0c             	sub    $0xc,%esp
 26f:	6a 01                	push   $0x1
 271:	b9 0a 00 00 00       	mov    $0xa,%ecx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	e8 ee fe ff ff       	call   16c <printint>
        ap++;
 27e:	83 c7 04             	add    $0x4,%edi
 281:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 284:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 287:	be 00 00 00 00       	mov    $0x0,%esi
 28c:	eb 83                	jmp    211 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 28e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 291:	8b 17                	mov    (%edi),%edx
 293:	83 ec 0c             	sub    $0xc,%esp
 296:	6a 00                	push   $0x0
 298:	b9 10 00 00 00       	mov    $0x10,%ecx
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	e8 c7 fe ff ff       	call   16c <printint>
        ap++;
 2a5:	83 c7 04             	add    $0x4,%edi
 2a8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ab:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ae:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2b3:	e9 59 ff ff ff       	jmp    211 <printf+0x2c>
        s = (char*)*ap;
 2b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2bb:	8b 30                	mov    (%eax),%esi
        ap++;
 2bd:	83 c0 04             	add    $0x4,%eax
 2c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2c3:	85 f6                	test   %esi,%esi
 2c5:	75 13                	jne    2da <printf+0xf5>
          s = "(null)";
 2c7:	be 89 03 00 00       	mov    $0x389,%esi
 2cc:	eb 0c                	jmp    2da <printf+0xf5>
          putc(fd, *s);
 2ce:	0f be d2             	movsbl %dl,%edx
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	e8 79 fe ff ff       	call   152 <putc>
          s++;
 2d9:	46                   	inc    %esi
        while(*s != 0){
 2da:	8a 16                	mov    (%esi),%dl
 2dc:	84 d2                	test   %dl,%dl
 2de:	75 ee                	jne    2ce <printf+0xe9>
      state = 0;
 2e0:	be 00 00 00 00       	mov    $0x0,%esi
 2e5:	e9 27 ff ff ff       	jmp    211 <printf+0x2c>
        putc(fd, *ap);
 2ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ed:	0f be 17             	movsbl (%edi),%edx
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	e8 5a fe ff ff       	call   152 <putc>
        ap++;
 2f8:	83 c7 04             	add    $0x4,%edi
 2fb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2fe:	be 00 00 00 00       	mov    $0x0,%esi
 303:	e9 09 ff ff ff       	jmp    211 <printf+0x2c>
        putc(fd, c);
 308:	89 fa                	mov    %edi,%edx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	e8 40 fe ff ff       	call   152 <putc>
      state = 0;
 312:	be 00 00 00 00       	mov    $0x0,%esi
 317:	e9 f5 fe ff ff       	jmp    211 <printf+0x2c>
        putc(fd, '%');
 31c:	ba 25 00 00 00       	mov    $0x25,%edx
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	e8 29 fe ff ff       	call   152 <putc>
        putc(fd, c);
 329:	89 fa                	mov    %edi,%edx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	e8 1f fe ff ff       	call   152 <putc>
      state = 0;
 333:	be 00 00 00 00       	mov    $0x0,%esi
 338:	e9 d4 fe ff ff       	jmp    211 <printf+0x2c>
    }
  }
}
 33d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    
