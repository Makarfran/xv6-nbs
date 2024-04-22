
ln:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	75 2e                	jne    45 <main+0x45>
    printf(2, "Usage: ln old new\n");
    exit(0);
  }
  if(link(argv[1], argv[2]) < 0)
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	ff 73 08             	push   0x8(%ebx)
  1d:	ff 73 04             	push   0x4(%ebx)
  20:	e8 bf 00 00 00       	call   e4 <link>
  25:	83 c4 10             	add    $0x10,%esp
  28:	85 c0                	test   %eax,%eax
  2a:	78 39                	js     65 <main+0x65>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	6a 00                	push   $0x0
  31:	e8 4e 00 00 00       	call   84 <exit>
}
  36:	b8 00 00 00 00       	mov    $0x0,%eax
  3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3e:	59                   	pop    %ecx
  3f:	5b                   	pop    %ebx
  40:	5d                   	pop    %ebp
  41:	8d 61 fc             	lea    -0x4(%ecx),%esp
  44:	c3                   	ret    
    printf(2, "Usage: ln old new\n");
  45:	83 ec 08             	sub    $0x8,%esp
  48:	68 40 03 00 00       	push   $0x340
  4d:	6a 02                	push   $0x2
  4f:	e8 8b 01 00 00       	call   1df <printf>
    exit(0);
  54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  5b:	e8 24 00 00 00       	call   84 <exit>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb b2                	jmp    17 <main+0x17>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  65:	ff 73 08             	push   0x8(%ebx)
  68:	ff 73 04             	push   0x4(%ebx)
  6b:	68 53 03 00 00       	push   $0x353
  70:	6a 02                	push   $0x2
  72:	e8 68 01 00 00       	call   1df <printf>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	eb b0                	jmp    2c <main+0x2c>

0000007c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  7c:	b8 01 00 00 00       	mov    $0x1,%eax
  81:	cd 40                	int    $0x40
  83:	c3                   	ret    

00000084 <exit>:
SYSCALL(exit)
  84:	b8 02 00 00 00       	mov    $0x2,%eax
  89:	cd 40                	int    $0x40
  8b:	c3                   	ret    

0000008c <wait>:
SYSCALL(wait)
  8c:	b8 03 00 00 00       	mov    $0x3,%eax
  91:	cd 40                	int    $0x40
  93:	c3                   	ret    

00000094 <pipe>:
SYSCALL(pipe)
  94:	b8 04 00 00 00       	mov    $0x4,%eax
  99:	cd 40                	int    $0x40
  9b:	c3                   	ret    

0000009c <read>:
SYSCALL(read)
  9c:	b8 05 00 00 00       	mov    $0x5,%eax
  a1:	cd 40                	int    $0x40
  a3:	c3                   	ret    

000000a4 <write>:
SYSCALL(write)
  a4:	b8 10 00 00 00       	mov    $0x10,%eax
  a9:	cd 40                	int    $0x40
  ab:	c3                   	ret    

000000ac <close>:
SYSCALL(close)
  ac:	b8 15 00 00 00       	mov    $0x15,%eax
  b1:	cd 40                	int    $0x40
  b3:	c3                   	ret    

000000b4 <kill>:
SYSCALL(kill)
  b4:	b8 06 00 00 00       	mov    $0x6,%eax
  b9:	cd 40                	int    $0x40
  bb:	c3                   	ret    

000000bc <exec>:
SYSCALL(exec)
  bc:	b8 07 00 00 00       	mov    $0x7,%eax
  c1:	cd 40                	int    $0x40
  c3:	c3                   	ret    

000000c4 <open>:
SYSCALL(open)
  c4:	b8 0f 00 00 00       	mov    $0xf,%eax
  c9:	cd 40                	int    $0x40
  cb:	c3                   	ret    

000000cc <mknod>:
SYSCALL(mknod)
  cc:	b8 11 00 00 00       	mov    $0x11,%eax
  d1:	cd 40                	int    $0x40
  d3:	c3                   	ret    

000000d4 <unlink>:
SYSCALL(unlink)
  d4:	b8 12 00 00 00       	mov    $0x12,%eax
  d9:	cd 40                	int    $0x40
  db:	c3                   	ret    

000000dc <fstat>:
SYSCALL(fstat)
  dc:	b8 08 00 00 00       	mov    $0x8,%eax
  e1:	cd 40                	int    $0x40
  e3:	c3                   	ret    

000000e4 <link>:
SYSCALL(link)
  e4:	b8 13 00 00 00       	mov    $0x13,%eax
  e9:	cd 40                	int    $0x40
  eb:	c3                   	ret    

000000ec <mkdir>:
SYSCALL(mkdir)
  ec:	b8 14 00 00 00       	mov    $0x14,%eax
  f1:	cd 40                	int    $0x40
  f3:	c3                   	ret    

000000f4 <chdir>:
SYSCALL(chdir)
  f4:	b8 09 00 00 00       	mov    $0x9,%eax
  f9:	cd 40                	int    $0x40
  fb:	c3                   	ret    

