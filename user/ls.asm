
ls:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 30 03 00 00       	call   341 <strlen>
  11:	01 d8                	add    %ebx,%eax
  13:	83 c4 10             	add    $0x10,%esp
  16:	eb 01                	jmp    19 <fmtname+0x19>
  18:	48                   	dec    %eax
  19:	39 d8                	cmp    %ebx,%eax
  1b:	72 05                	jb     22 <fmtname+0x22>
  1d:	80 38 2f             	cmpb   $0x2f,(%eax)
  20:	75 f6                	jne    18 <fmtname+0x18>
    ;
  p++;
  22:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	53                   	push   %ebx
  29:	e8 13 03 00 00       	call   341 <strlen>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	83 f8 0d             	cmp    $0xd,%eax
  34:	76 09                	jbe    3f <fmtname+0x3f>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  36:	89 d8                	mov    %ebx,%eax
  38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3b:	5b                   	pop    %ebx
  3c:	5e                   	pop    %esi
  3d:	5d                   	pop    %ebp
  3e:	c3                   	ret    
  memmove(buf, p, strlen(p));
  3f:	83 ec 0c             	sub    $0xc,%esp
  42:	53                   	push   %ebx
  43:	e8 f9 02 00 00       	call   341 <strlen>
  48:	83 c4 0c             	add    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	53                   	push   %ebx
  4d:	68 98 0a 00 00       	push   $0xa98
  52:	e8 fa 03 00 00       	call   451 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  57:	89 1c 24             	mov    %ebx,(%esp)
  5a:	e8 e2 02 00 00       	call   341 <strlen>
  5f:	89 c6                	mov    %eax,%esi
  61:	89 1c 24             	mov    %ebx,(%esp)
  64:	e8 d8 02 00 00       	call   341 <strlen>
  69:	83 c4 0c             	add    $0xc,%esp
  6c:	ba 0e 00 00 00       	mov    $0xe,%edx
  71:	29 f2                	sub    %esi,%edx
  73:	52                   	push   %edx
  74:	6a 20                	push   $0x20
  76:	05 98 0a 00 00       	add    $0xa98,%eax
  7b:	50                   	push   %eax
  7c:	e8 d6 02 00 00       	call   357 <memset>
  return buf;
  81:	83 c4 10             	add    $0x10,%esp
  84:	bb 98 0a 00 00       	mov    $0xa98,%ebx
  89:	eb ab                	jmp    36 <fmtname+0x36>

0000008b <ls>:

