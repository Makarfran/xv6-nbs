
sbrk1:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
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
  10:	83 ec 18             	sub    $0x18,%esp
  char* a = sbrk(15000);
  13:	68 98 3a 00 00       	push   $0x3a98
  18:	e8 76 01 00 00       	call   193 <sbrk>
  1d:	89 c3                	mov    %eax,%ebx

  a[500] = 1;
  1f:	c6 80 f4 01 00 00 01 	movb   $0x1,0x1f4(%eax)

  
  

  if ((uint)a + 15000 != (uint) sbrk(-15000))
  26:	8d b0 98 3a 00 00    	lea    0x3a98(%eax),%esi
  2c:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  33:	e8 5b 01 00 00       	call   193 <sbrk>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 c6                	cmp    %eax,%esi
  3d:	0f 85 9d 00 00 00    	jne    e0 <main+0xe0>
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
    exit(1);
  }
  
  
  if (a != sbrk(0))
  43:	83 ec 0c             	sub    $0xc,%esp
  46:	6a 00                	push   $0x0
  48:	e8 46 01 00 00       	call   193 <sbrk>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	39 c3                	cmp    %eax,%ebx
  52:	74 1e                	je     72 <main+0x72>
  {
    printf (1, "sbrk() con cero fallÃ³.\n");
  54:	83 ec 08             	sub    $0x8,%esp
  57:	68 f1 03 00 00       	push   $0x3f1
  5c:	6a 01                	push   $0x1
  5e:	e8 03 02 00 00       	call   266 <printf>
    exit(2);
  63:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6a:	e8 9c 00 00 00       	call   10b <exit>
  6f:	83 c4 10             	add    $0x10,%esp
  } 
  

  if (a != sbrk(15000))
  72:	83 ec 0c             	sub    $0xc,%esp
  75:	68 98 3a 00 00       	push   $0x3a98
  7a:	e8 14 01 00 00       	call   193 <sbrk>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	39 c3                	cmp    %eax,%ebx
  84:	74 1e                	je     a4 <main+0xa4>
  {
    printf (1, "sbrk() negativo fallÃ³.\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 0c 04 00 00       	push   $0x40c
  8e:	6a 01                	push   $0x1
  90:	e8 d1 01 00 00       	call   266 <printf>
    exit(3);
  95:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  9c:	e8 6a 00 00 00       	call   10b <exit>
  a1:	83 c4 10             	add    $0x10,%esp
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]); 
  a4:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  aa:	40                   	inc    %eax
  ab:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  b1:	83 ec 04             	sub    $0x4,%esp
  b4:	0f be c0             	movsbl %al,%eax
  b7:	50                   	push   %eax
  b8:	68 27 04 00 00       	push   $0x427
  bd:	6a 01                	push   $0x1
  bf:	e8 a2 01 00 00       	call   266 <printf>

  exit(0);
  c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  cb:	e8 3b 00 00 00       	call   10b <exit>
}
  d0:	b8 00 00 00 00       	mov    $0x0,%eax
  d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  d8:	59                   	pop    %ecx
  d9:	5b                   	pop    %ebx
  da:	5e                   	pop    %esi
  db:	5d                   	pop    %ebp
  dc:	8d 61 fc             	lea    -0x4(%ecx),%esp
  df:	c3                   	ret    
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	68 c8 03 00 00       	push   $0x3c8
  e8:	6a 01                	push   $0x1
  ea:	e8 77 01 00 00       	call   266 <printf>
    exit(1);
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 10 00 00 00       	call   10b <exit>
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	e9 40 ff ff ff       	jmp    43 <main+0x43>

00000103 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 103:	b8 01 00 00 00       	mov    $0x1,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret    

0000010b <exit>:
SYSCALL(exit)
 10b:	b8 02 00 00 00       	mov    $0x2,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret    

00000113 <wait>:
SYSCALL(wait)
 113:	b8 03 00 00 00       	mov    $0x3,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret    

0000011b <pipe>:
SYSCALL(pipe)
 11b:	b8 04 00 00 00       	mov    $0x4,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret    

00000123 <read>:
SYSCALL(read)
 123:	b8 05 00 00 00       	mov    $0x5,%eax
 128:	cd 40                	int    $0x40
 12a:	c3                   	ret    

