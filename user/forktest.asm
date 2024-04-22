
forktest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 6f 01 00 00       	call   17f <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	push   0x8(%ebp)
  18:	e8 c3 02 00 00       	call   2e0 <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
  2c:	68 88 03 00 00       	push   $0x388
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  38:	83 c4 10             	add    $0x10,%esp
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  40:	eb 01                	jmp    43 <forktest+0x1e>
  42:	43                   	inc    %ebx
  43:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  49:	7f 1a                	jg     65 <forktest+0x40>
    pid = fork();
  4b:	e8 68 02 00 00       	call   2b8 <fork>
    if(pid < 0)
  50:	85 c0                	test   %eax,%eax
  52:	78 11                	js     65 <forktest+0x40>
      break;
    if(pid == 0)
  54:	75 ec                	jne    42 <forktest+0x1d>
      exit(0);
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	6a 00                	push   $0x0
  5b:	e8 60 02 00 00       	call   2c0 <exit>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb dd                	jmp    42 <forktest+0x1d>
  }

  if(n == N){
  65:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  6b:	75 26                	jne    93 <forktest+0x6e>
    printf(1, "fork claimed to work N times!\n", N);
  6d:	83 ec 04             	sub    $0x4,%esp
  70:	68 e8 03 00 00       	push   $0x3e8
  75:	68 c8 03 00 00       	push   $0x3c8
  7a:	6a 01                	push   $0x1
  7c:	e8 7f ff ff ff       	call   0 <printf>
    exit(0);
  81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  88:	e8 33 02 00 00       	call   2c0 <exit>
  8d:	83 c4 10             	add    $0x10,%esp
  90:	eb 01                	jmp    93 <forktest+0x6e>
  }

  for(; n > 0; n--){
  92:	4b                   	dec    %ebx
  93:	85 db                	test   %ebx,%ebx
  95:	7e 31                	jle    c8 <forktest+0xa3>
    if(wait(NULL) < 0){
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 00                	push   $0x0
  9c:	e8 27 02 00 00       	call   2c8 <wait>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	85 c0                	test   %eax,%eax
  a6:	79 ea                	jns    92 <forktest+0x6d>
      printf(1, "wait stopped early\n");
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	68 93 03 00 00       	push   $0x393
  b0:	6a 01                	push   $0x1
  b2:	e8 49 ff ff ff       	call   0 <printf>
      exit(0);
  b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  be:	e8 fd 01 00 00       	call   2c0 <exit>
  c3:	83 c4 10             	add    $0x10,%esp
  c6:	eb ca                	jmp    92 <forktest+0x6d>
    }
  }

  if(wait(NULL) != -1){
  c8:	83 ec 0c             	sub    $0xc,%esp
  cb:	6a 00                	push   $0x0
  cd:	e8 f6 01 00 00       	call   2c8 <wait>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	83 f8 ff             	cmp    $0xffffffff,%eax
  d8:	75 17                	jne    f1 <forktest+0xcc>
    printf(1, "wait got too many\n");
    exit(0);
  }

  printf(1, "fork test OK\n");
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	68 ba 03 00 00       	push   $0x3ba
  e2:	6a 01                	push   $0x1
  e4:	e8 17 ff ff ff       	call   0 <printf>
}
  e9:	83 c4 10             	add    $0x10,%esp
  ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ef:	c9                   	leave  
  f0:	c3                   	ret    
    printf(1, "wait got too many\n");
  f1:	83 ec 08             	sub    $0x8,%esp
  f4:	68 a7 03 00 00       	push   $0x3a7
  f9:	6a 01                	push   $0x1
  fb:	e8 00 ff ff ff       	call   0 <printf>
    exit(0);
 100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 107:	e8 b4 01 00 00       	call   2c0 <exit>
 10c:	83 c4 10             	add    $0x10,%esp
 10f:	eb c9                	jmp    da <forktest+0xb5>

00000111 <main>:

int
main(void)
{
 111:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 115:	83 e4 f0             	and    $0xfffffff0,%esp
 118:	ff 71 fc             	push   -0x4(%ecx)
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	51                   	push   %ecx
 11f:	83 ec 04             	sub    $0x4,%esp
  forktest();
 122:	e8 fe fe ff ff       	call   25 <forktest>
  exit(0);
 127:	83 ec 0c             	sub    $0xc,%esp
 12a:	6a 00                	push   $0x0
 12c:	e8 8f 01 00 00       	call   2c0 <exit>
}
 131:	b8 00 00 00 00       	mov    $0x0,%eax
 136:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 139:	c9                   	leave  
 13a:	8d 61 fc             	lea    -0x4(%ecx),%esp
 13d:	c3                   	ret    

0000013e <start>:

// Entry point of the library	
void
start()
{
}
 13e:	c3                   	ret    

0000013f <strcpy>:

char*
strcpy(char *s, const char *t)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	56                   	push   %esi
 143:	53                   	push   %ebx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	89 c2                	mov    %eax,%edx
 14c:	89 cb                	mov    %ecx,%ebx
 14e:	41                   	inc    %ecx
 14f:	89 d6                	mov    %edx,%esi
 151:	42                   	inc    %edx
 152:	8a 1b                	mov    (%ebx),%bl
 154:	88 1e                	mov    %bl,(%esi)
 156:	84 db                	test   %bl,%bl
 158:	75 f2                	jne    14c <strcpy+0xd>
    ;
  return os;
}
 15a:	5b                   	pop    %ebx
 15b:	5e                   	pop    %esi
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    

0000015e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	8b 4d 08             	mov    0x8(%ebp),%ecx
 164:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 167:	eb 02                	jmp    16b <strcmp+0xd>
    p++, q++;
 169:	41                   	inc    %ecx
 16a:	42                   	inc    %edx
  while(*p && *p == *q)
 16b:	8a 01                	mov    (%ecx),%al
 16d:	84 c0                	test   %al,%al
 16f:	74 04                	je     175 <strcmp+0x17>
 171:	3a 02                	cmp    (%edx),%al
 173:	74 f4                	je     169 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 175:	0f b6 c0             	movzbl %al,%eax
 178:	0f b6 12             	movzbl (%edx),%edx
 17b:	29 d0                	sub    %edx,%eax
}
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    

0000017f <strlen>:

uint
strlen(const char *s)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 185:	b8 00 00 00 00       	mov    $0x0,%eax
 18a:	eb 01                	jmp    18d <strlen+0xe>
 18c:	40                   	inc    %eax
 18d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 191:	75 f9                	jne    18c <strlen+0xd>
    ;
  return n;
}
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    

00000195 <memset>:

void*
memset(void *dst, int c, uint n)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 199:	8b 7d 08             	mov    0x8(%ebp),%edi
 19c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	fc                   	cld    
 1a3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ab:	c9                   	leave  
 1ac:	c3                   	ret    

000001ad <strchr>:

char*
strchr(const char *s, char c)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1b6:	eb 01                	jmp    1b9 <strchr+0xc>
 1b8:	40                   	inc    %eax
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 06                	je     1c5 <strchr+0x18>
    if(*s == c)
 1bf:	38 ca                	cmp    %cl,%dl
 1c1:	75 f5                	jne    1b8 <strchr+0xb>
 1c3:	eb 05                	jmp    1ca <strchr+0x1d>
      return (char*)s;
  return 0;
 1c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 1c             	sub    $0x1c,%esp
 1d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d8:	bb 00 00 00 00       	mov    $0x0,%ebx
 1dd:	89 de                	mov    %ebx,%esi
 1df:	43                   	inc    %ebx
 1e0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e3:	7d 2b                	jge    210 <gets+0x44>
    cc = read(0, &c, 1);
 1e5:	83 ec 04             	sub    $0x4,%esp
 1e8:	6a 01                	push   $0x1
 1ea:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	6a 00                	push   $0x0
 1f0:	e8 e3 00 00 00       	call   2d8 <read>
    if(cc < 1)
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	85 c0                	test   %eax,%eax
 1fa:	7e 14                	jle    210 <gets+0x44>
      break;
    buf[i++] = c;
 1fc:	8a 45 e7             	mov    -0x19(%ebp),%al
 1ff:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 202:	3c 0a                	cmp    $0xa,%al
 204:	74 08                	je     20e <gets+0x42>
 206:	3c 0d                	cmp    $0xd,%al
 208:	75 d3                	jne    1dd <gets+0x11>
    buf[i++] = c;
 20a:	89 de                	mov    %ebx,%esi
 20c:	eb 02                	jmp    210 <gets+0x44>
 20e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 210:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 214:	89 f8                	mov    %edi,%eax
 216:	8d 65 f4             	lea    -0xc(%ebp),%esp
 219:	5b                   	pop    %ebx
 21a:	5e                   	pop    %esi
 21b:	5f                   	pop    %edi
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    

