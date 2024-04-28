
exitwait:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <forktest>:
*/
#define N  1000

void
forktest(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 18             	sub    $0x18,%esp
  int n, pid;
  int status;

  printf(1, "exit/wait with status test\n");
   8:	68 34 04 00 00       	push   $0x434
   d:	6a 01                	push   $0x1
   f:	e8 bd 02 00 00       	call   2d1 <printf>

  for(n=0; n<N; n++){
  14:	83 c4 10             	add    $0x10,%esp
  17:	bb 00 00 00 00       	mov    $0x0,%ebx
  1c:	eb 01                	jmp    1f <forktest+0x1f>
  1e:	43                   	inc    %ebx
  1f:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  25:	7f 36                	jg     5d <forktest+0x5d>
    pid = fork();
  27:	e8 42 01 00 00       	call   16e <fork>
    if(pid < 0)
  2c:	85 c0                	test   %eax,%eax
  2e:	78 2d                	js     5d <forktest+0x5d>
      break;
    if(pid == 0)
  30:	75 ec                	jne    1e <forktest+0x1e>
      exit(n - 1/(n/40));  // Some process will fail with divide by 0
  32:	b8 67 66 66 66       	mov    $0x66666667,%eax
  37:	f7 eb                	imul   %ebx
  39:	89 d1                	mov    %edx,%ecx
  3b:	c1 f9 04             	sar    $0x4,%ecx
  3e:	89 d8                	mov    %ebx,%eax
  40:	c1 f8 1f             	sar    $0x1f,%eax
  43:	29 c1                	sub    %eax,%ecx
  45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4a:	99                   	cltd   
  4b:	f7 f9                	idiv   %ecx
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	01 d8                	add    %ebx,%eax
  52:	50                   	push   %eax
  53:	e8 1e 01 00 00       	call   176 <exit>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	eb c1                	jmp    1e <forktest+0x1e>
  }

  if(n == N)
  5d:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  63:	75 58                	jne    bd <forktest+0xbd>
  {
    printf(1, "fork claimed to work %d times!\n", N);
  65:	83 ec 04             	sub    $0x4,%esp
  68:	68 e8 03 00 00       	push   $0x3e8
  6d:	68 a4 04 00 00       	push   $0x4a4
  72:	6a 01                	push   $0x1
  74:	e8 58 02 00 00       	call   2d1 <printf>
    exit(N);
  79:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  80:	e8 f1 00 00 00       	call   176 <exit>
  85:	83 c4 10             	add    $0x10,%esp
  88:	eb 33                	jmp    bd <forktest+0xbd>

  for(; n > 0; n--)
  {
    if((pid = wait(&status)) < 0)
    {
      printf(1, "wait stopped early\n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 50 04 00 00       	push   $0x450
  92:	6a 01                	push   $0x1
  94:	e8 38 02 00 00       	call   2d1 <printf>
      exit(-1);
  99:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  a0:	e8 d1 00 00 00       	call   176 <exit>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	eb 2c                	jmp    d6 <forktest+0xd6>
    }
    if (WIFEXITED (status))
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
    else if (WIFSIGNALED(status))
      printf (1, "Exited child (failure) %d, trap %d\n", pid, WEXITTRAP (status));
  aa:	4a                   	dec    %edx
  ab:	52                   	push   %edx
  ac:	56                   	push   %esi
  ad:	68 c4 04 00 00       	push   $0x4c4
  b2:	6a 01                	push   $0x1
  b4:	e8 18 02 00 00       	call   2d1 <printf>
  b9:	83 c4 10             	add    $0x10,%esp
  for(; n > 0; n--)
  bc:	4b                   	dec    %ebx
  bd:	85 db                	test   %ebx,%ebx
  bf:	7e 35                	jle    f6 <forktest+0xf6>
    if((pid = wait(&status)) < 0)
  c1:	83 ec 0c             	sub    $0xc,%esp
  c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  c7:	50                   	push   %eax
  c8:	e8 b1 00 00 00       	call   17e <wait>
  cd:	89 c6                	mov    %eax,%esi
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	85 c0                	test   %eax,%eax
  d4:	78 b4                	js     8a <forktest+0x8a>
    if (WIFEXITED (status))
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	89 c2                	mov    %eax,%edx
  db:	83 e2 7f             	and    $0x7f,%edx
  de:	75 ca                	jne    aa <forktest+0xaa>
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
  e0:	0f b6 c4             	movzbl %ah,%eax
  e3:	50                   	push   %eax
  e4:	56                   	push   %esi
  e5:	68 64 04 00 00       	push   $0x464
  ea:	6a 01                	push   $0x1
  ec:	e8 e0 01 00 00       	call   2d1 <printf>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	eb c6                	jmp    bc <forktest+0xbc>
  }

  if(wait(0) != -1){
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	6a 00                	push   $0x0
  fb:	e8 7e 00 00 00       	call   17e <wait>
 100:	83 c4 10             	add    $0x10,%esp
 103:	83 f8 ff             	cmp    $0xffffffff,%eax
 106:	75 19                	jne    121 <forktest+0x121>
    printf(1, "wait got too many\n");
    exit(-1);
  }

  printf(1, "fork test OK\n");
 108:	83 ec 08             	sub    $0x8,%esp
 10b:	68 95 04 00 00       	push   $0x495
 110:	6a 01                	push   $0x1
 112:	e8 ba 01 00 00       	call   2d1 <printf>
}
 117:	83 c4 10             	add    $0x10,%esp
 11a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 11d:	5b                   	pop    %ebx
 11e:	5e                   	pop    %esi
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
    printf(1, "wait got too many\n");
 121:	83 ec 08             	sub    $0x8,%esp
 124:	68 82 04 00 00       	push   $0x482
 129:	6a 01                	push   $0x1
 12b:	e8 a1 01 00 00       	call   2d1 <printf>
    exit(-1);
 130:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 137:	e8 3a 00 00 00       	call   176 <exit>
 13c:	83 c4 10             	add    $0x10,%esp
 13f:	eb c7                	jmp    108 <forktest+0x108>

00000141 <main>:

int
main(void)
{
 141:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 145:	83 e4 f0             	and    $0xfffffff0,%esp
 148:	ff 71 fc             	push   -0x4(%ecx)
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	51                   	push   %ecx
 14f:	83 ec 04             	sub    $0x4,%esp
  forktest();
 152:	e8 a9 fe ff ff       	call   0 <forktest>
  exit(0);
 157:	83 ec 0c             	sub    $0xc,%esp
 15a:	6a 00                	push   $0x0
 15c:	e8 15 00 00 00       	call   176 <exit>
}
 161:	b8 00 00 00 00       	mov    $0x0,%eax
 166:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 169:	c9                   	leave  
 16a:	8d 61 fc             	lea    -0x4(%ecx),%esp
 16d:	c3                   	ret    

0000016e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 16e:	b8 01 00 00 00       	mov    $0x1,%eax
 173:	cd 40                	int    $0x40
 175:	c3                   	ret    

00000176 <exit>:
SYSCALL(exit)
 176:	b8 02 00 00 00       	mov    $0x2,%eax
 17b:	cd 40                	int    $0x40
 17d:	c3                   	ret    

0000017e <wait>:
SYSCALL(wait)
 17e:	b8 03 00 00 00       	mov    $0x3,%eax
 183:	cd 40                	int    $0x40
 185:	c3                   	ret    

00000186 <pipe>:
SYSCALL(pipe)
 186:	b8 04 00 00 00       	mov    $0x4,%eax
 18b:	cd 40                	int    $0x40
 18d:	c3                   	ret    

0000018e <read>:
SYSCALL(read)
 18e:	b8 05 00 00 00       	mov    $0x5,%eax
 193:	cd 40                	int    $0x40
 195:	c3                   	ret    

00000196 <write>:
SYSCALL(write)
 196:	b8 10 00 00 00       	mov    $0x10,%eax
 19b:	cd 40                	int    $0x40
 19d:	c3                   	ret    

0000019e <close>:
SYSCALL(close)
 19e:	b8 15 00 00 00       	mov    $0x15,%eax
 1a3:	cd 40                	int    $0x40
 1a5:	c3                   	ret    

000001a6 <kill>:
SYSCALL(kill)
 1a6:	b8 06 00 00 00       	mov    $0x6,%eax
 1ab:	cd 40                	int    $0x40
 1ad:	c3                   	ret    

000001ae <exec>:
SYSCALL(exec)
 1ae:	b8 07 00 00 00       	mov    $0x7,%eax
 1b3:	cd 40                	int    $0x40
 1b5:	c3                   	ret    

000001b6 <open>:
SYSCALL(open)
 1b6:	b8 0f 00 00 00       	mov    $0xf,%eax
 1bb:	cd 40                	int    $0x40
 1bd:	c3                   	ret    

000001be <mknod>:
SYSCALL(mknod)
 1be:	b8 11 00 00 00       	mov    $0x11,%eax
 1c3:	cd 40                	int    $0x40
 1c5:	c3                   	ret    

000001c6 <unlink>:
SYSCALL(unlink)
 1c6:	b8 12 00 00 00       	mov    $0x12,%eax
 1cb:	cd 40                	int    $0x40
 1cd:	c3                   	ret    

000001ce <fstat>:
SYSCALL(fstat)
 1ce:	b8 08 00 00 00       	mov    $0x8,%eax
 1d3:	cd 40                	int    $0x40
 1d5:	c3                   	ret    

000001d6 <link>:
SYSCALL(link)
 1d6:	b8 13 00 00 00       	mov    $0x13,%eax
 1db:	cd 40                	int    $0x40
 1dd:	c3                   	ret    

000001de <mkdir>:
SYSCALL(mkdir)
 1de:	b8 14 00 00 00       	mov    $0x14,%eax
 1e3:	cd 40                	int    $0x40
 1e5:	c3                   	ret    

000001e6 <chdir>:
SYSCALL(chdir)
 1e6:	b8 09 00 00 00       	mov    $0x9,%eax
 1eb:	cd 40                	int    $0x40
 1ed:	c3                   	ret    

000001ee <dup>:
SYSCALL(dup)
 1ee:	b8 0a 00 00 00       	mov    $0xa,%eax
 1f3:	cd 40                	int    $0x40
 1f5:	c3                   	ret    

000001f6 <getpid>:
SYSCALL(getpid)
 1f6:	b8 0b 00 00 00       	mov    $0xb,%eax
 1fb:	cd 40                	int    $0x40
 1fd:	c3                   	ret    

000001fe <sbrk>:
SYSCALL(sbrk)
 1fe:	b8 0c 00 00 00       	mov    $0xc,%eax
 203:	cd 40                	int    $0x40
 205:	c3                   	ret    

00000206 <sleep>:
SYSCALL(sleep)
 206:	b8 0d 00 00 00       	mov    $0xd,%eax
 20b:	cd 40                	int    $0x40
 20d:	c3                   	ret    

0000020e <uptime>:
SYSCALL(uptime)
 20e:	b8 0e 00 00 00       	mov    $0xe,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <date>:
SYSCALL(date)
 216:	b8 16 00 00 00       	mov    $0x16,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <dup2>:
SYSCALL(dup2)
 21e:	b8 17 00 00 00       	mov    $0x17,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <phmem>:
SYSCALL(phmem)
 226:	b8 18 00 00 00       	mov    $0x18,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <getprio>:
SYSCALL(getprio)
 22e:	b8 19 00 00 00       	mov    $0x19,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <setprio>:
SYSCALL(setprio)
 236:	b8 1a 00 00 00       	mov    $0x1a,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 1c             	sub    $0x1c,%esp
 244:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 247:	6a 01                	push   $0x1
 249:	8d 55 f4             	lea    -0xc(%ebp),%edx
 24c:	52                   	push   %edx
 24d:	50                   	push   %eax
 24e:	e8 43 ff ff ff       	call   196 <write>
}
 253:	83 c4 10             	add    $0x10,%esp
 256:	c9                   	leave  
 257:	c3                   	ret    

00000258 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	57                   	push   %edi
 25c:	56                   	push   %esi
 25d:	53                   	push   %ebx
 25e:	83 ec 2c             	sub    $0x2c,%esp
 261:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 264:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 26a:	74 04                	je     270 <printint+0x18>
 26c:	85 d2                	test   %edx,%edx
 26e:	78 3c                	js     2ac <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 270:	89 d1                	mov    %edx,%ecx
  neg = 0;
 272:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 279:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 27e:	89 c8                	mov    %ecx,%eax
 280:	ba 00 00 00 00       	mov    $0x0,%edx
 285:	f7 f6                	div    %esi
 287:	89 df                	mov    %ebx,%edi
 289:	43                   	inc    %ebx
 28a:	8a 92 48 05 00 00    	mov    0x548(%edx),%dl
 290:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 294:	89 ca                	mov    %ecx,%edx
 296:	89 c1                	mov    %eax,%ecx
 298:	39 d6                	cmp    %edx,%esi
 29a:	76 e2                	jbe    27e <printint+0x26>
  if(neg)
 29c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2a0:	74 24                	je     2c6 <printint+0x6e>
    buf[i++] = '-';
 2a2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2a7:	8d 5f 02             	lea    0x2(%edi),%ebx
 2aa:	eb 1a                	jmp    2c6 <printint+0x6e>
    x = -xx;
 2ac:	89 d1                	mov    %edx,%ecx
 2ae:	f7 d9                	neg    %ecx
    neg = 1;
 2b0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 2b7:	eb c0                	jmp    279 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 2b9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2c1:	e8 78 ff ff ff       	call   23e <putc>
  while(--i >= 0)
 2c6:	4b                   	dec    %ebx
 2c7:	79 f0                	jns    2b9 <printint+0x61>
}
 2c9:	83 c4 2c             	add    $0x2c,%esp
 2cc:	5b                   	pop    %ebx
 2cd:	5e                   	pop    %esi
 2ce:	5f                   	pop    %edi
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    

