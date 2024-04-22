
dup2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int fd;

  // Ejemplo de dup2 con un fd incorrecto
  if (dup2 (-1,8) >= 0)
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 08                	push   $0x8
  14:	6a ff                	push   $0xffffffff
  16:	e8 f9 03 00 00       	call   414 <dup2>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	85 c0                	test   %eax,%eax
  20:	0f 89 fc 01 00 00    	jns    222 <main+0x222>
    printf (2, "dup2 no funciona con fd incorrecto.\n");

  // Ejemplo de dup2 con un newfd incorrecto
  if (dup2 (1,-1) >= 0)
  26:	83 ec 08             	sub    $0x8,%esp
  29:	6a ff                	push   $0xffffffff
  2b:	6a 01                	push   $0x1
  2d:	e8 e2 03 00 00       	call   414 <dup2>
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	0f 89 fc 01 00 00    	jns    239 <main+0x239>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");

  // Ejemplo de dup2 con un fd no mapeado
  if (dup2 (6,8) >= 0)
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	6a 08                	push   $0x8
  42:	6a 06                	push   $0x6
  44:	e8 cb 03 00 00       	call   414 <dup2>
  49:	83 c4 10             	add    $0x10,%esp
  4c:	85 c0                	test   %eax,%eax
  4e:	0f 89 fc 01 00 00    	jns    250 <main+0x250>
    printf (2, "dup2 no funciona con fd no mapeado.\n");

  // Ejemplo de dup2 con un fd no mapeado (2)
  if (dup2 (8,1) >= 0)
  54:	83 ec 08             	sub    $0x8,%esp
  57:	6a 01                	push   $0x1
  59:	6a 08                	push   $0x8
  5b:	e8 b4 03 00 00       	call   414 <dup2>
  60:	83 c4 10             	add    $0x10,%esp
  63:	85 c0                	test   %eax,%eax
  65:	0f 89 fc 01 00 00    	jns    267 <main+0x267>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");

  if (dup2 (1,25) >= 0)
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	6a 19                	push   $0x19
  70:	6a 01                	push   $0x1
  72:	e8 9d 03 00 00       	call   414 <dup2>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	85 c0                	test   %eax,%eax
  7c:	0f 89 fc 01 00 00    	jns    27e <main+0x27e>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");

  // Ejemplo de dup2 con fd existente
  if (dup2 (1,4) != 4)
  82:	83 ec 08             	sub    $0x8,%esp
  85:	6a 04                	push   $0x4
  87:	6a 01                	push   $0x1
  89:	e8 86 03 00 00       	call   414 <dup2>
  8e:	83 c4 10             	add    $0x10,%esp
  91:	83 f8 04             	cmp    $0x4,%eax
  94:	0f 85 fb 01 00 00    	jne    295 <main+0x295>
    printf (2, "dup2 no funciona con fd existente.\n");

  printf (4, "Este mensaje debe salir por terminal.\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 20 07 00 00       	push   $0x720
  a2:	6a 04                	push   $0x4
  a4:	e8 1e 04 00 00       	call   4c7 <printf>

  if (dup2 (4,6) != 6)
  a9:	83 c4 08             	add    $0x8,%esp
  ac:	6a 06                	push   $0x6
  ae:	6a 04                	push   $0x4
  b0:	e8 5f 03 00 00       	call   414 <dup2>
  b5:	83 c4 10             	add    $0x10,%esp
  b8:	83 f8 06             	cmp    $0x6,%eax
  bb:	0f 85 eb 01 00 00    	jne    2ac <main+0x2ac>
    printf (2, "dup2 no funciona con fd existente (2).\n");

  printf (6, "Este mensaje debe salir por terminal (2).\n");
  c1:	83 ec 08             	sub    $0x8,%esp
  c4:	68 70 07 00 00       	push   $0x770
  c9:	6a 06                	push   $0x6
  cb:	e8 f7 03 00 00       	call   4c7 <printf>

  if (close (4) != 0)
  d0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  d7:	e8 b8 02 00 00       	call   394 <close>
  dc:	83 c4 10             	add    $0x10,%esp
  df:	85 c0                	test   %eax,%eax
  e1:	0f 85 dc 01 00 00    	jne    2c3 <main+0x2c3>
    printf (2, "Error en close (4)\n");
  printf (6, "Este mensaje debe salir por terminal (3).\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 9c 07 00 00       	push   $0x79c
  ef:	6a 06                	push   $0x6
  f1:	e8 d1 03 00 00       	call   4c7 <printf>
  if (close (6) != 0)
  f6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  fd:	e8 92 02 00 00       	call   394 <close>
 102:	83 c4 10             	add    $0x10,%esp
 105:	85 c0                	test   %eax,%eax
 107:	0f 85 cd 01 00 00    	jne    2da <main+0x2da>
    printf (2, "Error en close (6)\n");
  if (close (6) == 0)
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	6a 06                	push   $0x6
 112:	e8 7d 02 00 00       	call   394 <close>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 84 cf 01 00 00    	je     2f1 <main+0x2f1>
    printf (2, "Error en close (6) (2)\n");

  fd = open ("fichero_salida.txt", O_CREATE|O_RDWR);
 122:	83 ec 08             	sub    $0x8,%esp
 125:	68 02 02 00 00       	push   $0x202
 12a:	68 7c 08 00 00       	push   $0x87c
 12f:	e8 78 02 00 00       	call   3ac <open>
 134:	89 c3                	mov    %eax,%ebx
  printf (fd, "Salida a fichero\n");
 136:	83 c4 08             	add    $0x8,%esp
 139:	68 8f 08 00 00       	push   $0x88f
 13e:	50                   	push   %eax
 13f:	e8 83 03 00 00       	call   4c7 <printf>

  if (dup2 (fd, 9) != 9)
 144:	83 c4 08             	add    $0x8,%esp
 147:	6a 09                	push   $0x9
 149:	53                   	push   %ebx
 14a:	e8 c5 02 00 00       	call   414 <dup2>
 14f:	83 c4 10             	add    $0x10,%esp
 152:	83 f8 09             	cmp    $0x9,%eax
 155:	0f 85 ad 01 00 00    	jne    308 <main+0x308>
    printf (2, "dup2 no funciona con fd existente (3).\n");

  printf (9, "Salida también a fichero.\n");
 15b:	83 ec 08             	sub    $0x8,%esp
 15e:	68 a1 08 00 00       	push   $0x8a1
 163:	6a 09                	push   $0x9
 165:	e8 5d 03 00 00       	call   4c7 <printf>

  if (dup2 (9, 9) != 9)
 16a:	83 c4 08             	add    $0x8,%esp
 16d:	6a 09                	push   $0x9
 16f:	6a 09                	push   $0x9
 171:	e8 9e 02 00 00       	call   414 <dup2>
 176:	83 c4 10             	add    $0x10,%esp
 179:	83 f8 09             	cmp    $0x9,%eax
 17c:	0f 85 9d 01 00 00    	jne    31f <main+0x31f>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");

  printf (9, "Salida también a fichero.\n");
 182:	83 ec 08             	sub    $0x8,%esp
 185:	68 a1 08 00 00       	push   $0x8a1
 18a:	6a 09                	push   $0x9
 18c:	e8 36 03 00 00       	call   4c7 <printf>

  close (9);
 191:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
 198:	e8 f7 01 00 00       	call   394 <close>

  dup2 (1, 6);
 19d:	83 c4 08             	add    $0x8,%esp
 1a0:	6a 06                	push   $0x6
 1a2:	6a 01                	push   $0x1
 1a4:	e8 6b 02 00 00       	call   414 <dup2>

  if (dup2 (fd, 1) != 1)
 1a9:	83 c4 08             	add    $0x8,%esp
 1ac:	6a 01                	push   $0x1
 1ae:	53                   	push   %ebx
 1af:	e8 60 02 00 00       	call   414 <dup2>
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	83 f8 01             	cmp    $0x1,%eax
 1ba:	0f 85 76 01 00 00    	jne    336 <main+0x336>
    printf (2, "dup2 no funciona con fd existente (4).\n");

  printf (1, "Cuarta salida a fichero.\n");
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	68 bd 08 00 00       	push   $0x8bd
 1c8:	6a 01                	push   $0x1
 1ca:	e8 f8 02 00 00       	call   4c7 <printf>
  if (close (1) != 0)
 1cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d6:	e8 b9 01 00 00       	call   394 <close>
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	85 c0                	test   %eax,%eax
 1e0:	0f 85 67 01 00 00    	jne    34d <main+0x34d>
    printf (2, "Error en close (1).\n");

  dup2 (6,fd);
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	53                   	push   %ebx
 1ea:	6a 06                	push   $0x6
 1ec:	e8 23 02 00 00       	call   414 <dup2>

  printf (fd, "Este mensaje debe salir por terminal.\n");
 1f1:	83 c4 08             	add    $0x8,%esp
 1f4:	68 20 07 00 00       	push   $0x720
 1f9:	53                   	push   %ebx
 1fa:	e8 c8 02 00 00       	call   4c7 <printf>
  close (fd);
 1ff:	89 1c 24             	mov    %ebx,(%esp)
 202:	e8 8d 01 00 00       	call   394 <close>

  exit(0);
 207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 20e:	e8 59 01 00 00       	call   36c <exit>
}
 213:	b8 00 00 00 00       	mov    $0x0,%eax
 218:	8d 65 f8             	lea    -0x8(%ebp),%esp
 21b:	59                   	pop    %ecx
 21c:	5b                   	pop    %ebx
 21d:	5d                   	pop    %ebp
 21e:	8d 61 fc             	lea    -0x4(%ecx),%esp
 221:	c3                   	ret    
    printf (2, "dup2 no funciona con fd incorrecto.\n");
 222:	83 ec 08             	sub    $0x8,%esp
 225:	68 28 06 00 00       	push   $0x628
 22a:	6a 02                	push   $0x2
 22c:	e8 96 02 00 00       	call   4c7 <printf>
 231:	83 c4 10             	add    $0x10,%esp
 234:	e9 ed fd ff ff       	jmp    26 <main+0x26>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	68 50 06 00 00       	push   $0x650
 241:	6a 02                	push   $0x2
 243:	e8 7f 02 00 00       	call   4c7 <printf>
 248:	83 c4 10             	add    $0x10,%esp
 24b:	e9 ed fd ff ff       	jmp    3d <main+0x3d>
    printf (2, "dup2 no funciona con fd no mapeado.\n");
 250:	83 ec 08             	sub    $0x8,%esp
 253:	68 7c 06 00 00       	push   $0x67c
 258:	6a 02                	push   $0x2
 25a:	e8 68 02 00 00       	call   4c7 <printf>
 25f:	83 c4 10             	add    $0x10,%esp
 262:	e9 ed fd ff ff       	jmp    54 <main+0x54>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");
 267:	83 ec 08             	sub    $0x8,%esp
 26a:	68 a4 06 00 00       	push   $0x6a4
 26f:	6a 02                	push   $0x2
 271:	e8 51 02 00 00       	call   4c7 <printf>
 276:	83 c4 10             	add    $0x10,%esp
 279:	e9 ed fd ff ff       	jmp    6b <main+0x6b>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	68 d0 06 00 00       	push   $0x6d0
 286:	6a 02                	push   $0x2
 288:	e8 3a 02 00 00       	call   4c7 <printf>
 28d:	83 c4 10             	add    $0x10,%esp
 290:	e9 ed fd ff ff       	jmp    82 <main+0x82>
    printf (2, "dup2 no funciona con fd existente.\n");
 295:	83 ec 08             	sub    $0x8,%esp
 298:	68 fc 06 00 00       	push   $0x6fc
 29d:	6a 02                	push   $0x2
 29f:	e8 23 02 00 00       	call   4c7 <printf>
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	e9 ee fd ff ff       	jmp    9a <main+0x9a>
    printf (2, "dup2 no funciona con fd existente (2).\n");
 2ac:	83 ec 08             	sub    $0x8,%esp
 2af:	68 48 07 00 00       	push   $0x748
 2b4:	6a 02                	push   $0x2
 2b6:	e8 0c 02 00 00       	call   4c7 <printf>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	e9 fe fd ff ff       	jmp    c1 <main+0xc1>
    printf (2, "Error en close (4)\n");
 2c3:	83 ec 08             	sub    $0x8,%esp
 2c6:	68 3c 08 00 00       	push   $0x83c
 2cb:	6a 02                	push   $0x2
 2cd:	e8 f5 01 00 00       	call   4c7 <printf>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	e9 0d fe ff ff       	jmp    e7 <main+0xe7>
    printf (2, "Error en close (6)\n");
 2da:	83 ec 08             	sub    $0x8,%esp
 2dd:	68 50 08 00 00       	push   $0x850
 2e2:	6a 02                	push   $0x2
 2e4:	e8 de 01 00 00       	call   4c7 <printf>
 2e9:	83 c4 10             	add    $0x10,%esp
 2ec:	e9 1c fe ff ff       	jmp    10d <main+0x10d>
    printf (2, "Error en close (6) (2)\n");
 2f1:	83 ec 08             	sub    $0x8,%esp
 2f4:	68 64 08 00 00       	push   $0x864
 2f9:	6a 02                	push   $0x2
 2fb:	e8 c7 01 00 00       	call   4c7 <printf>
 300:	83 c4 10             	add    $0x10,%esp
 303:	e9 1a fe ff ff       	jmp    122 <main+0x122>
    printf (2, "dup2 no funciona con fd existente (3).\n");
 308:	83 ec 08             	sub    $0x8,%esp
 30b:	68 c8 07 00 00       	push   $0x7c8
 310:	6a 02                	push   $0x2
 312:	e8 b0 01 00 00       	call   4c7 <printf>
 317:	83 c4 10             	add    $0x10,%esp
 31a:	e9 3c fe ff ff       	jmp    15b <main+0x15b>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");
 31f:	83 ec 08             	sub    $0x8,%esp
 322:	68 f0 07 00 00       	push   $0x7f0
 327:	6a 02                	push   $0x2
 329:	e8 99 01 00 00       	call   4c7 <printf>
 32e:	83 c4 10             	add    $0x10,%esp
 331:	e9 4c fe ff ff       	jmp    182 <main+0x182>
    printf (2, "dup2 no funciona con fd existente (4).\n");
 336:	83 ec 08             	sub    $0x8,%esp
 339:	68 14 08 00 00       	push   $0x814
 33e:	6a 02                	push   $0x2
 340:	e8 82 01 00 00       	call   4c7 <printf>
 345:	83 c4 10             	add    $0x10,%esp
 348:	e9 73 fe ff ff       	jmp    1c0 <main+0x1c0>
    printf (2, "Error en close (1).\n");
 34d:	83 ec 08             	sub    $0x8,%esp
 350:	68 d7 08 00 00       	push   $0x8d7
 355:	6a 02                	push   $0x2
 357:	e8 6b 01 00 00       	call   4c7 <printf>
 35c:	83 c4 10             	add    $0x10,%esp
 35f:	e9 82 fe ff ff       	jmp    1e6 <main+0x1e6>

00000364 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 364:	b8 01 00 00 00       	mov    $0x1,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exit>:
SYSCALL(exit)
 36c:	b8 02 00 00 00       	mov    $0x2,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <wait>:
SYSCALL(wait)
 374:	b8 03 00 00 00       	mov    $0x3,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <pipe>:
SYSCALL(pipe)
 37c:	b8 04 00 00 00       	mov    $0x4,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <read>:
SYSCALL(read)
 384:	b8 05 00 00 00       	mov    $0x5,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <write>:
SYSCALL(write)
 38c:	b8 10 00 00 00       	mov    $0x10,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <close>:
SYSCALL(close)
 394:	b8 15 00 00 00       	mov    $0x15,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <kill>:
SYSCALL(kill)
 39c:	b8 06 00 00 00       	mov    $0x6,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exec>:
SYSCALL(exec)
 3a4:	b8 07 00 00 00       	mov    $0x7,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <open>:
SYSCALL(open)
 3ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <mknod>:
SYSCALL(mknod)
 3b4:	b8 11 00 00 00       	mov    $0x11,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <unlink>:
SYSCALL(unlink)
 3bc:	b8 12 00 00 00       	mov    $0x12,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <fstat>:
SYSCALL(fstat)
 3c4:	b8 08 00 00 00       	mov    $0x8,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <link>:
SYSCALL(link)
 3cc:	b8 13 00 00 00       	mov    $0x13,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mkdir>:
SYSCALL(mkdir)
 3d4:	b8 14 00 00 00       	mov    $0x14,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <chdir>:
SYSCALL(chdir)
 3dc:	b8 09 00 00 00       	mov    $0x9,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <dup>:
SYSCALL(dup)
 3e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getpid>:
SYSCALL(getpid)
 3ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <sbrk>:
SYSCALL(sbrk)
 3f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sleep>:
SYSCALL(sleep)
 3fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <uptime>:
SYSCALL(uptime)
 404:	b8 0e 00 00 00       	mov    $0xe,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <date>:
SYSCALL(date)
 40c:	b8 16 00 00 00       	mov    $0x16,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <dup2>:
SYSCALL(dup2)
 414:	b8 17 00 00 00       	mov    $0x17,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <phmem>:
SYSCALL(phmem)
 41c:	b8 18 00 00 00       	mov    $0x18,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <getprio>:
SYSCALL(getprio)
 424:	b8 19 00 00 00       	mov    $0x19,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <setprio>:
SYSCALL(setprio)
 42c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 1c             	sub    $0x1c,%esp
 43a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 43d:	6a 01                	push   $0x1
 43f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 442:	52                   	push   %edx
 443:	50                   	push   %eax
 444:	e8 43 ff ff ff       	call   38c <write>
}
 449:	83 c4 10             	add    $0x10,%esp
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	57                   	push   %edi
 452:	56                   	push   %esi
 453:	53                   	push   %ebx
 454:	83 ec 2c             	sub    $0x2c,%esp
 457:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 45a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 460:	74 04                	je     466 <printint+0x18>
 462:	85 d2                	test   %edx,%edx
 464:	78 3c                	js     4a2 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 466:	89 d1                	mov    %edx,%ecx
  neg = 0;
 468:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 46f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 474:	89 c8                	mov    %ecx,%eax
 476:	ba 00 00 00 00       	mov    $0x0,%edx
 47b:	f7 f6                	div    %esi
 47d:	89 df                	mov    %ebx,%edi
 47f:	43                   	inc    %ebx
 480:	8a 92 4c 09 00 00    	mov    0x94c(%edx),%dl
 486:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 48a:	89 ca                	mov    %ecx,%edx
 48c:	89 c1                	mov    %eax,%ecx
 48e:	39 d6                	cmp    %edx,%esi
 490:	76 e2                	jbe    474 <printint+0x26>
  if(neg)
 492:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 496:	74 24                	je     4bc <printint+0x6e>
    buf[i++] = '-';
 498:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 49d:	8d 5f 02             	lea    0x2(%edi),%ebx
 4a0:	eb 1a                	jmp    4bc <printint+0x6e>
    x = -xx;
 4a2:	89 d1                	mov    %edx,%ecx
 4a4:	f7 d9                	neg    %ecx
    neg = 1;
 4a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 4ad:	eb c0                	jmp    46f <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 4af:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b7:	e8 78 ff ff ff       	call   434 <putc>
  while(--i >= 0)
 4bc:	4b                   	dec    %ebx
 4bd:	79 f0                	jns    4af <printint+0x61>
}
 4bf:	83 c4 2c             	add    $0x2c,%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    

