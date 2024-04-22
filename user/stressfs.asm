
stressfs:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	8d 7d de             	lea    -0x22(%ebp),%edi
  1a:	be 93 05 00 00       	mov    $0x593,%esi
  1f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  26:	68 70 05 00 00       	push   $0x570
  2b:	6a 01                	push   $0x1
  2d:	e8 dc 03 00 00       	call   40e <printf>
  memset(data, 'a', sizeof(data));
  32:	83 c4 0c             	add    $0xc,%esp
  35:	68 00 02 00 00       	push   $0x200
  3a:	6a 61                	push   $0x61
  3c:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  42:	50                   	push   %eax
  43:	e8 40 01 00 00       	call   188 <memset>

  for(i = 0; i < 4; i++)
  48:	83 c4 10             	add    $0x10,%esp
  4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  50:	83 fb 03             	cmp    $0x3,%ebx
  53:	7f 0c                	jg     61 <main+0x61>
    if(fork() > 0)
  55:	e8 51 02 00 00       	call   2ab <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 03                	jg     61 <main+0x61>
  for(i = 0; i < 4; i++)
  5e:	43                   	inc    %ebx
  5f:	eb ef                	jmp    50 <main+0x50>
      break;

  printf(1, "write %d\n", i);
  61:	83 ec 04             	sub    $0x4,%esp
  64:	53                   	push   %ebx
  65:	68 83 05 00 00       	push   $0x583
  6a:	6a 01                	push   $0x1
  6c:	e8 9d 03 00 00       	call   40e <printf>

  path[8] += i;
  71:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  74:	83 c4 08             	add    $0x8,%esp
  77:	68 02 02 00 00       	push   $0x202
  7c:	8d 45 de             	lea    -0x22(%ebp),%eax
  7f:	50                   	push   %eax
  80:	e8 6e 02 00 00       	call   2f3 <open>
  85:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  87:	83 c4 10             	add    $0x10,%esp
  8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  8f:	eb 19                	jmp    aa <main+0xaa>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  91:	83 ec 04             	sub    $0x4,%esp
  94:	68 00 02 00 00       	push   $0x200
  99:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  9f:	50                   	push   %eax
  a0:	56                   	push   %esi
  a1:	e8 2d 02 00 00       	call   2d3 <write>
  for(i = 0; i < 20; i++)
  a6:	43                   	inc    %ebx
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	83 fb 13             	cmp    $0x13,%ebx
  ad:	7e e2                	jle    91 <main+0x91>
  close(fd);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	56                   	push   %esi
  b3:	e8 23 02 00 00       	call   2db <close>

  printf(1, "read\n");
  b8:	83 c4 08             	add    $0x8,%esp
  bb:	68 8d 05 00 00       	push   $0x58d
  c0:	6a 01                	push   $0x1
  c2:	e8 47 03 00 00       	call   40e <printf>

  fd = open(path, O_RDONLY);
  c7:	83 c4 08             	add    $0x8,%esp
  ca:	6a 00                	push   $0x0
  cc:	8d 45 de             	lea    -0x22(%ebp),%eax
  cf:	50                   	push   %eax
  d0:	e8 1e 02 00 00       	call   2f3 <open>
  d5:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  d7:	83 c4 10             	add    $0x10,%esp
  da:	bb 00 00 00 00       	mov    $0x0,%ebx
  df:	eb 19                	jmp    fa <main+0xfa>
    read(fd, data, sizeof(data));
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	68 00 02 00 00       	push   $0x200
  e9:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  ef:	50                   	push   %eax
  f0:	56                   	push   %esi
  f1:	e8 d5 01 00 00       	call   2cb <read>
  for (i = 0; i < 20; i++)
  f6:	43                   	inc    %ebx
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	83 fb 13             	cmp    $0x13,%ebx
  fd:	7e e2                	jle    e1 <main+0xe1>
  close(fd);
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	56                   	push   %esi
 103:	e8 d3 01 00 00       	call   2db <close>

  wait(NULL);
 108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 10f:	e8 a7 01 00 00       	call   2bb <wait>

  exit(0);
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 93 01 00 00       	call   2b3 <exit>
}
 120:	b8 00 00 00 00       	mov    $0x0,%eax
 125:	8d 65 f0             	lea    -0x10(%ebp),%esp
 128:	59                   	pop    %ecx
 129:	5b                   	pop    %ebx
 12a:	5e                   	pop    %esi
 12b:	5f                   	pop    %edi
 12c:	5d                   	pop    %ebp
 12d:	8d 61 fc             	lea    -0x4(%ecx),%esp
 130:	c3                   	ret    