void
ls(char *path)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	57                   	push   %edi
  8f:	56                   	push   %esi
  90:	53                   	push   %ebx
  91:	81 ec 54 02 00 00    	sub    $0x254,%esp
  97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  9a:	6a 00                	push   $0x0
  9c:	53                   	push   %ebx
  9d:	e8 20 04 00 00       	call   4c2 <open>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	85 c0                	test   %eax,%eax
  a7:	0f 88 8b 00 00 00    	js     138 <ls+0xad>
  ad:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  af:	83 ec 08             	sub    $0x8,%esp
  b2:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  b8:	50                   	push   %eax
  b9:	57                   	push   %edi
  ba:	e8 1b 04 00 00       	call   4da <fstat>
  bf:	83 c4 10             	add    $0x10,%esp
  c2:	85 c0                	test   %eax,%eax
  c4:	0f 88 83 00 00 00    	js     14d <ls+0xc2>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ca:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
  d0:	0f bf f0             	movswl %ax,%esi
  d3:	66 83 f8 01          	cmp    $0x1,%ax
  d7:	0f 84 8d 00 00 00    	je     16a <ls+0xdf>
  dd:	66 83 f8 02          	cmp    $0x2,%ax
  e1:	75 41                	jne    124 <ls+0x99>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  e3:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  e9:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  ef:	8b 8d cc fd ff ff    	mov    -0x234(%ebp),%ecx
  f5:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
  fb:	83 ec 0c             	sub    $0xc,%esp
  fe:	53                   	push   %ebx
  ff:	e8 fc fe ff ff       	call   0 <fmtname>
 104:	83 c4 08             	add    $0x8,%esp
 107:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 10d:	ff b5 b0 fd ff ff    	push   -0x250(%ebp)
 113:	56                   	push   %esi
 114:	50                   	push   %eax
 115:	68 68 07 00 00       	push   $0x768
 11a:	6a 01                	push   $0x1
 11c:	e8 bc 04 00 00       	call   5dd <printf>
    break;
 121:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	57                   	push   %edi
 128:	e8 7d 03 00 00       	call   4aa <close>
 12d:	83 c4 10             	add    $0x10,%esp
}
 130:	8d 65 f4             	lea    -0xc(%ebp),%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5f                   	pop    %edi
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	53                   	push   %ebx
 13c:	68 40 07 00 00       	push   $0x740
 141:	6a 02                	push   $0x2
 143:	e8 95 04 00 00       	call   5dd <printf>
    return;
 148:	83 c4 10             	add    $0x10,%esp
 14b:	eb e3                	jmp    130 <ls+0xa5>
    printf(2, "ls: cannot stat %s\n", path);
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	53                   	push   %ebx
 151:	68 54 07 00 00       	push   $0x754
 156:	6a 02                	push   $0x2
 158:	e8 80 04 00 00       	call   5dd <printf>
    close(fd);
 15d:	89 3c 24             	mov    %edi,(%esp)
 160:	e8 45 03 00 00       	call   4aa <close>
    return;
 165:	83 c4 10             	add    $0x10,%esp
 168:	eb c6                	jmp    130 <ls+0xa5>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 16a:	83 ec 0c             	sub    $0xc,%esp
 16d:	53                   	push   %ebx
 16e:	e8 ce 01 00 00       	call   341 <strlen>
 173:	83 c0 10             	add    $0x10,%eax
 176:	83 c4 10             	add    $0x10,%esp
 179:	3d 00 02 00 00       	cmp    $0x200,%eax
 17e:	76 14                	jbe    194 <ls+0x109>
      printf(1, "ls: path too long\n");
 180:	83 ec 08             	sub    $0x8,%esp
 183:	68 75 07 00 00       	push   $0x775
 188:	6a 01                	push   $0x1
 18a:	e8 4e 04 00 00       	call   5dd <printf>
      break;
 18f:	83 c4 10             	add    $0x10,%esp
 192:	eb 90                	jmp    124 <ls+0x99>
    strcpy(buf, path);
 194:	83 ec 08             	sub    $0x8,%esp
 197:	53                   	push   %ebx
 198:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
 19e:	53                   	push   %ebx
 19f:	e8 5d 01 00 00       	call   301 <strcpy>
    p = buf+strlen(buf);
 1a4:	89 1c 24             	mov    %ebx,(%esp)
 1a7:	e8 95 01 00 00       	call   341 <strlen>
 1ac:	8d 34 03             	lea    (%ebx,%eax,1),%esi
    *p++ = '/';
 1af:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
 1b3:	89 85 ac fd ff ff    	mov    %eax,-0x254(%ebp)
 1b9:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 19                	jmp    1da <ls+0x14f>
        printf(1, "ls: cannot stat %s\n", buf);
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1ca:	50                   	push   %eax
 1cb:	68 54 07 00 00       	push   $0x754
 1d0:	6a 01                	push   $0x1
 1d2:	e8 06 04 00 00       	call   5dd <printf>
        continue;
 1d7:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	6a 10                	push   $0x10
 1df:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 1e5:	50                   	push   %eax
 1e6:	57                   	push   %edi
 1e7:	e8 ae 02 00 00       	call   49a <read>
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	83 f8 10             	cmp    $0x10,%eax
 1f2:	0f 85 2c ff ff ff    	jne    124 <ls+0x99>
      if(de.inum == 0)
 1f8:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1ff:	00 
 200:	74 d8                	je     1da <ls+0x14f>
      memmove(p, de.name, DIRSIZ);
 202:	83 ec 04             	sub    $0x4,%esp
 205:	6a 0e                	push   $0xe
 207:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	ff b5 ac fd ff ff    	push   -0x254(%ebp)
 214:	e8 38 02 00 00       	call   451 <memmove>
      p[DIRSIZ] = 0;
 219:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 21d:	83 c4 08             	add    $0x8,%esp
 220:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 226:	50                   	push   %eax
 227:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 22d:	50                   	push   %eax
 22e:	e8 ad 01 00 00       	call   3e0 <stat>
 233:	83 c4 10             	add    $0x10,%esp
 236:	85 c0                	test   %eax,%eax
 238:	78 87                	js     1c1 <ls+0x136>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 23a:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 240:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 246:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 24c:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 252:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 258:	83 ec 0c             	sub    $0xc,%esp
 25b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 261:	50                   	push   %eax
 262:	e8 99 fd ff ff       	call   0 <fmtname>
 267:	83 c4 08             	add    $0x8,%esp
 26a:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 270:	ff b5 b0 fd ff ff    	push   -0x250(%ebp)
 276:	0f bf db             	movswl %bx,%ebx
 279:	53                   	push   %ebx
 27a:	50                   	push   %eax
 27b:	68 68 07 00 00       	push   $0x768
 280:	6a 01                	push   $0x1
 282:	e8 56 03 00 00       	call   5dd <printf>
 287:	83 c4 20             	add    $0x20,%esp
 28a:	e9 4b ff ff ff       	jmp    1da <ls+0x14f>

