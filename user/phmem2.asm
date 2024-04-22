
phmem2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char array[4096];

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
  10:	83 ec 18             	sub    $0x18,%esp
  int pid, physical_mem;

  char *memory = sbrk(32768*sizeof(char));
  13:	68 00 80 00 00       	push   $0x8000
  18:	e8 14 01 00 00       	call   131 <sbrk>


  memory[0] = 'A';
  1d:	c6 00 41             	movb   $0x41,(%eax)
  memory[8192] = 'B';
  20:	c6 80 00 20 00 00 42 	movb   $0x42,0x2000(%eax)

  array[0] = 'A';
  27:	c6 05 20 05 00 00 41 	movb   $0x41,0x520

  pid = getpid();
  2e:	e8 f6 00 00 00       	call   129 <getpid>
  33:	89 c3                	mov    %eax,%ebx
  
  physical_mem = phmem(pid);
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 1c 01 00 00       	call   159 <phmem>
  3d:	89 c6                	mov    %eax,%esi

  if (physical_mem == -1)
  3f:	83 c4 10             	add    $0x10,%esp
  42:	83 f8 ff             	cmp    $0xffffffff,%eax
  45:	74 39                	je     80 <main+0x80>
  {
    printf(2, "phmem: PID %d does not exist\n", pid);
    exit(0);
  }
 
  printf(1, "Physical memory occupied by PID %d: %d KiBytes\n", pid, physical_mem);
  47:	56                   	push   %esi
  48:	53                   	push   %ebx
  49:	68 94 03 00 00       	push   $0x394
  4e:	6a 01                	push   $0x1
  50:	e8 af 01 00 00       	call   204 <printf>
  printf(1, "Output: 24 KiB\n");
  55:	83 c4 08             	add    $0x8,%esp
  58:	68 82 03 00 00       	push   $0x382
  5d:	6a 01                	push   $0x1
  5f:	e8 a0 01 00 00       	call   204 <printf>

  exit(0);
  64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6b:	e8 39 00 00 00       	call   a9 <exit>
}
  70:	b8 00 00 00 00       	mov    $0x0,%eax
  75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  78:	59                   	pop    %ecx
  79:	5b                   	pop    %ebx
  7a:	5e                   	pop    %esi
  7b:	5d                   	pop    %ebp
  7c:	8d 61 fc             	lea    -0x4(%ecx),%esp
  7f:	c3                   	ret    
    printf(2, "phmem: PID %d does not exist\n", pid);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	53                   	push   %ebx
  84:	68 64 03 00 00       	push   $0x364
  89:	6a 02                	push   $0x2
  8b:	e8 74 01 00 00       	call   204 <printf>
    exit(0);
  90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  97:	e8 0d 00 00 00       	call   a9 <exit>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb a6                	jmp    47 <main+0x47>

000000a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  a1:	b8 01 00 00 00       	mov    $0x1,%eax
  a6:	cd 40                	int    $0x40
  a8:	c3                   	ret    

000000a9 <exit>:
SYSCALL(exit)
  a9:	b8 02 00 00 00       	mov    $0x2,%eax
  ae:	cd 40                	int    $0x40
  b0:	c3                   	ret    

000000b1 <wait>:
SYSCALL(wait)
  b1:	b8 03 00 00 00       	mov    $0x3,%eax
  b6:	cd 40                	int    $0x40
  b8:	c3                   	ret    

000000b9 <pipe>:
SYSCALL(pipe)
  b9:	b8 04 00 00 00       	mov    $0x4,%eax
  be:	cd 40                	int    $0x40
  c0:	c3                   	ret    

000000c1 <read>:
SYSCALL(read)
  c1:	b8 05 00 00 00       	mov    $0x5,%eax
  c6:	cd 40                	int    $0x40
  c8:	c3                   	ret    

000000c9 <write>:
SYSCALL(write)
  c9:	b8 10 00 00 00       	mov    $0x10,%eax
  ce:	cd 40                	int    $0x40
  d0:	c3                   	ret    

