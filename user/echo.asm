
echo:     formato del fichero elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba 2e 03 00 00       	mov    $0x32e,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	push   (%edi,%eax,4)
  29:	68 30 03 00 00       	push   $0x330
  2e:	6a 01                	push   $0x1
  30:	e8 95 01 00 00       	call   1ca <printf>
  35:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba 2c 03 00 00       	mov    $0x32c,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit(0);
  4c:	83 ec 0c             	sub    $0xc,%esp
  4f:	6a 00                	push   $0x0
  51:	e8 19 00 00 00       	call   6f <exit>
}
  56:	b8 00 00 00 00       	mov    $0x0,%eax
  5b:	8d 65 f0             	lea    -0x10(%ebp),%esp
  5e:	59                   	pop    %ecx
  5f:	5b                   	pop    %ebx
  60:	5e                   	pop    %esi
  61:	5f                   	pop    %edi
  62:	5d                   	pop    %ebp
  63:	8d 61 fc             	lea    -0x4(%ecx),%esp
  66:	c3                   	ret    

00000067 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  67:	b8 01 00 00 00       	mov    $0x1,%eax
  6c:	cd 40                	int    $0x40
  6e:	c3                   	ret    

0000006f <exit>:
SYSCALL(exit)
  6f:	b8 02 00 00 00       	mov    $0x2,%eax
  74:	cd 40                	int    $0x40
  76:	c3                   	ret    

00000077 <wait>:
SYSCALL(wait)
  77:	b8 03 00 00 00       	mov    $0x3,%eax
  7c:	cd 40                	int    $0x40
  7e:	c3                   	ret    

0000007f <pipe>:
SYSCALL(pipe)
  7f:	b8 04 00 00 00       	mov    $0x4,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <read>:
SYSCALL(read)
  87:	b8 05 00 00 00       	mov    $0x5,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <write>:
SYSCALL(write)
  8f:	b8 10 00 00 00       	mov    $0x10,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <close>:
SYSCALL(close)
  97:	b8 15 00 00 00       	mov    $0x15,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <kill>:
SYSCALL(kill)
  9f:	b8 06 00 00 00       	mov    $0x6,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <exec>:
SYSCALL(exec)
  a7:	b8 07 00 00 00       	mov    $0x7,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <open>:
SYSCALL(open)
  af:	b8 0f 00 00 00       	mov    $0xf,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <mknod>:
SYSCALL(mknod)
  b7:	b8 11 00 00 00       	mov    $0x11,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <unlink>:
SYSCALL(unlink)
  bf:	b8 12 00 00 00       	mov    $0x12,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <fstat>:
SYSCALL(fstat)
  c7:	b8 08 00 00 00       	mov    $0x8,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <link>:
SYSCALL(link)
  cf:	b8 13 00 00 00       	mov    $0x13,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <mkdir>:
SYSCALL(mkdir)
  d7:	b8 14 00 00 00       	mov    $0x14,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <chdir>:
SYSCALL(chdir)
  df:	b8 09 00 00 00       	mov    $0x9,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <dup>:
SYSCALL(dup)
  e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <getpid>:
SYSCALL(getpid)
  ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <sbrk>:
SYSCALL(sbrk)
  f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <sleep>:
SYSCALL(sleep)
  ff:	b8 0d 00 00 00       	mov    $0xd,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <uptime>:
SYSCALL(uptime)
 107:	b8 0e 00 00 00       	mov    $0xe,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <date>:
SYSCALL(date)
 10f:	b8 16 00 00 00       	mov    $0x16,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <dup2>:
SYSCALL(dup2)
 117:	b8 17 00 00 00       	mov    $0x17,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <phmem>:
SYSCALL(phmem)
 11f:	b8 18 00 00 00       	mov    $0x18,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <getprio>:
SYSCALL(getprio)
 127:	b8 19 00 00 00       	mov    $0x19,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <setprio>:
SYSCALL(setprio)
 12f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 1c             	sub    $0x1c,%esp
 13d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 140:	6a 01                	push   $0x1
 142:	8d 55 f4             	lea    -0xc(%ebp),%edx
 145:	52                   	push   %edx
 146:	50                   	push   %eax
 147:	e8 43 ff ff ff       	call   8f <write>
}
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	57                   	push   %edi
 155:	56                   	push   %esi
 156:	53                   	push   %ebx
 157:	83 ec 2c             	sub    $0x2c,%esp
 15a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 15d:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 15f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 163:	74 04                	je     169 <printint+0x18>
 165:	85 d2                	test   %edx,%edx
 167:	78 3c                	js     1a5 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 169:	89 d1                	mov    %edx,%ecx
  neg = 0;
 16b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 172:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 177:	89 c8                	mov    %ecx,%eax
 179:	ba 00 00 00 00       	mov    $0x0,%edx
 17e:	f7 f6                	div    %esi
 180:	89 df                	mov    %ebx,%edi
 182:	43                   	inc    %ebx
 183:	8a 92 94 03 00 00    	mov    0x394(%edx),%dl
 189:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 18d:	89 ca                	mov    %ecx,%edx
 18f:	89 c1                	mov    %eax,%ecx
 191:	39 d6                	cmp    %edx,%esi
 193:	76 e2                	jbe    177 <printint+0x26>
  if(neg)
 195:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 199:	74 24                	je     1bf <printint+0x6e>
    buf[i++] = '-';
 19b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1a0:	8d 5f 02             	lea    0x2(%edi),%ebx
 1a3:	eb 1a                	jmp    1bf <printint+0x6e>
    x = -xx;
 1a5:	89 d1                	mov    %edx,%ecx
 1a7:	f7 d9                	neg    %ecx
    neg = 1;
 1a9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1b0:	eb c0                	jmp    172 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1b2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1ba:	e8 78 ff ff ff       	call   137 <putc>
  while(--i >= 0)
 1bf:	4b                   	dec    %ebx
 1c0:	79 f0                	jns    1b2 <printint+0x61>
}
 1c2:	83 c4 2c             	add    $0x2c,%esp
 1c5:	5b                   	pop    %ebx
 1c6:	5e                   	pop    %esi
 1c7:	5f                   	pop    %edi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    

