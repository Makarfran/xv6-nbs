
grep:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 29 00 00 00       	call   45 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 15                	jne    38 <matchstar+0x38>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	8a 13                	mov    (%ebx),%dl
  25:	84 d2                	test   %dl,%dl
  27:	74 14                	je     3d <matchstar+0x3d>
  29:	43                   	inc    %ebx
  2a:	0f be d2             	movsbl %dl,%edx
  2d:	39 f2                	cmp    %esi,%edx
  2f:	74 e1                	je     12 <matchstar+0x12>
  31:	83 fe 2e             	cmp    $0x2e,%esi
  34:	74 dc                	je     12 <matchstar+0x12>
  36:	eb 05                	jmp    3d <matchstar+0x3d>
      return 1;
  38:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40:	5b                   	pop    %ebx
  41:	5e                   	pop    %esi
  42:	5f                   	pop    %edi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret    

00000045 <matchhere>:
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  4e:	8a 02                	mov    (%edx),%al
  50:	84 c0                	test   %al,%al
  52:	74 62                	je     b6 <matchhere+0x71>
  if(re[1] == '*')
  54:	8a 4a 01             	mov    0x1(%edx),%cl
  57:	80 f9 2a             	cmp    $0x2a,%cl
  5a:	74 1c                	je     78 <matchhere+0x33>
  if(re[0] == '$' && re[1] == '\0')
  5c:	3c 24                	cmp    $0x24,%al
  5e:	74 30                	je     90 <matchhere+0x4b>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  63:	8a 09                	mov    (%ecx),%cl
  65:	84 c9                	test   %cl,%cl
  67:	74 54                	je     bd <matchhere+0x78>
  69:	3c 2e                	cmp    $0x2e,%al
  6b:	74 35                	je     a2 <matchhere+0x5d>
  6d:	38 c8                	cmp    %cl,%al
  6f:	74 31                	je     a2 <matchhere+0x5d>
  return 0;
  71:	b8 00 00 00 00       	mov    $0x0,%eax
  76:	eb 43                	jmp    bb <matchhere+0x76>
    return matchstar(re[0], re+2, text);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	ff 75 0c             	push   0xc(%ebp)
  7e:	83 c2 02             	add    $0x2,%edx
  81:	52                   	push   %edx
  82:	0f be c0             	movsbl %al,%eax
  85:	50                   	push   %eax
  86:	e8 75 ff ff ff       	call   0 <matchstar>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb 2b                	jmp    bb <matchhere+0x76>
  if(re[0] == '$' && re[1] == '\0')
  90:	84 c9                	test   %cl,%cl
  92:	75 cc                	jne    60 <matchhere+0x1b>
    return *text == '\0';
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	80 38 00             	cmpb   $0x0,(%eax)
  9a:	0f 94 c0             	sete   %al
  9d:	0f b6 c0             	movzbl %al,%eax
  a0:	eb 19                	jmp    bb <matchhere+0x76>
    return matchhere(re+1, text+1);
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  a8:	40                   	inc    %eax
  a9:	50                   	push   %eax
  aa:	42                   	inc    %edx
  ab:	52                   	push   %edx
  ac:	e8 94 ff ff ff       	call   45 <matchhere>
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	eb 05                	jmp    bb <matchhere+0x76>
    return 1;
  b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	eb f7                	jmp    bb <matchhere+0x76>