000000d1 <close>:
SYSCALL(close)
  d1:	b8 15 00 00 00       	mov    $0x15,%eax
  d6:	cd 40                	int    $0x40
  d8:	c3                   	ret    

000000d9 <kill>:
SYSCALL(kill)
  d9:	b8 06 00 00 00       	mov    $0x6,%eax
  de:	cd 40                	int    $0x40
  e0:	c3                   	ret    

000000e1 <exec>:
SYSCALL(exec)
  e1:	b8 07 00 00 00       	mov    $0x7,%eax
  e6:	cd 40                	int    $0x40
  e8:	c3                   	ret    

000000e9 <open>:
SYSCALL(open)
  e9:	b8 0f 00 00 00       	mov    $0xf,%eax
  ee:	cd 40                	int    $0x40
  f0:	c3                   	ret    

000000f1 <mknod>:
SYSCALL(mknod)
  f1:	b8 11 00 00 00       	mov    $0x11,%eax
  f6:	cd 40                	int    $0x40
  f8:	c3                   	ret    

000000f9 <unlink>:
SYSCALL(unlink)
  f9:	b8 12 00 00 00       	mov    $0x12,%eax
  fe:	cd 40                	int    $0x40
 100:	c3                   	ret    

00000101 <fstat>:
SYSCALL(fstat)
 101:	b8 08 00 00 00       	mov    $0x8,%eax
 106:	cd 40                	int    $0x40
 108:	c3                   	ret    

00000109 <link>:
SYSCALL(link)
 109:	b8 13 00 00 00       	mov    $0x13,%eax
 10e:	cd 40                	int    $0x40
 110:	c3                   	ret    

00000111 <mkdir>:
SYSCALL(mkdir)
 111:	b8 14 00 00 00       	mov    $0x14,%eax
 116:	cd 40                	int    $0x40
 118:	c3                   	ret    

00000119 <chdir>:
SYSCALL(chdir)
 119:	b8 09 00 00 00       	mov    $0x9,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret    

00000121 <dup>:
SYSCALL(dup)
 121:	b8 0a 00 00 00       	mov    $0xa,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret    

00000129 <getpid>:
SYSCALL(getpid)
 129:	b8 0b 00 00 00       	mov    $0xb,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret    

00000131 <sbrk>:
SYSCALL(sbrk)
 131:	b8 0c 00 00 00       	mov    $0xc,%eax
 136:	cd 40                	int    $0x40
 138:	c3                   	ret    

00000139 <sleep>:
SYSCALL(sleep)
 139:	b8 0d 00 00 00       	mov    $0xd,%eax
 13e:	cd 40                	int    $0x40
 140:	c3                   	ret    

00000141 <uptime>:
SYSCALL(uptime)
 141:	b8 0e 00 00 00       	mov    $0xe,%eax
 146:	cd 40                	int    $0x40
 148:	c3                   	ret    

00000149 <date>:
SYSCALL(date)
 149:	b8 16 00 00 00       	mov    $0x16,%eax
 14e:	cd 40                	int    $0x40
 150:	c3                   	ret    

00000151 <dup2>:
SYSCALL(dup2)
 151:	b8 17 00 00 00       	mov    $0x17,%eax
 156:	cd 40                	int    $0x40
 158:	c3                   	ret    

00000159 <phmem>:
SYSCALL(phmem)
 159:	b8 18 00 00 00       	mov    $0x18,%eax
 15e:	cd 40                	int    $0x40
 160:	c3                   	ret    

00000161 <getprio>:
SYSCALL(getprio)
 161:	b8 19 00 00 00       	mov    $0x19,%eax
 166:	cd 40                	int    $0x40
 168:	c3                   	ret    

00000169 <setprio>:
SYSCALL(setprio)
 169:	b8 1a 00 00 00       	mov    $0x1a,%eax
 16e:	cd 40                	int    $0x40
 170:	c3                   	ret    

