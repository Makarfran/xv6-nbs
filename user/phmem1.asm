
phmem1:     formato del fichero elf32-i386


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
  10:	83 ec 0c             	sub    $0xc,%esp
  int pid, physical_mem;

  array[0] = 'A';
  13:	c6 05 00 05 00 00 41 	movb   $0x41,0x500

  pid = getpid();
  1a:	e8 f7 00 00 00       	call   116 <getpid>
  1f:	89 c3                	mov    %eax,%ebx

  physical_mem = phmem(pid);
  21:	83 ec 0c             	sub    $0xc,%esp
  24:	50                   	push   %eax
  25:	e8 1c 01 00 00       	call   146 <phmem>
  2a:	89 c6                	mov    %eax,%esi

  if (physical_mem == -1)
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	83 f8 ff             	cmp    $0xffffffff,%eax
  32:	74 39                	je     6d <main+0x6d>
  {
    printf(2, "phmem: PID %d does not exist\n", pid);
    exit(0);
  }
  
  printf(1, "Physical memory occupied by PID %d: %d KiBytes\n", pid, physical_mem);
  34:	56                   	push   %esi
  35:	53                   	push   %ebx
  36:	68 84 03 00 00       	push   $0x384
  3b:	6a 01                	push   $0x1
  3d:	e8 af 01 00 00       	call   1f1 <printf>
  printf(1, "Output: 16 KiB\n");
  42:	83 c4 08             	add    $0x8,%esp
  45:	68 72 03 00 00       	push   $0x372
  4a:	6a 01                	push   $0x1
  4c:	e8 a0 01 00 00       	call   1f1 <printf>

  exit(0);
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 39 00 00 00       	call   96 <exit>
}
  5d:	b8 00 00 00 00       	mov    $0x0,%eax
  62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  65:	59                   	pop    %ecx
  66:	5b                   	pop    %ebx
  67:	5e                   	pop    %esi
  68:	5d                   	pop    %ebp
  69:	8d 61 fc             	lea    -0x4(%ecx),%esp
  6c:	c3                   	ret    
    printf(2, "phmem: PID %d does not exist\n", pid);
  6d:	83 ec 04             	sub    $0x4,%esp
  70:	53                   	push   %ebx
  71:	68 54 03 00 00       	push   $0x354
  76:	6a 02                	push   $0x2
  78:	e8 74 01 00 00       	call   1f1 <printf>
    exit(0);
  7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  84:	e8 0d 00 00 00       	call   96 <exit>
  89:	83 c4 10             	add    $0x10,%esp
  8c:	eb a6                	jmp    34 <main+0x34>

0000008e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  8e:	b8 01 00 00 00       	mov    $0x1,%eax
  93:	cd 40                	int    $0x40
  95:	c3                   	ret    

00000096 <exit>:
SYSCALL(exit)
  96:	b8 02 00 00 00       	mov    $0x2,%eax
  9b:	cd 40                	int    $0x40
  9d:	c3                   	ret    

0000009e <wait>:
SYSCALL(wait)
  9e:	b8 03 00 00 00       	mov    $0x3,%eax
  a3:	cd 40                	int    $0x40
  a5:	c3                   	ret    

000000a6 <pipe>:
SYSCALL(pipe)
  a6:	b8 04 00 00 00       	mov    $0x4,%eax
  ab:	cd 40                	int    $0x40
  ad:	c3                   	ret    

000000ae <read>:
SYSCALL(read)
  ae:	b8 05 00 00 00       	mov    $0x5,%eax
  b3:	cd 40                	int    $0x40
  b5:	c3                   	ret    

000000b6 <write>:
SYSCALL(write)
  b6:	b8 10 00 00 00       	mov    $0x10,%eax
  bb:	cd 40                	int    $0x40
  bd:	c3                   	ret    

000000be <close>:
SYSCALL(close)
  be:	b8 15 00 00 00       	mov    $0x15,%eax
  c3:	cd 40                	int    $0x40
  c5:	c3                   	ret    