000001ca <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	57                   	push   %edi
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1d3:	8d 45 10             	lea    0x10(%ebp),%eax
 1d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1d9:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1de:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e3:	eb 12                	jmp    1f7 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1e5:	89 fa                	mov    %edi,%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	e8 48 ff ff ff       	call   137 <putc>
 1ef:	eb 05                	jmp    1f6 <printf+0x2c>
      }
    } else if(state == '%'){
 1f1:	83 fe 25             	cmp    $0x25,%esi
 1f4:	74 22                	je     218 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 1f6:	43                   	inc    %ebx
 1f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fa:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1fd:	84 c0                	test   %al,%al
 1ff:	0f 84 1d 01 00 00    	je     322 <printf+0x158>
    c = fmt[i] & 0xff;
 205:	0f be f8             	movsbl %al,%edi
 208:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 20b:	85 f6                	test   %esi,%esi
 20d:	75 e2                	jne    1f1 <printf+0x27>
      if(c == '%'){
 20f:	83 f8 25             	cmp    $0x25,%eax
 212:	75 d1                	jne    1e5 <printf+0x1b>
        state = '%';
 214:	89 c6                	mov    %eax,%esi
 216:	eb de                	jmp    1f6 <printf+0x2c>
      if(c == 'd'){
 218:	83 f8 25             	cmp    $0x25,%eax
 21b:	0f 84 cc 00 00 00    	je     2ed <printf+0x123>
 221:	0f 8c da 00 00 00    	jl     301 <printf+0x137>
 227:	83 f8 78             	cmp    $0x78,%eax
 22a:	0f 8f d1 00 00 00    	jg     301 <printf+0x137>
 230:	83 f8 63             	cmp    $0x63,%eax
 233:	0f 8c c8 00 00 00    	jl     301 <printf+0x137>
 239:	83 e8 63             	sub    $0x63,%eax
 23c:	83 f8 15             	cmp    $0x15,%eax
 23f:	0f 87 bc 00 00 00    	ja     301 <printf+0x137>
 245:	ff 24 85 3c 03 00 00 	jmp    *0x33c(,%eax,4)
        printint(fd, *ap, 10, 1);
 24c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 24f:	8b 17                	mov    (%edi),%edx
 251:	83 ec 0c             	sub    $0xc,%esp
 254:	6a 01                	push   $0x1
 256:	b9 0a 00 00 00       	mov    $0xa,%ecx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	e8 ee fe ff ff       	call   151 <printint>
        ap++;
 263:	83 c7 04             	add    $0x4,%edi
 266:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 269:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 26c:	be 00 00 00 00       	mov    $0x0,%esi
 271:	eb 83                	jmp    1f6 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 273:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 276:	8b 17                	mov    (%edi),%edx
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	6a 00                	push   $0x0
 27d:	b9 10 00 00 00       	mov    $0x10,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	e8 c7 fe ff ff       	call   151 <printint>
        ap++;
 28a:	83 c7 04             	add    $0x4,%edi
 28d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 290:	83 c4 10             	add    $0x10,%esp
      state = 0;
 293:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 298:	e9 59 ff ff ff       	jmp    1f6 <printf+0x2c>
        s = (char*)*ap;
 29d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a0:	8b 30                	mov    (%eax),%esi
        ap++;
 2a2:	83 c0 04             	add    $0x4,%eax
 2a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2a8:	85 f6                	test   %esi,%esi
 2aa:	75 13                	jne    2bf <printf+0xf5>
          s = "(null)";
 2ac:	be 35 03 00 00       	mov    $0x335,%esi
 2b1:	eb 0c                	jmp    2bf <printf+0xf5>
          putc(fd, *s);
 2b3:	0f be d2             	movsbl %dl,%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	e8 79 fe ff ff       	call   137 <putc>
          s++;
 2be:	46                   	inc    %esi
        while(*s != 0){
 2bf:	8a 16                	mov    (%esi),%dl
 2c1:	84 d2                	test   %dl,%dl
 2c3:	75 ee                	jne    2b3 <printf+0xe9>
      state = 0;
 2c5:	be 00 00 00 00       	mov    $0x0,%esi
 2ca:	e9 27 ff ff ff       	jmp    1f6 <printf+0x2c>
        putc(fd, *ap);
 2cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d2:	0f be 17             	movsbl (%edi),%edx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	e8 5a fe ff ff       	call   137 <putc>
        ap++;
 2dd:	83 c7 04             	add    $0x4,%edi
 2e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2e3:	be 00 00 00 00       	mov    $0x0,%esi
 2e8:	e9 09 ff ff ff       	jmp    1f6 <printf+0x2c>
        putc(fd, c);
 2ed:	89 fa                	mov    %edi,%edx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	e8 40 fe ff ff       	call   137 <putc>
      state = 0;
 2f7:	be 00 00 00 00       	mov    $0x0,%esi
 2fc:	e9 f5 fe ff ff       	jmp    1f6 <printf+0x2c>
        putc(fd, '%');
 301:	ba 25 00 00 00       	mov    $0x25,%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	e8 29 fe ff ff       	call   137 <putc>
        putc(fd, c);
 30e:	89 fa                	mov    %edi,%edx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	e8 1f fe ff ff       	call   137 <putc>
      state = 0;
 318:	be 00 00 00 00       	mov    $0x0,%esi
 31d:	e9 d4 fe ff ff       	jmp    1f6 <printf+0x2c>
    }
  }
}
 322:	8d 65 f4             	lea    -0xc(%ebp),%esp
 325:	5b                   	pop    %ebx
 326:	5e                   	pop    %esi
 327:	5f                   	pop    %edi
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    