000000c4 <match>:
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	56                   	push   %esi
  c8:	53                   	push   %ebx
  c9:	8b 75 08             	mov    0x8(%ebp),%esi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  cf:	80 3e 5e             	cmpb   $0x5e,(%esi)
  d2:	75 12                	jne    e6 <match+0x22>
    return matchhere(re+1, text);
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	53                   	push   %ebx
  d8:	46                   	inc    %esi
  d9:	56                   	push   %esi
  da:	e8 66 ff ff ff       	call   45 <matchhere>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 22                	jmp    106 <match+0x42>
  }while(*text++ != '\0');
  e4:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	53                   	push   %ebx
  ea:	56                   	push   %esi
  eb:	e8 55 ff ff ff       	call   45 <matchhere>
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	85 c0                	test   %eax,%eax
  f5:	75 0a                	jne    101 <match+0x3d>
  }while(*text++ != '\0');
  f7:	8d 53 01             	lea    0x1(%ebx),%edx
  fa:	80 3b 00             	cmpb   $0x0,(%ebx)
  fd:	75 e5                	jne    e4 <match+0x20>
  ff:	eb 05                	jmp    106 <match+0x42>
      return 1;
 101:	b8 01 00 00 00       	mov    $0x1,%eax
}
 106:	8d 65 f8             	lea    -0x8(%ebp),%esp
 109:	5b                   	pop    %ebx
 10a:	5e                   	pop    %esi
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <grep>:
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	57                   	push   %edi
 111:	56                   	push   %esi
 112:	53                   	push   %ebx
 113:	83 ec 1c             	sub    $0x1c,%esp
 116:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 119:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 120:	eb 53                	jmp    175 <grep+0x68>
      p = q+1;
 122:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 125:	83 ec 08             	sub    $0x8,%esp
 128:	6a 0a                	push   $0xa
 12a:	56                   	push   %esi
 12b:	e8 0b 02 00 00       	call   33b <strchr>
 130:	89 c3                	mov    %eax,%ebx
 132:	83 c4 10             	add    $0x10,%esp
 135:	85 c0                	test   %eax,%eax
 137:	74 2d                	je     166 <grep+0x59>
      *q = 0;
 139:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	56                   	push   %esi
 140:	57                   	push   %edi
 141:	e8 7e ff ff ff       	call   c4 <match>
 146:	83 c4 10             	add    $0x10,%esp
 149:	85 c0                	test   %eax,%eax
 14b:	74 d5                	je     122 <grep+0x15>
        *q = '\n';
 14d:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 150:	8d 43 01             	lea    0x1(%ebx),%eax
 153:	83 ec 04             	sub    $0x4,%esp
 156:	29 f0                	sub    %esi,%eax
 158:	50                   	push   %eax
 159:	56                   	push   %esi
 15a:	6a 01                	push   $0x1
 15c:	e8 0d 03 00 00       	call   46e <write>
 161:	83 c4 10             	add    $0x10,%esp
 164:	eb bc                	jmp    122 <grep+0x15>
    if(p == buf)
 166:	81 fe a0 0a 00 00    	cmp    $0xaa0,%esi
 16c:	74 62                	je     1d0 <grep+0xc3>
    if(m > 0){
 16e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 171:	85 c9                	test   %ecx,%ecx
 173:	7f 3b                	jg     1b0 <grep+0xa3>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 175:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 17a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 17d:	29 c8                	sub    %ecx,%eax
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	50                   	push   %eax
 183:	8d 81 a0 0a 00 00    	lea    0xaa0(%ecx),%eax
 189:	50                   	push   %eax
 18a:	ff 75 0c             	push   0xc(%ebp)
 18d:	e8 d4 02 00 00       	call   466 <read>
 192:	83 c4 10             	add    $0x10,%esp
 195:	85 c0                	test   %eax,%eax
 197:	7e 40                	jle    1d9 <grep+0xcc>
    m += n;
 199:	01 45 e4             	add    %eax,-0x1c(%ebp)
 19c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 19f:	c6 82 a0 0a 00 00 00 	movb   $0x0,0xaa0(%edx)
    p = buf;
 1a6:	be a0 0a 00 00       	mov    $0xaa0,%esi
    while((q = strchr(p, '\n')) != 0){
 1ab:	e9 75 ff ff ff       	jmp    125 <grep+0x18>
      m -= p - buf;
 1b0:	89 f0                	mov    %esi,%eax
 1b2:	2d a0 0a 00 00       	sub    $0xaa0,%eax
 1b7:	29 c1                	sub    %eax,%ecx
 1b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 1bc:	83 ec 04             	sub    $0x4,%esp
 1bf:	51                   	push   %ecx
 1c0:	56                   	push   %esi
 1c1:	68 a0 0a 00 00       	push   $0xaa0
 1c6:	e8 52 02 00 00       	call   41d <memmove>
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	eb a5                	jmp    175 <grep+0x68>
      m = 0;
 1d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1d7:	eb 9c                	jmp    175 <grep+0x68>
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <main>:
{
 1e1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e5:	83 e4 f0             	and    $0xfffffff0,%esp
 1e8:	ff 71 fc             	push   -0x4(%ecx)
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	57                   	push   %edi
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	51                   	push   %ecx
 1f2:	83 ec 18             	sub    $0x18,%esp
 1f5:	8b 01                	mov    (%ecx),%eax
 1f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1fa:	8b 51 04             	mov    0x4(%ecx),%edx
 1fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 200:	83 f8 01             	cmp    $0x1,%eax
 203:	7e 16                	jle    21b <main+0x3a>
  pattern = argv[1];
 205:	8b 45 e0             	mov    -0x20(%ebp),%eax
 208:	8b 40 04             	mov    0x4(%eax),%eax
 20b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 20e:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 212:	7e 27                	jle    23b <main+0x5a>
{
 214:	be 02 00 00 00       	mov    $0x2,%esi
 219:	eb 54                	jmp    26f <main+0x8e>
    printf(2, "usage: grep pattern [file ...]\n");
 21b:	83 ec 08             	sub    $0x8,%esp
 21e:	68 0c 07 00 00       	push   $0x70c
 223:	6a 02                	push   $0x2
 225:	e8 7f 03 00 00       	call   5a9 <printf>
    exit(0);
 22a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 231:	e8 18 02 00 00       	call   44e <exit>
 236:	83 c4 10             	add    $0x10,%esp
 239:	eb ca                	jmp    205 <main+0x24>
    grep(pattern, 0);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	6a 00                	push   $0x0
 240:	50                   	push   %eax
 241:	e8 c7 fe ff ff       	call   10d <grep>
    exit(0);
 246:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24d:	e8 fc 01 00 00       	call   44e <exit>
 252:	83 c4 10             	add    $0x10,%esp
 255:	eb bd                	jmp    214 <main+0x33>
    grep(pattern, fd);
 257:	83 ec 08             	sub    $0x8,%esp
 25a:	53                   	push   %ebx
 25b:	ff 75 dc             	push   -0x24(%ebp)
 25e:	e8 aa fe ff ff       	call   10d <grep>
    close(fd);
 263:	89 1c 24             	mov    %ebx,(%esp)
 266:	e8 0b 02 00 00       	call   476 <close>
  for(i = 2; i < argc; i++){
 26b:	46                   	inc    %esi
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 272:	7d 3d                	jge    2b1 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 274:	8b 45 e0             	mov    -0x20(%ebp),%eax
 277:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 27a:	83 ec 08             	sub    $0x8,%esp
 27d:	6a 00                	push   $0x0
 27f:	ff 37                	push   (%edi)
 281:	e8 08 02 00 00       	call   48e <open>
 286:	89 c3                	mov    %eax,%ebx
 288:	83 c4 10             	add    $0x10,%esp
 28b:	85 c0                	test   %eax,%eax
 28d:	79 c8                	jns    257 <main+0x76>
      printf(1, "grep: cannot open %s\n", argv[i]);
 28f:	83 ec 04             	sub    $0x4,%esp
 292:	ff 37                	push   (%edi)
 294:	68 2c 07 00 00       	push   $0x72c
 299:	6a 01                	push   $0x1
 29b:	e8 09 03 00 00       	call   5a9 <printf>
      exit(0);
 2a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a7:	e8 a2 01 00 00       	call   44e <exit>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	eb a6                	jmp    257 <main+0x76>
  exit(0);
 2b1:	83 ec 0c             	sub    $0xc,%esp
 2b4:	6a 00                	push   $0x0
 2b6:	e8 93 01 00 00       	call   44e <exit>
}
 2bb:	b8 00 00 00 00       	mov    $0x0,%eax
 2c0:	8d 65 f0             	lea    -0x10(%ebp),%esp
 2c3:	59                   	pop    %ecx
 2c4:	5b                   	pop    %ebx
 2c5:	5e                   	pop    %esi
 2c6:	5f                   	pop    %edi
 2c7:	5d                   	pop    %ebp
 2c8:	8d 61 fc             	lea    -0x4(%ecx),%esp
 2cb:	c3                   	ret    

000002cc <start>:

// Entry point of the library	
void
start()
{
}
 2cc:	c3                   	ret    

000002cd <strcpy>:

char*
strcpy(char *s, const char *t)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d8:	89 c2                	mov    %eax,%edx
 2da:	89 cb                	mov    %ecx,%ebx
 2dc:	41                   	inc    %ecx
 2dd:	89 d6                	mov    %edx,%esi
 2df:	42                   	inc    %edx
 2e0:	8a 1b                	mov    (%ebx),%bl
 2e2:	88 1e                	mov    %bl,(%esi)
 2e4:	84 db                	test   %bl,%bl
 2e6:	75 f2                	jne    2da <strcpy+0xd>
    ;
  return os;
}
 2e8:	5b                   	pop    %ebx
 2e9:	5e                   	pop    %esi
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    

000002ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2f5:	eb 02                	jmp    2f9 <strcmp+0xd>
    p++, q++;
 2f7:	41                   	inc    %ecx
 2f8:	42                   	inc    %edx
  while(*p && *p == *q)
 2f9:	8a 01                	mov    (%ecx),%al
 2fb:	84 c0                	test   %al,%al
 2fd:	74 04                	je     303 <strcmp+0x17>
 2ff:	3a 02                	cmp    (%edx),%al
 301:	74 f4                	je     2f7 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 303:	0f b6 c0             	movzbl %al,%eax
 306:	0f b6 12             	movzbl (%edx),%edx
 309:	29 d0                	sub    %edx,%eax
}
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    

0000030d <strlen>:

uint
strlen(const char *s)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 313:	b8 00 00 00 00       	mov    $0x0,%eax
 318:	eb 01                	jmp    31b <strlen+0xe>
 31a:	40                   	inc    %eax
 31b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 31f:	75 f9                	jne    31a <strlen+0xd>
    ;
  return n;
}
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    

00000323 <memset>:

void*
memset(void *dst, int c, uint n)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 7d 08             	mov    0x8(%ebp),%edi
 32a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	fc                   	cld    
 331:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	8b 7d fc             	mov    -0x4(%ebp),%edi
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <strchr>:

char*
strchr(const char *s, char c)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 344:	eb 01                	jmp    347 <strchr+0xc>
 346:	40                   	inc    %eax
 347:	8a 10                	mov    (%eax),%dl
 349:	84 d2                	test   %dl,%dl
 34b:	74 06                	je     353 <strchr+0x18>
    if(*s == c)
 34d:	38 ca                	cmp    %cl,%dl
 34f:	75 f5                	jne    346 <strchr+0xb>
 351:	eb 05                	jmp    358 <strchr+0x1d>
      return (char*)s;
  return 0;
 353:	b8 00 00 00 00       	mov    $0x0,%eax
}
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    