0000028f <main>:

int
main(int argc, char *argv[])
{
 28f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 293:	83 e4 f0             	and    $0xfffffff0,%esp
 296:	ff 71 fc             	push   -0x4(%ecx)
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	57                   	push   %edi
 29d:	56                   	push   %esi
 29e:	53                   	push   %ebx
 29f:	51                   	push   %ecx
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	8b 31                	mov    (%ecx),%esi
 2a5:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
 2a8:	83 fe 01             	cmp    $0x1,%esi
 2ab:	7e 07                	jle    2b4 <main+0x25>
{
 2ad:	bb 01 00 00 00       	mov    $0x1,%ebx
 2b2:	eb 2d                	jmp    2e1 <main+0x52>
    ls(".");
 2b4:	83 ec 0c             	sub    $0xc,%esp
 2b7:	68 88 07 00 00       	push   $0x788
 2bc:	e8 ca fd ff ff       	call   8b <ls>
    exit(0);
 2c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2c8:	e8 b5 01 00 00       	call   482 <exit>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	eb db                	jmp    2ad <main+0x1e>
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2d2:	83 ec 0c             	sub    $0xc,%esp
 2d5:	ff 34 9f             	push   (%edi,%ebx,4)
 2d8:	e8 ae fd ff ff       	call   8b <ls>
  for(i=1; i<argc; i++)
 2dd:	43                   	inc    %ebx
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	39 f3                	cmp    %esi,%ebx
 2e3:	7c ed                	jl     2d2 <main+0x43>
  exit(0);
 2e5:	83 ec 0c             	sub    $0xc,%esp
 2e8:	6a 00                	push   $0x0
 2ea:	e8 93 01 00 00       	call   482 <exit>
}
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
 2f4:	8d 65 f0             	lea    -0x10(%ebp),%esp
 2f7:	59                   	pop    %ecx
 2f8:	5b                   	pop    %ebx
 2f9:	5e                   	pop    %esi
 2fa:	5f                   	pop    %edi
 2fb:	5d                   	pop    %ebp
 2fc:	8d 61 fc             	lea    -0x4(%ecx),%esp
 2ff:	c3                   	ret    

00000300 <start>:

// Entry point of the library	
void
start()
{
}
 300:	c3                   	ret    

00000301 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	56                   	push   %esi
 305:	53                   	push   %ebx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 30c:	89 c2                	mov    %eax,%edx
 30e:	89 cb                	mov    %ecx,%ebx
 310:	41                   	inc    %ecx
 311:	89 d6                	mov    %edx,%esi
 313:	42                   	inc    %edx
 314:	8a 1b                	mov    (%ebx),%bl
 316:	88 1e                	mov    %bl,(%esi)
 318:	84 db                	test   %bl,%bl
 31a:	75 f2                	jne    30e <strcpy+0xd>
    ;
  return os;
}
 31c:	5b                   	pop    %ebx
 31d:	5e                   	pop    %esi
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    