0000012b <write>:
SYSCALL(write)
 12b:	b8 10 00 00 00       	mov    $0x10,%eax
 130:	cd 40                	int    $0x40
 132:	c3                   	ret    

00000133 <close>:
SYSCALL(close)
 133:	b8 15 00 00 00       	mov    $0x15,%eax
 138:	cd 40                	int    $0x40
 13a:	c3                   	ret    

0000013b <kill>:
SYSCALL(kill)
 13b:	b8 06 00 00 00       	mov    $0x6,%eax
 140:	cd 40                	int    $0x40
 142:	c3                   	ret    

00000143 <exec>:
SYSCALL(exec)
 143:	b8 07 00 00 00       	mov    $0x7,%eax
 148:	cd 40                	int    $0x40
 14a:	c3                   	ret    

0000014b <open>:
SYSCALL(open)
 14b:	b8 0f 00 00 00       	mov    $0xf,%eax
 150:	cd 40                	int    $0x40
 152:	c3                   	ret    

00000153 <mknod>:
SYSCALL(mknod)
 153:	b8 11 00 00 00       	mov    $0x11,%eax
 158:	cd 40                	int    $0x40
 15a:	c3                   	ret    

0000015b <unlink>:
SYSCALL(unlink)
 15b:	b8 12 00 00 00       	mov    $0x12,%eax
 160:	cd 40                	int    $0x40
 162:	c3                   	ret    

00000163 <fstat>:
SYSCALL(fstat)
 163:	b8 08 00 00 00       	mov    $0x8,%eax
 168:	cd 40                	int    $0x40
 16a:	c3                   	ret    

0000016b <link>:
SYSCALL(link)
 16b:	b8 13 00 00 00       	mov    $0x13,%eax
 170:	cd 40                	int    $0x40
 172:	c3                   	ret    

00000173 <mkdir>:
SYSCALL(mkdir)
 173:	b8 14 00 00 00       	mov    $0x14,%eax
 178:	cd 40                	int    $0x40
 17a:	c3                   	ret    

0000017b <chdir>:
SYSCALL(chdir)
 17b:	b8 09 00 00 00       	mov    $0x9,%eax
 180:	cd 40                	int    $0x40
 182:	c3                   	ret    

00000183 <dup>:
SYSCALL(dup)
 183:	b8 0a 00 00 00       	mov    $0xa,%eax
 188:	cd 40                	int    $0x40
 18a:	c3                   	ret    

0000018b <getpid>:
SYSCALL(getpid)
 18b:	b8 0b 00 00 00       	mov    $0xb,%eax
 190:	cd 40                	int    $0x40
 192:	c3                   	ret    

00000193 <sbrk>:
SYSCALL(sbrk)
 193:	b8 0c 00 00 00       	mov    $0xc,%eax
 198:	cd 40                	int    $0x40
 19a:	c3                   	ret    

0000019b <sleep>:
SYSCALL(sleep)
 19b:	b8 0d 00 00 00       	mov    $0xd,%eax
 1a0:	cd 40                	int    $0x40
 1a2:	c3                   	ret    

000001a3 <uptime>:
SYSCALL(uptime)
 1a3:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a8:	cd 40                	int    $0x40
 1aa:	c3                   	ret    

000001ab <date>:
SYSCALL(date)
 1ab:	b8 16 00 00 00       	mov    $0x16,%eax
 1b0:	cd 40                	int    $0x40
 1b2:	c3                   	ret    

000001b3 <dup2>:
SYSCALL(dup2)
 1b3:	b8 17 00 00 00       	mov    $0x17,%eax
 1b8:	cd 40                	int    $0x40
 1ba:	c3                   	ret    

000001bb <phmem>:
SYSCALL(phmem)
 1bb:	b8 18 00 00 00       	mov    $0x18,%eax
 1c0:	cd 40                	int    $0x40
 1c2:	c3                   	ret    

000001c3 <getprio>:
SYSCALL(getprio)
 1c3:	b8 19 00 00 00       	mov    $0x19,%eax
 1c8:	cd 40                	int    $0x40
 1ca:	c3                   	ret    