0000035a <gets>:

char*
gets(char *buf, int max)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	57                   	push   %edi
 35e:	56                   	push   %esi
 35f:	53                   	push   %ebx
 360:	83 ec 1c             	sub    $0x1c,%esp
 363:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	bb 00 00 00 00       	mov    $0x0,%ebx
 36b:	89 de                	mov    %ebx,%esi
 36d:	43                   	inc    %ebx
 36e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 371:	7d 2b                	jge    39e <gets+0x44>
    cc = read(0, &c, 1);
 373:	83 ec 04             	sub    $0x4,%esp
 376:	6a 01                	push   $0x1
 378:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37b:	50                   	push   %eax
 37c:	6a 00                	push   $0x0
 37e:	e8 e3 00 00 00       	call   466 <read>
    if(cc < 1)
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	7e 14                	jle    39e <gets+0x44>
      break;
    buf[i++] = c;
 38a:	8a 45 e7             	mov    -0x19(%ebp),%al
 38d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 390:	3c 0a                	cmp    $0xa,%al
 392:	74 08                	je     39c <gets+0x42>
 394:	3c 0d                	cmp    $0xd,%al
 396:	75 d3                	jne    36b <gets+0x11>
    buf[i++] = c;
 398:	89 de                	mov    %ebx,%esi
 39a:	eb 02                	jmp    39e <gets+0x44>
 39c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 39e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3a2:	89 f8                	mov    %edi,%eax
 3a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a7:	5b                   	pop    %ebx
 3a8:	5e                   	pop    %esi
 3a9:	5f                   	pop    %edi
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    

