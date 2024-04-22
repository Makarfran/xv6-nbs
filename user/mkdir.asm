
mkdir:     formato del fichero elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 07                	jle    28 <main+0x28>
{
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 21                	jmp    49 <main+0x49>
    printf(2, "Usage: mkdir files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 54 03 00 00       	push   $0x354
  30:	6a 02                	push   $0x2
  32:	e8 bd 01 00 00       	call   1f4 <printf>
    exit(0);
  37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3e:	e8 56 00 00 00       	call   99 <exit>
  43:	83 c4 10             	add    $0x10,%esp
  46:	eb d9                	jmp    21 <main+0x21>
  }

  for(i = 1; i < argc; i++){
  48:	43                   	inc    %ebx
  49:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  4c:	7d 28                	jge    76 <main+0x76>
    if(mkdir(argv[i]) < 0){
  4e:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	ff 36                	push   (%esi)
  56:	e8 a6 00 00 00       	call   101 <mkdir>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	85 c0                	test   %eax,%eax
  60:	79 e6                	jns    48 <main+0x48>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  62:	83 ec 04             	sub    $0x4,%esp
  65:	ff 36                	push   (%esi)
  67:	68 6b 03 00 00       	push   $0x36b
  6c:	6a 02                	push   $0x2
  6e:	e8 81 01 00 00       	call   1f4 <printf>
      break;
  73:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit(0);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 00                	push   $0x0
  7b:	e8 19 00 00 00       	call   99 <exit>
}
  80:	b8 00 00 00 00       	mov    $0x0,%eax
  85:	8d 65 f0             	lea    -0x10(%ebp),%esp
  88:	59                   	pop    %ecx
  89:	5b                   	pop    %ebx
  8a:	5e                   	pop    %esi
  8b:	5f                   	pop    %edi
  8c:	5d                   	pop    %ebp
  8d:	8d 61 fc             	lea    -0x4(%ecx),%esp
  90:	c3                   	ret    

00000091 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  91:	b8 01 00 00 00       	mov    $0x1,%eax
  96:	cd 40                	int    $0x40
  98:	c3                   	ret    

00000099 <exit>:
SYSCALL(exit)
  99:	b8 02 00 00 00       	mov    $0x2,%eax
  9e:	cd 40                	int    $0x40
  a0:	c3                   	ret    

000000a1 <wait>:
SYSCALL(wait)
  a1:	b8 03 00 00 00       	mov    $0x3,%eax
  a6:	cd 40                	int    $0x40
  a8:	c3                   	ret    

000000a9 <pipe>:
SYSCALL(pipe)
  a9:	b8 04 00 00 00       	mov    $0x4,%eax
  ae:	cd 40                	int    $0x40
  b0:	c3                   	ret    

000000b1 <read>:
SYSCALL(read)
  b1:	b8 05 00 00 00       	mov    $0x5,%eax
  b6:	cd 40                	int    $0x40
  b8:	c3                   	ret    

000000b9 <write>:
SYSCALL(write)
  b9:	b8 10 00 00 00       	mov    $0x10,%eax
  be:	cd 40                	int    $0x40
  c0:	c3                   	ret    

000000c1 <close>:
SYSCALL(close)
  c1:	b8 15 00 00 00       	mov    $0x15,%eax
  c6:	cd 40                	int    $0x40
  c8:	c3                   	ret    

000000c9 <kill>:
SYSCALL(kill)
  c9:	b8 06 00 00 00       	mov    $0x6,%eax
  ce:	cd 40                	int    $0x40
  d0:	c3                   	ret    

000000d1 <exec>:
SYSCALL(exec)
  d1:	b8 07 00 00 00       	mov    $0x7,%eax
  d6:	cd 40                	int    $0x40
  d8:	c3                   	ret    

000000d9 <open>:
SYSCALL(open)
  d9:	b8 0f 00 00 00       	mov    $0xf,%eax
  de:	cd 40                	int    $0x40
  e0:	c3                   	ret    

000000e1 <mknod>:
SYSCALL(mknod)
  e1:	b8 11 00 00 00       	mov    $0x11,%eax
  e6:	cd 40                	int    $0x40
  e8:	c3                   	ret    

000000e9 <unlink>:
SYSCALL(unlink)
  e9:	b8 12 00 00 00       	mov    $0x12,%eax
  ee:	cd 40                	int    $0x40
  f0:	c3                   	ret    

000000f1 <fstat>:
SYSCALL(fstat)
  f1:	b8 08 00 00 00       	mov    $0x8,%eax
  f6:	cd 40                	int    $0x40
  f8:	c3                   	ret    

000000f9 <link>:
SYSCALL(link)
  f9:	b8 13 00 00 00       	mov    $0x13,%eax
  fe:	cd 40                	int    $0x40
 100:	c3                   	ret    

00000101 <mkdir>:
SYSCALL(mkdir)
 101:	b8 14 00 00 00       	mov    $0x14,%eax
 106:	cd 40                	int    $0x40
 108:	c3                   	ret    

00000109 <chdir>:
SYSCALL(chdir)
 109:	b8 09 00 00 00       	mov    $0x9,%eax
 10e:	cd 40                	int    $0x40
 110:	c3                   	ret    

00000111 <dup>:
SYSCALL(dup)
 111:	b8 0a 00 00 00       	mov    $0xa,%eax
 116:	cd 40                	int    $0x40
 118:	c3                   	ret    

00000119 <getpid>:
SYSCALL(getpid)
 119:	b8 0b 00 00 00       	mov    $0xb,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret    

00000121 <sbrk>:
SYSCALL(sbrk)
 121:	b8 0c 00 00 00       	mov    $0xc,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret    

00000129 <sleep>:
SYSCALL(sleep)
 129:	b8 0d 00 00 00       	mov    $0xd,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret    

00000131 <uptime>:
SYSCALL(uptime)
 131:	b8 0e 00 00 00       	mov    $0xe,%eax
 136:	cd 40                	int    $0x40
 138:	c3                   	ret    

00000139 <date>:
SYSCALL(date)
 139:	b8 16 00 00 00       	mov    $0x16,%eax
 13e:	cd 40                	int    $0x40
 140:	c3                   	ret    

00000141 <dup2>:
SYSCALL(dup2)
 141:	b8 17 00 00 00       	mov    $0x17,%eax
 146:	cd 40                	int    $0x40
 148:	c3                   	ret    

00000149 <phmem>:
SYSCALL(phmem)
 149:	b8 18 00 00 00       	mov    $0x18,%eax
 14e:	cd 40                	int    $0x40
 150:	c3                   	ret    

00000151 <getprio>:
SYSCALL(getprio)
 151:	b8 19 00 00 00       	mov    $0x19,%eax
 156:	cd 40                	int    $0x40
 158:	c3                   	ret    

00000159 <setprio>:
SYSCALL(setprio)
 159:	b8 1a 00 00 00       	mov    $0x1a,%eax
 15e:	cd 40                	int    $0x40
 160:	c3                   	ret    

00000161 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 1c             	sub    $0x1c,%esp
 167:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 16a:	6a 01                	push   $0x1
 16c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 16f:	52                   	push   %edx
 170:	50                   	push   %eax
 171:	e8 43 ff ff ff       	call   b9 <write>
}
 176:	83 c4 10             	add    $0x10,%esp
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	57                   	push   %edi
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
 181:	83 ec 2c             	sub    $0x2c,%esp
 184:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 187:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 18d:	74 04                	je     193 <printint+0x18>
 18f:	85 d2                	test   %edx,%edx
 191:	78 3c                	js     1cf <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 193:	89 d1                	mov    %edx,%ecx
  neg = 0;
 195:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 19c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1a1:	89 c8                	mov    %ecx,%eax
 1a3:	ba 00 00 00 00       	mov    $0x0,%edx
 1a8:	f7 f6                	div    %esi
 1aa:	89 df                	mov    %ebx,%edi
 1ac:	43                   	inc    %ebx
 1ad:	8a 92 e8 03 00 00    	mov    0x3e8(%edx),%dl
 1b3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1b7:	89 ca                	mov    %ecx,%edx
 1b9:	89 c1                	mov    %eax,%ecx
 1bb:	39 d6                	cmp    %edx,%esi
 1bd:	76 e2                	jbe    1a1 <printint+0x26>
  if(neg)
 1bf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1c3:	74 24                	je     1e9 <printint+0x6e>
    buf[i++] = '-';
 1c5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1ca:	8d 5f 02             	lea    0x2(%edi),%ebx
 1cd:	eb 1a                	jmp    1e9 <printint+0x6e>
    x = -xx;
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	f7 d9                	neg    %ecx
    neg = 1;
 1d3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1da:	eb c0                	jmp    19c <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1dc:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1e4:	e8 78 ff ff ff       	call   161 <putc>
  while(--i >= 0)
 1e9:	4b                   	dec    %ebx
 1ea:	79 f0                	jns    1dc <printint+0x61>
}
 1ec:	83 c4 2c             	add    $0x2c,%esp
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5f                   	pop    %edi
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    