00000131 <start>:

// Entry point of the library	
void
start()
{
}
 131:	c3                   	ret    

00000132 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	56                   	push   %esi
 136:	53                   	push   %ebx
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13d:	89 c2                	mov    %eax,%edx
 13f:	89 cb                	mov    %ecx,%ebx
 141:	41                   	inc    %ecx
 142:	89 d6                	mov    %edx,%esi
 144:	42                   	inc    %edx
 145:	8a 1b                	mov    (%ebx),%bl
 147:	88 1e                	mov    %bl,(%esi)
 149:	84 db                	test   %bl,%bl
 14b:	75 f2                	jne    13f <strcpy+0xd>
    ;
  return os;
}
 14d:	5b                   	pop    %ebx
 14e:	5e                   	pop    %esi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	8b 4d 08             	mov    0x8(%ebp),%ecx
 157:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15a:	eb 02                	jmp    15e <strcmp+0xd>
    p++, q++;
 15c:	41                   	inc    %ecx
 15d:	42                   	inc    %edx
  while(*p && *p == *q)
 15e:	8a 01                	mov    (%ecx),%al
 160:	84 c0                	test   %al,%al
 162:	74 04                	je     168 <strcmp+0x17>
 164:	3a 02                	cmp    (%edx),%al
 166:	74 f4                	je     15c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 168:	0f b6 c0             	movzbl %al,%eax
 16b:	0f b6 12             	movzbl (%edx),%edx
 16e:	29 d0                	sub    %edx,%eax
}
 170:	5d                   	pop    %ebp
 171:	c3                   	ret    

00000172 <strlen>:

uint
strlen(const char *s)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 178:	b8 00 00 00 00       	mov    $0x0,%eax
 17d:	eb 01                	jmp    180 <strlen+0xe>
 17f:	40                   	inc    %eax
 180:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 184:	75 f9                	jne    17f <strlen+0xd>
    ;
  return n;
}
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    

00000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18c:	8b 7d 08             	mov    0x8(%ebp),%edi
 18f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	fc                   	cld    
 196:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1a9:	eb 01                	jmp    1ac <strchr+0xc>
 1ab:	40                   	inc    %eax
 1ac:	8a 10                	mov    (%eax),%dl
 1ae:	84 d2                	test   %dl,%dl
 1b0:	74 06                	je     1b8 <strchr+0x18>
    if(*s == c)
 1b2:	38 ca                	cmp    %cl,%dl
 1b4:	75 f5                	jne    1ab <strchr+0xb>
 1b6:	eb 05                	jmp    1bd <strchr+0x1d>
      return (char*)s;
  return 0;
 1b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    

000001bf <gets>:

char*
gets(char *buf, int max)
{
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	57                   	push   %edi
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 1c             	sub    $0x1c,%esp
 1c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cb:	bb 00 00 00 00       	mov    $0x0,%ebx
 1d0:	89 de                	mov    %ebx,%esi
 1d2:	43                   	inc    %ebx
 1d3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d6:	7d 2b                	jge    203 <gets+0x44>
    cc = read(0, &c, 1);
 1d8:	83 ec 04             	sub    $0x4,%esp
 1db:	6a 01                	push   $0x1
 1dd:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1e0:	50                   	push   %eax
 1e1:	6a 00                	push   $0x0
 1e3:	e8 e3 00 00 00       	call   2cb <read>
    if(cc < 1)
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	85 c0                	test   %eax,%eax
 1ed:	7e 14                	jle    203 <gets+0x44>
      break;
    buf[i++] = c;
 1ef:	8a 45 e7             	mov    -0x19(%ebp),%al
 1f2:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1f5:	3c 0a                	cmp    $0xa,%al
 1f7:	74 08                	je     201 <gets+0x42>
 1f9:	3c 0d                	cmp    $0xd,%al
 1fb:	75 d3                	jne    1d0 <gets+0x11>
    buf[i++] = c;
 1fd:	89 de                	mov    %ebx,%esi
 1ff:	eb 02                	jmp    203 <gets+0x44>
 201:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 203:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 207:	89 f8                	mov    %edi,%eax
 209:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5f                   	pop    %edi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    

00000211 <stat>:

int
stat(const char *n, struct stat *st)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	56                   	push   %esi
 215:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	83 ec 08             	sub    $0x8,%esp
 219:	6a 00                	push   $0x0
 21b:	ff 75 08             	push   0x8(%ebp)
 21e:	e8 d0 00 00 00       	call   2f3 <open>
  if(fd < 0)
 223:	83 c4 10             	add    $0x10,%esp
 226:	85 c0                	test   %eax,%eax
 228:	78 24                	js     24e <stat+0x3d>
 22a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 0c             	push   0xc(%ebp)
 232:	50                   	push   %eax
 233:	e8 d3 00 00 00       	call   30b <fstat>
 238:	89 c6                	mov    %eax,%esi
  close(fd);
 23a:	89 1c 24             	mov    %ebx,(%esp)
 23d:	e8 99 00 00 00       	call   2db <close>
  return r;
 242:	83 c4 10             	add    $0x10,%esp
}
 245:	89 f0                	mov    %esi,%eax
 247:	8d 65 f8             	lea    -0x8(%ebp),%esp
 24a:	5b                   	pop    %ebx
 24b:	5e                   	pop    %esi
 24c:	5d                   	pop    %ebp
 24d:	c3                   	ret    
    return -1;
 24e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 253:	eb f0                	jmp    245 <stat+0x34>

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	53                   	push   %ebx
 259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 25c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 261:	eb 0e                	jmp    271 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 263:	8d 14 92             	lea    (%edx,%edx,4),%edx
 266:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 269:	41                   	inc    %ecx
 26a:	0f be c0             	movsbl %al,%eax
 26d:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 271:	8a 01                	mov    (%ecx),%al
 273:	8d 58 d0             	lea    -0x30(%eax),%ebx
 276:	80 fb 09             	cmp    $0x9,%bl
 279:	76 e8                	jbe    263 <atoi+0xe>
  return n;
}
 27b:	89 d0                	mov    %edx,%eax
 27d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	56                   	push   %esi
 286:	53                   	push   %ebx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 28d:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 290:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 292:	eb 0c                	jmp    2a0 <memmove+0x1e>
    *dst++ = *src++;
 294:	8a 13                	mov    (%ebx),%dl
 296:	88 11                	mov    %dl,(%ecx)
 298:	8d 5b 01             	lea    0x1(%ebx),%ebx
 29b:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 29e:	89 f2                	mov    %esi,%edx
 2a0:	8d 72 ff             	lea    -0x1(%edx),%esi
 2a3:	85 d2                	test   %edx,%edx
 2a5:	7f ed                	jg     294 <memmove+0x12>
  return vdst;
}
 2a7:	5b                   	pop    %ebx
 2a8:	5e                   	pop    %esi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <date>:
SYSCALL(date)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <dup2>:
SYSCALL(dup2)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <phmem>:
SYSCALL(phmem)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <getprio>:
SYSCALL(getprio)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <setprio>:
SYSCALL(setprio)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 1c             	sub    $0x1c,%esp
 381:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 384:	6a 01                	push   $0x1
 386:	8d 55 f4             	lea    -0xc(%ebp),%edx
 389:	52                   	push   %edx
 38a:	50                   	push   %eax
 38b:	e8 43 ff ff ff       	call   2d3 <write>
}
 390:	83 c4 10             	add    $0x10,%esp
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	57                   	push   %edi
 399:	56                   	push   %esi
 39a:	53                   	push   %ebx
 39b:	83 ec 2c             	sub    $0x2c,%esp
 39e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3a1:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a7:	74 04                	je     3ad <printint+0x18>
 3a9:	85 d2                	test   %edx,%edx
 3ab:	78 3c                	js     3e9 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ad:	89 d1                	mov    %edx,%ecx
  neg = 0;
 3af:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 3b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3bb:	89 c8                	mov    %ecx,%eax
 3bd:	ba 00 00 00 00       	mov    $0x0,%edx
 3c2:	f7 f6                	div    %esi
 3c4:	89 df                	mov    %ebx,%edi
 3c6:	43                   	inc    %ebx
 3c7:	8a 92 fc 05 00 00    	mov    0x5fc(%edx),%dl
 3cd:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3d1:	89 ca                	mov    %ecx,%edx
 3d3:	89 c1                	mov    %eax,%ecx
 3d5:	39 d6                	cmp    %edx,%esi
 3d7:	76 e2                	jbe    3bb <printint+0x26>
  if(neg)
 3d9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3dd:	74 24                	je     403 <printint+0x6e>
    buf[i++] = '-';
 3df:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3e4:	8d 5f 02             	lea    0x2(%edi),%ebx
 3e7:	eb 1a                	jmp    403 <printint+0x6e>
    x = -xx;
 3e9:	89 d1                	mov    %edx,%ecx
 3eb:	f7 d9                	neg    %ecx
    neg = 1;
 3ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3f4:	eb c0                	jmp    3b6 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 3f6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3fe:	e8 78 ff ff ff       	call   37b <putc>
  while(--i >= 0)
 403:	4b                   	dec    %ebx
 404:	79 f0                	jns    3f6 <printint+0x61>
}
 406:	83 c4 2c             	add    $0x2c,%esp
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5f                   	pop    %edi
 40c:	5d                   	pop    %ebp
 40d:	c3                   	ret    