000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	56                   	push   %esi
 3b0:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b1:	83 ec 08             	sub    $0x8,%esp
 3b4:	6a 00                	push   $0x0
 3b6:	ff 75 08             	push   0x8(%ebp)
 3b9:	e8 d0 00 00 00       	call   48e <open>
  if(fd < 0)
 3be:	83 c4 10             	add    $0x10,%esp
 3c1:	85 c0                	test   %eax,%eax
 3c3:	78 24                	js     3e9 <stat+0x3d>
 3c5:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3c7:	83 ec 08             	sub    $0x8,%esp
 3ca:	ff 75 0c             	push   0xc(%ebp)
 3cd:	50                   	push   %eax
 3ce:	e8 d3 00 00 00       	call   4a6 <fstat>
 3d3:	89 c6                	mov    %eax,%esi
  close(fd);
 3d5:	89 1c 24             	mov    %ebx,(%esp)
 3d8:	e8 99 00 00 00       	call   476 <close>
  return r;
 3dd:	83 c4 10             	add    $0x10,%esp
}
 3e0:	89 f0                	mov    %esi,%eax
 3e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3e5:	5b                   	pop    %ebx
 3e6:	5e                   	pop    %esi
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    
    return -1;
 3e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ee:	eb f0                	jmp    3e0 <stat+0x34>

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 3f7:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3fc:	eb 0e                	jmp    40c <atoi+0x1c>
    n = n*10 + *s++ - '0';
 3fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
 401:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 404:	41                   	inc    %ecx
 405:	0f be c0             	movsbl %al,%eax
 408:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 40c:	8a 01                	mov    (%ecx),%al
 40e:	8d 58 d0             	lea    -0x30(%eax),%ebx
 411:	80 fb 09             	cmp    $0x9,%bl
 414:	76 e8                	jbe    3fe <atoi+0xe>
  return n;
}
 416:	89 d0                	mov    %edx,%eax
 418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	56                   	push   %esi
 421:	53                   	push   %ebx
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 428:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 42b:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 42d:	eb 0c                	jmp    43b <memmove+0x1e>
    *dst++ = *src++;
 42f:	8a 13                	mov    (%ebx),%dl
 431:	88 11                	mov    %dl,(%ecx)
 433:	8d 5b 01             	lea    0x1(%ebx),%ebx
 436:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 439:	89 f2                	mov    %esi,%edx
 43b:	8d 72 ff             	lea    -0x1(%edx),%esi
 43e:	85 d2                	test   %edx,%edx
 440:	7f ed                	jg     42f <memmove+0x12>
  return vdst;
}
 442:	5b                   	pop    %ebx
 443:	5e                   	pop    %esi
 444:	5d                   	pop    %ebp
 445:	c3                   	ret    

