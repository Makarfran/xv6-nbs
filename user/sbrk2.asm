
sbrk2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <recursive>:
#include "user.h"

char a[4096] = {0};

int recursive(int v)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 1c             	sub    $0x1c,%esp
  printf (1, ".");
   7:	68 58 03 00 00       	push   $0x358
   c:	6a 01                	push   $0x1
   e:	e8 e2 01 00 00       	call   1f5 <printf>
  volatile int q = v;
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (q > 0)
  19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	7f 0a                	jg     2d <recursive+0x2d>
    return recursive (q+1)+recursive (q+2);
  return 0;
  23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2b:	c9                   	leave  
  2c:	c3                   	ret    
    return recursive (q+1)+recursive (q+2);
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	40                   	inc    %eax
  34:	50                   	push   %eax
  35:	e8 c6 ff ff ff       	call   0 <recursive>
  3a:	89 c3                	mov    %eax,%ebx
  3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3f:	83 c0 02             	add    $0x2,%eax
  42:	89 04 24             	mov    %eax,(%esp)
  45:	e8 b6 ff ff ff       	call   0 <recursive>
  4a:	01 d8                	add    %ebx,%eax
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	eb d7                	jmp    28 <recursive+0x28>

00000051 <main>:


int
main(int argc, char *argv[])
{
  51:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  55:	83 e4 f0             	and    $0xfffffff0,%esp
  58:	ff 71 fc             	push   -0x4(%ecx)
  5b:	55                   	push   %ebp
  5c:	89 e5                	mov    %esp,%ebp
  5e:	51                   	push   %ecx
  5f:	83 ec 10             	sub    $0x10,%esp
  int i = 1;

  // Llamar recursivamente a recursive
  printf (1, ": %d\n", recursive (i));
  62:	6a 01                	push   $0x1
  64:	e8 97 ff ff ff       	call   0 <recursive>
  69:	83 c4 0c             	add    $0xc,%esp
  6c:	50                   	push   %eax
  6d:	68 5a 03 00 00       	push   $0x35a
  72:	6a 01                	push   $0x1
  74:	e8 7c 01 00 00       	call   1f5 <printf>

  exit(0);
  79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80:	e8 15 00 00 00       	call   9a <exit>
}
  85:	b8 00 00 00 00       	mov    $0x0,%eax
  8a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8d:	c9                   	leave  
  8e:	8d 61 fc             	lea    -0x4(%ecx),%esp
  91:	c3                   	ret    

00000092 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  92:	b8 01 00 00 00       	mov    $0x1,%eax
  97:	cd 40                	int    $0x40
  99:	c3                   	ret    

0000009a <exit>:
SYSCALL(exit)
  9a:	b8 02 00 00 00       	mov    $0x2,%eax
  9f:	cd 40                	int    $0x40
  a1:	c3                   	ret    

000000a2 <wait>:
SYSCALL(wait)
  a2:	b8 03 00 00 00       	mov    $0x3,%eax
  a7:	cd 40                	int    $0x40
  a9:	c3                   	ret    

000000aa <pipe>:
SYSCALL(pipe)
  aa:	b8 04 00 00 00       	mov    $0x4,%eax
  af:	cd 40                	int    $0x40
  b1:	c3                   	ret    

000000b2 <read>:
SYSCALL(read)
  b2:	b8 05 00 00 00       	mov    $0x5,%eax
  b7:	cd 40                	int    $0x40
  b9:	c3                   	ret    

000000ba <write>:
SYSCALL(write)
  ba:	b8 10 00 00 00       	mov    $0x10,%eax
  bf:	cd 40                	int    $0x40
  c1:	c3                   	ret    

000000c2 <close>:
SYSCALL(close)
  c2:	b8 15 00 00 00       	mov    $0x15,%eax
  c7:	cd 40                	int    $0x40
  c9:	c3                   	ret    

000000ca <kill>:
SYSCALL(kill)
  ca:	b8 06 00 00 00       	mov    $0x6,%eax
  cf:	cd 40                	int    $0x40
  d1:	c3                   	ret    

000000d2 <exec>:
SYSCALL(exec)
  d2:	b8 07 00 00 00       	mov    $0x7,%eax
  d7:	cd 40                	int    $0x40
  d9:	c3                   	ret    

000000da <open>:
SYSCALL(open)
  da:	b8 0f 00 00 00       	mov    $0xf,%eax
  df:	cd 40                	int    $0x40
  e1:	c3                   	ret    

000000e2 <mknod>:
SYSCALL(mknod)
  e2:	b8 11 00 00 00       	mov    $0x11,%eax
  e7:	cd 40                	int    $0x40
  e9:	c3                   	ret    

000000ea <unlink>:
SYSCALL(unlink)
  ea:	b8 12 00 00 00       	mov    $0x12,%eax
  ef:	cd 40                	int    $0x40
  f1:	c3                   	ret    

