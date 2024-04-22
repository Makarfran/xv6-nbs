
wc:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	be 00 00 00 00       	mov    $0x0,%esi
  15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	83 ec 04             	sub    $0x4,%esp
  26:	68 00 02 00 00       	push   $0x200
  2b:	68 00 09 00 00       	push   $0x900
  30:	ff 75 08             	push   0x8(%ebp)
  33:	e8 f5 02 00 00       	call   32d <read>
  38:	89 c7                	mov    %eax,%edi
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	7e 4d                	jle    8e <wc+0x8e>
    for(i=0; i<n; i++){
  41:	bb 00 00 00 00       	mov    $0x0,%ebx
  46:	eb 20                	jmp    68 <wc+0x68>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	0f be c0             	movsbl %al,%eax
  4e:	50                   	push   %eax
  4f:	68 d0 05 00 00       	push   $0x5d0
  54:	e8 a9 01 00 00       	call   202 <strchr>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	74 1c                	je     7c <wc+0x7c>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  67:	43                   	inc    %ebx
  68:	39 fb                	cmp    %edi,%ebx
  6a:	7d b7                	jge    23 <wc+0x23>
      c++;
  6c:	46                   	inc    %esi
      if(buf[i] == '\n')
  6d:	8a 83 00 09 00 00    	mov    0x900(%ebx),%al
  73:	3c 0a                	cmp    $0xa,%al
  75:	75 d1                	jne    48 <wc+0x48>
        l++;
  77:	ff 45 e0             	incl   -0x20(%ebp)
  7a:	eb cc                	jmp    48 <wc+0x48>
      else if(!inword){
  7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80:	75 e5                	jne    67 <wc+0x67>
        w++;
  82:	ff 45 dc             	incl   -0x24(%ebp)
        inword = 1;
  85:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  8c:	eb d9                	jmp    67 <wc+0x67>
      }
    }
  }
  if(n < 0){
  8e:	78 24                	js     b4 <wc+0xb4>
    printf(1, "wc: read error\n");
    exit(0);
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  90:	83 ec 08             	sub    $0x8,%esp
  93:	ff 75 0c             	push   0xc(%ebp)
  96:	56                   	push   %esi
  97:	ff 75 dc             	push   -0x24(%ebp)
  9a:	ff 75 e0             	push   -0x20(%ebp)
  9d:	68 e6 05 00 00       	push   $0x5e6
  a2:	6a 01                	push   $0x1
  a4:	e8 c7 03 00 00       	call   470 <printf>
}
  a9:	83 c4 20             	add    $0x20,%esp
  ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  af:	5b                   	pop    %ebx
  b0:	5e                   	pop    %esi
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
    printf(1, "wc: read error\n");
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 d6 05 00 00       	push   $0x5d6
  bc:	6a 01                	push   $0x1
  be:	e8 ad 03 00 00       	call   470 <printf>
    exit(0);
  c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ca:	e8 46 02 00 00       	call   315 <exit>
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	eb bc                	jmp    90 <wc+0x90>

000000d4 <main>:

int
main(int argc, char *argv[])
{
  d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d8:	83 e4 f0             	and    $0xfffffff0,%esp
  db:	ff 71 fc             	push   -0x4(%ecx)
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	57                   	push   %edi
  e2:	56                   	push   %esi
  e3:	53                   	push   %ebx
  e4:	51                   	push   %ecx
  e5:	83 ec 18             	sub    $0x18,%esp
  e8:	8b 01                	mov    (%ecx),%eax
  ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ed:	8b 51 04             	mov    0x4(%ecx),%edx
  f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f3:	83 f8 01             	cmp    $0x1,%eax
  f6:	7e 07                	jle    ff <main+0x2b>
{
  f8:	be 01 00 00 00       	mov    $0x1,%esi
  fd:	eb 37                	jmp    136 <main+0x62>
    wc(0, "");
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	68 e5 05 00 00       	push   $0x5e5
 107:	6a 00                	push   $0x0
 109:	e8 f2 fe ff ff       	call   0 <wc>
    exit(0);
 10e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 115:	e8 fb 01 00 00       	call   315 <exit>
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	eb d9                	jmp    f8 <main+0x24>
  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit(0);
    }
    wc(fd, argv[i]);
 11f:	83 ec 08             	sub    $0x8,%esp
 122:	ff 37                	push   (%edi)
 124:	53                   	push   %ebx
 125:	e8 d6 fe ff ff       	call   0 <wc>
    close(fd);
 12a:	89 1c 24             	mov    %ebx,(%esp)
 12d:	e8 0b 02 00 00       	call   33d <close>
  for(i = 1; i < argc; i++){
 132:	46                   	inc    %esi
 133:	83 c4 10             	add    $0x10,%esp
 136:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 139:	7d 3d                	jge    178 <main+0xa4>
    if((fd = open(argv[i], 0)) < 0){
 13b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 13e:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 141:	83 ec 08             	sub    $0x8,%esp
 144:	6a 00                	push   $0x0
 146:	ff 37                	push   (%edi)
 148:	e8 08 02 00 00       	call   355 <open>
 14d:	89 c3                	mov    %eax,%ebx
 14f:	83 c4 10             	add    $0x10,%esp
 152:	85 c0                	test   %eax,%eax
 154:	79 c9                	jns    11f <main+0x4b>
      printf(1, "wc: cannot open %s\n", argv[i]);
 156:	83 ec 04             	sub    $0x4,%esp
 159:	ff 37                	push   (%edi)
 15b:	68 f3 05 00 00       	push   $0x5f3
 160:	6a 01                	push   $0x1
 162:	e8 09 03 00 00       	call   470 <printf>
      exit(0);
 167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 16e:	e8 a2 01 00 00       	call   315 <exit>
 173:	83 c4 10             	add    $0x10,%esp
 176:	eb a7                	jmp    11f <main+0x4b>
  }
  exit(0);
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	6a 00                	push   $0x0
 17d:	e8 93 01 00 00       	call   315 <exit>
}
 182:	b8 00 00 00 00       	mov    $0x0,%eax
 187:	8d 65 f0             	lea    -0x10(%ebp),%esp
 18a:	59                   	pop    %ecx
 18b:	5b                   	pop    %ebx
 18c:	5e                   	pop    %esi
 18d:	5f                   	pop    %edi
 18e:	5d                   	pop    %ebp
 18f:	8d 61 fc             	lea    -0x4(%ecx),%esp
 192:	c3                   	ret    

00000193 <start>:

// Entry point of the library	
void
start()
{
}
 193:	c3                   	ret    

00000194 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	56                   	push   %esi
 198:	53                   	push   %ebx
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19f:	89 c2                	mov    %eax,%edx
 1a1:	89 cb                	mov    %ecx,%ebx
 1a3:	41                   	inc    %ecx
 1a4:	89 d6                	mov    %edx,%esi
 1a6:	42                   	inc    %edx
 1a7:	8a 1b                	mov    (%ebx),%bl
 1a9:	88 1e                	mov    %bl,(%esi)
 1ab:	84 db                	test   %bl,%bl
 1ad:	75 f2                	jne    1a1 <strcpy+0xd>
    ;
  return os;
}
 1af:	5b                   	pop    %ebx
 1b0:	5e                   	pop    %esi
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    

000001b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1bc:	eb 02                	jmp    1c0 <strcmp+0xd>
    p++, q++;
 1be:	41                   	inc    %ecx
 1bf:	42                   	inc    %edx
  while(*p && *p == *q)
 1c0:	8a 01                	mov    (%ecx),%al
 1c2:	84 c0                	test   %al,%al
 1c4:	74 04                	je     1ca <strcmp+0x17>
 1c6:	3a 02                	cmp    (%edx),%al
 1c8:	74 f4                	je     1be <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1ca:	0f b6 c0             	movzbl %al,%eax
 1cd:	0f b6 12             	movzbl (%edx),%edx
 1d0:	29 d0                	sub    %edx,%eax
}
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    