000000c6 <kill>:
SYSCALL(kill)
  c6:	b8 06 00 00 00       	mov    $0x6,%eax
  cb:	cd 40                	int    $0x40
  cd:	c3                   	ret    

000000ce <exec>:
SYSCALL(exec)
  ce:	b8 07 00 00 00       	mov    $0x7,%eax
  d3:	cd 40                	int    $0x40
  d5:	c3                   	ret    

000000d6 <open>:
SYSCALL(open)
  d6:	b8 0f 00 00 00       	mov    $0xf,%eax
  db:	cd 40                	int    $0x40
  dd:	c3                   	ret    

000000de <mknod>:
SYSCALL(mknod)
  de:	b8 11 00 00 00       	mov    $0x11,%eax
  e3:	cd 40                	int    $0x40
  e5:	c3                   	ret    

000000e6 <unlink>:
SYSCALL(unlink)
  e6:	b8 12 00 00 00       	mov    $0x12,%eax
  eb:	cd 40                	int    $0x40
  ed:	c3                   	ret    

000000ee <fstat>:
SYSCALL(fstat)
  ee:	b8 08 00 00 00       	mov    $0x8,%eax
  f3:	cd 40                	int    $0x40
  f5:	c3                   	ret    

000000f6 <link>:
SYSCALL(link)
  f6:	b8 13 00 00 00       	mov    $0x13,%eax
  fb:	cd 40                	int    $0x40
  fd:	c3                   	ret    

000000fe <mkdir>:
SYSCALL(mkdir)
  fe:	b8 14 00 00 00       	mov    $0x14,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <chdir>:
SYSCALL(chdir)
 106:	b8 09 00 00 00       	mov    $0x9,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <dup>:
SYSCALL(dup)
 10e:	b8 0a 00 00 00       	mov    $0xa,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <getpid>:
SYSCALL(getpid)
 116:	b8 0b 00 00 00       	mov    $0xb,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    

0000011e <sbrk>:
SYSCALL(sbrk)
 11e:	b8 0c 00 00 00       	mov    $0xc,%eax
 123:	cd 40                	int    $0x40
 125:	c3                   	ret    

00000126 <sleep>:
SYSCALL(sleep)
 126:	b8 0d 00 00 00       	mov    $0xd,%eax
 12b:	cd 40                	int    $0x40
 12d:	c3                   	ret    

0000012e <uptime>:
SYSCALL(uptime)
 12e:	b8 0e 00 00 00       	mov    $0xe,%eax
 133:	cd 40                	int    $0x40
 135:	c3                   	ret    

00000136 <date>:
SYSCALL(date)
 136:	b8 16 00 00 00       	mov    $0x16,%eax
 13b:	cd 40                	int    $0x40
 13d:	c3                   	ret    

0000013e <dup2>:
SYSCALL(dup2)
 13e:	b8 17 00 00 00       	mov    $0x17,%eax
 143:	cd 40                	int    $0x40
 145:	c3                   	ret    

00000146 <phmem>:
SYSCALL(phmem)
 146:	b8 18 00 00 00       	mov    $0x18,%eax
 14b:	cd 40                	int    $0x40
 14d:	c3                   	ret    

0000014e <getprio>:
SYSCALL(getprio)
 14e:	b8 19 00 00 00       	mov    $0x19,%eax
 153:	cd 40                	int    $0x40
 155:	c3                   	ret    

00000156 <setprio>:
SYSCALL(setprio)
 156:	b8 1a 00 00 00       	mov    $0x1a,%eax
 15b:	cd 40                	int    $0x40
 15d:	c3                   	ret    