00000446 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 446:	b8 01 00 00 00       	mov    $0x1,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <exit>:
SYSCALL(exit)
 44e:	b8 02 00 00 00       	mov    $0x2,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <wait>:
SYSCALL(wait)
 456:	b8 03 00 00 00       	mov    $0x3,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <pipe>:
SYSCALL(pipe)
 45e:	b8 04 00 00 00       	mov    $0x4,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <read>:
SYSCALL(read)
 466:	b8 05 00 00 00       	mov    $0x5,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <write>:
SYSCALL(write)
 46e:	b8 10 00 00 00       	mov    $0x10,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <close>:
SYSCALL(close)
 476:	b8 15 00 00 00       	mov    $0x15,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <kill>:
SYSCALL(kill)
 47e:	b8 06 00 00 00       	mov    $0x6,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <exec>:
SYSCALL(exec)
 486:	b8 07 00 00 00       	mov    $0x7,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <open>:
SYSCALL(open)
 48e:	b8 0f 00 00 00       	mov    $0xf,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <mknod>:
SYSCALL(mknod)
 496:	b8 11 00 00 00       	mov    $0x11,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <unlink>:
SYSCALL(unlink)
 49e:	b8 12 00 00 00       	mov    $0x12,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <fstat>:
SYSCALL(fstat)
 4a6:	b8 08 00 00 00       	mov    $0x8,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <link>:
SYSCALL(link)
 4ae:	b8 13 00 00 00       	mov    $0x13,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <mkdir>:
SYSCALL(mkdir)
 4b6:	b8 14 00 00 00       	mov    $0x14,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <chdir>:
SYSCALL(chdir)
 4be:	b8 09 00 00 00       	mov    $0x9,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <dup>:
SYSCALL(dup)
 4c6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <getpid>:
SYSCALL(getpid)
 4ce:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <sbrk>:
SYSCALL(sbrk)
 4d6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <sleep>:
SYSCALL(sleep)
 4de:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <uptime>:
SYSCALL(uptime)
 4e6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <date>:
SYSCALL(date)
 4ee:	b8 16 00 00 00       	mov    $0x16,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <dup2>:
SYSCALL(dup2)
 4f6:	b8 17 00 00 00       	mov    $0x17,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <phmem>:
SYSCALL(phmem)
 4fe:	b8 18 00 00 00       	mov    $0x18,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <getprio>:
SYSCALL(getprio)
 506:	b8 19 00 00 00       	mov    $0x19,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <setprio>:
SYSCALL(setprio)
 50e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 1c             	sub    $0x1c,%esp
 51c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 51f:	6a 01                	push   $0x1
 521:	8d 55 f4             	lea    -0xc(%ebp),%edx
 524:	52                   	push   %edx
 525:	50                   	push   %eax
 526:	e8 43 ff ff ff       	call   46e <write>
}
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 2c             	sub    $0x2c,%esp
 539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 542:	74 04                	je     548 <printint+0x18>
 544:	85 d2                	test   %edx,%edx
 546:	78 3c                	js     584 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 548:	89 d1                	mov    %edx,%ecx
  neg = 0;
 54a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 551:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 556:	89 c8                	mov    %ecx,%eax
 558:	ba 00 00 00 00       	mov    $0x0,%edx
 55d:	f7 f6                	div    %esi
 55f:	89 df                	mov    %ebx,%edi
 561:	43                   	inc    %ebx
 562:	8a 92 a4 07 00 00    	mov    0x7a4(%edx),%dl
 568:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 56c:	89 ca                	mov    %ecx,%edx
 56e:	89 c1                	mov    %eax,%ecx
 570:	39 d6                	cmp    %edx,%esi
 572:	76 e2                	jbe    556 <printint+0x26>
  if(neg)
 574:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 578:	74 24                	je     59e <printint+0x6e>
    buf[i++] = '-';
 57a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 57f:	8d 5f 02             	lea    0x2(%edi),%ebx
 582:	eb 1a                	jmp    59e <printint+0x6e>
    x = -xx;
 584:	89 d1                	mov    %edx,%ecx
 586:	f7 d9                	neg    %ecx
    neg = 1;
 588:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 58f:	eb c0                	jmp    551 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 591:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 599:	e8 78 ff ff ff       	call   516 <putc>
  while(--i >= 0)
 59e:	4b                   	dec    %ebx
 59f:	79 f0                	jns    591 <printint+0x61>
}
 5a1:	83 c4 2c             	add    $0x2c,%esp
 5a4:	5b                   	pop    %ebx
 5a5:	5e                   	pop    %esi
 5a6:	5f                   	pop    %edi
 5a7:	5d                   	pop    %ebp
 5a8:	c3                   	ret    