000004c7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c7:	55                   	push   %ebp
 4c8:	89 e5                	mov    %esp,%ebp
 4ca:	57                   	push   %edi
 4cb:	56                   	push   %esi
 4cc:	53                   	push   %ebx
 4cd:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4d0:	8d 45 10             	lea    0x10(%ebp),%eax
 4d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4d6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4db:	bb 00 00 00 00       	mov    $0x0,%ebx
 4e0:	eb 12                	jmp    4f4 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e2:	89 fa                	mov    %edi,%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	e8 48 ff ff ff       	call   434 <putc>
 4ec:	eb 05                	jmp    4f3 <printf+0x2c>
      }
    } else if(state == '%'){
 4ee:	83 fe 25             	cmp    $0x25,%esi
 4f1:	74 22                	je     515 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 4f3:	43                   	inc    %ebx
 4f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f7:	8a 04 18             	mov    (%eax,%ebx,1),%al
 4fa:	84 c0                	test   %al,%al
 4fc:	0f 84 1d 01 00 00    	je     61f <printf+0x158>
    c = fmt[i] & 0xff;
 502:	0f be f8             	movsbl %al,%edi
 505:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 508:	85 f6                	test   %esi,%esi
 50a:	75 e2                	jne    4ee <printf+0x27>
      if(c == '%'){
 50c:	83 f8 25             	cmp    $0x25,%eax
 50f:	75 d1                	jne    4e2 <printf+0x1b>
        state = '%';
 511:	89 c6                	mov    %eax,%esi
 513:	eb de                	jmp    4f3 <printf+0x2c>
      if(c == 'd'){
 515:	83 f8 25             	cmp    $0x25,%eax
 518:	0f 84 cc 00 00 00    	je     5ea <printf+0x123>
 51e:	0f 8c da 00 00 00    	jl     5fe <printf+0x137>
 524:	83 f8 78             	cmp    $0x78,%eax
 527:	0f 8f d1 00 00 00    	jg     5fe <printf+0x137>
 52d:	83 f8 63             	cmp    $0x63,%eax
 530:	0f 8c c8 00 00 00    	jl     5fe <printf+0x137>
 536:	83 e8 63             	sub    $0x63,%eax
 539:	83 f8 15             	cmp    $0x15,%eax
 53c:	0f 87 bc 00 00 00    	ja     5fe <printf+0x137>
 542:	ff 24 85 f4 08 00 00 	jmp    *0x8f4(,%eax,4)
        printint(fd, *ap, 10, 1);
 549:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54c:	8b 17                	mov    (%edi),%edx
 54e:	83 ec 0c             	sub    $0xc,%esp
 551:	6a 01                	push   $0x1
 553:	b9 0a 00 00 00       	mov    $0xa,%ecx
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	e8 ee fe ff ff       	call   44e <printint>
        ap++;
 560:	83 c7 04             	add    $0x4,%edi
 563:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 566:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 569:	be 00 00 00 00       	mov    $0x0,%esi
 56e:	eb 83                	jmp    4f3 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 573:	8b 17                	mov    (%edi),%edx
 575:	83 ec 0c             	sub    $0xc,%esp
 578:	6a 00                	push   $0x0
 57a:	b9 10 00 00 00       	mov    $0x10,%ecx
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	e8 c7 fe ff ff       	call   44e <printint>
        ap++;
 587:	83 c7 04             	add    $0x4,%edi
 58a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 58d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 590:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 595:	e9 59 ff ff ff       	jmp    4f3 <printf+0x2c>
        s = (char*)*ap;
 59a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59d:	8b 30                	mov    (%eax),%esi
        ap++;
 59f:	83 c0 04             	add    $0x4,%eax
 5a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5a5:	85 f6                	test   %esi,%esi
 5a7:	75 13                	jne    5bc <printf+0xf5>
          s = "(null)";
 5a9:	be ec 08 00 00       	mov    $0x8ec,%esi
 5ae:	eb 0c                	jmp    5bc <printf+0xf5>
          putc(fd, *s);
 5b0:	0f be d2             	movsbl %dl,%edx
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	e8 79 fe ff ff       	call   434 <putc>
          s++;
 5bb:	46                   	inc    %esi
        while(*s != 0){
 5bc:	8a 16                	mov    (%esi),%dl
 5be:	84 d2                	test   %dl,%dl
 5c0:	75 ee                	jne    5b0 <printf+0xe9>
      state = 0;
 5c2:	be 00 00 00 00       	mov    $0x0,%esi
 5c7:	e9 27 ff ff ff       	jmp    4f3 <printf+0x2c>
        putc(fd, *ap);
 5cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cf:	0f be 17             	movsbl (%edi),%edx
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	e8 5a fe ff ff       	call   434 <putc>
        ap++;
 5da:	83 c7 04             	add    $0x4,%edi
 5dd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e0:	be 00 00 00 00       	mov    $0x0,%esi
 5e5:	e9 09 ff ff ff       	jmp    4f3 <printf+0x2c>
        putc(fd, c);
 5ea:	89 fa                	mov    %edi,%edx
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	e8 40 fe ff ff       	call   434 <putc>
      state = 0;
 5f4:	be 00 00 00 00       	mov    $0x0,%esi
 5f9:	e9 f5 fe ff ff       	jmp    4f3 <printf+0x2c>
        putc(fd, '%');
 5fe:	ba 25 00 00 00       	mov    $0x25,%edx
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	e8 29 fe ff ff       	call   434 <putc>
        putc(fd, c);
 60b:	89 fa                	mov    %edi,%edx
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	e8 1f fe ff ff       	call   434 <putc>
      state = 0;
 615:	be 00 00 00 00       	mov    $0x0,%esi
 61a:	e9 d4 fe ff ff       	jmp    4f3 <printf+0x2c>
    }
  }
}
 61f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 622:	5b                   	pop    %ebx
 623:	5e                   	pop    %esi
 624:	5f                   	pop    %edi
 625:	5d                   	pop    %ebp
 626:	c3                   	ret    