00000171 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	83 ec 1c             	sub    $0x1c,%esp
 177:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 17a:	6a 01                	push   $0x1
 17c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 17f:	52                   	push   %edx
 180:	50                   	push   %eax
 181:	e8 43 ff ff ff       	call   c9 <write>
}
 186:	83 c4 10             	add    $0x10,%esp
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	57                   	push   %edi
 18f:	56                   	push   %esi
 190:	53                   	push   %ebx
 191:	83 ec 2c             	sub    $0x2c,%esp
 194:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 197:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 19d:	74 04                	je     1a3 <printint+0x18>
 19f:	85 d2                	test   %edx,%edx
 1a1:	78 3c                	js     1df <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 1a3:	89 d1                	mov    %edx,%ecx
  neg = 0;
 1a5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 1ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1b1:	89 c8                	mov    %ecx,%eax
 1b3:	ba 00 00 00 00       	mov    $0x0,%edx
 1b8:	f7 f6                	div    %esi
 1ba:	89 df                	mov    %ebx,%edi
 1bc:	43                   	inc    %ebx
 1bd:	8a 92 24 04 00 00    	mov    0x424(%edx),%dl
 1c3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1c7:	89 ca                	mov    %ecx,%edx
 1c9:	89 c1                	mov    %eax,%ecx
 1cb:	39 d6                	cmp    %edx,%esi
 1cd:	76 e2                	jbe    1b1 <printint+0x26>
  if(neg)
 1cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1d3:	74 24                	je     1f9 <printint+0x6e>
    buf[i++] = '-';
 1d5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1da:	8d 5f 02             	lea    0x2(%edi),%ebx
 1dd:	eb 1a                	jmp    1f9 <printint+0x6e>
    x = -xx;
 1df:	89 d1                	mov    %edx,%ecx
 1e1:	f7 d9                	neg    %ecx
    neg = 1;
 1e3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1ea:	eb c0                	jmp    1ac <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1ec:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1f4:	e8 78 ff ff ff       	call   171 <putc>
  while(--i >= 0)
 1f9:	4b                   	dec    %ebx
 1fa:	79 f0                	jns    1ec <printint+0x61>
}
 1fc:	83 c4 2c             	add    $0x2c,%esp
 1ff:	5b                   	pop    %ebx
 200:	5e                   	pop    %esi
 201:	5f                   	pop    %edi
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    