00000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
 326:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 329:	eb 02                	jmp    32d <strcmp+0xd>
    p++, q++;
 32b:	41                   	inc    %ecx
 32c:	42                   	inc    %edx
  while(*p && *p == *q)
 32d:	8a 01                	mov    (%ecx),%al
 32f:	84 c0                	test   %al,%al
 331:	74 04                	je     337 <strcmp+0x17>
 333:	3a 02                	cmp    (%edx),%al
 335:	74 f4                	je     32b <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 337:	0f b6 c0             	movzbl %al,%eax
 33a:	0f b6 12             	movzbl (%edx),%edx
 33d:	29 d0                	sub    %edx,%eax
}
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    

00000341 <strlen>:

uint
strlen(const char *s)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 347:	b8 00 00 00 00       	mov    $0x0,%eax
 34c:	eb 01                	jmp    34f <strlen+0xe>
 34e:	40                   	inc    %eax
 34f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 353:	75 f9                	jne    34e <strlen+0xd>
    ;
  return n;
}
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    

00000357 <memset>:

void*
memset(void *dst, int c, uint n)
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 35b:	8b 7d 08             	mov    0x8(%ebp),%edi
 35e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 361:	8b 45 0c             	mov    0xc(%ebp),%eax
 364:	fc                   	cld    
 365:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	8b 7d fc             	mov    -0x4(%ebp),%edi
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <strchr>:

char*
strchr(const char *s, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 378:	eb 01                	jmp    37b <strchr+0xc>
 37a:	40                   	inc    %eax
 37b:	8a 10                	mov    (%eax),%dl
 37d:	84 d2                	test   %dl,%dl
 37f:	74 06                	je     387 <strchr+0x18>
    if(*s == c)
 381:	38 ca                	cmp    %cl,%dl
 383:	75 f5                	jne    37a <strchr+0xb>
 385:	eb 05                	jmp    38c <strchr+0x1d>
      return (char*)s;
  return 0;
 387:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    

0000038e <gets>:

char*
gets(char *buf, int max)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	57                   	push   %edi
 392:	56                   	push   %esi
 393:	53                   	push   %ebx
 394:	83 ec 1c             	sub    $0x1c,%esp
 397:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39a:	bb 00 00 00 00       	mov    $0x0,%ebx
 39f:	89 de                	mov    %ebx,%esi
 3a1:	43                   	inc    %ebx
 3a2:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3a5:	7d 2b                	jge    3d2 <gets+0x44>
    cc = read(0, &c, 1);
 3a7:	83 ec 04             	sub    $0x4,%esp
 3aa:	6a 01                	push   $0x1
 3ac:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3af:	50                   	push   %eax
 3b0:	6a 00                	push   $0x0
 3b2:	e8 e3 00 00 00       	call   49a <read>
    if(cc < 1)
 3b7:	83 c4 10             	add    $0x10,%esp
 3ba:	85 c0                	test   %eax,%eax
 3bc:	7e 14                	jle    3d2 <gets+0x44>
      break;
    buf[i++] = c;
 3be:	8a 45 e7             	mov    -0x19(%ebp),%al
 3c1:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 3c4:	3c 0a                	cmp    $0xa,%al
 3c6:	74 08                	je     3d0 <gets+0x42>
 3c8:	3c 0d                	cmp    $0xd,%al
 3ca:	75 d3                	jne    39f <gets+0x11>
    buf[i++] = c;
 3cc:	89 de                	mov    %ebx,%esi
 3ce:	eb 02                	jmp    3d2 <gets+0x44>
 3d0:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3d2:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3d6:	89 f8                	mov    %edi,%eax
 3d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3db:	5b                   	pop    %ebx
 3dc:	5e                   	pop    %esi
 3dd:	5f                   	pop    %edi
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    

000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	push   0x8(%ebp)
 3ed:	e8 d0 00 00 00       	call   4c2 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 24                	js     41d <stat+0x3d>
 3f9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3fb:	83 ec 08             	sub    $0x8,%esp
 3fe:	ff 75 0c             	push   0xc(%ebp)
 401:	50                   	push   %eax
 402:	e8 d3 00 00 00       	call   4da <fstat>
 407:	89 c6                	mov    %eax,%esi
  close(fd);
 409:	89 1c 24             	mov    %ebx,(%esp)
 40c:	e8 99 00 00 00       	call   4aa <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	89 f0                	mov    %esi,%eax
 416:	8d 65 f8             	lea    -0x8(%ebp),%esp
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
    return -1;
 41d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 422:	eb f0                	jmp    414 <stat+0x34>

00000424 <atoi>:

int
atoi(const char *s)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	53                   	push   %ebx
 428:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 42b:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 430:	eb 0e                	jmp    440 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 432:	8d 14 92             	lea    (%edx,%edx,4),%edx
 435:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 438:	41                   	inc    %ecx
 439:	0f be c0             	movsbl %al,%eax
 43c:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 440:	8a 01                	mov    (%ecx),%al
 442:	8d 58 d0             	lea    -0x30(%eax),%ebx
 445:	80 fb 09             	cmp    $0x9,%bl
 448:	76 e8                	jbe    432 <atoi+0xe>
  return n;
}
 44a:	89 d0                	mov    %edx,%eax
 44c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 45c:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 45f:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 461:	eb 0c                	jmp    46f <memmove+0x1e>
    *dst++ = *src++;
 463:	8a 13                	mov    (%ebx),%dl
 465:	88 11                	mov    %dl,(%ecx)
 467:	8d 5b 01             	lea    0x1(%ebx),%ebx
 46a:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 46d:	89 f2                	mov    %esi,%edx
 46f:	8d 72 ff             	lea    -0x1(%edx),%esi
 472:	85 d2                	test   %edx,%edx
 474:	7f ed                	jg     463 <memmove+0x12>
  return vdst;
}
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47a:	b8 01 00 00 00       	mov    $0x1,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <exit>:
SYSCALL(exit)
 482:	b8 02 00 00 00       	mov    $0x2,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <wait>:
SYSCALL(wait)
 48a:	b8 03 00 00 00       	mov    $0x3,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <pipe>:
SYSCALL(pipe)
 492:	b8 04 00 00 00       	mov    $0x4,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <read>:
SYSCALL(read)
 49a:	b8 05 00 00 00       	mov    $0x5,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <write>:
SYSCALL(write)
 4a2:	b8 10 00 00 00       	mov    $0x10,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <close>:
SYSCALL(close)
 4aa:	b8 15 00 00 00       	mov    $0x15,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <kill>:
SYSCALL(kill)
 4b2:	b8 06 00 00 00       	mov    $0x6,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <exec>:
SYSCALL(exec)
 4ba:	b8 07 00 00 00       	mov    $0x7,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <open>:
SYSCALL(open)
 4c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mknod>:
SYSCALL(mknod)
 4ca:	b8 11 00 00 00       	mov    $0x11,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <unlink>:
SYSCALL(unlink)
 4d2:	b8 12 00 00 00       	mov    $0x12,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <fstat>:
SYSCALL(fstat)
 4da:	b8 08 00 00 00       	mov    $0x8,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <link>:
SYSCALL(link)
 4e2:	b8 13 00 00 00       	mov    $0x13,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mkdir>:
SYSCALL(mkdir)
 4ea:	b8 14 00 00 00       	mov    $0x14,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <chdir>:
SYSCALL(chdir)
 4f2:	b8 09 00 00 00       	mov    $0x9,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <dup>:
SYSCALL(dup)
 4fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <getpid>:
SYSCALL(getpid)
 502:	b8 0b 00 00 00       	mov    $0xb,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <sbrk>:
SYSCALL(sbrk)
 50a:	b8 0c 00 00 00       	mov    $0xc,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <sleep>:
SYSCALL(sleep)
 512:	b8 0d 00 00 00       	mov    $0xd,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <uptime>:
SYSCALL(uptime)
 51a:	b8 0e 00 00 00       	mov    $0xe,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <date>:
SYSCALL(date)
 522:	b8 16 00 00 00       	mov    $0x16,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <dup2>:
SYSCALL(dup2)
 52a:	b8 17 00 00 00       	mov    $0x17,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <phmem>:
SYSCALL(phmem)
 532:	b8 18 00 00 00       	mov    $0x18,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <getprio>:
SYSCALL(getprio)
 53a:	b8 19 00 00 00       	mov    $0x19,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <setprio>:
SYSCALL(setprio)
 542:	b8 1a 00 00 00       	mov    $0x1a,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	83 ec 1c             	sub    $0x1c,%esp
 550:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 553:	6a 01                	push   $0x1
 555:	8d 55 f4             	lea    -0xc(%ebp),%edx
 558:	52                   	push   %edx
 559:	50                   	push   %eax
 55a:	e8 43 ff ff ff       	call   4a2 <write>
}
 55f:	83 c4 10             	add    $0x10,%esp
 562:	c9                   	leave  
 563:	c3                   	ret    

00000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	53                   	push   %ebx
 56a:	83 ec 2c             	sub    $0x2c,%esp
 56d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 570:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 572:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 576:	74 04                	je     57c <printint+0x18>
 578:	85 d2                	test   %edx,%edx
 57a:	78 3c                	js     5b8 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57c:	89 d1                	mov    %edx,%ecx
  neg = 0;
 57e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 585:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 58a:	89 c8                	mov    %ecx,%eax
 58c:	ba 00 00 00 00       	mov    $0x0,%edx
 591:	f7 f6                	div    %esi
 593:	89 df                	mov    %ebx,%edi
 595:	43                   	inc    %ebx
 596:	8a 92 ec 07 00 00    	mov    0x7ec(%edx),%dl
 59c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 5a0:	89 ca                	mov    %ecx,%edx
 5a2:	89 c1                	mov    %eax,%ecx
 5a4:	39 d6                	cmp    %edx,%esi
 5a6:	76 e2                	jbe    58a <printint+0x26>
  if(neg)
 5a8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 5ac:	74 24                	je     5d2 <printint+0x6e>
    buf[i++] = '-';
 5ae:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5b3:	8d 5f 02             	lea    0x2(%edi),%ebx
 5b6:	eb 1a                	jmp    5d2 <printint+0x6e>
    x = -xx;
 5b8:	89 d1                	mov    %edx,%ecx
 5ba:	f7 d9                	neg    %ecx
    neg = 1;
 5bc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 5c3:	eb c0                	jmp    585 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 5c5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5cd:	e8 78 ff ff ff       	call   54a <putc>
  while(--i >= 0)
 5d2:	4b                   	dec    %ebx
 5d3:	79 f0                	jns    5c5 <printint+0x61>
}
 5d5:	83 c4 2c             	add    $0x2c,%esp
 5d8:	5b                   	pop    %ebx
 5d9:	5e                   	pop    %esi
 5da:	5f                   	pop    %edi
 5db:	5d                   	pop    %ebp
 5dc:	c3                   	ret    

