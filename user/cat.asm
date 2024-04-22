
cat:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 c0 05 00 00       	push   $0x5c0
  15:	56                   	push   %esi
  16:	e8 41 01 00 00       	call   15c <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 37                	jle    5b <cat+0x5b>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 c0 05 00 00       	push   $0x5c0
  2d:	6a 01                	push   $0x1
  2f:	e8 30 01 00 00       	call   164 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 00 04 00 00       	push   $0x400
  43:	6a 01                	push   $0x1
  45:	e8 55 02 00 00       	call   29f <printf>
      exit(0);
  4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  51:	e8 ee 00 00 00       	call   144 <exit>
  56:	83 c4 10             	add    $0x10,%esp
  59:	eb ad                	jmp    8 <cat+0x8>
    }
  }
  if(n < 0){
  5b:	78 07                	js     64 <cat+0x64>
    printf(1, "cat: read error\n");
    exit(0);
  }
}
  5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  60:	5b                   	pop    %ebx
  61:	5e                   	pop    %esi
  62:	5d                   	pop    %ebp
  63:	c3                   	ret    
    printf(1, "cat: read error\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 12 04 00 00       	push   $0x412
  6c:	6a 01                	push   $0x1
  6e:	e8 2c 02 00 00       	call   29f <printf>
    exit(0);
  73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7a:	e8 c5 00 00 00       	call   144 <exit>
  7f:	83 c4 10             	add    $0x10,%esp
}
  82:	eb d9                	jmp    5d <cat+0x5d>

00000084 <main>:

int
main(int argc, char *argv[])
{
  84:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  88:	83 e4 f0             	and    $0xfffffff0,%esp
  8b:	ff 71 fc             	push   -0x4(%ecx)
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	57                   	push   %edi
  92:	56                   	push   %esi
  93:	53                   	push   %ebx
  94:	51                   	push   %ecx
  95:	83 ec 18             	sub    $0x18,%esp
  98:	8b 01                	mov    (%ecx),%eax
  9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  9d:	8b 51 04             	mov    0x4(%ecx),%edx
  a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  a3:	83 f8 01             	cmp    $0x1,%eax
  a6:	7e 07                	jle    af <main+0x2b>
{
  a8:	be 01 00 00 00       	mov    $0x1,%esi
  ad:	eb 30                	jmp    df <main+0x5b>
    cat(0);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	6a 00                	push   $0x0
  b4:	e8 47 ff ff ff       	call   0 <cat>
    exit(0);
  b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c0:	e8 7f 00 00 00       	call   144 <exit>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	eb de                	jmp    a8 <main+0x24>
  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  ca:	83 ec 0c             	sub    $0xc,%esp
  cd:	53                   	push   %ebx
  ce:	e8 2d ff ff ff       	call   0 <cat>
    close(fd);
  d3:	89 1c 24             	mov    %ebx,(%esp)
  d6:	e8 91 00 00 00       	call   16c <close>
  for(i = 1; i < argc; i++){
  db:	46                   	inc    %esi
  dc:	83 c4 10             	add    $0x10,%esp
  df:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  e2:	7d 3d                	jge    121 <main+0x9d>
    if((fd = open(argv[i], 0)) < 0){
  e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e7:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  ea:	83 ec 08             	sub    $0x8,%esp
  ed:	6a 00                	push   $0x0
  ef:	ff 37                	push   (%edi)
  f1:	e8 8e 00 00 00       	call   184 <open>
  f6:	89 c3                	mov    %eax,%ebx
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	85 c0                	test   %eax,%eax
  fd:	79 cb                	jns    ca <main+0x46>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	ff 37                	push   (%edi)
 104:	68 23 04 00 00       	push   $0x423
 109:	6a 01                	push   $0x1
 10b:	e8 8f 01 00 00       	call   29f <printf>
      exit(0);
 110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 117:	e8 28 00 00 00       	call   144 <exit>
 11c:	83 c4 10             	add    $0x10,%esp
 11f:	eb a9                	jmp    ca <main+0x46>
  }
  exit(0);
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	6a 00                	push   $0x0
 126:	e8 19 00 00 00       	call   144 <exit>
}
 12b:	b8 00 00 00 00       	mov    $0x0,%eax
 130:	8d 65 f0             	lea    -0x10(%ebp),%esp
 133:	59                   	pop    %ecx
 134:	5b                   	pop    %ebx
 135:	5e                   	pop    %esi
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	8d 61 fc             	lea    -0x4(%ecx),%esp
 13b:	c3                   	ret    

0000013c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 13c:	b8 01 00 00 00       	mov    $0x1,%eax
 141:	cd 40                	int    $0x40
 143:	c3                   	ret    

00000144 <exit>:
SYSCALL(exit)
 144:	b8 02 00 00 00       	mov    $0x2,%eax
 149:	cd 40                	int    $0x40
 14b:	c3                   	ret    

0000014c <wait>:
SYSCALL(wait)
 14c:	b8 03 00 00 00       	mov    $0x3,%eax
 151:	cd 40                	int    $0x40
 153:	c3                   	ret    

00000154 <pipe>:
SYSCALL(pipe)
 154:	b8 04 00 00 00       	mov    $0x4,%eax
 159:	cd 40                	int    $0x40
 15b:	c3                   	ret    

0000015c <read>:
SYSCALL(read)
 15c:	b8 05 00 00 00       	mov    $0x5,%eax
 161:	cd 40                	int    $0x40
 163:	c3                   	ret    

00000164 <write>:
SYSCALL(write)
 164:	b8 10 00 00 00       	mov    $0x10,%eax
 169:	cd 40                	int    $0x40
 16b:	c3                   	ret    

0000016c <close>:
SYSCALL(close)
 16c:	b8 15 00 00 00       	mov    $0x15,%eax
 171:	cd 40                	int    $0x40
 173:	c3                   	ret    

00000174 <kill>:
SYSCALL(kill)
 174:	b8 06 00 00 00       	mov    $0x6,%eax
 179:	cd 40                	int    $0x40
 17b:	c3                   	ret    

0000017c <exec>:
SYSCALL(exec)
 17c:	b8 07 00 00 00       	mov    $0x7,%eax
 181:	cd 40                	int    $0x40
 183:	c3                   	ret    

00000184 <open>:
SYSCALL(open)
 184:	b8 0f 00 00 00       	mov    $0xf,%eax
 189:	cd 40                	int    $0x40
 18b:	c3                   	ret    

0000018c <mknod>:
SYSCALL(mknod)
 18c:	b8 11 00 00 00       	mov    $0x11,%eax
 191:	cd 40                	int    $0x40
 193:	c3                   	ret    

00000194 <unlink>:
SYSCALL(unlink)
 194:	b8 12 00 00 00       	mov    $0x12,%eax
 199:	cd 40                	int    $0x40
 19b:	c3                   	ret    

0000019c <fstat>:
SYSCALL(fstat)
 19c:	b8 08 00 00 00       	mov    $0x8,%eax
 1a1:	cd 40                	int    $0x40
 1a3:	c3                   	ret    

000001a4 <link>:
SYSCALL(link)
 1a4:	b8 13 00 00 00       	mov    $0x13,%eax
 1a9:	cd 40                	int    $0x40
 1ab:	c3                   	ret    

000001ac <mkdir>:
SYSCALL(mkdir)
 1ac:	b8 14 00 00 00       	mov    $0x14,%eax
 1b1:	cd 40                	int    $0x40
 1b3:	c3                   	ret    

000001b4 <chdir>:
SYSCALL(chdir)
 1b4:	b8 09 00 00 00       	mov    $0x9,%eax
 1b9:	cd 40                	int    $0x40
 1bb:	c3                   	ret    

000001bc <dup>:
SYSCALL(dup)
 1bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 1c1:	cd 40                	int    $0x40
 1c3:	c3                   	ret    

000001c4 <getpid>:
SYSCALL(getpid)
 1c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 1c9:	cd 40                	int    $0x40
 1cb:	c3                   	ret    

000001cc <sbrk>:
SYSCALL(sbrk)
 1cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 1d1:	cd 40                	int    $0x40
 1d3:	c3                   	ret    

000001d4 <sleep>:
SYSCALL(sleep)
 1d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 1d9:	cd 40                	int    $0x40
 1db:	c3                   	ret    

000001dc <uptime>:
SYSCALL(uptime)
 1dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 1e1:	cd 40                	int    $0x40
 1e3:	c3                   	ret    

000001e4 <date>:
SYSCALL(date)
 1e4:	b8 16 00 00 00       	mov    $0x16,%eax
 1e9:	cd 40                	int    $0x40
 1eb:	c3                   	ret    

000001ec <dup2>:
SYSCALL(dup2)
 1ec:	b8 17 00 00 00       	mov    $0x17,%eax
 1f1:	cd 40                	int    $0x40
 1f3:	c3                   	ret    

000001f4 <phmem>:
SYSCALL(phmem)
 1f4:	b8 18 00 00 00       	mov    $0x18,%eax
 1f9:	cd 40                	int    $0x40
 1fb:	c3                   	ret    

000001fc <getprio>:
SYSCALL(getprio)
 1fc:	b8 19 00 00 00       	mov    $0x19,%eax
 201:	cd 40                	int    $0x40
 203:	c3                   	ret    

00000204 <setprio>:
SYSCALL(setprio)
 204:	b8 1a 00 00 00       	mov    $0x1a,%eax
 209:	cd 40                	int    $0x40
 20b:	c3                   	ret    

0000020c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 1c             	sub    $0x1c,%esp
 212:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 215:	6a 01                	push   $0x1
 217:	8d 55 f4             	lea    -0xc(%ebp),%edx
 21a:	52                   	push   %edx
 21b:	50                   	push   %eax
 21c:	e8 43 ff ff ff       	call   164 <write>
}
 221:	83 c4 10             	add    $0x10,%esp
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	57                   	push   %edi
 22a:	56                   	push   %esi
 22b:	53                   	push   %ebx
 22c:	83 ec 2c             	sub    $0x2c,%esp
 22f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 232:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 238:	74 04                	je     23e <printint+0x18>
 23a:	85 d2                	test   %edx,%edx
 23c:	78 3c                	js     27a <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 23e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 240:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 247:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 24c:	89 c8                	mov    %ecx,%eax
 24e:	ba 00 00 00 00       	mov    $0x0,%edx
 253:	f7 f6                	div    %esi
 255:	89 df                	mov    %ebx,%edi
 257:	43                   	inc    %ebx
 258:	8a 92 98 04 00 00    	mov    0x498(%edx),%dl
 25e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 262:	89 ca                	mov    %ecx,%edx
 264:	89 c1                	mov    %eax,%ecx
 266:	39 d6                	cmp    %edx,%esi
 268:	76 e2                	jbe    24c <printint+0x26>
  if(neg)
 26a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 26e:	74 24                	je     294 <printint+0x6e>
    buf[i++] = '-';
 270:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 275:	8d 5f 02             	lea    0x2(%edi),%ebx
 278:	eb 1a                	jmp    294 <printint+0x6e>
    x = -xx;
 27a:	89 d1                	mov    %edx,%ecx
 27c:	f7 d9                	neg    %ecx
    neg = 1;
 27e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 285:	eb c0                	jmp    247 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 287:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 28c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 28f:	e8 78 ff ff ff       	call   20c <putc>
  while(--i >= 0)
 294:	4b                   	dec    %ebx
 295:	79 f0                	jns    287 <printint+0x61>
}
 297:	83 c4 2c             	add    $0x2c,%esp
 29a:	5b                   	pop    %ebx
 29b:	5e                   	pop    %esi
 29c:	5f                   	pop    %edi
 29d:	5d                   	pop    %ebp
 29e:	c3                   	ret    