000000fc <dup>:
SYSCALL(dup)
  fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 101:	cd 40                	int    $0x40
 103:	c3                   	ret    

00000104 <getpid>:
SYSCALL(getpid)
 104:	b8 0b 00 00 00       	mov    $0xb,%eax
 109:	cd 40                	int    $0x40
 10b:	c3                   	ret    

0000010c <sbrk>:
SYSCALL(sbrk)
 10c:	b8 0c 00 00 00       	mov    $0xc,%eax
 111:	cd 40                	int    $0x40
 113:	c3                   	ret    

00000114 <sleep>:
SYSCALL(sleep)
 114:	b8 0d 00 00 00       	mov    $0xd,%eax
 119:	cd 40                	int    $0x40
 11b:	c3                   	ret    

0000011c <uptime>:
SYSCALL(uptime)
 11c:	b8 0e 00 00 00       	mov    $0xe,%eax
 121:	cd 40                	int    $0x40
 123:	c3                   	ret    

00000124 <date>:
SYSCALL(date)
 124:	b8 16 00 00 00       	mov    $0x16,%eax
 129:	cd 40                	int    $0x40
 12b:	c3                   	ret    

0000012c <dup2>:
SYSCALL(dup2)
 12c:	b8 17 00 00 00       	mov    $0x17,%eax
 131:	cd 40                	int    $0x40
 133:	c3                   	ret    

00000134 <phmem>:
SYSCALL(phmem)
 134:	b8 18 00 00 00       	mov    $0x18,%eax
 139:	cd 40                	int    $0x40
 13b:	c3                   	ret    

0000013c <getprio>:
SYSCALL(getprio)
 13c:	b8 19 00 00 00       	mov    $0x19,%eax
 141:	cd 40                	int    $0x40
 143:	c3                   	ret    

00000144 <setprio>:
SYSCALL(setprio)
 144:	b8 1a 00 00 00       	mov    $0x1a,%eax
 149:	cd 40                	int    $0x40
 14b:	c3                   	ret    