00000204 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	56                   	push   %esi
 209:	53                   	push   %ebx
 20a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 20d:	8d 45 10             	lea    0x10(%ebp),%eax
 210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 213:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 218:	bb 00 00 00 00       	mov    $0x0,%ebx
 21d:	eb 12                	jmp    231 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 21f:	89 fa                	mov    %edi,%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	e8 48 ff ff ff       	call   171 <putc>
 229:	eb 05                	jmp    230 <printf+0x2c>
      }
    } else if(state == '%'){
 22b:	83 fe 25             	cmp    $0x25,%esi
 22e:	74 22                	je     252 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 230:	43                   	inc    %ebx
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	8a 04 18             	mov    (%eax,%ebx,1),%al
 237:	84 c0                	test   %al,%al
 239:	0f 84 1d 01 00 00    	je     35c <printf+0x158>
    c = fmt[i] & 0xff;
 23f:	0f be f8             	movsbl %al,%edi
 242:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 245:	85 f6                	test   %esi,%esi
 247:	75 e2                	jne    22b <printf+0x27>
      if(c == '%'){
 249:	83 f8 25             	cmp    $0x25,%eax
 24c:	75 d1                	jne    21f <printf+0x1b>
        state = '%';
 24e:	89 c6                	mov    %eax,%esi
 250:	eb de                	jmp    230 <printf+0x2c>
      if(c == 'd'){
 252:	83 f8 25             	cmp    $0x25,%eax
 255:	0f 84 cc 00 00 00    	je     327 <printf+0x123>
 25b:	0f 8c da 00 00 00    	jl     33b <printf+0x137>
 261:	83 f8 78             	cmp    $0x78,%eax
 264:	0f 8f d1 00 00 00    	jg     33b <printf+0x137>
 26a:	83 f8 63             	cmp    $0x63,%eax
 26d:	0f 8c c8 00 00 00    	jl     33b <printf+0x137>
 273:	83 e8 63             	sub    $0x63,%eax
 276:	83 f8 15             	cmp    $0x15,%eax
 279:	0f 87 bc 00 00 00    	ja     33b <printf+0x137>
 27f:	ff 24 85 cc 03 00 00 	jmp    *0x3cc(,%eax,4)
        printint(fd, *ap, 10, 1);
 286:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 289:	8b 17                	mov    (%edi),%edx
 28b:	83 ec 0c             	sub    $0xc,%esp
 28e:	6a 01                	push   $0x1
 290:	b9 0a 00 00 00       	mov    $0xa,%ecx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	e8 ee fe ff ff       	call   18b <printint>
        ap++;
 29d:	83 c7 04             	add    $0x4,%edi
 2a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2a3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 2a6:	be 00 00 00 00       	mov    $0x0,%esi
 2ab:	eb 83                	jmp    230 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 2ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2b0:	8b 17                	mov    (%edi),%edx
 2b2:	83 ec 0c             	sub    $0xc,%esp
 2b5:	6a 00                	push   $0x0
 2b7:	b9 10 00 00 00       	mov    $0x10,%ecx
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	e8 c7 fe ff ff       	call   18b <printint>
        ap++;
 2c4:	83 c7 04             	add    $0x4,%edi
 2c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2cd:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2d2:	e9 59 ff ff ff       	jmp    230 <printf+0x2c>
        s = (char*)*ap;
 2d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2da:	8b 30                	mov    (%eax),%esi
        ap++;
 2dc:	83 c0 04             	add    $0x4,%eax
 2df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2e2:	85 f6                	test   %esi,%esi
 2e4:	75 13                	jne    2f9 <printf+0xf5>
          s = "(null)";
 2e6:	be c4 03 00 00       	mov    $0x3c4,%esi
 2eb:	eb 0c                	jmp    2f9 <printf+0xf5>
          putc(fd, *s);
 2ed:	0f be d2             	movsbl %dl,%edx
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	e8 79 fe ff ff       	call   171 <putc>
          s++;
 2f8:	46                   	inc    %esi
        while(*s != 0){
 2f9:	8a 16                	mov    (%esi),%dl
 2fb:	84 d2                	test   %dl,%dl
 2fd:	75 ee                	jne    2ed <printf+0xe9>
      state = 0;
 2ff:	be 00 00 00 00       	mov    $0x0,%esi
 304:	e9 27 ff ff ff       	jmp    230 <printf+0x2c>
        putc(fd, *ap);
 309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 30c:	0f be 17             	movsbl (%edi),%edx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	e8 5a fe ff ff       	call   171 <putc>
        ap++;
 317:	83 c7 04             	add    $0x4,%edi
 31a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 31d:	be 00 00 00 00       	mov    $0x0,%esi
 322:	e9 09 ff ff ff       	jmp    230 <printf+0x2c>
        putc(fd, c);
 327:	89 fa                	mov    %edi,%edx
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	e8 40 fe ff ff       	call   171 <putc>
      state = 0;
 331:	be 00 00 00 00       	mov    $0x0,%esi
 336:	e9 f5 fe ff ff       	jmp    230 <printf+0x2c>
        putc(fd, '%');
 33b:	ba 25 00 00 00       	mov    $0x25,%edx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	e8 29 fe ff ff       	call   171 <putc>
        putc(fd, c);
 348:	89 fa                	mov    %edi,%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	e8 1f fe ff ff       	call   171 <putc>
      state = 0;
 352:	be 00 00 00 00       	mov    $0x0,%esi
 357:	e9 d4 fe ff ff       	jmp    230 <printf+0x2c>
    }
  }
}
 35c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35f:	5b                   	pop    %ebx
 360:	5e                   	pop    %esi
 361:	5f                   	pop    %edi
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