0000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	56                   	push   %esi
 222:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 223:	83 ec 08             	sub    $0x8,%esp
 226:	6a 00                	push   $0x0
 228:	ff 75 08             	push   0x8(%ebp)
 22b:	e8 d0 00 00 00       	call   300 <open>
  if(fd < 0)
 230:	83 c4 10             	add    $0x10,%esp
 233:	85 c0                	test   %eax,%eax
 235:	78 24                	js     25b <stat+0x3d>
 237:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	ff 75 0c             	push   0xc(%ebp)
 23f:	50                   	push   %eax
 240:	e8 d3 00 00 00       	call   318 <fstat>
 245:	89 c6                	mov    %eax,%esi
  close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
 24a:	e8 99 00 00 00       	call   2e8 <close>
  return r;
 24f:	83 c4 10             	add    $0x10,%esp
}
 252:	89 f0                	mov    %esi,%eax
 254:	8d 65 f8             	lea    -0x8(%ebp),%esp
 257:	5b                   	pop    %ebx
 258:	5e                   	pop    %esi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    
    return -1;
 25b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 260:	eb f0                	jmp    252 <stat+0x34>

00000262 <atoi>:

int
atoi(const char *s)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	53                   	push   %ebx
 266:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 269:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 26e:	eb 0e                	jmp    27e <atoi+0x1c>
    n = n*10 + *s++ - '0';
 270:	8d 14 92             	lea    (%edx,%edx,4),%edx
 273:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 276:	41                   	inc    %ecx
 277:	0f be c0             	movsbl %al,%eax
 27a:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 27e:	8a 01                	mov    (%ecx),%al
 280:	8d 58 d0             	lea    -0x30(%eax),%ebx
 283:	80 fb 09             	cmp    $0x9,%bl
 286:	76 e8                	jbe    270 <atoi+0xe>
  return n;
}
 288:	89 d0                	mov    %edx,%eax
 28a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	56                   	push   %esi
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 29a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 29d:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 29f:	eb 0c                	jmp    2ad <memmove+0x1e>
    *dst++ = *src++;
 2a1:	8a 13                	mov    (%ebx),%dl
 2a3:	88 11                	mov    %dl,(%ecx)
 2a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a8:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2ab:	89 f2                	mov    %esi,%edx
 2ad:	8d 72 ff             	lea    -0x1(%edx),%esi
 2b0:	85 d2                	test   %edx,%edx
 2b2:	7f ed                	jg     2a1 <memmove+0x12>
  return vdst;
}
 2b4:	5b                   	pop    %ebx
 2b5:	5e                   	pop    %esi
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    

000002b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b8:	b8 01 00 00 00       	mov    $0x1,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exit>:
SYSCALL(exit)
 2c0:	b8 02 00 00 00       	mov    $0x2,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <wait>:
SYSCALL(wait)
 2c8:	b8 03 00 00 00       	mov    $0x3,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <pipe>:
SYSCALL(pipe)
 2d0:	b8 04 00 00 00       	mov    $0x4,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <read>:
SYSCALL(read)
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <write>:
SYSCALL(write)
 2e0:	b8 10 00 00 00       	mov    $0x10,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <close>:
SYSCALL(close)
 2e8:	b8 15 00 00 00       	mov    $0x15,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <kill>:
SYSCALL(kill)
 2f0:	b8 06 00 00 00       	mov    $0x6,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exec>:
SYSCALL(exec)
 2f8:	b8 07 00 00 00       	mov    $0x7,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <open>:
SYSCALL(open)
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mknod>:
SYSCALL(mknod)
 308:	b8 11 00 00 00       	mov    $0x11,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <unlink>:
SYSCALL(unlink)
 310:	b8 12 00 00 00       	mov    $0x12,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <fstat>:
SYSCALL(fstat)
 318:	b8 08 00 00 00       	mov    $0x8,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <link>:
SYSCALL(link)
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mkdir>:
SYSCALL(mkdir)
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <chdir>:
SYSCALL(chdir)
 330:	b8 09 00 00 00       	mov    $0x9,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <dup>:
SYSCALL(dup)
 338:	b8 0a 00 00 00       	mov    $0xa,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <getpid>:
SYSCALL(getpid)
 340:	b8 0b 00 00 00       	mov    $0xb,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sbrk>:
SYSCALL(sbrk)
 348:	b8 0c 00 00 00       	mov    $0xc,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sleep>:
SYSCALL(sleep)
 350:	b8 0d 00 00 00       	mov    $0xd,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <uptime>:
SYSCALL(uptime)
 358:	b8 0e 00 00 00       	mov    $0xe,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <date>:
SYSCALL(date)
 360:	b8 16 00 00 00       	mov    $0x16,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <dup2>:
SYSCALL(dup2)
 368:	b8 17 00 00 00       	mov    $0x17,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <phmem>:
SYSCALL(phmem)
 370:	b8 18 00 00 00       	mov    $0x18,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getprio>:
SYSCALL(getprio)
 378:	b8 19 00 00 00       	mov    $0x19,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <setprio>:
SYSCALL(setprio)
 380:	b8 1a 00 00 00       	mov    $0x1a,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    