000000f2 <fstat>:
SYSCALL(fstat)
  f2:	b8 08 00 00 00       	mov    $0x8,%eax
  f7:	cd 40                	int    $0x40
  f9:	c3                   	ret    

000000fa <link>:
SYSCALL(link)
  fa:	b8 13 00 00 00       	mov    $0x13,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <mkdir>:
SYSCALL(mkdir)
 102:	b8 14 00 00 00       	mov    $0x14,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <chdir>:
SYSCALL(chdir)
 10a:	b8 09 00 00 00       	mov    $0x9,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <dup>:
SYSCALL(dup)
 112:	b8 0a 00 00 00       	mov    $0xa,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <getpid>:
SYSCALL(getpid)
 11a:	b8 0b 00 00 00       	mov    $0xb,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <sbrk>:
SYSCALL(sbrk)
 122:	b8 0c 00 00 00       	mov    $0xc,%eax
 127:	cd 40                	int    $0x40
 129:	c3                   	ret    

0000012a <sleep>:
SYSCALL(sleep)
 12a:	b8 0d 00 00 00       	mov    $0xd,%eax
 12f:	cd 40                	int    $0x40
 131:	c3                   	ret    

00000132 <uptime>:
SYSCALL(uptime)
 132:	b8 0e 00 00 00       	mov    $0xe,%eax
 137:	cd 40                	int    $0x40
 139:	c3                   	ret    

0000013a <date>:
SYSCALL(date)
 13a:	b8 16 00 00 00       	mov    $0x16,%eax
 13f:	cd 40                	int    $0x40
 141:	c3                   	ret    

00000142 <dup2>:
SYSCALL(dup2)
 142:	b8 17 00 00 00       	mov    $0x17,%eax
 147:	cd 40                	int    $0x40
 149:	c3                   	ret    

0000014a <phmem>:
SYSCALL(phmem)
 14a:	b8 18 00 00 00       	mov    $0x18,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <getprio>:
SYSCALL(getprio)
 152:	b8 19 00 00 00       	mov    $0x19,%eax
 157:	cd 40                	int    $0x40
 159:	c3                   	ret    

0000015a <setprio>:
SYSCALL(setprio)
 15a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 15f:	cd 40                	int    $0x40
 161:	c3                   	ret    

