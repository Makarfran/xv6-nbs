
date:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"
int
main (int argc , char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 30             	sub    $0x30,%esp
  struct rtcdate r;
  if(date(&r)) {
  11:	8d 45 e0             	lea    -0x20(%ebp),%eax
  14:	50                   	push   %eax
  15:	e8 04 01 00 00       	call   11e <date>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	85 c0                	test   %eax,%eax
  1f:	75 35                	jne    56 <main+0x56>
  	printf(2 , "date failed\n") ;
  	exit(0);
  }
  printf(0, "Año:%d  Mes:%d  Dia:%d  Hora: %d:%d:%d  ", r.year, r.month, r.day, r.hour, r.minute, r.second);
  21:	ff 75 e0             	push   -0x20(%ebp)
  24:	ff 75 e4             	push   -0x1c(%ebp)
  27:	ff 75 e8             	push   -0x18(%ebp)
  2a:	ff 75 ec             	push   -0x14(%ebp)
  2d:	ff 75 f0             	push   -0x10(%ebp)
  30:	ff 75 f4             	push   -0xc(%ebp)
  33:	68 4c 03 00 00       	push   $0x34c
  38:	6a 00                	push   $0x0
  3a:	e8 9a 01 00 00       	call   1d9 <printf>
  exit(0);
  3f:	83 c4 14             	add    $0x14,%esp
  42:	6a 00                	push   $0x0
  44:	e8 35 00 00 00       	call   7e <exit>
}
  49:	b8 00 00 00 00       	mov    $0x0,%eax
  4e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  51:	c9                   	leave  
  52:	8d 61 fc             	lea    -0x4(%ecx),%esp
  55:	c3                   	ret    
  	printf(2 , "date failed\n") ;
  56:	83 ec 08             	sub    $0x8,%esp
  59:	68 3c 03 00 00       	push   $0x33c
  5e:	6a 02                	push   $0x2
  60:	e8 74 01 00 00       	call   1d9 <printf>
  	exit(0);
  65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6c:	e8 0d 00 00 00       	call   7e <exit>
  71:	83 c4 10             	add    $0x10,%esp
  74:	eb ab                	jmp    21 <main+0x21>

00000076 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  76:	b8 01 00 00 00       	mov    $0x1,%eax
  7b:	cd 40                	int    $0x40
  7d:	c3                   	ret    

0000007e <exit>:
SYSCALL(exit)
  7e:	b8 02 00 00 00       	mov    $0x2,%eax
  83:	cd 40                	int    $0x40
  85:	c3                   	ret    

00000086 <wait>:
SYSCALL(wait)
  86:	b8 03 00 00 00       	mov    $0x3,%eax
  8b:	cd 40                	int    $0x40
  8d:	c3                   	ret    

0000008e <pipe>:
SYSCALL(pipe)
  8e:	b8 04 00 00 00       	mov    $0x4,%eax
  93:	cd 40                	int    $0x40
  95:	c3                   	ret    

00000096 <read>:
SYSCALL(read)
  96:	b8 05 00 00 00       	mov    $0x5,%eax
  9b:	cd 40                	int    $0x40
  9d:	c3                   	ret    

0000009e <write>:
SYSCALL(write)
  9e:	b8 10 00 00 00       	mov    $0x10,%eax
  a3:	cd 40                	int    $0x40
  a5:	c3                   	ret    

000000a6 <close>:
SYSCALL(close)
  a6:	b8 15 00 00 00       	mov    $0x15,%eax
  ab:	cd 40                	int    $0x40
  ad:	c3                   	ret    

000000ae <kill>:
SYSCALL(kill)
  ae:	b8 06 00 00 00       	mov    $0x6,%eax
  b3:	cd 40                	int    $0x40
  b5:	c3                   	ret    

000000b6 <exec>:
SYSCALL(exec)
  b6:	b8 07 00 00 00       	mov    $0x7,%eax
  bb:	cd 40                	int    $0x40
  bd:	c3                   	ret    

000000be <open>:
SYSCALL(open)
  be:	b8 0f 00 00 00       	mov    $0xf,%eax
  c3:	cd 40                	int    $0x40
  c5:	c3                   	ret    

000000c6 <mknod>:
SYSCALL(mknod)
  c6:	b8 11 00 00 00       	mov    $0x11,%eax
  cb:	cd 40                	int    $0x40
  cd:	c3                   	ret    

000000ce <unlink>:
SYSCALL(unlink)
  ce:	b8 12 00 00 00       	mov    $0x12,%eax
  d3:	cd 40                	int    $0x40
  d5:	c3                   	ret    

000000d6 <fstat>:
SYSCALL(fstat)
  d6:	b8 08 00 00 00       	mov    $0x8,%eax
  db:	cd 40                	int    $0x40
  dd:	c3                   	ret    

000000de <link>:
SYSCALL(link)
  de:	b8 13 00 00 00       	mov    $0x13,%eax
  e3:	cd 40                	int    $0x40
  e5:	c3                   	ret    