0000015e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 1c             	sub    $0x1c,%esp
 164:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 167:	6a 01                	push   $0x1
 169:	8d 55 f4             	lea    -0xc(%ebp),%edx
 16c:	52                   	push   %edx
 16d:	50                   	push   %eax
 16e:	e8 43 ff ff ff       	call   b6 <write>
}
 173:	83 c4 10             	add    $0x10,%esp
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	57                   	push   %edi
 17c:	56                   	push   %esi
 17d:	53                   	push   %ebx
 17e:	83 ec 2c             	sub    $0x2c,%esp
 181:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 184:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 18a:	74 04                	je     190 <printint+0x18>
 18c:	85 d2                	test   %edx,%edx
 18e:	78 3c                	js     1cc <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 190:	89 d1                	mov    %edx,%ecx
  neg = 0;
 192:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 199:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 19e:	89 c8                	mov    %ecx,%eax
 1a0:	ba 00 00 00 00       	mov    $0x0,%edx
 1a5:	f7 f6                	div    %esi
 1a7:	89 df                	mov    %ebx,%edi
 1a9:	43                   	inc    %ebx
 1aa:	8a 92 14 04 00 00    	mov    0x414(%edx),%dl
 1b0:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1b4:	89 ca                	mov    %ecx,%edx
 1b6:	89 c1                	mov    %eax,%ecx
 1b8:	39 d6                	cmp    %edx,%esi
 1ba:	76 e2                	jbe    19e <printint+0x26>
  if(neg)
 1bc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1c0:	74 24                	je     1e6 <printint+0x6e>
    buf[i++] = '-';
 1c2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1c7:	8d 5f 02             	lea    0x2(%edi),%ebx
 1ca:	eb 1a                	jmp    1e6 <printint+0x6e>
    x = -xx;
 1cc:	89 d1                	mov    %edx,%ecx
 1ce:	f7 d9                	neg    %ecx
    neg = 1;
 1d0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1d7:	eb c0                	jmp    199 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1d9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1e1:	e8 78 ff ff ff       	call   15e <putc>
  while(--i >= 0)
 1e6:	4b                   	dec    %ebx
 1e7:	79 f0                	jns    1d9 <printint+0x61>
}
 1e9:	83 c4 2c             	add    $0x2c,%esp
 1ec:	5b                   	pop    %ebx
 1ed:	5e                   	pop    %esi
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	57                   	push   %edi
 1f5:	56                   	push   %esi
 1f6:	53                   	push   %ebx
 1f7:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1fa:	8d 45 10             	lea    0x10(%ebp),%eax
 1fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 200:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 205:	bb 00 00 00 00       	mov    $0x0,%ebx
 20a:	eb 12                	jmp    21e <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 20c:	89 fa                	mov    %edi,%edx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	e8 48 ff ff ff       	call   15e <putc>
 216:	eb 05                	jmp    21d <printf+0x2c>
      }
    } else if(state == '%'){
 218:	83 fe 25             	cmp    $0x25,%esi
 21b:	74 22                	je     23f <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 21d:	43                   	inc    %ebx
 21e:	8b 45 0c             	mov    0xc(%ebp),%eax
 221:	8a 04 18             	mov    (%eax,%ebx,1),%al
 224:	84 c0                	test   %al,%al
 226:	0f 84 1d 01 00 00    	je     349 <printf+0x158>
    c = fmt[i] & 0xff;
 22c:	0f be f8             	movsbl %al,%edi
 22f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 232:	85 f6                	test   %esi,%esi
 234:	75 e2                	jne    218 <printf+0x27>
      if(c == '%'){
 236:	83 f8 25             	cmp    $0x25,%eax
 239:	75 d1                	jne    20c <printf+0x1b>
        state = '%';
 23b:	89 c6                	mov    %eax,%esi
 23d:	eb de                	jmp    21d <printf+0x2c>
      if(c == 'd'){
 23f:	83 f8 25             	cmp    $0x25,%eax
 242:	0f 84 cc 00 00 00    	je     314 <printf+0x123>
 248:	0f 8c da 00 00 00    	jl     328 <printf+0x137>
 24e:	83 f8 78             	cmp    $0x78,%eax
 251:	0f 8f d1 00 00 00    	jg     328 <printf+0x137>
 257:	83 f8 63             	cmp    $0x63,%eax
 25a:	0f 8c c8 00 00 00    	jl     328 <printf+0x137>
 260:	83 e8 63             	sub    $0x63,%eax
 263:	83 f8 15             	cmp    $0x15,%eax
 266:	0f 87 bc 00 00 00    	ja     328 <printf+0x137>
 26c:	ff 24 85 bc 03 00 00 	jmp    *0x3bc(,%eax,4)
        printint(fd, *ap, 10, 1);
 273:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 276:	8b 17                	mov    (%edi),%edx
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	6a 01                	push   $0x1
 27d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	e8 ee fe ff ff       	call   178 <printint>
        ap++;
 28a:	83 c7 04             	add    $0x4,%edi
 28d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 290:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 293:	be 00 00 00 00       	mov    $0x0,%esi
 298:	eb 83                	jmp    21d <printf+0x2c>
        printint(fd, *ap, 16, 0);
 29a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29d:	8b 17                	mov    (%edi),%edx
 29f:	83 ec 0c             	sub    $0xc,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	b9 10 00 00 00       	mov    $0x10,%ecx
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	e8 c7 fe ff ff       	call   178 <printint>
        ap++;
 2b1:	83 c7 04             	add    $0x4,%edi
 2b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2b7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ba:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2bf:	e9 59 ff ff ff       	jmp    21d <printf+0x2c>
        s = (char*)*ap;
 2c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c7:	8b 30                	mov    (%eax),%esi
        ap++;
 2c9:	83 c0 04             	add    $0x4,%eax
 2cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2cf:	85 f6                	test   %esi,%esi
 2d1:	75 13                	jne    2e6 <printf+0xf5>
          s = "(null)";
 2d3:	be b4 03 00 00       	mov    $0x3b4,%esi
 2d8:	eb 0c                	jmp    2e6 <printf+0xf5>
          putc(fd, *s);
 2da:	0f be d2             	movsbl %dl,%edx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	e8 79 fe ff ff       	call   15e <putc>
          s++;
 2e5:	46                   	inc    %esi
        while(*s != 0){
 2e6:	8a 16                	mov    (%esi),%dl
 2e8:	84 d2                	test   %dl,%dl
 2ea:	75 ee                	jne    2da <printf+0xe9>
      state = 0;
 2ec:	be 00 00 00 00       	mov    $0x0,%esi
 2f1:	e9 27 ff ff ff       	jmp    21d <printf+0x2c>
        putc(fd, *ap);
 2f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f9:	0f be 17             	movsbl (%edi),%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	e8 5a fe ff ff       	call   15e <putc>
        ap++;
 304:	83 c7 04             	add    $0x4,%edi
 307:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 30a:	be 00 00 00 00       	mov    $0x0,%esi
 30f:	e9 09 ff ff ff       	jmp    21d <printf+0x2c>
        putc(fd, c);
 314:	89 fa                	mov    %edi,%edx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	e8 40 fe ff ff       	call   15e <putc>
      state = 0;
 31e:	be 00 00 00 00       	mov    $0x0,%esi
 323:	e9 f5 fe ff ff       	jmp    21d <printf+0x2c>
        putc(fd, '%');
 328:	ba 25 00 00 00       	mov    $0x25,%edx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	e8 29 fe ff ff       	call   15e <putc>
        putc(fd, c);
 335:	89 fa                	mov    %edi,%edx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	e8 1f fe ff ff       	call   15e <putc>
      state = 0;
 33f:	be 00 00 00 00       	mov    $0x0,%esi
 344:	e9 d4 fe ff ff       	jmp    21d <printf+0x2c>
    }
  }
}
 349:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34c:	5b                   	pop    %ebx
 34d:	5e                   	pop    %esi
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