000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1da:	b8 00 00 00 00       	mov    $0x0,%eax
 1df:	eb 01                	jmp    1e2 <strlen+0xe>
 1e1:	40                   	inc    %eax
 1e2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1e6:	75 f9                	jne    1e1 <strlen+0xd>
    ;
  return n;
}
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    

000001ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1ee:	8b 7d 08             	mov    0x8(%ebp),%edi
 1f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	fc                   	cld    
 1f8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	8b 7d fc             	mov    -0x4(%ebp),%edi
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 20b:	eb 01                	jmp    20e <strchr+0xc>
 20d:	40                   	inc    %eax
 20e:	8a 10                	mov    (%eax),%dl
 210:	84 d2                	test   %dl,%dl
 212:	74 06                	je     21a <strchr+0x18>
    if(*s == c)
 214:	38 ca                	cmp    %cl,%dl
 216:	75 f5                	jne    20d <strchr+0xb>
 218:	eb 05                	jmp    21f <strchr+0x1d>
      return (char*)s;
  return 0;
 21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	57                   	push   %edi
 225:	56                   	push   %esi
 226:	53                   	push   %ebx
 227:	83 ec 1c             	sub    $0x1c,%esp
 22a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22d:	bb 00 00 00 00       	mov    $0x0,%ebx
 232:	89 de                	mov    %ebx,%esi
 234:	43                   	inc    %ebx
 235:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 238:	7d 2b                	jge    265 <gets+0x44>
    cc = read(0, &c, 1);
 23a:	83 ec 04             	sub    $0x4,%esp
 23d:	6a 01                	push   $0x1
 23f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 242:	50                   	push   %eax
 243:	6a 00                	push   $0x0
 245:	e8 e3 00 00 00       	call   32d <read>
    if(cc < 1)
 24a:	83 c4 10             	add    $0x10,%esp
 24d:	85 c0                	test   %eax,%eax
 24f:	7e 14                	jle    265 <gets+0x44>
      break;
    buf[i++] = c;
 251:	8a 45 e7             	mov    -0x19(%ebp),%al
 254:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 257:	3c 0a                	cmp    $0xa,%al
 259:	74 08                	je     263 <gets+0x42>
 25b:	3c 0d                	cmp    $0xd,%al
 25d:	75 d3                	jne    232 <gets+0x11>
    buf[i++] = c;
 25f:	89 de                	mov    %ebx,%esi
 261:	eb 02                	jmp    265 <gets+0x44>
 263:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 265:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 269:	89 f8                	mov    %edi,%eax
 26b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26e:	5b                   	pop    %ebx
 26f:	5e                   	pop    %esi
 270:	5f                   	pop    %edi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    

00000273 <stat>:

int
stat(const char *n, struct stat *st)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	56                   	push   %esi
 277:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 278:	83 ec 08             	sub    $0x8,%esp
 27b:	6a 00                	push   $0x0
 27d:	ff 75 08             	push   0x8(%ebp)
 280:	e8 d0 00 00 00       	call   355 <open>
  if(fd < 0)
 285:	83 c4 10             	add    $0x10,%esp
 288:	85 c0                	test   %eax,%eax
 28a:	78 24                	js     2b0 <stat+0x3d>
 28c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 28e:	83 ec 08             	sub    $0x8,%esp
 291:	ff 75 0c             	push   0xc(%ebp)
 294:	50                   	push   %eax
 295:	e8 d3 00 00 00       	call   36d <fstat>
 29a:	89 c6                	mov    %eax,%esi
  close(fd);
 29c:	89 1c 24             	mov    %ebx,(%esp)
 29f:	e8 99 00 00 00       	call   33d <close>
  return r;
 2a4:	83 c4 10             	add    $0x10,%esp
}
 2a7:	89 f0                	mov    %esi,%eax
 2a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2ac:	5b                   	pop    %ebx
 2ad:	5e                   	pop    %esi
 2ae:	5d                   	pop    %ebp
 2af:	c3                   	ret    
    return -1;
 2b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b5:	eb f0                	jmp    2a7 <stat+0x34>