000000e6 <mkdir>:
SYSCALL(mkdir)
  e6:	b8 14 00 00 00       	mov    $0x14,%eax
  eb:	cd 40                	int    $0x40
  ed:	c3                   	ret    

000000ee <chdir>:
SYSCALL(chdir)
  ee:	b8 09 00 00 00       	mov    $0x9,%eax
  f3:	cd 40                	int    $0x40
  f5:	c3                   	ret    

000000f6 <dup>:
SYSCALL(dup)
  f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  fb:	cd 40                	int    $0x40
  fd:	c3                   	ret    

000000fe <getpid>:
SYSCALL(getpid)
  fe:	b8 0b 00 00 00       	mov    $0xb,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <sbrk>:
SYSCALL(sbrk)
 106:	b8 0c 00 00 00       	mov    $0xc,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <sleep>:
SYSCALL(sleep)
 10e:	b8 0d 00 00 00       	mov    $0xd,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <uptime>:
SYSCALL(uptime)
 116:	b8 0e 00 00 00       	mov    $0xe,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    

0000011e <date>:
SYSCALL(date)
 11e:	b8 16 00 00 00       	mov    $0x16,%eax
 123:	cd 40                	int    $0x40
 125:	c3                   	ret    

00000126 <dup2>:
SYSCALL(dup2)
 126:	b8 17 00 00 00       	mov    $0x17,%eax
 12b:	cd 40                	int    $0x40
 12d:	c3                   	ret    

0000012e <phmem>:
SYSCALL(phmem)
 12e:	b8 18 00 00 00       	mov    $0x18,%eax
 133:	cd 40                	int    $0x40
 135:	c3                   	ret    

00000136 <getprio>:
SYSCALL(getprio)
 136:	b8 19 00 00 00       	mov    $0x19,%eax
 13b:	cd 40                	int    $0x40
 13d:	c3                   	ret    

0000013e <setprio>:
SYSCALL(setprio)
 13e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 143:	cd 40                	int    $0x40
 145:	c3                   	ret    

00000146 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 1c             	sub    $0x1c,%esp
 14c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 14f:	6a 01                	push   $0x1
 151:	8d 55 f4             	lea    -0xc(%ebp),%edx
 154:	52                   	push   %edx
 155:	50                   	push   %eax
 156:	e8 43 ff ff ff       	call   9e <write>
}
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	c9                   	leave  
 15f:	c3                   	ret    

