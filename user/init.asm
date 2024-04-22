
init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 c4 03 00 00       	push   $0x3c4
  19:	e8 29 01 00 00       	call   147 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 1b                	js     40 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 50 01 00 00       	call   17f <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 44 01 00 00       	call   17f <dup>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb 6c                	jmp    ac <main+0xac>
    mknod("console", 1, 1);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	6a 01                	push   $0x1
  45:	6a 01                	push   $0x1
  47:	68 c4 03 00 00       	push   $0x3c4
  4c:	e8 fe 00 00 00       	call   14f <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 c4 03 00 00       	push   $0x3c4
  5b:	e8 e7 00 00 00       	call   147 <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 df 03 00 00       	push   $0x3df
  6d:	6a 01                	push   $0x1
  6f:	e8 ee 01 00 00       	call   262 <printf>
      exit(0);
  74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7b:	e8 87 00 00 00       	call   107 <exit>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb 44                	jmp    c9 <main+0xc9>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit(0);
    }
    while((wpid=wait(NULL)) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 0b 04 00 00       	push   $0x40b
  8d:	6a 01                	push   $0x1
  8f:	e8 ce 01 00 00       	call   262 <printf>
  94:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait(NULL)) >= 0 && wpid != pid)
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 00                	push   $0x0
  9c:	e8 6e 00 00 00       	call   10f <wait>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	85 c0                	test   %eax,%eax
  a6:	78 04                	js     ac <main+0xac>
  a8:	39 c3                	cmp    %eax,%ebx
  aa:	75 d9                	jne    85 <main+0x85>
    printf(1, "init: starting sh\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 cc 03 00 00       	push   $0x3cc
  b4:	6a 01                	push   $0x1
  b6:	e8 a7 01 00 00       	call   262 <printf>
    pid = fork();
  bb:	e8 3f 00 00 00       	call   ff <fork>
  c0:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	85 c0                	test   %eax,%eax
  c7:	78 9c                	js     65 <main+0x65>
    if(pid == 0){
  c9:	85 db                	test   %ebx,%ebx
  cb:	75 ca                	jne    97 <main+0x97>
      exec("sh", argv);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 44 05 00 00       	push   $0x544
  d5:	68 f2 03 00 00       	push   $0x3f2
  da:	e8 60 00 00 00       	call   13f <exec>
      printf(1, "init: exec sh failed\n");
  df:	83 c4 08             	add    $0x8,%esp
  e2:	68 f5 03 00 00       	push   $0x3f5
  e7:	6a 01                	push   $0x1
  e9:	e8 74 01 00 00       	call   262 <printf>
      exit(0);
  ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f5:	e8 0d 00 00 00       	call   107 <exit>
  fa:	83 c4 10             	add    $0x10,%esp
  fd:	eb 98                	jmp    97 <main+0x97>

000000ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  ff:	b8 01 00 00 00       	mov    $0x1,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <exit>:
SYSCALL(exit)
 107:	b8 02 00 00 00       	mov    $0x2,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <wait>:
SYSCALL(wait)
 10f:	b8 03 00 00 00       	mov    $0x3,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <pipe>:
SYSCALL(pipe)
 117:	b8 04 00 00 00       	mov    $0x4,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <read>:
SYSCALL(read)
 11f:	b8 05 00 00 00       	mov    $0x5,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <write>:
SYSCALL(write)
 127:	b8 10 00 00 00       	mov    $0x10,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <close>:
SYSCALL(close)
 12f:	b8 15 00 00 00       	mov    $0x15,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <kill>:
SYSCALL(kill)
 137:	b8 06 00 00 00       	mov    $0x6,%eax
 13c:	cd 40                	int    $0x40
 13e:	c3                   	ret    

0000013f <exec>:
SYSCALL(exec)
 13f:	b8 07 00 00 00       	mov    $0x7,%eax
 144:	cd 40                	int    $0x40
 146:	c3                   	ret    

00000147 <open>:
SYSCALL(open)
 147:	b8 0f 00 00 00       	mov    $0xf,%eax
 14c:	cd 40                	int    $0x40
 14e:	c3                   	ret    

0000014f <mknod>:
SYSCALL(mknod)
 14f:	b8 11 00 00 00       	mov    $0x11,%eax
 154:	cd 40                	int    $0x40
 156:	c3                   	ret    

00000157 <unlink>:
SYSCALL(unlink)
 157:	b8 12 00 00 00       	mov    $0x12,%eax
 15c:	cd 40                	int    $0x40
 15e:	c3                   	ret    

0000015f <fstat>:
SYSCALL(fstat)
 15f:	b8 08 00 00 00       	mov    $0x8,%eax
 164:	cd 40                	int    $0x40
 166:	c3                   	ret    

00000167 <link>:
SYSCALL(link)
 167:	b8 13 00 00 00       	mov    $0x13,%eax
 16c:	cd 40                	int    $0x40
 16e:	c3                   	ret    

0000016f <mkdir>:
SYSCALL(mkdir)
 16f:	b8 14 00 00 00       	mov    $0x14,%eax
 174:	cd 40                	int    $0x40
 176:	c3                   	ret    

00000177 <chdir>:
SYSCALL(chdir)
 177:	b8 09 00 00 00       	mov    $0x9,%eax
 17c:	cd 40                	int    $0x40
 17e:	c3                   	ret    

0000017f <dup>:
SYSCALL(dup)
 17f:	b8 0a 00 00 00       	mov    $0xa,%eax
 184:	cd 40                	int    $0x40
 186:	c3                   	ret    

00000187 <getpid>:
SYSCALL(getpid)
 187:	b8 0b 00 00 00       	mov    $0xb,%eax
 18c:	cd 40                	int    $0x40
 18e:	c3                   	ret    

0000018f <sbrk>:
SYSCALL(sbrk)
 18f:	b8 0c 00 00 00       	mov    $0xc,%eax
 194:	cd 40                	int    $0x40
 196:	c3                   	ret    

00000197 <sleep>:
SYSCALL(sleep)
 197:	b8 0d 00 00 00       	mov    $0xd,%eax
 19c:	cd 40                	int    $0x40
 19e:	c3                   	ret    

0000019f <uptime>:
SYSCALL(uptime)
 19f:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a4:	cd 40                	int    $0x40
 1a6:	c3                   	ret    

000001a7 <date>:
SYSCALL(date)
 1a7:	b8 16 00 00 00       	mov    $0x16,%eax
 1ac:	cd 40                	int    $0x40
 1ae:	c3                   	ret    

000001af <dup2>:
SYSCALL(dup2)
 1af:	b8 17 00 00 00       	mov    $0x17,%eax
 1b4:	cd 40                	int    $0x40
 1b6:	c3                   	ret    

000001b7 <phmem>:
SYSCALL(phmem)
 1b7:	b8 18 00 00 00       	mov    $0x18,%eax
 1bc:	cd 40                	int    $0x40
 1be:	c3                   	ret    

000001bf <getprio>:
SYSCALL(getprio)
 1bf:	b8 19 00 00 00       	mov    $0x19,%eax
 1c4:	cd 40                	int    $0x40
 1c6:	c3                   	ret    

000001c7 <setprio>:
SYSCALL(setprio)
 1c7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 1cc:	cd 40                	int    $0x40
 1ce:	c3                   	ret    

000001cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 1c             	sub    $0x1c,%esp
 1d5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1d8:	6a 01                	push   $0x1
 1da:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1dd:	52                   	push   %edx
 1de:	50                   	push   %eax
 1df:	e8 43 ff ff ff       	call   127 <write>
}
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	57                   	push   %edi
 1ed:	56                   	push   %esi
 1ee:	53                   	push   %ebx
 1ef:	83 ec 2c             	sub    $0x2c,%esp
 1f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1f5:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1fb:	74 04                	je     201 <printint+0x18>
 1fd:	85 d2                	test   %edx,%edx
 1ff:	78 3c                	js     23d <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 201:	89 d1                	mov    %edx,%ecx
  neg = 0;
 203:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 20a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 20f:	89 c8                	mov    %ecx,%eax
 211:	ba 00 00 00 00       	mov    $0x0,%edx
 216:	f7 f6                	div    %esi
 218:	89 df                	mov    %ebx,%edi
 21a:	43                   	inc    %ebx
 21b:	8a 92 74 04 00 00    	mov    0x474(%edx),%dl
 221:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 225:	89 ca                	mov    %ecx,%edx
 227:	89 c1                	mov    %eax,%ecx
 229:	39 d6                	cmp    %edx,%esi
 22b:	76 e2                	jbe    20f <printint+0x26>
  if(neg)
 22d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 231:	74 24                	je     257 <printint+0x6e>
    buf[i++] = '-';
 233:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 238:	8d 5f 02             	lea    0x2(%edi),%ebx
 23b:	eb 1a                	jmp    257 <printint+0x6e>
    x = -xx;
 23d:	89 d1                	mov    %edx,%ecx
 23f:	f7 d9                	neg    %ecx
    neg = 1;
 241:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 248:	eb c0                	jmp    20a <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 24a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 24f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 252:	e8 78 ff ff ff       	call   1cf <putc>
  while(--i >= 0)
 257:	4b                   	dec    %ebx
 258:	79 f0                	jns    24a <printint+0x61>
}
 25a:	83 c4 2c             	add    $0x2c,%esp
 25d:	5b                   	pop    %ebx
 25e:	5e                   	pop    %esi
 25f:	5f                   	pop    %edi
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	57                   	push   %edi
 266:	56                   	push   %esi
 267:	53                   	push   %ebx
 268:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 26b:	8d 45 10             	lea    0x10(%ebp),%eax
 26e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 271:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 276:	bb 00 00 00 00       	mov    $0x0,%ebx
 27b:	eb 12                	jmp    28f <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 27d:	89 fa                	mov    %edi,%edx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	e8 48 ff ff ff       	call   1cf <putc>
 287:	eb 05                	jmp    28e <printf+0x2c>
      }
    } else if(state == '%'){
 289:	83 fe 25             	cmp    $0x25,%esi
 28c:	74 22                	je     2b0 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 28e:	43                   	inc    %ebx
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	8a 04 18             	mov    (%eax,%ebx,1),%al
 295:	84 c0                	test   %al,%al
 297:	0f 84 1d 01 00 00    	je     3ba <printf+0x158>
    c = fmt[i] & 0xff;
 29d:	0f be f8             	movsbl %al,%edi
 2a0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2a3:	85 f6                	test   %esi,%esi
 2a5:	75 e2                	jne    289 <printf+0x27>
      if(c == '%'){
 2a7:	83 f8 25             	cmp    $0x25,%eax
 2aa:	75 d1                	jne    27d <printf+0x1b>
        state = '%';
 2ac:	89 c6                	mov    %eax,%esi
 2ae:	eb de                	jmp    28e <printf+0x2c>
      if(c == 'd'){
 2b0:	83 f8 25             	cmp    $0x25,%eax
 2b3:	0f 84 cc 00 00 00    	je     385 <printf+0x123>
 2b9:	0f 8c da 00 00 00    	jl     399 <printf+0x137>
 2bf:	83 f8 78             	cmp    $0x78,%eax
 2c2:	0f 8f d1 00 00 00    	jg     399 <printf+0x137>
 2c8:	83 f8 63             	cmp    $0x63,%eax
 2cb:	0f 8c c8 00 00 00    	jl     399 <printf+0x137>
 2d1:	83 e8 63             	sub    $0x63,%eax
 2d4:	83 f8 15             	cmp    $0x15,%eax
 2d7:	0f 87 bc 00 00 00    	ja     399 <printf+0x137>
 2dd:	ff 24 85 1c 04 00 00 	jmp    *0x41c(,%eax,4)
        printint(fd, *ap, 10, 1);
 2e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e7:	8b 17                	mov    (%edi),%edx
 2e9:	83 ec 0c             	sub    $0xc,%esp
 2ec:	6a 01                	push   $0x1
 2ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	e8 ee fe ff ff       	call   1e9 <printint>
        ap++;
 2fb:	83 c7 04             	add    $0x4,%edi
 2fe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 301:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 304:	be 00 00 00 00       	mov    $0x0,%esi
 309:	eb 83                	jmp    28e <printf+0x2c>
        printint(fd, *ap, 16, 0);
 30b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 30e:	8b 17                	mov    (%edi),%edx
 310:	83 ec 0c             	sub    $0xc,%esp
 313:	6a 00                	push   $0x0
 315:	b9 10 00 00 00       	mov    $0x10,%ecx
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	e8 c7 fe ff ff       	call   1e9 <printint>
        ap++;
 322:	83 c7 04             	add    $0x4,%edi
 325:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 328:	83 c4 10             	add    $0x10,%esp
      state = 0;
 32b:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 330:	e9 59 ff ff ff       	jmp    28e <printf+0x2c>
        s = (char*)*ap;
 335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 338:	8b 30                	mov    (%eax),%esi
        ap++;
 33a:	83 c0 04             	add    $0x4,%eax
 33d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 340:	85 f6                	test   %esi,%esi
 342:	75 13                	jne    357 <printf+0xf5>
          s = "(null)";
 344:	be 14 04 00 00       	mov    $0x414,%esi
 349:	eb 0c                	jmp    357 <printf+0xf5>
          putc(fd, *s);
 34b:	0f be d2             	movsbl %dl,%edx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	e8 79 fe ff ff       	call   1cf <putc>
          s++;
 356:	46                   	inc    %esi
        while(*s != 0){
 357:	8a 16                	mov    (%esi),%dl
 359:	84 d2                	test   %dl,%dl
 35b:	75 ee                	jne    34b <printf+0xe9>
      state = 0;
 35d:	be 00 00 00 00       	mov    $0x0,%esi
 362:	e9 27 ff ff ff       	jmp    28e <printf+0x2c>
        putc(fd, *ap);
 367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 36a:	0f be 17             	movsbl (%edi),%edx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	e8 5a fe ff ff       	call   1cf <putc>
        ap++;
 375:	83 c7 04             	add    $0x4,%edi
 378:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 37b:	be 00 00 00 00       	mov    $0x0,%esi
 380:	e9 09 ff ff ff       	jmp    28e <printf+0x2c>
        putc(fd, c);
 385:	89 fa                	mov    %edi,%edx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	e8 40 fe ff ff       	call   1cf <putc>
      state = 0;
 38f:	be 00 00 00 00       	mov    $0x0,%esi
 394:	e9 f5 fe ff ff       	jmp    28e <printf+0x2c>
        putc(fd, '%');
 399:	ba 25 00 00 00       	mov    $0x25,%edx
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	e8 29 fe ff ff       	call   1cf <putc>
        putc(fd, c);
 3a6:	89 fa                	mov    %edi,%edx
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	e8 1f fe ff ff       	call   1cf <putc>
      state = 0;
 3b0:	be 00 00 00 00       	mov    $0x0,%esi
 3b5:	e9 d4 fe ff ff       	jmp    28e <printf+0x2c>
    }
  }
}
 3ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bd:	5b                   	pop    %ebx
 3be:	5e                   	pop    %esi
 3bf:	5f                   	pop    %edi
 3c0:	5d                   	pop    %ebp
 3c1:	c3                   	ret    