000001f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	56                   	push   %esi
 1f9:	53                   	push   %ebx
 1fa:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1fd:	8d 45 10             	lea    0x10(%ebp),%eax
 200:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 203:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 208:	bb 00 00 00 00       	mov    $0x0,%ebx
 20d:	eb 12                	jmp    221 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 20f:	89 fa                	mov    %edi,%edx
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	e8 48 ff ff ff       	call   161 <putc>
 219:	eb 05                	jmp    220 <printf+0x2c>
      }
    } else if(state == '%'){
 21b:	83 fe 25             	cmp    $0x25,%esi
 21e:	74 22                	je     242 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 220:	43                   	inc    %ebx
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	8a 04 18             	mov    (%eax,%ebx,1),%al
 227:	84 c0                	test   %al,%al
 229:	0f 84 1d 01 00 00    	je     34c <printf+0x158>
    c = fmt[i] & 0xff;
 22f:	0f be f8             	movsbl %al,%edi
 232:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 235:	85 f6                	test   %esi,%esi
 237:	75 e2                	jne    21b <printf+0x27>
      if(c == '%'){
 239:	83 f8 25             	cmp    $0x25,%eax
 23c:	75 d1                	jne    20f <printf+0x1b>
        state = '%';
 23e:	89 c6                	mov    %eax,%esi
 240:	eb de                	jmp    220 <printf+0x2c>
      if(c == 'd'){
 242:	83 f8 25             	cmp    $0x25,%eax
 245:	0f 84 cc 00 00 00    	je     317 <printf+0x123>
 24b:	0f 8c da 00 00 00    	jl     32b <printf+0x137>
 251:	83 f8 78             	cmp    $0x78,%eax
 254:	0f 8f d1 00 00 00    	jg     32b <printf+0x137>
 25a:	83 f8 63             	cmp    $0x63,%eax
 25d:	0f 8c c8 00 00 00    	jl     32b <printf+0x137>
 263:	83 e8 63             	sub    $0x63,%eax
 266:	83 f8 15             	cmp    $0x15,%eax
 269:	0f 87 bc 00 00 00    	ja     32b <printf+0x137>
 26f:	ff 24 85 90 03 00 00 	jmp    *0x390(,%eax,4)
        printint(fd, *ap, 10, 1);
 276:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 279:	8b 17                	mov    (%edi),%edx
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	6a 01                	push   $0x1
 280:	b9 0a 00 00 00       	mov    $0xa,%ecx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	e8 ee fe ff ff       	call   17b <printint>
        ap++;
 28d:	83 c7 04             	add    $0x4,%edi
 290:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 293:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 296:	be 00 00 00 00       	mov    $0x0,%esi
 29b:	eb 83                	jmp    220 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 29d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a0:	8b 17                	mov    (%edi),%edx
 2a2:	83 ec 0c             	sub    $0xc,%esp
 2a5:	6a 00                	push   $0x0
 2a7:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	e8 c7 fe ff ff       	call   17b <printint>
        ap++;
 2b4:	83 c7 04             	add    $0x4,%edi
 2b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2bd:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2c2:	e9 59 ff ff ff       	jmp    220 <printf+0x2c>
        s = (char*)*ap;
 2c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ca:	8b 30                	mov    (%eax),%esi
        ap++;
 2cc:	83 c0 04             	add    $0x4,%eax
 2cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2d2:	85 f6                	test   %esi,%esi
 2d4:	75 13                	jne    2e9 <printf+0xf5>
          s = "(null)";
 2d6:	be 87 03 00 00       	mov    $0x387,%esi
 2db:	eb 0c                	jmp    2e9 <printf+0xf5>
          putc(fd, *s);
 2dd:	0f be d2             	movsbl %dl,%edx
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	e8 79 fe ff ff       	call   161 <putc>
          s++;
 2e8:	46                   	inc    %esi
        while(*s != 0){
 2e9:	8a 16                	mov    (%esi),%dl
 2eb:	84 d2                	test   %dl,%dl
 2ed:	75 ee                	jne    2dd <printf+0xe9>
      state = 0;
 2ef:	be 00 00 00 00       	mov    $0x0,%esi
 2f4:	e9 27 ff ff ff       	jmp    220 <printf+0x2c>
        putc(fd, *ap);
 2f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2fc:	0f be 17             	movsbl (%edi),%edx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	e8 5a fe ff ff       	call   161 <putc>
        ap++;
 307:	83 c7 04             	add    $0x4,%edi
 30a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 30d:	be 00 00 00 00       	mov    $0x0,%esi
 312:	e9 09 ff ff ff       	jmp    220 <printf+0x2c>
        putc(fd, c);
 317:	89 fa                	mov    %edi,%edx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	e8 40 fe ff ff       	call   161 <putc>
      state = 0;
 321:	be 00 00 00 00       	mov    $0x0,%esi
 326:	e9 f5 fe ff ff       	jmp    220 <printf+0x2c>
        putc(fd, '%');
 32b:	ba 25 00 00 00       	mov    $0x25,%edx
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	e8 29 fe ff ff       	call   161 <putc>
        putc(fd, c);
 338:	89 fa                	mov    %edi,%edx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	e8 1f fe ff ff       	call   161 <putc>
      state = 0;
 342:	be 00 00 00 00       	mov    $0x0,%esi
 347:	e9 d4 fe ff ff       	jmp    220 <printf+0x2c>
    }
  }
}
 34c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34f:	5b                   	pop    %ebx
 350:	5e                   	pop    %esi
 351:	5f                   	pop    %edi
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    