00000160 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	83 ec 2c             	sub    $0x2c,%esp
 169:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 16c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 172:	74 04                	je     178 <printint+0x18>
 174:	85 d2                	test   %edx,%edx
 176:	78 3c                	js     1b4 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 178:	89 d1                	mov    %edx,%ecx
  neg = 0;
 17a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 181:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 186:	89 c8                	mov    %ecx,%eax
 188:	ba 00 00 00 00       	mov    $0x0,%edx
 18d:	f7 f6                	div    %esi
 18f:	89 df                	mov    %ebx,%edi
 191:	43                   	inc    %ebx
 192:	8a 92 d8 03 00 00    	mov    0x3d8(%edx),%dl
 198:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 19c:	89 ca                	mov    %ecx,%edx
 19e:	89 c1                	mov    %eax,%ecx
 1a0:	39 d6                	cmp    %edx,%esi
 1a2:	76 e2                	jbe    186 <printint+0x26>
  if(neg)
 1a4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1a8:	74 24                	je     1ce <printint+0x6e>
    buf[i++] = '-';
 1aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1af:	8d 5f 02             	lea    0x2(%edi),%ebx
 1b2:	eb 1a                	jmp    1ce <printint+0x6e>
    x = -xx;
 1b4:	89 d1                	mov    %edx,%ecx
 1b6:	f7 d9                	neg    %ecx
    neg = 1;
 1b8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1bf:	eb c0                	jmp    181 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1c1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c9:	e8 78 ff ff ff       	call   146 <putc>
  while(--i >= 0)
 1ce:	4b                   	dec    %ebx
 1cf:	79 f0                	jns    1c1 <printint+0x61>
}
 1d1:	83 c4 2c             	add    $0x2c,%esp
 1d4:	5b                   	pop    %ebx
 1d5:	5e                   	pop    %esi
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	56                   	push   %esi
 1de:	53                   	push   %ebx
 1df:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e2:	8d 45 10             	lea    0x10(%ebp),%eax
 1e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e8:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ed:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f2:	eb 12                	jmp    206 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1f4:	89 fa                	mov    %edi,%edx
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	e8 48 ff ff ff       	call   146 <putc>
 1fe:	eb 05                	jmp    205 <printf+0x2c>
      }
    } else if(state == '%'){
 200:	83 fe 25             	cmp    $0x25,%esi
 203:	74 22                	je     227 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 205:	43                   	inc    %ebx
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	8a 04 18             	mov    (%eax,%ebx,1),%al
 20c:	84 c0                	test   %al,%al
 20e:	0f 84 1d 01 00 00    	je     331 <printf+0x158>
    c = fmt[i] & 0xff;
 214:	0f be f8             	movsbl %al,%edi
 217:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 21a:	85 f6                	test   %esi,%esi
 21c:	75 e2                	jne    200 <printf+0x27>
      if(c == '%'){
 21e:	83 f8 25             	cmp    $0x25,%eax
 221:	75 d1                	jne    1f4 <printf+0x1b>
        state = '%';
 223:	89 c6                	mov    %eax,%esi
 225:	eb de                	jmp    205 <printf+0x2c>
      if(c == 'd'){
 227:	83 f8 25             	cmp    $0x25,%eax
 22a:	0f 84 cc 00 00 00    	je     2fc <printf+0x123>
 230:	0f 8c da 00 00 00    	jl     310 <printf+0x137>
 236:	83 f8 78             	cmp    $0x78,%eax
 239:	0f 8f d1 00 00 00    	jg     310 <printf+0x137>
 23f:	83 f8 63             	cmp    $0x63,%eax
 242:	0f 8c c8 00 00 00    	jl     310 <printf+0x137>
 248:	83 e8 63             	sub    $0x63,%eax
 24b:	83 f8 15             	cmp    $0x15,%eax
 24e:	0f 87 bc 00 00 00    	ja     310 <printf+0x137>
 254:	ff 24 85 80 03 00 00 	jmp    *0x380(,%eax,4)
        printint(fd, *ap, 10, 1);
 25b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25e:	8b 17                	mov    (%edi),%edx
 260:	83 ec 0c             	sub    $0xc,%esp
 263:	6a 01                	push   $0x1
 265:	b9 0a 00 00 00       	mov    $0xa,%ecx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	e8 ee fe ff ff       	call   160 <printint>
        ap++;
 272:	83 c7 04             	add    $0x4,%edi
 275:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 278:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 27b:	be 00 00 00 00       	mov    $0x0,%esi
 280:	eb 83                	jmp    205 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 282:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 285:	8b 17                	mov    (%edi),%edx
 287:	83 ec 0c             	sub    $0xc,%esp
 28a:	6a 00                	push   $0x0
 28c:	b9 10 00 00 00       	mov    $0x10,%ecx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	e8 c7 fe ff ff       	call   160 <printint>
        ap++;
 299:	83 c7 04             	add    $0x4,%edi
 29c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 29f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2a2:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2a7:	e9 59 ff ff ff       	jmp    205 <printf+0x2c>
        s = (char*)*ap;
 2ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2af:	8b 30                	mov    (%eax),%esi
        ap++;
 2b1:	83 c0 04             	add    $0x4,%eax
 2b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2b7:	85 f6                	test   %esi,%esi
 2b9:	75 13                	jne    2ce <printf+0xf5>
          s = "(null)";
 2bb:	be 76 03 00 00       	mov    $0x376,%esi
 2c0:	eb 0c                	jmp    2ce <printf+0xf5>
          putc(fd, *s);
 2c2:	0f be d2             	movsbl %dl,%edx
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	e8 79 fe ff ff       	call   146 <putc>
          s++;
 2cd:	46                   	inc    %esi
        while(*s != 0){
 2ce:	8a 16                	mov    (%esi),%dl
 2d0:	84 d2                	test   %dl,%dl
 2d2:	75 ee                	jne    2c2 <printf+0xe9>
      state = 0;
 2d4:	be 00 00 00 00       	mov    $0x0,%esi
 2d9:	e9 27 ff ff ff       	jmp    205 <printf+0x2c>
        putc(fd, *ap);
 2de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e1:	0f be 17             	movsbl (%edi),%edx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	e8 5a fe ff ff       	call   146 <putc>
        ap++;
 2ec:	83 c7 04             	add    $0x4,%edi
 2ef:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2f2:	be 00 00 00 00       	mov    $0x0,%esi
 2f7:	e9 09 ff ff ff       	jmp    205 <printf+0x2c>
        putc(fd, c);
 2fc:	89 fa                	mov    %edi,%edx
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	e8 40 fe ff ff       	call   146 <putc>
      state = 0;
 306:	be 00 00 00 00       	mov    $0x0,%esi
 30b:	e9 f5 fe ff ff       	jmp    205 <printf+0x2c>
        putc(fd, '%');
 310:	ba 25 00 00 00       	mov    $0x25,%edx
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	e8 29 fe ff ff       	call   146 <putc>
        putc(fd, c);
 31d:	89 fa                	mov    %edi,%edx
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	e8 1f fe ff ff       	call   146 <putc>
      state = 0;
 327:	be 00 00 00 00       	mov    $0x0,%esi
 32c:	e9 d4 fe ff ff       	jmp    205 <printf+0x2c>
    }
  }
}
 331:	8d 65 f4             	lea    -0xc(%ebp),%esp
 334:	5b                   	pop    %ebx
 335:	5e                   	pop    %esi
 336:	5f                   	pop    %edi
 337:	5d                   	pop    %ebp
 338:	c3                   	ret    