0000029f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	57                   	push   %edi
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2a8:	8d 45 10             	lea    0x10(%ebp),%eax
 2ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2ae:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2b3:	bb 00 00 00 00       	mov    $0x0,%ebx
 2b8:	eb 12                	jmp    2cc <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2ba:	89 fa                	mov    %edi,%edx
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	e8 48 ff ff ff       	call   20c <putc>
 2c4:	eb 05                	jmp    2cb <printf+0x2c>
      }
    } else if(state == '%'){
 2c6:	83 fe 25             	cmp    $0x25,%esi
 2c9:	74 22                	je     2ed <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 2cb:	43                   	inc    %ebx
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2d2:	84 c0                	test   %al,%al
 2d4:	0f 84 1d 01 00 00    	je     3f7 <printf+0x158>
    c = fmt[i] & 0xff;
 2da:	0f be f8             	movsbl %al,%edi
 2dd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2e0:	85 f6                	test   %esi,%esi
 2e2:	75 e2                	jne    2c6 <printf+0x27>
      if(c == '%'){
 2e4:	83 f8 25             	cmp    $0x25,%eax
 2e7:	75 d1                	jne    2ba <printf+0x1b>
        state = '%';
 2e9:	89 c6                	mov    %eax,%esi
 2eb:	eb de                	jmp    2cb <printf+0x2c>
      if(c == 'd'){
 2ed:	83 f8 25             	cmp    $0x25,%eax
 2f0:	0f 84 cc 00 00 00    	je     3c2 <printf+0x123>
 2f6:	0f 8c da 00 00 00    	jl     3d6 <printf+0x137>
 2fc:	83 f8 78             	cmp    $0x78,%eax
 2ff:	0f 8f d1 00 00 00    	jg     3d6 <printf+0x137>
 305:	83 f8 63             	cmp    $0x63,%eax
 308:	0f 8c c8 00 00 00    	jl     3d6 <printf+0x137>
 30e:	83 e8 63             	sub    $0x63,%eax
 311:	83 f8 15             	cmp    $0x15,%eax
 314:	0f 87 bc 00 00 00    	ja     3d6 <printf+0x137>
 31a:	ff 24 85 40 04 00 00 	jmp    *0x440(,%eax,4)
        printint(fd, *ap, 10, 1);
 321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 324:	8b 17                	mov    (%edi),%edx
 326:	83 ec 0c             	sub    $0xc,%esp
 329:	6a 01                	push   $0x1
 32b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	e8 ee fe ff ff       	call   226 <printint>
        ap++;
 338:	83 c7 04             	add    $0x4,%edi
 33b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 33e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 341:	be 00 00 00 00       	mov    $0x0,%esi
 346:	eb 83                	jmp    2cb <printf+0x2c>
        printint(fd, *ap, 16, 0);
 348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 34b:	8b 17                	mov    (%edi),%edx
 34d:	83 ec 0c             	sub    $0xc,%esp
 350:	6a 00                	push   $0x0
 352:	b9 10 00 00 00       	mov    $0x10,%ecx
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	e8 c7 fe ff ff       	call   226 <printint>
        ap++;
 35f:	83 c7 04             	add    $0x4,%edi
 362:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 365:	83 c4 10             	add    $0x10,%esp
      state = 0;
 368:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 36d:	e9 59 ff ff ff       	jmp    2cb <printf+0x2c>
        s = (char*)*ap;
 372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 375:	8b 30                	mov    (%eax),%esi
        ap++;
 377:	83 c0 04             	add    $0x4,%eax
 37a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 37d:	85 f6                	test   %esi,%esi
 37f:	75 13                	jne    394 <printf+0xf5>
          s = "(null)";
 381:	be 38 04 00 00       	mov    $0x438,%esi
 386:	eb 0c                	jmp    394 <printf+0xf5>
          putc(fd, *s);
 388:	0f be d2             	movsbl %dl,%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	e8 79 fe ff ff       	call   20c <putc>
          s++;
 393:	46                   	inc    %esi
        while(*s != 0){
 394:	8a 16                	mov    (%esi),%dl
 396:	84 d2                	test   %dl,%dl
 398:	75 ee                	jne    388 <printf+0xe9>
      state = 0;
 39a:	be 00 00 00 00       	mov    $0x0,%esi
 39f:	e9 27 ff ff ff       	jmp    2cb <printf+0x2c>
        putc(fd, *ap);
 3a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3a7:	0f be 17             	movsbl (%edi),%edx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	e8 5a fe ff ff       	call   20c <putc>
        ap++;
 3b2:	83 c7 04             	add    $0x4,%edi
 3b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3b8:	be 00 00 00 00       	mov    $0x0,%esi
 3bd:	e9 09 ff ff ff       	jmp    2cb <printf+0x2c>
        putc(fd, c);
 3c2:	89 fa                	mov    %edi,%edx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	e8 40 fe ff ff       	call   20c <putc>
      state = 0;
 3cc:	be 00 00 00 00       	mov    $0x0,%esi
 3d1:	e9 f5 fe ff ff       	jmp    2cb <printf+0x2c>
        putc(fd, '%');
 3d6:	ba 25 00 00 00       	mov    $0x25,%edx
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	e8 29 fe ff ff       	call   20c <putc>
        putc(fd, c);
 3e3:	89 fa                	mov    %edi,%edx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	e8 1f fe ff ff       	call   20c <putc>
      state = 0;
 3ed:	be 00 00 00 00       	mov    $0x0,%esi
 3f2:	e9 d4 fe ff ff       	jmp    2cb <printf+0x2c>
    }
  }
}
 3f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fa:	5b                   	pop    %ebx
 3fb:	5e                   	pop    %esi
 3fc:	5f                   	pop    %edi
 3fd:	5d                   	pop    %ebp
 3fe:	c3                   	ret    