000001cb <setprio>:
SYSCALL(setprio)
 1cb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 1d0:	cd 40                	int    $0x40
 1d2:	c3                   	ret    

000001d3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1d3:	55                   	push   %ebp
 1d4:	89 e5                	mov    %esp,%ebp
 1d6:	83 ec 1c             	sub    $0x1c,%esp
 1d9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1dc:	6a 01                	push   $0x1
 1de:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1e1:	52                   	push   %edx
 1e2:	50                   	push   %eax
 1e3:	e8 43 ff ff ff       	call   12b <write>
}
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	57                   	push   %edi
 1f1:	56                   	push   %esi
 1f2:	53                   	push   %ebx
 1f3:	83 ec 2c             	sub    $0x2c,%esp
 1f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1f9:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1ff:	74 04                	je     205 <printint+0x18>
 201:	85 d2                	test   %edx,%edx
 203:	78 3c                	js     241 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 205:	89 d1                	mov    %edx,%ecx
  neg = 0;
 207:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 20e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 213:	89 c8                	mov    %ecx,%eax
 215:	ba 00 00 00 00       	mov    $0x0,%edx
 21a:	f7 f6                	div    %esi
 21c:	89 df                	mov    %ebx,%edi
 21e:	43                   	inc    %ebx
 21f:	8a 92 9c 04 00 00    	mov    0x49c(%edx),%dl
 225:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 229:	89 ca                	mov    %ecx,%edx
 22b:	89 c1                	mov    %eax,%ecx
 22d:	39 d6                	cmp    %edx,%esi
 22f:	76 e2                	jbe    213 <printint+0x26>
  if(neg)
 231:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 235:	74 24                	je     25b <printint+0x6e>
    buf[i++] = '-';
 237:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 23c:	8d 5f 02             	lea    0x2(%edi),%ebx
 23f:	eb 1a                	jmp    25b <printint+0x6e>
    x = -xx;
 241:	89 d1                	mov    %edx,%ecx
 243:	f7 d9                	neg    %ecx
    neg = 1;
 245:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 24c:	eb c0                	jmp    20e <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 24e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 256:	e8 78 ff ff ff       	call   1d3 <putc>
  while(--i >= 0)
 25b:	4b                   	dec    %ebx
 25c:	79 f0                	jns    24e <printint+0x61>
}
 25e:	83 c4 2c             	add    $0x2c,%esp
 261:	5b                   	pop    %ebx
 262:	5e                   	pop    %esi
 263:	5f                   	pop    %edi
 264:	5d                   	pop    %ebp
 265:	c3                   	ret    

