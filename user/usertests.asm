
usertests:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 0c 46 00 00       	push   $0x460c
       b:	ff 35 50 66 00 00    	push   0x6650
      11:	e8 bd 42 00 00       	call   42d3 <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 9f 45 00 00 	movl   $0x459f,(%esp)
      1d:	e8 be 41 00 00       	call   41e0 <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	78 58                	js     81 <iputtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }
  if(chdir("iputdir") < 0){
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 9f 45 00 00       	push   $0x459f
      31:	e8 b2 41 00 00       	call   41e8 <chdir>
      36:	83 c4 10             	add    $0x10,%esp
      39:	85 c0                	test   %eax,%eax
      3b:	78 68                	js     a5 <iputtest+0xa5>
    printf(stdout, "chdir iputdir failed\n");
    exit(0);
  }
  if(unlink("../iputdir") < 0){
      3d:	83 ec 0c             	sub    $0xc,%esp
      40:	68 9c 45 00 00       	push   $0x459c
      45:	e8 7e 41 00 00       	call   41c8 <unlink>
      4a:	83 c4 10             	add    $0x10,%esp
      4d:	85 c0                	test   %eax,%eax
      4f:	78 7b                	js     cc <iputtest+0xcc>
    printf(stdout, "unlink ../iputdir failed\n");
    exit(0);
  }
  if(chdir("/") < 0){
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	68 c1 45 00 00       	push   $0x45c1
      59:	e8 8a 41 00 00       	call   41e8 <chdir>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	0f 88 8a 00 00 00    	js     f3 <iputtest+0xf3>
    printf(stdout, "chdir / failed\n");
    exit(0);
  }
  printf(stdout, "iput test ok\n");
      69:	83 ec 08             	sub    $0x8,%esp
      6c:	68 44 46 00 00       	push   $0x4644
      71:	ff 35 50 66 00 00    	push   0x6650
      77:	e8 57 42 00 00       	call   42d3 <printf>
}
      7c:	83 c4 10             	add    $0x10,%esp
      7f:	c9                   	leave  
      80:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      81:	83 ec 08             	sub    $0x8,%esp
      84:	68 78 45 00 00       	push   $0x4578
      89:	ff 35 50 66 00 00    	push   0x6650
      8f:	e8 3f 42 00 00       	call   42d3 <printf>
    exit(0);
      94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      9b:	e8 d8 40 00 00       	call   4178 <exit>
      a0:	83 c4 10             	add    $0x10,%esp
      a3:	eb 84                	jmp    29 <iputtest+0x29>
    printf(stdout, "chdir iputdir failed\n");
      a5:	83 ec 08             	sub    $0x8,%esp
      a8:	68 86 45 00 00       	push   $0x4586
      ad:	ff 35 50 66 00 00    	push   0x6650
      b3:	e8 1b 42 00 00       	call   42d3 <printf>
    exit(0);
      b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      bf:	e8 b4 40 00 00       	call   4178 <exit>
      c4:	83 c4 10             	add    $0x10,%esp
      c7:	e9 71 ff ff ff       	jmp    3d <iputtest+0x3d>
    printf(stdout, "unlink ../iputdir failed\n");
      cc:	83 ec 08             	sub    $0x8,%esp
      cf:	68 a7 45 00 00       	push   $0x45a7
      d4:	ff 35 50 66 00 00    	push   0x6650
      da:	e8 f4 41 00 00       	call   42d3 <printf>
    exit(0);
      df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      e6:	e8 8d 40 00 00       	call   4178 <exit>
      eb:	83 c4 10             	add    $0x10,%esp
      ee:	e9 5e ff ff ff       	jmp    51 <iputtest+0x51>
    printf(stdout, "chdir / failed\n");
      f3:	83 ec 08             	sub    $0x8,%esp
      f6:	68 c3 45 00 00       	push   $0x45c3
      fb:	ff 35 50 66 00 00    	push   0x6650
     101:	e8 cd 41 00 00       	call   42d3 <printf>
    exit(0);
     106:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     10d:	e8 66 40 00 00       	call   4178 <exit>
     112:	83 c4 10             	add    $0x10,%esp
     115:	e9 4f ff ff ff       	jmp    69 <iputtest+0x69>

0000011a <exitiputtest>:

// does exit(0) call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
     11a:	55                   	push   %ebp
     11b:	89 e5                	mov    %esp,%ebp
     11d:	53                   	push   %ebx
     11e:	83 ec 0c             	sub    $0xc,%esp
  int pid;

  printf(stdout, "exitiput test\n");
     121:	68 d3 45 00 00       	push   $0x45d3
     126:	ff 35 50 66 00 00    	push   0x6650
     12c:	e8 a2 41 00 00       	call   42d3 <printf>

  pid = fork();
     131:	e8 3a 40 00 00       	call   4170 <fork>
     136:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
     138:	83 c4 10             	add    $0x10,%esp
     13b:	85 c0                	test   %eax,%eax
     13d:	78 29                	js     168 <exitiputtest+0x4e>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     13f:	85 db                	test   %ebx,%ebx
     141:	74 49                	je     18c <exitiputtest+0x72>
      printf(stdout, "unlink ../iputdir failed\n");
      exit(0);
    }
    exit(0);
  }
  wait(NULL);
     143:	83 ec 0c             	sub    $0xc,%esp
     146:	6a 00                	push   $0x0
     148:	e8 33 40 00 00       	call   4180 <wait>
  printf(stdout, "exitiput test ok\n");
     14d:	83 c4 08             	add    $0x8,%esp
     150:	68 f6 45 00 00       	push   $0x45f6
     155:	ff 35 50 66 00 00    	push   0x6650
     15b:	e8 73 41 00 00       	call   42d3 <printf>
}
     160:	83 c4 10             	add    $0x10,%esp
     163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     166:	c9                   	leave  
     167:	c3                   	ret    
    printf(stdout, "fork failed\n");
     168:	83 ec 08             	sub    $0x8,%esp
     16b:	68 b9 54 00 00       	push   $0x54b9
     170:	ff 35 50 66 00 00    	push   0x6650
     176:	e8 58 41 00 00       	call   42d3 <printf>
    exit(0);
     17b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     182:	e8 f1 3f 00 00       	call   4178 <exit>
     187:	83 c4 10             	add    $0x10,%esp
     18a:	eb b3                	jmp    13f <exitiputtest+0x25>
    if(mkdir("iputdir") < 0){
     18c:	83 ec 0c             	sub    $0xc,%esp
     18f:	68 9f 45 00 00       	push   $0x459f
     194:	e8 47 40 00 00       	call   41e0 <mkdir>
     199:	83 c4 10             	add    $0x10,%esp
     19c:	85 c0                	test   %eax,%eax
     19e:	78 3a                	js     1da <exitiputtest+0xc0>
    if(chdir("iputdir") < 0){
     1a0:	83 ec 0c             	sub    $0xc,%esp
     1a3:	68 9f 45 00 00       	push   $0x459f
     1a8:	e8 3b 40 00 00       	call   41e8 <chdir>
     1ad:	83 c4 10             	add    $0x10,%esp
     1b0:	85 c0                	test   %eax,%eax
     1b2:	78 4a                	js     1fe <exitiputtest+0xe4>
    if(unlink("../iputdir") < 0){
     1b4:	83 ec 0c             	sub    $0xc,%esp
     1b7:	68 9c 45 00 00       	push   $0x459c
     1bc:	e8 07 40 00 00       	call   41c8 <unlink>
     1c1:	83 c4 10             	add    $0x10,%esp
     1c4:	85 c0                	test   %eax,%eax
     1c6:	78 5a                	js     222 <exitiputtest+0x108>
    exit(0);
     1c8:	83 ec 0c             	sub    $0xc,%esp
     1cb:	6a 00                	push   $0x0
     1cd:	e8 a6 3f 00 00       	call   4178 <exit>
     1d2:	83 c4 10             	add    $0x10,%esp
     1d5:	e9 69 ff ff ff       	jmp    143 <exitiputtest+0x29>
      printf(stdout, "mkdir failed\n");
     1da:	83 ec 08             	sub    $0x8,%esp
     1dd:	68 78 45 00 00       	push   $0x4578
     1e2:	ff 35 50 66 00 00    	push   0x6650
     1e8:	e8 e6 40 00 00       	call   42d3 <printf>
      exit(0);
     1ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1f4:	e8 7f 3f 00 00       	call   4178 <exit>
     1f9:	83 c4 10             	add    $0x10,%esp
     1fc:	eb a2                	jmp    1a0 <exitiputtest+0x86>
      printf(stdout, "child chdir failed\n");
     1fe:	83 ec 08             	sub    $0x8,%esp
     201:	68 e2 45 00 00       	push   $0x45e2
     206:	ff 35 50 66 00 00    	push   0x6650
     20c:	e8 c2 40 00 00       	call   42d3 <printf>
      exit(0);
     211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     218:	e8 5b 3f 00 00       	call   4178 <exit>
     21d:	83 c4 10             	add    $0x10,%esp
     220:	eb 92                	jmp    1b4 <exitiputtest+0x9a>
      printf(stdout, "unlink ../iputdir failed\n");
     222:	83 ec 08             	sub    $0x8,%esp
     225:	68 a7 45 00 00       	push   $0x45a7
     22a:	ff 35 50 66 00 00    	push   0x6650
     230:	e8 9e 40 00 00       	call   42d3 <printf>
      exit(0);
     235:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     23c:	e8 37 3f 00 00       	call   4178 <exit>
     241:	83 c4 10             	add    $0x10,%esp
     244:	eb 82                	jmp    1c8 <exitiputtest+0xae>

00000246 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     246:	55                   	push   %ebp
     247:	89 e5                	mov    %esp,%ebp
     249:	53                   	push   %ebx
     24a:	83 ec 0c             	sub    $0xc,%esp
  int pid;

  printf(stdout, "openiput test\n");
     24d:	68 08 46 00 00       	push   $0x4608
     252:	ff 35 50 66 00 00    	push   0x6650
     258:	e8 76 40 00 00       	call   42d3 <printf>
  if(mkdir("oidir") < 0){
     25d:	c7 04 24 17 46 00 00 	movl   $0x4617,(%esp)
     264:	e8 77 3f 00 00       	call   41e0 <mkdir>
     269:	83 c4 10             	add    $0x10,%esp
     26c:	85 c0                	test   %eax,%eax
     26e:	78 59                	js     2c9 <openiputtest+0x83>
    printf(stdout, "mkdir oidir failed\n");
    exit(0);
  }
  pid = fork();
     270:	e8 fb 3e 00 00       	call   4170 <fork>
     275:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
     277:	85 c0                	test   %eax,%eax
     279:	78 72                	js     2ed <openiputtest+0xa7>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     27b:	85 db                	test   %ebx,%ebx
     27d:	0f 84 91 00 00 00    	je     314 <openiputtest+0xce>
      printf(stdout, "open directory for write succeeded\n");
      exit(0);
    }
    exit(0);
  }
  sleep(1);
     283:	83 ec 0c             	sub    $0xc,%esp
     286:	6a 01                	push   $0x1
     288:	e8 7b 3f 00 00       	call   4208 <sleep>
  if(unlink("oidir") != 0){
     28d:	c7 04 24 17 46 00 00 	movl   $0x4617,(%esp)
     294:	e8 2f 3f 00 00       	call   41c8 <unlink>
     299:	83 c4 10             	add    $0x10,%esp
     29c:	85 c0                	test   %eax,%eax
     29e:	0f 85 bc 00 00 00    	jne    360 <openiputtest+0x11a>
    printf(stdout, "unlink failed\n");
    exit(0);
  }
  wait(NULL);
     2a4:	83 ec 0c             	sub    $0xc,%esp
     2a7:	6a 00                	push   $0x0
     2a9:	e8 d2 3e 00 00       	call   4180 <wait>
  printf(stdout, "openiput test ok\n");
     2ae:	83 c4 08             	add    $0x8,%esp
     2b1:	68 40 46 00 00       	push   $0x4640
     2b6:	ff 35 50 66 00 00    	push   0x6650
     2bc:	e8 12 40 00 00       	call   42d3 <printf>
}
     2c1:	83 c4 10             	add    $0x10,%esp
     2c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2c7:	c9                   	leave  
     2c8:	c3                   	ret    
    printf(stdout, "mkdir oidir failed\n");
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	68 1d 46 00 00       	push   $0x461d
     2d1:	ff 35 50 66 00 00    	push   0x6650
     2d7:	e8 f7 3f 00 00       	call   42d3 <printf>
    exit(0);
     2dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2e3:	e8 90 3e 00 00       	call   4178 <exit>
     2e8:	83 c4 10             	add    $0x10,%esp
     2eb:	eb 83                	jmp    270 <openiputtest+0x2a>
    printf(stdout, "fork failed\n");
     2ed:	83 ec 08             	sub    $0x8,%esp
     2f0:	68 b9 54 00 00       	push   $0x54b9
     2f5:	ff 35 50 66 00 00    	push   0x6650
     2fb:	e8 d3 3f 00 00       	call   42d3 <printf>
    exit(0);
     300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     307:	e8 6c 3e 00 00       	call   4178 <exit>
     30c:	83 c4 10             	add    $0x10,%esp
     30f:	e9 67 ff ff ff       	jmp    27b <openiputtest+0x35>
    int fd = open("oidir", O_RDWR);
     314:	83 ec 08             	sub    $0x8,%esp
     317:	6a 02                	push   $0x2
     319:	68 17 46 00 00       	push   $0x4617
     31e:	e8 95 3e 00 00       	call   41b8 <open>
    if(fd >= 0){
     323:	83 c4 10             	add    $0x10,%esp
     326:	85 c0                	test   %eax,%eax
     328:	79 12                	jns    33c <openiputtest+0xf6>
    exit(0);
     32a:	83 ec 0c             	sub    $0xc,%esp
     32d:	6a 00                	push   $0x0
     32f:	e8 44 3e 00 00       	call   4178 <exit>
     334:	83 c4 10             	add    $0x10,%esp
     337:	e9 47 ff ff ff       	jmp    283 <openiputtest+0x3d>
      printf(stdout, "open directory for write succeeded\n");
     33c:	83 ec 08             	sub    $0x8,%esp
     33f:	68 9c 55 00 00       	push   $0x559c
     344:	ff 35 50 66 00 00    	push   0x6650
     34a:	e8 84 3f 00 00       	call   42d3 <printf>
      exit(0);
     34f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     356:	e8 1d 3e 00 00       	call   4178 <exit>
     35b:	83 c4 10             	add    $0x10,%esp
     35e:	eb ca                	jmp    32a <openiputtest+0xe4>
    printf(stdout, "unlink failed\n");
     360:	83 ec 08             	sub    $0x8,%esp
     363:	68 31 46 00 00       	push   $0x4631
     368:	ff 35 50 66 00 00    	push   0x6650
     36e:	e8 60 3f 00 00       	call   42d3 <printf>
    exit(0);
     373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     37a:	e8 f9 3d 00 00       	call   4178 <exit>
     37f:	83 c4 10             	add    $0x10,%esp
     382:	e9 1d ff ff ff       	jmp    2a4 <openiputtest+0x5e>

00000387 <opentest>:

// simple file system tests

void
opentest(void)
{
     387:	55                   	push   %ebp
     388:	89 e5                	mov    %esp,%ebp
     38a:	53                   	push   %ebx
     38b:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(stdout, "open test\n");
     38e:	68 52 46 00 00       	push   $0x4652
     393:	ff 35 50 66 00 00    	push   0x6650
     399:	e8 35 3f 00 00       	call   42d3 <printf>
  fd = open("echo", 0);
     39e:	83 c4 08             	add    $0x8,%esp
     3a1:	6a 00                	push   $0x0
     3a3:	68 5d 46 00 00       	push   $0x465d
     3a8:	e8 0b 3e 00 00       	call   41b8 <open>
     3ad:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     3af:	83 c4 10             	add    $0x10,%esp
     3b2:	85 c0                	test   %eax,%eax
     3b4:	78 3a                	js     3f0 <opentest+0x69>
    printf(stdout, "open echo failed!\n");
    exit(0);
  }
  close(fd);
     3b6:	83 ec 0c             	sub    $0xc,%esp
     3b9:	53                   	push   %ebx
     3ba:	e8 e1 3d 00 00       	call   41a0 <close>
  fd = open("doesnotexist", 0);
     3bf:	83 c4 08             	add    $0x8,%esp
     3c2:	6a 00                	push   $0x0
     3c4:	68 75 46 00 00       	push   $0x4675
     3c9:	e8 ea 3d 00 00       	call   41b8 <open>
  if(fd >= 0){
     3ce:	83 c4 10             	add    $0x10,%esp
     3d1:	85 c0                	test   %eax,%eax
     3d3:	79 3f                	jns    414 <opentest+0x8d>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit(0);
  }
  printf(stdout, "open test ok\n");
     3d5:	83 ec 08             	sub    $0x8,%esp
     3d8:	68 a0 46 00 00       	push   $0x46a0
     3dd:	ff 35 50 66 00 00    	push   0x6650
     3e3:	e8 eb 3e 00 00       	call   42d3 <printf>
}
     3e8:	83 c4 10             	add    $0x10,%esp
     3eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3ee:	c9                   	leave  
     3ef:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     3f0:	83 ec 08             	sub    $0x8,%esp
     3f3:	68 62 46 00 00       	push   $0x4662
     3f8:	ff 35 50 66 00 00    	push   0x6650
     3fe:	e8 d0 3e 00 00       	call   42d3 <printf>
    exit(0);
     403:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     40a:	e8 69 3d 00 00       	call   4178 <exit>
     40f:	83 c4 10             	add    $0x10,%esp
     412:	eb a2                	jmp    3b6 <opentest+0x2f>
    printf(stdout, "open doesnotexist succeeded!\n");
     414:	83 ec 08             	sub    $0x8,%esp
     417:	68 82 46 00 00       	push   $0x4682
     41c:	ff 35 50 66 00 00    	push   0x6650
     422:	e8 ac 3e 00 00       	call   42d3 <printf>
    exit(0);
     427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     42e:	e8 45 3d 00 00       	call   4178 <exit>
     433:	83 c4 10             	add    $0x10,%esp
     436:	eb 9d                	jmp    3d5 <opentest+0x4e>

00000438 <writetest>:

void
writetest(void)
{
     438:	55                   	push   %ebp
     439:	89 e5                	mov    %esp,%ebp
     43b:	56                   	push   %esi
     43c:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     43d:	83 ec 08             	sub    $0x8,%esp
     440:	68 ae 46 00 00       	push   $0x46ae
     445:	ff 35 50 66 00 00    	push   0x6650
     44b:	e8 83 3e 00 00       	call   42d3 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     450:	83 c4 08             	add    $0x8,%esp
     453:	68 02 02 00 00       	push   $0x202
     458:	68 bf 46 00 00       	push   $0x46bf
     45d:	e8 56 3d 00 00       	call   41b8 <open>
     462:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
     464:	83 c4 10             	add    $0x10,%esp
     467:	85 c0                	test   %eax,%eax
     469:	78 1d                	js     488 <writetest+0x50>
    printf(stdout, "creat small succeeded; ok\n");
     46b:	83 ec 08             	sub    $0x8,%esp
     46e:	68 c5 46 00 00       	push   $0x46c5
     473:	ff 35 50 66 00 00    	push   0x6650
     479:	e8 55 3e 00 00       	call   42d3 <printf>
     47e:	83 c4 10             	add    $0x10,%esp
{
     481:	bb 00 00 00 00       	mov    $0x0,%ebx
     486:	eb 4a                	jmp    4d2 <writetest+0x9a>
  } else {
    printf(stdout, "error: creat small failed!\n");
     488:	83 ec 08             	sub    $0x8,%esp
     48b:	68 e0 46 00 00       	push   $0x46e0
     490:	ff 35 50 66 00 00    	push   0x6650
     496:	e8 38 3e 00 00       	call   42d3 <printf>
    exit(0);
     49b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4a2:	e8 d1 3c 00 00       	call   4178 <exit>
     4a7:	83 c4 10             	add    $0x10,%esp
     4aa:	eb d5                	jmp    481 <writetest+0x49>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
      printf(stdout, "error: write aa %d new file failed\n", i);
     4ac:	83 ec 04             	sub    $0x4,%esp
     4af:	53                   	push   %ebx
     4b0:	68 c0 55 00 00       	push   $0x55c0
     4b5:	ff 35 50 66 00 00    	push   0x6650
     4bb:	e8 13 3e 00 00       	call   42d3 <printf>
      exit(0);
     4c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4c7:	e8 ac 3c 00 00       	call   4178 <exit>
     4cc:	83 c4 10             	add    $0x10,%esp
     4cf:	eb 1e                	jmp    4ef <writetest+0xb7>
  for(i = 0; i < 100; i++){
     4d1:	43                   	inc    %ebx
     4d2:	83 fb 63             	cmp    $0x63,%ebx
     4d5:	7f 55                	jg     52c <writetest+0xf4>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4d7:	83 ec 04             	sub    $0x4,%esp
     4da:	6a 0a                	push   $0xa
     4dc:	68 fc 46 00 00       	push   $0x46fc
     4e1:	56                   	push   %esi
     4e2:	e8 b1 3c 00 00       	call   4198 <write>
     4e7:	83 c4 10             	add    $0x10,%esp
     4ea:	83 f8 0a             	cmp    $0xa,%eax
     4ed:	75 bd                	jne    4ac <writetest+0x74>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4ef:	83 ec 04             	sub    $0x4,%esp
     4f2:	6a 0a                	push   $0xa
     4f4:	68 07 47 00 00       	push   $0x4707
     4f9:	56                   	push   %esi
     4fa:	e8 99 3c 00 00       	call   4198 <write>
     4ff:	83 c4 10             	add    $0x10,%esp
     502:	83 f8 0a             	cmp    $0xa,%eax
     505:	74 ca                	je     4d1 <writetest+0x99>
      printf(stdout, "error: write bb %d new file failed\n", i);
     507:	83 ec 04             	sub    $0x4,%esp
     50a:	53                   	push   %ebx
     50b:	68 e4 55 00 00       	push   $0x55e4
     510:	ff 35 50 66 00 00    	push   0x6650
     516:	e8 b8 3d 00 00       	call   42d3 <printf>
      exit(0);
     51b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     522:	e8 51 3c 00 00       	call   4178 <exit>
     527:	83 c4 10             	add    $0x10,%esp
     52a:	eb a5                	jmp    4d1 <writetest+0x99>
    }
  }
  printf(stdout, "writes ok\n");
     52c:	83 ec 08             	sub    $0x8,%esp
     52f:	68 12 47 00 00       	push   $0x4712
     534:	ff 35 50 66 00 00    	push   0x6650
     53a:	e8 94 3d 00 00       	call   42d3 <printf>
  close(fd);
     53f:	89 34 24             	mov    %esi,(%esp)
     542:	e8 59 3c 00 00       	call   41a0 <close>
  fd = open("small", O_RDONLY);
     547:	83 c4 08             	add    $0x8,%esp
     54a:	6a 00                	push   $0x0
     54c:	68 bf 46 00 00       	push   $0x46bf
     551:	e8 62 3c 00 00       	call   41b8 <open>
     556:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     558:	83 c4 10             	add    $0x10,%esp
     55b:	85 c0                	test   %eax,%eax
     55d:	0f 88 92 00 00 00    	js     5f5 <writetest+0x1bd>
    printf(stdout, "open small succeeded ok\n");
     563:	83 ec 08             	sub    $0x8,%esp
     566:	68 1d 47 00 00       	push   $0x471d
     56b:	ff 35 50 66 00 00    	push   0x6650
     571:	e8 5d 3d 00 00       	call   42d3 <printf>
     576:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit(0);
  }
  i = read(fd, buf, 2000);
     579:	83 ec 04             	sub    $0x4,%esp
     57c:	68 d0 07 00 00       	push   $0x7d0
     581:	68 a0 8d 00 00       	push   $0x8da0
     586:	53                   	push   %ebx
     587:	e8 04 3c 00 00       	call   4190 <read>
  if(i == 2000){
     58c:	83 c4 10             	add    $0x10,%esp
     58f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     594:	0f 84 82 00 00 00    	je     61c <writetest+0x1e4>
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     59a:	83 ec 08             	sub    $0x8,%esp
     59d:	68 7d 4a 00 00       	push   $0x4a7d
     5a2:	ff 35 50 66 00 00    	push   0x6650
     5a8:	e8 26 3d 00 00       	call   42d3 <printf>
    exit(0);
     5ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5b4:	e8 bf 3b 00 00       	call   4178 <exit>
     5b9:	83 c4 10             	add    $0x10,%esp
  }
  close(fd);
     5bc:	83 ec 0c             	sub    $0xc,%esp
     5bf:	53                   	push   %ebx
     5c0:	e8 db 3b 00 00       	call   41a0 <close>

  if(unlink("small") < 0){
     5c5:	c7 04 24 bf 46 00 00 	movl   $0x46bf,(%esp)
     5cc:	e8 f7 3b 00 00       	call   41c8 <unlink>
     5d1:	83 c4 10             	add    $0x10,%esp
     5d4:	85 c0                	test   %eax,%eax
     5d6:	78 5c                	js     634 <writetest+0x1fc>
    printf(stdout, "unlink small failed\n");
    exit(0);
  }
  printf(stdout, "small file test ok\n");
     5d8:	83 ec 08             	sub    $0x8,%esp
     5db:	68 79 47 00 00       	push   $0x4779
     5e0:	ff 35 50 66 00 00    	push   0x6650
     5e6:	e8 e8 3c 00 00       	call   42d3 <printf>
}
     5eb:	83 c4 10             	add    $0x10,%esp
     5ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5f1:	5b                   	pop    %ebx
     5f2:	5e                   	pop    %esi
     5f3:	5d                   	pop    %ebp
     5f4:	c3                   	ret    
    printf(stdout, "error: open small failed!\n");
     5f5:	83 ec 08             	sub    $0x8,%esp
     5f8:	68 36 47 00 00       	push   $0x4736
     5fd:	ff 35 50 66 00 00    	push   0x6650
     603:	e8 cb 3c 00 00       	call   42d3 <printf>
    exit(0);
     608:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     60f:	e8 64 3b 00 00       	call   4178 <exit>
     614:	83 c4 10             	add    $0x10,%esp
     617:	e9 5d ff ff ff       	jmp    579 <writetest+0x141>
    printf(stdout, "read succeeded ok\n");
     61c:	83 ec 08             	sub    $0x8,%esp
     61f:	68 51 47 00 00       	push   $0x4751
     624:	ff 35 50 66 00 00    	push   0x6650
     62a:	e8 a4 3c 00 00       	call   42d3 <printf>
     62f:	83 c4 10             	add    $0x10,%esp
     632:	eb 88                	jmp    5bc <writetest+0x184>
    printf(stdout, "unlink small failed\n");
     634:	83 ec 08             	sub    $0x8,%esp
     637:	68 64 47 00 00       	push   $0x4764
     63c:	ff 35 50 66 00 00    	push   0x6650
     642:	e8 8c 3c 00 00       	call   42d3 <printf>
    exit(0);
     647:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     64e:	e8 25 3b 00 00       	call   4178 <exit>
     653:	83 c4 10             	add    $0x10,%esp
     656:	eb 80                	jmp    5d8 <writetest+0x1a0>

00000658 <writetest1>:

void
writetest1(void)
{
     658:	55                   	push   %ebp
     659:	89 e5                	mov    %esp,%ebp
     65b:	56                   	push   %esi
     65c:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     65d:	83 ec 08             	sub    $0x8,%esp
     660:	68 8d 47 00 00       	push   $0x478d
     665:	ff 35 50 66 00 00    	push   0x6650
     66b:	e8 63 3c 00 00       	call   42d3 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     670:	83 c4 08             	add    $0x8,%esp
     673:	68 02 02 00 00       	push   $0x202
     678:	68 07 48 00 00       	push   $0x4807
     67d:	e8 36 3b 00 00       	call   41b8 <open>
     682:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     684:	83 c4 10             	add    $0x10,%esp
     687:	85 c0                	test   %eax,%eax
     689:	78 07                	js     692 <writetest1+0x3a>
{
     68b:	bb 00 00 00 00       	mov    $0x0,%ebx
     690:	eb 25                	jmp    6b7 <writetest1+0x5f>
    printf(stdout, "error: creat big failed!\n");
     692:	83 ec 08             	sub    $0x8,%esp
     695:	68 9d 47 00 00       	push   $0x479d
     69a:	ff 35 50 66 00 00    	push   0x6650
     6a0:	e8 2e 3c 00 00       	call   42d3 <printf>
    exit(0);
     6a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6ac:	e8 c7 3a 00 00       	call   4178 <exit>
     6b1:	83 c4 10             	add    $0x10,%esp
     6b4:	eb d5                	jmp    68b <writetest1+0x33>
  }

  for(i = 0; i < MAXFILE; i++){
     6b6:	43                   	inc    %ebx
     6b7:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     6bd:	77 48                	ja     707 <writetest1+0xaf>
    ((int*)buf)[0] = i;
     6bf:	89 1d a0 8d 00 00    	mov    %ebx,0x8da0
    if(write(fd, buf, 512) != 512){
     6c5:	83 ec 04             	sub    $0x4,%esp
     6c8:	68 00 02 00 00       	push   $0x200
     6cd:	68 a0 8d 00 00       	push   $0x8da0
     6d2:	56                   	push   %esi
     6d3:	e8 c0 3a 00 00       	call   4198 <write>
     6d8:	83 c4 10             	add    $0x10,%esp
     6db:	3d 00 02 00 00       	cmp    $0x200,%eax
     6e0:	74 d4                	je     6b6 <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
     6e2:	83 ec 04             	sub    $0x4,%esp
     6e5:	53                   	push   %ebx
     6e6:	68 b7 47 00 00       	push   $0x47b7
     6eb:	ff 35 50 66 00 00    	push   0x6650
     6f1:	e8 dd 3b 00 00       	call   42d3 <printf>
      exit(0);
     6f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6fd:	e8 76 3a 00 00       	call   4178 <exit>
     702:	83 c4 10             	add    $0x10,%esp
     705:	eb af                	jmp    6b6 <writetest1+0x5e>
    }
  }

  close(fd);
     707:	83 ec 0c             	sub    $0xc,%esp
     70a:	56                   	push   %esi
     70b:	e8 90 3a 00 00       	call   41a0 <close>

  fd = open("big", O_RDONLY);
     710:	83 c4 08             	add    $0x8,%esp
     713:	6a 00                	push   $0x0
     715:	68 07 48 00 00       	push   $0x4807
     71a:	e8 99 3a 00 00       	call   41b8 <open>
     71f:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     721:	83 c4 10             	add    $0x10,%esp
     724:	85 c0                	test   %eax,%eax
     726:	78 0a                	js     732 <writetest1+0xda>
{
     728:	bb 00 00 00 00       	mov    $0x0,%ebx
     72d:	e9 b4 00 00 00       	jmp    7e6 <writetest1+0x18e>
    printf(stdout, "error: open big failed!\n");
     732:	83 ec 08             	sub    $0x8,%esp
     735:	68 d5 47 00 00       	push   $0x47d5
     73a:	ff 35 50 66 00 00    	push   0x6650
     740:	e8 8e 3b 00 00       	call   42d3 <printf>
    exit(0);
     745:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     74c:	e8 27 3a 00 00       	call   4178 <exit>
     751:	83 c4 10             	add    $0x10,%esp
     754:	eb d2                	jmp    728 <writetest1+0xd0>

  n = 0;
  for(;;){
    i = read(fd, buf, 512);
    if(i == 0){
      if(n == MAXFILE - 1){
     756:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     75c:	74 3d                	je     79b <writetest1+0x143>
             n, ((int*)buf)[0]);
      exit(0);
    }
    n++;
  }
  close(fd);
     75e:	83 ec 0c             	sub    $0xc,%esp
     761:	56                   	push   %esi
     762:	e8 39 3a 00 00       	call   41a0 <close>
  if(unlink("big") < 0){
     767:	c7 04 24 07 48 00 00 	movl   $0x4807,(%esp)
     76e:	e8 55 3a 00 00       	call   41c8 <unlink>
     773:	83 c4 10             	add    $0x10,%esp
     776:	85 c0                	test   %eax,%eax
     778:	0f 88 b9 00 00 00    	js     837 <writetest1+0x1df>
    printf(stdout, "unlink big failed\n");
    exit(0);
  }
  printf(stdout, "big files ok\n");
     77e:	83 ec 08             	sub    $0x8,%esp
     781:	68 2e 48 00 00       	push   $0x482e
     786:	ff 35 50 66 00 00    	push   0x6650
     78c:	e8 42 3b 00 00       	call   42d3 <printf>
}
     791:	83 c4 10             	add    $0x10,%esp
     794:	8d 65 f8             	lea    -0x8(%ebp),%esp
     797:	5b                   	pop    %ebx
     798:	5e                   	pop    %esi
     799:	5d                   	pop    %ebp
     79a:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     79b:	83 ec 04             	sub    $0x4,%esp
     79e:	53                   	push   %ebx
     79f:	68 ee 47 00 00       	push   $0x47ee
     7a4:	ff 35 50 66 00 00    	push   0x6650
     7aa:	e8 24 3b 00 00       	call   42d3 <printf>
        exit(0);
     7af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     7b6:	e8 bd 39 00 00       	call   4178 <exit>
     7bb:	83 c4 10             	add    $0x10,%esp
     7be:	eb 9e                	jmp    75e <writetest1+0x106>
      printf(stdout, "read failed %d\n", i);
     7c0:	83 ec 04             	sub    $0x4,%esp
     7c3:	50                   	push   %eax
     7c4:	68 0b 48 00 00       	push   $0x480b
     7c9:	ff 35 50 66 00 00    	push   0x6650
     7cf:	e8 ff 3a 00 00       	call   42d3 <printf>
      exit(0);
     7d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     7db:	e8 98 39 00 00       	call   4178 <exit>
     7e0:	83 c4 10             	add    $0x10,%esp
     7e3:	eb 26                	jmp    80b <writetest1+0x1b3>
    n++;
     7e5:	43                   	inc    %ebx
    i = read(fd, buf, 512);
     7e6:	83 ec 04             	sub    $0x4,%esp
     7e9:	68 00 02 00 00       	push   $0x200
     7ee:	68 a0 8d 00 00       	push   $0x8da0
     7f3:	56                   	push   %esi
     7f4:	e8 97 39 00 00       	call   4190 <read>
    if(i == 0){
     7f9:	83 c4 10             	add    $0x10,%esp
     7fc:	85 c0                	test   %eax,%eax
     7fe:	0f 84 52 ff ff ff    	je     756 <writetest1+0xfe>
    } else if(i != 512){
     804:	3d 00 02 00 00       	cmp    $0x200,%eax
     809:	75 b5                	jne    7c0 <writetest1+0x168>
    if(((int*)buf)[0] != n){
     80b:	a1 a0 8d 00 00       	mov    0x8da0,%eax
     810:	39 d8                	cmp    %ebx,%eax
     812:	74 d1                	je     7e5 <writetest1+0x18d>
      printf(stdout, "read content of block %d is %d\n",
     814:	50                   	push   %eax
     815:	53                   	push   %ebx
     816:	68 08 56 00 00       	push   $0x5608
     81b:	ff 35 50 66 00 00    	push   0x6650
     821:	e8 ad 3a 00 00       	call   42d3 <printf>
      exit(0);
     826:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     82d:	e8 46 39 00 00       	call   4178 <exit>
     832:	83 c4 10             	add    $0x10,%esp
     835:	eb ae                	jmp    7e5 <writetest1+0x18d>
    printf(stdout, "unlink big failed\n");
     837:	83 ec 08             	sub    $0x8,%esp
     83a:	68 1b 48 00 00       	push   $0x481b
     83f:	ff 35 50 66 00 00    	push   0x6650
     845:	e8 89 3a 00 00       	call   42d3 <printf>
    exit(0);
     84a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     851:	e8 22 39 00 00       	call   4178 <exit>
     856:	83 c4 10             	add    $0x10,%esp
     859:	e9 20 ff ff ff       	jmp    77e <writetest1+0x126>

0000085e <createtest>:

void
createtest(void)
{
     85e:	55                   	push   %ebp
     85f:	89 e5                	mov    %esp,%ebp
     861:	53                   	push   %ebx
     862:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     865:	68 28 56 00 00       	push   $0x5628
     86a:	ff 35 50 66 00 00    	push   0x6650
     870:	e8 5e 3a 00 00       	call   42d3 <printf>

  name[0] = 'a';
     875:	c6 05 90 8d 00 00 61 	movb   $0x61,0x8d90
  name[2] = '\0';
     87c:	c6 05 92 8d 00 00 00 	movb   $0x0,0x8d92
  for(i = 0; i < 52; i++){
     883:	83 c4 10             	add    $0x10,%esp
     886:	bb 00 00 00 00       	mov    $0x0,%ebx
     88b:	eb 26                	jmp    8b3 <createtest+0x55>
    name[1] = '0' + i;
     88d:	8d 43 30             	lea    0x30(%ebx),%eax
     890:	a2 91 8d 00 00       	mov    %al,0x8d91
    fd = open(name, O_CREATE|O_RDWR);
     895:	83 ec 08             	sub    $0x8,%esp
     898:	68 02 02 00 00       	push   $0x202
     89d:	68 90 8d 00 00       	push   $0x8d90
     8a2:	e8 11 39 00 00       	call   41b8 <open>
    close(fd);
     8a7:	89 04 24             	mov    %eax,(%esp)
     8aa:	e8 f1 38 00 00       	call   41a0 <close>
  for(i = 0; i < 52; i++){
     8af:	43                   	inc    %ebx
     8b0:	83 c4 10             	add    $0x10,%esp
     8b3:	83 fb 33             	cmp    $0x33,%ebx
     8b6:	7e d5                	jle    88d <createtest+0x2f>
  }
  name[0] = 'a';
     8b8:	c6 05 90 8d 00 00 61 	movb   $0x61,0x8d90
  name[2] = '\0';
     8bf:	c6 05 92 8d 00 00 00 	movb   $0x0,0x8d92
  for(i = 0; i < 52; i++){
     8c6:	bb 00 00 00 00       	mov    $0x0,%ebx
     8cb:	eb 19                	jmp    8e6 <createtest+0x88>
    name[1] = '0' + i;
     8cd:	8d 43 30             	lea    0x30(%ebx),%eax
     8d0:	a2 91 8d 00 00       	mov    %al,0x8d91
    unlink(name);
     8d5:	83 ec 0c             	sub    $0xc,%esp
     8d8:	68 90 8d 00 00       	push   $0x8d90
     8dd:	e8 e6 38 00 00       	call   41c8 <unlink>
  for(i = 0; i < 52; i++){
     8e2:	43                   	inc    %ebx
     8e3:	83 c4 10             	add    $0x10,%esp
     8e6:	83 fb 33             	cmp    $0x33,%ebx
     8e9:	7e e2                	jle    8cd <createtest+0x6f>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     8eb:	83 ec 08             	sub    $0x8,%esp
     8ee:	68 50 56 00 00       	push   $0x5650
     8f3:	ff 35 50 66 00 00    	push   0x6650
     8f9:	e8 d5 39 00 00       	call   42d3 <printf>
}
     8fe:	83 c4 10             	add    $0x10,%esp
     901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     904:	c9                   	leave  
     905:	c3                   	ret    

00000906 <dirtest>:

void dirtest(void)
{
     906:	55                   	push   %ebp
     907:	89 e5                	mov    %esp,%ebp
     909:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     90c:	68 3c 48 00 00       	push   $0x483c
     911:	ff 35 50 66 00 00    	push   0x6650
     917:	e8 b7 39 00 00       	call   42d3 <printf>

  if(mkdir("dir0") < 0){
     91c:	c7 04 24 48 48 00 00 	movl   $0x4848,(%esp)
     923:	e8 b8 38 00 00       	call   41e0 <mkdir>
     928:	83 c4 10             	add    $0x10,%esp
     92b:	85 c0                	test   %eax,%eax
     92d:	78 58                	js     987 <dirtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }

  if(chdir("dir0") < 0){
     92f:	83 ec 0c             	sub    $0xc,%esp
     932:	68 48 48 00 00       	push   $0x4848
     937:	e8 ac 38 00 00       	call   41e8 <chdir>
     93c:	83 c4 10             	add    $0x10,%esp
     93f:	85 c0                	test   %eax,%eax
     941:	78 68                	js     9ab <dirtest+0xa5>
    printf(stdout, "chdir dir0 failed\n");
    exit(0);
  }

  if(chdir("..") < 0){
     943:	83 ec 0c             	sub    $0xc,%esp
     946:	68 ed 4d 00 00       	push   $0x4ded
     94b:	e8 98 38 00 00       	call   41e8 <chdir>
     950:	83 c4 10             	add    $0x10,%esp
     953:	85 c0                	test   %eax,%eax
     955:	78 7b                	js     9d2 <dirtest+0xcc>
    printf(stdout, "chdir .. failed\n");
    exit(0);
  }

  if(unlink("dir0") < 0){
     957:	83 ec 0c             	sub    $0xc,%esp
     95a:	68 48 48 00 00       	push   $0x4848
     95f:	e8 64 38 00 00       	call   41c8 <unlink>
     964:	83 c4 10             	add    $0x10,%esp
     967:	85 c0                	test   %eax,%eax
     969:	0f 88 8a 00 00 00    	js     9f9 <dirtest+0xf3>
    printf(stdout, "unlink dir0 failed\n");
    exit(0);
  }
  printf(stdout, "mkdir test ok\n");
     96f:	83 ec 08             	sub    $0x8,%esp
     972:	68 85 48 00 00       	push   $0x4885
     977:	ff 35 50 66 00 00    	push   0x6650
     97d:	e8 51 39 00 00       	call   42d3 <printf>
}
     982:	83 c4 10             	add    $0x10,%esp
     985:	c9                   	leave  
     986:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     987:	83 ec 08             	sub    $0x8,%esp
     98a:	68 78 45 00 00       	push   $0x4578
     98f:	ff 35 50 66 00 00    	push   0x6650
     995:	e8 39 39 00 00       	call   42d3 <printf>
    exit(0);
     99a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9a1:	e8 d2 37 00 00       	call   4178 <exit>
     9a6:	83 c4 10             	add    $0x10,%esp
     9a9:	eb 84                	jmp    92f <dirtest+0x29>
    printf(stdout, "chdir dir0 failed\n");
     9ab:	83 ec 08             	sub    $0x8,%esp
     9ae:	68 4d 48 00 00       	push   $0x484d
     9b3:	ff 35 50 66 00 00    	push   0x6650
     9b9:	e8 15 39 00 00       	call   42d3 <printf>
    exit(0);
     9be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9c5:	e8 ae 37 00 00       	call   4178 <exit>
     9ca:	83 c4 10             	add    $0x10,%esp
     9cd:	e9 71 ff ff ff       	jmp    943 <dirtest+0x3d>
    printf(stdout, "chdir .. failed\n");
     9d2:	83 ec 08             	sub    $0x8,%esp
     9d5:	68 60 48 00 00       	push   $0x4860
     9da:	ff 35 50 66 00 00    	push   0x6650
     9e0:	e8 ee 38 00 00       	call   42d3 <printf>
    exit(0);
     9e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9ec:	e8 87 37 00 00       	call   4178 <exit>
     9f1:	83 c4 10             	add    $0x10,%esp
     9f4:	e9 5e ff ff ff       	jmp    957 <dirtest+0x51>
    printf(stdout, "unlink dir0 failed\n");
     9f9:	83 ec 08             	sub    $0x8,%esp
     9fc:	68 71 48 00 00       	push   $0x4871
     a01:	ff 35 50 66 00 00    	push   0x6650
     a07:	e8 c7 38 00 00       	call   42d3 <printf>
    exit(0);
     a0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a13:	e8 60 37 00 00       	call   4178 <exit>
     a18:	83 c4 10             	add    $0x10,%esp
     a1b:	e9 4f ff ff ff       	jmp    96f <dirtest+0x69>

00000a20 <exectest>:

void
exectest(void)
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     a26:	68 94 48 00 00       	push   $0x4894
     a2b:	ff 35 50 66 00 00    	push   0x6650
     a31:	e8 9d 38 00 00       	call   42d3 <printf>
  if(exec("echo", echoargv) < 0){
     a36:	83 c4 08             	add    $0x8,%esp
     a39:	68 54 66 00 00       	push   $0x6654
     a3e:	68 5d 46 00 00       	push   $0x465d
     a43:	e8 68 37 00 00       	call   41b0 <exec>
     a48:	83 c4 10             	add    $0x10,%esp
     a4b:	85 c0                	test   %eax,%eax
     a4d:	78 02                	js     a51 <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit(0);
  }
}
     a4f:	c9                   	leave  
     a50:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     a51:	83 ec 08             	sub    $0x8,%esp
     a54:	68 9f 48 00 00       	push   $0x489f
     a59:	ff 35 50 66 00 00    	push   0x6650
     a5f:	e8 6f 38 00 00       	call   42d3 <printf>
    exit(0);
     a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a6b:	e8 08 37 00 00       	call   4178 <exit>
     a70:	83 c4 10             	add    $0x10,%esp
}
     a73:	eb da                	jmp    a4f <exectest+0x2f>

00000a75 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     a75:	55                   	push   %ebp
     a76:	89 e5                	mov    %esp,%ebp
     a78:	57                   	push   %edi
     a79:	56                   	push   %esi
     a7a:	53                   	push   %ebx
     a7b:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     a7e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a81:	50                   	push   %eax
     a82:	e8 01 37 00 00       	call   4188 <pipe>
     a87:	83 c4 10             	add    $0x10,%esp
     a8a:	85 c0                	test   %eax,%eax
     a8c:	75 7a                	jne    b08 <pipe1+0x93>
    printf(1, "pipe() failed\n");
    exit(0);
  }
  pid = fork();
     a8e:	e8 dd 36 00 00       	call   4170 <fork>
     a93:	89 c6                	mov    %eax,%esi
  seq = 0;
  if(pid == 0){
     a95:	85 c0                	test   %eax,%eax
     a97:	0f 84 8e 00 00 00    	je     b2b <pipe1+0xb6>
        printf(1, "pipe1 oops 1\n");
        exit(0);
      }
    }
    exit(0);
  } else if(pid > 0){
     a9d:	0f 8e 97 01 00 00    	jle    c3a <pipe1+0x1c5>
    close(fds[1]);
     aa3:	83 ec 0c             	sub    $0xc,%esp
     aa6:	ff 75 e4             	push   -0x1c(%ebp)
     aa9:	e8 f2 36 00 00       	call   41a0 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     aae:	83 c4 10             	add    $0x10,%esp
    total = 0;
     ab1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    cc = 1;
     ab8:	be 01 00 00 00       	mov    $0x1,%esi
  seq = 0;
     abd:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((n = read(fds[0], buf, cc)) > 0){
     ac2:	83 ec 04             	sub    $0x4,%esp
     ac5:	56                   	push   %esi
     ac6:	68 a0 8d 00 00       	push   $0x8da0
     acb:	ff 75 e0             	push   -0x20(%ebp)
     ace:	e8 bd 36 00 00       	call   4190 <read>
     ad3:	89 c1                	mov    %eax,%ecx
     ad5:	83 c4 10             	add    $0x10,%esp
     ad8:	85 c0                	test   %eax,%eax
     ada:	0f 8e 13 01 00 00    	jle    bf3 <pipe1+0x17e>
      for(i = 0; i < n; i++){
     ae0:	b8 00 00 00 00       	mov    $0x0,%eax
     ae5:	89 df                	mov    %ebx,%edi
     ae7:	39 c8                	cmp    %ecx,%eax
     ae9:	0f 8d e5 00 00 00    	jge    bd4 <pipe1+0x15f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     aef:	0f be 98 a0 8d 00 00 	movsbl 0x8da0(%eax),%ebx
     af6:	8d 57 01             	lea    0x1(%edi),%edx
     af9:	31 fb                	xor    %edi,%ebx
     afb:	84 db                	test   %bl,%bl
     afd:	0f 85 bd 00 00 00    	jne    bc0 <pipe1+0x14b>
      for(i = 0; i < n; i++){
     b03:	40                   	inc    %eax
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     b04:	89 d7                	mov    %edx,%edi
     b06:	eb df                	jmp    ae7 <pipe1+0x72>
    printf(1, "pipe() failed\n");
     b08:	83 ec 08             	sub    $0x8,%esp
     b0b:	68 b1 48 00 00       	push   $0x48b1
     b10:	6a 01                	push   $0x1
     b12:	e8 bc 37 00 00       	call   42d3 <printf>
    exit(0);
     b17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b1e:	e8 55 36 00 00       	call   4178 <exit>
     b23:	83 c4 10             	add    $0x10,%esp
     b26:	e9 63 ff ff ff       	jmp    a8e <pipe1+0x19>
    close(fds[0]);
     b2b:	83 ec 0c             	sub    $0xc,%esp
     b2e:	ff 75 e0             	push   -0x20(%ebp)
     b31:	e8 6a 36 00 00       	call   41a0 <close>
    for(n = 0; n < 5; n++){
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 f7                	mov    %esi,%edi
  seq = 0;
     b3b:	89 f3                	mov    %esi,%ebx
    for(n = 0; n < 5; n++){
     b3d:	eb 31                	jmp    b70 <pipe1+0xfb>
        buf[i] = seq++;
     b3f:	88 98 a0 8d 00 00    	mov    %bl,0x8da0(%eax)
      for(i = 0; i < 1033; i++)
     b45:	40                   	inc    %eax
        buf[i] = seq++;
     b46:	8d 5b 01             	lea    0x1(%ebx),%ebx
      for(i = 0; i < 1033; i++)
     b49:	3d 08 04 00 00       	cmp    $0x408,%eax
     b4e:	7e ef                	jle    b3f <pipe1+0xca>
      if(write(fds[1], buf, 1033) != 1033){
     b50:	83 ec 04             	sub    $0x4,%esp
     b53:	68 09 04 00 00       	push   $0x409
     b58:	68 a0 8d 00 00       	push   $0x8da0
     b5d:	ff 75 e4             	push   -0x1c(%ebp)
     b60:	e8 33 36 00 00       	call   4198 <write>
     b65:	83 c4 10             	add    $0x10,%esp
     b68:	3d 09 04 00 00       	cmp    $0x409,%eax
     b6d:	75 0a                	jne    b79 <pipe1+0x104>
    for(n = 0; n < 5; n++){
     b6f:	47                   	inc    %edi
     b70:	83 ff 04             	cmp    $0x4,%edi
     b73:	7f 24                	jg     b99 <pipe1+0x124>
      for(i = 0; i < 1033; i++)
     b75:	89 f0                	mov    %esi,%eax
     b77:	eb d0                	jmp    b49 <pipe1+0xd4>
        printf(1, "pipe1 oops 1\n");
     b79:	83 ec 08             	sub    $0x8,%esp
     b7c:	68 c0 48 00 00       	push   $0x48c0
     b81:	6a 01                	push   $0x1
     b83:	e8 4b 37 00 00       	call   42d3 <printf>
        exit(0);
     b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b8f:	e8 e4 35 00 00       	call   4178 <exit>
     b94:	83 c4 10             	add    $0x10,%esp
     b97:	eb d6                	jmp    b6f <pipe1+0xfa>
    exit(0);
     b99:	83 ec 0c             	sub    $0xc,%esp
     b9c:	6a 00                	push   $0x0
     b9e:	e8 d5 35 00 00       	call   4178 <exit>
     ba3:	83 c4 10             	add    $0x10,%esp
    wait(NULL);
  } else {
    printf(1, "fork() failed\n");
    exit(0);
  }
  printf(1, "pipe1 ok\n");
     ba6:	83 ec 08             	sub    $0x8,%esp
     ba9:	68 02 49 00 00       	push   $0x4902
     bae:	6a 01                	push   $0x1
     bb0:	e8 1e 37 00 00       	call   42d3 <printf>
     bb5:	83 c4 10             	add    $0x10,%esp
}
     bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bbb:	5b                   	pop    %ebx
     bbc:	5e                   	pop    %esi
     bbd:	5f                   	pop    %edi
     bbe:	5d                   	pop    %ebp
     bbf:	c3                   	ret    
          printf(1, "pipe1 oops 2\n");
     bc0:	83 ec 08             	sub    $0x8,%esp
     bc3:	68 ce 48 00 00       	push   $0x48ce
     bc8:	6a 01                	push   $0x1
     bca:	e8 04 37 00 00       	call   42d3 <printf>
          return;
     bcf:	83 c4 10             	add    $0x10,%esp
     bd2:	eb e4                	jmp    bb8 <pipe1+0x143>
      total += n;
     bd4:	89 fb                	mov    %edi,%ebx
     bd6:	01 4d d4             	add    %ecx,-0x2c(%ebp)
      cc = cc * 2;
     bd9:	8d 04 36             	lea    (%esi,%esi,1),%eax
     bdc:	89 c6                	mov    %eax,%esi
      if(cc > sizeof(buf))
     bde:	3d 00 20 00 00       	cmp    $0x2000,%eax
     be3:	0f 86 d9 fe ff ff    	jbe    ac2 <pipe1+0x4d>
        cc = sizeof(buf);
     be9:	be 00 20 00 00       	mov    $0x2000,%esi
     bee:	e9 cf fe ff ff       	jmp    ac2 <pipe1+0x4d>
    if(total != 5 * 1033){
     bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     bf6:	3d 2d 14 00 00       	cmp    $0x142d,%eax
     bfb:	75 1c                	jne    c19 <pipe1+0x1a4>
    close(fds[0]);
     bfd:	83 ec 0c             	sub    $0xc,%esp
     c00:	ff 75 e0             	push   -0x20(%ebp)
     c03:	e8 98 35 00 00       	call   41a0 <close>
    wait(NULL);
     c08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c0f:	e8 6c 35 00 00       	call   4180 <wait>
     c14:	83 c4 10             	add    $0x10,%esp
     c17:	eb 8d                	jmp    ba6 <pipe1+0x131>
      printf(1, "pipe1 oops 3 total %d\n", total);
     c19:	83 ec 04             	sub    $0x4,%esp
     c1c:	50                   	push   %eax
     c1d:	68 dc 48 00 00       	push   $0x48dc
     c22:	6a 01                	push   $0x1
     c24:	e8 aa 36 00 00       	call   42d3 <printf>
      exit(0);
     c29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c30:	e8 43 35 00 00       	call   4178 <exit>
     c35:	83 c4 10             	add    $0x10,%esp
     c38:	eb c3                	jmp    bfd <pipe1+0x188>
    printf(1, "fork() failed\n");
     c3a:	83 ec 08             	sub    $0x8,%esp
     c3d:	68 f3 48 00 00       	push   $0x48f3
     c42:	6a 01                	push   $0x1
     c44:	e8 8a 36 00 00       	call   42d3 <printf>
    exit(0);
     c49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c50:	e8 23 35 00 00       	call   4178 <exit>
     c55:	83 c4 10             	add    $0x10,%esp
     c58:	e9 49 ff ff ff       	jmp    ba6 <pipe1+0x131>

00000c5d <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     c5d:	55                   	push   %ebp
     c5e:	89 e5                	mov    %esp,%ebp
     c60:	57                   	push   %edi
     c61:	56                   	push   %esi
     c62:	53                   	push   %ebx
     c63:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     c66:	68 0c 49 00 00       	push   $0x490c
     c6b:	6a 01                	push   $0x1
     c6d:	e8 61 36 00 00       	call   42d3 <printf>
  pid1 = fork();
     c72:	e8 f9 34 00 00       	call   4170 <fork>
  if(pid1 == 0)
     c77:	83 c4 10             	add    $0x10,%esp
     c7a:	85 c0                	test   %eax,%eax
     c7c:	75 02                	jne    c80 <preempt+0x23>
    for(;;)
     c7e:	eb fe                	jmp    c7e <preempt+0x21>
     c80:	89 c3                	mov    %eax,%ebx
      ;

  pid2 = fork();
     c82:	e8 e9 34 00 00       	call   4170 <fork>
     c87:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     c89:	85 c0                	test   %eax,%eax
     c8b:	75 02                	jne    c8f <preempt+0x32>
    for(;;)
     c8d:	eb fe                	jmp    c8d <preempt+0x30>
      ;

  pipe(pfds);
     c8f:	83 ec 0c             	sub    $0xc,%esp
     c92:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c95:	50                   	push   %eax
     c96:	e8 ed 34 00 00       	call   4188 <pipe>
  pid3 = fork();
     c9b:	e8 d0 34 00 00       	call   4170 <fork>
     ca0:	89 c7                	mov    %eax,%edi
  if(pid3 == 0){
     ca2:	83 c4 10             	add    $0x10,%esp
     ca5:	85 c0                	test   %eax,%eax
     ca7:	75 49                	jne    cf2 <preempt+0x95>
    close(pfds[0]);
     ca9:	83 ec 0c             	sub    $0xc,%esp
     cac:	ff 75 e0             	push   -0x20(%ebp)
     caf:	e8 ec 34 00 00       	call   41a0 <close>
    if(write(pfds[1], "x", 1) != 1)
     cb4:	83 c4 0c             	add    $0xc,%esp
     cb7:	6a 01                	push   $0x1
     cb9:	68 d1 4e 00 00       	push   $0x4ed1
     cbe:	ff 75 e4             	push   -0x1c(%ebp)
     cc1:	e8 d2 34 00 00       	call   4198 <write>
     cc6:	83 c4 10             	add    $0x10,%esp
     cc9:	83 f8 01             	cmp    $0x1,%eax
     ccc:	75 10                	jne    cde <preempt+0x81>
      printf(1, "preempt write error");
    close(pfds[1]);
     cce:	83 ec 0c             	sub    $0xc,%esp
     cd1:	ff 75 e4             	push   -0x1c(%ebp)
     cd4:	e8 c7 34 00 00       	call   41a0 <close>
     cd9:	83 c4 10             	add    $0x10,%esp
    for(;;)
     cdc:	eb fe                	jmp    cdc <preempt+0x7f>
      printf(1, "preempt write error");
     cde:	83 ec 08             	sub    $0x8,%esp
     ce1:	68 16 49 00 00       	push   $0x4916
     ce6:	6a 01                	push   $0x1
     ce8:	e8 e6 35 00 00       	call   42d3 <printf>
     ced:	83 c4 10             	add    $0x10,%esp
     cf0:	eb dc                	jmp    cce <preempt+0x71>
      ;
  }

  close(pfds[1]);
     cf2:	83 ec 0c             	sub    $0xc,%esp
     cf5:	ff 75 e4             	push   -0x1c(%ebp)
     cf8:	e8 a3 34 00 00       	call   41a0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     cfd:	83 c4 0c             	add    $0xc,%esp
     d00:	68 00 20 00 00       	push   $0x2000
     d05:	68 a0 8d 00 00       	push   $0x8da0
     d0a:	ff 75 e0             	push   -0x20(%ebp)
     d0d:	e8 7e 34 00 00       	call   4190 <read>
     d12:	83 c4 10             	add    $0x10,%esp
     d15:	83 f8 01             	cmp    $0x1,%eax
     d18:	74 1a                	je     d34 <preempt+0xd7>
    printf(1, "preempt read error");
     d1a:	83 ec 08             	sub    $0x8,%esp
     d1d:	68 2a 49 00 00       	push   $0x492a
     d22:	6a 01                	push   $0x1
     d24:	e8 aa 35 00 00       	call   42d3 <printf>
    return;
     d29:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait(NULL);
  wait(NULL);
  wait(NULL);
  printf(1, "preempt ok\n");
}
     d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d2f:	5b                   	pop    %ebx
     d30:	5e                   	pop    %esi
     d31:	5f                   	pop    %edi
     d32:	5d                   	pop    %ebp
     d33:	c3                   	ret    
  close(pfds[0]);
     d34:	83 ec 0c             	sub    $0xc,%esp
     d37:	ff 75 e0             	push   -0x20(%ebp)
     d3a:	e8 61 34 00 00       	call   41a0 <close>
  printf(1, "kill... ");
     d3f:	83 c4 08             	add    $0x8,%esp
     d42:	68 3d 49 00 00       	push   $0x493d
     d47:	6a 01                	push   $0x1
     d49:	e8 85 35 00 00       	call   42d3 <printf>
  kill(pid1);
     d4e:	89 1c 24             	mov    %ebx,(%esp)
     d51:	e8 52 34 00 00       	call   41a8 <kill>
  kill(pid2);
     d56:	89 34 24             	mov    %esi,(%esp)
     d59:	e8 4a 34 00 00       	call   41a8 <kill>
  kill(pid3);
     d5e:	89 3c 24             	mov    %edi,(%esp)
     d61:	e8 42 34 00 00       	call   41a8 <kill>
  printf(1, "wait... ");
     d66:	83 c4 08             	add    $0x8,%esp
     d69:	68 46 49 00 00       	push   $0x4946
     d6e:	6a 01                	push   $0x1
     d70:	e8 5e 35 00 00       	call   42d3 <printf>
  wait(NULL);
     d75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d7c:	e8 ff 33 00 00       	call   4180 <wait>
  wait(NULL);
     d81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d88:	e8 f3 33 00 00       	call   4180 <wait>
  wait(NULL);
     d8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d94:	e8 e7 33 00 00       	call   4180 <wait>
  printf(1, "preempt ok\n");
     d99:	83 c4 08             	add    $0x8,%esp
     d9c:	68 4f 49 00 00       	push   $0x494f
     da1:	6a 01                	push   $0x1
     da3:	e8 2b 35 00 00       	call   42d3 <printf>
     da8:	83 c4 10             	add    $0x10,%esp
     dab:	e9 7c ff ff ff       	jmp    d2c <preempt+0xcf>

00000db0 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     db0:	55                   	push   %ebp
     db1:	89 e5                	mov    %esp,%ebp
     db3:	56                   	push   %esi
     db4:	53                   	push   %ebx
  int i, pid;

  for(i = 0; i < 100; i++){
     db5:	be 00 00 00 00       	mov    $0x0,%esi
     dba:	eb 27                	jmp    de3 <exitwait+0x33>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     dbc:	83 ec 08             	sub    $0x8,%esp
     dbf:	68 b9 54 00 00       	push   $0x54b9
     dc4:	6a 01                	push   $0x1
     dc6:	e8 08 35 00 00       	call   42d3 <printf>
      return;
     dcb:	83 c4 10             	add    $0x10,%esp
    } else {
      exit(0);
    }
  }
  printf(1, "exitwait ok\n");
}
     dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dd1:	5b                   	pop    %ebx
     dd2:	5e                   	pop    %esi
     dd3:	5d                   	pop    %ebp
     dd4:	c3                   	ret    
      exit(0);
     dd5:	83 ec 0c             	sub    $0xc,%esp
     dd8:	6a 00                	push   $0x0
     dda:	e8 99 33 00 00       	call   4178 <exit>
     ddf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
     de2:	46                   	inc    %esi
     de3:	83 fe 63             	cmp    $0x63,%esi
     de6:	7f 32                	jg     e1a <exitwait+0x6a>
    pid = fork();
     de8:	e8 83 33 00 00       	call   4170 <fork>
     ded:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     def:	85 c0                	test   %eax,%eax
     df1:	78 c9                	js     dbc <exitwait+0xc>
    if(pid){
     df3:	74 e0                	je     dd5 <exitwait+0x25>
      if(wait(NULL) != pid){
     df5:	83 ec 0c             	sub    $0xc,%esp
     df8:	6a 00                	push   $0x0
     dfa:	e8 81 33 00 00       	call   4180 <wait>
     dff:	83 c4 10             	add    $0x10,%esp
     e02:	39 d8                	cmp    %ebx,%eax
     e04:	74 dc                	je     de2 <exitwait+0x32>
        printf(1, "wait wrong pid\n");
     e06:	83 ec 08             	sub    $0x8,%esp
     e09:	68 5b 49 00 00       	push   $0x495b
     e0e:	6a 01                	push   $0x1
     e10:	e8 be 34 00 00       	call   42d3 <printf>
        return;
     e15:	83 c4 10             	add    $0x10,%esp
     e18:	eb b4                	jmp    dce <exitwait+0x1e>
  printf(1, "exitwait ok\n");
     e1a:	83 ec 08             	sub    $0x8,%esp
     e1d:	68 6b 49 00 00       	push   $0x496b
     e22:	6a 01                	push   $0x1
     e24:	e8 aa 34 00 00       	call   42d3 <printf>
     e29:	83 c4 10             	add    $0x10,%esp
     e2c:	eb a0                	jmp    dce <exitwait+0x1e>

00000e2e <mem>:

void
mem(void)
{
     e2e:	55                   	push   %ebp
     e2f:	89 e5                	mov    %esp,%ebp
     e31:	57                   	push   %edi
     e32:	56                   	push   %esi
     e33:	53                   	push   %ebx
     e34:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     e37:	68 78 49 00 00       	push   $0x4978
     e3c:	6a 01                	push   $0x1
     e3e:	e8 90 34 00 00       	call   42d3 <printf>
  ppid = getpid();
     e43:	e8 b0 33 00 00       	call   41f8 <getpid>
     e48:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     e4a:	e8 21 33 00 00       	call   4170 <fork>
     e4f:	83 c4 10             	add    $0x10,%esp
     e52:	85 c0                	test   %eax,%eax
     e54:	0f 85 a2 00 00 00    	jne    efc <mem+0xce>
    m1 = 0;
     e5a:	bb 00 00 00 00       	mov    $0x0,%ebx
     e5f:	eb 04                	jmp    e65 <mem+0x37>
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
     e61:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     e63:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     e65:	83 ec 0c             	sub    $0xc,%esp
     e68:	68 11 27 00 00       	push   $0x2711
     e6d:	e8 81 36 00 00       	call   44f3 <malloc>
     e72:	83 c4 10             	add    $0x10,%esp
     e75:	85 c0                	test   %eax,%eax
     e77:	75 e8                	jne    e61 <mem+0x33>
     e79:	eb 10                	jmp    e8b <mem+0x5d>
    }
    while(m1){
      m2 = *(char**)m1;
     e7b:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     e7d:	83 ec 0c             	sub    $0xc,%esp
     e80:	53                   	push   %ebx
     e81:	e8 ad 35 00 00       	call   4433 <free>
     e86:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     e89:	89 fb                	mov    %edi,%ebx
    while(m1){
     e8b:	85 db                	test   %ebx,%ebx
     e8d:	75 ec                	jne    e7b <mem+0x4d>
    }
    m1 = malloc(1024*20);
     e8f:	83 ec 0c             	sub    $0xc,%esp
     e92:	68 00 50 00 00       	push   $0x5000
     e97:	e8 57 36 00 00       	call   44f3 <malloc>
     e9c:	89 c3                	mov    %eax,%ebx
    if(m1 == 0){
     e9e:	83 c4 10             	add    $0x10,%esp
     ea1:	85 c0                	test   %eax,%eax
     ea3:	74 2f                	je     ed4 <mem+0xa6>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit(0);
    }
    free(m1);
     ea5:	83 ec 0c             	sub    $0xc,%esp
     ea8:	53                   	push   %ebx
     ea9:	e8 85 35 00 00       	call   4433 <free>
    printf(1, "mem ok\n");
     eae:	83 c4 08             	add    $0x8,%esp
     eb1:	68 9c 49 00 00       	push   $0x499c
     eb6:	6a 01                	push   $0x1
     eb8:	e8 16 34 00 00       	call   42d3 <printf>
    exit(0);
     ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ec4:	e8 af 32 00 00       	call   4178 <exit>
     ec9:	83 c4 10             	add    $0x10,%esp
  } else {
    wait(NULL);
  }
}
     ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ecf:	5b                   	pop    %ebx
     ed0:	5e                   	pop    %esi
     ed1:	5f                   	pop    %edi
     ed2:	5d                   	pop    %ebp
     ed3:	c3                   	ret    
      printf(1, "couldn't allocate mem?!!\n");
     ed4:	83 ec 08             	sub    $0x8,%esp
     ed7:	68 82 49 00 00       	push   $0x4982
     edc:	6a 01                	push   $0x1
     ede:	e8 f0 33 00 00       	call   42d3 <printf>
      kill(ppid);
     ee3:	89 34 24             	mov    %esi,(%esp)
     ee6:	e8 bd 32 00 00       	call   41a8 <kill>
      exit(0);
     eeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ef2:	e8 81 32 00 00       	call   4178 <exit>
     ef7:	83 c4 10             	add    $0x10,%esp
     efa:	eb a9                	jmp    ea5 <mem+0x77>
    wait(NULL);
     efc:	83 ec 0c             	sub    $0xc,%esp
     eff:	6a 00                	push   $0x0
     f01:	e8 7a 32 00 00       	call   4180 <wait>
     f06:	83 c4 10             	add    $0x10,%esp
}
     f09:	eb c1                	jmp    ecc <mem+0x9e>

00000f0b <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     f0b:	55                   	push   %ebp
     f0c:	89 e5                	mov    %esp,%ebp
     f0e:	57                   	push   %edi
     f0f:	56                   	push   %esi
     f10:	53                   	push   %ebx
     f11:	83 ec 24             	sub    $0x24,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     f14:	68 a4 49 00 00       	push   $0x49a4
     f19:	6a 01                	push   $0x1
     f1b:	e8 b3 33 00 00       	call   42d3 <printf>

  unlink("sharedfd");
     f20:	c7 04 24 b3 49 00 00 	movl   $0x49b3,(%esp)
     f27:	e8 9c 32 00 00       	call   41c8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     f2c:	83 c4 08             	add    $0x8,%esp
     f2f:	68 02 02 00 00       	push   $0x202
     f34:	68 b3 49 00 00       	push   $0x49b3
     f39:	e8 7a 32 00 00       	call   41b8 <open>
  if(fd < 0){
     f3e:	83 c4 10             	add    $0x10,%esp
     f41:	85 c0                	test   %eax,%eax
     f43:	78 4b                	js     f90 <sharedfd+0x85>
     f45:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     f47:	e8 24 32 00 00       	call   4170 <fork>
     f4c:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     f4e:	85 c0                	test   %eax,%eax
     f50:	75 55                	jne    fa7 <sharedfd+0x9c>
     f52:	b8 63 00 00 00       	mov    $0x63,%eax
     f57:	83 ec 04             	sub    $0x4,%esp
     f5a:	6a 0a                	push   $0xa
     f5c:	50                   	push   %eax
     f5d:	8d 45 de             	lea    -0x22(%ebp),%eax
     f60:	50                   	push   %eax
     f61:	e8 e7 30 00 00       	call   404d <memset>
  for(i = 0; i < 1000; i++){
     f66:	83 c4 10             	add    $0x10,%esp
     f69:	bb 00 00 00 00       	mov    $0x0,%ebx
     f6e:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     f74:	7f 4a                	jg     fc0 <sharedfd+0xb5>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f76:	83 ec 04             	sub    $0x4,%esp
     f79:	6a 0a                	push   $0xa
     f7b:	8d 45 de             	lea    -0x22(%ebp),%eax
     f7e:	50                   	push   %eax
     f7f:	56                   	push   %esi
     f80:	e8 13 32 00 00       	call   4198 <write>
     f85:	83 c4 10             	add    $0x10,%esp
     f88:	83 f8 0a             	cmp    $0xa,%eax
     f8b:	75 21                	jne    fae <sharedfd+0xa3>
  for(i = 0; i < 1000; i++){
     f8d:	43                   	inc    %ebx
     f8e:	eb de                	jmp    f6e <sharedfd+0x63>
    printf(1, "fstests: cannot open sharedfd for writing");
     f90:	83 ec 08             	sub    $0x8,%esp
     f93:	68 78 56 00 00       	push   $0x5678
     f98:	6a 01                	push   $0x1
     f9a:	e8 34 33 00 00       	call   42d3 <printf>
    return;
     f9f:	83 c4 10             	add    $0x10,%esp
     fa2:	e9 f2 00 00 00       	jmp    1099 <sharedfd+0x18e>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     fa7:	b8 70 00 00 00       	mov    $0x70,%eax
     fac:	eb a9                	jmp    f57 <sharedfd+0x4c>
      printf(1, "fstests: write sharedfd failed\n");
     fae:	83 ec 08             	sub    $0x8,%esp
     fb1:	68 a4 56 00 00       	push   $0x56a4
     fb6:	6a 01                	push   $0x1
     fb8:	e8 16 33 00 00       	call   42d3 <printf>
      break;
     fbd:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     fc0:	85 ff                	test   %edi,%edi
     fc2:	75 55                	jne    1019 <sharedfd+0x10e>
    exit(0);
     fc4:	83 ec 0c             	sub    $0xc,%esp
     fc7:	6a 00                	push   $0x0
     fc9:	e8 aa 31 00 00       	call   4178 <exit>
     fce:	83 c4 10             	add    $0x10,%esp
  else
    wait(NULL);
  close(fd);
     fd1:	83 ec 0c             	sub    $0xc,%esp
     fd4:	56                   	push   %esi
     fd5:	e8 c6 31 00 00       	call   41a0 <close>
  fd = open("sharedfd", 0);
     fda:	83 c4 08             	add    $0x8,%esp
     fdd:	6a 00                	push   $0x0
     fdf:	68 b3 49 00 00       	push   $0x49b3
     fe4:	e8 cf 31 00 00       	call   41b8 <open>
     fe9:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     feb:	83 c4 10             	add    $0x10,%esp
     fee:	85 c0                	test   %eax,%eax
     ff0:	78 36                	js     1028 <sharedfd+0x11d>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     ff2:	be 00 00 00 00       	mov    $0x0,%esi
     ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     ffc:	83 ec 04             	sub    $0x4,%esp
     fff:	6a 0a                	push   $0xa
    1001:	8d 45 de             	lea    -0x22(%ebp),%eax
    1004:	50                   	push   %eax
    1005:	57                   	push   %edi
    1006:	e8 85 31 00 00       	call   4190 <read>
    100b:	83 c4 10             	add    $0x10,%esp
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 42                	jle    1054 <sharedfd+0x149>
    for(i = 0; i < sizeof(buf); i++){
    1012:	ba 00 00 00 00       	mov    $0x0,%edx
    1017:	eb 27                	jmp    1040 <sharedfd+0x135>
    wait(NULL);
    1019:	83 ec 0c             	sub    $0xc,%esp
    101c:	6a 00                	push   $0x0
    101e:	e8 5d 31 00 00       	call   4180 <wait>
    1023:	83 c4 10             	add    $0x10,%esp
    1026:	eb a9                	jmp    fd1 <sharedfd+0xc6>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1028:	83 ec 08             	sub    $0x8,%esp
    102b:	68 c4 56 00 00       	push   $0x56c4
    1030:	6a 01                	push   $0x1
    1032:	e8 9c 32 00 00       	call   42d3 <printf>
    return;
    1037:	83 c4 10             	add    $0x10,%esp
    103a:	eb 5d                	jmp    1099 <sharedfd+0x18e>
      if(buf[i] == 'c')
        nc++;
    103c:	43                   	inc    %ebx
    103d:	eb 0e                	jmp    104d <sharedfd+0x142>
    for(i = 0; i < sizeof(buf); i++){
    103f:	42                   	inc    %edx
    1040:	83 fa 09             	cmp    $0x9,%edx
    1043:	77 b7                	ja     ffc <sharedfd+0xf1>
      if(buf[i] == 'c')
    1045:	8a 44 15 de          	mov    -0x22(%ebp,%edx,1),%al
    1049:	3c 63                	cmp    $0x63,%al
    104b:	74 ef                	je     103c <sharedfd+0x131>
      if(buf[i] == 'p')
    104d:	3c 70                	cmp    $0x70,%al
    104f:	75 ee                	jne    103f <sharedfd+0x134>
        np++;
    1051:	46                   	inc    %esi
    1052:	eb eb                	jmp    103f <sharedfd+0x134>
    }
  }
  close(fd);
    1054:	83 ec 0c             	sub    $0xc,%esp
    1057:	57                   	push   %edi
    1058:	e8 43 31 00 00       	call   41a0 <close>
  unlink("sharedfd");
    105d:	c7 04 24 b3 49 00 00 	movl   $0x49b3,(%esp)
    1064:	e8 5f 31 00 00       	call   41c8 <unlink>
  if(nc == 10000 && np == 10000){
    1069:	83 c4 10             	add    $0x10,%esp
    106c:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    1072:	75 08                	jne    107c <sharedfd+0x171>
    1074:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
    107a:	74 25                	je     10a1 <sharedfd+0x196>
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    107c:	56                   	push   %esi
    107d:	53                   	push   %ebx
    107e:	68 c9 49 00 00       	push   $0x49c9
    1083:	6a 01                	push   $0x1
    1085:	e8 49 32 00 00       	call   42d3 <printf>
    exit(0);
    108a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1091:	e8 e2 30 00 00       	call   4178 <exit>
    1096:	83 c4 10             	add    $0x10,%esp
  }
}
    1099:	8d 65 f4             	lea    -0xc(%ebp),%esp
    109c:	5b                   	pop    %ebx
    109d:	5e                   	pop    %esi
    109e:	5f                   	pop    %edi
    109f:	5d                   	pop    %ebp
    10a0:	c3                   	ret    
    printf(1, "sharedfd ok\n");
    10a1:	83 ec 08             	sub    $0x8,%esp
    10a4:	68 bc 49 00 00       	push   $0x49bc
    10a9:	6a 01                	push   $0x1
    10ab:	e8 23 32 00 00       	call   42d3 <printf>
    10b0:	83 c4 10             	add    $0x10,%esp
    10b3:	eb e4                	jmp    1099 <sharedfd+0x18e>

000010b5 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    10b5:	55                   	push   %ebp
    10b6:	89 e5                	mov    %esp,%ebp
    10b8:	57                   	push   %edi
    10b9:	56                   	push   %esi
    10ba:	53                   	push   %ebx
    10bb:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    10be:	8d 7d d8             	lea    -0x28(%ebp),%edi
    10c1:	be 10 5d 00 00       	mov    $0x5d10,%esi
    10c6:	b9 04 00 00 00       	mov    $0x4,%ecx
    10cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  char *fname;

  printf(1, "fourfiles test\n");
    10cd:	68 de 49 00 00       	push   $0x49de
    10d2:	6a 01                	push   $0x1
    10d4:	e8 fa 31 00 00       	call   42d3 <printf>

  for(pi = 0; pi < 4; pi++){
    10d9:	83 c4 10             	add    $0x10,%esp
    10dc:	be 00 00 00 00       	mov    $0x0,%esi
    10e1:	eb 05                	jmp    10e8 <fourfiles+0x33>
    if(pid < 0){
      printf(1, "fork failed\n");
      exit(0);
    }

    if(pid == 0){
    10e3:	85 db                	test   %ebx,%ebx
    10e5:	74 45                	je     112c <fourfiles+0x77>
  for(pi = 0; pi < 4; pi++){
    10e7:	46                   	inc    %esi
    10e8:	83 fe 03             	cmp    $0x3,%esi
    10eb:	0f 8f e3 00 00 00    	jg     11d4 <fourfiles+0x11f>
    fname = names[pi];
    10f1:	8b 7c b5 d8          	mov    -0x28(%ebp,%esi,4),%edi
    unlink(fname);
    10f5:	83 ec 0c             	sub    $0xc,%esp
    10f8:	57                   	push   %edi
    10f9:	e8 ca 30 00 00       	call   41c8 <unlink>
    pid = fork();
    10fe:	e8 6d 30 00 00       	call   4170 <fork>
    1103:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1105:	83 c4 10             	add    $0x10,%esp
    1108:	85 c0                	test   %eax,%eax
    110a:	79 d7                	jns    10e3 <fourfiles+0x2e>
      printf(1, "fork failed\n");
    110c:	83 ec 08             	sub    $0x8,%esp
    110f:	68 b9 54 00 00       	push   $0x54b9
    1114:	6a 01                	push   $0x1
    1116:	e8 b8 31 00 00       	call   42d3 <printf>
      exit(0);
    111b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1122:	e8 51 30 00 00       	call   4178 <exit>
    1127:	83 c4 10             	add    $0x10,%esp
    112a:	eb b7                	jmp    10e3 <fourfiles+0x2e>
      fd = open(fname, O_CREATE | O_RDWR);
    112c:	83 ec 08             	sub    $0x8,%esp
    112f:	68 02 02 00 00       	push   $0x202
    1134:	57                   	push   %edi
    1135:	e8 7e 30 00 00       	call   41b8 <open>
    113a:	89 c7                	mov    %eax,%edi
      if(fd < 0){
    113c:	83 c4 10             	add    $0x10,%esp
    113f:	85 c0                	test   %eax,%eax
    1141:	78 1b                	js     115e <fourfiles+0xa9>
        printf(1, "create failed\n");
        exit(0);
      }

      memset(buf, '0'+pi, 512);
    1143:	83 ec 04             	sub    $0x4,%esp
    1146:	68 00 02 00 00       	push   $0x200
    114b:	8d 46 30             	lea    0x30(%esi),%eax
    114e:	50                   	push   %eax
    114f:	68 a0 8d 00 00       	push   $0x8da0
    1154:	e8 f4 2e 00 00       	call   404d <memset>
      for(i = 0; i < 12; i++){
    1159:	83 c4 10             	add    $0x10,%esp
    115c:	eb 21                	jmp    117f <fourfiles+0xca>
        printf(1, "create failed\n");
    115e:	83 ec 08             	sub    $0x8,%esp
    1161:	68 7f 4c 00 00       	push   $0x4c7f
    1166:	6a 01                	push   $0x1
    1168:	e8 66 31 00 00       	call   42d3 <printf>
        exit(0);
    116d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1174:	e8 ff 2f 00 00       	call   4178 <exit>
    1179:	83 c4 10             	add    $0x10,%esp
    117c:	eb c5                	jmp    1143 <fourfiles+0x8e>
      for(i = 0; i < 12; i++){
    117e:	43                   	inc    %ebx
    117f:	83 fb 0b             	cmp    $0xb,%ebx
    1182:	7f 3e                	jg     11c2 <fourfiles+0x10d>
        if((n = write(fd, buf, 500)) != 500){
    1184:	83 ec 04             	sub    $0x4,%esp
    1187:	68 f4 01 00 00       	push   $0x1f4
    118c:	68 a0 8d 00 00       	push   $0x8da0
    1191:	57                   	push   %edi
    1192:	e8 01 30 00 00       	call   4198 <write>
    1197:	83 c4 10             	add    $0x10,%esp
    119a:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    119f:	74 dd                	je     117e <fourfiles+0xc9>
          printf(1, "write failed %d\n", n);
    11a1:	83 ec 04             	sub    $0x4,%esp
    11a4:	50                   	push   %eax
    11a5:	68 ee 49 00 00       	push   $0x49ee
    11aa:	6a 01                	push   $0x1
    11ac:	e8 22 31 00 00       	call   42d3 <printf>
          exit(0);
    11b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11b8:	e8 bb 2f 00 00       	call   4178 <exit>
    11bd:	83 c4 10             	add    $0x10,%esp
    11c0:	eb bc                	jmp    117e <fourfiles+0xc9>
        }
      }
      exit(0);
    11c2:	83 ec 0c             	sub    $0xc,%esp
    11c5:	6a 00                	push   $0x0
    11c7:	e8 ac 2f 00 00       	call   4178 <exit>
    11cc:	83 c4 10             	add    $0x10,%esp
    11cf:	e9 13 ff ff ff       	jmp    10e7 <fourfiles+0x32>
    }
  }

  for(pi = 0; pi < 4; pi++){
    11d4:	bb 00 00 00 00       	mov    $0x0,%ebx
    11d9:	eb 0e                	jmp    11e9 <fourfiles+0x134>
    wait(NULL);
    11db:	83 ec 0c             	sub    $0xc,%esp
    11de:	6a 00                	push   $0x0
    11e0:	e8 9b 2f 00 00       	call   4180 <wait>
  for(pi = 0; pi < 4; pi++){
    11e5:	43                   	inc    %ebx
    11e6:	83 c4 10             	add    $0x10,%esp
    11e9:	83 fb 03             	cmp    $0x3,%ebx
    11ec:	7e ed                	jle    11db <fourfiles+0x126>
  }

  for(i = 0; i < 2; i++){
    11ee:	bf 00 00 00 00       	mov    $0x0,%edi
    11f3:	e9 82 00 00 00       	jmp    127a <fourfiles+0x1c5>
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11f8:	43                   	inc    %ebx
    11f9:	39 f3                	cmp    %esi,%ebx
    11fb:	7d 2e                	jge    122b <fourfiles+0x176>
        if(buf[j] != '0'+i){
    11fd:	0f be 93 a0 8d 00 00 	movsbl 0x8da0(%ebx),%edx
    1204:	8d 47 30             	lea    0x30(%edi),%eax
    1207:	39 c2                	cmp    %eax,%edx
    1209:	74 ed                	je     11f8 <fourfiles+0x143>
          printf(1, "wrong char\n");
    120b:	83 ec 08             	sub    $0x8,%esp
    120e:	68 ff 49 00 00       	push   $0x49ff
    1213:	6a 01                	push   $0x1
    1215:	e8 b9 30 00 00       	call   42d3 <printf>
          exit(0);
    121a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1221:	e8 52 2f 00 00       	call   4178 <exit>
    1226:	83 c4 10             	add    $0x10,%esp
    1229:	eb cd                	jmp    11f8 <fourfiles+0x143>
        }
      }
      total += n;
    122b:	01 75 d0             	add    %esi,-0x30(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    122e:	83 ec 04             	sub    $0x4,%esp
    1231:	68 00 20 00 00       	push   $0x2000
    1236:	68 a0 8d 00 00       	push   $0x8da0
    123b:	ff 75 d4             	push   -0x2c(%ebp)
    123e:	e8 4d 2f 00 00       	call   4190 <read>
    1243:	89 c6                	mov    %eax,%esi
    1245:	83 c4 10             	add    $0x10,%esp
    1248:	85 c0                	test   %eax,%eax
    124a:	7e 07                	jle    1253 <fourfiles+0x19e>
      for(j = 0; j < n; j++){
    124c:	bb 00 00 00 00       	mov    $0x0,%ebx
    1251:	eb a6                	jmp    11f9 <fourfiles+0x144>
    }
    close(fd);
    1253:	83 ec 0c             	sub    $0xc,%esp
    1256:	ff 75 d4             	push   -0x2c(%ebp)
    1259:	e8 42 2f 00 00       	call   41a0 <close>
    if(total != 12*500){
    125e:	83 c4 10             	add    $0x10,%esp
    1261:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1264:	3d 70 17 00 00       	cmp    $0x1770,%eax
    1269:	75 35                	jne    12a0 <fourfiles+0x1eb>
      printf(1, "wrong length %d\n", total);
      exit(0);
    }
    unlink(fname);
    126b:	83 ec 0c             	sub    $0xc,%esp
    126e:	ff 75 cc             	push   -0x34(%ebp)
    1271:	e8 52 2f 00 00       	call   41c8 <unlink>
  for(i = 0; i < 2; i++){
    1276:	47                   	inc    %edi
    1277:	83 c4 10             	add    $0x10,%esp
    127a:	83 ff 01             	cmp    $0x1,%edi
    127d:	7f 42                	jg     12c1 <fourfiles+0x20c>
    fname = names[i];
    127f:	8b 44 bd d8          	mov    -0x28(%ebp,%edi,4),%eax
    1283:	89 45 cc             	mov    %eax,-0x34(%ebp)
    fd = open(fname, 0);
    1286:	83 ec 08             	sub    $0x8,%esp
    1289:	6a 00                	push   $0x0
    128b:	50                   	push   %eax
    128c:	e8 27 2f 00 00       	call   41b8 <open>
    1291:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1294:	83 c4 10             	add    $0x10,%esp
    total = 0;
    1297:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    129e:	eb 8e                	jmp    122e <fourfiles+0x179>
      printf(1, "wrong length %d\n", total);
    12a0:	83 ec 04             	sub    $0x4,%esp
    12a3:	50                   	push   %eax
    12a4:	68 0b 4a 00 00       	push   $0x4a0b
    12a9:	6a 01                	push   $0x1
    12ab:	e8 23 30 00 00       	call   42d3 <printf>
      exit(0);
    12b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    12b7:	e8 bc 2e 00 00       	call   4178 <exit>
    12bc:	83 c4 10             	add    $0x10,%esp
    12bf:	eb aa                	jmp    126b <fourfiles+0x1b6>
  }

  printf(1, "fourfiles ok\n");
    12c1:	83 ec 08             	sub    $0x8,%esp
    12c4:	68 1c 4a 00 00       	push   $0x4a1c
    12c9:	6a 01                	push   $0x1
    12cb:	e8 03 30 00 00       	call   42d3 <printf>
}
    12d0:	83 c4 10             	add    $0x10,%esp
    12d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12d6:	5b                   	pop    %ebx
    12d7:	5e                   	pop    %esi
    12d8:	5f                   	pop    %edi
    12d9:	5d                   	pop    %ebp
    12da:	c3                   	ret    

000012db <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12db:	55                   	push   %ebp
    12dc:	89 e5                	mov    %esp,%ebp
    12de:	57                   	push   %edi
    12df:	56                   	push   %esi
    12e0:	53                   	push   %ebx
    12e1:	83 ec 34             	sub    $0x34,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12e4:	68 30 4a 00 00       	push   $0x4a30
    12e9:	6a 01                	push   $0x1
    12eb:	e8 e3 2f 00 00       	call   42d3 <printf>

  for(pi = 0; pi < 4; pi++){
    12f0:	83 c4 10             	add    $0x10,%esp
    12f3:	bf 00 00 00 00       	mov    $0x0,%edi
    12f8:	e9 ce 00 00 00       	jmp    13cb <createdelete+0xf0>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    12fd:	83 ec 08             	sub    $0x8,%esp
    1300:	68 b9 54 00 00       	push   $0x54b9
    1305:	6a 01                	push   $0x1
    1307:	e8 c7 2f 00 00       	call   42d3 <printf>
      exit(0);
    130c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1313:	e8 60 2e 00 00       	call   4178 <exit>
    1318:	83 c4 10             	add    $0x10,%esp
    131b:	e9 bf 00 00 00       	jmp    13df <createdelete+0x104>
      name[2] = '\0';
      for(i = 0; i < N; i++){
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
    1320:	83 ec 08             	sub    $0x8,%esp
    1323:	68 7f 4c 00 00       	push   $0x4c7f
    1328:	6a 01                	push   $0x1
    132a:	e8 a4 2f 00 00       	call   42d3 <printf>
          exit(0);
    132f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1336:	e8 3d 2e 00 00       	call   4178 <exit>
    133b:	83 c4 10             	add    $0x10,%esp
    133e:	eb 26                	jmp    1366 <createdelete+0x8b>
      for(i = 0; i < N; i++){
    1340:	43                   	inc    %ebx
    1341:	83 fb 13             	cmp    $0x13,%ebx
    1344:	7f 77                	jg     13bd <createdelete+0xe2>
        name[1] = '0' + i;
    1346:	8d 43 30             	lea    0x30(%ebx),%eax
    1349:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    134c:	83 ec 08             	sub    $0x8,%esp
    134f:	68 02 02 00 00       	push   $0x202
    1354:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1357:	50                   	push   %eax
    1358:	e8 5b 2e 00 00       	call   41b8 <open>
    135d:	89 c6                	mov    %eax,%esi
        if(fd < 0){
    135f:	83 c4 10             	add    $0x10,%esp
    1362:	85 c0                	test   %eax,%eax
    1364:	78 ba                	js     1320 <createdelete+0x45>
        }
        close(fd);
    1366:	83 ec 0c             	sub    $0xc,%esp
    1369:	56                   	push   %esi
    136a:	e8 31 2e 00 00       	call   41a0 <close>
        if(i > 0 && (i % 2 ) == 0){
    136f:	83 c4 10             	add    $0x10,%esp
    1372:	85 db                	test   %ebx,%ebx
    1374:	7e ca                	jle    1340 <createdelete+0x65>
    1376:	f6 c3 01             	test   $0x1,%bl
    1379:	75 c5                	jne    1340 <createdelete+0x65>
          name[1] = '0' + (i / 2);
    137b:	89 d8                	mov    %ebx,%eax
    137d:	c1 e8 1f             	shr    $0x1f,%eax
    1380:	01 d8                	add    %ebx,%eax
    1382:	d1 f8                	sar    %eax
    1384:	83 c0 30             	add    $0x30,%eax
    1387:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    138a:	83 ec 0c             	sub    $0xc,%esp
    138d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1390:	50                   	push   %eax
    1391:	e8 32 2e 00 00       	call   41c8 <unlink>
    1396:	83 c4 10             	add    $0x10,%esp
    1399:	85 c0                	test   %eax,%eax
    139b:	79 a3                	jns    1340 <createdelete+0x65>
            printf(1, "unlink failed\n");
    139d:	83 ec 08             	sub    $0x8,%esp
    13a0:	68 31 46 00 00       	push   $0x4631
    13a5:	6a 01                	push   $0x1
    13a7:	e8 27 2f 00 00       	call   42d3 <printf>
            exit(0);
    13ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    13b3:	e8 c0 2d 00 00       	call   4178 <exit>
    13b8:	83 c4 10             	add    $0x10,%esp
    13bb:	eb 83                	jmp    1340 <createdelete+0x65>
          }
        }
      }
      exit(0);
    13bd:	83 ec 0c             	sub    $0xc,%esp
    13c0:	6a 00                	push   $0x0
    13c2:	e8 b1 2d 00 00       	call   4178 <exit>
    13c7:	83 c4 10             	add    $0x10,%esp
  for(pi = 0; pi < 4; pi++){
    13ca:	47                   	inc    %edi
    13cb:	83 ff 03             	cmp    $0x3,%edi
    13ce:	7f 22                	jg     13f2 <createdelete+0x117>
    pid = fork();
    13d0:	e8 9b 2d 00 00       	call   4170 <fork>
    13d5:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    13d7:	85 c0                	test   %eax,%eax
    13d9:	0f 88 1e ff ff ff    	js     12fd <createdelete+0x22>
    if(pid == 0){
    13df:	85 db                	test   %ebx,%ebx
    13e1:	75 e7                	jne    13ca <createdelete+0xef>
      name[0] = 'p' + pi;
    13e3:	8d 47 70             	lea    0x70(%edi),%eax
    13e6:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    13e9:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    13ed:	e9 4f ff ff ff       	jmp    1341 <createdelete+0x66>
    }
  }

  for(pi = 0; pi < 4; pi++){
    13f2:	bb 00 00 00 00       	mov    $0x0,%ebx
    13f7:	eb 0e                	jmp    1407 <createdelete+0x12c>
    wait(NULL);
    13f9:	83 ec 0c             	sub    $0xc,%esp
    13fc:	6a 00                	push   $0x0
    13fe:	e8 7d 2d 00 00       	call   4180 <wait>
  for(pi = 0; pi < 4; pi++){
    1403:	43                   	inc    %ebx
    1404:	83 c4 10             	add    $0x10,%esp
    1407:	83 fb 03             	cmp    $0x3,%ebx
    140a:	7e ed                	jle    13f9 <createdelete+0x11e>
  }

  name[0] = name[1] = name[2] = 0;
    140c:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1410:	c6 45 c9 00          	movb   $0x0,-0x37(%ebp)
    1414:	c6 45 c8 00          	movb   $0x0,-0x38(%ebp)
  for(i = 0; i < N; i++){
    1418:	bf 00 00 00 00       	mov    $0x0,%edi
    141d:	e9 a9 00 00 00       	jmp    14cb <createdelete+0x1f0>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
    1422:	85 db                	test   %ebx,%ebx
    1424:	78 44                	js     146a <createdelete+0x18f>
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit(0);
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1426:	8d 47 ff             	lea    -0x1(%edi),%eax
    1429:	83 f8 08             	cmp    $0x8,%eax
    142c:	76 60                	jbe    148e <createdelete+0x1b3>
        printf(1, "oops createdelete %s did exist\n", name);
        exit(0);
      }
      if(fd >= 0)
    142e:	85 db                	test   %ebx,%ebx
    1430:	0f 89 83 00 00 00    	jns    14b9 <createdelete+0x1de>
    for(pi = 0; pi < 4; pi++){
    1436:	46                   	inc    %esi
    1437:	83 fe 03             	cmp    $0x3,%esi
    143a:	0f 8f 8a 00 00 00    	jg     14ca <createdelete+0x1ef>
      name[0] = 'p' + pi;
    1440:	8d 46 70             	lea    0x70(%esi),%eax
    1443:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1446:	8d 47 30             	lea    0x30(%edi),%eax
    1449:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    144c:	83 ec 08             	sub    $0x8,%esp
    144f:	6a 00                	push   $0x0
    1451:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1454:	50                   	push   %eax
    1455:	e8 5e 2d 00 00       	call   41b8 <open>
    145a:	89 c3                	mov    %eax,%ebx
      if((i == 0 || i >= N/2) && fd < 0){
    145c:	83 c4 10             	add    $0x10,%esp
    145f:	85 ff                	test   %edi,%edi
    1461:	74 bf                	je     1422 <createdelete+0x147>
    1463:	83 ff 09             	cmp    $0x9,%edi
    1466:	7e be                	jle    1426 <createdelete+0x14b>
    1468:	eb b8                	jmp    1422 <createdelete+0x147>
        printf(1, "oops createdelete %s didn't exist\n", name);
    146a:	83 ec 04             	sub    $0x4,%esp
    146d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1470:	50                   	push   %eax
    1471:	68 f0 56 00 00       	push   $0x56f0
    1476:	6a 01                	push   $0x1
    1478:	e8 56 2e 00 00       	call   42d3 <printf>
        exit(0);
    147d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1484:	e8 ef 2c 00 00       	call   4178 <exit>
    1489:	83 c4 10             	add    $0x10,%esp
    148c:	eb a0                	jmp    142e <createdelete+0x153>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    148e:	85 db                	test   %ebx,%ebx
    1490:	78 9c                	js     142e <createdelete+0x153>
        printf(1, "oops createdelete %s did exist\n", name);
    1492:	83 ec 04             	sub    $0x4,%esp
    1495:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1498:	50                   	push   %eax
    1499:	68 14 57 00 00       	push   $0x5714
    149e:	6a 01                	push   $0x1
    14a0:	e8 2e 2e 00 00       	call   42d3 <printf>
        exit(0);
    14a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14ac:	e8 c7 2c 00 00       	call   4178 <exit>
    14b1:	83 c4 10             	add    $0x10,%esp
    14b4:	e9 75 ff ff ff       	jmp    142e <createdelete+0x153>
        close(fd);
    14b9:	83 ec 0c             	sub    $0xc,%esp
    14bc:	53                   	push   %ebx
    14bd:	e8 de 2c 00 00       	call   41a0 <close>
    14c2:	83 c4 10             	add    $0x10,%esp
    14c5:	e9 6c ff ff ff       	jmp    1436 <createdelete+0x15b>
  for(i = 0; i < N; i++){
    14ca:	47                   	inc    %edi
    14cb:	83 ff 13             	cmp    $0x13,%edi
    14ce:	7f 0a                	jg     14da <createdelete+0x1ff>
    for(pi = 0; pi < 4; pi++){
    14d0:	be 00 00 00 00       	mov    $0x0,%esi
    14d5:	e9 5d ff ff ff       	jmp    1437 <createdelete+0x15c>
    }
  }

  for(i = 0; i < N; i++){
    14da:	be 00 00 00 00       	mov    $0x0,%esi
    14df:	eb 22                	jmp    1503 <createdelete+0x228>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    14e1:	8d 46 70             	lea    0x70(%esi),%eax
    14e4:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14e7:	8d 46 30             	lea    0x30(%esi),%eax
    14ea:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14ed:	83 ec 0c             	sub    $0xc,%esp
    14f0:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14f3:	50                   	push   %eax
    14f4:	e8 cf 2c 00 00       	call   41c8 <unlink>
    for(pi = 0; pi < 4; pi++){
    14f9:	43                   	inc    %ebx
    14fa:	83 c4 10             	add    $0x10,%esp
    14fd:	83 fb 03             	cmp    $0x3,%ebx
    1500:	7e df                	jle    14e1 <createdelete+0x206>
  for(i = 0; i < N; i++){
    1502:	46                   	inc    %esi
    1503:	83 fe 13             	cmp    $0x13,%esi
    1506:	7f 07                	jg     150f <createdelete+0x234>
    for(pi = 0; pi < 4; pi++){
    1508:	bb 00 00 00 00       	mov    $0x0,%ebx
    150d:	eb ee                	jmp    14fd <createdelete+0x222>
    }
  }

  printf(1, "createdelete ok\n");
    150f:	83 ec 08             	sub    $0x8,%esp
    1512:	68 43 4a 00 00       	push   $0x4a43
    1517:	6a 01                	push   $0x1
    1519:	e8 b5 2d 00 00       	call   42d3 <printf>
}
    151e:	83 c4 10             	add    $0x10,%esp
    1521:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1524:	5b                   	pop    %ebx
    1525:	5e                   	pop    %esi
    1526:	5f                   	pop    %edi
    1527:	5d                   	pop    %ebp
    1528:	c3                   	ret    

00001529 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1529:	55                   	push   %ebp
    152a:	89 e5                	mov    %esp,%ebp
    152c:	56                   	push   %esi
    152d:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    152e:	83 ec 08             	sub    $0x8,%esp
    1531:	68 54 4a 00 00       	push   $0x4a54
    1536:	6a 01                	push   $0x1
    1538:	e8 96 2d 00 00       	call   42d3 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    153d:	83 c4 08             	add    $0x8,%esp
    1540:	68 02 02 00 00       	push   $0x202
    1545:	68 65 4a 00 00       	push   $0x4a65
    154a:	e8 69 2c 00 00       	call   41b8 <open>
    154f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1551:	83 c4 10             	add    $0x10,%esp
    1554:	85 c0                	test   %eax,%eax
    1556:	0f 88 ee 00 00 00    	js     164a <unlinkread+0x121>
    printf(1, "create unlinkread failed\n");
    exit(0);
  }
  write(fd, "hello", 5);
    155c:	83 ec 04             	sub    $0x4,%esp
    155f:	6a 05                	push   $0x5
    1561:	68 8a 4a 00 00       	push   $0x4a8a
    1566:	53                   	push   %ebx
    1567:	e8 2c 2c 00 00       	call   4198 <write>
  close(fd);
    156c:	89 1c 24             	mov    %ebx,(%esp)
    156f:	e8 2c 2c 00 00       	call   41a0 <close>

  fd = open("unlinkread", O_RDWR);
    1574:	83 c4 08             	add    $0x8,%esp
    1577:	6a 02                	push   $0x2
    1579:	68 65 4a 00 00       	push   $0x4a65
    157e:	e8 35 2c 00 00       	call   41b8 <open>
    1583:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1585:	83 c4 10             	add    $0x10,%esp
    1588:	85 c0                	test   %eax,%eax
    158a:	0f 88 dd 00 00 00    	js     166d <unlinkread+0x144>
    printf(1, "open unlinkread failed\n");
    exit(0);
  }
  if(unlink("unlinkread") != 0){
    1590:	83 ec 0c             	sub    $0xc,%esp
    1593:	68 65 4a 00 00       	push   $0x4a65
    1598:	e8 2b 2c 00 00       	call   41c8 <unlink>
    159d:	83 c4 10             	add    $0x10,%esp
    15a0:	85 c0                	test   %eax,%eax
    15a2:	0f 85 e8 00 00 00    	jne    1690 <unlinkread+0x167>
    printf(1, "unlink unlinkread failed\n");
    exit(0);
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15a8:	83 ec 08             	sub    $0x8,%esp
    15ab:	68 02 02 00 00       	push   $0x202
    15b0:	68 65 4a 00 00       	push   $0x4a65
    15b5:	e8 fe 2b 00 00       	call   41b8 <open>
    15ba:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    15bc:	83 c4 0c             	add    $0xc,%esp
    15bf:	6a 03                	push   $0x3
    15c1:	68 c2 4a 00 00       	push   $0x4ac2
    15c6:	50                   	push   %eax
    15c7:	e8 cc 2b 00 00       	call   4198 <write>
  close(fd1);
    15cc:	89 34 24             	mov    %esi,(%esp)
    15cf:	e8 cc 2b 00 00       	call   41a0 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    15d4:	83 c4 0c             	add    $0xc,%esp
    15d7:	68 00 20 00 00       	push   $0x2000
    15dc:	68 a0 8d 00 00       	push   $0x8da0
    15e1:	53                   	push   %ebx
    15e2:	e8 a9 2b 00 00       	call   4190 <read>
    15e7:	83 c4 10             	add    $0x10,%esp
    15ea:	83 f8 05             	cmp    $0x5,%eax
    15ed:	0f 85 c0 00 00 00    	jne    16b3 <unlinkread+0x18a>
    printf(1, "unlinkread read failed");
    exit(0);
  }
  if(buf[0] != 'h'){
    15f3:	80 3d a0 8d 00 00 68 	cmpb   $0x68,0x8da0
    15fa:	0f 85 d6 00 00 00    	jne    16d6 <unlinkread+0x1ad>
    printf(1, "unlinkread wrong data\n");
    exit(0);
  }
  if(write(fd, buf, 10) != 10){
    1600:	83 ec 04             	sub    $0x4,%esp
    1603:	6a 0a                	push   $0xa
    1605:	68 a0 8d 00 00       	push   $0x8da0
    160a:	53                   	push   %ebx
    160b:	e8 88 2b 00 00       	call   4198 <write>
    1610:	83 c4 10             	add    $0x10,%esp
    1613:	83 f8 0a             	cmp    $0xa,%eax
    1616:	0f 85 dd 00 00 00    	jne    16f9 <unlinkread+0x1d0>
    printf(1, "unlinkread write failed\n");
    exit(0);
  }
  close(fd);
    161c:	83 ec 0c             	sub    $0xc,%esp
    161f:	53                   	push   %ebx
    1620:	e8 7b 2b 00 00       	call   41a0 <close>
  unlink("unlinkread");
    1625:	c7 04 24 65 4a 00 00 	movl   $0x4a65,(%esp)
    162c:	e8 97 2b 00 00       	call   41c8 <unlink>
  printf(1, "unlinkread ok\n");
    1631:	83 c4 08             	add    $0x8,%esp
    1634:	68 0d 4b 00 00       	push   $0x4b0d
    1639:	6a 01                	push   $0x1
    163b:	e8 93 2c 00 00       	call   42d3 <printf>
}
    1640:	83 c4 10             	add    $0x10,%esp
    1643:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1646:	5b                   	pop    %ebx
    1647:	5e                   	pop    %esi
    1648:	5d                   	pop    %ebp
    1649:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    164a:	83 ec 08             	sub    $0x8,%esp
    164d:	68 70 4a 00 00       	push   $0x4a70
    1652:	6a 01                	push   $0x1
    1654:	e8 7a 2c 00 00       	call   42d3 <printf>
    exit(0);
    1659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1660:	e8 13 2b 00 00       	call   4178 <exit>
    1665:	83 c4 10             	add    $0x10,%esp
    1668:	e9 ef fe ff ff       	jmp    155c <unlinkread+0x33>
    printf(1, "open unlinkread failed\n");
    166d:	83 ec 08             	sub    $0x8,%esp
    1670:	68 90 4a 00 00       	push   $0x4a90
    1675:	6a 01                	push   $0x1
    1677:	e8 57 2c 00 00       	call   42d3 <printf>
    exit(0);
    167c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1683:	e8 f0 2a 00 00       	call   4178 <exit>
    1688:	83 c4 10             	add    $0x10,%esp
    168b:	e9 00 ff ff ff       	jmp    1590 <unlinkread+0x67>
    printf(1, "unlink unlinkread failed\n");
    1690:	83 ec 08             	sub    $0x8,%esp
    1693:	68 a8 4a 00 00       	push   $0x4aa8
    1698:	6a 01                	push   $0x1
    169a:	e8 34 2c 00 00       	call   42d3 <printf>
    exit(0);
    169f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16a6:	e8 cd 2a 00 00       	call   4178 <exit>
    16ab:	83 c4 10             	add    $0x10,%esp
    16ae:	e9 f5 fe ff ff       	jmp    15a8 <unlinkread+0x7f>
    printf(1, "unlinkread read failed");
    16b3:	83 ec 08             	sub    $0x8,%esp
    16b6:	68 c6 4a 00 00       	push   $0x4ac6
    16bb:	6a 01                	push   $0x1
    16bd:	e8 11 2c 00 00       	call   42d3 <printf>
    exit(0);
    16c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16c9:	e8 aa 2a 00 00       	call   4178 <exit>
    16ce:	83 c4 10             	add    $0x10,%esp
    16d1:	e9 1d ff ff ff       	jmp    15f3 <unlinkread+0xca>
    printf(1, "unlinkread wrong data\n");
    16d6:	83 ec 08             	sub    $0x8,%esp
    16d9:	68 dd 4a 00 00       	push   $0x4add
    16de:	6a 01                	push   $0x1
    16e0:	e8 ee 2b 00 00       	call   42d3 <printf>
    exit(0);
    16e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16ec:	e8 87 2a 00 00       	call   4178 <exit>
    16f1:	83 c4 10             	add    $0x10,%esp
    16f4:	e9 07 ff ff ff       	jmp    1600 <unlinkread+0xd7>
    printf(1, "unlinkread write failed\n");
    16f9:	83 ec 08             	sub    $0x8,%esp
    16fc:	68 f4 4a 00 00       	push   $0x4af4
    1701:	6a 01                	push   $0x1
    1703:	e8 cb 2b 00 00       	call   42d3 <printf>
    exit(0);
    1708:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    170f:	e8 64 2a 00 00       	call   4178 <exit>
    1714:	83 c4 10             	add    $0x10,%esp
    1717:	e9 00 ff ff ff       	jmp    161c <unlinkread+0xf3>

0000171c <linktest>:

void
linktest(void)
{
    171c:	55                   	push   %ebp
    171d:	89 e5                	mov    %esp,%ebp
    171f:	53                   	push   %ebx
    1720:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    1723:	68 1c 4b 00 00       	push   $0x4b1c
    1728:	6a 01                	push   $0x1
    172a:	e8 a4 2b 00 00       	call   42d3 <printf>

  unlink("lf1");
    172f:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    1736:	e8 8d 2a 00 00       	call   41c8 <unlink>
  unlink("lf2");
    173b:	c7 04 24 2a 4b 00 00 	movl   $0x4b2a,(%esp)
    1742:	e8 81 2a 00 00       	call   41c8 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1747:	83 c4 08             	add    $0x8,%esp
    174a:	68 02 02 00 00       	push   $0x202
    174f:	68 26 4b 00 00       	push   $0x4b26
    1754:	e8 5f 2a 00 00       	call   41b8 <open>
    1759:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    175b:	83 c4 10             	add    $0x10,%esp
    175e:	85 c0                	test   %eax,%eax
    1760:	0f 88 28 01 00 00    	js     188e <linktest+0x172>
    printf(1, "create lf1 failed\n");
    exit(0);
  }
  if(write(fd, "hello", 5) != 5){
    1766:	83 ec 04             	sub    $0x4,%esp
    1769:	6a 05                	push   $0x5
    176b:	68 8a 4a 00 00       	push   $0x4a8a
    1770:	53                   	push   %ebx
    1771:	e8 22 2a 00 00       	call   4198 <write>
    1776:	83 c4 10             	add    $0x10,%esp
    1779:	83 f8 05             	cmp    $0x5,%eax
    177c:	0f 85 2f 01 00 00    	jne    18b1 <linktest+0x195>
    printf(1, "write lf1 failed\n");
    exit(0);
  }
  close(fd);
    1782:	83 ec 0c             	sub    $0xc,%esp
    1785:	53                   	push   %ebx
    1786:	e8 15 2a 00 00       	call   41a0 <close>

  if(link("lf1", "lf2") < 0){
    178b:	83 c4 08             	add    $0x8,%esp
    178e:	68 2a 4b 00 00       	push   $0x4b2a
    1793:	68 26 4b 00 00       	push   $0x4b26
    1798:	e8 3b 2a 00 00       	call   41d8 <link>
    179d:	83 c4 10             	add    $0x10,%esp
    17a0:	85 c0                	test   %eax,%eax
    17a2:	0f 88 2c 01 00 00    	js     18d4 <linktest+0x1b8>
    printf(1, "link lf1 lf2 failed\n");
    exit(0);
  }
  unlink("lf1");
    17a8:	83 ec 0c             	sub    $0xc,%esp
    17ab:	68 26 4b 00 00       	push   $0x4b26
    17b0:	e8 13 2a 00 00       	call   41c8 <unlink>

  if(open("lf1", 0) >= 0){
    17b5:	83 c4 08             	add    $0x8,%esp
    17b8:	6a 00                	push   $0x0
    17ba:	68 26 4b 00 00       	push   $0x4b26
    17bf:	e8 f4 29 00 00       	call   41b8 <open>
    17c4:	83 c4 10             	add    $0x10,%esp
    17c7:	85 c0                	test   %eax,%eax
    17c9:	0f 89 28 01 00 00    	jns    18f7 <linktest+0x1db>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit(0);
  }

  fd = open("lf2", 0);
    17cf:	83 ec 08             	sub    $0x8,%esp
    17d2:	6a 00                	push   $0x0
    17d4:	68 2a 4b 00 00       	push   $0x4b2a
    17d9:	e8 da 29 00 00       	call   41b8 <open>
    17de:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    17e0:	83 c4 10             	add    $0x10,%esp
    17e3:	85 c0                	test   %eax,%eax
    17e5:	0f 88 2f 01 00 00    	js     191a <linktest+0x1fe>
    printf(1, "open lf2 failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    17eb:	83 ec 04             	sub    $0x4,%esp
    17ee:	68 00 20 00 00       	push   $0x2000
    17f3:	68 a0 8d 00 00       	push   $0x8da0
    17f8:	53                   	push   %ebx
    17f9:	e8 92 29 00 00       	call   4190 <read>
    17fe:	83 c4 10             	add    $0x10,%esp
    1801:	83 f8 05             	cmp    $0x5,%eax
    1804:	0f 85 33 01 00 00    	jne    193d <linktest+0x221>
    printf(1, "read lf2 failed\n");
    exit(0);
  }
  close(fd);
    180a:	83 ec 0c             	sub    $0xc,%esp
    180d:	53                   	push   %ebx
    180e:	e8 8d 29 00 00       	call   41a0 <close>

  if(link("lf2", "lf2") >= 0){
    1813:	83 c4 08             	add    $0x8,%esp
    1816:	68 2a 4b 00 00       	push   $0x4b2a
    181b:	68 2a 4b 00 00       	push   $0x4b2a
    1820:	e8 b3 29 00 00       	call   41d8 <link>
    1825:	83 c4 10             	add    $0x10,%esp
    1828:	85 c0                	test   %eax,%eax
    182a:	0f 89 30 01 00 00    	jns    1960 <linktest+0x244>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit(0);
  }

  unlink("lf2");
    1830:	83 ec 0c             	sub    $0xc,%esp
    1833:	68 2a 4b 00 00       	push   $0x4b2a
    1838:	e8 8b 29 00 00       	call   41c8 <unlink>
  if(link("lf2", "lf1") >= 0){
    183d:	83 c4 08             	add    $0x8,%esp
    1840:	68 26 4b 00 00       	push   $0x4b26
    1845:	68 2a 4b 00 00       	push   $0x4b2a
    184a:	e8 89 29 00 00       	call   41d8 <link>
    184f:	83 c4 10             	add    $0x10,%esp
    1852:	85 c0                	test   %eax,%eax
    1854:	0f 89 29 01 00 00    	jns    1983 <linktest+0x267>
    printf(1, "link non-existant succeeded! oops\n");
    exit(0);
  }

  if(link(".", "lf1") >= 0){
    185a:	83 ec 08             	sub    $0x8,%esp
    185d:	68 26 4b 00 00       	push   $0x4b26
    1862:	68 ee 4d 00 00       	push   $0x4dee
    1867:	e8 6c 29 00 00       	call   41d8 <link>
    186c:	83 c4 10             	add    $0x10,%esp
    186f:	85 c0                	test   %eax,%eax
    1871:	0f 89 2f 01 00 00    	jns    19a6 <linktest+0x28a>
    printf(1, "link . lf1 succeeded! oops\n");
    exit(0);
  }

  printf(1, "linktest ok\n");
    1877:	83 ec 08             	sub    $0x8,%esp
    187a:	68 c4 4b 00 00       	push   $0x4bc4
    187f:	6a 01                	push   $0x1
    1881:	e8 4d 2a 00 00       	call   42d3 <printf>
}
    1886:	83 c4 10             	add    $0x10,%esp
    1889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    188c:	c9                   	leave  
    188d:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    188e:	83 ec 08             	sub    $0x8,%esp
    1891:	68 2e 4b 00 00       	push   $0x4b2e
    1896:	6a 01                	push   $0x1
    1898:	e8 36 2a 00 00       	call   42d3 <printf>
    exit(0);
    189d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18a4:	e8 cf 28 00 00       	call   4178 <exit>
    18a9:	83 c4 10             	add    $0x10,%esp
    18ac:	e9 b5 fe ff ff       	jmp    1766 <linktest+0x4a>
    printf(1, "write lf1 failed\n");
    18b1:	83 ec 08             	sub    $0x8,%esp
    18b4:	68 41 4b 00 00       	push   $0x4b41
    18b9:	6a 01                	push   $0x1
    18bb:	e8 13 2a 00 00       	call   42d3 <printf>
    exit(0);
    18c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18c7:	e8 ac 28 00 00       	call   4178 <exit>
    18cc:	83 c4 10             	add    $0x10,%esp
    18cf:	e9 ae fe ff ff       	jmp    1782 <linktest+0x66>
    printf(1, "link lf1 lf2 failed\n");
    18d4:	83 ec 08             	sub    $0x8,%esp
    18d7:	68 53 4b 00 00       	push   $0x4b53
    18dc:	6a 01                	push   $0x1
    18de:	e8 f0 29 00 00       	call   42d3 <printf>
    exit(0);
    18e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18ea:	e8 89 28 00 00       	call   4178 <exit>
    18ef:	83 c4 10             	add    $0x10,%esp
    18f2:	e9 b1 fe ff ff       	jmp    17a8 <linktest+0x8c>
    printf(1, "unlinked lf1 but it is still there!\n");
    18f7:	83 ec 08             	sub    $0x8,%esp
    18fa:	68 34 57 00 00       	push   $0x5734
    18ff:	6a 01                	push   $0x1
    1901:	e8 cd 29 00 00       	call   42d3 <printf>
    exit(0);
    1906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    190d:	e8 66 28 00 00       	call   4178 <exit>
    1912:	83 c4 10             	add    $0x10,%esp
    1915:	e9 b5 fe ff ff       	jmp    17cf <linktest+0xb3>
    printf(1, "open lf2 failed\n");
    191a:	83 ec 08             	sub    $0x8,%esp
    191d:	68 68 4b 00 00       	push   $0x4b68
    1922:	6a 01                	push   $0x1
    1924:	e8 aa 29 00 00       	call   42d3 <printf>
    exit(0);
    1929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1930:	e8 43 28 00 00       	call   4178 <exit>
    1935:	83 c4 10             	add    $0x10,%esp
    1938:	e9 ae fe ff ff       	jmp    17eb <linktest+0xcf>
    printf(1, "read lf2 failed\n");
    193d:	83 ec 08             	sub    $0x8,%esp
    1940:	68 79 4b 00 00       	push   $0x4b79
    1945:	6a 01                	push   $0x1
    1947:	e8 87 29 00 00       	call   42d3 <printf>
    exit(0);
    194c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1953:	e8 20 28 00 00       	call   4178 <exit>
    1958:	83 c4 10             	add    $0x10,%esp
    195b:	e9 aa fe ff ff       	jmp    180a <linktest+0xee>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1960:	83 ec 08             	sub    $0x8,%esp
    1963:	68 8a 4b 00 00       	push   $0x4b8a
    1968:	6a 01                	push   $0x1
    196a:	e8 64 29 00 00       	call   42d3 <printf>
    exit(0);
    196f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1976:	e8 fd 27 00 00       	call   4178 <exit>
    197b:	83 c4 10             	add    $0x10,%esp
    197e:	e9 ad fe ff ff       	jmp    1830 <linktest+0x114>
    printf(1, "link non-existant succeeded! oops\n");
    1983:	83 ec 08             	sub    $0x8,%esp
    1986:	68 5c 57 00 00       	push   $0x575c
    198b:	6a 01                	push   $0x1
    198d:	e8 41 29 00 00       	call   42d3 <printf>
    exit(0);
    1992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1999:	e8 da 27 00 00       	call   4178 <exit>
    199e:	83 c4 10             	add    $0x10,%esp
    19a1:	e9 b4 fe ff ff       	jmp    185a <linktest+0x13e>
    printf(1, "link . lf1 succeeded! oops\n");
    19a6:	83 ec 08             	sub    $0x8,%esp
    19a9:	68 a8 4b 00 00       	push   $0x4ba8
    19ae:	6a 01                	push   $0x1
    19b0:	e8 1e 29 00 00       	call   42d3 <printf>
    exit(0);
    19b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19bc:	e8 b7 27 00 00       	call   4178 <exit>
    19c1:	83 c4 10             	add    $0x10,%esp
    19c4:	e9 ae fe ff ff       	jmp    1877 <linktest+0x15b>

000019c9 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    19c9:	55                   	push   %ebp
    19ca:	89 e5                	mov    %esp,%ebp
    19cc:	57                   	push   %edi
    19cd:	56                   	push   %esi
    19ce:	53                   	push   %ebx
    19cf:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    19d2:	68 d1 4b 00 00       	push   $0x4bd1
    19d7:	6a 01                	push   $0x1
    19d9:	e8 f5 28 00 00       	call   42d3 <printf>
  file[0] = 'C';
    19de:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    19e2:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    19e6:	83 c4 10             	add    $0x10,%esp
    19e9:	bb 00 00 00 00       	mov    $0x0,%ebx
    19ee:	eb 57                	jmp    1a47 <concreate+0x7e>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    19f0:	85 f6                	test   %esi,%esi
    19f2:	75 13                	jne    1a07 <concreate+0x3e>
    19f4:	b9 05 00 00 00       	mov    $0x5,%ecx
    19f9:	89 d8                	mov    %ebx,%eax
    19fb:	99                   	cltd   
    19fc:	f7 f9                	idiv   %ecx
    19fe:	83 fa 01             	cmp    $0x1,%edx
    1a01:	0f 84 92 00 00 00    	je     1a99 <concreate+0xd0>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1a07:	83 ec 08             	sub    $0x8,%esp
    1a0a:	68 02 02 00 00       	push   $0x202
    1a0f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a12:	50                   	push   %eax
    1a13:	e8 a0 27 00 00       	call   41b8 <open>
    1a18:	89 c7                	mov    %eax,%edi
      if(fd < 0){
    1a1a:	83 c4 10             	add    $0x10,%esp
    1a1d:	85 c0                	test   %eax,%eax
    1a1f:	0f 88 8a 00 00 00    	js     1aaf <concreate+0xe6>
        printf(1, "concreate create %s failed\n", file);
        exit(0);
      }
      close(fd);
    1a25:	83 ec 0c             	sub    $0xc,%esp
    1a28:	57                   	push   %edi
    1a29:	e8 72 27 00 00       	call   41a0 <close>
    1a2e:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a31:	85 f6                	test   %esi,%esi
    1a33:	0f 85 9d 00 00 00    	jne    1ad6 <concreate+0x10d>
      exit(0);
    1a39:	83 ec 0c             	sub    $0xc,%esp
    1a3c:	6a 00                	push   $0x0
    1a3e:	e8 35 27 00 00       	call   4178 <exit>
    1a43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    1a46:	43                   	inc    %ebx
    1a47:	83 fb 27             	cmp    $0x27,%ebx
    1a4a:	0f 8f 98 00 00 00    	jg     1ae8 <concreate+0x11f>
    file[1] = '0' + i;
    1a50:	8d 43 30             	lea    0x30(%ebx),%eax
    1a53:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1a56:	83 ec 0c             	sub    $0xc,%esp
    1a59:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a5c:	50                   	push   %eax
    1a5d:	e8 66 27 00 00       	call   41c8 <unlink>
    pid = fork();
    1a62:	e8 09 27 00 00       	call   4170 <fork>
    1a67:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    1a69:	83 c4 10             	add    $0x10,%esp
    1a6c:	85 c0                	test   %eax,%eax
    1a6e:	74 80                	je     19f0 <concreate+0x27>
    1a70:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a75:	89 d8                	mov    %ebx,%eax
    1a77:	99                   	cltd   
    1a78:	f7 f9                	idiv   %ecx
    1a7a:	83 fa 01             	cmp    $0x1,%edx
    1a7d:	0f 85 6d ff ff ff    	jne    19f0 <concreate+0x27>
      link("C0", file);
    1a83:	83 ec 08             	sub    $0x8,%esp
    1a86:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a89:	50                   	push   %eax
    1a8a:	68 e1 4b 00 00       	push   $0x4be1
    1a8f:	e8 44 27 00 00       	call   41d8 <link>
    1a94:	83 c4 10             	add    $0x10,%esp
    1a97:	eb 98                	jmp    1a31 <concreate+0x68>
      link("C0", file);
    1a99:	83 ec 08             	sub    $0x8,%esp
    1a9c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a9f:	50                   	push   %eax
    1aa0:	68 e1 4b 00 00       	push   $0x4be1
    1aa5:	e8 2e 27 00 00       	call   41d8 <link>
    1aaa:	83 c4 10             	add    $0x10,%esp
    1aad:	eb 82                	jmp    1a31 <concreate+0x68>
        printf(1, "concreate create %s failed\n", file);
    1aaf:	83 ec 04             	sub    $0x4,%esp
    1ab2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1ab5:	50                   	push   %eax
    1ab6:	68 e4 4b 00 00       	push   $0x4be4
    1abb:	6a 01                	push   $0x1
    1abd:	e8 11 28 00 00       	call   42d3 <printf>
        exit(0);
    1ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1ac9:	e8 aa 26 00 00       	call   4178 <exit>
    1ace:	83 c4 10             	add    $0x10,%esp
    1ad1:	e9 4f ff ff ff       	jmp    1a25 <concreate+0x5c>
    else
      wait(NULL);
    1ad6:	83 ec 0c             	sub    $0xc,%esp
    1ad9:	6a 00                	push   $0x0
    1adb:	e8 a0 26 00 00       	call   4180 <wait>
    1ae0:	83 c4 10             	add    $0x10,%esp
    1ae3:	e9 5e ff ff ff       	jmp    1a46 <concreate+0x7d>
  }

  memset(fa, 0, sizeof(fa));
    1ae8:	83 ec 04             	sub    $0x4,%esp
    1aeb:	6a 28                	push   $0x28
    1aed:	6a 00                	push   $0x0
    1aef:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1af2:	50                   	push   %eax
    1af3:	e8 55 25 00 00       	call   404d <memset>
  fd = open(".", 0);
    1af8:	83 c4 08             	add    $0x8,%esp
    1afb:	6a 00                	push   $0x0
    1afd:	68 ee 4d 00 00       	push   $0x4dee
    1b02:	e8 b1 26 00 00       	call   41b8 <open>
    1b07:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b09:	83 c4 10             	add    $0x10,%esp
  n = 0;
    1b0c:	be 00 00 00 00       	mov    $0x0,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    1b11:	83 ec 04             	sub    $0x4,%esp
    1b14:	6a 10                	push   $0x10
    1b16:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b19:	50                   	push   %eax
    1b1a:	53                   	push   %ebx
    1b1b:	e8 70 26 00 00       	call   4190 <read>
    1b20:	83 c4 10             	add    $0x10,%esp
    1b23:	85 c0                	test   %eax,%eax
    1b25:	7e 76                	jle    1b9d <concreate+0x1d4>
    if(de.inum == 0)
    1b27:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    1b2c:	74 e3                	je     1b11 <concreate+0x148>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1b2e:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    1b32:	75 dd                	jne    1b11 <concreate+0x148>
    1b34:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    1b38:	75 d7                	jne    1b11 <concreate+0x148>
      i = de.name[1] - '0';
    1b3a:	0f be 7d af          	movsbl -0x51(%ebp),%edi
    1b3e:	83 ef 30             	sub    $0x30,%edi
      if(i < 0 || i >= sizeof(fa)){
    1b41:	83 ff 27             	cmp    $0x27,%edi
    1b44:	77 0f                	ja     1b55 <concreate+0x18c>
        printf(1, "concreate weird file %s\n", de.name);
        exit(0);
      }
      if(fa[i]){
    1b46:	80 7c 3d bd 00       	cmpb   $0x0,-0x43(%ebp,%edi,1)
    1b4b:	75 2c                	jne    1b79 <concreate+0x1b0>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit(0);
      }
      fa[i] = 1;
    1b4d:	c6 44 3d bd 01       	movb   $0x1,-0x43(%ebp,%edi,1)
      n++;
    1b52:	46                   	inc    %esi
    1b53:	eb bc                	jmp    1b11 <concreate+0x148>
        printf(1, "concreate weird file %s\n", de.name);
    1b55:	83 ec 04             	sub    $0x4,%esp
    1b58:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1b5b:	50                   	push   %eax
    1b5c:	68 00 4c 00 00       	push   $0x4c00
    1b61:	6a 01                	push   $0x1
    1b63:	e8 6b 27 00 00       	call   42d3 <printf>
        exit(0);
    1b68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1b6f:	e8 04 26 00 00       	call   4178 <exit>
    1b74:	83 c4 10             	add    $0x10,%esp
    1b77:	eb cd                	jmp    1b46 <concreate+0x17d>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b79:	83 ec 04             	sub    $0x4,%esp
    1b7c:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1b7f:	50                   	push   %eax
    1b80:	68 19 4c 00 00       	push   $0x4c19
    1b85:	6a 01                	push   $0x1
    1b87:	e8 47 27 00 00       	call   42d3 <printf>
        exit(0);
    1b8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1b93:	e8 e0 25 00 00       	call   4178 <exit>
    1b98:	83 c4 10             	add    $0x10,%esp
    1b9b:	eb b0                	jmp    1b4d <concreate+0x184>
    }
  }
  close(fd);
    1b9d:	83 ec 0c             	sub    $0xc,%esp
    1ba0:	53                   	push   %ebx
    1ba1:	e8 fa 25 00 00       	call   41a0 <close>

  if(n != 40){
    1ba6:	83 c4 10             	add    $0x10,%esp
    1ba9:	83 fe 28             	cmp    $0x28,%esi
    1bac:	75 07                	jne    1bb5 <concreate+0x1ec>
  n = 0;
    1bae:	bb 00 00 00 00       	mov    $0x0,%ebx
    1bb3:	eb 7d                	jmp    1c32 <concreate+0x269>
    printf(1, "concreate not enough files in directory listing\n");
    1bb5:	83 ec 08             	sub    $0x8,%esp
    1bb8:	68 80 57 00 00       	push   $0x5780
    1bbd:	6a 01                	push   $0x1
    1bbf:	e8 0f 27 00 00       	call   42d3 <printf>
    exit(0);
    1bc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1bcb:	e8 a8 25 00 00       	call   4178 <exit>
    1bd0:	83 c4 10             	add    $0x10,%esp
    1bd3:	eb d9                	jmp    1bae <concreate+0x1e5>

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    1bd5:	83 ec 08             	sub    $0x8,%esp
    1bd8:	68 b9 54 00 00       	push   $0x54b9
    1bdd:	6a 01                	push   $0x1
    1bdf:	e8 ef 26 00 00       	call   42d3 <printf>
      exit(0);
    1be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1beb:	e8 88 25 00 00       	call   4178 <exit>
    1bf0:	83 c4 10             	add    $0x10,%esp
    1bf3:	eb 57                	jmp    1c4c <concreate+0x283>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    1bf5:	83 ec 0c             	sub    $0xc,%esp
    1bf8:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1bfb:	57                   	push   %edi
    1bfc:	e8 c7 25 00 00       	call   41c8 <unlink>
      unlink(file);
    1c01:	89 3c 24             	mov    %edi,(%esp)
    1c04:	e8 bf 25 00 00       	call   41c8 <unlink>
      unlink(file);
    1c09:	89 3c 24             	mov    %edi,(%esp)
    1c0c:	e8 b7 25 00 00       	call   41c8 <unlink>
      unlink(file);
    1c11:	89 3c 24             	mov    %edi,(%esp)
    1c14:	e8 af 25 00 00       	call   41c8 <unlink>
    1c19:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c1c:	85 f6                	test   %esi,%esi
    1c1e:	0f 85 9a 00 00 00    	jne    1cbe <concreate+0x2f5>
      exit(0);
    1c24:	83 ec 0c             	sub    $0xc,%esp
    1c27:	6a 00                	push   $0x0
    1c29:	e8 4a 25 00 00       	call   4178 <exit>
    1c2e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    1c31:	43                   	inc    %ebx
    1c32:	83 fb 27             	cmp    $0x27,%ebx
    1c35:	0f 8f 95 00 00 00    	jg     1cd0 <concreate+0x307>
    file[1] = '0' + i;
    1c3b:	8d 43 30             	lea    0x30(%ebx),%eax
    1c3e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1c41:	e8 2a 25 00 00       	call   4170 <fork>
    1c46:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1c48:	85 c0                	test   %eax,%eax
    1c4a:	78 89                	js     1bd5 <concreate+0x20c>
    if(((i % 3) == 0 && pid == 0) ||
    1c4c:	b9 03 00 00 00       	mov    $0x3,%ecx
    1c51:	89 d8                	mov    %ebx,%eax
    1c53:	99                   	cltd   
    1c54:	f7 f9                	idiv   %ecx
    1c56:	85 d2                	test   %edx,%edx
    1c58:	75 04                	jne    1c5e <concreate+0x295>
    1c5a:	85 f6                	test   %esi,%esi
    1c5c:	74 09                	je     1c67 <concreate+0x29e>
    1c5e:	83 fa 01             	cmp    $0x1,%edx
    1c61:	75 92                	jne    1bf5 <concreate+0x22c>
       ((i % 3) == 1 && pid != 0)){
    1c63:	85 f6                	test   %esi,%esi
    1c65:	74 8e                	je     1bf5 <concreate+0x22c>
      close(open(file, 0));
    1c67:	83 ec 08             	sub    $0x8,%esp
    1c6a:	6a 00                	push   $0x0
    1c6c:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1c6f:	57                   	push   %edi
    1c70:	e8 43 25 00 00       	call   41b8 <open>
    1c75:	89 04 24             	mov    %eax,(%esp)
    1c78:	e8 23 25 00 00       	call   41a0 <close>
      close(open(file, 0));
    1c7d:	83 c4 08             	add    $0x8,%esp
    1c80:	6a 00                	push   $0x0
    1c82:	57                   	push   %edi
    1c83:	e8 30 25 00 00       	call   41b8 <open>
    1c88:	89 04 24             	mov    %eax,(%esp)
    1c8b:	e8 10 25 00 00       	call   41a0 <close>
      close(open(file, 0));
    1c90:	83 c4 08             	add    $0x8,%esp
    1c93:	6a 00                	push   $0x0
    1c95:	57                   	push   %edi
    1c96:	e8 1d 25 00 00       	call   41b8 <open>
    1c9b:	89 04 24             	mov    %eax,(%esp)
    1c9e:	e8 fd 24 00 00       	call   41a0 <close>
      close(open(file, 0));
    1ca3:	83 c4 08             	add    $0x8,%esp
    1ca6:	6a 00                	push   $0x0
    1ca8:	57                   	push   %edi
    1ca9:	e8 0a 25 00 00       	call   41b8 <open>
    1cae:	89 04 24             	mov    %eax,(%esp)
    1cb1:	e8 ea 24 00 00       	call   41a0 <close>
    1cb6:	83 c4 10             	add    $0x10,%esp
    1cb9:	e9 5e ff ff ff       	jmp    1c1c <concreate+0x253>
    else
      wait(NULL);
    1cbe:	83 ec 0c             	sub    $0xc,%esp
    1cc1:	6a 00                	push   $0x0
    1cc3:	e8 b8 24 00 00       	call   4180 <wait>
    1cc8:	83 c4 10             	add    $0x10,%esp
    1ccb:	e9 61 ff ff ff       	jmp    1c31 <concreate+0x268>
  }

  printf(1, "concreate ok\n");
    1cd0:	83 ec 08             	sub    $0x8,%esp
    1cd3:	68 36 4c 00 00       	push   $0x4c36
    1cd8:	6a 01                	push   $0x1
    1cda:	e8 f4 25 00 00       	call   42d3 <printf>
}
    1cdf:	83 c4 10             	add    $0x10,%esp
    1ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ce5:	5b                   	pop    %ebx
    1ce6:	5e                   	pop    %esi
    1ce7:	5f                   	pop    %edi
    1ce8:	5d                   	pop    %ebp
    1ce9:	c3                   	ret    

00001cea <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cea:	55                   	push   %ebp
    1ceb:	89 e5                	mov    %esp,%ebp
    1ced:	57                   	push   %edi
    1cee:	56                   	push   %esi
    1cef:	53                   	push   %ebx
    1cf0:	83 ec 14             	sub    $0x14,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cf3:	68 44 4c 00 00       	push   $0x4c44
    1cf8:	6a 01                	push   $0x1
    1cfa:	e8 d4 25 00 00       	call   42d3 <printf>

  unlink("x");
    1cff:	c7 04 24 d1 4e 00 00 	movl   $0x4ed1,(%esp)
    1d06:	e8 bd 24 00 00       	call   41c8 <unlink>
  pid = fork();
    1d0b:	e8 60 24 00 00       	call   4170 <fork>
    1d10:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    1d12:	83 c4 10             	add    $0x10,%esp
    1d15:	85 c0                	test   %eax,%eax
    1d17:	78 10                	js     1d29 <linkunlink+0x3f>
    printf(1, "fork failed\n");
    exit(0);
  }

  unsigned int x = (pid ? 1 : 97);
    1d19:	85 ff                	test   %edi,%edi
    1d1b:	74 2c                	je     1d49 <linkunlink+0x5f>
    1d1d:	bb 01 00 00 00       	mov    $0x1,%ebx
    1d22:	be 00 00 00 00       	mov    $0x0,%esi
    1d27:	eb 45                	jmp    1d6e <linkunlink+0x84>
    printf(1, "fork failed\n");
    1d29:	83 ec 08             	sub    $0x8,%esp
    1d2c:	68 b9 54 00 00       	push   $0x54b9
    1d31:	6a 01                	push   $0x1
    1d33:	e8 9b 25 00 00       	call   42d3 <printf>
    exit(0);
    1d38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1d3f:	e8 34 24 00 00       	call   4178 <exit>
    1d44:	83 c4 10             	add    $0x10,%esp
    1d47:	eb d0                	jmp    1d19 <linkunlink+0x2f>
  unsigned int x = (pid ? 1 : 97);
    1d49:	bb 61 00 00 00       	mov    $0x61,%ebx
    1d4e:	eb d2                	jmp    1d22 <linkunlink+0x38>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    1d50:	83 ec 08             	sub    $0x8,%esp
    1d53:	68 02 02 00 00       	push   $0x202
    1d58:	68 d1 4e 00 00       	push   $0x4ed1
    1d5d:	e8 56 24 00 00       	call   41b8 <open>
    1d62:	89 04 24             	mov    %eax,(%esp)
    1d65:	e8 36 24 00 00       	call   41a0 <close>
    1d6a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1d6d:	46                   	inc    %esi
    1d6e:	83 fe 63             	cmp    $0x63,%esi
    1d71:	7f 68                	jg     1ddb <linkunlink+0xf1>
    x = x * 1103515245 + 12345;
    1d73:	89 d8                	mov    %ebx,%eax
    1d75:	c1 e0 09             	shl    $0x9,%eax
    1d78:	29 d8                	sub    %ebx,%eax
    1d7a:	8d 14 83             	lea    (%ebx,%eax,4),%edx
    1d7d:	89 d0                	mov    %edx,%eax
    1d7f:	c1 e0 09             	shl    $0x9,%eax
    1d82:	29 d0                	sub    %edx,%eax
    1d84:	01 c0                	add    %eax,%eax
    1d86:	01 d8                	add    %ebx,%eax
    1d88:	89 c2                	mov    %eax,%edx
    1d8a:	c1 e2 05             	shl    $0x5,%edx
    1d8d:	01 d0                	add    %edx,%eax
    1d8f:	c1 e0 02             	shl    $0x2,%eax
    1d92:	29 d8                	sub    %ebx,%eax
    1d94:	8d 9c 83 39 30 00 00 	lea    0x3039(%ebx,%eax,4),%ebx
    if((x % 3) == 0){
    1d9b:	b9 03 00 00 00       	mov    $0x3,%ecx
    1da0:	89 d8                	mov    %ebx,%eax
    1da2:	ba 00 00 00 00       	mov    $0x0,%edx
    1da7:	f7 f1                	div    %ecx
    1da9:	85 d2                	test   %edx,%edx
    1dab:	74 a3                	je     1d50 <linkunlink+0x66>
    } else if((x % 3) == 1){
    1dad:	83 fa 01             	cmp    $0x1,%edx
    1db0:	74 12                	je     1dc4 <linkunlink+0xda>
      link("cat", "x");
    } else {
      unlink("x");
    1db2:	83 ec 0c             	sub    $0xc,%esp
    1db5:	68 d1 4e 00 00       	push   $0x4ed1
    1dba:	e8 09 24 00 00       	call   41c8 <unlink>
    1dbf:	83 c4 10             	add    $0x10,%esp
    1dc2:	eb a9                	jmp    1d6d <linkunlink+0x83>
      link("cat", "x");
    1dc4:	83 ec 08             	sub    $0x8,%esp
    1dc7:	68 d1 4e 00 00       	push   $0x4ed1
    1dcc:	68 55 4c 00 00       	push   $0x4c55
    1dd1:	e8 02 24 00 00       	call   41d8 <link>
    1dd6:	83 c4 10             	add    $0x10,%esp
    1dd9:	eb 92                	jmp    1d6d <linkunlink+0x83>
    }
  }

  if(pid)
    1ddb:	85 ff                	test   %edi,%edi
    1ddd:	74 27                	je     1e06 <linkunlink+0x11c>
    wait(NULL);
    1ddf:	83 ec 0c             	sub    $0xc,%esp
    1de2:	6a 00                	push   $0x0
    1de4:	e8 97 23 00 00       	call   4180 <wait>
    1de9:	83 c4 10             	add    $0x10,%esp
  else
    exit(0);

  printf(1, "linkunlink ok\n");
    1dec:	83 ec 08             	sub    $0x8,%esp
    1def:	68 59 4c 00 00       	push   $0x4c59
    1df4:	6a 01                	push   $0x1
    1df6:	e8 d8 24 00 00       	call   42d3 <printf>
}
    1dfb:	83 c4 10             	add    $0x10,%esp
    1dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1e01:	5b                   	pop    %ebx
    1e02:	5e                   	pop    %esi
    1e03:	5f                   	pop    %edi
    1e04:	5d                   	pop    %ebp
    1e05:	c3                   	ret    
    exit(0);
    1e06:	83 ec 0c             	sub    $0xc,%esp
    1e09:	6a 00                	push   $0x0
    1e0b:	e8 68 23 00 00       	call   4178 <exit>
    1e10:	83 c4 10             	add    $0x10,%esp
    1e13:	eb d7                	jmp    1dec <linkunlink+0x102>

00001e15 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e15:	55                   	push   %ebp
    1e16:	89 e5                	mov    %esp,%ebp
    1e18:	53                   	push   %ebx
    1e19:	83 ec 1c             	sub    $0x1c,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e1c:	68 68 4c 00 00       	push   $0x4c68
    1e21:	6a 01                	push   $0x1
    1e23:	e8 ab 24 00 00       	call   42d3 <printf>
  unlink("bd");
    1e28:	c7 04 24 75 4c 00 00 	movl   $0x4c75,(%esp)
    1e2f:	e8 94 23 00 00       	call   41c8 <unlink>

  fd = open("bd", O_CREATE);
    1e34:	83 c4 08             	add    $0x8,%esp
    1e37:	68 00 02 00 00       	push   $0x200
    1e3c:	68 75 4c 00 00       	push   $0x4c75
    1e41:	e8 72 23 00 00       	call   41b8 <open>
    1e46:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e48:	83 c4 10             	add    $0x10,%esp
    1e4b:	85 c0                	test   %eax,%eax
    1e4d:	78 13                	js     1e62 <bigdir+0x4d>
    printf(1, "bigdir create failed\n");
    exit(0);
  }
  close(fd);
    1e4f:	83 ec 0c             	sub    $0xc,%esp
    1e52:	53                   	push   %ebx
    1e53:	e8 48 23 00 00       	call   41a0 <close>

  for(i = 0; i < 500; i++){
    1e58:	83 c4 10             	add    $0x10,%esp
    1e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
    1e60:	eb 48                	jmp    1eaa <bigdir+0x95>
    printf(1, "bigdir create failed\n");
    1e62:	83 ec 08             	sub    $0x8,%esp
    1e65:	68 78 4c 00 00       	push   $0x4c78
    1e6a:	6a 01                	push   $0x1
    1e6c:	e8 62 24 00 00       	call   42d3 <printf>
    exit(0);
    1e71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1e78:	e8 fb 22 00 00       	call   4178 <exit>
    1e7d:	83 c4 10             	add    $0x10,%esp
    1e80:	eb cd                	jmp    1e4f <bigdir+0x3a>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1e82:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1e85:	eb 35                	jmp    1ebc <bigdir+0xa7>
    name[2] = '0' + (i % 64);
    1e87:	83 c0 30             	add    $0x30,%eax
    1e8a:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1e8d:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1e91:	83 ec 08             	sub    $0x8,%esp
    1e94:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1e97:	50                   	push   %eax
    1e98:	68 75 4c 00 00       	push   $0x4c75
    1e9d:	e8 36 23 00 00       	call   41d8 <link>
    1ea2:	83 c4 10             	add    $0x10,%esp
    1ea5:	85 c0                	test   %eax,%eax
    1ea7:	75 2c                	jne    1ed5 <bigdir+0xc0>
  for(i = 0; i < 500; i++){
    1ea9:	43                   	inc    %ebx
    1eaa:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1eb0:	7f 43                	jg     1ef5 <bigdir+0xe0>
    name[0] = 'x';
    1eb2:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1eb6:	89 d8                	mov    %ebx,%eax
    1eb8:	85 db                	test   %ebx,%ebx
    1eba:	78 c6                	js     1e82 <bigdir+0x6d>
    1ebc:	c1 f8 06             	sar    $0x6,%eax
    1ebf:	83 c0 30             	add    $0x30,%eax
    1ec2:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1ec5:	89 d8                	mov    %ebx,%eax
    1ec7:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1ecc:	79 b9                	jns    1e87 <bigdir+0x72>
    1ece:	48                   	dec    %eax
    1ecf:	83 c8 c0             	or     $0xffffffc0,%eax
    1ed2:	40                   	inc    %eax
    1ed3:	eb b2                	jmp    1e87 <bigdir+0x72>
      printf(1, "bigdir link failed\n");
    1ed5:	83 ec 08             	sub    $0x8,%esp
    1ed8:	68 8e 4c 00 00       	push   $0x4c8e
    1edd:	6a 01                	push   $0x1
    1edf:	e8 ef 23 00 00       	call   42d3 <printf>
      exit(0);
    1ee4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1eeb:	e8 88 22 00 00       	call   4178 <exit>
    1ef0:	83 c4 10             	add    $0x10,%esp
    1ef3:	eb b4                	jmp    1ea9 <bigdir+0x94>
    }
  }

  unlink("bd");
    1ef5:	83 ec 0c             	sub    $0xc,%esp
    1ef8:	68 75 4c 00 00       	push   $0x4c75
    1efd:	e8 c6 22 00 00       	call   41c8 <unlink>
  for(i = 0; i < 500; i++){
    1f02:	83 c4 10             	add    $0x10,%esp
    1f05:	bb 00 00 00 00       	mov    $0x0,%ebx
    1f0a:	eb 23                	jmp    1f2f <bigdir+0x11a>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1f0c:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1f0f:	eb 30                	jmp    1f41 <bigdir+0x12c>
    name[2] = '0' + (i % 64);
    1f11:	83 c0 30             	add    $0x30,%eax
    1f14:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1f17:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1f1b:	83 ec 0c             	sub    $0xc,%esp
    1f1e:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1f21:	50                   	push   %eax
    1f22:	e8 a1 22 00 00       	call   41c8 <unlink>
    1f27:	83 c4 10             	add    $0x10,%esp
    1f2a:	85 c0                	test   %eax,%eax
    1f2c:	75 2c                	jne    1f5a <bigdir+0x145>
  for(i = 0; i < 500; i++){
    1f2e:	43                   	inc    %ebx
    1f2f:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1f35:	7f 43                	jg     1f7a <bigdir+0x165>
    name[0] = 'x';
    1f37:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1f3b:	89 d8                	mov    %ebx,%eax
    1f3d:	85 db                	test   %ebx,%ebx
    1f3f:	78 cb                	js     1f0c <bigdir+0xf7>
    1f41:	c1 f8 06             	sar    $0x6,%eax
    1f44:	83 c0 30             	add    $0x30,%eax
    1f47:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1f4a:	89 d8                	mov    %ebx,%eax
    1f4c:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1f51:	79 be                	jns    1f11 <bigdir+0xfc>
    1f53:	48                   	dec    %eax
    1f54:	83 c8 c0             	or     $0xffffffc0,%eax
    1f57:	40                   	inc    %eax
    1f58:	eb b7                	jmp    1f11 <bigdir+0xfc>
      printf(1, "bigdir unlink failed");
    1f5a:	83 ec 08             	sub    $0x8,%esp
    1f5d:	68 a2 4c 00 00       	push   $0x4ca2
    1f62:	6a 01                	push   $0x1
    1f64:	e8 6a 23 00 00       	call   42d3 <printf>
      exit(0);
    1f69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1f70:	e8 03 22 00 00       	call   4178 <exit>
    1f75:	83 c4 10             	add    $0x10,%esp
    1f78:	eb b4                	jmp    1f2e <bigdir+0x119>
    }
  }

  printf(1, "bigdir ok\n");
    1f7a:	83 ec 08             	sub    $0x8,%esp
    1f7d:	68 b7 4c 00 00       	push   $0x4cb7
    1f82:	6a 01                	push   $0x1
    1f84:	e8 4a 23 00 00       	call   42d3 <printf>
}
    1f89:	83 c4 10             	add    $0x10,%esp
    1f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f8f:	c9                   	leave  
    1f90:	c3                   	ret    

00001f91 <subdir>:

void
subdir(void)
{
    1f91:	55                   	push   %ebp
    1f92:	89 e5                	mov    %esp,%ebp
    1f94:	53                   	push   %ebx
    1f95:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f98:	68 c2 4c 00 00       	push   $0x4cc2
    1f9d:	6a 01                	push   $0x1
    1f9f:	e8 2f 23 00 00       	call   42d3 <printf>

  unlink("ff");
    1fa4:	c7 04 24 4b 4d 00 00 	movl   $0x4d4b,(%esp)
    1fab:	e8 18 22 00 00       	call   41c8 <unlink>
  if(mkdir("dd") != 0){
    1fb0:	c7 04 24 e8 4d 00 00 	movl   $0x4de8,(%esp)
    1fb7:	e8 24 22 00 00       	call   41e0 <mkdir>
    1fbc:	83 c4 10             	add    $0x10,%esp
    1fbf:	85 c0                	test   %eax,%eax
    1fc1:	0f 85 2a 04 00 00    	jne    23f1 <subdir+0x460>
    printf(1, "subdir mkdir dd failed\n");
    exit(0);
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fc7:	83 ec 08             	sub    $0x8,%esp
    1fca:	68 02 02 00 00       	push   $0x202
    1fcf:	68 21 4d 00 00       	push   $0x4d21
    1fd4:	e8 df 21 00 00       	call   41b8 <open>
    1fd9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1fdb:	83 c4 10             	add    $0x10,%esp
    1fde:	85 c0                	test   %eax,%eax
    1fe0:	0f 88 2e 04 00 00    	js     2414 <subdir+0x483>
    printf(1, "create dd/ff failed\n");
    exit(0);
  }
  write(fd, "ff", 2);
    1fe6:	83 ec 04             	sub    $0x4,%esp
    1fe9:	6a 02                	push   $0x2
    1feb:	68 4b 4d 00 00       	push   $0x4d4b
    1ff0:	53                   	push   %ebx
    1ff1:	e8 a2 21 00 00       	call   4198 <write>
  close(fd);
    1ff6:	89 1c 24             	mov    %ebx,(%esp)
    1ff9:	e8 a2 21 00 00       	call   41a0 <close>

  if(unlink("dd") >= 0){
    1ffe:	c7 04 24 e8 4d 00 00 	movl   $0x4de8,(%esp)
    2005:	e8 be 21 00 00       	call   41c8 <unlink>
    200a:	83 c4 10             	add    $0x10,%esp
    200d:	85 c0                	test   %eax,%eax
    200f:	0f 89 22 04 00 00    	jns    2437 <subdir+0x4a6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit(0);
  }

  if(mkdir("/dd/dd") != 0){
    2015:	83 ec 0c             	sub    $0xc,%esp
    2018:	68 fc 4c 00 00       	push   $0x4cfc
    201d:	e8 be 21 00 00       	call   41e0 <mkdir>
    2022:	83 c4 10             	add    $0x10,%esp
    2025:	85 c0                	test   %eax,%eax
    2027:	0f 85 2d 04 00 00    	jne    245a <subdir+0x4c9>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit(0);
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    202d:	83 ec 08             	sub    $0x8,%esp
    2030:	68 02 02 00 00       	push   $0x202
    2035:	68 1e 4d 00 00       	push   $0x4d1e
    203a:	e8 79 21 00 00       	call   41b8 <open>
    203f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2041:	83 c4 10             	add    $0x10,%esp
    2044:	85 c0                	test   %eax,%eax
    2046:	0f 88 31 04 00 00    	js     247d <subdir+0x4ec>
    printf(1, "create dd/dd/ff failed\n");
    exit(0);
  }
  write(fd, "FF", 2);
    204c:	83 ec 04             	sub    $0x4,%esp
    204f:	6a 02                	push   $0x2
    2051:	68 3f 4d 00 00       	push   $0x4d3f
    2056:	53                   	push   %ebx
    2057:	e8 3c 21 00 00       	call   4198 <write>
  close(fd);
    205c:	89 1c 24             	mov    %ebx,(%esp)
    205f:	e8 3c 21 00 00       	call   41a0 <close>

  fd = open("dd/dd/../ff", 0);
    2064:	83 c4 08             	add    $0x8,%esp
    2067:	6a 00                	push   $0x0
    2069:	68 42 4d 00 00       	push   $0x4d42
    206e:	e8 45 21 00 00       	call   41b8 <open>
    2073:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2075:	83 c4 10             	add    $0x10,%esp
    2078:	85 c0                	test   %eax,%eax
    207a:	0f 88 20 04 00 00    	js     24a0 <subdir+0x50f>
    printf(1, "open dd/dd/../ff failed\n");
    exit(0);
  }
  cc = read(fd, buf, sizeof(buf));
    2080:	83 ec 04             	sub    $0x4,%esp
    2083:	68 00 20 00 00       	push   $0x2000
    2088:	68 a0 8d 00 00       	push   $0x8da0
    208d:	53                   	push   %ebx
    208e:	e8 fd 20 00 00       	call   4190 <read>
  if(cc != 2 || buf[0] != 'f'){
    2093:	83 c4 10             	add    $0x10,%esp
    2096:	83 f8 02             	cmp    $0x2,%eax
    2099:	75 09                	jne    20a4 <subdir+0x113>
    209b:	80 3d a0 8d 00 00 66 	cmpb   $0x66,0x8da0
    20a2:	74 1e                	je     20c2 <subdir+0x131>
    printf(1, "dd/dd/../ff wrong content\n");
    20a4:	83 ec 08             	sub    $0x8,%esp
    20a7:	68 67 4d 00 00       	push   $0x4d67
    20ac:	6a 01                	push   $0x1
    20ae:	e8 20 22 00 00       	call   42d3 <printf>
    exit(0);
    20b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    20ba:	e8 b9 20 00 00       	call   4178 <exit>
    20bf:	83 c4 10             	add    $0x10,%esp
  }
  close(fd);
    20c2:	83 ec 0c             	sub    $0xc,%esp
    20c5:	53                   	push   %ebx
    20c6:	e8 d5 20 00 00       	call   41a0 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    20cb:	83 c4 08             	add    $0x8,%esp
    20ce:	68 82 4d 00 00       	push   $0x4d82
    20d3:	68 1e 4d 00 00       	push   $0x4d1e
    20d8:	e8 fb 20 00 00       	call   41d8 <link>
    20dd:	83 c4 10             	add    $0x10,%esp
    20e0:	85 c0                	test   %eax,%eax
    20e2:	0f 85 db 03 00 00    	jne    24c3 <subdir+0x532>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit(0);
  }

  if(unlink("dd/dd/ff") != 0){
    20e8:	83 ec 0c             	sub    $0xc,%esp
    20eb:	68 1e 4d 00 00       	push   $0x4d1e
    20f0:	e8 d3 20 00 00       	call   41c8 <unlink>
    20f5:	83 c4 10             	add    $0x10,%esp
    20f8:	85 c0                	test   %eax,%eax
    20fa:	0f 85 e6 03 00 00    	jne    24e6 <subdir+0x555>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2100:	83 ec 08             	sub    $0x8,%esp
    2103:	6a 00                	push   $0x0
    2105:	68 1e 4d 00 00       	push   $0x4d1e
    210a:	e8 a9 20 00 00       	call   41b8 <open>
    210f:	83 c4 10             	add    $0x10,%esp
    2112:	85 c0                	test   %eax,%eax
    2114:	0f 89 ef 03 00 00    	jns    2509 <subdir+0x578>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit(0);
  }

  if(chdir("dd") != 0){
    211a:	83 ec 0c             	sub    $0xc,%esp
    211d:	68 e8 4d 00 00       	push   $0x4de8
    2122:	e8 c1 20 00 00       	call   41e8 <chdir>
    2127:	83 c4 10             	add    $0x10,%esp
    212a:	85 c0                	test   %eax,%eax
    212c:	0f 85 fa 03 00 00    	jne    252c <subdir+0x59b>
    printf(1, "chdir dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../dd") != 0){
    2132:	83 ec 0c             	sub    $0xc,%esp
    2135:	68 b6 4d 00 00       	push   $0x4db6
    213a:	e8 a9 20 00 00       	call   41e8 <chdir>
    213f:	83 c4 10             	add    $0x10,%esp
    2142:	85 c0                	test   %eax,%eax
    2144:	0f 85 05 04 00 00    	jne    254f <subdir+0x5be>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../../dd") != 0){
    214a:	83 ec 0c             	sub    $0xc,%esp
    214d:	68 dc 4d 00 00       	push   $0x4ddc
    2152:	e8 91 20 00 00       	call   41e8 <chdir>
    2157:	83 c4 10             	add    $0x10,%esp
    215a:	85 c0                	test   %eax,%eax
    215c:	0f 85 10 04 00 00    	jne    2572 <subdir+0x5e1>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("./..") != 0){
    2162:	83 ec 0c             	sub    $0xc,%esp
    2165:	68 eb 4d 00 00       	push   $0x4deb
    216a:	e8 79 20 00 00       	call   41e8 <chdir>
    216f:	83 c4 10             	add    $0x10,%esp
    2172:	85 c0                	test   %eax,%eax
    2174:	0f 85 1b 04 00 00    	jne    2595 <subdir+0x604>
    printf(1, "chdir ./.. failed\n");
    exit(0);
  }

  fd = open("dd/dd/ffff", 0);
    217a:	83 ec 08             	sub    $0x8,%esp
    217d:	6a 00                	push   $0x0
    217f:	68 82 4d 00 00       	push   $0x4d82
    2184:	e8 2f 20 00 00       	call   41b8 <open>
    2189:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    218b:	83 c4 10             	add    $0x10,%esp
    218e:	85 c0                	test   %eax,%eax
    2190:	0f 88 22 04 00 00    	js     25b8 <subdir+0x627>
    printf(1, "open dd/dd/ffff failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2196:	83 ec 04             	sub    $0x4,%esp
    2199:	68 00 20 00 00       	push   $0x2000
    219e:	68 a0 8d 00 00       	push   $0x8da0
    21a3:	53                   	push   %ebx
    21a4:	e8 e7 1f 00 00       	call   4190 <read>
    21a9:	83 c4 10             	add    $0x10,%esp
    21ac:	83 f8 02             	cmp    $0x2,%eax
    21af:	0f 85 26 04 00 00    	jne    25db <subdir+0x64a>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit(0);
  }
  close(fd);
    21b5:	83 ec 0c             	sub    $0xc,%esp
    21b8:	53                   	push   %ebx
    21b9:	e8 e2 1f 00 00       	call   41a0 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21be:	83 c4 08             	add    $0x8,%esp
    21c1:	6a 00                	push   $0x0
    21c3:	68 1e 4d 00 00       	push   $0x4d1e
    21c8:	e8 eb 1f 00 00       	call   41b8 <open>
    21cd:	83 c4 10             	add    $0x10,%esp
    21d0:	85 c0                	test   %eax,%eax
    21d2:	0f 89 26 04 00 00    	jns    25fe <subdir+0x66d>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit(0);
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    21d8:	83 ec 08             	sub    $0x8,%esp
    21db:	68 02 02 00 00       	push   $0x202
    21e0:	68 36 4e 00 00       	push   $0x4e36
    21e5:	e8 ce 1f 00 00       	call   41b8 <open>
    21ea:	83 c4 10             	add    $0x10,%esp
    21ed:	85 c0                	test   %eax,%eax
    21ef:	0f 89 2c 04 00 00    	jns    2621 <subdir+0x690>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    21f5:	83 ec 08             	sub    $0x8,%esp
    21f8:	68 02 02 00 00       	push   $0x202
    21fd:	68 5b 4e 00 00       	push   $0x4e5b
    2202:	e8 b1 1f 00 00       	call   41b8 <open>
    2207:	83 c4 10             	add    $0x10,%esp
    220a:	85 c0                	test   %eax,%eax
    220c:	0f 89 32 04 00 00    	jns    2644 <subdir+0x6b3>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(open("dd", O_CREATE) >= 0){
    2212:	83 ec 08             	sub    $0x8,%esp
    2215:	68 00 02 00 00       	push   $0x200
    221a:	68 e8 4d 00 00       	push   $0x4de8
    221f:	e8 94 1f 00 00       	call   41b8 <open>
    2224:	83 c4 10             	add    $0x10,%esp
    2227:	85 c0                	test   %eax,%eax
    2229:	0f 89 38 04 00 00    	jns    2667 <subdir+0x6d6>
    printf(1, "create dd succeeded!\n");
    exit(0);
  }
  if(open("dd", O_RDWR) >= 0){
    222f:	83 ec 08             	sub    $0x8,%esp
    2232:	6a 02                	push   $0x2
    2234:	68 e8 4d 00 00       	push   $0x4de8
    2239:	e8 7a 1f 00 00       	call   41b8 <open>
    223e:	83 c4 10             	add    $0x10,%esp
    2241:	85 c0                	test   %eax,%eax
    2243:	0f 89 41 04 00 00    	jns    268a <subdir+0x6f9>
    printf(1, "open dd rdwr succeeded!\n");
    exit(0);
  }
  if(open("dd", O_WRONLY) >= 0){
    2249:	83 ec 08             	sub    $0x8,%esp
    224c:	6a 01                	push   $0x1
    224e:	68 e8 4d 00 00       	push   $0x4de8
    2253:	e8 60 1f 00 00       	call   41b8 <open>
    2258:	83 c4 10             	add    $0x10,%esp
    225b:	85 c0                	test   %eax,%eax
    225d:	0f 89 4a 04 00 00    	jns    26ad <subdir+0x71c>
    printf(1, "open dd wronly succeeded!\n");
    exit(0);
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2263:	83 ec 08             	sub    $0x8,%esp
    2266:	68 ca 4e 00 00       	push   $0x4eca
    226b:	68 36 4e 00 00       	push   $0x4e36
    2270:	e8 63 1f 00 00       	call   41d8 <link>
    2275:	83 c4 10             	add    $0x10,%esp
    2278:	85 c0                	test   %eax,%eax
    227a:	0f 84 50 04 00 00    	je     26d0 <subdir+0x73f>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2280:	83 ec 08             	sub    $0x8,%esp
    2283:	68 ca 4e 00 00       	push   $0x4eca
    2288:	68 5b 4e 00 00       	push   $0x4e5b
    228d:	e8 46 1f 00 00       	call   41d8 <link>
    2292:	83 c4 10             	add    $0x10,%esp
    2295:	85 c0                	test   %eax,%eax
    2297:	0f 84 56 04 00 00    	je     26f3 <subdir+0x762>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    229d:	83 ec 08             	sub    $0x8,%esp
    22a0:	68 82 4d 00 00       	push   $0x4d82
    22a5:	68 21 4d 00 00       	push   $0x4d21
    22aa:	e8 29 1f 00 00       	call   41d8 <link>
    22af:	83 c4 10             	add    $0x10,%esp
    22b2:	85 c0                	test   %eax,%eax
    22b4:	0f 84 5c 04 00 00    	je     2716 <subdir+0x785>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/ff/ff") == 0){
    22ba:	83 ec 0c             	sub    $0xc,%esp
    22bd:	68 36 4e 00 00       	push   $0x4e36
    22c2:	e8 19 1f 00 00       	call   41e0 <mkdir>
    22c7:	83 c4 10             	add    $0x10,%esp
    22ca:	85 c0                	test   %eax,%eax
    22cc:	0f 84 67 04 00 00    	je     2739 <subdir+0x7a8>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/xx/ff") == 0){
    22d2:	83 ec 0c             	sub    $0xc,%esp
    22d5:	68 5b 4e 00 00       	push   $0x4e5b
    22da:	e8 01 1f 00 00       	call   41e0 <mkdir>
    22df:	83 c4 10             	add    $0x10,%esp
    22e2:	85 c0                	test   %eax,%eax
    22e4:	0f 84 72 04 00 00    	je     275c <subdir+0x7cb>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/dd/ffff") == 0){
    22ea:	83 ec 0c             	sub    $0xc,%esp
    22ed:	68 82 4d 00 00       	push   $0x4d82
    22f2:	e8 e9 1e 00 00       	call   41e0 <mkdir>
    22f7:	83 c4 10             	add    $0x10,%esp
    22fa:	85 c0                	test   %eax,%eax
    22fc:	0f 84 7d 04 00 00    	je     277f <subdir+0x7ee>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/xx/ff") == 0){
    2302:	83 ec 0c             	sub    $0xc,%esp
    2305:	68 5b 4e 00 00       	push   $0x4e5b
    230a:	e8 b9 1e 00 00       	call   41c8 <unlink>
    230f:	83 c4 10             	add    $0x10,%esp
    2312:	85 c0                	test   %eax,%eax
    2314:	0f 84 88 04 00 00    	je     27a2 <subdir+0x811>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/ff/ff") == 0){
    231a:	83 ec 0c             	sub    $0xc,%esp
    231d:	68 36 4e 00 00       	push   $0x4e36
    2322:	e8 a1 1e 00 00       	call   41c8 <unlink>
    2327:	83 c4 10             	add    $0x10,%esp
    232a:	85 c0                	test   %eax,%eax
    232c:	0f 84 93 04 00 00    	je     27c5 <subdir+0x834>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/ff") == 0){
    2332:	83 ec 0c             	sub    $0xc,%esp
    2335:	68 21 4d 00 00       	push   $0x4d21
    233a:	e8 a9 1e 00 00       	call   41e8 <chdir>
    233f:	83 c4 10             	add    $0x10,%esp
    2342:	85 c0                	test   %eax,%eax
    2344:	0f 84 9e 04 00 00    	je     27e8 <subdir+0x857>
    printf(1, "chdir dd/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/xx") == 0){
    234a:	83 ec 0c             	sub    $0xc,%esp
    234d:	68 cd 4e 00 00       	push   $0x4ecd
    2352:	e8 91 1e 00 00       	call   41e8 <chdir>
    2357:	83 c4 10             	add    $0x10,%esp
    235a:	85 c0                	test   %eax,%eax
    235c:	0f 84 a9 04 00 00    	je     280b <subdir+0x87a>
    printf(1, "chdir dd/xx succeeded!\n");
    exit(0);
  }

  if(unlink("dd/dd/ffff") != 0){
    2362:	83 ec 0c             	sub    $0xc,%esp
    2365:	68 82 4d 00 00       	push   $0x4d82
    236a:	e8 59 1e 00 00       	call   41c8 <unlink>
    236f:	83 c4 10             	add    $0x10,%esp
    2372:	85 c0                	test   %eax,%eax
    2374:	0f 85 b4 04 00 00    	jne    282e <subdir+0x89d>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd/ff") != 0){
    237a:	83 ec 0c             	sub    $0xc,%esp
    237d:	68 21 4d 00 00       	push   $0x4d21
    2382:	e8 41 1e 00 00       	call   41c8 <unlink>
    2387:	83 c4 10             	add    $0x10,%esp
    238a:	85 c0                	test   %eax,%eax
    238c:	0f 85 bf 04 00 00    	jne    2851 <subdir+0x8c0>
    printf(1, "unlink dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd") == 0){
    2392:	83 ec 0c             	sub    $0xc,%esp
    2395:	68 e8 4d 00 00       	push   $0x4de8
    239a:	e8 29 1e 00 00       	call   41c8 <unlink>
    239f:	83 c4 10             	add    $0x10,%esp
    23a2:	85 c0                	test   %eax,%eax
    23a4:	0f 84 ca 04 00 00    	je     2874 <subdir+0x8e3>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit(0);
  }
  if(unlink("dd/dd") < 0){
    23aa:	83 ec 0c             	sub    $0xc,%esp
    23ad:	68 fd 4c 00 00       	push   $0x4cfd
    23b2:	e8 11 1e 00 00       	call   41c8 <unlink>
    23b7:	83 c4 10             	add    $0x10,%esp
    23ba:	85 c0                	test   %eax,%eax
    23bc:	0f 88 d5 04 00 00    	js     2897 <subdir+0x906>
    printf(1, "unlink dd/dd failed\n");
    exit(0);
  }
  if(unlink("dd") < 0){
    23c2:	83 ec 0c             	sub    $0xc,%esp
    23c5:	68 e8 4d 00 00       	push   $0x4de8
    23ca:	e8 f9 1d 00 00       	call   41c8 <unlink>
    23cf:	83 c4 10             	add    $0x10,%esp
    23d2:	85 c0                	test   %eax,%eax
    23d4:	0f 88 e0 04 00 00    	js     28ba <subdir+0x929>
    printf(1, "unlink dd failed\n");
    exit(0);
  }

  printf(1, "subdir ok\n");
    23da:	83 ec 08             	sub    $0x8,%esp
    23dd:	68 ca 4f 00 00       	push   $0x4fca
    23e2:	6a 01                	push   $0x1
    23e4:	e8 ea 1e 00 00       	call   42d3 <printf>
}
    23e9:	83 c4 10             	add    $0x10,%esp
    23ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    23ef:	c9                   	leave  
    23f0:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    23f1:	83 ec 08             	sub    $0x8,%esp
    23f4:	68 cf 4c 00 00       	push   $0x4ccf
    23f9:	6a 01                	push   $0x1
    23fb:	e8 d3 1e 00 00       	call   42d3 <printf>
    exit(0);
    2400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2407:	e8 6c 1d 00 00       	call   4178 <exit>
    240c:	83 c4 10             	add    $0x10,%esp
    240f:	e9 b3 fb ff ff       	jmp    1fc7 <subdir+0x36>
    printf(1, "create dd/ff failed\n");
    2414:	83 ec 08             	sub    $0x8,%esp
    2417:	68 e7 4c 00 00       	push   $0x4ce7
    241c:	6a 01                	push   $0x1
    241e:	e8 b0 1e 00 00       	call   42d3 <printf>
    exit(0);
    2423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    242a:	e8 49 1d 00 00       	call   4178 <exit>
    242f:	83 c4 10             	add    $0x10,%esp
    2432:	e9 af fb ff ff       	jmp    1fe6 <subdir+0x55>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2437:	83 ec 08             	sub    $0x8,%esp
    243a:	68 b4 57 00 00       	push   $0x57b4
    243f:	6a 01                	push   $0x1
    2441:	e8 8d 1e 00 00       	call   42d3 <printf>
    exit(0);
    2446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    244d:	e8 26 1d 00 00       	call   4178 <exit>
    2452:	83 c4 10             	add    $0x10,%esp
    2455:	e9 bb fb ff ff       	jmp    2015 <subdir+0x84>
    printf(1, "subdir mkdir dd/dd failed\n");
    245a:	83 ec 08             	sub    $0x8,%esp
    245d:	68 03 4d 00 00       	push   $0x4d03
    2462:	6a 01                	push   $0x1
    2464:	e8 6a 1e 00 00       	call   42d3 <printf>
    exit(0);
    2469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2470:	e8 03 1d 00 00       	call   4178 <exit>
    2475:	83 c4 10             	add    $0x10,%esp
    2478:	e9 b0 fb ff ff       	jmp    202d <subdir+0x9c>
    printf(1, "create dd/dd/ff failed\n");
    247d:	83 ec 08             	sub    $0x8,%esp
    2480:	68 27 4d 00 00       	push   $0x4d27
    2485:	6a 01                	push   $0x1
    2487:	e8 47 1e 00 00       	call   42d3 <printf>
    exit(0);
    248c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2493:	e8 e0 1c 00 00       	call   4178 <exit>
    2498:	83 c4 10             	add    $0x10,%esp
    249b:	e9 ac fb ff ff       	jmp    204c <subdir+0xbb>
    printf(1, "open dd/dd/../ff failed\n");
    24a0:	83 ec 08             	sub    $0x8,%esp
    24a3:	68 4e 4d 00 00       	push   $0x4d4e
    24a8:	6a 01                	push   $0x1
    24aa:	e8 24 1e 00 00       	call   42d3 <printf>
    exit(0);
    24af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24b6:	e8 bd 1c 00 00       	call   4178 <exit>
    24bb:	83 c4 10             	add    $0x10,%esp
    24be:	e9 bd fb ff ff       	jmp    2080 <subdir+0xef>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    24c3:	83 ec 08             	sub    $0x8,%esp
    24c6:	68 dc 57 00 00       	push   $0x57dc
    24cb:	6a 01                	push   $0x1
    24cd:	e8 01 1e 00 00       	call   42d3 <printf>
    exit(0);
    24d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24d9:	e8 9a 1c 00 00       	call   4178 <exit>
    24de:	83 c4 10             	add    $0x10,%esp
    24e1:	e9 02 fc ff ff       	jmp    20e8 <subdir+0x157>
    printf(1, "unlink dd/dd/ff failed\n");
    24e6:	83 ec 08             	sub    $0x8,%esp
    24e9:	68 8d 4d 00 00       	push   $0x4d8d
    24ee:	6a 01                	push   $0x1
    24f0:	e8 de 1d 00 00       	call   42d3 <printf>
    exit(0);
    24f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24fc:	e8 77 1c 00 00       	call   4178 <exit>
    2501:	83 c4 10             	add    $0x10,%esp
    2504:	e9 f7 fb ff ff       	jmp    2100 <subdir+0x16f>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2509:	83 ec 08             	sub    $0x8,%esp
    250c:	68 00 58 00 00       	push   $0x5800
    2511:	6a 01                	push   $0x1
    2513:	e8 bb 1d 00 00       	call   42d3 <printf>
    exit(0);
    2518:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    251f:	e8 54 1c 00 00       	call   4178 <exit>
    2524:	83 c4 10             	add    $0x10,%esp
    2527:	e9 ee fb ff ff       	jmp    211a <subdir+0x189>
    printf(1, "chdir dd failed\n");
    252c:	83 ec 08             	sub    $0x8,%esp
    252f:	68 a5 4d 00 00       	push   $0x4da5
    2534:	6a 01                	push   $0x1
    2536:	e8 98 1d 00 00       	call   42d3 <printf>
    exit(0);
    253b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2542:	e8 31 1c 00 00       	call   4178 <exit>
    2547:	83 c4 10             	add    $0x10,%esp
    254a:	e9 e3 fb ff ff       	jmp    2132 <subdir+0x1a1>
    printf(1, "chdir dd/../../dd failed\n");
    254f:	83 ec 08             	sub    $0x8,%esp
    2552:	68 c2 4d 00 00       	push   $0x4dc2
    2557:	6a 01                	push   $0x1
    2559:	e8 75 1d 00 00       	call   42d3 <printf>
    exit(0);
    255e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2565:	e8 0e 1c 00 00       	call   4178 <exit>
    256a:	83 c4 10             	add    $0x10,%esp
    256d:	e9 d8 fb ff ff       	jmp    214a <subdir+0x1b9>
    printf(1, "chdir dd/../../dd failed\n");
    2572:	83 ec 08             	sub    $0x8,%esp
    2575:	68 c2 4d 00 00       	push   $0x4dc2
    257a:	6a 01                	push   $0x1
    257c:	e8 52 1d 00 00       	call   42d3 <printf>
    exit(0);
    2581:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2588:	e8 eb 1b 00 00       	call   4178 <exit>
    258d:	83 c4 10             	add    $0x10,%esp
    2590:	e9 cd fb ff ff       	jmp    2162 <subdir+0x1d1>
    printf(1, "chdir ./.. failed\n");
    2595:	83 ec 08             	sub    $0x8,%esp
    2598:	68 f0 4d 00 00       	push   $0x4df0
    259d:	6a 01                	push   $0x1
    259f:	e8 2f 1d 00 00       	call   42d3 <printf>
    exit(0);
    25a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25ab:	e8 c8 1b 00 00       	call   4178 <exit>
    25b0:	83 c4 10             	add    $0x10,%esp
    25b3:	e9 c2 fb ff ff       	jmp    217a <subdir+0x1e9>
    printf(1, "open dd/dd/ffff failed\n");
    25b8:	83 ec 08             	sub    $0x8,%esp
    25bb:	68 03 4e 00 00       	push   $0x4e03
    25c0:	6a 01                	push   $0x1
    25c2:	e8 0c 1d 00 00       	call   42d3 <printf>
    exit(0);
    25c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25ce:	e8 a5 1b 00 00       	call   4178 <exit>
    25d3:	83 c4 10             	add    $0x10,%esp
    25d6:	e9 bb fb ff ff       	jmp    2196 <subdir+0x205>
    printf(1, "read dd/dd/ffff wrong len\n");
    25db:	83 ec 08             	sub    $0x8,%esp
    25de:	68 1b 4e 00 00       	push   $0x4e1b
    25e3:	6a 01                	push   $0x1
    25e5:	e8 e9 1c 00 00       	call   42d3 <printf>
    exit(0);
    25ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25f1:	e8 82 1b 00 00       	call   4178 <exit>
    25f6:	83 c4 10             	add    $0x10,%esp
    25f9:	e9 b7 fb ff ff       	jmp    21b5 <subdir+0x224>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    25fe:	83 ec 08             	sub    $0x8,%esp
    2601:	68 24 58 00 00       	push   $0x5824
    2606:	6a 01                	push   $0x1
    2608:	e8 c6 1c 00 00       	call   42d3 <printf>
    exit(0);
    260d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2614:	e8 5f 1b 00 00       	call   4178 <exit>
    2619:	83 c4 10             	add    $0x10,%esp
    261c:	e9 b7 fb ff ff       	jmp    21d8 <subdir+0x247>
    printf(1, "create dd/ff/ff succeeded!\n");
    2621:	83 ec 08             	sub    $0x8,%esp
    2624:	68 3f 4e 00 00       	push   $0x4e3f
    2629:	6a 01                	push   $0x1
    262b:	e8 a3 1c 00 00       	call   42d3 <printf>
    exit(0);
    2630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2637:	e8 3c 1b 00 00       	call   4178 <exit>
    263c:	83 c4 10             	add    $0x10,%esp
    263f:	e9 b1 fb ff ff       	jmp    21f5 <subdir+0x264>
    printf(1, "create dd/xx/ff succeeded!\n");
    2644:	83 ec 08             	sub    $0x8,%esp
    2647:	68 64 4e 00 00       	push   $0x4e64
    264c:	6a 01                	push   $0x1
    264e:	e8 80 1c 00 00       	call   42d3 <printf>
    exit(0);
    2653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    265a:	e8 19 1b 00 00       	call   4178 <exit>
    265f:	83 c4 10             	add    $0x10,%esp
    2662:	e9 ab fb ff ff       	jmp    2212 <subdir+0x281>
    printf(1, "create dd succeeded!\n");
    2667:	83 ec 08             	sub    $0x8,%esp
    266a:	68 80 4e 00 00       	push   $0x4e80
    266f:	6a 01                	push   $0x1
    2671:	e8 5d 1c 00 00       	call   42d3 <printf>
    exit(0);
    2676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    267d:	e8 f6 1a 00 00       	call   4178 <exit>
    2682:	83 c4 10             	add    $0x10,%esp
    2685:	e9 a5 fb ff ff       	jmp    222f <subdir+0x29e>
    printf(1, "open dd rdwr succeeded!\n");
    268a:	83 ec 08             	sub    $0x8,%esp
    268d:	68 96 4e 00 00       	push   $0x4e96
    2692:	6a 01                	push   $0x1
    2694:	e8 3a 1c 00 00       	call   42d3 <printf>
    exit(0);
    2699:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26a0:	e8 d3 1a 00 00       	call   4178 <exit>
    26a5:	83 c4 10             	add    $0x10,%esp
    26a8:	e9 9c fb ff ff       	jmp    2249 <subdir+0x2b8>
    printf(1, "open dd wronly succeeded!\n");
    26ad:	83 ec 08             	sub    $0x8,%esp
    26b0:	68 af 4e 00 00       	push   $0x4eaf
    26b5:	6a 01                	push   $0x1
    26b7:	e8 17 1c 00 00       	call   42d3 <printf>
    exit(0);
    26bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26c3:	e8 b0 1a 00 00       	call   4178 <exit>
    26c8:	83 c4 10             	add    $0x10,%esp
    26cb:	e9 93 fb ff ff       	jmp    2263 <subdir+0x2d2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    26d0:	83 ec 08             	sub    $0x8,%esp
    26d3:	68 4c 58 00 00       	push   $0x584c
    26d8:	6a 01                	push   $0x1
    26da:	e8 f4 1b 00 00       	call   42d3 <printf>
    exit(0);
    26df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26e6:	e8 8d 1a 00 00       	call   4178 <exit>
    26eb:	83 c4 10             	add    $0x10,%esp
    26ee:	e9 8d fb ff ff       	jmp    2280 <subdir+0x2ef>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    26f3:	83 ec 08             	sub    $0x8,%esp
    26f6:	68 70 58 00 00       	push   $0x5870
    26fb:	6a 01                	push   $0x1
    26fd:	e8 d1 1b 00 00       	call   42d3 <printf>
    exit(0);
    2702:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2709:	e8 6a 1a 00 00       	call   4178 <exit>
    270e:	83 c4 10             	add    $0x10,%esp
    2711:	e9 87 fb ff ff       	jmp    229d <subdir+0x30c>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2716:	83 ec 08             	sub    $0x8,%esp
    2719:	68 94 58 00 00       	push   $0x5894
    271e:	6a 01                	push   $0x1
    2720:	e8 ae 1b 00 00       	call   42d3 <printf>
    exit(0);
    2725:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    272c:	e8 47 1a 00 00       	call   4178 <exit>
    2731:	83 c4 10             	add    $0x10,%esp
    2734:	e9 81 fb ff ff       	jmp    22ba <subdir+0x329>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2739:	83 ec 08             	sub    $0x8,%esp
    273c:	68 d3 4e 00 00       	push   $0x4ed3
    2741:	6a 01                	push   $0x1
    2743:	e8 8b 1b 00 00       	call   42d3 <printf>
    exit(0);
    2748:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    274f:	e8 24 1a 00 00       	call   4178 <exit>
    2754:	83 c4 10             	add    $0x10,%esp
    2757:	e9 76 fb ff ff       	jmp    22d2 <subdir+0x341>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    275c:	83 ec 08             	sub    $0x8,%esp
    275f:	68 ee 4e 00 00       	push   $0x4eee
    2764:	6a 01                	push   $0x1
    2766:	e8 68 1b 00 00       	call   42d3 <printf>
    exit(0);
    276b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2772:	e8 01 1a 00 00       	call   4178 <exit>
    2777:	83 c4 10             	add    $0x10,%esp
    277a:	e9 6b fb ff ff       	jmp    22ea <subdir+0x359>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    277f:	83 ec 08             	sub    $0x8,%esp
    2782:	68 09 4f 00 00       	push   $0x4f09
    2787:	6a 01                	push   $0x1
    2789:	e8 45 1b 00 00       	call   42d3 <printf>
    exit(0);
    278e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2795:	e8 de 19 00 00       	call   4178 <exit>
    279a:	83 c4 10             	add    $0x10,%esp
    279d:	e9 60 fb ff ff       	jmp    2302 <subdir+0x371>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    27a2:	83 ec 08             	sub    $0x8,%esp
    27a5:	68 26 4f 00 00       	push   $0x4f26
    27aa:	6a 01                	push   $0x1
    27ac:	e8 22 1b 00 00       	call   42d3 <printf>
    exit(0);
    27b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27b8:	e8 bb 19 00 00       	call   4178 <exit>
    27bd:	83 c4 10             	add    $0x10,%esp
    27c0:	e9 55 fb ff ff       	jmp    231a <subdir+0x389>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    27c5:	83 ec 08             	sub    $0x8,%esp
    27c8:	68 42 4f 00 00       	push   $0x4f42
    27cd:	6a 01                	push   $0x1
    27cf:	e8 ff 1a 00 00       	call   42d3 <printf>
    exit(0);
    27d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27db:	e8 98 19 00 00       	call   4178 <exit>
    27e0:	83 c4 10             	add    $0x10,%esp
    27e3:	e9 4a fb ff ff       	jmp    2332 <subdir+0x3a1>
    printf(1, "chdir dd/ff succeeded!\n");
    27e8:	83 ec 08             	sub    $0x8,%esp
    27eb:	68 5e 4f 00 00       	push   $0x4f5e
    27f0:	6a 01                	push   $0x1
    27f2:	e8 dc 1a 00 00       	call   42d3 <printf>
    exit(0);
    27f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27fe:	e8 75 19 00 00       	call   4178 <exit>
    2803:	83 c4 10             	add    $0x10,%esp
    2806:	e9 3f fb ff ff       	jmp    234a <subdir+0x3b9>
    printf(1, "chdir dd/xx succeeded!\n");
    280b:	83 ec 08             	sub    $0x8,%esp
    280e:	68 76 4f 00 00       	push   $0x4f76
    2813:	6a 01                	push   $0x1
    2815:	e8 b9 1a 00 00       	call   42d3 <printf>
    exit(0);
    281a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2821:	e8 52 19 00 00       	call   4178 <exit>
    2826:	83 c4 10             	add    $0x10,%esp
    2829:	e9 34 fb ff ff       	jmp    2362 <subdir+0x3d1>
    printf(1, "unlink dd/dd/ff failed\n");
    282e:	83 ec 08             	sub    $0x8,%esp
    2831:	68 8d 4d 00 00       	push   $0x4d8d
    2836:	6a 01                	push   $0x1
    2838:	e8 96 1a 00 00       	call   42d3 <printf>
    exit(0);
    283d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2844:	e8 2f 19 00 00       	call   4178 <exit>
    2849:	83 c4 10             	add    $0x10,%esp
    284c:	e9 29 fb ff ff       	jmp    237a <subdir+0x3e9>
    printf(1, "unlink dd/ff failed\n");
    2851:	83 ec 08             	sub    $0x8,%esp
    2854:	68 8e 4f 00 00       	push   $0x4f8e
    2859:	6a 01                	push   $0x1
    285b:	e8 73 1a 00 00       	call   42d3 <printf>
    exit(0);
    2860:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2867:	e8 0c 19 00 00       	call   4178 <exit>
    286c:	83 c4 10             	add    $0x10,%esp
    286f:	e9 1e fb ff ff       	jmp    2392 <subdir+0x401>
    printf(1, "unlink non-empty dd succeeded!\n");
    2874:	83 ec 08             	sub    $0x8,%esp
    2877:	68 b8 58 00 00       	push   $0x58b8
    287c:	6a 01                	push   $0x1
    287e:	e8 50 1a 00 00       	call   42d3 <printf>
    exit(0);
    2883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    288a:	e8 e9 18 00 00       	call   4178 <exit>
    288f:	83 c4 10             	add    $0x10,%esp
    2892:	e9 13 fb ff ff       	jmp    23aa <subdir+0x419>
    printf(1, "unlink dd/dd failed\n");
    2897:	83 ec 08             	sub    $0x8,%esp
    289a:	68 a3 4f 00 00       	push   $0x4fa3
    289f:	6a 01                	push   $0x1
    28a1:	e8 2d 1a 00 00       	call   42d3 <printf>
    exit(0);
    28a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    28ad:	e8 c6 18 00 00       	call   4178 <exit>
    28b2:	83 c4 10             	add    $0x10,%esp
    28b5:	e9 08 fb ff ff       	jmp    23c2 <subdir+0x431>
    printf(1, "unlink dd failed\n");
    28ba:	83 ec 08             	sub    $0x8,%esp
    28bd:	68 b8 4f 00 00       	push   $0x4fb8
    28c2:	6a 01                	push   $0x1
    28c4:	e8 0a 1a 00 00       	call   42d3 <printf>
    exit(0);
    28c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    28d0:	e8 a3 18 00 00       	call   4178 <exit>
    28d5:	83 c4 10             	add    $0x10,%esp
    28d8:	e9 fd fa ff ff       	jmp    23da <subdir+0x449>

000028dd <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    28dd:	55                   	push   %ebp
    28de:	89 e5                	mov    %esp,%ebp
    28e0:	57                   	push   %edi
    28e1:	56                   	push   %esi
    28e2:	53                   	push   %ebx
    28e3:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    28e6:	68 d5 4f 00 00       	push   $0x4fd5
    28eb:	6a 01                	push   $0x1
    28ed:	e8 e1 19 00 00       	call   42d3 <printf>

  unlink("bigwrite");
    28f2:	c7 04 24 e4 4f 00 00 	movl   $0x4fe4,(%esp)
    28f9:	e8 ca 18 00 00       	call   41c8 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    28fe:	83 c4 10             	add    $0x10,%esp
    2901:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    2906:	eb 7c                	jmp    2984 <bigwrite+0xa7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    2908:	83 ec 08             	sub    $0x8,%esp
    290b:	68 ed 4f 00 00       	push   $0x4fed
    2910:	6a 01                	push   $0x1
    2912:	e8 bc 19 00 00       	call   42d3 <printf>
      exit(0);
    2917:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    291e:	e8 55 18 00 00       	call   4178 <exit>
    2923:	83 c4 10             	add    $0x10,%esp
    2926:	e9 80 00 00 00       	jmp    29ab <bigwrite+0xce>
    }
    int i;
    for(i = 0; i < 2; i++){
    292b:	46                   	inc    %esi
    292c:	83 fe 01             	cmp    $0x1,%esi
    292f:	7f 35                	jg     2966 <bigwrite+0x89>
      int cc = write(fd, buf, sz);
    2931:	83 ec 04             	sub    $0x4,%esp
    2934:	53                   	push   %ebx
    2935:	68 a0 8d 00 00       	push   $0x8da0
    293a:	57                   	push   %edi
    293b:	e8 58 18 00 00       	call   4198 <write>
      if(cc != sz){
    2940:	83 c4 10             	add    $0x10,%esp
    2943:	39 c3                	cmp    %eax,%ebx
    2945:	74 e4                	je     292b <bigwrite+0x4e>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2947:	50                   	push   %eax
    2948:	53                   	push   %ebx
    2949:	68 05 50 00 00       	push   $0x5005
    294e:	6a 01                	push   $0x1
    2950:	e8 7e 19 00 00       	call   42d3 <printf>
        exit(0);
    2955:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    295c:	e8 17 18 00 00       	call   4178 <exit>
    2961:	83 c4 10             	add    $0x10,%esp
    2964:	eb c5                	jmp    292b <bigwrite+0x4e>
      }
    }
    close(fd);
    2966:	83 ec 0c             	sub    $0xc,%esp
    2969:	57                   	push   %edi
    296a:	e8 31 18 00 00       	call   41a0 <close>
    unlink("bigwrite");
    296f:	c7 04 24 e4 4f 00 00 	movl   $0x4fe4,(%esp)
    2976:	e8 4d 18 00 00       	call   41c8 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    297b:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    2981:	83 c4 10             	add    $0x10,%esp
    2984:	81 fb ff 17 00 00    	cmp    $0x17ff,%ebx
    298a:	7f 29                	jg     29b5 <bigwrite+0xd8>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    298c:	83 ec 08             	sub    $0x8,%esp
    298f:	68 02 02 00 00       	push   $0x202
    2994:	68 e4 4f 00 00       	push   $0x4fe4
    2999:	e8 1a 18 00 00       	call   41b8 <open>
    299e:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    29a0:	83 c4 10             	add    $0x10,%esp
    29a3:	85 c0                	test   %eax,%eax
    29a5:	0f 88 5d ff ff ff    	js     2908 <bigwrite+0x2b>
{
    29ab:	be 00 00 00 00       	mov    $0x0,%esi
    29b0:	e9 77 ff ff ff       	jmp    292c <bigwrite+0x4f>
  }

  printf(1, "bigwrite ok\n");
    29b5:	83 ec 08             	sub    $0x8,%esp
    29b8:	68 17 50 00 00       	push   $0x5017
    29bd:	6a 01                	push   $0x1
    29bf:	e8 0f 19 00 00       	call   42d3 <printf>
}
    29c4:	83 c4 10             	add    $0x10,%esp
    29c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    29ca:	5b                   	pop    %ebx
    29cb:	5e                   	pop    %esi
    29cc:	5f                   	pop    %edi
    29cd:	5d                   	pop    %ebp
    29ce:	c3                   	ret    

000029cf <bigfile>:

void
bigfile(void)
{
    29cf:	55                   	push   %ebp
    29d0:	89 e5                	mov    %esp,%ebp
    29d2:	57                   	push   %edi
    29d3:	56                   	push   %esi
    29d4:	53                   	push   %ebx
    29d5:	83 ec 24             	sub    $0x24,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    29d8:	68 24 50 00 00       	push   $0x5024
    29dd:	6a 01                	push   $0x1
    29df:	e8 ef 18 00 00       	call   42d3 <printf>

  unlink("bigfile");
    29e4:	c7 04 24 40 50 00 00 	movl   $0x5040,(%esp)
    29eb:	e8 d8 17 00 00       	call   41c8 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    29f0:	83 c4 08             	add    $0x8,%esp
    29f3:	68 02 02 00 00       	push   $0x202
    29f8:	68 40 50 00 00       	push   $0x5040
    29fd:	e8 b6 17 00 00       	call   41b8 <open>
    2a02:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2a04:	83 c4 10             	add    $0x10,%esp
    2a07:	85 c0                	test   %eax,%eax
    2a09:	78 07                	js     2a12 <bigfile+0x43>
{
    2a0b:	bb 00 00 00 00       	mov    $0x0,%ebx
    2a10:	eb 21                	jmp    2a33 <bigfile+0x64>
    printf(1, "cannot create bigfile");
    2a12:	83 ec 08             	sub    $0x8,%esp
    2a15:	68 32 50 00 00       	push   $0x5032
    2a1a:	6a 01                	push   $0x1
    2a1c:	e8 b2 18 00 00       	call   42d3 <printf>
    exit(0);
    2a21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a28:	e8 4b 17 00 00       	call   4178 <exit>
    2a2d:	83 c4 10             	add    $0x10,%esp
    2a30:	eb d9                	jmp    2a0b <bigfile+0x3c>
  }
  for(i = 0; i < 20; i++){
    2a32:	43                   	inc    %ebx
    2a33:	83 fb 13             	cmp    $0x13,%ebx
    2a36:	7f 50                	jg     2a88 <bigfile+0xb9>
    memset(buf, i, 600);
    2a38:	83 ec 04             	sub    $0x4,%esp
    2a3b:	68 58 02 00 00       	push   $0x258
    2a40:	53                   	push   %ebx
    2a41:	68 a0 8d 00 00       	push   $0x8da0
    2a46:	e8 02 16 00 00       	call   404d <memset>
    if(write(fd, buf, 600) != 600){
    2a4b:	83 c4 0c             	add    $0xc,%esp
    2a4e:	68 58 02 00 00       	push   $0x258
    2a53:	68 a0 8d 00 00       	push   $0x8da0
    2a58:	56                   	push   %esi
    2a59:	e8 3a 17 00 00       	call   4198 <write>
    2a5e:	83 c4 10             	add    $0x10,%esp
    2a61:	3d 58 02 00 00       	cmp    $0x258,%eax
    2a66:	74 ca                	je     2a32 <bigfile+0x63>
      printf(1, "write bigfile failed\n");
    2a68:	83 ec 08             	sub    $0x8,%esp
    2a6b:	68 48 50 00 00       	push   $0x5048
    2a70:	6a 01                	push   $0x1
    2a72:	e8 5c 18 00 00       	call   42d3 <printf>
      exit(0);
    2a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a7e:	e8 f5 16 00 00       	call   4178 <exit>
    2a83:	83 c4 10             	add    $0x10,%esp
    2a86:	eb aa                	jmp    2a32 <bigfile+0x63>
    }
  }
  close(fd);
    2a88:	83 ec 0c             	sub    $0xc,%esp
    2a8b:	56                   	push   %esi
    2a8c:	e8 0f 17 00 00       	call   41a0 <close>

  fd = open("bigfile", 0);
    2a91:	83 c4 08             	add    $0x8,%esp
    2a94:	6a 00                	push   $0x0
    2a96:	68 40 50 00 00       	push   $0x5040
    2a9b:	e8 18 17 00 00       	call   41b8 <open>
    2aa0:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    2aa2:	83 c4 10             	add    $0x10,%esp
    2aa5:	85 c0                	test   %eax,%eax
    2aa7:	78 11                	js     2aba <bigfile+0xeb>
{
    2aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    2ab0:	be 00 00 00 00       	mov    $0x0,%esi
    2ab5:	e9 82 00 00 00       	jmp    2b3c <bigfile+0x16d>
    printf(1, "cannot open bigfile\n");
    2aba:	83 ec 08             	sub    $0x8,%esp
    2abd:	68 5e 50 00 00       	push   $0x505e
    2ac2:	6a 01                	push   $0x1
    2ac4:	e8 0a 18 00 00       	call   42d3 <printf>
    exit(0);
    2ac9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ad0:	e8 a3 16 00 00       	call   4178 <exit>
    2ad5:	83 c4 10             	add    $0x10,%esp
    2ad8:	eb cf                	jmp    2aa9 <bigfile+0xda>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
    2ada:	83 ec 08             	sub    $0x8,%esp
    2add:	68 73 50 00 00       	push   $0x5073
    2ae2:	6a 01                	push   $0x1
    2ae4:	e8 ea 17 00 00       	call   42d3 <printf>
      exit(0);
    2ae9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2af0:	e8 83 16 00 00       	call   4178 <exit>
    2af5:	83 c4 10             	add    $0x10,%esp
    2af8:	eb 5e                	jmp    2b58 <bigfile+0x189>
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
    2afa:	83 ec 08             	sub    $0x8,%esp
    2afd:	68 88 50 00 00       	push   $0x5088
    2b02:	6a 01                	push   $0x1
    2b04:	e8 ca 17 00 00       	call   42d3 <printf>
      exit(0);
    2b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b10:	e8 63 16 00 00       	call   4178 <exit>
    2b15:	83 c4 10             	add    $0x10,%esp
    2b18:	eb 4a                	jmp    2b64 <bigfile+0x195>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
    2b1a:	83 ec 08             	sub    $0x8,%esp
    2b1d:	68 9c 50 00 00       	push   $0x509c
    2b22:	6a 01                	push   $0x1
    2b24:	e8 aa 17 00 00       	call   42d3 <printf>
      exit(0);
    2b29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b30:	e8 43 16 00 00       	call   4178 <exit>
    2b35:	83 c4 10             	add    $0x10,%esp
    }
    total += cc;
    2b38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
  for(i = 0; ; i++){
    2b3b:	46                   	inc    %esi
    cc = read(fd, buf, 300);
    2b3c:	83 ec 04             	sub    $0x4,%esp
    2b3f:	68 2c 01 00 00       	push   $0x12c
    2b44:	68 a0 8d 00 00       	push   $0x8da0
    2b49:	57                   	push   %edi
    2b4a:	e8 41 16 00 00       	call   4190 <read>
    2b4f:	89 c3                	mov    %eax,%ebx
    if(cc < 0){
    2b51:	83 c4 10             	add    $0x10,%esp
    2b54:	85 c0                	test   %eax,%eax
    2b56:	78 82                	js     2ada <bigfile+0x10b>
    if(cc == 0)
    2b58:	85 db                	test   %ebx,%ebx
    2b5a:	74 29                	je     2b85 <bigfile+0x1b6>
    if(cc != 300){
    2b5c:	81 fb 2c 01 00 00    	cmp    $0x12c,%ebx
    2b62:	75 96                	jne    2afa <bigfile+0x12b>
    if(buf[0] != i/2 || buf[299] != i/2){
    2b64:	0f be 15 a0 8d 00 00 	movsbl 0x8da0,%edx
    2b6b:	89 f0                	mov    %esi,%eax
    2b6d:	c1 e8 1f             	shr    $0x1f,%eax
    2b70:	01 f0                	add    %esi,%eax
    2b72:	d1 f8                	sar    %eax
    2b74:	39 c2                	cmp    %eax,%edx
    2b76:	75 a2                	jne    2b1a <bigfile+0x14b>
    2b78:	0f be 15 cb 8e 00 00 	movsbl 0x8ecb,%edx
    2b7f:	39 d0                	cmp    %edx,%eax
    2b81:	75 97                	jne    2b1a <bigfile+0x14b>
    2b83:	eb b3                	jmp    2b38 <bigfile+0x169>
  }
  close(fd);
    2b85:	83 ec 0c             	sub    $0xc,%esp
    2b88:	57                   	push   %edi
    2b89:	e8 12 16 00 00       	call   41a0 <close>
  if(total != 20*600){
    2b8e:	83 c4 10             	add    $0x10,%esp
    2b91:	81 7d e4 e0 2e 00 00 	cmpl   $0x2ee0,-0x1c(%ebp)
    2b98:	75 27                	jne    2bc1 <bigfile+0x1f2>
    printf(1, "read bigfile wrong total\n");
    exit(0);
  }
  unlink("bigfile");
    2b9a:	83 ec 0c             	sub    $0xc,%esp
    2b9d:	68 40 50 00 00       	push   $0x5040
    2ba2:	e8 21 16 00 00       	call   41c8 <unlink>

  printf(1, "bigfile test ok\n");
    2ba7:	83 c4 08             	add    $0x8,%esp
    2baa:	68 cf 50 00 00       	push   $0x50cf
    2baf:	6a 01                	push   $0x1
    2bb1:	e8 1d 17 00 00       	call   42d3 <printf>
}
    2bb6:	83 c4 10             	add    $0x10,%esp
    2bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2bbc:	5b                   	pop    %ebx
    2bbd:	5e                   	pop    %esi
    2bbe:	5f                   	pop    %edi
    2bbf:	5d                   	pop    %ebp
    2bc0:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    2bc1:	83 ec 08             	sub    $0x8,%esp
    2bc4:	68 b5 50 00 00       	push   $0x50b5
    2bc9:	6a 01                	push   $0x1
    2bcb:	e8 03 17 00 00       	call   42d3 <printf>
    exit(0);
    2bd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2bd7:	e8 9c 15 00 00       	call   4178 <exit>
    2bdc:	83 c4 10             	add    $0x10,%esp
    2bdf:	eb b9                	jmp    2b9a <bigfile+0x1cb>

00002be1 <fourteen>:

void
fourteen(void)
{
    2be1:	55                   	push   %ebp
    2be2:	89 e5                	mov    %esp,%ebp
    2be4:	53                   	push   %ebx
    2be5:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2be8:	68 e0 50 00 00       	push   $0x50e0
    2bed:	6a 01                	push   $0x1
    2bef:	e8 df 16 00 00       	call   42d3 <printf>

  if(mkdir("12345678901234") != 0){
    2bf4:	c7 04 24 1b 51 00 00 	movl   $0x511b,(%esp)
    2bfb:	e8 e0 15 00 00       	call   41e0 <mkdir>
    2c00:	83 c4 10             	add    $0x10,%esp
    2c03:	85 c0                	test   %eax,%eax
    2c05:	0f 85 ab 00 00 00    	jne    2cb6 <fourteen+0xd5>
    printf(1, "mkdir 12345678901234 failed\n");
    exit(0);
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2c0b:	83 ec 0c             	sub    $0xc,%esp
    2c0e:	68 d8 58 00 00       	push   $0x58d8
    2c13:	e8 c8 15 00 00       	call   41e0 <mkdir>
    2c18:	83 c4 10             	add    $0x10,%esp
    2c1b:	85 c0                	test   %eax,%eax
    2c1d:	0f 85 b6 00 00 00    	jne    2cd9 <fourteen+0xf8>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit(0);
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c23:	83 ec 08             	sub    $0x8,%esp
    2c26:	68 00 02 00 00       	push   $0x200
    2c2b:	68 28 59 00 00       	push   $0x5928
    2c30:	e8 83 15 00 00       	call   41b8 <open>
    2c35:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2c37:	83 c4 10             	add    $0x10,%esp
    2c3a:	85 c0                	test   %eax,%eax
    2c3c:	0f 88 ba 00 00 00    	js     2cfc <fourteen+0x11b>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit(0);
  }
  close(fd);
    2c42:	83 ec 0c             	sub    $0xc,%esp
    2c45:	53                   	push   %ebx
    2c46:	e8 55 15 00 00       	call   41a0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c4b:	83 c4 08             	add    $0x8,%esp
    2c4e:	6a 00                	push   $0x0
    2c50:	68 98 59 00 00       	push   $0x5998
    2c55:	e8 5e 15 00 00       	call   41b8 <open>
    2c5a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2c5c:	83 c4 10             	add    $0x10,%esp
    2c5f:	85 c0                	test   %eax,%eax
    2c61:	0f 88 b8 00 00 00    	js     2d1f <fourteen+0x13e>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit(0);
  }
  close(fd);
    2c67:	83 ec 0c             	sub    $0xc,%esp
    2c6a:	53                   	push   %ebx
    2c6b:	e8 30 15 00 00       	call   41a0 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2c70:	c7 04 24 0c 51 00 00 	movl   $0x510c,(%esp)
    2c77:	e8 64 15 00 00       	call   41e0 <mkdir>
    2c7c:	83 c4 10             	add    $0x10,%esp
    2c7f:	85 c0                	test   %eax,%eax
    2c81:	0f 84 bb 00 00 00    	je     2d42 <fourteen+0x161>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit(0);
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2c87:	83 ec 0c             	sub    $0xc,%esp
    2c8a:	68 34 5a 00 00       	push   $0x5a34
    2c8f:	e8 4c 15 00 00       	call   41e0 <mkdir>
    2c94:	83 c4 10             	add    $0x10,%esp
    2c97:	85 c0                	test   %eax,%eax
    2c99:	0f 84 c6 00 00 00    	je     2d65 <fourteen+0x184>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit(0);
  }

  printf(1, "fourteen ok\n");
    2c9f:	83 ec 08             	sub    $0x8,%esp
    2ca2:	68 2a 51 00 00       	push   $0x512a
    2ca7:	6a 01                	push   $0x1
    2ca9:	e8 25 16 00 00       	call   42d3 <printf>
}
    2cae:	83 c4 10             	add    $0x10,%esp
    2cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2cb4:	c9                   	leave  
    2cb5:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2cb6:	83 ec 08             	sub    $0x8,%esp
    2cb9:	68 ef 50 00 00       	push   $0x50ef
    2cbe:	6a 01                	push   $0x1
    2cc0:	e8 0e 16 00 00       	call   42d3 <printf>
    exit(0);
    2cc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ccc:	e8 a7 14 00 00       	call   4178 <exit>
    2cd1:	83 c4 10             	add    $0x10,%esp
    2cd4:	e9 32 ff ff ff       	jmp    2c0b <fourteen+0x2a>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2cd9:	83 ec 08             	sub    $0x8,%esp
    2cdc:	68 f8 58 00 00       	push   $0x58f8
    2ce1:	6a 01                	push   $0x1
    2ce3:	e8 eb 15 00 00       	call   42d3 <printf>
    exit(0);
    2ce8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cef:	e8 84 14 00 00       	call   4178 <exit>
    2cf4:	83 c4 10             	add    $0x10,%esp
    2cf7:	e9 27 ff ff ff       	jmp    2c23 <fourteen+0x42>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2cfc:	83 ec 08             	sub    $0x8,%esp
    2cff:	68 58 59 00 00       	push   $0x5958
    2d04:	6a 01                	push   $0x1
    2d06:	e8 c8 15 00 00       	call   42d3 <printf>
    exit(0);
    2d0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d12:	e8 61 14 00 00       	call   4178 <exit>
    2d17:	83 c4 10             	add    $0x10,%esp
    2d1a:	e9 23 ff ff ff       	jmp    2c42 <fourteen+0x61>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2d1f:	83 ec 08             	sub    $0x8,%esp
    2d22:	68 c8 59 00 00       	push   $0x59c8
    2d27:	6a 01                	push   $0x1
    2d29:	e8 a5 15 00 00       	call   42d3 <printf>
    exit(0);
    2d2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d35:	e8 3e 14 00 00       	call   4178 <exit>
    2d3a:	83 c4 10             	add    $0x10,%esp
    2d3d:	e9 25 ff ff ff       	jmp    2c67 <fourteen+0x86>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2d42:	83 ec 08             	sub    $0x8,%esp
    2d45:	68 04 5a 00 00       	push   $0x5a04
    2d4a:	6a 01                	push   $0x1
    2d4c:	e8 82 15 00 00       	call   42d3 <printf>
    exit(0);
    2d51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d58:	e8 1b 14 00 00       	call   4178 <exit>
    2d5d:	83 c4 10             	add    $0x10,%esp
    2d60:	e9 22 ff ff ff       	jmp    2c87 <fourteen+0xa6>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2d65:	83 ec 08             	sub    $0x8,%esp
    2d68:	68 54 5a 00 00       	push   $0x5a54
    2d6d:	6a 01                	push   $0x1
    2d6f:	e8 5f 15 00 00       	call   42d3 <printf>
    exit(0);
    2d74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d7b:	e8 f8 13 00 00       	call   4178 <exit>
    2d80:	83 c4 10             	add    $0x10,%esp
    2d83:	e9 17 ff ff ff       	jmp    2c9f <fourteen+0xbe>

00002d88 <rmdot>:

void
rmdot(void)
{
    2d88:	55                   	push   %ebp
    2d89:	89 e5                	mov    %esp,%ebp
    2d8b:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2d8e:	68 37 51 00 00       	push   $0x5137
    2d93:	6a 01                	push   $0x1
    2d95:	e8 39 15 00 00       	call   42d3 <printf>
  if(mkdir("dots") != 0){
    2d9a:	c7 04 24 43 51 00 00 	movl   $0x5143,(%esp)
    2da1:	e8 3a 14 00 00       	call   41e0 <mkdir>
    2da6:	83 c4 10             	add    $0x10,%esp
    2da9:	85 c0                	test   %eax,%eax
    2dab:	0f 85 bc 00 00 00    	jne    2e6d <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit(0);
  }
  if(chdir("dots") != 0){
    2db1:	83 ec 0c             	sub    $0xc,%esp
    2db4:	68 43 51 00 00       	push   $0x5143
    2db9:	e8 2a 14 00 00       	call   41e8 <chdir>
    2dbe:	83 c4 10             	add    $0x10,%esp
    2dc1:	85 c0                	test   %eax,%eax
    2dc3:	0f 85 c7 00 00 00    	jne    2e90 <rmdot+0x108>
    printf(1, "chdir dots failed\n");
    exit(0);
  }
  if(unlink(".") == 0){
    2dc9:	83 ec 0c             	sub    $0xc,%esp
    2dcc:	68 ee 4d 00 00       	push   $0x4dee
    2dd1:	e8 f2 13 00 00       	call   41c8 <unlink>
    2dd6:	83 c4 10             	add    $0x10,%esp
    2dd9:	85 c0                	test   %eax,%eax
    2ddb:	0f 84 d2 00 00 00    	je     2eb3 <rmdot+0x12b>
    printf(1, "rm . worked!\n");
    exit(0);
  }
  if(unlink("..") == 0){
    2de1:	83 ec 0c             	sub    $0xc,%esp
    2de4:	68 ed 4d 00 00       	push   $0x4ded
    2de9:	e8 da 13 00 00       	call   41c8 <unlink>
    2dee:	83 c4 10             	add    $0x10,%esp
    2df1:	85 c0                	test   %eax,%eax
    2df3:	0f 84 dd 00 00 00    	je     2ed6 <rmdot+0x14e>
    printf(1, "rm .. worked!\n");
    exit(0);
  }
  if(chdir("/") != 0){
    2df9:	83 ec 0c             	sub    $0xc,%esp
    2dfc:	68 c1 45 00 00       	push   $0x45c1
    2e01:	e8 e2 13 00 00       	call   41e8 <chdir>
    2e06:	83 c4 10             	add    $0x10,%esp
    2e09:	85 c0                	test   %eax,%eax
    2e0b:	0f 85 e8 00 00 00    	jne    2ef9 <rmdot+0x171>
    printf(1, "chdir / failed\n");
    exit(0);
  }
  if(unlink("dots/.") == 0){
    2e11:	83 ec 0c             	sub    $0xc,%esp
    2e14:	68 8b 51 00 00       	push   $0x518b
    2e19:	e8 aa 13 00 00       	call   41c8 <unlink>
    2e1e:	83 c4 10             	add    $0x10,%esp
    2e21:	85 c0                	test   %eax,%eax
    2e23:	0f 84 f3 00 00 00    	je     2f1c <rmdot+0x194>
    printf(1, "unlink dots/. worked!\n");
    exit(0);
  }
  if(unlink("dots/..") == 0){
    2e29:	83 ec 0c             	sub    $0xc,%esp
    2e2c:	68 a9 51 00 00       	push   $0x51a9
    2e31:	e8 92 13 00 00       	call   41c8 <unlink>
    2e36:	83 c4 10             	add    $0x10,%esp
    2e39:	85 c0                	test   %eax,%eax
    2e3b:	0f 84 fe 00 00 00    	je     2f3f <rmdot+0x1b7>
    printf(1, "unlink dots/.. worked!\n");
    exit(0);
  }
  if(unlink("dots") != 0){
    2e41:	83 ec 0c             	sub    $0xc,%esp
    2e44:	68 43 51 00 00       	push   $0x5143
    2e49:	e8 7a 13 00 00       	call   41c8 <unlink>
    2e4e:	83 c4 10             	add    $0x10,%esp
    2e51:	85 c0                	test   %eax,%eax
    2e53:	0f 85 09 01 00 00    	jne    2f62 <rmdot+0x1da>
    printf(1, "unlink dots failed!\n");
    exit(0);
  }
  printf(1, "rmdot ok\n");
    2e59:	83 ec 08             	sub    $0x8,%esp
    2e5c:	68 de 51 00 00       	push   $0x51de
    2e61:	6a 01                	push   $0x1
    2e63:	e8 6b 14 00 00       	call   42d3 <printf>
}
    2e68:	83 c4 10             	add    $0x10,%esp
    2e6b:	c9                   	leave  
    2e6c:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2e6d:	83 ec 08             	sub    $0x8,%esp
    2e70:	68 48 51 00 00       	push   $0x5148
    2e75:	6a 01                	push   $0x1
    2e77:	e8 57 14 00 00       	call   42d3 <printf>
    exit(0);
    2e7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e83:	e8 f0 12 00 00       	call   4178 <exit>
    2e88:	83 c4 10             	add    $0x10,%esp
    2e8b:	e9 21 ff ff ff       	jmp    2db1 <rmdot+0x29>
    printf(1, "chdir dots failed\n");
    2e90:	83 ec 08             	sub    $0x8,%esp
    2e93:	68 5b 51 00 00       	push   $0x515b
    2e98:	6a 01                	push   $0x1
    2e9a:	e8 34 14 00 00       	call   42d3 <printf>
    exit(0);
    2e9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ea6:	e8 cd 12 00 00       	call   4178 <exit>
    2eab:	83 c4 10             	add    $0x10,%esp
    2eae:	e9 16 ff ff ff       	jmp    2dc9 <rmdot+0x41>
    printf(1, "rm . worked!\n");
    2eb3:	83 ec 08             	sub    $0x8,%esp
    2eb6:	68 6e 51 00 00       	push   $0x516e
    2ebb:	6a 01                	push   $0x1
    2ebd:	e8 11 14 00 00       	call   42d3 <printf>
    exit(0);
    2ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ec9:	e8 aa 12 00 00       	call   4178 <exit>
    2ece:	83 c4 10             	add    $0x10,%esp
    2ed1:	e9 0b ff ff ff       	jmp    2de1 <rmdot+0x59>
    printf(1, "rm .. worked!\n");
    2ed6:	83 ec 08             	sub    $0x8,%esp
    2ed9:	68 7c 51 00 00       	push   $0x517c
    2ede:	6a 01                	push   $0x1
    2ee0:	e8 ee 13 00 00       	call   42d3 <printf>
    exit(0);
    2ee5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2eec:	e8 87 12 00 00       	call   4178 <exit>
    2ef1:	83 c4 10             	add    $0x10,%esp
    2ef4:	e9 00 ff ff ff       	jmp    2df9 <rmdot+0x71>
    printf(1, "chdir / failed\n");
    2ef9:	83 ec 08             	sub    $0x8,%esp
    2efc:	68 c3 45 00 00       	push   $0x45c3
    2f01:	6a 01                	push   $0x1
    2f03:	e8 cb 13 00 00       	call   42d3 <printf>
    exit(0);
    2f08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f0f:	e8 64 12 00 00       	call   4178 <exit>
    2f14:	83 c4 10             	add    $0x10,%esp
    2f17:	e9 f5 fe ff ff       	jmp    2e11 <rmdot+0x89>
    printf(1, "unlink dots/. worked!\n");
    2f1c:	83 ec 08             	sub    $0x8,%esp
    2f1f:	68 92 51 00 00       	push   $0x5192
    2f24:	6a 01                	push   $0x1
    2f26:	e8 a8 13 00 00       	call   42d3 <printf>
    exit(0);
    2f2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f32:	e8 41 12 00 00       	call   4178 <exit>
    2f37:	83 c4 10             	add    $0x10,%esp
    2f3a:	e9 ea fe ff ff       	jmp    2e29 <rmdot+0xa1>
    printf(1, "unlink dots/.. worked!\n");
    2f3f:	83 ec 08             	sub    $0x8,%esp
    2f42:	68 b1 51 00 00       	push   $0x51b1
    2f47:	6a 01                	push   $0x1
    2f49:	e8 85 13 00 00       	call   42d3 <printf>
    exit(0);
    2f4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f55:	e8 1e 12 00 00       	call   4178 <exit>
    2f5a:	83 c4 10             	add    $0x10,%esp
    2f5d:	e9 df fe ff ff       	jmp    2e41 <rmdot+0xb9>
    printf(1, "unlink dots failed!\n");
    2f62:	83 ec 08             	sub    $0x8,%esp
    2f65:	68 c9 51 00 00       	push   $0x51c9
    2f6a:	6a 01                	push   $0x1
    2f6c:	e8 62 13 00 00       	call   42d3 <printf>
    exit(0);
    2f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f78:	e8 fb 11 00 00       	call   4178 <exit>
    2f7d:	83 c4 10             	add    $0x10,%esp
    2f80:	e9 d4 fe ff ff       	jmp    2e59 <rmdot+0xd1>

00002f85 <dirfile>:

void
dirfile(void)
{
    2f85:	55                   	push   %ebp
    2f86:	89 e5                	mov    %esp,%ebp
    2f88:	53                   	push   %ebx
    2f89:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2f8c:	68 e8 51 00 00       	push   $0x51e8
    2f91:	6a 01                	push   $0x1
    2f93:	e8 3b 13 00 00       	call   42d3 <printf>

  fd = open("dirfile", O_CREATE);
    2f98:	83 c4 08             	add    $0x8,%esp
    2f9b:	68 00 02 00 00       	push   $0x200
    2fa0:	68 f5 51 00 00       	push   $0x51f5
    2fa5:	e8 0e 12 00 00       	call   41b8 <open>
    2faa:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2fac:	83 c4 10             	add    $0x10,%esp
    2faf:	85 c0                	test   %eax,%eax
    2fb1:	0f 88 22 01 00 00    	js     30d9 <dirfile+0x154>
    printf(1, "create dirfile failed\n");
    exit(0);
  }
  close(fd);
    2fb7:	83 ec 0c             	sub    $0xc,%esp
    2fba:	53                   	push   %ebx
    2fbb:	e8 e0 11 00 00       	call   41a0 <close>
  if(chdir("dirfile") == 0){
    2fc0:	c7 04 24 f5 51 00 00 	movl   $0x51f5,(%esp)
    2fc7:	e8 1c 12 00 00       	call   41e8 <chdir>
    2fcc:	83 c4 10             	add    $0x10,%esp
    2fcf:	85 c0                	test   %eax,%eax
    2fd1:	0f 84 25 01 00 00    	je     30fc <dirfile+0x177>
    printf(1, "chdir dirfile succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", 0);
    2fd7:	83 ec 08             	sub    $0x8,%esp
    2fda:	6a 00                	push   $0x0
    2fdc:	68 2e 52 00 00       	push   $0x522e
    2fe1:	e8 d2 11 00 00       	call   41b8 <open>
  if(fd >= 0){
    2fe6:	83 c4 10             	add    $0x10,%esp
    2fe9:	85 c0                	test   %eax,%eax
    2feb:	0f 89 2e 01 00 00    	jns    311f <dirfile+0x19a>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", O_CREATE);
    2ff1:	83 ec 08             	sub    $0x8,%esp
    2ff4:	68 00 02 00 00       	push   $0x200
    2ff9:	68 2e 52 00 00       	push   $0x522e
    2ffe:	e8 b5 11 00 00       	call   41b8 <open>
  if(fd >= 0){
    3003:	83 c4 10             	add    $0x10,%esp
    3006:	85 c0                	test   %eax,%eax
    3008:	0f 89 34 01 00 00    	jns    3142 <dirfile+0x1bd>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  if(mkdir("dirfile/xx") == 0){
    300e:	83 ec 0c             	sub    $0xc,%esp
    3011:	68 2e 52 00 00       	push   $0x522e
    3016:	e8 c5 11 00 00       	call   41e0 <mkdir>
    301b:	83 c4 10             	add    $0x10,%esp
    301e:	85 c0                	test   %eax,%eax
    3020:	0f 84 3f 01 00 00    	je     3165 <dirfile+0x1e0>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile/xx") == 0){
    3026:	83 ec 0c             	sub    $0xc,%esp
    3029:	68 2e 52 00 00       	push   $0x522e
    302e:	e8 95 11 00 00       	call   41c8 <unlink>
    3033:	83 c4 10             	add    $0x10,%esp
    3036:	85 c0                	test   %eax,%eax
    3038:	0f 84 4a 01 00 00    	je     3188 <dirfile+0x203>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit(0);
  }
  if(link("README", "dirfile/xx") == 0){
    303e:	83 ec 08             	sub    $0x8,%esp
    3041:	68 2e 52 00 00       	push   $0x522e
    3046:	68 92 52 00 00       	push   $0x5292
    304b:	e8 88 11 00 00       	call   41d8 <link>
    3050:	83 c4 10             	add    $0x10,%esp
    3053:	85 c0                	test   %eax,%eax
    3055:	0f 84 50 01 00 00    	je     31ab <dirfile+0x226>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile") != 0){
    305b:	83 ec 0c             	sub    $0xc,%esp
    305e:	68 f5 51 00 00       	push   $0x51f5
    3063:	e8 60 11 00 00       	call   41c8 <unlink>
    3068:	83 c4 10             	add    $0x10,%esp
    306b:	85 c0                	test   %eax,%eax
    306d:	0f 85 5b 01 00 00    	jne    31ce <dirfile+0x249>
    printf(1, "unlink dirfile failed!\n");
    exit(0);
  }

  fd = open(".", O_RDWR);
    3073:	83 ec 08             	sub    $0x8,%esp
    3076:	6a 02                	push   $0x2
    3078:	68 ee 4d 00 00       	push   $0x4dee
    307d:	e8 36 11 00 00       	call   41b8 <open>
  if(fd >= 0){
    3082:	83 c4 10             	add    $0x10,%esp
    3085:	85 c0                	test   %eax,%eax
    3087:	0f 89 64 01 00 00    	jns    31f1 <dirfile+0x26c>
    printf(1, "open . for writing succeeded!\n");
    exit(0);
  }
  fd = open(".", 0);
    308d:	83 ec 08             	sub    $0x8,%esp
    3090:	6a 00                	push   $0x0
    3092:	68 ee 4d 00 00       	push   $0x4dee
    3097:	e8 1c 11 00 00       	call   41b8 <open>
    309c:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    309e:	83 c4 0c             	add    $0xc,%esp
    30a1:	6a 01                	push   $0x1
    30a3:	68 d1 4e 00 00       	push   $0x4ed1
    30a8:	50                   	push   %eax
    30a9:	e8 ea 10 00 00       	call   4198 <write>
    30ae:	83 c4 10             	add    $0x10,%esp
    30b1:	85 c0                	test   %eax,%eax
    30b3:	0f 8f 5b 01 00 00    	jg     3214 <dirfile+0x28f>
    printf(1, "write . succeeded!\n");
    exit(0);
  }
  close(fd);
    30b9:	83 ec 0c             	sub    $0xc,%esp
    30bc:	53                   	push   %ebx
    30bd:	e8 de 10 00 00       	call   41a0 <close>

  printf(1, "dir vs file OK\n");
    30c2:	83 c4 08             	add    $0x8,%esp
    30c5:	68 c5 52 00 00       	push   $0x52c5
    30ca:	6a 01                	push   $0x1
    30cc:	e8 02 12 00 00       	call   42d3 <printf>
}
    30d1:	83 c4 10             	add    $0x10,%esp
    30d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    30d7:	c9                   	leave  
    30d8:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    30d9:	83 ec 08             	sub    $0x8,%esp
    30dc:	68 fd 51 00 00       	push   $0x51fd
    30e1:	6a 01                	push   $0x1
    30e3:	e8 eb 11 00 00       	call   42d3 <printf>
    exit(0);
    30e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30ef:	e8 84 10 00 00       	call   4178 <exit>
    30f4:	83 c4 10             	add    $0x10,%esp
    30f7:	e9 bb fe ff ff       	jmp    2fb7 <dirfile+0x32>
    printf(1, "chdir dirfile succeeded!\n");
    30fc:	83 ec 08             	sub    $0x8,%esp
    30ff:	68 14 52 00 00       	push   $0x5214
    3104:	6a 01                	push   $0x1
    3106:	e8 c8 11 00 00       	call   42d3 <printf>
    exit(0);
    310b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3112:	e8 61 10 00 00       	call   4178 <exit>
    3117:	83 c4 10             	add    $0x10,%esp
    311a:	e9 b8 fe ff ff       	jmp    2fd7 <dirfile+0x52>
    printf(1, "create dirfile/xx succeeded!\n");
    311f:	83 ec 08             	sub    $0x8,%esp
    3122:	68 39 52 00 00       	push   $0x5239
    3127:	6a 01                	push   $0x1
    3129:	e8 a5 11 00 00       	call   42d3 <printf>
    exit(0);
    312e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3135:	e8 3e 10 00 00       	call   4178 <exit>
    313a:	83 c4 10             	add    $0x10,%esp
    313d:	e9 af fe ff ff       	jmp    2ff1 <dirfile+0x6c>
    printf(1, "create dirfile/xx succeeded!\n");
    3142:	83 ec 08             	sub    $0x8,%esp
    3145:	68 39 52 00 00       	push   $0x5239
    314a:	6a 01                	push   $0x1
    314c:	e8 82 11 00 00       	call   42d3 <printf>
    exit(0);
    3151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3158:	e8 1b 10 00 00       	call   4178 <exit>
    315d:	83 c4 10             	add    $0x10,%esp
    3160:	e9 a9 fe ff ff       	jmp    300e <dirfile+0x89>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    3165:	83 ec 08             	sub    $0x8,%esp
    3168:	68 57 52 00 00       	push   $0x5257
    316d:	6a 01                	push   $0x1
    316f:	e8 5f 11 00 00       	call   42d3 <printf>
    exit(0);
    3174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    317b:	e8 f8 0f 00 00       	call   4178 <exit>
    3180:	83 c4 10             	add    $0x10,%esp
    3183:	e9 9e fe ff ff       	jmp    3026 <dirfile+0xa1>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3188:	83 ec 08             	sub    $0x8,%esp
    318b:	68 74 52 00 00       	push   $0x5274
    3190:	6a 01                	push   $0x1
    3192:	e8 3c 11 00 00       	call   42d3 <printf>
    exit(0);
    3197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    319e:	e8 d5 0f 00 00       	call   4178 <exit>
    31a3:	83 c4 10             	add    $0x10,%esp
    31a6:	e9 93 fe ff ff       	jmp    303e <dirfile+0xb9>
    printf(1, "link to dirfile/xx succeeded!\n");
    31ab:	83 ec 08             	sub    $0x8,%esp
    31ae:	68 88 5a 00 00       	push   $0x5a88
    31b3:	6a 01                	push   $0x1
    31b5:	e8 19 11 00 00       	call   42d3 <printf>
    exit(0);
    31ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31c1:	e8 b2 0f 00 00       	call   4178 <exit>
    31c6:	83 c4 10             	add    $0x10,%esp
    31c9:	e9 8d fe ff ff       	jmp    305b <dirfile+0xd6>
    printf(1, "unlink dirfile failed!\n");
    31ce:	83 ec 08             	sub    $0x8,%esp
    31d1:	68 99 52 00 00       	push   $0x5299
    31d6:	6a 01                	push   $0x1
    31d8:	e8 f6 10 00 00       	call   42d3 <printf>
    exit(0);
    31dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31e4:	e8 8f 0f 00 00       	call   4178 <exit>
    31e9:	83 c4 10             	add    $0x10,%esp
    31ec:	e9 82 fe ff ff       	jmp    3073 <dirfile+0xee>
    printf(1, "open . for writing succeeded!\n");
    31f1:	83 ec 08             	sub    $0x8,%esp
    31f4:	68 a8 5a 00 00       	push   $0x5aa8
    31f9:	6a 01                	push   $0x1
    31fb:	e8 d3 10 00 00       	call   42d3 <printf>
    exit(0);
    3200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3207:	e8 6c 0f 00 00       	call   4178 <exit>
    320c:	83 c4 10             	add    $0x10,%esp
    320f:	e9 79 fe ff ff       	jmp    308d <dirfile+0x108>
    printf(1, "write . succeeded!\n");
    3214:	83 ec 08             	sub    $0x8,%esp
    3217:	68 b1 52 00 00       	push   $0x52b1
    321c:	6a 01                	push   $0x1
    321e:	e8 b0 10 00 00       	call   42d3 <printf>
    exit(0);
    3223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    322a:	e8 49 0f 00 00       	call   4178 <exit>
    322f:	83 c4 10             	add    $0x10,%esp
    3232:	e9 82 fe ff ff       	jmp    30b9 <dirfile+0x134>

00003237 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    3237:	55                   	push   %ebp
    3238:	89 e5                	mov    %esp,%ebp
    323a:	53                   	push   %ebx
    323b:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    323e:	68 d5 52 00 00       	push   $0x52d5
    3243:	6a 01                	push   $0x1
    3245:	e8 89 10 00 00       	call   42d3 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    324a:	83 c4 10             	add    $0x10,%esp
    324d:	bb 00 00 00 00       	mov    $0x0,%ebx
    3252:	eb 5f                	jmp    32b3 <iref+0x7c>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    3254:	83 ec 08             	sub    $0x8,%esp
    3257:	68 ec 52 00 00       	push   $0x52ec
    325c:	6a 01                	push   $0x1
    325e:	e8 70 10 00 00       	call   42d3 <printf>
      exit(0);
    3263:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    326a:	e8 09 0f 00 00       	call   4178 <exit>
    326f:	83 c4 10             	add    $0x10,%esp
    3272:	eb 5c                	jmp    32d0 <iref+0x99>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    3274:	83 ec 08             	sub    $0x8,%esp
    3277:	68 00 53 00 00       	push   $0x5300
    327c:	6a 01                	push   $0x1
    327e:	e8 50 10 00 00       	call   42d3 <printf>
      exit(0);
    3283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    328a:	e8 e9 0e 00 00       	call   4178 <exit>
    328f:	83 c4 10             	add    $0x10,%esp
    3292:	eb 50                	jmp    32e4 <iref+0xad>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    3294:	83 ec 0c             	sub    $0xc,%esp
    3297:	50                   	push   %eax
    3298:	e8 03 0f 00 00       	call   41a0 <close>
    329d:	83 c4 10             	add    $0x10,%esp
    32a0:	eb 7e                	jmp    3320 <iref+0xe9>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    32a2:	83 ec 0c             	sub    $0xc,%esp
    32a5:	68 d0 4e 00 00       	push   $0x4ed0
    32aa:	e8 19 0f 00 00       	call   41c8 <unlink>
  for(i = 0; i < 50 + 1; i++){
    32af:	43                   	inc    %ebx
    32b0:	83 c4 10             	add    $0x10,%esp
    32b3:	83 fb 32             	cmp    $0x32,%ebx
    32b6:	0f 8f 92 00 00 00    	jg     334e <iref+0x117>
    if(mkdir("irefd") != 0){
    32bc:	83 ec 0c             	sub    $0xc,%esp
    32bf:	68 e6 52 00 00       	push   $0x52e6
    32c4:	e8 17 0f 00 00       	call   41e0 <mkdir>
    32c9:	83 c4 10             	add    $0x10,%esp
    32cc:	85 c0                	test   %eax,%eax
    32ce:	75 84                	jne    3254 <iref+0x1d>
    if(chdir("irefd") != 0){
    32d0:	83 ec 0c             	sub    $0xc,%esp
    32d3:	68 e6 52 00 00       	push   $0x52e6
    32d8:	e8 0b 0f 00 00       	call   41e8 <chdir>
    32dd:	83 c4 10             	add    $0x10,%esp
    32e0:	85 c0                	test   %eax,%eax
    32e2:	75 90                	jne    3274 <iref+0x3d>
    mkdir("");
    32e4:	83 ec 0c             	sub    $0xc,%esp
    32e7:	68 9b 49 00 00       	push   $0x499b
    32ec:	e8 ef 0e 00 00       	call   41e0 <mkdir>
    link("README", "");
    32f1:	83 c4 08             	add    $0x8,%esp
    32f4:	68 9b 49 00 00       	push   $0x499b
    32f9:	68 92 52 00 00       	push   $0x5292
    32fe:	e8 d5 0e 00 00       	call   41d8 <link>
    fd = open("", O_CREATE);
    3303:	83 c4 08             	add    $0x8,%esp
    3306:	68 00 02 00 00       	push   $0x200
    330b:	68 9b 49 00 00       	push   $0x499b
    3310:	e8 a3 0e 00 00       	call   41b8 <open>
    if(fd >= 0)
    3315:	83 c4 10             	add    $0x10,%esp
    3318:	85 c0                	test   %eax,%eax
    331a:	0f 89 74 ff ff ff    	jns    3294 <iref+0x5d>
    fd = open("xx", O_CREATE);
    3320:	83 ec 08             	sub    $0x8,%esp
    3323:	68 00 02 00 00       	push   $0x200
    3328:	68 d0 4e 00 00       	push   $0x4ed0
    332d:	e8 86 0e 00 00       	call   41b8 <open>
    if(fd >= 0)
    3332:	83 c4 10             	add    $0x10,%esp
    3335:	85 c0                	test   %eax,%eax
    3337:	0f 88 65 ff ff ff    	js     32a2 <iref+0x6b>
      close(fd);
    333d:	83 ec 0c             	sub    $0xc,%esp
    3340:	50                   	push   %eax
    3341:	e8 5a 0e 00 00       	call   41a0 <close>
    3346:	83 c4 10             	add    $0x10,%esp
    3349:	e9 54 ff ff ff       	jmp    32a2 <iref+0x6b>
  }

  chdir("/");
    334e:	83 ec 0c             	sub    $0xc,%esp
    3351:	68 c1 45 00 00       	push   $0x45c1
    3356:	e8 8d 0e 00 00       	call   41e8 <chdir>
  printf(1, "empty file name OK\n");
    335b:	83 c4 08             	add    $0x8,%esp
    335e:	68 14 53 00 00       	push   $0x5314
    3363:	6a 01                	push   $0x1
    3365:	e8 69 0f 00 00       	call   42d3 <printf>
}
    336a:	83 c4 10             	add    $0x10,%esp
    336d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3370:	c9                   	leave  
    3371:	c3                   	ret    

00003372 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3372:	55                   	push   %ebp
    3373:	89 e5                	mov    %esp,%ebp
    3375:	53                   	push   %ebx
    3376:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    3379:	68 28 53 00 00       	push   $0x5328
    337e:	6a 01                	push   $0x1
    3380:	e8 4e 0f 00 00       	call   42d3 <printf>

  for(n=0; n<1000; n++){
    3385:	83 c4 10             	add    $0x10,%esp
    3388:	bb 00 00 00 00       	mov    $0x0,%ebx
    338d:	eb 01                	jmp    3390 <forktest+0x1e>
    338f:	43                   	inc    %ebx
    3390:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    3396:	7f 1a                	jg     33b2 <forktest+0x40>
    pid = fork();
    3398:	e8 d3 0d 00 00       	call   4170 <fork>
    if(pid < 0)
    339d:	85 c0                	test   %eax,%eax
    339f:	78 11                	js     33b2 <forktest+0x40>
      break;
    if(pid == 0)
    33a1:	75 ec                	jne    338f <forktest+0x1d>
      exit(0);
    33a3:	83 ec 0c             	sub    $0xc,%esp
    33a6:	6a 00                	push   $0x0
    33a8:	e8 cb 0d 00 00       	call   4178 <exit>
    33ad:	83 c4 10             	add    $0x10,%esp
    33b0:	eb dd                	jmp    338f <forktest+0x1d>
  }

  if(n == 1000){
    33b2:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    33b8:	75 21                	jne    33db <forktest+0x69>
    printf(1, "fork claimed to work 1000 times!\n");
    33ba:	83 ec 08             	sub    $0x8,%esp
    33bd:	68 c8 5a 00 00       	push   $0x5ac8
    33c2:	6a 01                	push   $0x1
    33c4:	e8 0a 0f 00 00       	call   42d3 <printf>
    exit(0);
    33c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33d0:	e8 a3 0d 00 00       	call   4178 <exit>
    33d5:	83 c4 10             	add    $0x10,%esp
    33d8:	eb 01                	jmp    33db <forktest+0x69>
  }

  for(; n > 0; n--){
    33da:	4b                   	dec    %ebx
    33db:	85 db                	test   %ebx,%ebx
    33dd:	7e 31                	jle    3410 <forktest+0x9e>
    if(wait(NULL) < 0){
    33df:	83 ec 0c             	sub    $0xc,%esp
    33e2:	6a 00                	push   $0x0
    33e4:	e8 97 0d 00 00       	call   4180 <wait>
    33e9:	83 c4 10             	add    $0x10,%esp
    33ec:	85 c0                	test   %eax,%eax
    33ee:	79 ea                	jns    33da <forktest+0x68>
      printf(1, "wait stopped early\n");
    33f0:	83 ec 08             	sub    $0x8,%esp
    33f3:	68 33 53 00 00       	push   $0x5333
    33f8:	6a 01                	push   $0x1
    33fa:	e8 d4 0e 00 00       	call   42d3 <printf>
      exit(0);
    33ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3406:	e8 6d 0d 00 00       	call   4178 <exit>
    340b:	83 c4 10             	add    $0x10,%esp
    340e:	eb ca                	jmp    33da <forktest+0x68>
    }
  }

  if(wait(NULL) != -1){
    3410:	83 ec 0c             	sub    $0xc,%esp
    3413:	6a 00                	push   $0x0
    3415:	e8 66 0d 00 00       	call   4180 <wait>
    341a:	83 c4 10             	add    $0x10,%esp
    341d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3420:	75 17                	jne    3439 <forktest+0xc7>
    printf(1, "wait got too many\n");
    exit(0);
  }

  printf(1, "fork test OK\n");
    3422:	83 ec 08             	sub    $0x8,%esp
    3425:	68 5a 53 00 00       	push   $0x535a
    342a:	6a 01                	push   $0x1
    342c:	e8 a2 0e 00 00       	call   42d3 <printf>
}
    3431:	83 c4 10             	add    $0x10,%esp
    3434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3437:	c9                   	leave  
    3438:	c3                   	ret    
    printf(1, "wait got too many\n");
    3439:	83 ec 08             	sub    $0x8,%esp
    343c:	68 47 53 00 00       	push   $0x5347
    3441:	6a 01                	push   $0x1
    3443:	e8 8b 0e 00 00       	call   42d3 <printf>
    exit(0);
    3448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    344f:	e8 24 0d 00 00       	call   4178 <exit>
    3454:	83 c4 10             	add    $0x10,%esp
    3457:	eb c9                	jmp    3422 <forktest+0xb0>

00003459 <sbrktest>:

void
sbrktest(void)
{
    3459:	55                   	push   %ebp
    345a:	89 e5                	mov    %esp,%ebp
    345c:	57                   	push   %edi
    345d:	56                   	push   %esi
    345e:	53                   	push   %ebx
    345f:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3462:	68 68 53 00 00       	push   $0x5368
    3467:	ff 35 50 66 00 00    	push   0x6650
    346d:	e8 61 0e 00 00       	call   42d3 <printf>
  oldbrk = sbrk(0);
    3472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3479:	e8 82 0d 00 00       	call   4200 <sbrk>
    347e:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3481:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3488:	e8 73 0d 00 00       	call   4200 <sbrk>
    348d:	89 c7                	mov    %eax,%edi
  int i;
  for(i = 0; i < 5000; i++){
    348f:	83 c4 10             	add    $0x10,%esp
    3492:	be 00 00 00 00       	mov    $0x0,%esi
    3497:	eb 07                	jmp    34a0 <sbrktest+0x47>
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit(0);
    }
    *b = 1;
    3499:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    349c:	8d 7b 01             	lea    0x1(%ebx),%edi
  for(i = 0; i < 5000; i++){
    349f:	46                   	inc    %esi
    34a0:	81 fe 87 13 00 00    	cmp    $0x1387,%esi
    34a6:	7f 38                	jg     34e0 <sbrktest+0x87>
    b = sbrk(1);
    34a8:	83 ec 0c             	sub    $0xc,%esp
    34ab:	6a 01                	push   $0x1
    34ad:	e8 4e 0d 00 00       	call   4200 <sbrk>
    34b2:	89 c3                	mov    %eax,%ebx
    if(b != a){
    34b4:	83 c4 10             	add    $0x10,%esp
    34b7:	39 c7                	cmp    %eax,%edi
    34b9:	74 de                	je     3499 <sbrktest+0x40>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    34bb:	83 ec 0c             	sub    $0xc,%esp
    34be:	50                   	push   %eax
    34bf:	57                   	push   %edi
    34c0:	56                   	push   %esi
    34c1:	68 73 53 00 00       	push   $0x5373
    34c6:	ff 35 50 66 00 00    	push   0x6650
    34cc:	e8 02 0e 00 00       	call   42d3 <printf>
      exit(0);
    34d1:	83 c4 14             	add    $0x14,%esp
    34d4:	6a 00                	push   $0x0
    34d6:	e8 9d 0c 00 00       	call   4178 <exit>
    34db:	83 c4 10             	add    $0x10,%esp
    34de:	eb b9                	jmp    3499 <sbrktest+0x40>
  }
  pid = fork();
    34e0:	e8 8b 0c 00 00       	call   4170 <fork>
    34e5:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    34e7:	85 c0                	test   %eax,%eax
    34e9:	0f 88 a7 01 00 00    	js     3696 <sbrktest+0x23d>
    printf(stdout, "sbrk test fork failed\n");
    exit(0);
  }
  c = sbrk(1);
    34ef:	83 ec 0c             	sub    $0xc,%esp
    34f2:	6a 01                	push   $0x1
    34f4:	e8 07 0d 00 00       	call   4200 <sbrk>
  c = sbrk(1);
    34f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3500:	e8 fb 0c 00 00       	call   4200 <sbrk>
  if(c != a + 1){
    3505:	47                   	inc    %edi
    3506:	83 c4 10             	add    $0x10,%esp
    3509:	39 c7                	cmp    %eax,%edi
    350b:	74 22                	je     352f <sbrktest+0xd6>
    printf(stdout, "sbrk test failed post-fork\n");
    350d:	83 ec 08             	sub    $0x8,%esp
    3510:	68 a5 53 00 00       	push   $0x53a5
    3515:	ff 35 50 66 00 00    	push   0x6650
    351b:	e8 b3 0d 00 00       	call   42d3 <printf>
    exit(0);
    3520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3527:	e8 4c 0c 00 00       	call   4178 <exit>
    352c:	83 c4 10             	add    $0x10,%esp
  }
  if(pid == 0)
    352f:	85 db                	test   %ebx,%ebx
    3531:	0f 84 86 01 00 00    	je     36bd <sbrktest+0x264>
    exit(0);
  wait(NULL);
    3537:	83 ec 0c             	sub    $0xc,%esp
    353a:	6a 00                	push   $0x0
    353c:	e8 3f 0c 00 00       	call   4180 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3541:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3548:	e8 b3 0c 00 00       	call   4200 <sbrk>
    354d:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    354f:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3554:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    3556:	89 04 24             	mov    %eax,(%esp)
    3559:	e8 a2 0c 00 00       	call   4200 <sbrk>
  if (p != a) {
    355e:	83 c4 10             	add    $0x10,%esp
    3561:	39 c3                	cmp    %eax,%ebx
    3563:	74 22                	je     3587 <sbrktest+0x12e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3565:	83 ec 08             	sub    $0x8,%esp
    3568:	68 ec 5a 00 00       	push   $0x5aec
    356d:	ff 35 50 66 00 00    	push   0x6650
    3573:	e8 5b 0d 00 00       	call   42d3 <printf>
    exit(0);
    3578:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    357f:	e8 f4 0b 00 00       	call   4178 <exit>
    3584:	83 c4 10             	add    $0x10,%esp
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3587:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    358e:	83 ec 0c             	sub    $0xc,%esp
    3591:	6a 00                	push   $0x0
    3593:	e8 68 0c 00 00       	call   4200 <sbrk>
    3598:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    359a:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    35a1:	e8 5a 0c 00 00       	call   4200 <sbrk>
  if(c == (char*)0xffffffff){
    35a6:	83 c4 10             	add    $0x10,%esp
    35a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    35ac:	0f 84 1d 01 00 00    	je     36cf <sbrktest+0x276>
    printf(stdout, "sbrk could not deallocate\n");
    exit(0);
  }
  c = sbrk(0);
    35b2:	83 ec 0c             	sub    $0xc,%esp
    35b5:	6a 00                	push   $0x0
    35b7:	e8 44 0c 00 00       	call   4200 <sbrk>
  if(c != a - 4096){
    35bc:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    35c2:	83 c4 10             	add    $0x10,%esp
    35c5:	39 c2                	cmp    %eax,%edx
    35c7:	74 21                	je     35ea <sbrktest+0x191>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    35c9:	50                   	push   %eax
    35ca:	53                   	push   %ebx
    35cb:	68 2c 5b 00 00       	push   $0x5b2c
    35d0:	ff 35 50 66 00 00    	push   0x6650
    35d6:	e8 f8 0c 00 00       	call   42d3 <printf>
    exit(0);
    35db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35e2:	e8 91 0b 00 00       	call   4178 <exit>
    35e7:	83 c4 10             	add    $0x10,%esp
  }

  // can one re-allocate that page?
  a = sbrk(0);
    35ea:	83 ec 0c             	sub    $0xc,%esp
    35ed:	6a 00                	push   $0x0
    35ef:	e8 0c 0c 00 00       	call   4200 <sbrk>
    35f4:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    35f6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    35fd:	e8 fe 0b 00 00       	call   4200 <sbrk>
    3602:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    3604:	83 c4 10             	add    $0x10,%esp
    3607:	39 c3                	cmp    %eax,%ebx
    3609:	0f 84 e7 00 00 00    	je     36f6 <sbrktest+0x29d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    360f:	56                   	push   %esi
    3610:	53                   	push   %ebx
    3611:	68 64 5b 00 00       	push   $0x5b64
    3616:	ff 35 50 66 00 00    	push   0x6650
    361c:	e8 b2 0c 00 00       	call   42d3 <printf>
    exit(0);
    3621:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3628:	e8 4b 0b 00 00       	call   4178 <exit>
    362d:	83 c4 10             	add    $0x10,%esp
  }
  if(*lastaddr == 99){
    3630:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    3637:	0f 84 d9 00 00 00    	je     3716 <sbrktest+0x2bd>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit(0);
  }

  a = sbrk(0);
    363d:	83 ec 0c             	sub    $0xc,%esp
    3640:	6a 00                	push   $0x0
    3642:	e8 b9 0b 00 00       	call   4200 <sbrk>
    3647:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    3649:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3650:	e8 ab 0b 00 00       	call   4200 <sbrk>
    3655:	89 c2                	mov    %eax,%edx
    3657:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    365a:	29 d0                	sub    %edx,%eax
    365c:	89 04 24             	mov    %eax,(%esp)
    365f:	e8 9c 0b 00 00       	call   4200 <sbrk>
  if(c != a){
    3664:	83 c4 10             	add    $0x10,%esp
    3667:	39 c3                	cmp    %eax,%ebx
    3669:	74 21                	je     368c <sbrktest+0x233>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    366b:	50                   	push   %eax
    366c:	53                   	push   %ebx
    366d:	68 bc 5b 00 00       	push   $0x5bbc
    3672:	ff 35 50 66 00 00    	push   0x6650
    3678:	e8 56 0c 00 00       	call   42d3 <printf>
    exit(0);
    367d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3684:	e8 ef 0a 00 00       	call   4178 <exit>
    3689:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 5000; i++){
    368c:	be 00 00 00 80       	mov    $0x80000000,%esi
    3691:	e9 de 00 00 00       	jmp    3774 <sbrktest+0x31b>
    printf(stdout, "sbrk test fork failed\n");
    3696:	83 ec 08             	sub    $0x8,%esp
    3699:	68 8e 53 00 00       	push   $0x538e
    369e:	ff 35 50 66 00 00    	push   0x6650
    36a4:	e8 2a 0c 00 00       	call   42d3 <printf>
    exit(0);
    36a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36b0:	e8 c3 0a 00 00       	call   4178 <exit>
    36b5:	83 c4 10             	add    $0x10,%esp
    36b8:	e9 32 fe ff ff       	jmp    34ef <sbrktest+0x96>
    exit(0);
    36bd:	83 ec 0c             	sub    $0xc,%esp
    36c0:	6a 00                	push   $0x0
    36c2:	e8 b1 0a 00 00       	call   4178 <exit>
    36c7:	83 c4 10             	add    $0x10,%esp
    36ca:	e9 68 fe ff ff       	jmp    3537 <sbrktest+0xde>
    printf(stdout, "sbrk could not deallocate\n");
    36cf:	83 ec 08             	sub    $0x8,%esp
    36d2:	68 c1 53 00 00       	push   $0x53c1
    36d7:	ff 35 50 66 00 00    	push   0x6650
    36dd:	e8 f1 0b 00 00       	call   42d3 <printf>
    exit(0);
    36e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36e9:	e8 8a 0a 00 00       	call   4178 <exit>
    36ee:	83 c4 10             	add    $0x10,%esp
    36f1:	e9 bc fe ff ff       	jmp    35b2 <sbrktest+0x159>
  if(c != a || sbrk(0) != a + 4096){
    36f6:	83 ec 0c             	sub    $0xc,%esp
    36f9:	6a 00                	push   $0x0
    36fb:	e8 00 0b 00 00       	call   4200 <sbrk>
    3700:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    3706:	83 c4 10             	add    $0x10,%esp
    3709:	39 c2                	cmp    %eax,%edx
    370b:	0f 85 fe fe ff ff    	jne    360f <sbrktest+0x1b6>
    3711:	e9 1a ff ff ff       	jmp    3630 <sbrktest+0x1d7>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3716:	83 ec 08             	sub    $0x8,%esp
    3719:	68 8c 5b 00 00       	push   $0x5b8c
    371e:	ff 35 50 66 00 00    	push   0x6650
    3724:	e8 aa 0b 00 00       	call   42d3 <printf>
    exit(0);
    3729:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3730:	e8 43 0a 00 00       	call   4178 <exit>
    3735:	83 c4 10             	add    $0x10,%esp
    3738:	e9 00 ff ff ff       	jmp    363d <sbrktest+0x1e4>
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    pid = fork();
    if(pid < 0){
      printf(stdout, "fork failed\n");
    373d:	83 ec 08             	sub    $0x8,%esp
    3740:	68 b9 54 00 00       	push   $0x54b9
    3745:	ff 35 50 66 00 00    	push   0x6650
    374b:	e8 83 0b 00 00       	call   42d3 <printf>
      exit(0);
    3750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3757:	e8 1c 0a 00 00       	call   4178 <exit>
    375c:	83 c4 10             	add    $0x10,%esp
    375f:	eb 2d                	jmp    378e <sbrktest+0x335>
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit(0);
    }
    wait(NULL);
    3761:	83 ec 0c             	sub    $0xc,%esp
    3764:	6a 00                	push   $0x0
    3766:	e8 15 0a 00 00       	call   4180 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    376b:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    3771:	83 c4 10             	add    $0x10,%esp
    3774:	81 fe 7f 84 1e 80    	cmp    $0x801e847f,%esi
    377a:	77 44                	ja     37c0 <sbrktest+0x367>
    ppid = getpid();
    377c:	e8 77 0a 00 00       	call   41f8 <getpid>
    3781:	89 c7                	mov    %eax,%edi
    pid = fork();
    3783:	e8 e8 09 00 00       	call   4170 <fork>
    3788:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    378a:	85 c0                	test   %eax,%eax
    378c:	78 af                	js     373d <sbrktest+0x2e4>
    if(pid == 0){
    378e:	85 db                	test   %ebx,%ebx
    3790:	75 cf                	jne    3761 <sbrktest+0x308>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3792:	0f be 06             	movsbl (%esi),%eax
    3795:	50                   	push   %eax
    3796:	56                   	push   %esi
    3797:	68 dc 53 00 00       	push   $0x53dc
    379c:	ff 35 50 66 00 00    	push   0x6650
    37a2:	e8 2c 0b 00 00       	call   42d3 <printf>
      kill(ppid);
    37a7:	89 3c 24             	mov    %edi,(%esp)
    37aa:	e8 f9 09 00 00       	call   41a8 <kill>
      exit(0);
    37af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    37b6:	e8 bd 09 00 00       	call   4178 <exit>
    37bb:	83 c4 10             	add    $0x10,%esp
    37be:	eb a1                	jmp    3761 <sbrktest+0x308>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    37c0:	83 ec 0c             	sub    $0xc,%esp
    37c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
    37c6:	50                   	push   %eax
    37c7:	e8 bc 09 00 00       	call   4188 <pipe>
    37cc:	83 c4 10             	add    $0x10,%esp
    37cf:	85 c0                	test   %eax,%eax
    37d1:	75 07                	jne    37da <sbrktest+0x381>
  for(i = 0; i < 5000; i++){
    37d3:	bb 00 00 00 00       	mov    $0x0,%ebx
    37d8:	eb 63                	jmp    383d <sbrktest+0x3e4>
    printf(1, "pipe() failed\n");
    37da:	83 ec 08             	sub    $0x8,%esp
    37dd:	68 b1 48 00 00       	push   $0x48b1
    37e2:	6a 01                	push   $0x1
    37e4:	e8 ea 0a 00 00       	call   42d3 <printf>
    exit(0);
    37e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    37f0:	e8 83 09 00 00       	call   4178 <exit>
    37f5:	83 c4 10             	add    $0x10,%esp
    37f8:	eb d9                	jmp    37d3 <sbrktest+0x37a>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    37fa:	83 ec 0c             	sub    $0xc,%esp
    37fd:	6a 00                	push   $0x0
    37ff:	e8 fc 09 00 00       	call   4200 <sbrk>
    3804:	89 c2                	mov    %eax,%edx
    3806:	b8 00 00 40 06       	mov    $0x6400000,%eax
    380b:	29 d0                	sub    %edx,%eax
    380d:	89 04 24             	mov    %eax,(%esp)
    3810:	e8 eb 09 00 00       	call   4200 <sbrk>
      write(fds[1], "x", 1);
    3815:	83 c4 0c             	add    $0xc,%esp
    3818:	6a 01                	push   $0x1
    381a:	68 d1 4e 00 00       	push   $0x4ed1
    381f:	ff 75 e4             	push   -0x1c(%ebp)
    3822:	e8 71 09 00 00       	call   4198 <write>
    3827:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    382a:	83 ec 0c             	sub    $0xc,%esp
    382d:	68 e8 03 00 00       	push   $0x3e8
    3832:	e8 d1 09 00 00       	call   4208 <sleep>
    3837:	83 c4 10             	add    $0x10,%esp
    383a:	eb ee                	jmp    382a <sbrktest+0x3d1>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    383c:	43                   	inc    %ebx
    383d:	83 fb 09             	cmp    $0x9,%ebx
    3840:	77 28                	ja     386a <sbrktest+0x411>
    if((pids[i] = fork()) == 0){
    3842:	e8 29 09 00 00       	call   4170 <fork>
    3847:	89 44 9d b8          	mov    %eax,-0x48(%ebp,%ebx,4)
    384b:	85 c0                	test   %eax,%eax
    384d:	74 ab                	je     37fa <sbrktest+0x3a1>
    }
    if(pids[i] != -1)
    384f:	83 f8 ff             	cmp    $0xffffffff,%eax
    3852:	74 e8                	je     383c <sbrktest+0x3e3>
      read(fds[0], &scratch, 1);
    3854:	83 ec 04             	sub    $0x4,%esp
    3857:	6a 01                	push   $0x1
    3859:	8d 45 b7             	lea    -0x49(%ebp),%eax
    385c:	50                   	push   %eax
    385d:	ff 75 e0             	push   -0x20(%ebp)
    3860:	e8 2b 09 00 00       	call   4190 <read>
    3865:	83 c4 10             	add    $0x10,%esp
    3868:	eb d2                	jmp    383c <sbrktest+0x3e3>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    386a:	83 ec 0c             	sub    $0xc,%esp
    386d:	68 00 10 00 00       	push   $0x1000
    3872:	e8 89 09 00 00       	call   4200 <sbrk>
    3877:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3879:	83 c4 10             	add    $0x10,%esp
    387c:	bb 00 00 00 00       	mov    $0x0,%ebx
    3881:	eb 01                	jmp    3884 <sbrktest+0x42b>
    3883:	43                   	inc    %ebx
    3884:	83 fb 09             	cmp    $0x9,%ebx
    3887:	77 23                	ja     38ac <sbrktest+0x453>
    if(pids[i] == -1)
    3889:	8b 44 9d b8          	mov    -0x48(%ebp,%ebx,4),%eax
    388d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3890:	74 f1                	je     3883 <sbrktest+0x42a>
      continue;
    kill(pids[i]);
    3892:	83 ec 0c             	sub    $0xc,%esp
    3895:	50                   	push   %eax
    3896:	e8 0d 09 00 00       	call   41a8 <kill>
    wait(NULL);
    389b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    38a2:	e8 d9 08 00 00       	call   4180 <wait>
    38a7:	83 c4 10             	add    $0x10,%esp
    38aa:	eb d7                	jmp    3883 <sbrktest+0x42a>
  }
  if(c == (char*)0xffffffff){
    38ac:	83 fe ff             	cmp    $0xffffffff,%esi
    38af:	74 30                	je     38e1 <sbrktest+0x488>
    printf(stdout, "failed sbrk leaked memory\n");
    exit(0);
  }

  if(sbrk(0) > oldbrk)
    38b1:	83 ec 0c             	sub    $0xc,%esp
    38b4:	6a 00                	push   $0x0
    38b6:	e8 45 09 00 00       	call   4200 <sbrk>
    38bb:	83 c4 10             	add    $0x10,%esp
    38be:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    38c1:	72 42                	jb     3905 <sbrktest+0x4ac>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    38c3:	83 ec 08             	sub    $0x8,%esp
    38c6:	68 10 54 00 00       	push   $0x5410
    38cb:	ff 35 50 66 00 00    	push   0x6650
    38d1:	e8 fd 09 00 00       	call   42d3 <printf>
}
    38d6:	83 c4 10             	add    $0x10,%esp
    38d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    38dc:	5b                   	pop    %ebx
    38dd:	5e                   	pop    %esi
    38de:	5f                   	pop    %edi
    38df:	5d                   	pop    %ebp
    38e0:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    38e1:	83 ec 08             	sub    $0x8,%esp
    38e4:	68 f5 53 00 00       	push   $0x53f5
    38e9:	ff 35 50 66 00 00    	push   0x6650
    38ef:	e8 df 09 00 00       	call   42d3 <printf>
    exit(0);
    38f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    38fb:	e8 78 08 00 00       	call   4178 <exit>
    3900:	83 c4 10             	add    $0x10,%esp
    3903:	eb ac                	jmp    38b1 <sbrktest+0x458>
    sbrk(-(sbrk(0) - oldbrk));
    3905:	83 ec 0c             	sub    $0xc,%esp
    3908:	6a 00                	push   $0x0
    390a:	e8 f1 08 00 00       	call   4200 <sbrk>
    390f:	89 c2                	mov    %eax,%edx
    3911:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    3914:	29 d0                	sub    %edx,%eax
    3916:	89 04 24             	mov    %eax,(%esp)
    3919:	e8 e2 08 00 00       	call   4200 <sbrk>
    391e:	83 c4 10             	add    $0x10,%esp
    3921:	eb a0                	jmp    38c3 <sbrktest+0x46a>

00003923 <validateint>:
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3923:	c3                   	ret    

00003924 <validatetest>:

void
validatetest(void)
{
    3924:	55                   	push   %ebp
    3925:	89 e5                	mov    %esp,%ebp
    3927:	56                   	push   %esi
    3928:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3929:	83 ec 08             	sub    $0x8,%esp
    392c:	68 1e 54 00 00       	push   $0x541e
    3931:	ff 35 50 66 00 00    	push   0x6650
    3937:	e8 97 09 00 00       	call   42d3 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    393c:	83 c4 10             	add    $0x10,%esp
    393f:	be 00 00 00 00       	mov    $0x0,%esi
    3944:	eb 15                	jmp    395b <validatetest+0x37>
    if((pid = fork()) == 0){
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit(0);
    3946:	83 ec 0c             	sub    $0xc,%esp
    3949:	6a 00                	push   $0x0
    394b:	e8 28 08 00 00       	call   4178 <exit>
    3950:	83 c4 10             	add    $0x10,%esp
    3953:	eb 19                	jmp    396e <validatetest+0x4a>
  for(p = 0; p <= (uint)hi; p += 4096){
    3955:	81 c6 00 10 00 00    	add    $0x1000,%esi
    395b:	81 fe 00 30 11 00    	cmp    $0x113000,%esi
    3961:	77 6f                	ja     39d2 <validatetest+0xae>
    if((pid = fork()) == 0){
    3963:	e8 08 08 00 00       	call   4170 <fork>
    3968:	89 c3                	mov    %eax,%ebx
    396a:	85 c0                	test   %eax,%eax
    396c:	74 d8                	je     3946 <validatetest+0x22>
    }
    sleep(0);
    396e:	83 ec 0c             	sub    $0xc,%esp
    3971:	6a 00                	push   $0x0
    3973:	e8 90 08 00 00       	call   4208 <sleep>
    sleep(0);
    3978:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    397f:	e8 84 08 00 00       	call   4208 <sleep>
    kill(pid);
    3984:	89 1c 24             	mov    %ebx,(%esp)
    3987:	e8 1c 08 00 00       	call   41a8 <kill>
    wait(NULL);
    398c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3993:	e8 e8 07 00 00       	call   4180 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3998:	83 c4 08             	add    $0x8,%esp
    399b:	56                   	push   %esi
    399c:	68 2d 54 00 00       	push   $0x542d
    39a1:	e8 32 08 00 00       	call   41d8 <link>
    39a6:	83 c4 10             	add    $0x10,%esp
    39a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    39ac:	74 a7                	je     3955 <validatetest+0x31>
      printf(stdout, "link should not succeed\n");
    39ae:	83 ec 08             	sub    $0x8,%esp
    39b1:	68 38 54 00 00       	push   $0x5438
    39b6:	ff 35 50 66 00 00    	push   0x6650
    39bc:	e8 12 09 00 00       	call   42d3 <printf>
      exit(0);
    39c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    39c8:	e8 ab 07 00 00       	call   4178 <exit>
    39cd:	83 c4 10             	add    $0x10,%esp
    39d0:	eb 83                	jmp    3955 <validatetest+0x31>
    }
  }

  printf(stdout, "validate ok\n");
    39d2:	83 ec 08             	sub    $0x8,%esp
    39d5:	68 51 54 00 00       	push   $0x5451
    39da:	ff 35 50 66 00 00    	push   0x6650
    39e0:	e8 ee 08 00 00       	call   42d3 <printf>
}
    39e5:	83 c4 10             	add    $0x10,%esp
    39e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    39eb:	5b                   	pop    %ebx
    39ec:	5e                   	pop    %esi
    39ed:	5d                   	pop    %ebp
    39ee:	c3                   	ret    

000039ef <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    39ef:	55                   	push   %ebp
    39f0:	89 e5                	mov    %esp,%ebp
    39f2:	53                   	push   %ebx
    39f3:	83 ec 0c             	sub    $0xc,%esp
  int i;

  printf(stdout, "bss test\n");
    39f6:	68 5e 54 00 00       	push   $0x545e
    39fb:	ff 35 50 66 00 00    	push   0x6650
    3a01:	e8 cd 08 00 00       	call   42d3 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3a06:	83 c4 10             	add    $0x10,%esp
    3a09:	bb 00 00 00 00       	mov    $0x0,%ebx
    3a0e:	eb 01                	jmp    3a11 <bsstest+0x22>
    3a10:	43                   	inc    %ebx
    3a11:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
    3a17:	77 2d                	ja     3a46 <bsstest+0x57>
    if(uninit[i] != '\0'){
    3a19:	80 bb 80 66 00 00 00 	cmpb   $0x0,0x6680(%ebx)
    3a20:	74 ee                	je     3a10 <bsstest+0x21>
      printf(stdout, "bss test failed\n");
    3a22:	83 ec 08             	sub    $0x8,%esp
    3a25:	68 68 54 00 00       	push   $0x5468
    3a2a:	ff 35 50 66 00 00    	push   0x6650
    3a30:	e8 9e 08 00 00       	call   42d3 <printf>
      exit(0);
    3a35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3a3c:	e8 37 07 00 00       	call   4178 <exit>
    3a41:	83 c4 10             	add    $0x10,%esp
    3a44:	eb ca                	jmp    3a10 <bsstest+0x21>
    }
  }
  printf(stdout, "bss test ok\n");
    3a46:	83 ec 08             	sub    $0x8,%esp
    3a49:	68 79 54 00 00       	push   $0x5479
    3a4e:	ff 35 50 66 00 00    	push   0x6650
    3a54:	e8 7a 08 00 00       	call   42d3 <printf>
}
    3a59:	83 c4 10             	add    $0x10,%esp
    3a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3a5f:	c9                   	leave  
    3a60:	c3                   	ret    

00003a61 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3a61:	55                   	push   %ebp
    3a62:	89 e5                	mov    %esp,%ebp
    3a64:	53                   	push   %ebx
    3a65:	83 ec 10             	sub    $0x10,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3a68:	68 86 54 00 00       	push   $0x5486
    3a6d:	e8 56 07 00 00       	call   41c8 <unlink>
  pid = fork();
    3a72:	e8 f9 06 00 00       	call   4170 <fork>
  if(pid == 0){
    3a77:	83 c4 10             	add    $0x10,%esp
    3a7a:	85 c0                	test   %eax,%eax
    3a7c:	74 36                	je     3ab4 <bigargtest+0x53>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    3a7e:	0f 89 a0 00 00 00    	jns    3b24 <bigargtest+0xc3>
    printf(stdout, "bigargtest: fork failed\n");
    3a84:	83 ec 08             	sub    $0x8,%esp
    3a87:	68 ad 54 00 00       	push   $0x54ad
    3a8c:	ff 35 50 66 00 00    	push   0x6650
    3a92:	e8 3c 08 00 00       	call   42d3 <printf>
    exit(0);
    3a97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3a9e:	e8 d5 06 00 00       	call   4178 <exit>
    3aa3:	83 c4 10             	add    $0x10,%esp
    3aa6:	eb 7c                	jmp    3b24 <bigargtest+0xc3>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3aa8:	c7 04 85 a0 ad 00 00 	movl   $0x5be0,0xada0(,%eax,4)
    3aaf:	e0 5b 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3ab3:	40                   	inc    %eax
    3ab4:	83 f8 1e             	cmp    $0x1e,%eax
    3ab7:	7e ef                	jle    3aa8 <bigargtest+0x47>
    args[MAXARG-1] = 0;
    3ab9:	c7 05 1c ae 00 00 00 	movl   $0x0,0xae1c
    3ac0:	00 00 00 
    printf(stdout, "bigarg test\n");
    3ac3:	83 ec 08             	sub    $0x8,%esp
    3ac6:	68 90 54 00 00       	push   $0x5490
    3acb:	ff 35 50 66 00 00    	push   0x6650
    3ad1:	e8 fd 07 00 00       	call   42d3 <printf>
    exec("echo", args);
    3ad6:	83 c4 08             	add    $0x8,%esp
    3ad9:	68 a0 ad 00 00       	push   $0xada0
    3ade:	68 5d 46 00 00       	push   $0x465d
    3ae3:	e8 c8 06 00 00       	call   41b0 <exec>
    printf(stdout, "bigarg test ok\n");
    3ae8:	83 c4 08             	add    $0x8,%esp
    3aeb:	68 9d 54 00 00       	push   $0x549d
    3af0:	ff 35 50 66 00 00    	push   0x6650
    3af6:	e8 d8 07 00 00       	call   42d3 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3afb:	83 c4 08             	add    $0x8,%esp
    3afe:	68 00 02 00 00       	push   $0x200
    3b03:	68 86 54 00 00       	push   $0x5486
    3b08:	e8 ab 06 00 00       	call   41b8 <open>
    close(fd);
    3b0d:	89 04 24             	mov    %eax,(%esp)
    3b10:	e8 8b 06 00 00       	call   41a0 <close>
    exit(0);
    3b15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b1c:	e8 57 06 00 00       	call   4178 <exit>
    3b21:	83 c4 10             	add    $0x10,%esp
  }
  wait(NULL);
    3b24:	83 ec 0c             	sub    $0xc,%esp
    3b27:	6a 00                	push   $0x0
    3b29:	e8 52 06 00 00       	call   4180 <wait>
  fd = open("bigarg-ok", 0);
    3b2e:	83 c4 08             	add    $0x8,%esp
    3b31:	6a 00                	push   $0x0
    3b33:	68 86 54 00 00       	push   $0x5486
    3b38:	e8 7b 06 00 00       	call   41b8 <open>
    3b3d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    3b3f:	83 c4 10             	add    $0x10,%esp
    3b42:	85 c0                	test   %eax,%eax
    3b44:	78 1d                	js     3b63 <bigargtest+0x102>
    printf(stdout, "bigarg test failed!\n");
    exit(0);
  }
  close(fd);
    3b46:	83 ec 0c             	sub    $0xc,%esp
    3b49:	53                   	push   %ebx
    3b4a:	e8 51 06 00 00       	call   41a0 <close>
  unlink("bigarg-ok");
    3b4f:	c7 04 24 86 54 00 00 	movl   $0x5486,(%esp)
    3b56:	e8 6d 06 00 00       	call   41c8 <unlink>
}
    3b5b:	83 c4 10             	add    $0x10,%esp
    3b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b61:	c9                   	leave  
    3b62:	c3                   	ret    
    printf(stdout, "bigarg test failed!\n");
    3b63:	83 ec 08             	sub    $0x8,%esp
    3b66:	68 c6 54 00 00       	push   $0x54c6
    3b6b:	ff 35 50 66 00 00    	push   0x6650
    3b71:	e8 5d 07 00 00       	call   42d3 <printf>
    exit(0);
    3b76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b7d:	e8 f6 05 00 00       	call   4178 <exit>
    3b82:	83 c4 10             	add    $0x10,%esp
    3b85:	eb bf                	jmp    3b46 <bigargtest+0xe5>

00003b87 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3b87:	55                   	push   %ebp
    3b88:	89 e5                	mov    %esp,%ebp
    3b8a:	57                   	push   %edi
    3b8b:	56                   	push   %esi
    3b8c:	53                   	push   %ebx
    3b8d:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    3b90:	68 db 54 00 00       	push   $0x54db
    3b95:	6a 01                	push   $0x1
    3b97:	e8 37 07 00 00       	call   42d3 <printf>
    3b9c:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3b9f:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    3ba4:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3ba8:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3bad:	f7 eb                	imul   %ebx
    3baf:	89 d0                	mov    %edx,%eax
    3bb1:	c1 f8 06             	sar    $0x6,%eax
    3bb4:	89 de                	mov    %ebx,%esi
    3bb6:	c1 fe 1f             	sar    $0x1f,%esi
    3bb9:	29 f0                	sub    %esi,%eax
    3bbb:	8d 50 30             	lea    0x30(%eax),%edx
    3bbe:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3bc1:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3bc4:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3bc7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3bca:	c1 e0 03             	shl    $0x3,%eax
    3bcd:	89 df                	mov    %ebx,%edi
    3bcf:	29 c7                	sub    %eax,%edi
    3bd1:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3bd6:	89 f8                	mov    %edi,%eax
    3bd8:	f7 e9                	imul   %ecx
    3bda:	c1 fa 05             	sar    $0x5,%edx
    3bdd:	c1 ff 1f             	sar    $0x1f,%edi
    3be0:	29 fa                	sub    %edi,%edx
    3be2:	83 c2 30             	add    $0x30,%edx
    3be5:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3be8:	89 c8                	mov    %ecx,%eax
    3bea:	f7 eb                	imul   %ebx
    3bec:	89 d1                	mov    %edx,%ecx
    3bee:	c1 f9 05             	sar    $0x5,%ecx
    3bf1:	29 f1                	sub    %esi,%ecx
    3bf3:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    3bf6:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3bf9:	c1 e0 02             	shl    $0x2,%eax
    3bfc:	89 d9                	mov    %ebx,%ecx
    3bfe:	29 c1                	sub    %eax,%ecx
    3c00:	bf 67 66 66 66       	mov    $0x66666667,%edi
    3c05:	89 c8                	mov    %ecx,%eax
    3c07:	f7 ef                	imul   %edi
    3c09:	89 d0                	mov    %edx,%eax
    3c0b:	c1 f8 02             	sar    $0x2,%eax
    3c0e:	c1 f9 1f             	sar    $0x1f,%ecx
    3c11:	29 c8                	sub    %ecx,%eax
    3c13:	83 c0 30             	add    $0x30,%eax
    3c16:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3c19:	89 f8                	mov    %edi,%eax
    3c1b:	f7 eb                	imul   %ebx
    3c1d:	89 d0                	mov    %edx,%eax
    3c1f:	c1 f8 02             	sar    $0x2,%eax
    3c22:	29 f0                	sub    %esi,%eax
    3c24:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3c27:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3c2a:	89 d8                	mov    %ebx,%eax
    3c2c:	29 d0                	sub    %edx,%eax
    3c2e:	83 c0 30             	add    $0x30,%eax
    3c31:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    3c34:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    3c38:	83 ec 04             	sub    $0x4,%esp
    3c3b:	8d 75 a8             	lea    -0x58(%ebp),%esi
    3c3e:	56                   	push   %esi
    3c3f:	68 e8 54 00 00       	push   $0x54e8
    3c44:	6a 01                	push   $0x1
    3c46:	e8 88 06 00 00       	call   42d3 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3c4b:	83 c4 08             	add    $0x8,%esp
    3c4e:	68 02 02 00 00       	push   $0x202
    3c53:	56                   	push   %esi
    3c54:	e8 5f 05 00 00       	call   41b8 <open>
    3c59:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3c5b:	83 c4 10             	add    $0x10,%esp
    3c5e:	85 c0                	test   %eax,%eax
    3c60:	79 1b                	jns    3c7d <fsfull+0xf6>
      printf(1, "open %s failed\n", name);
    3c62:	83 ec 04             	sub    $0x4,%esp
    3c65:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3c68:	50                   	push   %eax
    3c69:	68 f4 54 00 00       	push   $0x54f4
    3c6e:	6a 01                	push   $0x1
    3c70:	e8 5e 06 00 00       	call   42d3 <printf>
      break;
    3c75:	83 c4 10             	add    $0x10,%esp
    3c78:	e9 f3 00 00 00       	jmp    3d70 <fsfull+0x1e9>
    }
    int total = 0;
    3c7d:	bf 00 00 00 00       	mov    $0x0,%edi
    while(1){
      int cc = write(fd, buf, 512);
    3c82:	83 ec 04             	sub    $0x4,%esp
    3c85:	68 00 02 00 00       	push   $0x200
    3c8a:	68 a0 8d 00 00       	push   $0x8da0
    3c8f:	56                   	push   %esi
    3c90:	e8 03 05 00 00       	call   4198 <write>
      if(cc < 512)
    3c95:	83 c4 10             	add    $0x10,%esp
    3c98:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3c9d:	7e 04                	jle    3ca3 <fsfull+0x11c>
        break;
      total += cc;
    3c9f:	01 c7                	add    %eax,%edi
    while(1){
    3ca1:	eb df                	jmp    3c82 <fsfull+0xfb>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3ca3:	83 ec 04             	sub    $0x4,%esp
    3ca6:	57                   	push   %edi
    3ca7:	68 04 55 00 00       	push   $0x5504
    3cac:	6a 01                	push   $0x1
    3cae:	e8 20 06 00 00       	call   42d3 <printf>
    close(fd);
    3cb3:	89 34 24             	mov    %esi,(%esp)
    3cb6:	e8 e5 04 00 00       	call   41a0 <close>
    if(total == 0)
    3cbb:	83 c4 10             	add    $0x10,%esp
    3cbe:	85 ff                	test   %edi,%edi
    3cc0:	0f 84 aa 00 00 00    	je     3d70 <fsfull+0x1e9>
  for(nfiles = 0; ; nfiles++){
    3cc6:	43                   	inc    %ebx
    3cc7:	e9 d8 fe ff ff       	jmp    3ba4 <fsfull+0x1d>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    3ccc:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3cd0:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3cd5:	f7 eb                	imul   %ebx
    3cd7:	89 d0                	mov    %edx,%eax
    3cd9:	c1 f8 06             	sar    $0x6,%eax
    3cdc:	89 de                	mov    %ebx,%esi
    3cde:	c1 fe 1f             	sar    $0x1f,%esi
    3ce1:	29 f0                	sub    %esi,%eax
    3ce3:	8d 50 30             	lea    0x30(%eax),%edx
    3ce6:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3ce9:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3cec:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3cef:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3cf2:	c1 e0 03             	shl    $0x3,%eax
    3cf5:	89 df                	mov    %ebx,%edi
    3cf7:	29 c7                	sub    %eax,%edi
    3cf9:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3cfe:	89 f8                	mov    %edi,%eax
    3d00:	f7 e9                	imul   %ecx
    3d02:	c1 fa 05             	sar    $0x5,%edx
    3d05:	c1 ff 1f             	sar    $0x1f,%edi
    3d08:	29 fa                	sub    %edi,%edx
    3d0a:	83 c2 30             	add    $0x30,%edx
    3d0d:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3d10:	89 c8                	mov    %ecx,%eax
    3d12:	f7 eb                	imul   %ebx
    3d14:	89 d1                	mov    %edx,%ecx
    3d16:	c1 f9 05             	sar    $0x5,%ecx
    3d19:	29 f1                	sub    %esi,%ecx
    3d1b:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    3d1e:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3d21:	c1 e0 02             	shl    $0x2,%eax
    3d24:	89 d9                	mov    %ebx,%ecx
    3d26:	29 c1                	sub    %eax,%ecx
    3d28:	bf 67 66 66 66       	mov    $0x66666667,%edi
    3d2d:	89 c8                	mov    %ecx,%eax
    3d2f:	f7 ef                	imul   %edi
    3d31:	89 d0                	mov    %edx,%eax
    3d33:	c1 f8 02             	sar    $0x2,%eax
    3d36:	c1 f9 1f             	sar    $0x1f,%ecx
    3d39:	29 c8                	sub    %ecx,%eax
    3d3b:	83 c0 30             	add    $0x30,%eax
    3d3e:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3d41:	89 f8                	mov    %edi,%eax
    3d43:	f7 eb                	imul   %ebx
    3d45:	89 d0                	mov    %edx,%eax
    3d47:	c1 f8 02             	sar    $0x2,%eax
    3d4a:	29 f0                	sub    %esi,%eax
    3d4c:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3d4f:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3d52:	89 d8                	mov    %ebx,%eax
    3d54:	29 d0                	sub    %edx,%eax
    3d56:	83 c0 30             	add    $0x30,%eax
    3d59:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    3d5c:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    3d60:	83 ec 0c             	sub    $0xc,%esp
    3d63:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3d66:	50                   	push   %eax
    3d67:	e8 5c 04 00 00       	call   41c8 <unlink>
    nfiles--;
    3d6c:	4b                   	dec    %ebx
    3d6d:	83 c4 10             	add    $0x10,%esp
  while(nfiles >= 0){
    3d70:	85 db                	test   %ebx,%ebx
    3d72:	0f 89 54 ff ff ff    	jns    3ccc <fsfull+0x145>
  }

  printf(1, "fsfull test finished\n");
    3d78:	83 ec 08             	sub    $0x8,%esp
    3d7b:	68 14 55 00 00       	push   $0x5514
    3d80:	6a 01                	push   $0x1
    3d82:	e8 4c 05 00 00       	call   42d3 <printf>
}
    3d87:	83 c4 10             	add    $0x10,%esp
    3d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3d8d:	5b                   	pop    %ebx
    3d8e:	5e                   	pop    %esi
    3d8f:	5f                   	pop    %edi
    3d90:	5d                   	pop    %ebp
    3d91:	c3                   	ret    

00003d92 <uio>:

void
uio()
{
    3d92:	55                   	push   %ebp
    3d93:	89 e5                	mov    %esp,%ebp
    3d95:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    3d98:	68 2a 55 00 00       	push   $0x552a
    3d9d:	6a 01                	push   $0x1
    3d9f:	e8 2f 05 00 00       	call   42d3 <printf>
  pid = fork();
    3da4:	e8 c7 03 00 00       	call   4170 <fork>
  if(pid == 0){
    3da9:	83 c4 10             	add    $0x10,%esp
    3dac:	85 c0                	test   %eax,%eax
    3dae:	74 20                	je     3dd0 <uio+0x3e>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit(0);
  } else if(pid < 0){
    3db0:	78 4c                	js     3dfe <uio+0x6c>
    printf (1, "fork failed\n");
    exit(0);
  }
  wait(NULL);
    3db2:	83 ec 0c             	sub    $0xc,%esp
    3db5:	6a 00                	push   $0x0
    3db7:	e8 c4 03 00 00       	call   4180 <wait>
  printf(1, "uio test done\n");
    3dbc:	83 c4 08             	add    $0x8,%esp
    3dbf:	68 34 55 00 00       	push   $0x5534
    3dc4:	6a 01                	push   $0x1
    3dc6:	e8 08 05 00 00       	call   42d3 <printf>
}
    3dcb:	83 c4 10             	add    $0x10,%esp
    3dce:	c9                   	leave  
    3dcf:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3dd0:	b0 09                	mov    $0x9,%al
    3dd2:	ba 70 00 00 00       	mov    $0x70,%edx
    3dd7:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3dd8:	ba 71 00 00 00       	mov    $0x71,%edx
    3ddd:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3dde:	83 ec 08             	sub    $0x8,%esp
    3de1:	68 c0 5c 00 00       	push   $0x5cc0
    3de6:	6a 01                	push   $0x1
    3de8:	e8 e6 04 00 00       	call   42d3 <printf>
    exit(0);
    3ded:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3df4:	e8 7f 03 00 00       	call   4178 <exit>
    3df9:	83 c4 10             	add    $0x10,%esp
    3dfc:	eb b4                	jmp    3db2 <uio+0x20>
    printf (1, "fork failed\n");
    3dfe:	83 ec 08             	sub    $0x8,%esp
    3e01:	68 b9 54 00 00       	push   $0x54b9
    3e06:	6a 01                	push   $0x1
    3e08:	e8 c6 04 00 00       	call   42d3 <printf>
    exit(0);
    3e0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e14:	e8 5f 03 00 00       	call   4178 <exit>
    3e19:	83 c4 10             	add    $0x10,%esp
    3e1c:	eb 94                	jmp    3db2 <uio+0x20>

00003e1e <argptest>:

void argptest()
{
    3e1e:	55                   	push   %ebp
    3e1f:	89 e5                	mov    %esp,%ebp
    3e21:	53                   	push   %ebx
    3e22:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3e25:	6a 00                	push   $0x0
    3e27:	68 43 55 00 00       	push   $0x5543
    3e2c:	e8 87 03 00 00       	call   41b8 <open>
    3e31:	89 c3                	mov    %eax,%ebx
  if (fd < 0) {
    3e33:	83 c4 10             	add    $0x10,%esp
    3e36:	85 c0                	test   %eax,%eax
    3e38:	78 36                	js     3e70 <argptest+0x52>
    printf(2, "open failed\n");
    exit(0);
  }
  read(fd, sbrk(0) - 1, -1);
    3e3a:	83 ec 0c             	sub    $0xc,%esp
    3e3d:	6a 00                	push   $0x0
    3e3f:	e8 bc 03 00 00       	call   4200 <sbrk>
    3e44:	48                   	dec    %eax
    3e45:	83 c4 0c             	add    $0xc,%esp
    3e48:	6a ff                	push   $0xffffffff
    3e4a:	50                   	push   %eax
    3e4b:	53                   	push   %ebx
    3e4c:	e8 3f 03 00 00       	call   4190 <read>
  close(fd);
    3e51:	89 1c 24             	mov    %ebx,(%esp)
    3e54:	e8 47 03 00 00       	call   41a0 <close>
  printf(1, "arg test passed\n");
    3e59:	83 c4 08             	add    $0x8,%esp
    3e5c:	68 55 55 00 00       	push   $0x5555
    3e61:	6a 01                	push   $0x1
    3e63:	e8 6b 04 00 00       	call   42d3 <printf>
}
    3e68:	83 c4 10             	add    $0x10,%esp
    3e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3e6e:	c9                   	leave  
    3e6f:	c3                   	ret    
    printf(2, "open failed\n");
    3e70:	83 ec 08             	sub    $0x8,%esp
    3e73:	68 48 55 00 00       	push   $0x5548
    3e78:	6a 02                	push   $0x2
    3e7a:	e8 54 04 00 00       	call   42d3 <printf>
    exit(0);
    3e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e86:	e8 ed 02 00 00       	call   4178 <exit>
    3e8b:	83 c4 10             	add    $0x10,%esp
    3e8e:	eb aa                	jmp    3e3a <argptest+0x1c>

00003e90 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    3e90:	a1 4c 66 00 00       	mov    0x664c,%eax
    3e95:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3e98:	01 c2                	add    %eax,%edx
    3e9a:	8d 0c 90             	lea    (%eax,%edx,4),%ecx
    3e9d:	c1 e1 08             	shl    $0x8,%ecx
    3ea0:	89 ca                	mov    %ecx,%edx
    3ea2:	01 c2                	add    %eax,%edx
    3ea4:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3ea7:	8d 04 90             	lea    (%eax,%edx,4),%eax
    3eaa:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3ead:	8d 84 80 5f f3 6e 3c 	lea    0x3c6ef35f(%eax,%eax,4),%eax
    3eb4:	a3 4c 66 00 00       	mov    %eax,0x664c
  return randstate;
}
    3eb9:	c3                   	ret    

00003eba <main>:

int
main(int argc, char *argv[])
{
    3eba:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3ebe:	83 e4 f0             	and    $0xfffffff0,%esp
    3ec1:	ff 71 fc             	push   -0x4(%ecx)
    3ec4:	55                   	push   %ebp
    3ec5:	89 e5                	mov    %esp,%ebp
    3ec7:	51                   	push   %ecx
    3ec8:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    3ecb:	68 66 55 00 00       	push   $0x5566
    3ed0:	6a 01                	push   $0x1
    3ed2:	e8 fc 03 00 00       	call   42d3 <printf>

  if(open("usertests.ran", 0) >= 0){
    3ed7:	83 c4 08             	add    $0x8,%esp
    3eda:	6a 00                	push   $0x0
    3edc:	68 7a 55 00 00       	push   $0x557a
    3ee1:	e8 d2 02 00 00       	call   41b8 <open>
    3ee6:	83 c4 10             	add    $0x10,%esp
    3ee9:	85 c0                	test   %eax,%eax
    3eeb:	0f 89 e2 00 00 00    	jns    3fd3 <main+0x119>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    exit(0);
  }
  close(open("usertests.ran", O_CREATE));
    3ef1:	83 ec 08             	sub    $0x8,%esp
    3ef4:	68 00 02 00 00       	push   $0x200
    3ef9:	68 7a 55 00 00       	push   $0x557a
    3efe:	e8 b5 02 00 00       	call   41b8 <open>
    3f03:	89 04 24             	mov    %eax,(%esp)
    3f06:	e8 95 02 00 00       	call   41a0 <close>

  argptest();
    3f0b:	e8 0e ff ff ff       	call   3e1e <argptest>
  createdelete();
    3f10:	e8 c6 d3 ff ff       	call   12db <createdelete>
  linkunlink();
    3f15:	e8 d0 dd ff ff       	call   1cea <linkunlink>
  concreate();
    3f1a:	e8 aa da ff ff       	call   19c9 <concreate>
  fourfiles();
    3f1f:	e8 91 d1 ff ff       	call   10b5 <fourfiles>
  sharedfd();
    3f24:	e8 e2 cf ff ff       	call   f0b <sharedfd>

  bigargtest();
    3f29:	e8 33 fb ff ff       	call   3a61 <bigargtest>
  bigwrite();
    3f2e:	e8 aa e9 ff ff       	call   28dd <bigwrite>
  bigargtest();
    3f33:	e8 29 fb ff ff       	call   3a61 <bigargtest>
  bsstest();
    3f38:	e8 b2 fa ff ff       	call   39ef <bsstest>
  sbrktest();
    3f3d:	e8 17 f5 ff ff       	call   3459 <sbrktest>
  validatetest();
    3f42:	e8 dd f9 ff ff       	call   3924 <validatetest>

  opentest();
    3f47:	e8 3b c4 ff ff       	call   387 <opentest>
  writetest();
    3f4c:	e8 e7 c4 ff ff       	call   438 <writetest>
  writetest1();
    3f51:	e8 02 c7 ff ff       	call   658 <writetest1>
  createtest();
    3f56:	e8 03 c9 ff ff       	call   85e <createtest>

  openiputtest();
    3f5b:	e8 e6 c2 ff ff       	call   246 <openiputtest>
  exitiputtest();
    3f60:	e8 b5 c1 ff ff       	call   11a <exitiputtest>
  iputtest();
    3f65:	e8 96 c0 ff ff       	call   0 <iputtest>

  mem();
    3f6a:	e8 bf ce ff ff       	call   e2e <mem>
  pipe1();
    3f6f:	e8 01 cb ff ff       	call   a75 <pipe1>
  preempt();
    3f74:	e8 e4 cc ff ff       	call   c5d <preempt>
  exitwait();
    3f79:	e8 32 ce ff ff       	call   db0 <exitwait>

  rmdot();
    3f7e:	e8 05 ee ff ff       	call   2d88 <rmdot>
  fourteen();
    3f83:	e8 59 ec ff ff       	call   2be1 <fourteen>
  bigfile();
    3f88:	e8 42 ea ff ff       	call   29cf <bigfile>
  subdir();
    3f8d:	e8 ff df ff ff       	call   1f91 <subdir>
  linktest();
    3f92:	e8 85 d7 ff ff       	call   171c <linktest>
  unlinkread();
    3f97:	e8 8d d5 ff ff       	call   1529 <unlinkread>
  dirfile();
    3f9c:	e8 e4 ef ff ff       	call   2f85 <dirfile>
  iref();
    3fa1:	e8 91 f2 ff ff       	call   3237 <iref>
  forktest();
    3fa6:	e8 c7 f3 ff ff       	call   3372 <forktest>
  bigdir(); // slow
    3fab:	e8 65 de ff ff       	call   1e15 <bigdir>

  uio();
    3fb0:	e8 dd fd ff ff       	call   3d92 <uio>

  exectest();
    3fb5:	e8 66 ca ff ff       	call   a20 <exectest>

  exit(0);
    3fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3fc1:	e8 b2 01 00 00       	call   4178 <exit>
}
    3fc6:	b8 00 00 00 00       	mov    $0x0,%eax
    3fcb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
    3fce:	c9                   	leave  
    3fcf:	8d 61 fc             	lea    -0x4(%ecx),%esp
    3fd2:	c3                   	ret    
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3fd3:	83 ec 08             	sub    $0x8,%esp
    3fd6:	68 e4 5c 00 00       	push   $0x5ce4
    3fdb:	6a 01                	push   $0x1
    3fdd:	e8 f1 02 00 00       	call   42d3 <printf>
    exit(0);
    3fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3fe9:	e8 8a 01 00 00       	call   4178 <exit>
    3fee:	83 c4 10             	add    $0x10,%esp
    3ff1:	e9 fb fe ff ff       	jmp    3ef1 <main+0x37>

00003ff6 <start>:

// Entry point of the library	
void
start()
{
}
    3ff6:	c3                   	ret    

00003ff7 <strcpy>:

char*
strcpy(char *s, const char *t)
{
    3ff7:	55                   	push   %ebp
    3ff8:	89 e5                	mov    %esp,%ebp
    3ffa:	56                   	push   %esi
    3ffb:	53                   	push   %ebx
    3ffc:	8b 45 08             	mov    0x8(%ebp),%eax
    3fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4002:	89 c2                	mov    %eax,%edx
    4004:	89 cb                	mov    %ecx,%ebx
    4006:	41                   	inc    %ecx
    4007:	89 d6                	mov    %edx,%esi
    4009:	42                   	inc    %edx
    400a:	8a 1b                	mov    (%ebx),%bl
    400c:	88 1e                	mov    %bl,(%esi)
    400e:	84 db                	test   %bl,%bl
    4010:	75 f2                	jne    4004 <strcpy+0xd>
    ;
  return os;
}
    4012:	5b                   	pop    %ebx
    4013:	5e                   	pop    %esi
    4014:	5d                   	pop    %ebp
    4015:	c3                   	ret    

00004016 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4016:	55                   	push   %ebp
    4017:	89 e5                	mov    %esp,%ebp
    4019:	8b 4d 08             	mov    0x8(%ebp),%ecx
    401c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    401f:	eb 02                	jmp    4023 <strcmp+0xd>
    p++, q++;
    4021:	41                   	inc    %ecx
    4022:	42                   	inc    %edx
  while(*p && *p == *q)
    4023:	8a 01                	mov    (%ecx),%al
    4025:	84 c0                	test   %al,%al
    4027:	74 04                	je     402d <strcmp+0x17>
    4029:	3a 02                	cmp    (%edx),%al
    402b:	74 f4                	je     4021 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    402d:	0f b6 c0             	movzbl %al,%eax
    4030:	0f b6 12             	movzbl (%edx),%edx
    4033:	29 d0                	sub    %edx,%eax
}
    4035:	5d                   	pop    %ebp
    4036:	c3                   	ret    

00004037 <strlen>:

uint
strlen(const char *s)
{
    4037:	55                   	push   %ebp
    4038:	89 e5                	mov    %esp,%ebp
    403a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    403d:	b8 00 00 00 00       	mov    $0x0,%eax
    4042:	eb 01                	jmp    4045 <strlen+0xe>
    4044:	40                   	inc    %eax
    4045:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
    4049:	75 f9                	jne    4044 <strlen+0xd>
    ;
  return n;
}
    404b:	5d                   	pop    %ebp
    404c:	c3                   	ret    

0000404d <memset>:

void*
memset(void *dst, int c, uint n)
{
    404d:	55                   	push   %ebp
    404e:	89 e5                	mov    %esp,%ebp
    4050:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    4051:	8b 7d 08             	mov    0x8(%ebp),%edi
    4054:	8b 4d 10             	mov    0x10(%ebp),%ecx
    4057:	8b 45 0c             	mov    0xc(%ebp),%eax
    405a:	fc                   	cld    
    405b:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    405d:	8b 45 08             	mov    0x8(%ebp),%eax
    4060:	8b 7d fc             	mov    -0x4(%ebp),%edi
    4063:	c9                   	leave  
    4064:	c3                   	ret    

00004065 <strchr>:

char*
strchr(const char *s, char c)
{
    4065:	55                   	push   %ebp
    4066:	89 e5                	mov    %esp,%ebp
    4068:	8b 45 08             	mov    0x8(%ebp),%eax
    406b:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
    406e:	eb 01                	jmp    4071 <strchr+0xc>
    4070:	40                   	inc    %eax
    4071:	8a 10                	mov    (%eax),%dl
    4073:	84 d2                	test   %dl,%dl
    4075:	74 06                	je     407d <strchr+0x18>
    if(*s == c)
    4077:	38 ca                	cmp    %cl,%dl
    4079:	75 f5                	jne    4070 <strchr+0xb>
    407b:	eb 05                	jmp    4082 <strchr+0x1d>
      return (char*)s;
  return 0;
    407d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4082:	5d                   	pop    %ebp
    4083:	c3                   	ret    

00004084 <gets>:

char*
gets(char *buf, int max)
{
    4084:	55                   	push   %ebp
    4085:	89 e5                	mov    %esp,%ebp
    4087:	57                   	push   %edi
    4088:	56                   	push   %esi
    4089:	53                   	push   %ebx
    408a:	83 ec 1c             	sub    $0x1c,%esp
    408d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4090:	bb 00 00 00 00       	mov    $0x0,%ebx
    4095:	89 de                	mov    %ebx,%esi
    4097:	43                   	inc    %ebx
    4098:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    409b:	7d 2b                	jge    40c8 <gets+0x44>
    cc = read(0, &c, 1);
    409d:	83 ec 04             	sub    $0x4,%esp
    40a0:	6a 01                	push   $0x1
    40a2:	8d 45 e7             	lea    -0x19(%ebp),%eax
    40a5:	50                   	push   %eax
    40a6:	6a 00                	push   $0x0
    40a8:	e8 e3 00 00 00       	call   4190 <read>
    if(cc < 1)
    40ad:	83 c4 10             	add    $0x10,%esp
    40b0:	85 c0                	test   %eax,%eax
    40b2:	7e 14                	jle    40c8 <gets+0x44>
      break;
    buf[i++] = c;
    40b4:	8a 45 e7             	mov    -0x19(%ebp),%al
    40b7:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    40ba:	3c 0a                	cmp    $0xa,%al
    40bc:	74 08                	je     40c6 <gets+0x42>
    40be:	3c 0d                	cmp    $0xd,%al
    40c0:	75 d3                	jne    4095 <gets+0x11>
    buf[i++] = c;
    40c2:	89 de                	mov    %ebx,%esi
    40c4:	eb 02                	jmp    40c8 <gets+0x44>
    40c6:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    40c8:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    40cc:	89 f8                	mov    %edi,%eax
    40ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    40d1:	5b                   	pop    %ebx
    40d2:	5e                   	pop    %esi
    40d3:	5f                   	pop    %edi
    40d4:	5d                   	pop    %ebp
    40d5:	c3                   	ret    

000040d6 <stat>:

int
stat(const char *n, struct stat *st)
{
    40d6:	55                   	push   %ebp
    40d7:	89 e5                	mov    %esp,%ebp
    40d9:	56                   	push   %esi
    40da:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    40db:	83 ec 08             	sub    $0x8,%esp
    40de:	6a 00                	push   $0x0
    40e0:	ff 75 08             	push   0x8(%ebp)
    40e3:	e8 d0 00 00 00       	call   41b8 <open>
  if(fd < 0)
    40e8:	83 c4 10             	add    $0x10,%esp
    40eb:	85 c0                	test   %eax,%eax
    40ed:	78 24                	js     4113 <stat+0x3d>
    40ef:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    40f1:	83 ec 08             	sub    $0x8,%esp
    40f4:	ff 75 0c             	push   0xc(%ebp)
    40f7:	50                   	push   %eax
    40f8:	e8 d3 00 00 00       	call   41d0 <fstat>
    40fd:	89 c6                	mov    %eax,%esi
  close(fd);
    40ff:	89 1c 24             	mov    %ebx,(%esp)
    4102:	e8 99 00 00 00       	call   41a0 <close>
  return r;
    4107:	83 c4 10             	add    $0x10,%esp
}
    410a:	89 f0                	mov    %esi,%eax
    410c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    410f:	5b                   	pop    %ebx
    4110:	5e                   	pop    %esi
    4111:	5d                   	pop    %ebp
    4112:	c3                   	ret    
    return -1;
    4113:	be ff ff ff ff       	mov    $0xffffffff,%esi
    4118:	eb f0                	jmp    410a <stat+0x34>

0000411a <atoi>:

int
atoi(const char *s)
{
    411a:	55                   	push   %ebp
    411b:	89 e5                	mov    %esp,%ebp
    411d:	53                   	push   %ebx
    411e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    4121:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    4126:	eb 0e                	jmp    4136 <atoi+0x1c>
    n = n*10 + *s++ - '0';
    4128:	8d 14 92             	lea    (%edx,%edx,4),%edx
    412b:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
    412e:	41                   	inc    %ecx
    412f:	0f be c0             	movsbl %al,%eax
    4132:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
    4136:	8a 01                	mov    (%ecx),%al
    4138:	8d 58 d0             	lea    -0x30(%eax),%ebx
    413b:	80 fb 09             	cmp    $0x9,%bl
    413e:	76 e8                	jbe    4128 <atoi+0xe>
  return n;
}
    4140:	89 d0                	mov    %edx,%eax
    4142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4145:	c9                   	leave  
    4146:	c3                   	ret    

00004147 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4147:	55                   	push   %ebp
    4148:	89 e5                	mov    %esp,%ebp
    414a:	56                   	push   %esi
    414b:	53                   	push   %ebx
    414c:	8b 45 08             	mov    0x8(%ebp),%eax
    414f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    4152:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
    4155:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
    4157:	eb 0c                	jmp    4165 <memmove+0x1e>
    *dst++ = *src++;
    4159:	8a 13                	mov    (%ebx),%dl
    415b:	88 11                	mov    %dl,(%ecx)
    415d:	8d 5b 01             	lea    0x1(%ebx),%ebx
    4160:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
    4163:	89 f2                	mov    %esi,%edx
    4165:	8d 72 ff             	lea    -0x1(%edx),%esi
    4168:	85 d2                	test   %edx,%edx
    416a:	7f ed                	jg     4159 <memmove+0x12>
  return vdst;
}
    416c:	5b                   	pop    %ebx
    416d:	5e                   	pop    %esi
    416e:	5d                   	pop    %ebp
    416f:	c3                   	ret    

00004170 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4170:	b8 01 00 00 00       	mov    $0x1,%eax
    4175:	cd 40                	int    $0x40
    4177:	c3                   	ret    

00004178 <exit>:
SYSCALL(exit)
    4178:	b8 02 00 00 00       	mov    $0x2,%eax
    417d:	cd 40                	int    $0x40
    417f:	c3                   	ret    

00004180 <wait>:
SYSCALL(wait)
    4180:	b8 03 00 00 00       	mov    $0x3,%eax
    4185:	cd 40                	int    $0x40
    4187:	c3                   	ret    

00004188 <pipe>:
SYSCALL(pipe)
    4188:	b8 04 00 00 00       	mov    $0x4,%eax
    418d:	cd 40                	int    $0x40
    418f:	c3                   	ret    

00004190 <read>:
SYSCALL(read)
    4190:	b8 05 00 00 00       	mov    $0x5,%eax
    4195:	cd 40                	int    $0x40
    4197:	c3                   	ret    

00004198 <write>:
SYSCALL(write)
    4198:	b8 10 00 00 00       	mov    $0x10,%eax
    419d:	cd 40                	int    $0x40
    419f:	c3                   	ret    

000041a0 <close>:
SYSCALL(close)
    41a0:	b8 15 00 00 00       	mov    $0x15,%eax
    41a5:	cd 40                	int    $0x40
    41a7:	c3                   	ret    

000041a8 <kill>:
SYSCALL(kill)
    41a8:	b8 06 00 00 00       	mov    $0x6,%eax
    41ad:	cd 40                	int    $0x40
    41af:	c3                   	ret    

000041b0 <exec>:
SYSCALL(exec)
    41b0:	b8 07 00 00 00       	mov    $0x7,%eax
    41b5:	cd 40                	int    $0x40
    41b7:	c3                   	ret    

000041b8 <open>:
SYSCALL(open)
    41b8:	b8 0f 00 00 00       	mov    $0xf,%eax
    41bd:	cd 40                	int    $0x40
    41bf:	c3                   	ret    

000041c0 <mknod>:
SYSCALL(mknod)
    41c0:	b8 11 00 00 00       	mov    $0x11,%eax
    41c5:	cd 40                	int    $0x40
    41c7:	c3                   	ret    

000041c8 <unlink>:
SYSCALL(unlink)
    41c8:	b8 12 00 00 00       	mov    $0x12,%eax
    41cd:	cd 40                	int    $0x40
    41cf:	c3                   	ret    

000041d0 <fstat>:
SYSCALL(fstat)
    41d0:	b8 08 00 00 00       	mov    $0x8,%eax
    41d5:	cd 40                	int    $0x40
    41d7:	c3                   	ret    

000041d8 <link>:
SYSCALL(link)
    41d8:	b8 13 00 00 00       	mov    $0x13,%eax
    41dd:	cd 40                	int    $0x40
    41df:	c3                   	ret    

000041e0 <mkdir>:
SYSCALL(mkdir)
    41e0:	b8 14 00 00 00       	mov    $0x14,%eax
    41e5:	cd 40                	int    $0x40
    41e7:	c3                   	ret    

000041e8 <chdir>:
SYSCALL(chdir)
    41e8:	b8 09 00 00 00       	mov    $0x9,%eax
    41ed:	cd 40                	int    $0x40
    41ef:	c3                   	ret    

000041f0 <dup>:
SYSCALL(dup)
    41f0:	b8 0a 00 00 00       	mov    $0xa,%eax
    41f5:	cd 40                	int    $0x40
    41f7:	c3                   	ret    

000041f8 <getpid>:
SYSCALL(getpid)
    41f8:	b8 0b 00 00 00       	mov    $0xb,%eax
    41fd:	cd 40                	int    $0x40
    41ff:	c3                   	ret    

00004200 <sbrk>:
SYSCALL(sbrk)
    4200:	b8 0c 00 00 00       	mov    $0xc,%eax
    4205:	cd 40                	int    $0x40
    4207:	c3                   	ret    

00004208 <sleep>:
SYSCALL(sleep)
    4208:	b8 0d 00 00 00       	mov    $0xd,%eax
    420d:	cd 40                	int    $0x40
    420f:	c3                   	ret    

00004210 <uptime>:
SYSCALL(uptime)
    4210:	b8 0e 00 00 00       	mov    $0xe,%eax
    4215:	cd 40                	int    $0x40
    4217:	c3                   	ret    

00004218 <date>:
SYSCALL(date)
    4218:	b8 16 00 00 00       	mov    $0x16,%eax
    421d:	cd 40                	int    $0x40
    421f:	c3                   	ret    

00004220 <dup2>:
SYSCALL(dup2)
    4220:	b8 17 00 00 00       	mov    $0x17,%eax
    4225:	cd 40                	int    $0x40
    4227:	c3                   	ret    

00004228 <phmem>:
SYSCALL(phmem)
    4228:	b8 18 00 00 00       	mov    $0x18,%eax
    422d:	cd 40                	int    $0x40
    422f:	c3                   	ret    

00004230 <getprio>:
SYSCALL(getprio)
    4230:	b8 19 00 00 00       	mov    $0x19,%eax
    4235:	cd 40                	int    $0x40
    4237:	c3                   	ret    

00004238 <setprio>:
SYSCALL(setprio)
    4238:	b8 1a 00 00 00       	mov    $0x1a,%eax
    423d:	cd 40                	int    $0x40
    423f:	c3                   	ret    

00004240 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4240:	55                   	push   %ebp
    4241:	89 e5                	mov    %esp,%ebp
    4243:	83 ec 1c             	sub    $0x1c,%esp
    4246:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    4249:	6a 01                	push   $0x1
    424b:	8d 55 f4             	lea    -0xc(%ebp),%edx
    424e:	52                   	push   %edx
    424f:	50                   	push   %eax
    4250:	e8 43 ff ff ff       	call   4198 <write>
}
    4255:	83 c4 10             	add    $0x10,%esp
    4258:	c9                   	leave  
    4259:	c3                   	ret    

0000425a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    425a:	55                   	push   %ebp
    425b:	89 e5                	mov    %esp,%ebp
    425d:	57                   	push   %edi
    425e:	56                   	push   %esi
    425f:	53                   	push   %ebx
    4260:	83 ec 2c             	sub    $0x2c,%esp
    4263:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    4266:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4268:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    426c:	74 04                	je     4272 <printint+0x18>
    426e:	85 d2                	test   %edx,%edx
    4270:	78 3c                	js     42ae <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4272:	89 d1                	mov    %edx,%ecx
  neg = 0;
    4274:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
    427b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    4280:	89 c8                	mov    %ecx,%eax
    4282:	ba 00 00 00 00       	mov    $0x0,%edx
    4287:	f7 f6                	div    %esi
    4289:	89 df                	mov    %ebx,%edi
    428b:	43                   	inc    %ebx
    428c:	8a 92 80 5d 00 00    	mov    0x5d80(%edx),%dl
    4292:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    4296:	89 ca                	mov    %ecx,%edx
    4298:	89 c1                	mov    %eax,%ecx
    429a:	39 d6                	cmp    %edx,%esi
    429c:	76 e2                	jbe    4280 <printint+0x26>
  if(neg)
    429e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    42a2:	74 24                	je     42c8 <printint+0x6e>
    buf[i++] = '-';
    42a4:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    42a9:	8d 5f 02             	lea    0x2(%edi),%ebx
    42ac:	eb 1a                	jmp    42c8 <printint+0x6e>
    x = -xx;
    42ae:	89 d1                	mov    %edx,%ecx
    42b0:	f7 d9                	neg    %ecx
    neg = 1;
    42b2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
    42b9:	eb c0                	jmp    427b <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
    42bb:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    42c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    42c3:	e8 78 ff ff ff       	call   4240 <putc>
  while(--i >= 0)
    42c8:	4b                   	dec    %ebx
    42c9:	79 f0                	jns    42bb <printint+0x61>
}
    42cb:	83 c4 2c             	add    $0x2c,%esp
    42ce:	5b                   	pop    %ebx
    42cf:	5e                   	pop    %esi
    42d0:	5f                   	pop    %edi
    42d1:	5d                   	pop    %ebp
    42d2:	c3                   	ret    

000042d3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    42d3:	55                   	push   %ebp
    42d4:	89 e5                	mov    %esp,%ebp
    42d6:	57                   	push   %edi
    42d7:	56                   	push   %esi
    42d8:	53                   	push   %ebx
    42d9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    42dc:	8d 45 10             	lea    0x10(%ebp),%eax
    42df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    42e2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    42e7:	bb 00 00 00 00       	mov    $0x0,%ebx
    42ec:	eb 12                	jmp    4300 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    42ee:	89 fa                	mov    %edi,%edx
    42f0:	8b 45 08             	mov    0x8(%ebp),%eax
    42f3:	e8 48 ff ff ff       	call   4240 <putc>
    42f8:	eb 05                	jmp    42ff <printf+0x2c>
      }
    } else if(state == '%'){
    42fa:	83 fe 25             	cmp    $0x25,%esi
    42fd:	74 22                	je     4321 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
    42ff:	43                   	inc    %ebx
    4300:	8b 45 0c             	mov    0xc(%ebp),%eax
    4303:	8a 04 18             	mov    (%eax,%ebx,1),%al
    4306:	84 c0                	test   %al,%al
    4308:	0f 84 1d 01 00 00    	je     442b <printf+0x158>
    c = fmt[i] & 0xff;
    430e:	0f be f8             	movsbl %al,%edi
    4311:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    4314:	85 f6                	test   %esi,%esi
    4316:	75 e2                	jne    42fa <printf+0x27>
      if(c == '%'){
    4318:	83 f8 25             	cmp    $0x25,%eax
    431b:	75 d1                	jne    42ee <printf+0x1b>
        state = '%';
    431d:	89 c6                	mov    %eax,%esi
    431f:	eb de                	jmp    42ff <printf+0x2c>
      if(c == 'd'){
    4321:	83 f8 25             	cmp    $0x25,%eax
    4324:	0f 84 cc 00 00 00    	je     43f6 <printf+0x123>
    432a:	0f 8c da 00 00 00    	jl     440a <printf+0x137>
    4330:	83 f8 78             	cmp    $0x78,%eax
    4333:	0f 8f d1 00 00 00    	jg     440a <printf+0x137>
    4339:	83 f8 63             	cmp    $0x63,%eax
    433c:	0f 8c c8 00 00 00    	jl     440a <printf+0x137>
    4342:	83 e8 63             	sub    $0x63,%eax
    4345:	83 f8 15             	cmp    $0x15,%eax
    4348:	0f 87 bc 00 00 00    	ja     440a <printf+0x137>
    434e:	ff 24 85 28 5d 00 00 	jmp    *0x5d28(,%eax,4)
        printint(fd, *ap, 10, 1);
    4355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    4358:	8b 17                	mov    (%edi),%edx
    435a:	83 ec 0c             	sub    $0xc,%esp
    435d:	6a 01                	push   $0x1
    435f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    4364:	8b 45 08             	mov    0x8(%ebp),%eax
    4367:	e8 ee fe ff ff       	call   425a <printint>
        ap++;
    436c:	83 c7 04             	add    $0x4,%edi
    436f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    4372:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    4375:	be 00 00 00 00       	mov    $0x0,%esi
    437a:	eb 83                	jmp    42ff <printf+0x2c>
        printint(fd, *ap, 16, 0);
    437c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    437f:	8b 17                	mov    (%edi),%edx
    4381:	83 ec 0c             	sub    $0xc,%esp
    4384:	6a 00                	push   $0x0
    4386:	b9 10 00 00 00       	mov    $0x10,%ecx
    438b:	8b 45 08             	mov    0x8(%ebp),%eax
    438e:	e8 c7 fe ff ff       	call   425a <printint>
        ap++;
    4393:	83 c7 04             	add    $0x4,%edi
    4396:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    4399:	83 c4 10             	add    $0x10,%esp
      state = 0;
    439c:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
    43a1:	e9 59 ff ff ff       	jmp    42ff <printf+0x2c>
        s = (char*)*ap;
    43a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    43a9:	8b 30                	mov    (%eax),%esi
        ap++;
    43ab:	83 c0 04             	add    $0x4,%eax
    43ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    43b1:	85 f6                	test   %esi,%esi
    43b3:	75 13                	jne    43c8 <printf+0xf5>
          s = "(null)";
    43b5:	be 20 5d 00 00       	mov    $0x5d20,%esi
    43ba:	eb 0c                	jmp    43c8 <printf+0xf5>
          putc(fd, *s);
    43bc:	0f be d2             	movsbl %dl,%edx
    43bf:	8b 45 08             	mov    0x8(%ebp),%eax
    43c2:	e8 79 fe ff ff       	call   4240 <putc>
          s++;
    43c7:	46                   	inc    %esi
        while(*s != 0){
    43c8:	8a 16                	mov    (%esi),%dl
    43ca:	84 d2                	test   %dl,%dl
    43cc:	75 ee                	jne    43bc <printf+0xe9>
      state = 0;
    43ce:	be 00 00 00 00       	mov    $0x0,%esi
    43d3:	e9 27 ff ff ff       	jmp    42ff <printf+0x2c>
        putc(fd, *ap);
    43d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    43db:	0f be 17             	movsbl (%edi),%edx
    43de:	8b 45 08             	mov    0x8(%ebp),%eax
    43e1:	e8 5a fe ff ff       	call   4240 <putc>
        ap++;
    43e6:	83 c7 04             	add    $0x4,%edi
    43e9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    43ec:	be 00 00 00 00       	mov    $0x0,%esi
    43f1:	e9 09 ff ff ff       	jmp    42ff <printf+0x2c>
        putc(fd, c);
    43f6:	89 fa                	mov    %edi,%edx
    43f8:	8b 45 08             	mov    0x8(%ebp),%eax
    43fb:	e8 40 fe ff ff       	call   4240 <putc>
      state = 0;
    4400:	be 00 00 00 00       	mov    $0x0,%esi
    4405:	e9 f5 fe ff ff       	jmp    42ff <printf+0x2c>
        putc(fd, '%');
    440a:	ba 25 00 00 00       	mov    $0x25,%edx
    440f:	8b 45 08             	mov    0x8(%ebp),%eax
    4412:	e8 29 fe ff ff       	call   4240 <putc>
        putc(fd, c);
    4417:	89 fa                	mov    %edi,%edx
    4419:	8b 45 08             	mov    0x8(%ebp),%eax
    441c:	e8 1f fe ff ff       	call   4240 <putc>
      state = 0;
    4421:	be 00 00 00 00       	mov    $0x0,%esi
    4426:	e9 d4 fe ff ff       	jmp    42ff <printf+0x2c>
    }
  }
}
    442b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    442e:	5b                   	pop    %ebx
    442f:	5e                   	pop    %esi
    4430:	5f                   	pop    %edi
    4431:	5d                   	pop    %ebp
    4432:	c3                   	ret    

00004433 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4433:	55                   	push   %ebp
    4434:	89 e5                	mov    %esp,%ebp
    4436:	57                   	push   %edi
    4437:	56                   	push   %esi
    4438:	53                   	push   %ebx
    4439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    443c:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    443f:	a1 20 ae 00 00       	mov    0xae20,%eax
    4444:	eb 02                	jmp    4448 <free+0x15>
    4446:	89 d0                	mov    %edx,%eax
    4448:	39 c8                	cmp    %ecx,%eax
    444a:	73 04                	jae    4450 <free+0x1d>
    444c:	39 08                	cmp    %ecx,(%eax)
    444e:	77 12                	ja     4462 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4450:	8b 10                	mov    (%eax),%edx
    4452:	39 c2                	cmp    %eax,%edx
    4454:	77 f0                	ja     4446 <free+0x13>
    4456:	39 c8                	cmp    %ecx,%eax
    4458:	72 08                	jb     4462 <free+0x2f>
    445a:	39 ca                	cmp    %ecx,%edx
    445c:	77 04                	ja     4462 <free+0x2f>
    445e:	89 d0                	mov    %edx,%eax
    4460:	eb e6                	jmp    4448 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    4462:	8b 73 fc             	mov    -0x4(%ebx),%esi
    4465:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    4468:	8b 10                	mov    (%eax),%edx
    446a:	39 d7                	cmp    %edx,%edi
    446c:	74 19                	je     4487 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    446e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    4471:	8b 50 04             	mov    0x4(%eax),%edx
    4474:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    4477:	39 ce                	cmp    %ecx,%esi
    4479:	74 1b                	je     4496 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    447b:	89 08                	mov    %ecx,(%eax)
  freep = p;
    447d:	a3 20 ae 00 00       	mov    %eax,0xae20
}
    4482:	5b                   	pop    %ebx
    4483:	5e                   	pop    %esi
    4484:	5f                   	pop    %edi
    4485:	5d                   	pop    %ebp
    4486:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    4487:	03 72 04             	add    0x4(%edx),%esi
    448a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    448d:	8b 10                	mov    (%eax),%edx
    448f:	8b 12                	mov    (%edx),%edx
    4491:	89 53 f8             	mov    %edx,-0x8(%ebx)
    4494:	eb db                	jmp    4471 <free+0x3e>
    p->s.size += bp->s.size;
    4496:	03 53 fc             	add    -0x4(%ebx),%edx
    4499:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    449c:	8b 53 f8             	mov    -0x8(%ebx),%edx
    449f:	89 10                	mov    %edx,(%eax)
    44a1:	eb da                	jmp    447d <free+0x4a>

000044a3 <morecore>:

static Header*
morecore(uint nu)
{
    44a3:	55                   	push   %ebp
    44a4:	89 e5                	mov    %esp,%ebp
    44a6:	53                   	push   %ebx
    44a7:	83 ec 04             	sub    $0x4,%esp
    44aa:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    44ac:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    44b1:	77 05                	ja     44b8 <morecore+0x15>
    nu = 4096;
    44b3:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    44b8:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    44bf:	83 ec 0c             	sub    $0xc,%esp
    44c2:	50                   	push   %eax
    44c3:	e8 38 fd ff ff       	call   4200 <sbrk>
  if(p == (char*)-1)
    44c8:	83 c4 10             	add    $0x10,%esp
    44cb:	83 f8 ff             	cmp    $0xffffffff,%eax
    44ce:	74 1c                	je     44ec <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    44d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    44d3:	83 c0 08             	add    $0x8,%eax
    44d6:	83 ec 0c             	sub    $0xc,%esp
    44d9:	50                   	push   %eax
    44da:	e8 54 ff ff ff       	call   4433 <free>
  return freep;
    44df:	a1 20 ae 00 00       	mov    0xae20,%eax
    44e4:	83 c4 10             	add    $0x10,%esp
}
    44e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    44ea:	c9                   	leave  
    44eb:	c3                   	ret    
    return 0;
    44ec:	b8 00 00 00 00       	mov    $0x0,%eax
    44f1:	eb f4                	jmp    44e7 <morecore+0x44>

000044f3 <malloc>:

void*
malloc(uint nbytes)
{
    44f3:	55                   	push   %ebp
    44f4:	89 e5                	mov    %esp,%ebp
    44f6:	53                   	push   %ebx
    44f7:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    44fa:	8b 45 08             	mov    0x8(%ebp),%eax
    44fd:	8d 58 07             	lea    0x7(%eax),%ebx
    4500:	c1 eb 03             	shr    $0x3,%ebx
    4503:	43                   	inc    %ebx
  if((prevp = freep) == 0){
    4504:	8b 0d 20 ae 00 00    	mov    0xae20,%ecx
    450a:	85 c9                	test   %ecx,%ecx
    450c:	74 04                	je     4512 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    450e:	8b 01                	mov    (%ecx),%eax
    4510:	eb 4a                	jmp    455c <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
    4512:	c7 05 20 ae 00 00 24 	movl   $0xae24,0xae20
    4519:	ae 00 00 
    451c:	c7 05 24 ae 00 00 24 	movl   $0xae24,0xae24
    4523:	ae 00 00 
    base.s.size = 0;
    4526:	c7 05 28 ae 00 00 00 	movl   $0x0,0xae28
    452d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    4530:	b9 24 ae 00 00       	mov    $0xae24,%ecx
    4535:	eb d7                	jmp    450e <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    4537:	74 19                	je     4552 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    4539:	29 da                	sub    %ebx,%edx
    453b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    453e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    4541:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    4544:	89 0d 20 ae 00 00    	mov    %ecx,0xae20
      return (void*)(p + 1);
    454a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    454d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4550:	c9                   	leave  
    4551:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    4552:	8b 10                	mov    (%eax),%edx
    4554:	89 11                	mov    %edx,(%ecx)
    4556:	eb ec                	jmp    4544 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4558:	89 c1                	mov    %eax,%ecx
    455a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    455c:	8b 50 04             	mov    0x4(%eax),%edx
    455f:	39 da                	cmp    %ebx,%edx
    4561:	73 d4                	jae    4537 <malloc+0x44>
    if(p == freep)
    4563:	39 05 20 ae 00 00    	cmp    %eax,0xae20
    4569:	75 ed                	jne    4558 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
    456b:	89 d8                	mov    %ebx,%eax
    456d:	e8 31 ff ff ff       	call   44a3 <morecore>
    4572:	85 c0                	test   %eax,%eax
    4574:	75 e2                	jne    4558 <malloc+0x65>
    4576:	eb d5                	jmp    454d <malloc+0x5a>
