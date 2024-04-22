
sh:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	8b 5d 08             	mov    0x8(%ebp),%ebx
       8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 14 10 00 00       	push   $0x1014
      13:	6a 02                	push   $0x2
      15:	e8 55 0d 00 00       	call   d6f <printf>
  memset(buf, 0, nbuf);
      1a:	83 c4 0c             	add    $0xc,%esp
      1d:	56                   	push   %esi
      1e:	6a 00                	push   $0x0
      20:	53                   	push   %ebx
      21:	e8 c3 0a 00 00       	call   ae9 <memset>
  gets(buf, nbuf);
      26:	83 c4 08             	add    $0x8,%esp
      29:	56                   	push   %esi
      2a:	53                   	push   %ebx
      2b:	e8 f0 0a 00 00       	call   b20 <gets>
  if(buf[0] == 0) // EOF
      30:	83 c4 10             	add    $0x10,%esp
      33:	80 3b 00             	cmpb   $0x0,(%ebx)
      36:	74 0c                	je     44 <getcmd+0x44>
    return -1;
  return 0;
      38:	b8 00 00 00 00       	mov    $0x0,%eax
}
      3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
      40:	5b                   	pop    %ebx
      41:	5e                   	pop    %esi
      42:	5d                   	pop    %ebp
      43:	c3                   	ret    
    return -1;
      44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      49:	eb f2                	jmp    3d <getcmd+0x3d>

0000004b <panic>:
  exit(0);
}

void
panic(char *s)
{
      4b:	55                   	push   %ebp
      4c:	89 e5                	mov    %esp,%ebp
      4e:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
      51:	ff 75 08             	push   0x8(%ebp)
      54:	68 b1 10 00 00       	push   $0x10b1
      59:	6a 02                	push   $0x2
      5b:	e8 0f 0d 00 00       	call   d6f <printf>
  exit(0);
      60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      67:	e8 a8 0b 00 00       	call   c14 <exit>
}
      6c:	83 c4 10             	add    $0x10,%esp
      6f:	c9                   	leave  
      70:	c3                   	ret    

00000071 <fork1>:

int
fork1(void)
{
      71:	55                   	push   %ebp
      72:	89 e5                	mov    %esp,%ebp
      74:	53                   	push   %ebx
      75:	83 ec 04             	sub    $0x4,%esp
  int pid;

  pid = fork();
      78:	e8 8f 0b 00 00       	call   c0c <fork>
      7d:	89 c3                	mov    %eax,%ebx
  if(pid == -1)
      7f:	83 f8 ff             	cmp    $0xffffffff,%eax
      82:	74 07                	je     8b <fork1+0x1a>
    panic("fork");
  return pid;
}
      84:	89 d8                	mov    %ebx,%eax
      86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      89:	c9                   	leave  
      8a:	c3                   	ret    
    panic("fork");
      8b:	83 ec 0c             	sub    $0xc,%esp
      8e:	68 17 10 00 00       	push   $0x1017
      93:	e8 b3 ff ff ff       	call   4b <panic>
      98:	83 c4 10             	add    $0x10,%esp
  return pid;
      9b:	eb e7                	jmp    84 <fork1+0x13>