00000266 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	57                   	push   %edi
 26a:	56                   	push   %esi
 26b:	53                   	push   %ebx
 26c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 26f:	8d 45 10             	lea    0x10(%ebp),%eax
 272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 275:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 27a:	bb 00 00 00 00       	mov    $0x0,%ebx
 27f:	eb 12                	jmp    293 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 281:	89 fa                	mov    %edi,%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	e8 48 ff ff ff       	call   1d3 <putc>
 28b:	eb 05                	jmp    292 <printf+0x2c>
      }
    } else if(state == '%'){
 28d:	83 fe 25             	cmp    $0x25,%esi
 290:	74 22                	je     2b4 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 292:	43                   	inc    %ebx
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	8a 04 18             	mov    (%eax,%ebx,1),%al
 299:	84 c0                	test   %al,%al
 29b:	0f 84 1d 01 00 00    	je     3be <printf+0x158>
    c = fmt[i] & 0xff;
 2a1:	0f be f8             	movsbl %al,%edi
 2a4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2a7:	85 f6                	test   %esi,%esi
 2a9:	75 e2                	jne    28d <printf+0x27>
      if(c == '%'){
 2ab:	83 f8 25             	cmp    $0x25,%eax
 2ae:	75 d1                	jne    281 <printf+0x1b>
        state = '%';
 2b0:	89 c6                	mov    %eax,%esi
 2b2:	eb de                	jmp    292 <printf+0x2c>
      if(c == 'd'){
 2b4:	83 f8 25             	cmp    $0x25,%eax
 2b7:	0f 84 cc 00 00 00    	je     389 <printf+0x123>
 2bd:	0f 8c da 00 00 00    	jl     39d <printf+0x137>
 2c3:	83 f8 78             	cmp    $0x78,%eax
 2c6:	0f 8f d1 00 00 00    	jg     39d <printf+0x137>
 2cc:	83 f8 63             	cmp    $0x63,%eax
 2cf:	0f 8c c8 00 00 00    	jl     39d <printf+0x137>
 2d5:	83 e8 63             	sub    $0x63,%eax
 2d8:	83 f8 15             	cmp    $0x15,%eax
 2db:	0f 87 bc 00 00 00    	ja     39d <printf+0x137>
 2e1:	ff 24 85 44 04 00 00 	jmp    *0x444(,%eax,4)
        printint(fd, *ap, 10, 1);
 2e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2eb:	8b 17                	mov    (%edi),%edx
 2ed:	83 ec 0c             	sub    $0xc,%esp
 2f0:	6a 01                	push   $0x1
 2f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	e8 ee fe ff ff       	call   1ed <printint>
        ap++;
 2ff:	83 c7 04             	add    $0x4,%edi
 302:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 305:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 308:	be 00 00 00 00       	mov    $0x0,%esi
 30d:	eb 83                	jmp    292 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 30f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 312:	8b 17                	mov    (%edi),%edx
 314:	83 ec 0c             	sub    $0xc,%esp
 317:	6a 00                	push   $0x0
 319:	b9 10 00 00 00       	mov    $0x10,%ecx
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	e8 c7 fe ff ff       	call   1ed <printint>
        ap++;
 326:	83 c7 04             	add    $0x4,%edi
 329:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 32c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 32f:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 334:	e9 59 ff ff ff       	jmp    292 <printf+0x2c>
        s = (char*)*ap;
 339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 33c:	8b 30                	mov    (%eax),%esi
        ap++;
 33e:	83 c0 04             	add    $0x4,%eax
 341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 344:	85 f6                	test   %esi,%esi
 346:	75 13                	jne    35b <printf+0xf5>
          s = "(null)";
 348:	be 3d 04 00 00       	mov    $0x43d,%esi
 34d:	eb 0c                	jmp    35b <printf+0xf5>
          putc(fd, *s);
 34f:	0f be d2             	movsbl %dl,%edx
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	e8 79 fe ff ff       	call   1d3 <putc>
          s++;
 35a:	46                   	inc    %esi
        while(*s != 0){
 35b:	8a 16                	mov    (%esi),%dl
 35d:	84 d2                	test   %dl,%dl
 35f:	75 ee                	jne    34f <printf+0xe9>
      state = 0;
 361:	be 00 00 00 00       	mov    $0x0,%esi
 366:	e9 27 ff ff ff       	jmp    292 <printf+0x2c>
        putc(fd, *ap);
 36b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 36e:	0f be 17             	movsbl (%edi),%edx
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	e8 5a fe ff ff       	call   1d3 <putc>
        ap++;
 379:	83 c7 04             	add    $0x4,%edi
 37c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 37f:	be 00 00 00 00       	mov    $0x0,%esi
 384:	e9 09 ff ff ff       	jmp    292 <printf+0x2c>
        putc(fd, c);
 389:	89 fa                	mov    %edi,%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	e8 40 fe ff ff       	call   1d3 <putc>
      state = 0;
 393:	be 00 00 00 00       	mov    $0x0,%esi
 398:	e9 f5 fe ff ff       	jmp    292 <printf+0x2c>
        putc(fd, '%');
 39d:	ba 25 00 00 00       	mov    $0x25,%edx
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	e8 29 fe ff ff       	call   1d3 <putc>
        putc(fd, c);
 3aa:	89 fa                	mov    %edi,%edx
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	e8 1f fe ff ff       	call   1d3 <putc>
      state = 0;
 3b4:	be 00 00 00 00       	mov    $0x0,%esi
 3b9:	e9 d4 fe ff ff       	jmp    292 <printf+0x2c>
    }
  }
}
 3be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c1:	5b                   	pop    %ebx
 3c2:	5e                   	pop    %esi
 3c3:	5f                   	pop    %edi
 3c4:	5d                   	pop    %ebp
 3c5:	c3                   	ret    