000005a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	57                   	push   %edi
 5ad:	56                   	push   %esi
 5ae:	53                   	push   %ebx
 5af:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5b2:	8d 45 10             	lea    0x10(%ebp),%eax
 5b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5b8:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5bd:	bb 00 00 00 00       	mov    $0x0,%ebx
 5c2:	eb 12                	jmp    5d6 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5c4:	89 fa                	mov    %edi,%edx
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	e8 48 ff ff ff       	call   516 <putc>
 5ce:	eb 05                	jmp    5d5 <printf+0x2c>
      }
    } else if(state == '%'){
 5d0:	83 fe 25             	cmp    $0x25,%esi
 5d3:	74 22                	je     5f7 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 5d5:	43                   	inc    %ebx
 5d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d9:	8a 04 18             	mov    (%eax,%ebx,1),%al
 5dc:	84 c0                	test   %al,%al
 5de:	0f 84 1d 01 00 00    	je     701 <printf+0x158>
    c = fmt[i] & 0xff;
 5e4:	0f be f8             	movsbl %al,%edi
 5e7:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5ea:	85 f6                	test   %esi,%esi
 5ec:	75 e2                	jne    5d0 <printf+0x27>
      if(c == '%'){
 5ee:	83 f8 25             	cmp    $0x25,%eax
 5f1:	75 d1                	jne    5c4 <printf+0x1b>
        state = '%';
 5f3:	89 c6                	mov    %eax,%esi
 5f5:	eb de                	jmp    5d5 <printf+0x2c>
      if(c == 'd'){
 5f7:	83 f8 25             	cmp    $0x25,%eax
 5fa:	0f 84 cc 00 00 00    	je     6cc <printf+0x123>
 600:	0f 8c da 00 00 00    	jl     6e0 <printf+0x137>
 606:	83 f8 78             	cmp    $0x78,%eax
 609:	0f 8f d1 00 00 00    	jg     6e0 <printf+0x137>
 60f:	83 f8 63             	cmp    $0x63,%eax
 612:	0f 8c c8 00 00 00    	jl     6e0 <printf+0x137>
 618:	83 e8 63             	sub    $0x63,%eax
 61b:	83 f8 15             	cmp    $0x15,%eax
 61e:	0f 87 bc 00 00 00    	ja     6e0 <printf+0x137>
 624:	ff 24 85 4c 07 00 00 	jmp    *0x74c(,%eax,4)
        printint(fd, *ap, 10, 1);
 62b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 62e:	8b 17                	mov    (%edi),%edx
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	6a 01                	push   $0x1
 635:	b9 0a 00 00 00       	mov    $0xa,%ecx
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	e8 ee fe ff ff       	call   530 <printint>
        ap++;
 642:	83 c7 04             	add    $0x4,%edi
 645:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 648:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64b:	be 00 00 00 00       	mov    $0x0,%esi
 650:	eb 83                	jmp    5d5 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 655:	8b 17                	mov    (%edi),%edx
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	6a 00                	push   $0x0
 65c:	b9 10 00 00 00       	mov    $0x10,%ecx
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	e8 c7 fe ff ff       	call   530 <printint>
        ap++;
 669:	83 c7 04             	add    $0x4,%edi
 66c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 66f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 672:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 677:	e9 59 ff ff ff       	jmp    5d5 <printf+0x2c>
        s = (char*)*ap;
 67c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67f:	8b 30                	mov    (%eax),%esi
        ap++;
 681:	83 c0 04             	add    $0x4,%eax
 684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 687:	85 f6                	test   %esi,%esi
 689:	75 13                	jne    69e <printf+0xf5>
          s = "(null)";
 68b:	be 42 07 00 00       	mov    $0x742,%esi
 690:	eb 0c                	jmp    69e <printf+0xf5>
          putc(fd, *s);
 692:	0f be d2             	movsbl %dl,%edx
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	e8 79 fe ff ff       	call   516 <putc>
          s++;
 69d:	46                   	inc    %esi
        while(*s != 0){
 69e:	8a 16                	mov    (%esi),%dl
 6a0:	84 d2                	test   %dl,%dl
 6a2:	75 ee                	jne    692 <printf+0xe9>
      state = 0;
 6a4:	be 00 00 00 00       	mov    $0x0,%esi
 6a9:	e9 27 ff ff ff       	jmp    5d5 <printf+0x2c>
        putc(fd, *ap);
 6ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6b1:	0f be 17             	movsbl (%edi),%edx
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	e8 5a fe ff ff       	call   516 <putc>
        ap++;
 6bc:	83 c7 04             	add    $0x4,%edi
 6bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6c2:	be 00 00 00 00       	mov    $0x0,%esi
 6c7:	e9 09 ff ff ff       	jmp    5d5 <printf+0x2c>
        putc(fd, c);
 6cc:	89 fa                	mov    %edi,%edx
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	e8 40 fe ff ff       	call   516 <putc>
      state = 0;
 6d6:	be 00 00 00 00       	mov    $0x0,%esi
 6db:	e9 f5 fe ff ff       	jmp    5d5 <printf+0x2c>
        putc(fd, '%');
 6e0:	ba 25 00 00 00       	mov    $0x25,%edx
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	e8 29 fe ff ff       	call   516 <putc>
        putc(fd, c);
 6ed:	89 fa                	mov    %edi,%edx
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	e8 1f fe ff ff       	call   516 <putc>
      state = 0;
 6f7:	be 00 00 00 00       	mov    $0x0,%esi
 6fc:	e9 d4 fe ff ff       	jmp    5d5 <printf+0x2c>
    }
  }
}
 701:	8d 65 f4             	lea    -0xc(%ebp),%esp
 704:	5b                   	pop    %ebx
 705:	5e                   	pop    %esi
 706:	5f                   	pop    %edi
 707:	5d                   	pop    %ebp
 708:	c3                   	ret    