000002d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	57                   	push   %edi
 2d5:	56                   	push   %esi
 2d6:	53                   	push   %ebx
 2d7:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2da:	8d 45 10             	lea    0x10(%ebp),%eax
 2dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2e0:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2e5:	bb 00 00 00 00       	mov    $0x0,%ebx
 2ea:	eb 12                	jmp    2fe <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2ec:	89 fa                	mov    %edi,%edx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	e8 48 ff ff ff       	call   23e <putc>
 2f6:	eb 05                	jmp    2fd <printf+0x2c>
      }
    } else if(state == '%'){
 2f8:	83 fe 25             	cmp    $0x25,%esi
 2fb:	74 22                	je     31f <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 2fd:	43                   	inc    %ebx
 2fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 301:	8a 04 18             	mov    (%eax,%ebx,1),%al
 304:	84 c0                	test   %al,%al
 306:	0f 84 1d 01 00 00    	je     429 <printf+0x158>
    c = fmt[i] & 0xff;
 30c:	0f be f8             	movsbl %al,%edi
 30f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 312:	85 f6                	test   %esi,%esi
 314:	75 e2                	jne    2f8 <printf+0x27>
      if(c == '%'){
 316:	83 f8 25             	cmp    $0x25,%eax
 319:	75 d1                	jne    2ec <printf+0x1b>
        state = '%';
 31b:	89 c6                	mov    %eax,%esi
 31d:	eb de                	jmp    2fd <printf+0x2c>
      if(c == 'd'){
 31f:	83 f8 25             	cmp    $0x25,%eax
 322:	0f 84 cc 00 00 00    	je     3f4 <printf+0x123>
 328:	0f 8c da 00 00 00    	jl     408 <printf+0x137>
 32e:	83 f8 78             	cmp    $0x78,%eax
 331:	0f 8f d1 00 00 00    	jg     408 <printf+0x137>
 337:	83 f8 63             	cmp    $0x63,%eax
 33a:	0f 8c c8 00 00 00    	jl     408 <printf+0x137>
 340:	83 e8 63             	sub    $0x63,%eax
 343:	83 f8 15             	cmp    $0x15,%eax
 346:	0f 87 bc 00 00 00    	ja     408 <printf+0x137>
 34c:	ff 24 85 f0 04 00 00 	jmp    *0x4f0(,%eax,4)
        printint(fd, *ap, 10, 1);
 353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 356:	8b 17                	mov    (%edi),%edx
 358:	83 ec 0c             	sub    $0xc,%esp
 35b:	6a 01                	push   $0x1
 35d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	e8 ee fe ff ff       	call   258 <printint>
        ap++;
 36a:	83 c7 04             	add    $0x4,%edi
 36d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 370:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 373:	be 00 00 00 00       	mov    $0x0,%esi
 378:	eb 83                	jmp    2fd <printf+0x2c>
        printint(fd, *ap, 16, 0);
 37a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 37d:	8b 17                	mov    (%edi),%edx
 37f:	83 ec 0c             	sub    $0xc,%esp
 382:	6a 00                	push   $0x0
 384:	b9 10 00 00 00       	mov    $0x10,%ecx
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	e8 c7 fe ff ff       	call   258 <printint>
        ap++;
 391:	83 c7 04             	add    $0x4,%edi
 394:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 397:	83 c4 10             	add    $0x10,%esp
      state = 0;
 39a:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 39f:	e9 59 ff ff ff       	jmp    2fd <printf+0x2c>
        s = (char*)*ap;
 3a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3a7:	8b 30                	mov    (%eax),%esi
        ap++;
 3a9:	83 c0 04             	add    $0x4,%eax
 3ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3af:	85 f6                	test   %esi,%esi
 3b1:	75 13                	jne    3c6 <printf+0xf5>
          s = "(null)";
 3b3:	be e8 04 00 00       	mov    $0x4e8,%esi
 3b8:	eb 0c                	jmp    3c6 <printf+0xf5>
          putc(fd, *s);
 3ba:	0f be d2             	movsbl %dl,%edx
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	e8 79 fe ff ff       	call   23e <putc>
          s++;
 3c5:	46                   	inc    %esi
        while(*s != 0){
 3c6:	8a 16                	mov    (%esi),%dl
 3c8:	84 d2                	test   %dl,%dl
 3ca:	75 ee                	jne    3ba <printf+0xe9>
      state = 0;
 3cc:	be 00 00 00 00       	mov    $0x0,%esi
 3d1:	e9 27 ff ff ff       	jmp    2fd <printf+0x2c>
        putc(fd, *ap);
 3d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d9:	0f be 17             	movsbl (%edi),%edx
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	e8 5a fe ff ff       	call   23e <putc>
        ap++;
 3e4:	83 c7 04             	add    $0x4,%edi
 3e7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3ea:	be 00 00 00 00       	mov    $0x0,%esi
 3ef:	e9 09 ff ff ff       	jmp    2fd <printf+0x2c>
        putc(fd, c);
 3f4:	89 fa                	mov    %edi,%edx
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	e8 40 fe ff ff       	call   23e <putc>
      state = 0;
 3fe:	be 00 00 00 00       	mov    $0x0,%esi
 403:	e9 f5 fe ff ff       	jmp    2fd <printf+0x2c>
        putc(fd, '%');
 408:	ba 25 00 00 00       	mov    $0x25,%edx
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	e8 29 fe ff ff       	call   23e <putc>
        putc(fd, c);
 415:	89 fa                	mov    %edi,%edx
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	e8 1f fe ff ff       	call   23e <putc>
      state = 0;
 41f:	be 00 00 00 00       	mov    $0x0,%esi
 424:	e9 d4 fe ff ff       	jmp    2fd <printf+0x2c>
    }
  }
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