000002b7 <atoi>:

int
atoi(const char *s)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	53                   	push   %ebx
 2bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2be:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2c3:	eb 0e                	jmp    2d3 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 2c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2c8:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 2cb:	41                   	inc    %ecx
 2cc:	0f be c0             	movsbl %al,%eax
 2cf:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 2d3:	8a 01                	mov    (%ecx),%al
 2d5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d8:	80 fb 09             	cmp    $0x9,%bl
 2db:	76 e8                	jbe    2c5 <atoi+0xe>
  return n;
}
 2dd:	89 d0                	mov    %edx,%eax
 2df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	56                   	push   %esi
 2e8:	53                   	push   %ebx
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2f2:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2f4:	eb 0c                	jmp    302 <memmove+0x1e>
    *dst++ = *src++;
 2f6:	8a 13                	mov    (%ebx),%dl
 2f8:	88 11                	mov    %dl,(%ecx)
 2fa:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2fd:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 300:	89 f2                	mov    %esi,%edx
 302:	8d 72 ff             	lea    -0x1(%edx),%esi
 305:	85 d2                	test   %edx,%edx
 307:	7f ed                	jg     2f6 <memmove+0x12>
  return vdst;
}
 309:	5b                   	pop    %ebx
 30a:	5e                   	pop    %esi
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    

0000030d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30d:	b8 01 00 00 00       	mov    $0x1,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exit>:
SYSCALL(exit)
 315:	b8 02 00 00 00       	mov    $0x2,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <wait>:
SYSCALL(wait)
 31d:	b8 03 00 00 00       	mov    $0x3,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <pipe>:
SYSCALL(pipe)
 325:	b8 04 00 00 00       	mov    $0x4,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <read>:
SYSCALL(read)
 32d:	b8 05 00 00 00       	mov    $0x5,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <write>:
SYSCALL(write)
 335:	b8 10 00 00 00       	mov    $0x10,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <close>:
SYSCALL(close)
 33d:	b8 15 00 00 00       	mov    $0x15,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <kill>:
SYSCALL(kill)
 345:	b8 06 00 00 00       	mov    $0x6,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <exec>:
SYSCALL(exec)
 34d:	b8 07 00 00 00       	mov    $0x7,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <open>:
SYSCALL(open)
 355:	b8 0f 00 00 00       	mov    $0xf,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mknod>:
SYSCALL(mknod)
 35d:	b8 11 00 00 00       	mov    $0x11,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <unlink>:
SYSCALL(unlink)
 365:	b8 12 00 00 00       	mov    $0x12,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <fstat>:
SYSCALL(fstat)
 36d:	b8 08 00 00 00       	mov    $0x8,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <link>:
SYSCALL(link)
 375:	b8 13 00 00 00       	mov    $0x13,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <mkdir>:
SYSCALL(mkdir)
 37d:	b8 14 00 00 00       	mov    $0x14,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <chdir>:
SYSCALL(chdir)
 385:	b8 09 00 00 00       	mov    $0x9,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <dup>:
SYSCALL(dup)
 38d:	b8 0a 00 00 00       	mov    $0xa,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <getpid>:
SYSCALL(getpid)
 395:	b8 0b 00 00 00       	mov    $0xb,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sbrk>:
SYSCALL(sbrk)
 39d:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <sleep>:
SYSCALL(sleep)
 3a5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <uptime>:
SYSCALL(uptime)
 3ad:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <date>:
SYSCALL(date)
 3b5:	b8 16 00 00 00       	mov    $0x16,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <dup2>:
SYSCALL(dup2)
 3bd:	b8 17 00 00 00       	mov    $0x17,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <phmem>:
SYSCALL(phmem)
 3c5:	b8 18 00 00 00       	mov    $0x18,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getprio>:
SYSCALL(getprio)
 3cd:	b8 19 00 00 00       	mov    $0x19,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <setprio>:
SYSCALL(setprio)
 3d5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 1c             	sub    $0x1c,%esp
 3e3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3e6:	6a 01                	push   $0x1
 3e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3eb:	52                   	push   %edx
 3ec:	50                   	push   %eax
 3ed:	e8 43 ff ff ff       	call   335 <write>
}
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	57                   	push   %edi
 3fb:	56                   	push   %esi
 3fc:	53                   	push   %ebx
 3fd:	83 ec 2c             	sub    $0x2c,%esp
 400:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 403:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 409:	74 04                	je     40f <printint+0x18>
 40b:	85 d2                	test   %edx,%edx
 40d:	78 3c                	js     44b <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40f:	89 d1                	mov    %edx,%ecx
  neg = 0;
 411:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 418:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 41d:	89 c8                	mov    %ecx,%eax
 41f:	ba 00 00 00 00       	mov    $0x0,%edx
 424:	f7 f6                	div    %esi
 426:	89 df                	mov    %ebx,%edi
 428:	43                   	inc    %ebx
 429:	8a 92 68 06 00 00    	mov    0x668(%edx),%dl
 42f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 433:	89 ca                	mov    %ecx,%edx
 435:	89 c1                	mov    %eax,%ecx
 437:	39 d6                	cmp    %edx,%esi
 439:	76 e2                	jbe    41d <printint+0x26>
  if(neg)
 43b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 43f:	74 24                	je     465 <printint+0x6e>
    buf[i++] = '-';
 441:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 446:	8d 5f 02             	lea    0x2(%edi),%ebx
 449:	eb 1a                	jmp    465 <printint+0x6e>
    x = -xx;
 44b:	89 d1                	mov    %edx,%ecx
 44d:	f7 d9                	neg    %ecx
    neg = 1;
 44f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 456:	eb c0                	jmp    418 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 458:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 45d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 460:	e8 78 ff ff ff       	call   3dd <putc>
  while(--i >= 0)
 465:	4b                   	dec    %ebx
 466:	79 f0                	jns    458 <printint+0x61>
}
 468:	83 c4 2c             	add    $0x2c,%esp
 46b:	5b                   	pop    %ebx
 46c:	5e                   	pop    %esi
 46d:	5f                   	pop    %edi
 46e:	5d                   	pop    %ebp
 46f:	c3                   	ret    

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 479:	8d 45 10             	lea    0x10(%ebp),%eax
 47c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 47f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 484:	bb 00 00 00 00       	mov    $0x0,%ebx
 489:	eb 12                	jmp    49d <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 48b:	89 fa                	mov    %edi,%edx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	e8 48 ff ff ff       	call   3dd <putc>
 495:	eb 05                	jmp    49c <printf+0x2c>
      }
    } else if(state == '%'){
 497:	83 fe 25             	cmp    $0x25,%esi
 49a:	74 22                	je     4be <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 49c:	43                   	inc    %ebx
 49d:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a0:	8a 04 18             	mov    (%eax,%ebx,1),%al
 4a3:	84 c0                	test   %al,%al
 4a5:	0f 84 1d 01 00 00    	je     5c8 <printf+0x158>
    c = fmt[i] & 0xff;
 4ab:	0f be f8             	movsbl %al,%edi
 4ae:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4b1:	85 f6                	test   %esi,%esi
 4b3:	75 e2                	jne    497 <printf+0x27>
      if(c == '%'){
 4b5:	83 f8 25             	cmp    $0x25,%eax
 4b8:	75 d1                	jne    48b <printf+0x1b>
        state = '%';
 4ba:	89 c6                	mov    %eax,%esi
 4bc:	eb de                	jmp    49c <printf+0x2c>
      if(c == 'd'){
 4be:	83 f8 25             	cmp    $0x25,%eax
 4c1:	0f 84 cc 00 00 00    	je     593 <printf+0x123>
 4c7:	0f 8c da 00 00 00    	jl     5a7 <printf+0x137>
 4cd:	83 f8 78             	cmp    $0x78,%eax
 4d0:	0f 8f d1 00 00 00    	jg     5a7 <printf+0x137>
 4d6:	83 f8 63             	cmp    $0x63,%eax
 4d9:	0f 8c c8 00 00 00    	jl     5a7 <printf+0x137>
 4df:	83 e8 63             	sub    $0x63,%eax
 4e2:	83 f8 15             	cmp    $0x15,%eax
 4e5:	0f 87 bc 00 00 00    	ja     5a7 <printf+0x137>
 4eb:	ff 24 85 10 06 00 00 	jmp    *0x610(,%eax,4)
        printint(fd, *ap, 10, 1);
 4f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f5:	8b 17                	mov    (%edi),%edx
 4f7:	83 ec 0c             	sub    $0xc,%esp
 4fa:	6a 01                	push   $0x1
 4fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	e8 ee fe ff ff       	call   3f7 <printint>
        ap++;
 509:	83 c7 04             	add    $0x4,%edi
 50c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 50f:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 512:	be 00 00 00 00       	mov    $0x0,%esi
 517:	eb 83                	jmp    49c <printf+0x2c>
        printint(fd, *ap, 16, 0);
 519:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 51c:	8b 17                	mov    (%edi),%edx
 51e:	83 ec 0c             	sub    $0xc,%esp
 521:	6a 00                	push   $0x0
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	e8 c7 fe ff ff       	call   3f7 <printint>
        ap++;
 530:	83 c7 04             	add    $0x4,%edi
 533:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 536:	83 c4 10             	add    $0x10,%esp
      state = 0;
 539:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 53e:	e9 59 ff ff ff       	jmp    49c <printf+0x2c>
        s = (char*)*ap;
 543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 546:	8b 30                	mov    (%eax),%esi
        ap++;
 548:	83 c0 04             	add    $0x4,%eax
 54b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 54e:	85 f6                	test   %esi,%esi
 550:	75 13                	jne    565 <printf+0xf5>
          s = "(null)";
 552:	be 07 06 00 00       	mov    $0x607,%esi
 557:	eb 0c                	jmp    565 <printf+0xf5>
          putc(fd, *s);
 559:	0f be d2             	movsbl %dl,%edx
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	e8 79 fe ff ff       	call   3dd <putc>
          s++;
 564:	46                   	inc    %esi
        while(*s != 0){
 565:	8a 16                	mov    (%esi),%dl
 567:	84 d2                	test   %dl,%dl
 569:	75 ee                	jne    559 <printf+0xe9>
      state = 0;
 56b:	be 00 00 00 00       	mov    $0x0,%esi
 570:	e9 27 ff ff ff       	jmp    49c <printf+0x2c>
        putc(fd, *ap);
 575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 578:	0f be 17             	movsbl (%edi),%edx
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	e8 5a fe ff ff       	call   3dd <putc>
        ap++;
 583:	83 c7 04             	add    $0x4,%edi
 586:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 589:	be 00 00 00 00       	mov    $0x0,%esi
 58e:	e9 09 ff ff ff       	jmp    49c <printf+0x2c>
        putc(fd, c);
 593:	89 fa                	mov    %edi,%edx
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	e8 40 fe ff ff       	call   3dd <putc>
      state = 0;
 59d:	be 00 00 00 00       	mov    $0x0,%esi
 5a2:	e9 f5 fe ff ff       	jmp    49c <printf+0x2c>
        putc(fd, '%');
 5a7:	ba 25 00 00 00       	mov    $0x25,%edx
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	e8 29 fe ff ff       	call   3dd <putc>
        putc(fd, c);
 5b4:	89 fa                	mov    %edi,%edx
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	e8 1f fe ff ff       	call   3dd <putc>
      state = 0;
 5be:	be 00 00 00 00       	mov    $0x0,%esi
 5c3:	e9 d4 fe ff ff       	jmp    49c <printf+0x2c>
    }
  }
}
 5c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cb:	5b                   	pop    %ebx
 5cc:	5e                   	pop    %esi
 5cd:	5f                   	pop    %edi
 5ce:	5d                   	pop    %ebp
 5cf:	c3                   	ret    