0000014c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	83 ec 1c             	sub    $0x1c,%esp
 152:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 155:	6a 01                	push   $0x1
 157:	8d 55 f4             	lea    -0xc(%ebp),%edx
 15a:	52                   	push   %edx
 15b:	50                   	push   %eax
 15c:	e8 43 ff ff ff       	call   a4 <write>
}
 161:	83 c4 10             	add    $0x10,%esp
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	57                   	push   %edi
 16a:	56                   	push   %esi
 16b:	53                   	push   %ebx
 16c:	83 ec 2c             	sub    $0x2c,%esp
 16f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 172:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 174:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 178:	74 04                	je     17e <printint+0x18>
 17a:	85 d2                	test   %edx,%edx
 17c:	78 3c                	js     1ba <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 17e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 180:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 187:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 18c:	89 c8                	mov    %ecx,%eax
 18e:	ba 00 00 00 00       	mov    $0x0,%edx
 193:	f7 f6                	div    %esi
 195:	89 df                	mov    %ebx,%edi
 197:	43                   	inc    %ebx
 198:	8a 92 c8 03 00 00    	mov    0x3c8(%edx),%dl
 19e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1a2:	89 ca                	mov    %ecx,%edx
 1a4:	89 c1                	mov    %eax,%ecx
 1a6:	39 d6                	cmp    %edx,%esi
 1a8:	76 e2                	jbe    18c <printint+0x26>
  if(neg)
 1aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1ae:	74 24                	je     1d4 <printint+0x6e>
    buf[i++] = '-';
 1b0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1b5:	8d 5f 02             	lea    0x2(%edi),%ebx
 1b8:	eb 1a                	jmp    1d4 <printint+0x6e>
    x = -xx;
 1ba:	89 d1                	mov    %edx,%ecx
 1bc:	f7 d9                	neg    %ecx
    neg = 1;
 1be:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1c5:	eb c0                	jmp    187 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1c7:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1cf:	e8 78 ff ff ff       	call   14c <putc>
  while(--i >= 0)
 1d4:	4b                   	dec    %ebx
 1d5:	79 f0                	jns    1c7 <printint+0x61>
}
 1d7:	83 c4 2c             	add    $0x2c,%esp
 1da:	5b                   	pop    %ebx
 1db:	5e                   	pop    %esi
 1dc:	5f                   	pop    %edi
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	57                   	push   %edi
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
 1e5:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e8:	8d 45 10             	lea    0x10(%ebp),%eax
 1eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1ee:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1f3:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f8:	eb 12                	jmp    20c <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1fa:	89 fa                	mov    %edi,%edx
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	e8 48 ff ff ff       	call   14c <putc>
 204:	eb 05                	jmp    20b <printf+0x2c>
      }
    } else if(state == '%'){
 206:	83 fe 25             	cmp    $0x25,%esi
 209:	74 22                	je     22d <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 20b:	43                   	inc    %ebx
 20c:	8b 45 0c             	mov    0xc(%ebp),%eax
 20f:	8a 04 18             	mov    (%eax,%ebx,1),%al
 212:	84 c0                	test   %al,%al
 214:	0f 84 1d 01 00 00    	je     337 <printf+0x158>
    c = fmt[i] & 0xff;
 21a:	0f be f8             	movsbl %al,%edi
 21d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 220:	85 f6                	test   %esi,%esi
 222:	75 e2                	jne    206 <printf+0x27>
      if(c == '%'){
 224:	83 f8 25             	cmp    $0x25,%eax
 227:	75 d1                	jne    1fa <printf+0x1b>
        state = '%';
 229:	89 c6                	mov    %eax,%esi
 22b:	eb de                	jmp    20b <printf+0x2c>
      if(c == 'd'){
 22d:	83 f8 25             	cmp    $0x25,%eax
 230:	0f 84 cc 00 00 00    	je     302 <printf+0x123>
 236:	0f 8c da 00 00 00    	jl     316 <printf+0x137>
 23c:	83 f8 78             	cmp    $0x78,%eax
 23f:	0f 8f d1 00 00 00    	jg     316 <printf+0x137>
 245:	83 f8 63             	cmp    $0x63,%eax
 248:	0f 8c c8 00 00 00    	jl     316 <printf+0x137>
 24e:	83 e8 63             	sub    $0x63,%eax
 251:	83 f8 15             	cmp    $0x15,%eax
 254:	0f 87 bc 00 00 00    	ja     316 <printf+0x137>
 25a:	ff 24 85 70 03 00 00 	jmp    *0x370(,%eax,4)
        printint(fd, *ap, 10, 1);
 261:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 264:	8b 17                	mov    (%edi),%edx
 266:	83 ec 0c             	sub    $0xc,%esp
 269:	6a 01                	push   $0x1
 26b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	e8 ee fe ff ff       	call   166 <printint>
        ap++;
 278:	83 c7 04             	add    $0x4,%edi
 27b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 27e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 281:	be 00 00 00 00       	mov    $0x0,%esi
 286:	eb 83                	jmp    20b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 288:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 28b:	8b 17                	mov    (%edi),%edx
 28d:	83 ec 0c             	sub    $0xc,%esp
 290:	6a 00                	push   $0x0
 292:	b9 10 00 00 00       	mov    $0x10,%ecx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	e8 c7 fe ff ff       	call   166 <printint>
        ap++;
 29f:	83 c7 04             	add    $0x4,%edi
 2a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2a5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2a8:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2ad:	e9 59 ff ff ff       	jmp    20b <printf+0x2c>
        s = (char*)*ap;
 2b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2b5:	8b 30                	mov    (%eax),%esi
        ap++;
 2b7:	83 c0 04             	add    $0x4,%eax
 2ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2bd:	85 f6                	test   %esi,%esi
 2bf:	75 13                	jne    2d4 <printf+0xf5>
          s = "(null)";
 2c1:	be 67 03 00 00       	mov    $0x367,%esi
 2c6:	eb 0c                	jmp    2d4 <printf+0xf5>
          putc(fd, *s);
 2c8:	0f be d2             	movsbl %dl,%edx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	e8 79 fe ff ff       	call   14c <putc>
          s++;
 2d3:	46                   	inc    %esi
        while(*s != 0){
 2d4:	8a 16                	mov    (%esi),%dl
 2d6:	84 d2                	test   %dl,%dl
 2d8:	75 ee                	jne    2c8 <printf+0xe9>
      state = 0;
 2da:	be 00 00 00 00       	mov    $0x0,%esi
 2df:	e9 27 ff ff ff       	jmp    20b <printf+0x2c>
        putc(fd, *ap);
 2e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e7:	0f be 17             	movsbl (%edi),%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	e8 5a fe ff ff       	call   14c <putc>
        ap++;
 2f2:	83 c7 04             	add    $0x4,%edi
 2f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2f8:	be 00 00 00 00       	mov    $0x0,%esi
 2fd:	e9 09 ff ff ff       	jmp    20b <printf+0x2c>
        putc(fd, c);
 302:	89 fa                	mov    %edi,%edx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	e8 40 fe ff ff       	call   14c <putc>
      state = 0;
 30c:	be 00 00 00 00       	mov    $0x0,%esi
 311:	e9 f5 fe ff ff       	jmp    20b <printf+0x2c>
        putc(fd, '%');
 316:	ba 25 00 00 00       	mov    $0x25,%edx
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	e8 29 fe ff ff       	call   14c <putc>
        putc(fd, c);
 323:	89 fa                	mov    %edi,%edx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	e8 1f fe ff ff       	call   14c <putc>
      state = 0;
 32d:	be 00 00 00 00       	mov    $0x0,%esi
 332:	e9 d4 fe ff ff       	jmp    20b <printf+0x2c>
    }
  }
}
 337:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33a:	5b                   	pop    %ebx
 33b:	5e                   	pop    %esi
 33c:	5f                   	pop    %edi
 33d:	5d                   	pop    %ebp
 33e:	c3                   	ret    
