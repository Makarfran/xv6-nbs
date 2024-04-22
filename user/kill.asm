
kill:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 07                	jle    25 <main+0x25>
{
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 37                	jmp    5c <main+0x5c>
    printf(2, "usage: kill pid...\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 b8 04 00 00       	push   $0x4b8
  2d:	6a 02                	push   $0x2
  2f:	e8 24 03 00 00       	call   358 <printf>
    exit(0);
  34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3b:	e8 bd 01 00 00       	call   1fd <exit>
  40:	83 c4 10             	add    $0x10,%esp
  43:	eb d9                	jmp    1e <main+0x1e>
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	ff 34 9f             	push   (%edi,%ebx,4)
  4b:	e8 4f 01 00 00       	call   19f <atoi>
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 d5 01 00 00       	call   22d <kill>
  for(i=1; i<argc; i++)
  58:	43                   	inc    %ebx
  59:	83 c4 10             	add    $0x10,%esp
  5c:	39 f3                	cmp    %esi,%ebx
  5e:	7c e5                	jl     45 <main+0x45>
  exit(0);
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	6a 00                	push   $0x0
  65:	e8 93 01 00 00       	call   1fd <exit>
}
  6a:	b8 00 00 00 00       	mov    $0x0,%eax
  6f:	8d 65 f0             	lea    -0x10(%ebp),%esp
  72:	59                   	pop    %ecx
  73:	5b                   	pop    %ebx
  74:	5e                   	pop    %esi
  75:	5f                   	pop    %edi
  76:	5d                   	pop    %ebp
  77:	8d 61 fc             	lea    -0x4(%ecx),%esp
  7a:	c3                   	ret    

0000007b <start>:

// Entry point of the library	
void
start()
{
}
  7b:	c3                   	ret    

0000007c <strcpy>:

char*
strcpy(char *s, const char *t)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	56                   	push   %esi
  80:	53                   	push   %ebx
  81:	8b 45 08             	mov    0x8(%ebp),%eax
  84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  87:	89 c2                	mov    %eax,%edx
  89:	89 cb                	mov    %ecx,%ebx
  8b:	41                   	inc    %ecx
  8c:	89 d6                	mov    %edx,%esi
  8e:	42                   	inc    %edx
  8f:	8a 1b                	mov    (%ebx),%bl
  91:	88 1e                	mov    %bl,(%esi)
  93:	84 db                	test   %bl,%bl
  95:	75 f2                	jne    89 <strcpy+0xd>
    ;
  return os;
}
  97:	5b                   	pop    %ebx
  98:	5e                   	pop    %esi
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  a4:	eb 02                	jmp    a8 <strcmp+0xd>
    p++, q++;
  a6:	41                   	inc    %ecx
  a7:	42                   	inc    %edx
  while(*p && *p == *q)
  a8:	8a 01                	mov    (%ecx),%al
  aa:	84 c0                	test   %al,%al
  ac:	74 04                	je     b2 <strcmp+0x17>
  ae:	3a 02                	cmp    (%edx),%al
  b0:	74 f4                	je     a6 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	0f b6 12             	movzbl (%edx),%edx
  b8:	29 d0                	sub    %edx,%eax
}
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c2:	b8 00 00 00 00       	mov    $0x0,%eax
  c7:	eb 01                	jmp    ca <strlen+0xe>
  c9:	40                   	inc    %eax
  ca:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  ce:	75 f9                	jne    c9 <strlen+0xd>
    ;
  return n;
}
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    

000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  df:	fc                   	cld    
  e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  e8:	c9                   	leave  
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f3:	eb 01                	jmp    f6 <strchr+0xc>
  f5:	40                   	inc    %eax
  f6:	8a 10                	mov    (%eax),%dl
  f8:	84 d2                	test   %dl,%dl
  fa:	74 06                	je     102 <strchr+0x18>
    if(*s == c)
  fc:	38 ca                	cmp    %cl,%dl
  fe:	75 f5                	jne    f5 <strchr+0xb>
 100:	eb 05                	jmp    107 <strchr+0x1d>
      return (char*)s;
  return 0;
 102:	b8 00 00 00 00       	mov    $0x0,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <gets>:

char*
gets(char *buf, int max)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	57                   	push   %edi
 10d:	56                   	push   %esi
 10e:	53                   	push   %ebx
 10f:	83 ec 1c             	sub    $0x1c,%esp
 112:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	bb 00 00 00 00       	mov    $0x0,%ebx
 11a:	89 de                	mov    %ebx,%esi
 11c:	43                   	inc    %ebx
 11d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 120:	7d 2b                	jge    14d <gets+0x44>
    cc = read(0, &c, 1);
 122:	83 ec 04             	sub    $0x4,%esp
 125:	6a 01                	push   $0x1
 127:	8d 45 e7             	lea    -0x19(%ebp),%eax
 12a:	50                   	push   %eax
 12b:	6a 00                	push   $0x0
 12d:	e8 e3 00 00 00       	call   215 <read>
    if(cc < 1)
 132:	83 c4 10             	add    $0x10,%esp
 135:	85 c0                	test   %eax,%eax
 137:	7e 14                	jle    14d <gets+0x44>
      break;
    buf[i++] = c;
 139:	8a 45 e7             	mov    -0x19(%ebp),%al
 13c:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 13f:	3c 0a                	cmp    $0xa,%al
 141:	74 08                	je     14b <gets+0x42>
 143:	3c 0d                	cmp    $0xd,%al
 145:	75 d3                	jne    11a <gets+0x11>
    buf[i++] = c;
 147:	89 de                	mov    %ebx,%esi
 149:	eb 02                	jmp    14d <gets+0x44>
 14b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 14d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 151:	89 f8                	mov    %edi,%eax
 153:	8d 65 f4             	lea    -0xc(%ebp),%esp
 156:	5b                   	pop    %ebx
 157:	5e                   	pop    %esi
 158:	5f                   	pop    %edi
 159:	5d                   	pop    %ebp
 15a:	c3                   	ret    

0000015b <stat>:

int
stat(const char *n, struct stat *st)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	56                   	push   %esi
 15f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	ff 75 08             	push   0x8(%ebp)
 168:	e8 d0 00 00 00       	call   23d <open>
  if(fd < 0)
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	78 24                	js     198 <stat+0x3d>
 174:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 176:	83 ec 08             	sub    $0x8,%esp
 179:	ff 75 0c             	push   0xc(%ebp)
 17c:	50                   	push   %eax
 17d:	e8 d3 00 00 00       	call   255 <fstat>
 182:	89 c6                	mov    %eax,%esi
  close(fd);
 184:	89 1c 24             	mov    %ebx,(%esp)
 187:	e8 99 00 00 00       	call   225 <close>
  return r;
 18c:	83 c4 10             	add    $0x10,%esp
}
 18f:	89 f0                	mov    %esi,%eax
 191:	8d 65 f8             	lea    -0x8(%ebp),%esp
 194:	5b                   	pop    %ebx
 195:	5e                   	pop    %esi
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    
    return -1;
 198:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19d:	eb f0                	jmp    18f <stat+0x34>

0000019f <atoi>:

int
atoi(const char *s)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	53                   	push   %ebx
 1a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1a6:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ab:	eb 0e                	jmp    1bb <atoi+0x1c>
    n = n*10 + *s++ - '0';
 1ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1b0:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 1b3:	41                   	inc    %ecx
 1b4:	0f be c0             	movsbl %al,%eax
 1b7:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 1bb:	8a 01                	mov    (%ecx),%al
 1bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c0:	80 fb 09             	cmp    $0x9,%bl
 1c3:	76 e8                	jbe    1ad <atoi+0xe>
  return n;
}
 1c5:	89 d0                	mov    %edx,%eax
 1c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    

000001cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	56                   	push   %esi
 1d0:	53                   	push   %ebx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1d7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1da:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1dc:	eb 0c                	jmp    1ea <memmove+0x1e>
    *dst++ = *src++;
 1de:	8a 13                	mov    (%ebx),%dl
 1e0:	88 11                	mov    %dl,(%ecx)
 1e2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1e5:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1e8:	89 f2                	mov    %esi,%edx
 1ea:	8d 72 ff             	lea    -0x1(%edx),%esi
 1ed:	85 d2                	test   %edx,%edx
 1ef:	7f ed                	jg     1de <memmove+0x12>
  return vdst;
}
 1f1:	5b                   	pop    %ebx
 1f2:	5e                   	pop    %esi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f5:	b8 01 00 00 00       	mov    $0x1,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <exit>:
SYSCALL(exit)
 1fd:	b8 02 00 00 00       	mov    $0x2,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <wait>:
SYSCALL(wait)
 205:	b8 03 00 00 00       	mov    $0x3,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <pipe>:
SYSCALL(pipe)
 20d:	b8 04 00 00 00       	mov    $0x4,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <read>:
SYSCALL(read)
 215:	b8 05 00 00 00       	mov    $0x5,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <write>:
SYSCALL(write)
 21d:	b8 10 00 00 00       	mov    $0x10,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <close>:
SYSCALL(close)
 225:	b8 15 00 00 00       	mov    $0x15,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <kill>:
SYSCALL(kill)
 22d:	b8 06 00 00 00       	mov    $0x6,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <exec>:
SYSCALL(exec)
 235:	b8 07 00 00 00       	mov    $0x7,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <open>:
SYSCALL(open)
 23d:	b8 0f 00 00 00       	mov    $0xf,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <mknod>:
SYSCALL(mknod)
 245:	b8 11 00 00 00       	mov    $0x11,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <unlink>:
SYSCALL(unlink)
 24d:	b8 12 00 00 00       	mov    $0x12,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <fstat>:
SYSCALL(fstat)
 255:	b8 08 00 00 00       	mov    $0x8,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <link>:
SYSCALL(link)
 25d:	b8 13 00 00 00       	mov    $0x13,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <mkdir>:
SYSCALL(mkdir)
 265:	b8 14 00 00 00       	mov    $0x14,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <chdir>:
SYSCALL(chdir)
 26d:	b8 09 00 00 00       	mov    $0x9,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <dup>:
SYSCALL(dup)
 275:	b8 0a 00 00 00       	mov    $0xa,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <getpid>:
SYSCALL(getpid)
 27d:	b8 0b 00 00 00       	mov    $0xb,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <sbrk>:
SYSCALL(sbrk)
 285:	b8 0c 00 00 00       	mov    $0xc,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <sleep>:
SYSCALL(sleep)
 28d:	b8 0d 00 00 00       	mov    $0xd,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <uptime>:
SYSCALL(uptime)
 295:	b8 0e 00 00 00       	mov    $0xe,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <date>:
SYSCALL(date)
 29d:	b8 16 00 00 00       	mov    $0x16,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <dup2>:
SYSCALL(dup2)
 2a5:	b8 17 00 00 00       	mov    $0x17,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <phmem>:
SYSCALL(phmem)
 2ad:	b8 18 00 00 00       	mov    $0x18,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <getprio>:
SYSCALL(getprio)
 2b5:	b8 19 00 00 00       	mov    $0x19,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <setprio>:
SYSCALL(setprio)
 2bd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 1c             	sub    $0x1c,%esp
 2cb:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ce:	6a 01                	push   $0x1
 2d0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d3:	52                   	push   %edx
 2d4:	50                   	push   %eax
 2d5:	e8 43 ff ff ff       	call   21d <write>
}
 2da:	83 c4 10             	add    $0x10,%esp
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	57                   	push   %edi
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
 2e5:	83 ec 2c             	sub    $0x2c,%esp
 2e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2eb:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f1:	74 04                	je     2f7 <printint+0x18>
 2f3:	85 d2                	test   %edx,%edx
 2f5:	78 3c                	js     333 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2f7:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2f9:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 300:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 305:	89 c8                	mov    %ecx,%eax
 307:	ba 00 00 00 00       	mov    $0x0,%edx
 30c:	f7 f6                	div    %esi
 30e:	89 df                	mov    %ebx,%edi
 310:	43                   	inc    %ebx
 311:	8a 92 2c 05 00 00    	mov    0x52c(%edx),%dl
 317:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 31b:	89 ca                	mov    %ecx,%edx
 31d:	89 c1                	mov    %eax,%ecx
 31f:	39 d6                	cmp    %edx,%esi
 321:	76 e2                	jbe    305 <printint+0x26>
  if(neg)
 323:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 327:	74 24                	je     34d <printint+0x6e>
    buf[i++] = '-';
 329:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32e:	8d 5f 02             	lea    0x2(%edi),%ebx
 331:	eb 1a                	jmp    34d <printint+0x6e>
    x = -xx;
 333:	89 d1                	mov    %edx,%ecx
 335:	f7 d9                	neg    %ecx
    neg = 1;
 337:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 33e:	eb c0                	jmp    300 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 340:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 345:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 348:	e8 78 ff ff ff       	call   2c5 <putc>
  while(--i >= 0)
 34d:	4b                   	dec    %ebx
 34e:	79 f0                	jns    340 <printint+0x61>
}
 350:	83 c4 2c             	add    $0x2c,%esp
 353:	5b                   	pop    %ebx
 354:	5e                   	pop    %esi
 355:	5f                   	pop    %edi
 356:	5d                   	pop    %ebp
 357:	c3                   	ret    