00000162 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 1c             	sub    $0x1c,%esp
 168:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 16b:	6a 01                	push   $0x1
 16d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 170:	52                   	push   %edx
 171:	50                   	push   %eax
 172:	e8 43 ff ff ff       	call   ba <write>
}
 177:	83 c4 10             	add    $0x10,%esp
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	57                   	push   %edi
 180:	56                   	push   %esi
 181:	53                   	push   %ebx
 182:	83 ec 2c             	sub    $0x2c,%esp
 185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 188:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 18a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 18e:	74 04                	je     194 <printint+0x18>
 190:	85 d2                	test   %edx,%edx
 192:	78 3c                	js     1d0 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 194:	89 d1                	mov    %edx,%ecx
  neg = 0;
 196:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 19d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1a2:	89 c8                	mov    %ecx,%eax
 1a4:	ba 00 00 00 00       	mov    $0x0,%edx
 1a9:	f7 f6                	div    %esi
 1ab:	89 df                	mov    %ebx,%edi
 1ad:	43                   	inc    %ebx
 1ae:	8a 92 c0 03 00 00    	mov    0x3c0(%edx),%dl
 1b4:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1b8:	89 ca                	mov    %ecx,%edx
 1ba:	89 c1                	mov    %eax,%ecx
 1bc:	39 d6                	cmp    %edx,%esi
 1be:	76 e2                	jbe    1a2 <printint+0x26>
  if(neg)
 1c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1c4:	74 24                	je     1ea <printint+0x6e>
    buf[i++] = '-';
 1c6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1cb:	8d 5f 02             	lea    0x2(%edi),%ebx
 1ce:	eb 1a                	jmp    1ea <printint+0x6e>
    x = -xx;
 1d0:	89 d1                	mov    %edx,%ecx
 1d2:	f7 d9                	neg    %ecx
    neg = 1;
 1d4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1db:	eb c0                	jmp    19d <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1dd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1e5:	e8 78 ff ff ff       	call   162 <putc>
  while(--i >= 0)
 1ea:	4b                   	dec    %ebx
 1eb:	79 f0                	jns    1dd <printint+0x61>
}
 1ed:	83 c4 2c             	add    $0x2c,%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	57                   	push   %edi
 1f9:	56                   	push   %esi
 1fa:	53                   	push   %ebx
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1fe:	8d 45 10             	lea    0x10(%ebp),%eax
 201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 204:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 209:	bb 00 00 00 00       	mov    $0x0,%ebx
 20e:	eb 12                	jmp    222 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 210:	89 fa                	mov    %edi,%edx
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	e8 48 ff ff ff       	call   162 <putc>
 21a:	eb 05                	jmp    221 <printf+0x2c>
      }
    } else if(state == '%'){
 21c:	83 fe 25             	cmp    $0x25,%esi
 21f:	74 22                	je     243 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 221:	43                   	inc    %ebx
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	8a 04 18             	mov    (%eax,%ebx,1),%al
 228:	84 c0                	test   %al,%al
 22a:	0f 84 1d 01 00 00    	je     34d <printf+0x158>
    c = fmt[i] & 0xff;
 230:	0f be f8             	movsbl %al,%edi
 233:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 236:	85 f6                	test   %esi,%esi
 238:	75 e2                	jne    21c <printf+0x27>
      if(c == '%'){
 23a:	83 f8 25             	cmp    $0x25,%eax
 23d:	75 d1                	jne    210 <printf+0x1b>
        state = '%';
 23f:	89 c6                	mov    %eax,%esi
 241:	eb de                	jmp    221 <printf+0x2c>
      if(c == 'd'){
 243:	83 f8 25             	cmp    $0x25,%eax
 246:	0f 84 cc 00 00 00    	je     318 <printf+0x123>
 24c:	0f 8c da 00 00 00    	jl     32c <printf+0x137>
 252:	83 f8 78             	cmp    $0x78,%eax
 255:	0f 8f d1 00 00 00    	jg     32c <printf+0x137>
 25b:	83 f8 63             	cmp    $0x63,%eax
 25e:	0f 8c c8 00 00 00    	jl     32c <printf+0x137>
 264:	83 e8 63             	sub    $0x63,%eax
 267:	83 f8 15             	cmp    $0x15,%eax
 26a:	0f 87 bc 00 00 00    	ja     32c <printf+0x137>
 270:	ff 24 85 68 03 00 00 	jmp    *0x368(,%eax,4)
        printint(fd, *ap, 10, 1);
 277:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 27a:	8b 17                	mov    (%edi),%edx
 27c:	83 ec 0c             	sub    $0xc,%esp
 27f:	6a 01                	push   $0x1
 281:	b9 0a 00 00 00       	mov    $0xa,%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	e8 ee fe ff ff       	call   17c <printint>
        ap++;
 28e:	83 c7 04             	add    $0x4,%edi
 291:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 294:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 297:	be 00 00 00 00       	mov    $0x0,%esi
 29c:	eb 83                	jmp    221 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 29e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a1:	8b 17                	mov    (%edi),%edx
 2a3:	83 ec 0c             	sub    $0xc,%esp
 2a6:	6a 00                	push   $0x0
 2a8:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	e8 c7 fe ff ff       	call   17c <printint>
        ap++;
 2b5:	83 c7 04             	add    $0x4,%edi
 2b8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2bb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2be:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2c3:	e9 59 ff ff ff       	jmp    221 <printf+0x2c>
        s = (char*)*ap;
 2c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2cb:	8b 30                	mov    (%eax),%esi
        ap++;
 2cd:	83 c0 04             	add    $0x4,%eax
 2d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2d3:	85 f6                	test   %esi,%esi
 2d5:	75 13                	jne    2ea <printf+0xf5>
          s = "(null)";
 2d7:	be 60 03 00 00       	mov    $0x360,%esi
 2dc:	eb 0c                	jmp    2ea <printf+0xf5>
          putc(fd, *s);
 2de:	0f be d2             	movsbl %dl,%edx
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	e8 79 fe ff ff       	call   162 <putc>
          s++;
 2e9:	46                   	inc    %esi
        while(*s != 0){
 2ea:	8a 16                	mov    (%esi),%dl
 2ec:	84 d2                	test   %dl,%dl
 2ee:	75 ee                	jne    2de <printf+0xe9>
      state = 0;
 2f0:	be 00 00 00 00       	mov    $0x0,%esi
 2f5:	e9 27 ff ff ff       	jmp    221 <printf+0x2c>
        putc(fd, *ap);
 2fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2fd:	0f be 17             	movsbl (%edi),%edx
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	e8 5a fe ff ff       	call   162 <putc>
        ap++;
 308:	83 c7 04             	add    $0x4,%edi
 30b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 30e:	be 00 00 00 00       	mov    $0x0,%esi
 313:	e9 09 ff ff ff       	jmp    221 <printf+0x2c>
        putc(fd, c);
 318:	89 fa                	mov    %edi,%edx
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	e8 40 fe ff ff       	call   162 <putc>
      state = 0;
 322:	be 00 00 00 00       	mov    $0x0,%esi
 327:	e9 f5 fe ff ff       	jmp    221 <printf+0x2c>
        putc(fd, '%');
 32c:	ba 25 00 00 00       	mov    $0x25,%edx
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	e8 29 fe ff ff       	call   162 <putc>
        putc(fd, c);
 339:	89 fa                	mov    %edi,%edx
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	e8 1f fe ff ff       	call   162 <putc>
      state = 0;
 343:	be 00 00 00 00       	mov    $0x0,%esi
 348:	e9 d4 fe ff ff       	jmp    221 <printf+0x2c>
    }
  }
}
 34d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret    