000005dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	57                   	push   %edi
 5e1:	56                   	push   %esi
 5e2:	53                   	push   %ebx
 5e3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5e6:	8d 45 10             	lea    0x10(%ebp),%eax
 5e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5ec:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5f1:	bb 00 00 00 00       	mov    $0x0,%ebx
 5f6:	eb 12                	jmp    60a <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5f8:	89 fa                	mov    %edi,%edx
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	e8 48 ff ff ff       	call   54a <putc>
 602:	eb 05                	jmp    609 <printf+0x2c>
      }
    } else if(state == '%'){
 604:	83 fe 25             	cmp    $0x25,%esi
 607:	74 22                	je     62b <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 609:	43                   	inc    %ebx
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	8a 04 18             	mov    (%eax,%ebx,1),%al
 610:	84 c0                	test   %al,%al
 612:	0f 84 1d 01 00 00    	je     735 <printf+0x158>
    c = fmt[i] & 0xff;
 618:	0f be f8             	movsbl %al,%edi
 61b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 61e:	85 f6                	test   %esi,%esi
 620:	75 e2                	jne    604 <printf+0x27>
      if(c == '%'){
 622:	83 f8 25             	cmp    $0x25,%eax
 625:	75 d1                	jne    5f8 <printf+0x1b>
        state = '%';
 627:	89 c6                	mov    %eax,%esi
 629:	eb de                	jmp    609 <printf+0x2c>
      if(c == 'd'){
 62b:	83 f8 25             	cmp    $0x25,%eax
 62e:	0f 84 cc 00 00 00    	je     700 <printf+0x123>
 634:	0f 8c da 00 00 00    	jl     714 <printf+0x137>
 63a:	83 f8 78             	cmp    $0x78,%eax
 63d:	0f 8f d1 00 00 00    	jg     714 <printf+0x137>
 643:	83 f8 63             	cmp    $0x63,%eax
 646:	0f 8c c8 00 00 00    	jl     714 <printf+0x137>
 64c:	83 e8 63             	sub    $0x63,%eax
 64f:	83 f8 15             	cmp    $0x15,%eax
 652:	0f 87 bc 00 00 00    	ja     714 <printf+0x137>
 658:	ff 24 85 94 07 00 00 	jmp    *0x794(,%eax,4)
        printint(fd, *ap, 10, 1);
 65f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 662:	8b 17                	mov    (%edi),%edx
 664:	83 ec 0c             	sub    $0xc,%esp
 667:	6a 01                	push   $0x1
 669:	b9 0a 00 00 00       	mov    $0xa,%ecx
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	e8 ee fe ff ff       	call   564 <printint>
        ap++;
 676:	83 c7 04             	add    $0x4,%edi
 679:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 67c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 67f:	be 00 00 00 00       	mov    $0x0,%esi
 684:	eb 83                	jmp    609 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 686:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 689:	8b 17                	mov    (%edi),%edx
 68b:	83 ec 0c             	sub    $0xc,%esp
 68e:	6a 00                	push   $0x0
 690:	b9 10 00 00 00       	mov    $0x10,%ecx
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	e8 c7 fe ff ff       	call   564 <printint>
        ap++;
 69d:	83 c7 04             	add    $0x4,%edi
 6a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6a3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6a6:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 6ab:	e9 59 ff ff ff       	jmp    609 <printf+0x2c>
        s = (char*)*ap;
 6b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b3:	8b 30                	mov    (%eax),%esi
        ap++;
 6b5:	83 c0 04             	add    $0x4,%eax
 6b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6bb:	85 f6                	test   %esi,%esi
 6bd:	75 13                	jne    6d2 <printf+0xf5>
          s = "(null)";
 6bf:	be 8a 07 00 00       	mov    $0x78a,%esi
 6c4:	eb 0c                	jmp    6d2 <printf+0xf5>
          putc(fd, *s);
 6c6:	0f be d2             	movsbl %dl,%edx
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	e8 79 fe ff ff       	call   54a <putc>
          s++;
 6d1:	46                   	inc    %esi
        while(*s != 0){
 6d2:	8a 16                	mov    (%esi),%dl
 6d4:	84 d2                	test   %dl,%dl
 6d6:	75 ee                	jne    6c6 <printf+0xe9>
      state = 0;
 6d8:	be 00 00 00 00       	mov    $0x0,%esi
 6dd:	e9 27 ff ff ff       	jmp    609 <printf+0x2c>
        putc(fd, *ap);
 6e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6e5:	0f be 17             	movsbl (%edi),%edx
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	e8 5a fe ff ff       	call   54a <putc>
        ap++;
 6f0:	83 c7 04             	add    $0x4,%edi
 6f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6f6:	be 00 00 00 00       	mov    $0x0,%esi
 6fb:	e9 09 ff ff ff       	jmp    609 <printf+0x2c>
        putc(fd, c);
 700:	89 fa                	mov    %edi,%edx
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	e8 40 fe ff ff       	call   54a <putc>
      state = 0;
 70a:	be 00 00 00 00       	mov    $0x0,%esi
 70f:	e9 f5 fe ff ff       	jmp    609 <printf+0x2c>
        putc(fd, '%');
 714:	ba 25 00 00 00       	mov    $0x25,%edx
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	e8 29 fe ff ff       	call   54a <putc>
        putc(fd, c);
 721:	89 fa                	mov    %edi,%edx
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	e8 1f fe ff ff       	call   54a <putc>
      state = 0;
 72b:	be 00 00 00 00       	mov    $0x0,%esi
 730:	e9 d4 fe ff ff       	jmp    609 <printf+0x2c>
    }
  }
}
 735:	8d 65 f4             	lea    -0xc(%ebp),%esp
 738:	5b                   	pop    %ebx
 739:	5e                   	pop    %esi
 73a:	5f                   	pop    %edi
 73b:	5d                   	pop    %ebp
 73c:	c3                   	ret    