00000358 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 361:	8d 45 10             	lea    0x10(%ebp),%eax
 364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 367:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 36c:	bb 00 00 00 00       	mov    $0x0,%ebx
 371:	eb 12                	jmp    385 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 373:	89 fa                	mov    %edi,%edx
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	e8 48 ff ff ff       	call   2c5 <putc>
 37d:	eb 05                	jmp    384 <printf+0x2c>
      }
    } else if(state == '%'){
 37f:	83 fe 25             	cmp    $0x25,%esi
 382:	74 22                	je     3a6 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 384:	43                   	inc    %ebx
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	8a 04 18             	mov    (%eax,%ebx,1),%al
 38b:	84 c0                	test   %al,%al
 38d:	0f 84 1d 01 00 00    	je     4b0 <printf+0x158>
    c = fmt[i] & 0xff;
 393:	0f be f8             	movsbl %al,%edi
 396:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 399:	85 f6                	test   %esi,%esi
 39b:	75 e2                	jne    37f <printf+0x27>
      if(c == '%'){
 39d:	83 f8 25             	cmp    $0x25,%eax
 3a0:	75 d1                	jne    373 <printf+0x1b>
        state = '%';
 3a2:	89 c6                	mov    %eax,%esi
 3a4:	eb de                	jmp    384 <printf+0x2c>
      if(c == 'd'){
 3a6:	83 f8 25             	cmp    $0x25,%eax
 3a9:	0f 84 cc 00 00 00    	je     47b <printf+0x123>
 3af:	0f 8c da 00 00 00    	jl     48f <printf+0x137>
 3b5:	83 f8 78             	cmp    $0x78,%eax
 3b8:	0f 8f d1 00 00 00    	jg     48f <printf+0x137>
 3be:	83 f8 63             	cmp    $0x63,%eax
 3c1:	0f 8c c8 00 00 00    	jl     48f <printf+0x137>
 3c7:	83 e8 63             	sub    $0x63,%eax
 3ca:	83 f8 15             	cmp    $0x15,%eax
 3cd:	0f 87 bc 00 00 00    	ja     48f <printf+0x137>
 3d3:	ff 24 85 d4 04 00 00 	jmp    *0x4d4(,%eax,4)
        printint(fd, *ap, 10, 1);
 3da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3dd:	8b 17                	mov    (%edi),%edx
 3df:	83 ec 0c             	sub    $0xc,%esp
 3e2:	6a 01                	push   $0x1
 3e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	e8 ee fe ff ff       	call   2df <printint>
        ap++;
 3f1:	83 c7 04             	add    $0x4,%edi
 3f4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f7:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3fa:	be 00 00 00 00       	mov    $0x0,%esi
 3ff:	eb 83                	jmp    384 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 404:	8b 17                	mov    (%edi),%edx
 406:	83 ec 0c             	sub    $0xc,%esp
 409:	6a 00                	push   $0x0
 40b:	b9 10 00 00 00       	mov    $0x10,%ecx
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	e8 c7 fe ff ff       	call   2df <printint>
        ap++;
 418:	83 c7 04             	add    $0x4,%edi
 41b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 421:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 426:	e9 59 ff ff ff       	jmp    384 <printf+0x2c>
        s = (char*)*ap;
 42b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42e:	8b 30                	mov    (%eax),%esi
        ap++;
 430:	83 c0 04             	add    $0x4,%eax
 433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 436:	85 f6                	test   %esi,%esi
 438:	75 13                	jne    44d <printf+0xf5>
          s = "(null)";
 43a:	be cc 04 00 00       	mov    $0x4cc,%esi
 43f:	eb 0c                	jmp    44d <printf+0xf5>
          putc(fd, *s);
 441:	0f be d2             	movsbl %dl,%edx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	e8 79 fe ff ff       	call   2c5 <putc>
          s++;
 44c:	46                   	inc    %esi
        while(*s != 0){
 44d:	8a 16                	mov    (%esi),%dl
 44f:	84 d2                	test   %dl,%dl
 451:	75 ee                	jne    441 <printf+0xe9>
      state = 0;
 453:	be 00 00 00 00       	mov    $0x0,%esi
 458:	e9 27 ff ff ff       	jmp    384 <printf+0x2c>
        putc(fd, *ap);
 45d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 460:	0f be 17             	movsbl (%edi),%edx
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	e8 5a fe ff ff       	call   2c5 <putc>
        ap++;
 46b:	83 c7 04             	add    $0x4,%edi
 46e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 471:	be 00 00 00 00       	mov    $0x0,%esi
 476:	e9 09 ff ff ff       	jmp    384 <printf+0x2c>
        putc(fd, c);
 47b:	89 fa                	mov    %edi,%edx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 40 fe ff ff       	call   2c5 <putc>
      state = 0;
 485:	be 00 00 00 00       	mov    $0x0,%esi
 48a:	e9 f5 fe ff ff       	jmp    384 <printf+0x2c>
        putc(fd, '%');
 48f:	ba 25 00 00 00       	mov    $0x25,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 29 fe ff ff       	call   2c5 <putc>
        putc(fd, c);
 49c:	89 fa                	mov    %edi,%edx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 1f fe ff ff       	call   2c5 <putc>
      state = 0;
 4a6:	be 00 00 00 00       	mov    $0x0,%esi
 4ab:	e9 d4 fe ff ff       	jmp    384 <printf+0x2c>
    }
  }
}
 4b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