0000040e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	57                   	push   %edi
 412:	56                   	push   %esi
 413:	53                   	push   %ebx
 414:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 45 10             	lea    0x10(%ebp),%eax
 41a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 41d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 422:	bb 00 00 00 00       	mov    $0x0,%ebx
 427:	eb 12                	jmp    43b <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 429:	89 fa                	mov    %edi,%edx
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	e8 48 ff ff ff       	call   37b <putc>
 433:	eb 05                	jmp    43a <printf+0x2c>
      }
    } else if(state == '%'){
 435:	83 fe 25             	cmp    $0x25,%esi
 438:	74 22                	je     45c <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 43a:	43                   	inc    %ebx
 43b:	8b 45 0c             	mov    0xc(%ebp),%eax
 43e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 441:	84 c0                	test   %al,%al
 443:	0f 84 1d 01 00 00    	je     566 <printf+0x158>
    c = fmt[i] & 0xff;
 449:	0f be f8             	movsbl %al,%edi
 44c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 44f:	85 f6                	test   %esi,%esi
 451:	75 e2                	jne    435 <printf+0x27>
      if(c == '%'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	75 d1                	jne    429 <printf+0x1b>
        state = '%';
 458:	89 c6                	mov    %eax,%esi
 45a:	eb de                	jmp    43a <printf+0x2c>
      if(c == 'd'){
 45c:	83 f8 25             	cmp    $0x25,%eax
 45f:	0f 84 cc 00 00 00    	je     531 <printf+0x123>
 465:	0f 8c da 00 00 00    	jl     545 <printf+0x137>
 46b:	83 f8 78             	cmp    $0x78,%eax
 46e:	0f 8f d1 00 00 00    	jg     545 <printf+0x137>
 474:	83 f8 63             	cmp    $0x63,%eax
 477:	0f 8c c8 00 00 00    	jl     545 <printf+0x137>
 47d:	83 e8 63             	sub    $0x63,%eax
 480:	83 f8 15             	cmp    $0x15,%eax
 483:	0f 87 bc 00 00 00    	ja     545 <printf+0x137>
 489:	ff 24 85 a4 05 00 00 	jmp    *0x5a4(,%eax,4)
        printint(fd, *ap, 10, 1);
 490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 493:	8b 17                	mov    (%edi),%edx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 01                	push   $0x1
 49a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 ee fe ff ff       	call   395 <printint>
        ap++;
 4a7:	83 c7 04             	add    $0x4,%edi
 4aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ad:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b0:	be 00 00 00 00       	mov    $0x0,%esi
 4b5:	eb 83                	jmp    43a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ba:	8b 17                	mov    (%edi),%edx
 4bc:	83 ec 0c             	sub    $0xc,%esp
 4bf:	6a 00                	push   $0x0
 4c1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	e8 c7 fe ff ff       	call   395 <printint>
        ap++;
 4ce:	83 c7 04             	add    $0x4,%edi
 4d1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d7:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4dc:	e9 59 ff ff ff       	jmp    43a <printf+0x2c>
        s = (char*)*ap;
 4e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e4:	8b 30                	mov    (%eax),%esi
        ap++;
 4e6:	83 c0 04             	add    $0x4,%eax
 4e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4ec:	85 f6                	test   %esi,%esi
 4ee:	75 13                	jne    503 <printf+0xf5>
          s = "(null)";
 4f0:	be 9d 05 00 00       	mov    $0x59d,%esi
 4f5:	eb 0c                	jmp    503 <printf+0xf5>
          putc(fd, *s);
 4f7:	0f be d2             	movsbl %dl,%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 79 fe ff ff       	call   37b <putc>
          s++;
 502:	46                   	inc    %esi
        while(*s != 0){
 503:	8a 16                	mov    (%esi),%dl
 505:	84 d2                	test   %dl,%dl
 507:	75 ee                	jne    4f7 <printf+0xe9>
      state = 0;
 509:	be 00 00 00 00       	mov    $0x0,%esi
 50e:	e9 27 ff ff ff       	jmp    43a <printf+0x2c>
        putc(fd, *ap);
 513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 516:	0f be 17             	movsbl (%edi),%edx
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	e8 5a fe ff ff       	call   37b <putc>
        ap++;
 521:	83 c7 04             	add    $0x4,%edi
 524:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 527:	be 00 00 00 00       	mov    $0x0,%esi
 52c:	e9 09 ff ff ff       	jmp    43a <printf+0x2c>
        putc(fd, c);
 531:	89 fa                	mov    %edi,%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 40 fe ff ff       	call   37b <putc>
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	e9 f5 fe ff ff       	jmp    43a <printf+0x2c>
        putc(fd, '%');
 545:	ba 25 00 00 00       	mov    $0x25,%edx
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	e8 29 fe ff ff       	call   37b <putc>
        putc(fd, c);
 552:	89 fa                	mov    %edi,%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	e8 1f fe ff ff       	call   37b <putc>
      state = 0;
 55c:	be 00 00 00 00       	mov    $0x0,%esi
 561:	e9 d4 fe ff ff       	jmp    43a <printf+0x2c>
    }
  }
}
 566:	8d 65 f4             	lea    -0xc(%ebp),%esp
 569:	5b                   	pop    %ebx
 56a:	5e                   	pop    %esi
 56b:	5f                   	pop    %edi
 56c:	5d                   	pop    %ebp
 56d:	c3                   	ret    