0000009d <runcmd>:
{
      9d:	55                   	push   %ebp
      9e:	89 e5                	mov    %esp,%ebp
      a0:	53                   	push   %ebx
      a1:	83 ec 14             	sub    $0x14,%esp
      a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
      a7:	85 db                	test   %ebx,%ebx
      a9:	74 0e                	je     b9 <runcmd+0x1c>
  switch(cmd->type){
      ab:	8b 03                	mov    (%ebx),%eax
      ad:	83 f8 05             	cmp    $0x5,%eax
      b0:	77 16                	ja     c8 <runcmd+0x2b>
      b2:	ff 24 85 e0 10 00 00 	jmp    *0x10e0(,%eax,4)
    exit(0);
      b9:	83 ec 0c             	sub    $0xc,%esp
      bc:	6a 00                	push   $0x0
      be:	e8 51 0b 00 00       	call   c14 <exit>
      c3:	83 c4 10             	add    $0x10,%esp
      c6:	eb e3                	jmp    ab <runcmd+0xe>
    panic("runcmd");
      c8:	83 ec 0c             	sub    $0xc,%esp
      cb:	68 1c 10 00 00       	push   $0x101c
      d0:	e8 76 ff ff ff       	call   4b <panic>
      d5:	83 c4 10             	add    $0x10,%esp
    if(ecmd->argv[0] == 0)
      d8:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
      dc:	74 36                	je     114 <runcmd+0x77>
    exec(ecmd->argv[0], ecmd->argv);
      de:	8d 43 04             	lea    0x4(%ebx),%eax
      e1:	83 ec 08             	sub    $0x8,%esp
      e4:	50                   	push   %eax
      e5:	ff 73 04             	push   0x4(%ebx)
      e8:	e8 5f 0b 00 00       	call   c4c <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      ed:	83 c4 0c             	add    $0xc,%esp
      f0:	ff 73 04             	push   0x4(%ebx)
      f3:	68 23 10 00 00       	push   $0x1023
      f8:	6a 02                	push   $0x2
      fa:	e8 70 0c 00 00       	call   d6f <printf>
    break;
      ff:	83 c4 10             	add    $0x10,%esp
  exit(0);
     102:	83 ec 0c             	sub    $0xc,%esp
     105:	6a 00                	push   $0x0
     107:	e8 08 0b 00 00       	call   c14 <exit>
}
     10c:	83 c4 10             	add    $0x10,%esp
     10f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     112:	c9                   	leave  
     113:	c3                   	ret    
      exit(0);
     114:	83 ec 0c             	sub    $0xc,%esp
     117:	6a 00                	push   $0x0
     119:	e8 f6 0a 00 00       	call   c14 <exit>
     11e:	83 c4 10             	add    $0x10,%esp
     121:	eb bb                	jmp    de <runcmd+0x41>
    close(rcmd->fd);
     123:	83 ec 0c             	sub    $0xc,%esp
     126:	ff 73 14             	push   0x14(%ebx)
     129:	e8 0e 0b 00 00       	call   c3c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     12e:	83 c4 08             	add    $0x8,%esp
     131:	ff 73 10             	push   0x10(%ebx)
     134:	ff 73 08             	push   0x8(%ebx)
     137:	e8 18 0b 00 00       	call   c54 <open>
     13c:	83 c4 10             	add    $0x10,%esp
     13f:	85 c0                	test   %eax,%eax
     141:	78 10                	js     153 <runcmd+0xb6>
    runcmd(rcmd->cmd);
     143:	83 ec 0c             	sub    $0xc,%esp
     146:	ff 73 04             	push   0x4(%ebx)
     149:	e8 4f ff ff ff       	call   9d <runcmd>
    break;
     14e:	83 c4 10             	add    $0x10,%esp
     151:	eb af                	jmp    102 <runcmd+0x65>
      printf(2, "open %s failed\n", rcmd->file);
     153:	83 ec 04             	sub    $0x4,%esp
     156:	ff 73 08             	push   0x8(%ebx)
     159:	68 33 10 00 00       	push   $0x1033
     15e:	6a 02                	push   $0x2
     160:	e8 0a 0c 00 00       	call   d6f <printf>
      exit(0);
     165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     16c:	e8 a3 0a 00 00       	call   c14 <exit>
     171:	83 c4 10             	add    $0x10,%esp
     174:	eb cd                	jmp    143 <runcmd+0xa6>
    if(fork1() == 0)
     176:	e8 f6 fe ff ff       	call   71 <fork1>
     17b:	85 c0                	test   %eax,%eax
     17d:	74 1d                	je     19c <runcmd+0xff>
    wait(NULL);
     17f:	83 ec 0c             	sub    $0xc,%esp
     182:	6a 00                	push   $0x0
     184:	e8 93 0a 00 00       	call   c1c <wait>
    runcmd(lcmd->right);
     189:	83 c4 04             	add    $0x4,%esp
     18c:	ff 73 08             	push   0x8(%ebx)
     18f:	e8 09 ff ff ff       	call   9d <runcmd>
    break;
     194:	83 c4 10             	add    $0x10,%esp
     197:	e9 66 ff ff ff       	jmp    102 <runcmd+0x65>
      runcmd(lcmd->left);
     19c:	83 ec 0c             	sub    $0xc,%esp
     19f:	ff 73 04             	push   0x4(%ebx)
     1a2:	e8 f6 fe ff ff       	call   9d <runcmd>
     1a7:	83 c4 10             	add    $0x10,%esp
     1aa:	eb d3                	jmp    17f <runcmd+0xe2>
    if(pipe(p) < 0)
     1ac:	83 ec 0c             	sub    $0xc,%esp
     1af:	8d 45 f0             	lea    -0x10(%ebp),%eax
     1b2:	50                   	push   %eax
     1b3:	e8 6c 0a 00 00       	call   c24 <pipe>
     1b8:	83 c4 10             	add    $0x10,%esp
     1bb:	85 c0                	test   %eax,%eax
     1bd:	78 4c                	js     20b <runcmd+0x16e>
    if(fork1() == 0){
     1bf:	e8 ad fe ff ff       	call   71 <fork1>
     1c4:	85 c0                	test   %eax,%eax
     1c6:	74 55                	je     21d <runcmd+0x180>
    if(fork1() == 0){
     1c8:	e8 a4 fe ff ff       	call   71 <fork1>
     1cd:	85 c0                	test   %eax,%eax
     1cf:	0f 84 86 00 00 00    	je     25b <runcmd+0x1be>
    close(p[0]);
     1d5:	83 ec 0c             	sub    $0xc,%esp
     1d8:	ff 75 f0             	push   -0x10(%ebp)
     1db:	e8 5c 0a 00 00       	call   c3c <close>
    close(p[1]);
     1e0:	83 c4 04             	add    $0x4,%esp
     1e3:	ff 75 f4             	push   -0xc(%ebp)
     1e6:	e8 51 0a 00 00       	call   c3c <close>
    wait(NULL);
     1eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1f2:	e8 25 0a 00 00       	call   c1c <wait>
    wait(NULL);
     1f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1fe:	e8 19 0a 00 00       	call   c1c <wait>
    break;
     203:	83 c4 10             	add    $0x10,%esp
     206:	e9 f7 fe ff ff       	jmp    102 <runcmd+0x65>
      panic("pipe");
     20b:	83 ec 0c             	sub    $0xc,%esp
     20e:	68 43 10 00 00       	push   $0x1043
     213:	e8 33 fe ff ff       	call   4b <panic>
     218:	83 c4 10             	add    $0x10,%esp
     21b:	eb a2                	jmp    1bf <runcmd+0x122>
      close(1);
     21d:	83 ec 0c             	sub    $0xc,%esp
     220:	6a 01                	push   $0x1
     222:	e8 15 0a 00 00       	call   c3c <close>
      dup(p[1]);
     227:	83 c4 04             	add    $0x4,%esp
     22a:	ff 75 f4             	push   -0xc(%ebp)
     22d:	e8 5a 0a 00 00       	call   c8c <dup>
      close(p[0]);
     232:	83 c4 04             	add    $0x4,%esp
     235:	ff 75 f0             	push   -0x10(%ebp)
     238:	e8 ff 09 00 00       	call   c3c <close>
      close(p[1]);
     23d:	83 c4 04             	add    $0x4,%esp
     240:	ff 75 f4             	push   -0xc(%ebp)
     243:	e8 f4 09 00 00       	call   c3c <close>
      runcmd(pcmd->left);
     248:	83 c4 04             	add    $0x4,%esp
     24b:	ff 73 04             	push   0x4(%ebx)
     24e:	e8 4a fe ff ff       	call   9d <runcmd>
     253:	83 c4 10             	add    $0x10,%esp
     256:	e9 6d ff ff ff       	jmp    1c8 <runcmd+0x12b>
      close(0);
     25b:	83 ec 0c             	sub    $0xc,%esp
     25e:	6a 00                	push   $0x0
     260:	e8 d7 09 00 00       	call   c3c <close>
      dup(p[0]);
     265:	83 c4 04             	add    $0x4,%esp
     268:	ff 75 f0             	push   -0x10(%ebp)
     26b:	e8 1c 0a 00 00       	call   c8c <dup>
      close(p[0]);
     270:	83 c4 04             	add    $0x4,%esp
     273:	ff 75 f0             	push   -0x10(%ebp)
     276:	e8 c1 09 00 00       	call   c3c <close>
      close(p[1]);
     27b:	83 c4 04             	add    $0x4,%esp
     27e:	ff 75 f4             	push   -0xc(%ebp)
     281:	e8 b6 09 00 00       	call   c3c <close>
      runcmd(pcmd->right);
     286:	83 c4 04             	add    $0x4,%esp
     289:	ff 73 08             	push   0x8(%ebx)
     28c:	e8 0c fe ff ff       	call   9d <runcmd>
     291:	83 c4 10             	add    $0x10,%esp
     294:	e9 3c ff ff ff       	jmp    1d5 <runcmd+0x138>
    if(fork1() == 0)
     299:	e8 d3 fd ff ff       	call   71 <fork1>
     29e:	85 c0                	test   %eax,%eax
     2a0:	0f 85 5c fe ff ff    	jne    102 <runcmd+0x65>
      runcmd(bcmd->cmd);
     2a6:	83 ec 0c             	sub    $0xc,%esp
     2a9:	ff 73 04             	push   0x4(%ebx)
     2ac:	e8 ec fd ff ff       	call   9d <runcmd>
     2b1:	83 c4 10             	add    $0x10,%esp
     2b4:	e9 49 fe ff ff       	jmp    102 <runcmd+0x65>

000002b9 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     2b9:	55                   	push   %ebp
     2ba:	89 e5                	mov    %esp,%ebp
     2bc:	53                   	push   %ebx
     2bd:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2c0:	6a 54                	push   $0x54
     2c2:	e8 c8 0c 00 00       	call   f8f <malloc>
     2c7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2c9:	83 c4 0c             	add    $0xc,%esp
     2cc:	6a 54                	push   $0x54
     2ce:	6a 00                	push   $0x0
     2d0:	50                   	push   %eax
     2d1:	e8 13 08 00 00       	call   ae9 <memset>
  cmd->type = EXEC;
     2d6:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     2dc:	89 d8                	mov    %ebx,%eax
     2de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2e1:	c9                   	leave  
     2e2:	c3                   	ret    

000002e3 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2e3:	55                   	push   %ebp
     2e4:	89 e5                	mov    %esp,%ebp
     2e6:	53                   	push   %ebx
     2e7:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	6a 18                	push   $0x18
     2ec:	e8 9e 0c 00 00       	call   f8f <malloc>
     2f1:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2f3:	83 c4 0c             	add    $0xc,%esp
     2f6:	6a 18                	push   $0x18
     2f8:	6a 00                	push   $0x0
     2fa:	50                   	push   %eax
     2fb:	e8 e9 07 00 00       	call   ae9 <memset>
  cmd->type = REDIR;
     300:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     306:	8b 45 08             	mov    0x8(%ebp),%eax
     309:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     30c:	8b 45 0c             	mov    0xc(%ebp),%eax
     30f:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     312:	8b 45 10             	mov    0x10(%ebp),%eax
     315:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     318:	8b 45 14             	mov    0x14(%ebp),%eax
     31b:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     31e:	8b 45 18             	mov    0x18(%ebp),%eax
     321:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     324:	89 d8                	mov    %ebx,%eax
     326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     329:	c9                   	leave  
     32a:	c3                   	ret    

0000032b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     32b:	55                   	push   %ebp
     32c:	89 e5                	mov    %esp,%ebp
     32e:	53                   	push   %ebx
     32f:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     332:	6a 0c                	push   $0xc
     334:	e8 56 0c 00 00       	call   f8f <malloc>
     339:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     33b:	83 c4 0c             	add    $0xc,%esp
     33e:	6a 0c                	push   $0xc
     340:	6a 00                	push   $0x0
     342:	50                   	push   %eax
     343:	e8 a1 07 00 00       	call   ae9 <memset>
  cmd->type = PIPE;
     348:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     34e:	8b 45 08             	mov    0x8(%ebp),%eax
     351:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     354:	8b 45 0c             	mov    0xc(%ebp),%eax
     357:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     35a:	89 d8                	mov    %ebx,%eax
     35c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     35f:	c9                   	leave  
     360:	c3                   	ret    

00000361 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     361:	55                   	push   %ebp
     362:	89 e5                	mov    %esp,%ebp
     364:	53                   	push   %ebx
     365:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     368:	6a 0c                	push   $0xc
     36a:	e8 20 0c 00 00       	call   f8f <malloc>
     36f:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     371:	83 c4 0c             	add    $0xc,%esp
     374:	6a 0c                	push   $0xc
     376:	6a 00                	push   $0x0
     378:	50                   	push   %eax
     379:	e8 6b 07 00 00       	call   ae9 <memset>
  cmd->type = LIST;
     37e:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     384:	8b 45 08             	mov    0x8(%ebp),%eax
     387:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     38a:	8b 45 0c             	mov    0xc(%ebp),%eax
     38d:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     390:	89 d8                	mov    %ebx,%eax
     392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     395:	c9                   	leave  
     396:	c3                   	ret    

00000397 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     397:	55                   	push   %ebp
     398:	89 e5                	mov    %esp,%ebp
     39a:	53                   	push   %ebx
     39b:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     39e:	6a 08                	push   $0x8
     3a0:	e8 ea 0b 00 00       	call   f8f <malloc>
     3a5:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3a7:	83 c4 0c             	add    $0xc,%esp
     3aa:	6a 08                	push   $0x8
     3ac:	6a 00                	push   $0x0
     3ae:	50                   	push   %eax
     3af:	e8 35 07 00 00       	call   ae9 <memset>
  cmd->type = BACK;
     3b4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     3ba:	8b 45 08             	mov    0x8(%ebp),%eax
     3bd:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     3c0:	89 d8                	mov    %ebx,%eax
     3c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3c5:	c9                   	leave  
     3c6:	c3                   	ret    

000003c7 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3c7:	55                   	push   %ebp
     3c8:	89 e5                	mov    %esp,%ebp
     3ca:	57                   	push   %edi
     3cb:	56                   	push   %esi
     3cc:	53                   	push   %ebx
     3cd:	83 ec 0c             	sub    $0xc,%esp
     3d0:	8b 75 0c             	mov    0xc(%ebp),%esi
     3d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     3d6:	8b 45 08             	mov    0x8(%ebp),%eax
     3d9:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     3db:	eb 01                	jmp    3de <gettoken+0x17>
    s++;
     3dd:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
     3de:	39 f3                	cmp    %esi,%ebx
     3e0:	73 18                	jae    3fa <gettoken+0x33>
     3e2:	83 ec 08             	sub    $0x8,%esp
     3e5:	0f be 03             	movsbl (%ebx),%eax
     3e8:	50                   	push   %eax
     3e9:	68 14 17 00 00       	push   $0x1714
     3ee:	e8 0e 07 00 00       	call   b01 <strchr>
     3f3:	83 c4 10             	add    $0x10,%esp
     3f6:	85 c0                	test   %eax,%eax
     3f8:	75 e3                	jne    3dd <gettoken+0x16>
  if(q)
     3fa:	85 ff                	test   %edi,%edi
     3fc:	74 02                	je     400 <gettoken+0x39>
    *q = s;
     3fe:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     400:	8a 03                	mov    (%ebx),%al
     402:	0f be f8             	movsbl %al,%edi
  switch(*s){
     405:	3c 3c                	cmp    $0x3c,%al
     407:	7f 25                	jg     42e <gettoken+0x67>
     409:	3c 3b                	cmp    $0x3b,%al
     40b:	7d 13                	jge    420 <gettoken+0x59>
     40d:	84 c0                	test   %al,%al
     40f:	74 10                	je     421 <gettoken+0x5a>
     411:	78 3d                	js     450 <gettoken+0x89>
     413:	3c 26                	cmp    $0x26,%al
     415:	74 09                	je     420 <gettoken+0x59>
     417:	7c 37                	jl     450 <gettoken+0x89>
     419:	83 e8 28             	sub    $0x28,%eax
     41c:	3c 01                	cmp    $0x1,%al
     41e:	77 30                	ja     450 <gettoken+0x89>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     420:	43                   	inc    %ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     421:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     425:	74 73                	je     49a <gettoken+0xd3>
    *eq = s;
     427:	8b 45 14             	mov    0x14(%ebp),%eax
     42a:	89 18                	mov    %ebx,(%eax)
     42c:	eb 6c                	jmp    49a <gettoken+0xd3>
  switch(*s){
     42e:	3c 3e                	cmp    $0x3e,%al
     430:	75 0d                	jne    43f <gettoken+0x78>
    s++;
     432:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
     435:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     439:	74 0a                	je     445 <gettoken+0x7e>
    s++;
     43b:	89 c3                	mov    %eax,%ebx
     43d:	eb e2                	jmp    421 <gettoken+0x5a>
  switch(*s){
     43f:	3c 7c                	cmp    $0x7c,%al
     441:	75 0d                	jne    450 <gettoken+0x89>
     443:	eb db                	jmp    420 <gettoken+0x59>
      s++;
     445:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
     448:	bf 2b 00 00 00       	mov    $0x2b,%edi
     44d:	eb d2                	jmp    421 <gettoken+0x5a>
      s++;
     44f:	43                   	inc    %ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     450:	39 f3                	cmp    %esi,%ebx
     452:	73 37                	jae    48b <gettoken+0xc4>
     454:	83 ec 08             	sub    $0x8,%esp
     457:	0f be 03             	movsbl (%ebx),%eax
     45a:	50                   	push   %eax
     45b:	68 14 17 00 00       	push   $0x1714
     460:	e8 9c 06 00 00       	call   b01 <strchr>
     465:	83 c4 10             	add    $0x10,%esp
     468:	85 c0                	test   %eax,%eax
     46a:	75 26                	jne    492 <gettoken+0xcb>
     46c:	83 ec 08             	sub    $0x8,%esp
     46f:	0f be 03             	movsbl (%ebx),%eax
     472:	50                   	push   %eax
     473:	68 0c 17 00 00       	push   $0x170c
     478:	e8 84 06 00 00       	call   b01 <strchr>
     47d:	83 c4 10             	add    $0x10,%esp
     480:	85 c0                	test   %eax,%eax
     482:	74 cb                	je     44f <gettoken+0x88>
    ret = 'a';
     484:	bf 61 00 00 00       	mov    $0x61,%edi
     489:	eb 96                	jmp    421 <gettoken+0x5a>
     48b:	bf 61 00 00 00       	mov    $0x61,%edi
     490:	eb 8f                	jmp    421 <gettoken+0x5a>
     492:	bf 61 00 00 00       	mov    $0x61,%edi
     497:	eb 88                	jmp    421 <gettoken+0x5a>

  while(s < es && strchr(whitespace, *s))
    s++;
     499:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
     49a:	39 f3                	cmp    %esi,%ebx
     49c:	73 18                	jae    4b6 <gettoken+0xef>
     49e:	83 ec 08             	sub    $0x8,%esp
     4a1:	0f be 03             	movsbl (%ebx),%eax
     4a4:	50                   	push   %eax
     4a5:	68 14 17 00 00       	push   $0x1714
     4aa:	e8 52 06 00 00       	call   b01 <strchr>
     4af:	83 c4 10             	add    $0x10,%esp
     4b2:	85 c0                	test   %eax,%eax
     4b4:	75 e3                	jne    499 <gettoken+0xd2>
  *ps = s;
     4b6:	8b 45 08             	mov    0x8(%ebp),%eax
     4b9:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     4bb:	89 f8                	mov    %edi,%eax
     4bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4c0:	5b                   	pop    %ebx
     4c1:	5e                   	pop    %esi
     4c2:	5f                   	pop    %edi
     4c3:	5d                   	pop    %ebp
     4c4:	c3                   	ret    

000004c5 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     4c5:	55                   	push   %ebp
     4c6:	89 e5                	mov    %esp,%ebp
     4c8:	57                   	push   %edi
     4c9:	56                   	push   %esi
     4ca:	53                   	push   %ebx
     4cb:	83 ec 0c             	sub    $0xc,%esp
     4ce:	8b 7d 08             	mov    0x8(%ebp),%edi
     4d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     4d4:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     4d6:	eb 01                	jmp    4d9 <peek+0x14>
    s++;
     4d8:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
     4d9:	39 f3                	cmp    %esi,%ebx
     4db:	73 18                	jae    4f5 <peek+0x30>
     4dd:	83 ec 08             	sub    $0x8,%esp
     4e0:	0f be 03             	movsbl (%ebx),%eax
     4e3:	50                   	push   %eax
     4e4:	68 14 17 00 00       	push   $0x1714
     4e9:	e8 13 06 00 00       	call   b01 <strchr>
     4ee:	83 c4 10             	add    $0x10,%esp
     4f1:	85 c0                	test   %eax,%eax
     4f3:	75 e3                	jne    4d8 <peek+0x13>
  *ps = s;
     4f5:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     4f7:	8a 03                	mov    (%ebx),%al
     4f9:	84 c0                	test   %al,%al
     4fb:	75 0d                	jne    50a <peek+0x45>
     4fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     502:	8d 65 f4             	lea    -0xc(%ebp),%esp
     505:	5b                   	pop    %ebx
     506:	5e                   	pop    %esi
     507:	5f                   	pop    %edi
     508:	5d                   	pop    %ebp
     509:	c3                   	ret    
  return *s && strchr(toks, *s);
     50a:	83 ec 08             	sub    $0x8,%esp
     50d:	0f be c0             	movsbl %al,%eax
     510:	50                   	push   %eax
     511:	ff 75 10             	push   0x10(%ebp)
     514:	e8 e8 05 00 00       	call   b01 <strchr>
     519:	83 c4 10             	add    $0x10,%esp
     51c:	85 c0                	test   %eax,%eax
     51e:	74 07                	je     527 <peek+0x62>
     520:	b8 01 00 00 00       	mov    $0x1,%eax
     525:	eb db                	jmp    502 <peek+0x3d>
     527:	b8 00 00 00 00       	mov    $0x0,%eax
     52c:	eb d4                	jmp    502 <peek+0x3d>

0000052e <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     52e:	55                   	push   %ebp
     52f:	89 e5                	mov    %esp,%ebp
     531:	57                   	push   %edi
     532:	56                   	push   %esi
     533:	53                   	push   %ebx
     534:	83 ec 1c             	sub    $0x1c,%esp
     537:	8b 7d 0c             	mov    0xc(%ebp),%edi
     53a:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     53d:	eb 13                	jmp    552 <parseredirs+0x24>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
     53f:	83 fb 3c             	cmp    $0x3c,%ebx
     542:	74 5e                	je     5a2 <parseredirs+0x74>
     544:	83 fb 3e             	cmp    $0x3e,%ebx
     547:	74 76                	je     5bf <parseredirs+0x91>
     549:	83 fb 2b             	cmp    $0x2b,%ebx
     54c:	0f 84 90 00 00 00    	je     5e2 <parseredirs+0xb4>
  while(peek(ps, es, "<>")){
     552:	83 ec 04             	sub    $0x4,%esp
     555:	68 65 10 00 00       	push   $0x1065
     55a:	56                   	push   %esi
     55b:	57                   	push   %edi
     55c:	e8 64 ff ff ff       	call   4c5 <peek>
     561:	83 c4 10             	add    $0x10,%esp
     564:	85 c0                	test   %eax,%eax
     566:	0f 84 99 00 00 00    	je     605 <parseredirs+0xd7>
    tok = gettoken(ps, es, 0, 0);
     56c:	6a 00                	push   $0x0
     56e:	6a 00                	push   $0x0
     570:	56                   	push   %esi
     571:	57                   	push   %edi
     572:	e8 50 fe ff ff       	call   3c7 <gettoken>
     577:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     579:	8d 45 e0             	lea    -0x20(%ebp),%eax
     57c:	50                   	push   %eax
     57d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     580:	50                   	push   %eax
     581:	56                   	push   %esi
     582:	57                   	push   %edi
     583:	e8 3f fe ff ff       	call   3c7 <gettoken>
     588:	83 c4 20             	add    $0x20,%esp
     58b:	83 f8 61             	cmp    $0x61,%eax
     58e:	74 af                	je     53f <parseredirs+0x11>
      panic("missing file for redirection");
     590:	83 ec 0c             	sub    $0xc,%esp
     593:	68 48 10 00 00       	push   $0x1048
     598:	e8 ae fa ff ff       	call   4b <panic>
     59d:	83 c4 10             	add    $0x10,%esp
     5a0:	eb 9d                	jmp    53f <parseredirs+0x11>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5a2:	83 ec 0c             	sub    $0xc,%esp
     5a5:	6a 00                	push   $0x0
     5a7:	6a 00                	push   $0x0
     5a9:	ff 75 e0             	push   -0x20(%ebp)
     5ac:	ff 75 e4             	push   -0x1c(%ebp)
     5af:	ff 75 08             	push   0x8(%ebp)
     5b2:	e8 2c fd ff ff       	call   2e3 <redircmd>
     5b7:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     5ba:	83 c4 20             	add    $0x20,%esp
     5bd:	eb 93                	jmp    552 <parseredirs+0x24>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     5bf:	83 ec 0c             	sub    $0xc,%esp
     5c2:	6a 01                	push   $0x1
     5c4:	68 01 02 00 00       	push   $0x201
     5c9:	ff 75 e0             	push   -0x20(%ebp)
     5cc:	ff 75 e4             	push   -0x1c(%ebp)
     5cf:	ff 75 08             	push   0x8(%ebp)
     5d2:	e8 0c fd ff ff       	call   2e3 <redircmd>
     5d7:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     5da:	83 c4 20             	add    $0x20,%esp
     5dd:	e9 70 ff ff ff       	jmp    552 <parseredirs+0x24>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     5e2:	83 ec 0c             	sub    $0xc,%esp
     5e5:	6a 01                	push   $0x1
     5e7:	68 01 02 00 00       	push   $0x201
     5ec:	ff 75 e0             	push   -0x20(%ebp)
     5ef:	ff 75 e4             	push   -0x1c(%ebp)
     5f2:	ff 75 08             	push   0x8(%ebp)
     5f5:	e8 e9 fc ff ff       	call   2e3 <redircmd>
     5fa:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     5fd:	83 c4 20             	add    $0x20,%esp
     600:	e9 4d ff ff ff       	jmp    552 <parseredirs+0x24>
    }
  }
  return cmd;
}
     605:	8b 45 08             	mov    0x8(%ebp),%eax
     608:	8d 65 f4             	lea    -0xc(%ebp),%esp
     60b:	5b                   	pop    %ebx
     60c:	5e                   	pop    %esi
     60d:	5f                   	pop    %edi
     60e:	5d                   	pop    %ebp
     60f:	c3                   	ret    

00000610 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     610:	55                   	push   %ebp
     611:	89 e5                	mov    %esp,%ebp
     613:	57                   	push   %edi
     614:	56                   	push   %esi
     615:	53                   	push   %ebx
     616:	83 ec 30             	sub    $0x30,%esp
     619:	8b 75 08             	mov    0x8(%ebp),%esi
     61c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     61f:	68 68 10 00 00       	push   $0x1068
     624:	57                   	push   %edi
     625:	56                   	push   %esi
     626:	e8 9a fe ff ff       	call   4c5 <peek>
     62b:	83 c4 10             	add    $0x10,%esp
     62e:	85 c0                	test   %eax,%eax
     630:	75 1d                	jne    64f <parseexec+0x3f>
     632:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     634:	e8 80 fc ff ff       	call   2b9 <execcmd>
     639:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     63c:	83 ec 04             	sub    $0x4,%esp
     63f:	57                   	push   %edi
     640:	56                   	push   %esi
     641:	50                   	push   %eax
     642:	e8 e7 fe ff ff       	call   52e <parseredirs>
     647:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     64a:	83 c4 10             	add    $0x10,%esp
     64d:	eb 3f                	jmp    68e <parseexec+0x7e>
    return parseblock(ps, es);
     64f:	83 ec 08             	sub    $0x8,%esp
     652:	57                   	push   %edi
     653:	56                   	push   %esi
     654:	e8 97 01 00 00       	call   7f0 <parseblock>
     659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     65c:	83 c4 10             	add    $0x10,%esp
     65f:	e9 92 00 00 00       	jmp    6f6 <parseexec+0xe6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
     664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     667:	8b 55 d0             	mov    -0x30(%ebp),%edx
     66a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     66e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     671:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     675:	43                   	inc    %ebx
    if(argc >= MAXARGS)
     676:	83 fb 09             	cmp    $0x9,%ebx
     679:	7f 56                	jg     6d1 <parseexec+0xc1>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     67b:	83 ec 04             	sub    $0x4,%esp
     67e:	57                   	push   %edi
     67f:	56                   	push   %esi
     680:	ff 75 d4             	push   -0x2c(%ebp)
     683:	e8 a6 fe ff ff       	call   52e <parseredirs>
     688:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     68b:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
     68e:	83 ec 04             	sub    $0x4,%esp
     691:	68 7f 10 00 00       	push   $0x107f
     696:	57                   	push   %edi
     697:	56                   	push   %esi
     698:	e8 28 fe ff ff       	call   4c5 <peek>
     69d:	83 c4 10             	add    $0x10,%esp
     6a0:	85 c0                	test   %eax,%eax
     6a2:	75 3f                	jne    6e3 <parseexec+0xd3>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     6a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
     6a7:	50                   	push   %eax
     6a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     6ab:	50                   	push   %eax
     6ac:	57                   	push   %edi
     6ad:	56                   	push   %esi
     6ae:	e8 14 fd ff ff       	call   3c7 <gettoken>
     6b3:	83 c4 10             	add    $0x10,%esp
     6b6:	85 c0                	test   %eax,%eax
     6b8:	74 29                	je     6e3 <parseexec+0xd3>
    if(tok != 'a')
     6ba:	83 f8 61             	cmp    $0x61,%eax
     6bd:	74 a5                	je     664 <parseexec+0x54>
      panic("syntax");
     6bf:	83 ec 0c             	sub    $0xc,%esp
     6c2:	68 6a 10 00 00       	push   $0x106a
     6c7:	e8 7f f9 ff ff       	call   4b <panic>
     6cc:	83 c4 10             	add    $0x10,%esp
     6cf:	eb 93                	jmp    664 <parseexec+0x54>
      panic("too many args");
     6d1:	83 ec 0c             	sub    $0xc,%esp
     6d4:	68 71 10 00 00       	push   $0x1071
     6d9:	e8 6d f9 ff ff       	call   4b <panic>
     6de:	83 c4 10             	add    $0x10,%esp
     6e1:	eb 98                	jmp    67b <parseexec+0x6b>
  }
  cmd->argv[argc] = 0;
     6e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
     6e6:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     6ed:	00 
  cmd->eargv[argc] = 0;
     6ee:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     6f5:	00 
  return ret;
}
     6f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6fc:	5b                   	pop    %ebx
     6fd:	5e                   	pop    %esi
     6fe:	5f                   	pop    %edi
     6ff:	5d                   	pop    %ebp
     700:	c3                   	ret    

00000701 <parsepipe>:
{
     701:	55                   	push   %ebp
     702:	89 e5                	mov    %esp,%ebp
     704:	57                   	push   %edi
     705:	56                   	push   %esi
     706:	53                   	push   %ebx
     707:	83 ec 14             	sub    $0x14,%esp
     70a:	8b 75 08             	mov    0x8(%ebp),%esi
     70d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     710:	57                   	push   %edi
     711:	56                   	push   %esi
     712:	e8 f9 fe ff ff       	call   610 <parseexec>
     717:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     719:	83 c4 0c             	add    $0xc,%esp
     71c:	68 84 10 00 00       	push   $0x1084
     721:	57                   	push   %edi
     722:	56                   	push   %esi
     723:	e8 9d fd ff ff       	call   4c5 <peek>
     728:	83 c4 10             	add    $0x10,%esp
     72b:	85 c0                	test   %eax,%eax
     72d:	75 0a                	jne    739 <parsepipe+0x38>
}
     72f:	89 d8                	mov    %ebx,%eax
     731:	8d 65 f4             	lea    -0xc(%ebp),%esp
     734:	5b                   	pop    %ebx
     735:	5e                   	pop    %esi
     736:	5f                   	pop    %edi
     737:	5d                   	pop    %ebp
     738:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     739:	6a 00                	push   $0x0
     73b:	6a 00                	push   $0x0
     73d:	57                   	push   %edi
     73e:	56                   	push   %esi
     73f:	e8 83 fc ff ff       	call   3c7 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     744:	83 c4 08             	add    $0x8,%esp
     747:	57                   	push   %edi
     748:	56                   	push   %esi
     749:	e8 b3 ff ff ff       	call   701 <parsepipe>
     74e:	83 c4 08             	add    $0x8,%esp
     751:	50                   	push   %eax
     752:	53                   	push   %ebx
     753:	e8 d3 fb ff ff       	call   32b <pipecmd>
     758:	89 c3                	mov    %eax,%ebx
     75a:	83 c4 10             	add    $0x10,%esp
  return cmd;
     75d:	eb d0                	jmp    72f <parsepipe+0x2e>

0000075f <parseline>:
{
     75f:	55                   	push   %ebp
     760:	89 e5                	mov    %esp,%ebp
     762:	57                   	push   %edi
     763:	56                   	push   %esi
     764:	53                   	push   %ebx
     765:	83 ec 14             	sub    $0x14,%esp
     768:	8b 75 08             	mov    0x8(%ebp),%esi
     76b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     76e:	57                   	push   %edi
     76f:	56                   	push   %esi
     770:	e8 8c ff ff ff       	call   701 <parsepipe>
     775:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     777:	83 c4 10             	add    $0x10,%esp
     77a:	eb 18                	jmp    794 <parseline+0x35>
    gettoken(ps, es, 0, 0);
     77c:	6a 00                	push   $0x0
     77e:	6a 00                	push   $0x0
     780:	57                   	push   %edi
     781:	56                   	push   %esi
     782:	e8 40 fc ff ff       	call   3c7 <gettoken>
    cmd = backcmd(cmd);
     787:	89 1c 24             	mov    %ebx,(%esp)
     78a:	e8 08 fc ff ff       	call   397 <backcmd>
     78f:	89 c3                	mov    %eax,%ebx
     791:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
     794:	83 ec 04             	sub    $0x4,%esp
     797:	68 86 10 00 00       	push   $0x1086
     79c:	57                   	push   %edi
     79d:	56                   	push   %esi
     79e:	e8 22 fd ff ff       	call   4c5 <peek>
     7a3:	83 c4 10             	add    $0x10,%esp
     7a6:	85 c0                	test   %eax,%eax
     7a8:	75 d2                	jne    77c <parseline+0x1d>
  if(peek(ps, es, ";")){
     7aa:	83 ec 04             	sub    $0x4,%esp
     7ad:	68 82 10 00 00       	push   $0x1082
     7b2:	57                   	push   %edi
     7b3:	56                   	push   %esi
     7b4:	e8 0c fd ff ff       	call   4c5 <peek>
     7b9:	83 c4 10             	add    $0x10,%esp
     7bc:	85 c0                	test   %eax,%eax
     7be:	75 0a                	jne    7ca <parseline+0x6b>
}
     7c0:	89 d8                	mov    %ebx,%eax
     7c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7c5:	5b                   	pop    %ebx
     7c6:	5e                   	pop    %esi
     7c7:	5f                   	pop    %edi
     7c8:	5d                   	pop    %ebp
     7c9:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     7ca:	6a 00                	push   $0x0
     7cc:	6a 00                	push   $0x0
     7ce:	57                   	push   %edi
     7cf:	56                   	push   %esi
     7d0:	e8 f2 fb ff ff       	call   3c7 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     7d5:	83 c4 08             	add    $0x8,%esp
     7d8:	57                   	push   %edi
     7d9:	56                   	push   %esi
     7da:	e8 80 ff ff ff       	call   75f <parseline>
     7df:	83 c4 08             	add    $0x8,%esp
     7e2:	50                   	push   %eax
     7e3:	53                   	push   %ebx
     7e4:	e8 78 fb ff ff       	call   361 <listcmd>
     7e9:	89 c3                	mov    %eax,%ebx
     7eb:	83 c4 10             	add    $0x10,%esp
  return cmd;
     7ee:	eb d0                	jmp    7c0 <parseline+0x61>

000007f0 <parseblock>:
{
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	57                   	push   %edi
     7f4:	56                   	push   %esi
     7f5:	53                   	push   %ebx
     7f6:	83 ec 10             	sub    $0x10,%esp
     7f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     7ff:	68 68 10 00 00       	push   $0x1068
     804:	56                   	push   %esi
     805:	53                   	push   %ebx
     806:	e8 ba fc ff ff       	call   4c5 <peek>
     80b:	83 c4 10             	add    $0x10,%esp
     80e:	85 c0                	test   %eax,%eax
     810:	74 4b                	je     85d <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
     812:	6a 00                	push   $0x0
     814:	6a 00                	push   $0x0
     816:	56                   	push   %esi
     817:	53                   	push   %ebx
     818:	e8 aa fb ff ff       	call   3c7 <gettoken>
  cmd = parseline(ps, es);
     81d:	83 c4 08             	add    $0x8,%esp
     820:	56                   	push   %esi
     821:	53                   	push   %ebx
     822:	e8 38 ff ff ff       	call   75f <parseline>
     827:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     829:	83 c4 0c             	add    $0xc,%esp
     82c:	68 a4 10 00 00       	push   $0x10a4
     831:	56                   	push   %esi
     832:	53                   	push   %ebx
     833:	e8 8d fc ff ff       	call   4c5 <peek>
     838:	83 c4 10             	add    $0x10,%esp
     83b:	85 c0                	test   %eax,%eax
     83d:	74 30                	je     86f <parseblock+0x7f>
  gettoken(ps, es, 0, 0);
     83f:	6a 00                	push   $0x0
     841:	6a 00                	push   $0x0
     843:	56                   	push   %esi
     844:	53                   	push   %ebx
     845:	e8 7d fb ff ff       	call   3c7 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     84a:	83 c4 0c             	add    $0xc,%esp
     84d:	56                   	push   %esi
     84e:	53                   	push   %ebx
     84f:	57                   	push   %edi
     850:	e8 d9 fc ff ff       	call   52e <parseredirs>
}
     855:	8d 65 f4             	lea    -0xc(%ebp),%esp
     858:	5b                   	pop    %ebx
     859:	5e                   	pop    %esi
     85a:	5f                   	pop    %edi
     85b:	5d                   	pop    %ebp
     85c:	c3                   	ret    
    panic("parseblock");
     85d:	83 ec 0c             	sub    $0xc,%esp
     860:	68 88 10 00 00       	push   $0x1088
     865:	e8 e1 f7 ff ff       	call   4b <panic>
     86a:	83 c4 10             	add    $0x10,%esp
     86d:	eb a3                	jmp    812 <parseblock+0x22>
    panic("syntax - missing )");
     86f:	83 ec 0c             	sub    $0xc,%esp
     872:	68 93 10 00 00       	push   $0x1093
     877:	e8 cf f7 ff ff       	call   4b <panic>
     87c:	83 c4 10             	add    $0x10,%esp
     87f:	eb be                	jmp    83f <parseblock+0x4f>

00000881 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     881:	55                   	push   %ebp
     882:	89 e5                	mov    %esp,%ebp
     884:	53                   	push   %ebx
     885:	83 ec 04             	sub    $0x4,%esp
     888:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     88b:	85 db                	test   %ebx,%ebx
     88d:	74 1d                	je     8ac <nulterminate+0x2b>
    return 0;

  switch(cmd->type){
     88f:	8b 03                	mov    (%ebx),%eax
     891:	83 f8 05             	cmp    $0x5,%eax
     894:	77 16                	ja     8ac <nulterminate+0x2b>
     896:	ff 24 85 f8 10 00 00 	jmp    *0x10f8(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
     89d:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
     8a1:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     8a4:	40                   	inc    %eax
     8a5:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
     8aa:	75 f1                	jne    89d <nulterminate+0x1c>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     8ac:	89 d8                	mov    %ebx,%eax
     8ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8b1:	c9                   	leave  
     8b2:	c3                   	ret    
  switch(cmd->type){
     8b3:	b8 00 00 00 00       	mov    $0x0,%eax
     8b8:	eb eb                	jmp    8a5 <nulterminate+0x24>
    nulterminate(rcmd->cmd);
     8ba:	83 ec 0c             	sub    $0xc,%esp
     8bd:	ff 73 04             	push   0x4(%ebx)
     8c0:	e8 bc ff ff ff       	call   881 <nulterminate>
    *rcmd->efile = 0;
     8c5:	8b 43 0c             	mov    0xc(%ebx),%eax
     8c8:	c6 00 00             	movb   $0x0,(%eax)
    break;
     8cb:	83 c4 10             	add    $0x10,%esp
     8ce:	eb dc                	jmp    8ac <nulterminate+0x2b>
    nulterminate(pcmd->left);
     8d0:	83 ec 0c             	sub    $0xc,%esp
     8d3:	ff 73 04             	push   0x4(%ebx)
     8d6:	e8 a6 ff ff ff       	call   881 <nulterminate>
    nulterminate(pcmd->right);
     8db:	83 c4 04             	add    $0x4,%esp
     8de:	ff 73 08             	push   0x8(%ebx)
     8e1:	e8 9b ff ff ff       	call   881 <nulterminate>
    break;
     8e6:	83 c4 10             	add    $0x10,%esp
     8e9:	eb c1                	jmp    8ac <nulterminate+0x2b>
    nulterminate(lcmd->left);
     8eb:	83 ec 0c             	sub    $0xc,%esp
     8ee:	ff 73 04             	push   0x4(%ebx)
     8f1:	e8 8b ff ff ff       	call   881 <nulterminate>
    nulterminate(lcmd->right);
     8f6:	83 c4 04             	add    $0x4,%esp
     8f9:	ff 73 08             	push   0x8(%ebx)
     8fc:	e8 80 ff ff ff       	call   881 <nulterminate>
    break;
     901:	83 c4 10             	add    $0x10,%esp
     904:	eb a6                	jmp    8ac <nulterminate+0x2b>
    nulterminate(bcmd->cmd);
     906:	83 ec 0c             	sub    $0xc,%esp
     909:	ff 73 04             	push   0x4(%ebx)
     90c:	e8 70 ff ff ff       	call   881 <nulterminate>
    break;
     911:	83 c4 10             	add    $0x10,%esp
     914:	eb 96                	jmp    8ac <nulterminate+0x2b>

00000916 <parsecmd>:
{
     916:	55                   	push   %ebp
     917:	89 e5                	mov    %esp,%ebp
     919:	56                   	push   %esi
     91a:	53                   	push   %ebx
  es = s + strlen(s);
     91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
     91e:	83 ec 0c             	sub    $0xc,%esp
     921:	53                   	push   %ebx
     922:	e8 ac 01 00 00       	call   ad3 <strlen>
     927:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     929:	83 c4 08             	add    $0x8,%esp
     92c:	53                   	push   %ebx
     92d:	8d 45 08             	lea    0x8(%ebp),%eax
     930:	50                   	push   %eax
     931:	e8 29 fe ff ff       	call   75f <parseline>
     936:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     938:	83 c4 0c             	add    $0xc,%esp
     93b:	68 dc 10 00 00       	push   $0x10dc
     940:	53                   	push   %ebx
     941:	8d 45 08             	lea    0x8(%ebp),%eax
     944:	50                   	push   %eax
     945:	e8 7b fb ff ff       	call   4c5 <peek>
  if(s != es){
     94a:	8b 45 08             	mov    0x8(%ebp),%eax
     94d:	83 c4 10             	add    $0x10,%esp
     950:	39 d8                	cmp    %ebx,%eax
     952:	74 1f                	je     973 <parsecmd+0x5d>
    printf(2, "leftovers: %s\n", s);
     954:	83 ec 04             	sub    $0x4,%esp
     957:	50                   	push   %eax
     958:	68 a6 10 00 00       	push   $0x10a6
     95d:	6a 02                	push   $0x2
     95f:	e8 0b 04 00 00       	call   d6f <printf>
    panic("syntax");
     964:	c7 04 24 6a 10 00 00 	movl   $0x106a,(%esp)
     96b:	e8 db f6 ff ff       	call   4b <panic>
     970:	83 c4 10             	add    $0x10,%esp
  nulterminate(cmd);
     973:	83 ec 0c             	sub    $0xc,%esp
     976:	56                   	push   %esi
     977:	e8 05 ff ff ff       	call   881 <nulterminate>
}
     97c:	89 f0                	mov    %esi,%eax
     97e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     981:	5b                   	pop    %ebx
     982:	5e                   	pop    %esi
     983:	5d                   	pop    %ebp
     984:	c3                   	ret    

00000985 <main>:
{
     985:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     989:	83 e4 f0             	and    $0xfffffff0,%esp
     98c:	ff 71 fc             	push   -0x4(%ecx)
     98f:	55                   	push   %ebp
     990:	89 e5                	mov    %esp,%ebp
     992:	51                   	push   %ecx
     993:	83 ec 14             	sub    $0x14,%esp
  while((fd = open("console", O_RDWR)) >= 0){
     996:	83 ec 08             	sub    $0x8,%esp
     999:	6a 02                	push   $0x2
     99b:	68 b5 10 00 00       	push   $0x10b5
     9a0:	e8 af 02 00 00       	call   c54 <open>
     9a5:	83 c4 10             	add    $0x10,%esp
     9a8:	85 c0                	test   %eax,%eax
     9aa:	78 41                	js     9ed <main+0x68>
    if(fd >= 3){
     9ac:	83 f8 02             	cmp    $0x2,%eax
     9af:	7e e5                	jle    996 <main+0x11>
      close(fd);
     9b1:	83 ec 0c             	sub    $0xc,%esp
     9b4:	50                   	push   %eax
     9b5:	e8 82 02 00 00       	call   c3c <close>
      break;
     9ba:	83 c4 10             	add    $0x10,%esp
     9bd:	eb 2e                	jmp    9ed <main+0x68>
    if(fork1() == 0){
     9bf:	e8 ad f6 ff ff       	call   71 <fork1>
     9c4:	85 c0                	test   %eax,%eax
     9c6:	0f 84 92 00 00 00    	je     a5e <main+0xd9>
    wait(&status);
     9cc:	83 ec 0c             	sub    $0xc,%esp
     9cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
     9d2:	50                   	push   %eax
     9d3:	e8 44 02 00 00       	call   c1c <wait>
    printf(0, "Output code : %d\n", status);
     9d8:	83 c4 0c             	add    $0xc,%esp
     9db:	ff 75 f4             	push   -0xc(%ebp)
     9de:	68 cb 10 00 00       	push   $0x10cb
     9e3:	6a 00                	push   $0x0
     9e5:	e8 85 03 00 00       	call   d6f <printf>
     9ea:	83 c4 10             	add    $0x10,%esp
  while(getcmd(buf, sizeof(buf)) >= 0){
     9ed:	83 ec 08             	sub    $0x8,%esp
     9f0:	6a 64                	push   $0x64
     9f2:	68 20 17 00 00       	push   $0x1720
     9f7:	e8 04 f6 ff ff       	call   0 <getcmd>
     9fc:	83 c4 10             	add    $0x10,%esp
     9ff:	85 c0                	test   %eax,%eax
     a01:	78 78                	js     a7b <main+0xf6>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a03:	80 3d 20 17 00 00 63 	cmpb   $0x63,0x1720
     a0a:	75 b3                	jne    9bf <main+0x3a>
     a0c:	80 3d 21 17 00 00 64 	cmpb   $0x64,0x1721
     a13:	75 aa                	jne    9bf <main+0x3a>
     a15:	80 3d 22 17 00 00 20 	cmpb   $0x20,0x1722
     a1c:	75 a1                	jne    9bf <main+0x3a>
      buf[strlen(buf)-1] = 0;  // chop \n
     a1e:	83 ec 0c             	sub    $0xc,%esp
     a21:	68 20 17 00 00       	push   $0x1720
     a26:	e8 a8 00 00 00       	call   ad3 <strlen>
     a2b:	c6 80 1f 17 00 00 00 	movb   $0x0,0x171f(%eax)
      if(chdir(buf+3) < 0)
     a32:	c7 04 24 23 17 00 00 	movl   $0x1723,(%esp)
     a39:	e8 46 02 00 00       	call   c84 <chdir>
     a3e:	83 c4 10             	add    $0x10,%esp
     a41:	85 c0                	test   %eax,%eax
     a43:	79 a8                	jns    9ed <main+0x68>
        printf(2, "cannot cd %s\n", buf+3);
     a45:	83 ec 04             	sub    $0x4,%esp
     a48:	68 23 17 00 00       	push   $0x1723
     a4d:	68 bd 10 00 00       	push   $0x10bd
     a52:	6a 02                	push   $0x2
     a54:	e8 16 03 00 00       	call   d6f <printf>
     a59:	83 c4 10             	add    $0x10,%esp
      continue;
     a5c:	eb 8f                	jmp    9ed <main+0x68>
      runcmd(parsecmd(buf));
     a5e:	83 ec 0c             	sub    $0xc,%esp
     a61:	68 20 17 00 00       	push   $0x1720
     a66:	e8 ab fe ff ff       	call   916 <parsecmd>
     a6b:	89 04 24             	mov    %eax,(%esp)
     a6e:	e8 2a f6 ff ff       	call   9d <runcmd>
     a73:	83 c4 10             	add    $0x10,%esp
     a76:	e9 51 ff ff ff       	jmp    9cc <main+0x47>
  exit(0);
     a7b:	83 ec 0c             	sub    $0xc,%esp
     a7e:	6a 00                	push   $0x0
     a80:	e8 8f 01 00 00       	call   c14 <exit>
}
     a85:	b8 00 00 00 00       	mov    $0x0,%eax
     a8a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
     a8d:	c9                   	leave  
     a8e:	8d 61 fc             	lea    -0x4(%ecx),%esp
     a91:	c3                   	ret    

00000a92 <start>:

// Entry point of the library	
void
start()
{
}
     a92:	c3                   	ret    

00000a93 <strcpy>:

char*
strcpy(char *s, const char *t)
{
     a93:	55                   	push   %ebp
     a94:	89 e5                	mov    %esp,%ebp
     a96:	56                   	push   %esi
     a97:	53                   	push   %ebx
     a98:	8b 45 08             	mov    0x8(%ebp),%eax
     a9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a9e:	89 c2                	mov    %eax,%edx
     aa0:	89 cb                	mov    %ecx,%ebx
     aa2:	41                   	inc    %ecx
     aa3:	89 d6                	mov    %edx,%esi
     aa5:	42                   	inc    %edx
     aa6:	8a 1b                	mov    (%ebx),%bl
     aa8:	88 1e                	mov    %bl,(%esi)
     aaa:	84 db                	test   %bl,%bl
     aac:	75 f2                	jne    aa0 <strcpy+0xd>
    ;
  return os;
}
     aae:	5b                   	pop    %ebx
     aaf:	5e                   	pop    %esi
     ab0:	5d                   	pop    %ebp
     ab1:	c3                   	ret    

00000ab2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ab2:	55                   	push   %ebp
     ab3:	89 e5                	mov    %esp,%ebp
     ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     abb:	eb 02                	jmp    abf <strcmp+0xd>
    p++, q++;
     abd:	41                   	inc    %ecx
     abe:	42                   	inc    %edx
  while(*p && *p == *q)
     abf:	8a 01                	mov    (%ecx),%al
     ac1:	84 c0                	test   %al,%al
     ac3:	74 04                	je     ac9 <strcmp+0x17>
     ac5:	3a 02                	cmp    (%edx),%al
     ac7:	74 f4                	je     abd <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
     ac9:	0f b6 c0             	movzbl %al,%eax
     acc:	0f b6 12             	movzbl (%edx),%edx
     acf:	29 d0                	sub    %edx,%eax
}
     ad1:	5d                   	pop    %ebp
     ad2:	c3                   	ret    

00000ad3 <strlen>:

uint
strlen(const char *s)
{
     ad3:	55                   	push   %ebp
     ad4:	89 e5                	mov    %esp,%ebp
     ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     ad9:	b8 00 00 00 00       	mov    $0x0,%eax
     ade:	eb 01                	jmp    ae1 <strlen+0xe>
     ae0:	40                   	inc    %eax
     ae1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
     ae5:	75 f9                	jne    ae0 <strlen+0xd>
    ;
  return n;
}
     ae7:	5d                   	pop    %ebp
     ae8:	c3                   	ret    

00000ae9 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ae9:	55                   	push   %ebp
     aea:	89 e5                	mov    %esp,%ebp
     aec:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     aed:	8b 7d 08             	mov    0x8(%ebp),%edi
     af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
     af3:	8b 45 0c             	mov    0xc(%ebp),%eax
     af6:	fc                   	cld    
     af7:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     af9:	8b 45 08             	mov    0x8(%ebp),%eax
     afc:	8b 7d fc             	mov    -0x4(%ebp),%edi
     aff:	c9                   	leave  
     b00:	c3                   	ret    

00000b01 <strchr>:

char*
strchr(const char *s, char c)
{
     b01:	55                   	push   %ebp
     b02:	89 e5                	mov    %esp,%ebp
     b04:	8b 45 08             	mov    0x8(%ebp),%eax
     b07:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
     b0a:	eb 01                	jmp    b0d <strchr+0xc>
     b0c:	40                   	inc    %eax
     b0d:	8a 10                	mov    (%eax),%dl
     b0f:	84 d2                	test   %dl,%dl
     b11:	74 06                	je     b19 <strchr+0x18>
    if(*s == c)
     b13:	38 ca                	cmp    %cl,%dl
     b15:	75 f5                	jne    b0c <strchr+0xb>
     b17:	eb 05                	jmp    b1e <strchr+0x1d>
      return (char*)s;
  return 0;
     b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b1e:	5d                   	pop    %ebp
     b1f:	c3                   	ret    

00000b20 <gets>:

char*
gets(char *buf, int max)
{
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	57                   	push   %edi
     b24:	56                   	push   %esi
     b25:	53                   	push   %ebx
     b26:	83 ec 1c             	sub    $0x1c,%esp
     b29:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b2c:	bb 00 00 00 00       	mov    $0x0,%ebx
     b31:	89 de                	mov    %ebx,%esi
     b33:	43                   	inc    %ebx
     b34:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     b37:	7d 2b                	jge    b64 <gets+0x44>
    cc = read(0, &c, 1);
     b39:	83 ec 04             	sub    $0x4,%esp
     b3c:	6a 01                	push   $0x1
     b3e:	8d 45 e7             	lea    -0x19(%ebp),%eax
     b41:	50                   	push   %eax
     b42:	6a 00                	push   $0x0
     b44:	e8 e3 00 00 00       	call   c2c <read>
    if(cc < 1)
     b49:	83 c4 10             	add    $0x10,%esp
     b4c:	85 c0                	test   %eax,%eax
     b4e:	7e 14                	jle    b64 <gets+0x44>
      break;
    buf[i++] = c;
     b50:	8a 45 e7             	mov    -0x19(%ebp),%al
     b53:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
     b56:	3c 0a                	cmp    $0xa,%al
     b58:	74 08                	je     b62 <gets+0x42>
     b5a:	3c 0d                	cmp    $0xd,%al
     b5c:	75 d3                	jne    b31 <gets+0x11>
    buf[i++] = c;
     b5e:	89 de                	mov    %ebx,%esi
     b60:	eb 02                	jmp    b64 <gets+0x44>
     b62:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     b64:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     b68:	89 f8                	mov    %edi,%eax
     b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b6d:	5b                   	pop    %ebx
     b6e:	5e                   	pop    %esi
     b6f:	5f                   	pop    %edi
     b70:	5d                   	pop    %ebp
     b71:	c3                   	ret    

00000b72 <stat>:

int
stat(const char *n, struct stat *st)
{
     b72:	55                   	push   %ebp
     b73:	89 e5                	mov    %esp,%ebp
     b75:	56                   	push   %esi
     b76:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b77:	83 ec 08             	sub    $0x8,%esp
     b7a:	6a 00                	push   $0x0
     b7c:	ff 75 08             	push   0x8(%ebp)
     b7f:	e8 d0 00 00 00       	call   c54 <open>
  if(fd < 0)
     b84:	83 c4 10             	add    $0x10,%esp
     b87:	85 c0                	test   %eax,%eax
     b89:	78 24                	js     baf <stat+0x3d>
     b8b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     b8d:	83 ec 08             	sub    $0x8,%esp
     b90:	ff 75 0c             	push   0xc(%ebp)
     b93:	50                   	push   %eax
     b94:	e8 d3 00 00 00       	call   c6c <fstat>
     b99:	89 c6                	mov    %eax,%esi
  close(fd);
     b9b:	89 1c 24             	mov    %ebx,(%esp)
     b9e:	e8 99 00 00 00       	call   c3c <close>
  return r;
     ba3:	83 c4 10             	add    $0x10,%esp
}
     ba6:	89 f0                	mov    %esi,%eax
     ba8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bab:	5b                   	pop    %ebx
     bac:	5e                   	pop    %esi
     bad:	5d                   	pop    %ebp
     bae:	c3                   	ret    
    return -1;
     baf:	be ff ff ff ff       	mov    $0xffffffff,%esi
     bb4:	eb f0                	jmp    ba6 <stat+0x34>

00000bb6 <atoi>:

int
atoi(const char *s)
{
     bb6:	55                   	push   %ebp
     bb7:	89 e5                	mov    %esp,%ebp
     bb9:	53                   	push   %ebx
     bba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
     bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
     bc2:	eb 0e                	jmp    bd2 <atoi+0x1c>
    n = n*10 + *s++ - '0';
     bc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
     bc7:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
     bca:	41                   	inc    %ecx
     bcb:	0f be c0             	movsbl %al,%eax
     bce:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
     bd2:	8a 01                	mov    (%ecx),%al
     bd4:	8d 58 d0             	lea    -0x30(%eax),%ebx
     bd7:	80 fb 09             	cmp    $0x9,%bl
     bda:	76 e8                	jbe    bc4 <atoi+0xe>
  return n;
}
     bdc:	89 d0                	mov    %edx,%eax
     bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     be1:	c9                   	leave  
     be2:	c3                   	ret    

00000be3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     be3:	55                   	push   %ebp
     be4:	89 e5                	mov    %esp,%ebp
     be6:	56                   	push   %esi
     be7:	53                   	push   %ebx
     be8:	8b 45 08             	mov    0x8(%ebp),%eax
     beb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     bee:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
     bf1:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
     bf3:	eb 0c                	jmp    c01 <memmove+0x1e>
    *dst++ = *src++;
     bf5:	8a 13                	mov    (%ebx),%dl
     bf7:	88 11                	mov    %dl,(%ecx)
     bf9:	8d 5b 01             	lea    0x1(%ebx),%ebx
     bfc:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
     bff:	89 f2                	mov    %esi,%edx
     c01:	8d 72 ff             	lea    -0x1(%edx),%esi
     c04:	85 d2                	test   %edx,%edx
     c06:	7f ed                	jg     bf5 <memmove+0x12>
  return vdst;
}
     c08:	5b                   	pop    %ebx
     c09:	5e                   	pop    %esi
     c0a:	5d                   	pop    %ebp
     c0b:	c3                   	ret    

00000c0c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c0c:	b8 01 00 00 00       	mov    $0x1,%eax
     c11:	cd 40                	int    $0x40
     c13:	c3                   	ret    

00000c14 <exit>:
SYSCALL(exit)
     c14:	b8 02 00 00 00       	mov    $0x2,%eax
     c19:	cd 40                	int    $0x40
     c1b:	c3                   	ret    

00000c1c <wait>:
SYSCALL(wait)
     c1c:	b8 03 00 00 00       	mov    $0x3,%eax
     c21:	cd 40                	int    $0x40
     c23:	c3                   	ret    

00000c24 <pipe>:
SYSCALL(pipe)
     c24:	b8 04 00 00 00       	mov    $0x4,%eax
     c29:	cd 40                	int    $0x40
     c2b:	c3                   	ret    

00000c2c <read>:
SYSCALL(read)
     c2c:	b8 05 00 00 00       	mov    $0x5,%eax
     c31:	cd 40                	int    $0x40
     c33:	c3                   	ret    

00000c34 <write>:
SYSCALL(write)
     c34:	b8 10 00 00 00       	mov    $0x10,%eax
     c39:	cd 40                	int    $0x40
     c3b:	c3                   	ret    

00000c3c <close>:
SYSCALL(close)
     c3c:	b8 15 00 00 00       	mov    $0x15,%eax
     c41:	cd 40                	int    $0x40
     c43:	c3                   	ret    

00000c44 <kill>:
SYSCALL(kill)
     c44:	b8 06 00 00 00       	mov    $0x6,%eax
     c49:	cd 40                	int    $0x40
     c4b:	c3                   	ret    

00000c4c <exec>:
SYSCALL(exec)
     c4c:	b8 07 00 00 00       	mov    $0x7,%eax
     c51:	cd 40                	int    $0x40
     c53:	c3                   	ret    

00000c54 <open>:
SYSCALL(open)
     c54:	b8 0f 00 00 00       	mov    $0xf,%eax
     c59:	cd 40                	int    $0x40
     c5b:	c3                   	ret    

00000c5c <mknod>:
SYSCALL(mknod)
     c5c:	b8 11 00 00 00       	mov    $0x11,%eax
     c61:	cd 40                	int    $0x40
     c63:	c3                   	ret    

00000c64 <unlink>:
SYSCALL(unlink)
     c64:	b8 12 00 00 00       	mov    $0x12,%eax
     c69:	cd 40                	int    $0x40
     c6b:	c3                   	ret    

00000c6c <fstat>:
SYSCALL(fstat)
     c6c:	b8 08 00 00 00       	mov    $0x8,%eax
     c71:	cd 40                	int    $0x40
     c73:	c3                   	ret    

00000c74 <link>:
SYSCALL(link)
     c74:	b8 13 00 00 00       	mov    $0x13,%eax
     c79:	cd 40                	int    $0x40
     c7b:	c3                   	ret    

00000c7c <mkdir>:
SYSCALL(mkdir)
     c7c:	b8 14 00 00 00       	mov    $0x14,%eax
     c81:	cd 40                	int    $0x40
     c83:	c3                   	ret    

00000c84 <chdir>:
SYSCALL(chdir)
     c84:	b8 09 00 00 00       	mov    $0x9,%eax
     c89:	cd 40                	int    $0x40
     c8b:	c3                   	ret    

00000c8c <dup>:
SYSCALL(dup)
     c8c:	b8 0a 00 00 00       	mov    $0xa,%eax
     c91:	cd 40                	int    $0x40
     c93:	c3                   	ret    

00000c94 <getpid>:
SYSCALL(getpid)
     c94:	b8 0b 00 00 00       	mov    $0xb,%eax
     c99:	cd 40                	int    $0x40
     c9b:	c3                   	ret    

00000c9c <sbrk>:
SYSCALL(sbrk)
     c9c:	b8 0c 00 00 00       	mov    $0xc,%eax
     ca1:	cd 40                	int    $0x40
     ca3:	c3                   	ret    

00000ca4 <sleep>:
SYSCALL(sleep)
     ca4:	b8 0d 00 00 00       	mov    $0xd,%eax
     ca9:	cd 40                	int    $0x40
     cab:	c3                   	ret    

00000cac <uptime>:
SYSCALL(uptime)
     cac:	b8 0e 00 00 00       	mov    $0xe,%eax
     cb1:	cd 40                	int    $0x40
     cb3:	c3                   	ret    

00000cb4 <date>:
SYSCALL(date)
     cb4:	b8 16 00 00 00       	mov    $0x16,%eax
     cb9:	cd 40                	int    $0x40
     cbb:	c3                   	ret    

00000cbc <dup2>:
SYSCALL(dup2)
     cbc:	b8 17 00 00 00       	mov    $0x17,%eax
     cc1:	cd 40                	int    $0x40
     cc3:	c3                   	ret    

00000cc4 <phmem>:
SYSCALL(phmem)
     cc4:	b8 18 00 00 00       	mov    $0x18,%eax
     cc9:	cd 40                	int    $0x40
     ccb:	c3                   	ret    

00000ccc <getprio>:
SYSCALL(getprio)
     ccc:	b8 19 00 00 00       	mov    $0x19,%eax
     cd1:	cd 40                	int    $0x40
     cd3:	c3                   	ret    

00000cd4 <setprio>:
SYSCALL(setprio)
     cd4:	b8 1a 00 00 00       	mov    $0x1a,%eax
     cd9:	cd 40                	int    $0x40
     cdb:	c3                   	ret    

00000cdc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     cdc:	55                   	push   %ebp
     cdd:	89 e5                	mov    %esp,%ebp
     cdf:	83 ec 1c             	sub    $0x1c,%esp
     ce2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
     ce5:	6a 01                	push   $0x1
     ce7:	8d 55 f4             	lea    -0xc(%ebp),%edx
     cea:	52                   	push   %edx
     ceb:	50                   	push   %eax
     cec:	e8 43 ff ff ff       	call   c34 <write>
}
     cf1:	83 c4 10             	add    $0x10,%esp
     cf4:	c9                   	leave  
     cf5:	c3                   	ret    

00000cf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cf6:	55                   	push   %ebp
     cf7:	89 e5                	mov    %esp,%ebp
     cf9:	57                   	push   %edi
     cfa:	56                   	push   %esi
     cfb:	53                   	push   %ebx
     cfc:	83 ec 2c             	sub    $0x2c,%esp
     cff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     d02:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d08:	74 04                	je     d0e <printint+0x18>
     d0a:	85 d2                	test   %edx,%edx
     d0c:	78 3c                	js     d4a <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d0e:	89 d1                	mov    %edx,%ecx
  neg = 0;
     d10:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
     d17:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
     d1c:	89 c8                	mov    %ecx,%eax
     d1e:	ba 00 00 00 00       	mov    $0x0,%edx
     d23:	f7 f6                	div    %esi
     d25:	89 df                	mov    %ebx,%edi
     d27:	43                   	inc    %ebx
     d28:	8a 92 70 11 00 00    	mov    0x1170(%edx),%dl
     d2e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
     d32:	89 ca                	mov    %ecx,%edx
     d34:	89 c1                	mov    %eax,%ecx
     d36:	39 d6                	cmp    %edx,%esi
     d38:	76 e2                	jbe    d1c <printint+0x26>
  if(neg)
     d3a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     d3e:	74 24                	je     d64 <printint+0x6e>
    buf[i++] = '-';
     d40:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     d45:	8d 5f 02             	lea    0x2(%edi),%ebx
     d48:	eb 1a                	jmp    d64 <printint+0x6e>
    x = -xx;
     d4a:	89 d1                	mov    %edx,%ecx
     d4c:	f7 d9                	neg    %ecx
    neg = 1;
     d4e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
     d55:	eb c0                	jmp    d17 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
     d57:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
     d5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     d5f:	e8 78 ff ff ff       	call   cdc <putc>
  while(--i >= 0)
     d64:	4b                   	dec    %ebx
     d65:	79 f0                	jns    d57 <printint+0x61>
}
     d67:	83 c4 2c             	add    $0x2c,%esp
     d6a:	5b                   	pop    %ebx
     d6b:	5e                   	pop    %esi
     d6c:	5f                   	pop    %edi
     d6d:	5d                   	pop    %ebp
     d6e:	c3                   	ret    

00000d6f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     d6f:	55                   	push   %ebp
     d70:	89 e5                	mov    %esp,%ebp
     d72:	57                   	push   %edi
     d73:	56                   	push   %esi
     d74:	53                   	push   %ebx
     d75:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     d78:	8d 45 10             	lea    0x10(%ebp),%eax
     d7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
     d7e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
     d83:	bb 00 00 00 00       	mov    $0x0,%ebx
     d88:	eb 12                	jmp    d9c <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     d8a:	89 fa                	mov    %edi,%edx
     d8c:	8b 45 08             	mov    0x8(%ebp),%eax
     d8f:	e8 48 ff ff ff       	call   cdc <putc>
     d94:	eb 05                	jmp    d9b <printf+0x2c>
      }
    } else if(state == '%'){
     d96:	83 fe 25             	cmp    $0x25,%esi
     d99:	74 22                	je     dbd <printf+0x4e>
  for(i = 0; fmt[i]; i++){
     d9b:	43                   	inc    %ebx
     d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d9f:	8a 04 18             	mov    (%eax,%ebx,1),%al
     da2:	84 c0                	test   %al,%al
     da4:	0f 84 1d 01 00 00    	je     ec7 <printf+0x158>
    c = fmt[i] & 0xff;
     daa:	0f be f8             	movsbl %al,%edi
     dad:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
     db0:	85 f6                	test   %esi,%esi
     db2:	75 e2                	jne    d96 <printf+0x27>
      if(c == '%'){
     db4:	83 f8 25             	cmp    $0x25,%eax
     db7:	75 d1                	jne    d8a <printf+0x1b>
        state = '%';
     db9:	89 c6                	mov    %eax,%esi
     dbb:	eb de                	jmp    d9b <printf+0x2c>
      if(c == 'd'){
     dbd:	83 f8 25             	cmp    $0x25,%eax
     dc0:	0f 84 cc 00 00 00    	je     e92 <printf+0x123>
     dc6:	0f 8c da 00 00 00    	jl     ea6 <printf+0x137>
     dcc:	83 f8 78             	cmp    $0x78,%eax
     dcf:	0f 8f d1 00 00 00    	jg     ea6 <printf+0x137>
     dd5:	83 f8 63             	cmp    $0x63,%eax
     dd8:	0f 8c c8 00 00 00    	jl     ea6 <printf+0x137>
     dde:	83 e8 63             	sub    $0x63,%eax
     de1:	83 f8 15             	cmp    $0x15,%eax
     de4:	0f 87 bc 00 00 00    	ja     ea6 <printf+0x137>
     dea:	ff 24 85 18 11 00 00 	jmp    *0x1118(,%eax,4)
        printint(fd, *ap, 10, 1);
     df1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     df4:	8b 17                	mov    (%edi),%edx
     df6:	83 ec 0c             	sub    $0xc,%esp
     df9:	6a 01                	push   $0x1
     dfb:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e00:	8b 45 08             	mov    0x8(%ebp),%eax
     e03:	e8 ee fe ff ff       	call   cf6 <printint>
        ap++;
     e08:	83 c7 04             	add    $0x4,%edi
     e0b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     e0e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     e11:	be 00 00 00 00       	mov    $0x0,%esi
     e16:	eb 83                	jmp    d9b <printf+0x2c>
        printint(fd, *ap, 16, 0);
     e18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     e1b:	8b 17                	mov    (%edi),%edx
     e1d:	83 ec 0c             	sub    $0xc,%esp
     e20:	6a 00                	push   $0x0
     e22:	b9 10 00 00 00       	mov    $0x10,%ecx
     e27:	8b 45 08             	mov    0x8(%ebp),%eax
     e2a:	e8 c7 fe ff ff       	call   cf6 <printint>
        ap++;
     e2f:	83 c7 04             	add    $0x4,%edi
     e32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     e35:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e38:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
     e3d:	e9 59 ff ff ff       	jmp    d9b <printf+0x2c>
        s = (char*)*ap;
     e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e45:	8b 30                	mov    (%eax),%esi
        ap++;
     e47:	83 c0 04             	add    $0x4,%eax
     e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
     e4d:	85 f6                	test   %esi,%esi
     e4f:	75 13                	jne    e64 <printf+0xf5>
          s = "(null)";
     e51:	be 10 11 00 00       	mov    $0x1110,%esi
     e56:	eb 0c                	jmp    e64 <printf+0xf5>
          putc(fd, *s);
     e58:	0f be d2             	movsbl %dl,%edx
     e5b:	8b 45 08             	mov    0x8(%ebp),%eax
     e5e:	e8 79 fe ff ff       	call   cdc <putc>
          s++;
     e63:	46                   	inc    %esi
        while(*s != 0){
     e64:	8a 16                	mov    (%esi),%dl
     e66:	84 d2                	test   %dl,%dl
     e68:	75 ee                	jne    e58 <printf+0xe9>
      state = 0;
     e6a:	be 00 00 00 00       	mov    $0x0,%esi
     e6f:	e9 27 ff ff ff       	jmp    d9b <printf+0x2c>
        putc(fd, *ap);
     e74:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     e77:	0f be 17             	movsbl (%edi),%edx
     e7a:	8b 45 08             	mov    0x8(%ebp),%eax
     e7d:	e8 5a fe ff ff       	call   cdc <putc>
        ap++;
     e82:	83 c7 04             	add    $0x4,%edi
     e85:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
     e88:	be 00 00 00 00       	mov    $0x0,%esi
     e8d:	e9 09 ff ff ff       	jmp    d9b <printf+0x2c>
        putc(fd, c);
     e92:	89 fa                	mov    %edi,%edx
     e94:	8b 45 08             	mov    0x8(%ebp),%eax
     e97:	e8 40 fe ff ff       	call   cdc <putc>
      state = 0;
     e9c:	be 00 00 00 00       	mov    $0x0,%esi
     ea1:	e9 f5 fe ff ff       	jmp    d9b <printf+0x2c>
        putc(fd, '%');
     ea6:	ba 25 00 00 00       	mov    $0x25,%edx
     eab:	8b 45 08             	mov    0x8(%ebp),%eax
     eae:	e8 29 fe ff ff       	call   cdc <putc>
        putc(fd, c);
     eb3:	89 fa                	mov    %edi,%edx
     eb5:	8b 45 08             	mov    0x8(%ebp),%eax
     eb8:	e8 1f fe ff ff       	call   cdc <putc>
      state = 0;
     ebd:	be 00 00 00 00       	mov    $0x0,%esi
     ec2:	e9 d4 fe ff ff       	jmp    d9b <printf+0x2c>
    }
  }
}
     ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     eca:	5b                   	pop    %ebx
     ecb:	5e                   	pop    %esi
     ecc:	5f                   	pop    %edi
     ecd:	5d                   	pop    %ebp
     ece:	c3                   	ret    

00000ecf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ecf:	55                   	push   %ebp
     ed0:	89 e5                	mov    %esp,%ebp
     ed2:	57                   	push   %edi
     ed3:	56                   	push   %esi
     ed4:	53                   	push   %ebx
     ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ed8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     edb:	a1 84 17 00 00       	mov    0x1784,%eax
     ee0:	eb 02                	jmp    ee4 <free+0x15>
     ee2:	89 d0                	mov    %edx,%eax
     ee4:	39 c8                	cmp    %ecx,%eax
     ee6:	73 04                	jae    eec <free+0x1d>
     ee8:	39 08                	cmp    %ecx,(%eax)
     eea:	77 12                	ja     efe <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eec:	8b 10                	mov    (%eax),%edx
     eee:	39 c2                	cmp    %eax,%edx
     ef0:	77 f0                	ja     ee2 <free+0x13>
     ef2:	39 c8                	cmp    %ecx,%eax
     ef4:	72 08                	jb     efe <free+0x2f>
     ef6:	39 ca                	cmp    %ecx,%edx
     ef8:	77 04                	ja     efe <free+0x2f>
     efa:	89 d0                	mov    %edx,%eax
     efc:	eb e6                	jmp    ee4 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
     efe:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f01:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f04:	8b 10                	mov    (%eax),%edx
     f06:	39 d7                	cmp    %edx,%edi
     f08:	74 19                	je     f23 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f0a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f0d:	8b 50 04             	mov    0x4(%eax),%edx
     f10:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f13:	39 ce                	cmp    %ecx,%esi
     f15:	74 1b                	je     f32 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f17:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f19:	a3 84 17 00 00       	mov    %eax,0x1784
}
     f1e:	5b                   	pop    %ebx
     f1f:	5e                   	pop    %esi
     f20:	5f                   	pop    %edi
     f21:	5d                   	pop    %ebp
     f22:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
     f23:	03 72 04             	add    0x4(%edx),%esi
     f26:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f29:	8b 10                	mov    (%eax),%edx
     f2b:	8b 12                	mov    (%edx),%edx
     f2d:	89 53 f8             	mov    %edx,-0x8(%ebx)
     f30:	eb db                	jmp    f0d <free+0x3e>
    p->s.size += bp->s.size;
     f32:	03 53 fc             	add    -0x4(%ebx),%edx
     f35:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f38:	8b 53 f8             	mov    -0x8(%ebx),%edx
     f3b:	89 10                	mov    %edx,(%eax)
     f3d:	eb da                	jmp    f19 <free+0x4a>

00000f3f <morecore>:

static Header*
morecore(uint nu)
{
     f3f:	55                   	push   %ebp
     f40:	89 e5                	mov    %esp,%ebp
     f42:	53                   	push   %ebx
     f43:	83 ec 04             	sub    $0x4,%esp
     f46:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
     f48:	3d ff 0f 00 00       	cmp    $0xfff,%eax
     f4d:	77 05                	ja     f54 <morecore+0x15>
    nu = 4096;
     f4f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
     f54:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
     f5b:	83 ec 0c             	sub    $0xc,%esp
     f5e:	50                   	push   %eax
     f5f:	e8 38 fd ff ff       	call   c9c <sbrk>
  if(p == (char*)-1)
     f64:	83 c4 10             	add    $0x10,%esp
     f67:	83 f8 ff             	cmp    $0xffffffff,%eax
     f6a:	74 1c                	je     f88 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
     f6c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     f6f:	83 c0 08             	add    $0x8,%eax
     f72:	83 ec 0c             	sub    $0xc,%esp
     f75:	50                   	push   %eax
     f76:	e8 54 ff ff ff       	call   ecf <free>
  return freep;
     f7b:	a1 84 17 00 00       	mov    0x1784,%eax
     f80:	83 c4 10             	add    $0x10,%esp
}
     f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f86:	c9                   	leave  
     f87:	c3                   	ret    
    return 0;
     f88:	b8 00 00 00 00       	mov    $0x0,%eax
     f8d:	eb f4                	jmp    f83 <morecore+0x44>

00000f8f <malloc>:

void*
malloc(uint nbytes)
{
     f8f:	55                   	push   %ebp
     f90:	89 e5                	mov    %esp,%ebp
     f92:	53                   	push   %ebx
     f93:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f96:	8b 45 08             	mov    0x8(%ebp),%eax
     f99:	8d 58 07             	lea    0x7(%eax),%ebx
     f9c:	c1 eb 03             	shr    $0x3,%ebx
     f9f:	43                   	inc    %ebx
  if((prevp = freep) == 0){
     fa0:	8b 0d 84 17 00 00    	mov    0x1784,%ecx
     fa6:	85 c9                	test   %ecx,%ecx
     fa8:	74 04                	je     fae <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     faa:	8b 01                	mov    (%ecx),%eax
     fac:	eb 4a                	jmp    ff8 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
     fae:	c7 05 84 17 00 00 88 	movl   $0x1788,0x1784
     fb5:	17 00 00 
     fb8:	c7 05 88 17 00 00 88 	movl   $0x1788,0x1788
     fbf:	17 00 00 
    base.s.size = 0;
     fc2:	c7 05 8c 17 00 00 00 	movl   $0x0,0x178c
     fc9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
     fcc:	b9 88 17 00 00       	mov    $0x1788,%ecx
     fd1:	eb d7                	jmp    faa <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
     fd3:	74 19                	je     fee <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
     fd5:	29 da                	sub    %ebx,%edx
     fd7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     fda:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
     fdd:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
     fe0:	89 0d 84 17 00 00    	mov    %ecx,0x1784
      return (void*)(p + 1);
     fe6:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
     fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fec:	c9                   	leave  
     fed:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
     fee:	8b 10                	mov    (%eax),%edx
     ff0:	89 11                	mov    %edx,(%ecx)
     ff2:	eb ec                	jmp    fe0 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ff4:	89 c1                	mov    %eax,%ecx
     ff6:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
     ff8:	8b 50 04             	mov    0x4(%eax),%edx
     ffb:	39 da                	cmp    %ebx,%edx
     ffd:	73 d4                	jae    fd3 <malloc+0x44>
    if(p == freep)
     fff:	39 05 84 17 00 00    	cmp    %eax,0x1784
    1005:	75 ed                	jne    ff4 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
    1007:	89 d8                	mov    %ebx,%eax
    1009:	e8 31 ff ff ff       	call   f3f <morecore>
    100e:	85 c0                	test   %eax,%eax
    1010:	75 e2                	jne    ff4 <malloc+0x65>
    1012:	eb d5                	jmp    fe9 <malloc+0x5a>
