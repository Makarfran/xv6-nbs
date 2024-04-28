
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 30 58 11 80       	mov    $0x80115830,%esp
8010002d:	b8 92 29 10 80       	mov    $0x80102992,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 03 3d 00 00       	call   80103d4e <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 20 a5 10 80       	push   $0x8010a520
8010007a:	e8 34 3d 00 00       	call   80103db3 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 b5 3a 00 00       	call   80103b3f <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 e6 3c 00 00       	call   80103db3 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 67 3a 00 00       	call   80103b3f <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 80 6b 10 80       	push   $0x80106b80
801000ed:	e8 4f 02 00 00       	call   80100341 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 91 6b 10 80       	push   $0x80106b91
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 0f 3b 00 00       	call   80103c17 <initlock>
  bcache.head.prev = &bcache.head;
80100108:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010010f:	ec 10 80 
  bcache.head.next = &bcache.head;
80100112:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100119:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011c:	83 c4 10             	add    $0x10,%esp
8010011f:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100124:	eb 37                	jmp    8010015d <binit+0x6b>
    b->next = bcache.head.next;
80100126:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010012e:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100135:	83 ec 08             	sub    $0x8,%esp
80100138:	68 98 6b 10 80       	push   $0x80106b98
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 c6 39 00 00       	call   80103b0c <initsleeplock>
    bcache.head.next->prev = b;
80100146:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010014e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100154:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015a:	83 c4 10             	add    $0x10,%esp
8010015d:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100163:	72 c1                	jb     80100126 <binit+0x34>
}
80100165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100168:	c9                   	leave  
80100169:	c3                   	ret    

8010016a <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016a:	55                   	push   %ebp
8010016b:	89 e5                	mov    %esp,%ebp
8010016d:	53                   	push   %ebx
8010016e:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	8b 45 08             	mov    0x8(%ebp),%eax
80100177:	e8 b8 fe ff ff       	call   80100034 <bget>
8010017c:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
8010017e:	f6 00 02             	testb  $0x2,(%eax)
80100181:	74 07                	je     8010018a <bread+0x20>
    iderw(b);
  }
  return b;
}
80100183:	89 d8                	mov    %ebx,%eax
80100185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100188:	c9                   	leave  
80100189:	c3                   	ret    
    iderw(b);
8010018a:	83 ec 0c             	sub    $0xc,%esp
8010018d:	50                   	push   %eax
8010018e:	e8 ea 1b 00 00       	call   80101d7d <iderw>
80100193:	83 c4 10             	add    $0x10,%esp
  return b;
80100196:	eb eb                	jmp    80100183 <bread+0x19>

80100198 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100198:	55                   	push   %ebp
80100199:	89 e5                	mov    %esp,%ebp
8010019b:	53                   	push   %ebx
8010019c:	83 ec 10             	sub    $0x10,%esp
8010019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a5:	50                   	push   %eax
801001a6:	e8 1e 3a 00 00       	call   80103bc9 <holdingsleep>
801001ab:	83 c4 10             	add    $0x10,%esp
801001ae:	85 c0                	test   %eax,%eax
801001b0:	74 14                	je     801001c6 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b2:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b5:	83 ec 0c             	sub    $0xc,%esp
801001b8:	53                   	push   %ebx
801001b9:	e8 bf 1b 00 00       	call   80101d7d <iderw>
}
801001be:	83 c4 10             	add    $0x10,%esp
801001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c4:	c9                   	leave  
801001c5:	c3                   	ret    
    panic("bwrite");
801001c6:	83 ec 0c             	sub    $0xc,%esp
801001c9:	68 9f 6b 10 80       	push   $0x80106b9f
801001ce:	e8 6e 01 00 00       	call   80100341 <panic>

801001d3 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d3:	55                   	push   %ebp
801001d4:	89 e5                	mov    %esp,%ebp
801001d6:	56                   	push   %esi
801001d7:	53                   	push   %ebx
801001d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001db:	8d 73 0c             	lea    0xc(%ebx),%esi
801001de:	83 ec 0c             	sub    $0xc,%esp
801001e1:	56                   	push   %esi
801001e2:	e8 e2 39 00 00       	call   80103bc9 <holdingsleep>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	85 c0                	test   %eax,%eax
801001ec:	74 69                	je     80100257 <brelse+0x84>
    panic("brelse");

  releasesleep(&b->lock);
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 97 39 00 00       	call   80103b8e <releasesleep>

  acquire(&bcache.lock);
801001f7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001fe:	e8 4b 3b 00 00       	call   80103d4e <acquire>
  b->refcnt--;
80100203:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100206:	48                   	dec    %eax
80100207:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020a:	83 c4 10             	add    $0x10,%esp
8010020d:	85 c0                	test   %eax,%eax
8010020f:	75 2f                	jne    80100240 <brelse+0x6d>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100211:	8b 43 54             	mov    0x54(%ebx),%eax
80100214:	8b 53 50             	mov    0x50(%ebx),%edx
80100217:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021a:	8b 43 50             	mov    0x50(%ebx),%eax
8010021d:	8b 53 54             	mov    0x54(%ebx),%edx
80100220:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100223:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100228:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100232:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100237:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023a:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 20 a5 10 80       	push   $0x8010a520
80100248:	e8 66 3b 00 00       	call   80103db3 <release>
}
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
    panic("brelse");
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 a6 6b 10 80       	push   $0x80106ba6
8010025f:	e8 dd 00 00 00       	call   80100341 <panic>

80100264 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100264:	55                   	push   %ebp
80100265:	89 e5                	mov    %esp,%ebp
80100267:	57                   	push   %edi
80100268:	56                   	push   %esi
80100269:	53                   	push   %ebx
8010026a:	83 ec 28             	sub    $0x28,%esp
8010026d:	8b 7d 08             	mov    0x8(%ebp),%edi
80100270:	8b 75 0c             	mov    0xc(%ebp),%esi
80100273:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100276:	57                   	push   %edi
80100277:	e8 4a 13 00 00       	call   801015c6 <iunlock>
  target = n;
8010027c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
8010027f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100286:	e8 c3 3a 00 00       	call   80103d4e <acquire>
  while(n > 0){
8010028b:	83 c4 10             	add    $0x10,%esp
8010028e:	85 db                	test   %ebx,%ebx
80100290:	0f 8e 8c 00 00 00    	jle    80100322 <consoleread+0xbe>
    while(input.r == input.w){
80100296:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a1:	75 47                	jne    801002ea <consoleread+0x86>
      if(myproc()->killed){
801002a3:	e8 72 30 00 00       	call   8010331a <myproc>
801002a8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ac:	75 17                	jne    801002c5 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002ae:	83 ec 08             	sub    $0x8,%esp
801002b1:	68 20 ef 10 80       	push   $0x8010ef20
801002b6:	68 00 ef 10 80       	push   $0x8010ef00
801002bb:	e8 76 35 00 00       	call   80103836 <sleep>
801002c0:	83 c4 10             	add    $0x10,%esp
801002c3:	eb d1                	jmp    80100296 <consoleread+0x32>
        release(&cons.lock);
801002c5:	83 ec 0c             	sub    $0xc,%esp
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 e1 3a 00 00       	call   80103db3 <release>
        ilock(ip);
801002d2:	89 3c 24             	mov    %edi,(%esp)
801002d5:	e8 2c 12 00 00       	call   80101506 <ilock>
        return -1;
801002da:	83 c4 10             	add    $0x10,%esp
801002dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e5:	5b                   	pop    %ebx
801002e6:	5e                   	pop    %esi
801002e7:	5f                   	pop    %edi
801002e8:	5d                   	pop    %ebp
801002e9:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ea:	8d 50 01             	lea    0x1(%eax),%edx
801002ed:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f3:	89 c2                	mov    %eax,%edx
801002f5:	83 e2 7f             	and    $0x7f,%edx
801002f8:	8a 92 80 ee 10 80    	mov    -0x7fef1180(%edx),%dl
801002fe:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100301:	80 fa 04             	cmp    $0x4,%dl
80100304:	74 12                	je     80100318 <consoleread+0xb4>
    *dst++ = c;
80100306:	8d 46 01             	lea    0x1(%esi),%eax
80100309:	88 16                	mov    %dl,(%esi)
    --n;
8010030b:	4b                   	dec    %ebx
    if(c == '\n')
8010030c:	83 f9 0a             	cmp    $0xa,%ecx
8010030f:	74 11                	je     80100322 <consoleread+0xbe>
    *dst++ = c;
80100311:	89 c6                	mov    %eax,%esi
80100313:	e9 76 ff ff ff       	jmp    8010028e <consoleread+0x2a>
      if(n < target){
80100318:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010031b:	73 05                	jae    80100322 <consoleread+0xbe>
        input.r--;
8010031d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100322:	83 ec 0c             	sub    $0xc,%esp
80100325:	68 20 ef 10 80       	push   $0x8010ef20
8010032a:	e8 84 3a 00 00       	call   80103db3 <release>
  ilock(ip);
8010032f:	89 3c 24             	mov    %edi,(%esp)
80100332:	e8 cf 11 00 00       	call   80101506 <ilock>
  return target - n;
80100337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033a:	29 d8                	sub    %ebx,%eax
8010033c:	83 c4 10             	add    $0x10,%esp
8010033f:	eb a1                	jmp    801002e2 <consoleread+0x7e>

80100341 <panic>:
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
80100344:	53                   	push   %ebx
80100345:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100348:	fa                   	cli    
  cons.locking = 0;
80100349:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100350:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100353:	e8 8b 1f 00 00       	call   801022e3 <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 ad 6b 10 80       	push   $0x80106bad
80100361:	e8 74 02 00 00       	call   801005da <cprintf>
  cprintf(s);
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 69 02 00 00       	call   801005da <cprintf>
  cprintf("\n");
80100371:	c7 04 24 ef 75 10 80 	movl   $0x801075ef,(%esp)
80100378:	e8 5d 02 00 00       	call   801005da <cprintf>
  getcallerpcs(&s, pcs);
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100383:	50                   	push   %eax
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 a5 38 00 00       	call   80103c32 <getcallerpcs>
  for(i=0; i<10; i++)
8010038d:	83 c4 10             	add    $0x10,%esp
80100390:	bb 00 00 00 00       	mov    $0x0,%ebx
80100395:	eb 15                	jmp    801003ac <panic+0x6b>
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
8010039e:	68 c1 6b 10 80       	push   $0x80106bc1
801003a3:	e8 32 02 00 00       	call   801005da <cprintf>
  for(i=0; i<10; i++)
801003a8:	43                   	inc    %ebx
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	83 fb 09             	cmp    $0x9,%ebx
801003af:	7e e6                	jle    80100397 <panic+0x56>
  panicked = 1; // freeze other CPU
801003b1:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003b8:	00 00 00 
  for(;;)
801003bb:	eb fe                	jmp    801003bb <panic+0x7a>

801003bd <cgaputc>:
{
801003bd:	55                   	push   %ebp
801003be:	89 e5                	mov    %esp,%ebp
801003c0:	57                   	push   %edi
801003c1:	56                   	push   %esi
801003c2:	53                   	push   %ebx
801003c3:	83 ec 0c             	sub    $0xc,%esp
801003c6:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003c8:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003cd:	b0 0e                	mov    $0xe,%al
801003cf:	89 fa                	mov    %edi,%edx
801003d1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d2:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003d7:	89 ca                	mov    %ecx,%edx
801003d9:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003da:	0f b6 f0             	movzbl %al,%esi
801003dd:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e0:	b0 0f                	mov    $0xf,%al
801003e2:	89 fa                	mov    %edi,%edx
801003e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e5:	89 ca                	mov    %ecx,%edx
801003e7:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003e8:	0f b6 c8             	movzbl %al,%ecx
801003eb:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003ed:	83 fb 0a             	cmp    $0xa,%ebx
801003f0:	74 5a                	je     8010044c <cgaputc+0x8f>
  else if(c == BACKSPACE){
801003f2:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003f8:	74 62                	je     8010045c <cgaputc+0x9f>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003fa:	0f b6 c3             	movzbl %bl,%eax
801003fd:	8d 59 01             	lea    0x1(%ecx),%ebx
80100400:	80 cc 07             	or     $0x7,%ah
80100403:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
8010040a:	80 
  if(pos < 0 || pos > 25*80)
8010040b:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100411:	77 56                	ja     80100469 <cgaputc+0xac>
  if((pos/80) >= 24){  // Scroll up.
80100413:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100419:	7f 5b                	jg     80100476 <cgaputc+0xb9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100420:	b0 0e                	mov    $0xe,%al
80100422:	89 f2                	mov    %esi,%edx
80100424:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100425:	0f b6 c7             	movzbl %bh,%eax
80100428:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010042d:	89 ca                	mov    %ecx,%edx
8010042f:	ee                   	out    %al,(%dx)
80100430:	b0 0f                	mov    $0xf,%al
80100432:	89 f2                	mov    %esi,%edx
80100434:	ee                   	out    %al,(%dx)
80100435:	88 d8                	mov    %bl,%al
80100437:	89 ca                	mov    %ecx,%edx
80100439:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010043a:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100441:	80 20 07 
}
80100444:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100447:	5b                   	pop    %ebx
80100448:	5e                   	pop    %esi
80100449:	5f                   	pop    %edi
8010044a:	5d                   	pop    %ebp
8010044b:	c3                   	ret    
    pos += 80 - pos%80;
8010044c:	bb 50 00 00 00       	mov    $0x50,%ebx
80100451:	89 c8                	mov    %ecx,%eax
80100453:	99                   	cltd   
80100454:	f7 fb                	idiv   %ebx
80100456:	29 d3                	sub    %edx,%ebx
80100458:	01 cb                	add    %ecx,%ebx
8010045a:	eb af                	jmp    8010040b <cgaputc+0x4e>
    if(pos > 0) --pos;
8010045c:	85 c9                	test   %ecx,%ecx
8010045e:	7e 05                	jle    80100465 <cgaputc+0xa8>
80100460:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100463:	eb a6                	jmp    8010040b <cgaputc+0x4e>
  pos |= inb(CRTPORT+1);
80100465:	89 cb                	mov    %ecx,%ebx
80100467:	eb a2                	jmp    8010040b <cgaputc+0x4e>
    panic("pos under/overflow");
80100469:	83 ec 0c             	sub    $0xc,%esp
8010046c:	68 c5 6b 10 80       	push   $0x80106bc5
80100471:	e8 cb fe ff ff       	call   80100341 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100476:	83 ec 04             	sub    $0x4,%esp
80100479:	68 60 0e 00 00       	push   $0xe60
8010047e:	68 a0 80 0b 80       	push   $0x800b80a0
80100483:	68 00 80 0b 80       	push   $0x800b8000
80100488:	e8 e3 39 00 00       	call   80103e70 <memmove>
    pos -= 80;
8010048d:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100490:	b8 80 07 00 00       	mov    $0x780,%eax
80100495:	29 d8                	sub    %ebx,%eax
80100497:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
8010049e:	83 c4 0c             	add    $0xc,%esp
801004a1:	01 c0                	add    %eax,%eax
801004a3:	50                   	push   %eax
801004a4:	6a 00                	push   $0x0
801004a6:	52                   	push   %edx
801004a7:	e8 4e 39 00 00       	call   80103dfa <memset>
801004ac:	83 c4 10             	add    $0x10,%esp
801004af:	e9 67 ff ff ff       	jmp    8010041b <cgaputc+0x5e>

801004b4 <consputc>:
  if(panicked){
801004b4:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004bb:	74 03                	je     801004c0 <consputc+0xc>
  asm volatile("cli");
801004bd:	fa                   	cli    
    for(;;)
801004be:	eb fe                	jmp    801004be <consputc+0xa>
{
801004c0:	55                   	push   %ebp
801004c1:	89 e5                	mov    %esp,%ebp
801004c3:	53                   	push   %ebx
801004c4:	83 ec 04             	sub    $0x4,%esp
801004c7:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004c9:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ce:	74 18                	je     801004e8 <consputc+0x34>
    uartputc(c);
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	50                   	push   %eax
801004d4:	e8 df 50 00 00       	call   801055b8 <uartputc>
801004d9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004dc:	89 d8                	mov    %ebx,%eax
801004de:	e8 da fe ff ff       	call   801003bd <cgaputc>
}
801004e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801004e6:	c9                   	leave  
801004e7:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e8:	83 ec 0c             	sub    $0xc,%esp
801004eb:	6a 08                	push   $0x8
801004ed:	e8 c6 50 00 00       	call   801055b8 <uartputc>
801004f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f9:	e8 ba 50 00 00       	call   801055b8 <uartputc>
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 ae 50 00 00       	call   801055b8 <uartputc>
8010050a:	83 c4 10             	add    $0x10,%esp
8010050d:	eb cd                	jmp    801004dc <consputc+0x28>

8010050f <printint>:
{
8010050f:	55                   	push   %ebp
80100510:	89 e5                	mov    %esp,%ebp
80100512:	57                   	push   %edi
80100513:	56                   	push   %esi
80100514:	53                   	push   %ebx
80100515:	83 ec 2c             	sub    $0x2c,%esp
80100518:	89 d6                	mov    %edx,%esi
8010051a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010051d:	85 c9                	test   %ecx,%ecx
8010051f:	74 0c                	je     8010052d <printint+0x1e>
80100521:	89 c7                	mov    %eax,%edi
80100523:	c1 ef 1f             	shr    $0x1f,%edi
80100526:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100529:	85 c0                	test   %eax,%eax
8010052b:	78 35                	js     80100562 <printint+0x53>
    x = xx;
8010052d:	89 c1                	mov    %eax,%ecx
  i = 0;
8010052f:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100534:	89 c8                	mov    %ecx,%eax
80100536:	ba 00 00 00 00       	mov    $0x0,%edx
8010053b:	f7 f6                	div    %esi
8010053d:	89 df                	mov    %ebx,%edi
8010053f:	43                   	inc    %ebx
80100540:	8a 92 f0 6b 10 80    	mov    -0x7fef9410(%edx),%dl
80100546:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
8010054a:	89 ca                	mov    %ecx,%edx
8010054c:	89 c1                	mov    %eax,%ecx
8010054e:	39 d6                	cmp    %edx,%esi
80100550:	76 e2                	jbe    80100534 <printint+0x25>
  if(sign)
80100552:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100556:	74 1a                	je     80100572 <printint+0x63>
    buf[i++] = '-';
80100558:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010055d:	8d 5f 02             	lea    0x2(%edi),%ebx
80100560:	eb 10                	jmp    80100572 <printint+0x63>
    x = -xx;
80100562:	f7 d8                	neg    %eax
80100564:	89 c1                	mov    %eax,%ecx
80100566:	eb c7                	jmp    8010052f <printint+0x20>
    consputc(buf[i]);
80100568:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010056d:	e8 42 ff ff ff       	call   801004b4 <consputc>
  while(--i >= 0)
80100572:	4b                   	dec    %ebx
80100573:	79 f3                	jns    80100568 <printint+0x59>
}
80100575:	83 c4 2c             	add    $0x2c,%esp
80100578:	5b                   	pop    %ebx
80100579:	5e                   	pop    %esi
8010057a:	5f                   	pop    %edi
8010057b:	5d                   	pop    %ebp
8010057c:	c3                   	ret    

8010057d <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010057d:	55                   	push   %ebp
8010057e:	89 e5                	mov    %esp,%ebp
80100580:	57                   	push   %edi
80100581:	56                   	push   %esi
80100582:	53                   	push   %ebx
80100583:	83 ec 18             	sub    $0x18,%esp
80100586:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100589:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010058c:	ff 75 08             	push   0x8(%ebp)
8010058f:	e8 32 10 00 00       	call   801015c6 <iunlock>
  acquire(&cons.lock);
80100594:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010059b:	e8 ae 37 00 00       	call   80103d4e <acquire>
  for(i = 0; i < n; i++)
801005a0:	83 c4 10             	add    $0x10,%esp
801005a3:	bb 00 00 00 00       	mov    $0x0,%ebx
801005a8:	eb 0a                	jmp    801005b4 <consolewrite+0x37>
    consputc(buf[i] & 0xff);
801005aa:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005ae:	e8 01 ff ff ff       	call   801004b4 <consputc>
  for(i = 0; i < n; i++)
801005b3:	43                   	inc    %ebx
801005b4:	39 f3                	cmp    %esi,%ebx
801005b6:	7c f2                	jl     801005aa <consolewrite+0x2d>
  release(&cons.lock);
801005b8:	83 ec 0c             	sub    $0xc,%esp
801005bb:	68 20 ef 10 80       	push   $0x8010ef20
801005c0:	e8 ee 37 00 00       	call   80103db3 <release>
  ilock(ip);
801005c5:	83 c4 04             	add    $0x4,%esp
801005c8:	ff 75 08             	push   0x8(%ebp)
801005cb:	e8 36 0f 00 00       	call   80101506 <ilock>

  return n;
}
801005d0:	89 f0                	mov    %esi,%eax
801005d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    

801005da <cprintf>:
{
801005da:	55                   	push   %ebp
801005db:	89 e5                	mov    %esp,%ebp
801005dd:	57                   	push   %edi
801005de:	56                   	push   %esi
801005df:	53                   	push   %ebx
801005e0:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005e3:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005eb:	85 c0                	test   %eax,%eax
801005ed:	75 10                	jne    801005ff <cprintf+0x25>
  if (fmt == 0)
801005ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801005f3:	74 1c                	je     80100611 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
801005f5:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005f8:	be 00 00 00 00       	mov    $0x0,%esi
801005fd:	eb 25                	jmp    80100624 <cprintf+0x4a>
    acquire(&cons.lock);
801005ff:	83 ec 0c             	sub    $0xc,%esp
80100602:	68 20 ef 10 80       	push   $0x8010ef20
80100607:	e8 42 37 00 00       	call   80103d4e <acquire>
8010060c:	83 c4 10             	add    $0x10,%esp
8010060f:	eb de                	jmp    801005ef <cprintf+0x15>
    panic("null fmt");
80100611:	83 ec 0c             	sub    $0xc,%esp
80100614:	68 df 6b 10 80       	push   $0x80106bdf
80100619:	e8 23 fd ff ff       	call   80100341 <panic>
      consputc(c);
8010061e:	e8 91 fe ff ff       	call   801004b4 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100623:	46                   	inc    %esi
80100624:	8b 55 08             	mov    0x8(%ebp),%edx
80100627:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010062b:	85 c0                	test   %eax,%eax
8010062d:	0f 84 ac 00 00 00    	je     801006df <cprintf+0x105>
    if(c != '%'){
80100633:	83 f8 25             	cmp    $0x25,%eax
80100636:	75 e6                	jne    8010061e <cprintf+0x44>
    c = fmt[++i] & 0xff;
80100638:	46                   	inc    %esi
80100639:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
8010063d:	85 db                	test   %ebx,%ebx
8010063f:	0f 84 9a 00 00 00    	je     801006df <cprintf+0x105>
    switch(c){
80100645:	83 fb 70             	cmp    $0x70,%ebx
80100648:	74 2e                	je     80100678 <cprintf+0x9e>
8010064a:	7f 22                	jg     8010066e <cprintf+0x94>
8010064c:	83 fb 25             	cmp    $0x25,%ebx
8010064f:	74 69                	je     801006ba <cprintf+0xe0>
80100651:	83 fb 64             	cmp    $0x64,%ebx
80100654:	75 73                	jne    801006c9 <cprintf+0xef>
      printint(*argp++, 10, 1);
80100656:	8d 5f 04             	lea    0x4(%edi),%ebx
80100659:	8b 07                	mov    (%edi),%eax
8010065b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100660:	ba 0a 00 00 00       	mov    $0xa,%edx
80100665:	e8 a5 fe ff ff       	call   8010050f <printint>
8010066a:	89 df                	mov    %ebx,%edi
      break;
8010066c:	eb b5                	jmp    80100623 <cprintf+0x49>
    switch(c){
8010066e:	83 fb 73             	cmp    $0x73,%ebx
80100671:	74 1d                	je     80100690 <cprintf+0xb6>
80100673:	83 fb 78             	cmp    $0x78,%ebx
80100676:	75 51                	jne    801006c9 <cprintf+0xef>
      printint(*argp++, 16, 0);
80100678:	8d 5f 04             	lea    0x4(%edi),%ebx
8010067b:	8b 07                	mov    (%edi),%eax
8010067d:	b9 00 00 00 00       	mov    $0x0,%ecx
80100682:	ba 10 00 00 00       	mov    $0x10,%edx
80100687:	e8 83 fe ff ff       	call   8010050f <printint>
8010068c:	89 df                	mov    %ebx,%edi
      break;
8010068e:	eb 93                	jmp    80100623 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
80100690:	8d 47 04             	lea    0x4(%edi),%eax
80100693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100696:	8b 1f                	mov    (%edi),%ebx
80100698:	85 db                	test   %ebx,%ebx
8010069a:	75 10                	jne    801006ac <cprintf+0xd2>
        s = "(null)";
8010069c:	bb d8 6b 10 80       	mov    $0x80106bd8,%ebx
801006a1:	eb 09                	jmp    801006ac <cprintf+0xd2>
        consputc(*s);
801006a3:	0f be c0             	movsbl %al,%eax
801006a6:	e8 09 fe ff ff       	call   801004b4 <consputc>
      for(; *s; s++)
801006ab:	43                   	inc    %ebx
801006ac:	8a 03                	mov    (%ebx),%al
801006ae:	84 c0                	test   %al,%al
801006b0:	75 f1                	jne    801006a3 <cprintf+0xc9>
      if((s = (char*)*argp++) == 0)
801006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006b5:	e9 69 ff ff ff       	jmp    80100623 <cprintf+0x49>
      consputc('%');
801006ba:	b8 25 00 00 00       	mov    $0x25,%eax
801006bf:	e8 f0 fd ff ff       	call   801004b4 <consputc>
      break;
801006c4:	e9 5a ff ff ff       	jmp    80100623 <cprintf+0x49>
      consputc('%');
801006c9:	b8 25 00 00 00       	mov    $0x25,%eax
801006ce:	e8 e1 fd ff ff       	call   801004b4 <consputc>
      consputc(c);
801006d3:	89 d8                	mov    %ebx,%eax
801006d5:	e8 da fd ff ff       	call   801004b4 <consputc>
      break;
801006da:	e9 44 ff ff ff       	jmp    80100623 <cprintf+0x49>
  if(locking)
801006df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801006e3:	75 08                	jne    801006ed <cprintf+0x113>
}
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	5b                   	pop    %ebx
801006e9:	5e                   	pop    %esi
801006ea:	5f                   	pop    %edi
801006eb:	5d                   	pop    %ebp
801006ec:	c3                   	ret    
    release(&cons.lock);
801006ed:	83 ec 0c             	sub    $0xc,%esp
801006f0:	68 20 ef 10 80       	push   $0x8010ef20
801006f5:	e8 b9 36 00 00       	call   80103db3 <release>
801006fa:	83 c4 10             	add    $0x10,%esp
}
801006fd:	eb e6                	jmp    801006e5 <cprintf+0x10b>

801006ff <consoleintr>:
{
801006ff:	55                   	push   %ebp
80100700:	89 e5                	mov    %esp,%ebp
80100702:	57                   	push   %edi
80100703:	56                   	push   %esi
80100704:	53                   	push   %ebx
80100705:	83 ec 18             	sub    $0x18,%esp
80100708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010070b:	68 20 ef 10 80       	push   $0x8010ef20
80100710:	e8 39 36 00 00       	call   80103d4e <acquire>
  while((c = getc()) >= 0){
80100715:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100718:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010071d:	eb 13                	jmp    80100732 <consoleintr+0x33>
    switch(c){
8010071f:	83 ff 08             	cmp    $0x8,%edi
80100722:	0f 84 d1 00 00 00    	je     801007f9 <consoleintr+0xfa>
80100728:	83 ff 10             	cmp    $0x10,%edi
8010072b:	75 25                	jne    80100752 <consoleintr+0x53>
8010072d:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100732:	ff d3                	call   *%ebx
80100734:	89 c7                	mov    %eax,%edi
80100736:	85 c0                	test   %eax,%eax
80100738:	0f 88 eb 00 00 00    	js     80100829 <consoleintr+0x12a>
    switch(c){
8010073e:	83 ff 15             	cmp    $0x15,%edi
80100741:	0f 84 8d 00 00 00    	je     801007d4 <consoleintr+0xd5>
80100747:	7e d6                	jle    8010071f <consoleintr+0x20>
80100749:	83 ff 7f             	cmp    $0x7f,%edi
8010074c:	0f 84 a7 00 00 00    	je     801007f9 <consoleintr+0xfa>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100752:	85 ff                	test   %edi,%edi
80100754:	74 dc                	je     80100732 <consoleintr+0x33>
80100756:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010075b:	89 c2                	mov    %eax,%edx
8010075d:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100763:	83 fa 7f             	cmp    $0x7f,%edx
80100766:	77 ca                	ja     80100732 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
80100768:	83 ff 0d             	cmp    $0xd,%edi
8010076b:	0f 84 ae 00 00 00    	je     8010081f <consoleintr+0x120>
        input.buf[input.e++ % INPUT_BUF] = c;
80100771:	8d 50 01             	lea    0x1(%eax),%edx
80100774:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
8010077a:	83 e0 7f             	and    $0x7f,%eax
8010077d:	89 f9                	mov    %edi,%ecx
8010077f:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
80100785:	89 f8                	mov    %edi,%eax
80100787:	e8 28 fd ff ff       	call   801004b4 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010078c:	83 ff 0a             	cmp    $0xa,%edi
8010078f:	74 15                	je     801007a6 <consoleintr+0xa7>
80100791:	83 ff 04             	cmp    $0x4,%edi
80100794:	74 10                	je     801007a6 <consoleintr+0xa7>
80100796:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010079b:	83 e8 80             	sub    $0xffffff80,%eax
8010079e:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007a4:	75 8c                	jne    80100732 <consoleintr+0x33>
          input.w = input.e;
801007a6:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007ab:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801007b0:	83 ec 0c             	sub    $0xc,%esp
801007b3:	68 00 ef 10 80       	push   $0x8010ef00
801007b8:	e8 eb 31 00 00       	call   801039a8 <wakeup>
801007bd:	83 c4 10             	add    $0x10,%esp
801007c0:	e9 6d ff ff ff       	jmp    80100732 <consoleintr+0x33>
        input.e--;
801007c5:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
801007ca:	b8 00 01 00 00       	mov    $0x100,%eax
801007cf:	e8 e0 fc ff ff       	call   801004b4 <consputc>
      while(input.e != input.w &&
801007d4:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007d9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007df:	0f 84 4d ff ff ff    	je     80100732 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007e5:	48                   	dec    %eax
801007e6:	89 c2                	mov    %eax,%edx
801007e8:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007eb:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801007f2:	75 d1                	jne    801007c5 <consoleintr+0xc6>
801007f4:	e9 39 ff ff ff       	jmp    80100732 <consoleintr+0x33>
      if(input.e != input.w){
801007f9:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007fe:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100804:	0f 84 28 ff ff ff    	je     80100732 <consoleintr+0x33>
        input.e--;
8010080a:	48                   	dec    %eax
8010080b:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
80100810:	b8 00 01 00 00       	mov    $0x100,%eax
80100815:	e8 9a fc ff ff       	call   801004b4 <consputc>
8010081a:	e9 13 ff ff ff       	jmp    80100732 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010081f:	bf 0a 00 00 00       	mov    $0xa,%edi
80100824:	e9 48 ff ff ff       	jmp    80100771 <consoleintr+0x72>
  release(&cons.lock);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 20 ef 10 80       	push   $0x8010ef20
80100831:	e8 7d 35 00 00       	call   80103db3 <release>
  if(doprocdump) {
80100836:	83 c4 10             	add    $0x10,%esp
80100839:	85 f6                	test   %esi,%esi
8010083b:	75 08                	jne    80100845 <consoleintr+0x146>
}
8010083d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100840:	5b                   	pop    %ebx
80100841:	5e                   	pop    %esi
80100842:	5f                   	pop    %edi
80100843:	5d                   	pop    %ebp
80100844:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100845:	e8 0f 32 00 00       	call   80103a59 <procdump>
}
8010084a:	eb f1                	jmp    8010083d <consoleintr+0x13e>

8010084c <consoleinit>:

void
consoleinit(void)
{
8010084c:	55                   	push   %ebp
8010084d:	89 e5                	mov    %esp,%ebp
8010084f:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100852:	68 e8 6b 10 80       	push   $0x80106be8
80100857:	68 20 ef 10 80       	push   $0x8010ef20
8010085c:	e8 b6 33 00 00       	call   80103c17 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100861:	c7 05 0c f9 10 80 7d 	movl   $0x8010057d,0x8010f90c
80100868:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010086b:	c7 05 08 f9 10 80 64 	movl   $0x80100264,0x8010f908
80100872:	02 10 80 
  cons.locking = 1;
80100875:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
8010087c:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
8010087f:	83 c4 08             	add    $0x8,%esp
80100882:	6a 00                	push   $0x0
80100884:	6a 01                	push   $0x1
80100886:	e8 5a 16 00 00       	call   80101ee5 <ioapicenable>
}
8010088b:	83 c4 10             	add    $0x10,%esp
8010088e:	c9                   	leave  
8010088f:	c3                   	ret    

80100890 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100890:	55                   	push   %ebp
80100891:	89 e5                	mov    %esp,%ebp
80100893:	57                   	push   %edi
80100894:	56                   	push   %esi
80100895:	53                   	push   %ebx
80100896:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010089c:	e8 79 2a 00 00       	call   8010331a <myproc>
801008a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008a7:	e8 30 1e 00 00       	call   801026dc <begin_op>

  if((ip = namei(path)) == 0){
801008ac:	83 ec 0c             	sub    $0xc,%esp
801008af:	ff 75 08             	push   0x8(%ebp)
801008b2:	e8 b3 12 00 00       	call   80101b6a <namei>
801008b7:	83 c4 10             	add    $0x10,%esp
801008ba:	85 c0                	test   %eax,%eax
801008bc:	74 56                	je     80100914 <exec+0x84>
801008be:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	50                   	push   %eax
801008c4:	e8 3d 0c 00 00       	call   80101506 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008c9:	6a 34                	push   $0x34
801008cb:	6a 00                	push   $0x0
801008cd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801008d3:	50                   	push   %eax
801008d4:	53                   	push   %ebx
801008d5:	e8 19 0e 00 00       	call   801016f3 <readi>
801008da:	83 c4 20             	add    $0x20,%esp
801008dd:	83 f8 34             	cmp    $0x34,%eax
801008e0:	75 0c                	jne    801008ee <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801008e2:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801008e9:	45 4c 46 
801008ec:	74 42                	je     80100930 <exec+0xa0>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
801008ee:	85 db                	test   %ebx,%ebx
801008f0:	0f 84 cc 02 00 00    	je     80100bc2 <exec+0x332>
    iunlockput(ip);
801008f6:	83 ec 0c             	sub    $0xc,%esp
801008f9:	53                   	push   %ebx
801008fa:	e8 aa 0d 00 00       	call   801016a9 <iunlockput>
    end_op();
801008ff:	e8 54 1e 00 00       	call   80102758 <end_op>
80100904:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010090c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090f:	5b                   	pop    %ebx
80100910:	5e                   	pop    %esi
80100911:	5f                   	pop    %edi
80100912:	5d                   	pop    %ebp
80100913:	c3                   	ret    
    end_op();
80100914:	e8 3f 1e 00 00       	call   80102758 <end_op>
    cprintf("exec: fail\n");
80100919:	83 ec 0c             	sub    $0xc,%esp
8010091c:	68 01 6c 10 80       	push   $0x80106c01
80100921:	e8 b4 fc ff ff       	call   801005da <cprintf>
    return -1;
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010092e:	eb dc                	jmp    8010090c <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
80100930:	e8 fd 5f 00 00       	call   80106932 <setupkvm>
80100935:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010093b:	85 c0                	test   %eax,%eax
8010093d:	0f 84 14 01 00 00    	je     80100a57 <exec+0x1c7>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100943:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100949:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100950:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100953:	be 00 00 00 00       	mov    $0x0,%esi
80100958:	eb 04                	jmp    8010095e <exec+0xce>
8010095a:	46                   	inc    %esi
8010095b:	8d 47 20             	lea    0x20(%edi),%eax
8010095e:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100965:	39 f2                	cmp    %esi,%edx
80100967:	0f 8e a1 00 00 00    	jle    80100a0e <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
8010096d:	89 c7                	mov    %eax,%edi
8010096f:	6a 20                	push   $0x20
80100971:	50                   	push   %eax
80100972:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100978:	50                   	push   %eax
80100979:	53                   	push   %ebx
8010097a:	e8 74 0d 00 00       	call   801016f3 <readi>
8010097f:	83 c4 10             	add    $0x10,%esp
80100982:	83 f8 20             	cmp    $0x20,%eax
80100985:	0f 85 cc 00 00 00    	jne    80100a57 <exec+0x1c7>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
8010098b:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100992:	75 c6                	jne    8010095a <exec+0xca>
80100994:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010099a:	85 c0                	test   %eax,%eax
8010099c:	74 bc                	je     8010095a <exec+0xca>
    if(ph.memsz < ph.filesz)
8010099e:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009a4:	0f 82 ad 00 00 00    	jb     80100a57 <exec+0x1c7>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009aa:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009b0:	0f 82 a1 00 00 00    	jb     80100a57 <exec+0x1c7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009b6:	83 ec 04             	sub    $0x4,%esp
801009b9:	50                   	push   %eax
801009ba:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801009c0:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009c6:	e8 04 5e 00 00       	call   801067cf <allocuvm>
801009cb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009d1:	83 c4 10             	add    $0x10,%esp
801009d4:	85 c0                	test   %eax,%eax
801009d6:	74 7f                	je     80100a57 <exec+0x1c7>
    if(ph.vaddr % PGSIZE != 0)
801009d8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801009de:	a9 ff 0f 00 00       	test   $0xfff,%eax
801009e3:	75 72                	jne    80100a57 <exec+0x1c7>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801009e5:	83 ec 0c             	sub    $0xc,%esp
801009e8:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801009ee:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801009f4:	53                   	push   %ebx
801009f5:	50                   	push   %eax
801009f6:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009fc:	e8 a0 5c 00 00       	call   801066a1 <loaduvm>
80100a01:	83 c4 20             	add    $0x20,%esp
80100a04:	85 c0                	test   %eax,%eax
80100a06:	0f 89 4e ff ff ff    	jns    8010095a <exec+0xca>
80100a0c:	eb 49                	jmp    80100a57 <exec+0x1c7>
  iunlockput(ip);
80100a0e:	83 ec 0c             	sub    $0xc,%esp
80100a11:	53                   	push   %ebx
80100a12:	e8 92 0c 00 00       	call   801016a9 <iunlockput>
  end_op();
80100a17:	e8 3c 1d 00 00       	call   80102758 <end_op>
  sz = PGROUNDUP(sz);
80100a1c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a22:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a2c:	83 c4 0c             	add    $0xc,%esp
80100a2f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a35:	52                   	push   %edx
80100a36:	50                   	push   %eax
80100a37:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100a3d:	57                   	push   %edi
80100a3e:	e8 8c 5d 00 00       	call   801067cf <allocuvm>
80100a43:	89 c6                	mov    %eax,%esi
80100a45:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	75 26                	jne    80100a78 <exec+0x1e8>
  ip = 0;
80100a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a57:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a5d:	85 c0                	test   %eax,%eax
80100a5f:	0f 84 89 fe ff ff    	je     801008ee <exec+0x5e>
    freevm(pgdir, 1);
80100a65:	83 ec 08             	sub    $0x8,%esp
80100a68:	6a 01                	push   $0x1
80100a6a:	50                   	push   %eax
80100a6b:	e8 4c 5e 00 00       	call   801068bc <freevm>
80100a70:	83 c4 10             	add    $0x10,%esp
80100a73:	e9 76 fe ff ff       	jmp    801008ee <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100a78:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7e:	83 ec 08             	sub    $0x8,%esp
80100a81:	50                   	push   %eax
80100a82:	57                   	push   %edi
80100a83:	e8 31 5f 00 00       	call   801069b9 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100a88:	83 c4 10             	add    $0x10,%esp
80100a8b:	bf 00 00 00 00       	mov    $0x0,%edi
80100a90:	eb 08                	jmp    80100a9a <exec+0x20a>
    ustack[3+argc] = sp;
80100a92:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100a99:	47                   	inc    %edi
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100aa0:	8b 03                	mov    (%ebx),%eax
80100aa2:	85 c0                	test   %eax,%eax
80100aa4:	74 43                	je     80100ae9 <exec+0x259>
    if(argc >= MAXARG)
80100aa6:	83 ff 1f             	cmp    $0x1f,%edi
80100aa9:	0f 87 09 01 00 00    	ja     80100bb8 <exec+0x328>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100aaf:	83 ec 0c             	sub    $0xc,%esp
80100ab2:	50                   	push   %eax
80100ab3:	e8 d2 34 00 00       	call   80103f8a <strlen>
80100ab8:	29 c6                	sub    %eax,%esi
80100aba:	4e                   	dec    %esi
80100abb:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100abe:	83 c4 04             	add    $0x4,%esp
80100ac1:	ff 33                	push   (%ebx)
80100ac3:	e8 c2 34 00 00       	call   80103f8a <strlen>
80100ac8:	40                   	inc    %eax
80100ac9:	50                   	push   %eax
80100aca:	ff 33                	push   (%ebx)
80100acc:	56                   	push   %esi
80100acd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad3:	e8 20 60 00 00       	call   80106af8 <copyout>
80100ad8:	83 c4 20             	add    $0x20,%esp
80100adb:	85 c0                	test   %eax,%eax
80100add:	79 b3                	jns    80100a92 <exec+0x202>
  ip = 0;
80100adf:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ae4:	e9 6e ff ff ff       	jmp    80100a57 <exec+0x1c7>
  ustack[3+argc] = 0;
80100ae9:	89 f1                	mov    %esi,%ecx
80100aeb:	89 c3                	mov    %eax,%ebx
80100aed:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100af4:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100af8:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100aff:	ff ff ff 
  ustack[1] = argc;
80100b02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b08:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b0f:	89 f0                	mov    %esi,%eax
80100b11:	29 d0                	sub    %edx,%eax
80100b13:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b19:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b20:	29 c1                	sub    %eax,%ecx
80100b22:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b24:	50                   	push   %eax
80100b25:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b2b:	50                   	push   %eax
80100b2c:	51                   	push   %ecx
80100b2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b33:	e8 c0 5f 00 00       	call   80106af8 <copyout>
80100b38:	83 c4 10             	add    $0x10,%esp
80100b3b:	85 c0                	test   %eax,%eax
80100b3d:	0f 88 14 ff ff ff    	js     80100a57 <exec+0x1c7>
  for(last=s=path; *s; s++)
80100b43:	8b 55 08             	mov    0x8(%ebp),%edx
80100b46:	89 d0                	mov    %edx,%eax
80100b48:	eb 01                	jmp    80100b4b <exec+0x2bb>
80100b4a:	40                   	inc    %eax
80100b4b:	8a 08                	mov    (%eax),%cl
80100b4d:	84 c9                	test   %cl,%cl
80100b4f:	74 0a                	je     80100b5b <exec+0x2cb>
    if(*s == '/')
80100b51:	80 f9 2f             	cmp    $0x2f,%cl
80100b54:	75 f4                	jne    80100b4a <exec+0x2ba>
      last = s+1;
80100b56:	8d 50 01             	lea    0x1(%eax),%edx
80100b59:	eb ef                	jmp    80100b4a <exec+0x2ba>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b5b:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b61:	89 f8                	mov    %edi,%eax
80100b63:	83 c0 6c             	add    $0x6c,%eax
80100b66:	83 ec 04             	sub    $0x4,%esp
80100b69:	6a 10                	push   $0x10
80100b6b:	52                   	push   %edx
80100b6c:	50                   	push   %eax
80100b6d:	e8 e0 33 00 00       	call   80103f52 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100b72:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100b75:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b7b:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100b7e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100b84:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100b86:	8b 47 18             	mov    0x18(%edi),%eax
80100b89:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100b8f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100b92:	8b 47 18             	mov    0x18(%edi),%eax
80100b95:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100b98:	89 3c 24             	mov    %edi,(%esp)
80100b9b:	e8 3d 59 00 00       	call   801064dd <switchuvm>
  freevm(oldpgdir, 1);
80100ba0:	83 c4 08             	add    $0x8,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	53                   	push   %ebx
80100ba6:	e8 11 5d 00 00       	call   801068bc <freevm>
  return 0;
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	b8 00 00 00 00       	mov    $0x0,%eax
80100bb3:	e9 54 fd ff ff       	jmp    8010090c <exec+0x7c>
  ip = 0;
80100bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bbd:	e9 95 fe ff ff       	jmp    80100a57 <exec+0x1c7>
  return -1;
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 40 fd ff ff       	jmp    8010090c <exec+0x7c>

80100bcc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100bcc:	55                   	push   %ebp
80100bcd:	89 e5                	mov    %esp,%ebp
80100bcf:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100bd2:	68 0d 6c 10 80       	push   $0x80106c0d
80100bd7:	68 60 ef 10 80       	push   $0x8010ef60
80100bdc:	e8 36 30 00 00       	call   80103c17 <initlock>
}
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    

80100be6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100be6:	55                   	push   %ebp
80100be7:	89 e5                	mov    %esp,%ebp
80100be9:	53                   	push   %ebx
80100bea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100bed:	68 60 ef 10 80       	push   $0x8010ef60
80100bf2:	e8 57 31 00 00       	call   80103d4e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100bff:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c05:	73 29                	jae    80100c30 <filealloc+0x4a>
    if(f->ref == 0){
80100c07:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c0b:	74 05                	je     80100c12 <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c0d:	83 c3 18             	add    $0x18,%ebx
80100c10:	eb ed                	jmp    80100bff <filealloc+0x19>
      f->ref = 1;
80100c12:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c19:	83 ec 0c             	sub    $0xc,%esp
80100c1c:	68 60 ef 10 80       	push   $0x8010ef60
80100c21:	e8 8d 31 00 00       	call   80103db3 <release>
      return f;
80100c26:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c29:	89 d8                	mov    %ebx,%eax
80100c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    
  release(&ftable.lock);
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	68 60 ef 10 80       	push   $0x8010ef60
80100c38:	e8 76 31 00 00       	call   80103db3 <release>
  return 0;
80100c3d:	83 c4 10             	add    $0x10,%esp
80100c40:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c45:	eb e2                	jmp    80100c29 <filealloc+0x43>

80100c47 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c47:	55                   	push   %ebp
80100c48:	89 e5                	mov    %esp,%ebp
80100c4a:	53                   	push   %ebx
80100c4b:	83 ec 10             	sub    $0x10,%esp
80100c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c51:	68 60 ef 10 80       	push   $0x8010ef60
80100c56:	e8 f3 30 00 00       	call   80103d4e <acquire>
  if(f->ref < 1)
80100c5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	85 c0                	test   %eax,%eax
80100c63:	7e 18                	jle    80100c7d <filedup+0x36>
    panic("filedup");
  f->ref++;
80100c65:	40                   	inc    %eax
80100c66:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	68 60 ef 10 80       	push   $0x8010ef60
80100c71:	e8 3d 31 00 00       	call   80103db3 <release>
  return f;
}
80100c76:	89 d8                	mov    %ebx,%eax
80100c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7b:	c9                   	leave  
80100c7c:	c3                   	ret    
    panic("filedup");
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	68 14 6c 10 80       	push   $0x80106c14
80100c85:	e8 b7 f6 ff ff       	call   80100341 <panic>

80100c8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	57                   	push   %edi
80100c8e:	56                   	push   %esi
80100c8f:	53                   	push   %ebx
80100c90:	83 ec 38             	sub    $0x38,%esp
80100c93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100c96:	68 60 ef 10 80       	push   $0x8010ef60
80100c9b:	e8 ae 30 00 00       	call   80103d4e <acquire>
  if(f->ref < 1)
80100ca0:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	7e 58                	jle    80100d02 <fileclose+0x78>
    panic("fileclose");
  if(--f->ref > 0){
80100caa:	48                   	dec    %eax
80100cab:	89 43 04             	mov    %eax,0x4(%ebx)
80100cae:	85 c0                	test   %eax,%eax
80100cb0:	7f 5d                	jg     80100d0f <fileclose+0x85>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cb2:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cb5:	b9 06 00 00 00       	mov    $0x6,%ecx
80100cba:	89 de                	mov    %ebx,%esi
80100cbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100cbe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100cc5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100ccb:	83 ec 0c             	sub    $0xc,%esp
80100cce:	68 60 ef 10 80       	push   $0x8010ef60
80100cd3:	e8 db 30 00 00       	call   80103db3 <release>

  if(ff.type == FD_PIPE)
80100cd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cdb:	83 c4 10             	add    $0x10,%esp
80100cde:	83 f8 01             	cmp    $0x1,%eax
80100ce1:	74 44                	je     80100d27 <fileclose+0x9d>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ce3:	83 f8 02             	cmp    $0x2,%eax
80100ce6:	75 37                	jne    80100d1f <fileclose+0x95>
    begin_op();
80100ce8:	e8 ef 19 00 00       	call   801026dc <begin_op>
    iput(ff.ip);
80100ced:	83 ec 0c             	sub    $0xc,%esp
80100cf0:	ff 75 e0             	push   -0x20(%ebp)
80100cf3:	e8 13 09 00 00       	call   8010160b <iput>
    end_op();
80100cf8:	e8 5b 1a 00 00       	call   80102758 <end_op>
80100cfd:	83 c4 10             	add    $0x10,%esp
80100d00:	eb 1d                	jmp    80100d1f <fileclose+0x95>
    panic("fileclose");
80100d02:	83 ec 0c             	sub    $0xc,%esp
80100d05:	68 1c 6c 10 80       	push   $0x80106c1c
80100d0a:	e8 32 f6 ff ff       	call   80100341 <panic>
    release(&ftable.lock);
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 60 ef 10 80       	push   $0x8010ef60
80100d17:	e8 97 30 00 00       	call   80103db3 <release>
    return;
80100d1c:	83 c4 10             	add    $0x10,%esp
  }
}
80100d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d22:	5b                   	pop    %ebx
80100d23:	5e                   	pop    %esi
80100d24:	5f                   	pop    %edi
80100d25:	5d                   	pop    %ebp
80100d26:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d27:	83 ec 08             	sub    $0x8,%esp
80100d2a:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d2e:	50                   	push   %eax
80100d2f:	ff 75 dc             	push   -0x24(%ebp)
80100d32:	e8 06 20 00 00       	call   80102d3d <pipeclose>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	eb e3                	jmp    80100d1f <fileclose+0x95>

80100d3c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d3c:	55                   	push   %ebp
80100d3d:	89 e5                	mov    %esp,%ebp
80100d3f:	53                   	push   %ebx
80100d40:	83 ec 04             	sub    $0x4,%esp
80100d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d46:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d49:	75 31                	jne    80100d7c <filestat+0x40>
    ilock(f->ip);
80100d4b:	83 ec 0c             	sub    $0xc,%esp
80100d4e:	ff 73 10             	push   0x10(%ebx)
80100d51:	e8 b0 07 00 00       	call   80101506 <ilock>
    stati(f->ip, st);
80100d56:	83 c4 08             	add    $0x8,%esp
80100d59:	ff 75 0c             	push   0xc(%ebp)
80100d5c:	ff 73 10             	push   0x10(%ebx)
80100d5f:	e8 65 09 00 00       	call   801016c9 <stati>
    iunlock(f->ip);
80100d64:	83 c4 04             	add    $0x4,%esp
80100d67:	ff 73 10             	push   0x10(%ebx)
80100d6a:	e8 57 08 00 00       	call   801015c6 <iunlock>
    return 0;
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
  return -1;
80100d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d81:	eb f4                	jmp    80100d77 <filestat+0x3b>

80100d83 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100d83:	55                   	push   %ebp
80100d84:	89 e5                	mov    %esp,%ebp
80100d86:	56                   	push   %esi
80100d87:	53                   	push   %ebx
80100d88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100d8b:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100d8f:	74 70                	je     80100e01 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100d91:	8b 03                	mov    (%ebx),%eax
80100d93:	83 f8 01             	cmp    $0x1,%eax
80100d96:	74 44                	je     80100ddc <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100d98:	83 f8 02             	cmp    $0x2,%eax
80100d9b:	75 57                	jne    80100df4 <fileread+0x71>
    ilock(f->ip);
80100d9d:	83 ec 0c             	sub    $0xc,%esp
80100da0:	ff 73 10             	push   0x10(%ebx)
80100da3:	e8 5e 07 00 00       	call   80101506 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100da8:	ff 75 10             	push   0x10(%ebp)
80100dab:	ff 73 14             	push   0x14(%ebx)
80100dae:	ff 75 0c             	push   0xc(%ebp)
80100db1:	ff 73 10             	push   0x10(%ebx)
80100db4:	e8 3a 09 00 00       	call   801016f3 <readi>
80100db9:	89 c6                	mov    %eax,%esi
80100dbb:	83 c4 20             	add    $0x20,%esp
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	7e 03                	jle    80100dc5 <fileread+0x42>
      f->off += r;
80100dc2:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	ff 73 10             	push   0x10(%ebx)
80100dcb:	e8 f6 07 00 00       	call   801015c6 <iunlock>
    return r;
80100dd0:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100dd3:	89 f0                	mov    %esi,%eax
80100dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100dd8:	5b                   	pop    %ebx
80100dd9:	5e                   	pop    %esi
80100dda:	5d                   	pop    %ebp
80100ddb:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ddc:	83 ec 04             	sub    $0x4,%esp
80100ddf:	ff 75 10             	push   0x10(%ebp)
80100de2:	ff 75 0c             	push   0xc(%ebp)
80100de5:	ff 73 0c             	push   0xc(%ebx)
80100de8:	e8 9e 20 00 00       	call   80102e8b <piperead>
80100ded:	89 c6                	mov    %eax,%esi
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	eb df                	jmp    80100dd3 <fileread+0x50>
  panic("fileread");
80100df4:	83 ec 0c             	sub    $0xc,%esp
80100df7:	68 26 6c 10 80       	push   $0x80106c26
80100dfc:	e8 40 f5 ff ff       	call   80100341 <panic>
    return -1;
80100e01:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e06:	eb cb                	jmp    80100dd3 <fileread+0x50>

80100e08 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e08:	55                   	push   %ebp
80100e09:	89 e5                	mov    %esp,%ebp
80100e0b:	57                   	push   %edi
80100e0c:	56                   	push   %esi
80100e0d:	53                   	push   %ebx
80100e0e:	83 ec 1c             	sub    $0x1c,%esp
80100e11:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e14:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e18:	0f 84 cc 00 00 00    	je     80100eea <filewrite+0xe2>
    return -1;
  if(f->type == FD_PIPE)
80100e1e:	8b 06                	mov    (%esi),%eax
80100e20:	83 f8 01             	cmp    $0x1,%eax
80100e23:	74 10                	je     80100e35 <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e25:	83 f8 02             	cmp    $0x2,%eax
80100e28:	0f 85 af 00 00 00    	jne    80100edd <filewrite+0xd5>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e2e:	bf 00 00 00 00       	mov    $0x0,%edi
80100e33:	eb 67                	jmp    80100e9c <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100e35:	83 ec 04             	sub    $0x4,%esp
80100e38:	ff 75 10             	push   0x10(%ebp)
80100e3b:	ff 75 0c             	push   0xc(%ebp)
80100e3e:	ff 76 0c             	push   0xc(%esi)
80100e41:	e8 83 1f 00 00       	call   80102dc9 <pipewrite>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	e9 82 00 00 00       	jmp    80100ed0 <filewrite+0xc8>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100e4e:	e8 89 18 00 00       	call   801026dc <begin_op>
      ilock(f->ip);
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	ff 76 10             	push   0x10(%esi)
80100e59:	e8 a8 06 00 00       	call   80101506 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100e5e:	ff 75 e4             	push   -0x1c(%ebp)
80100e61:	ff 76 14             	push   0x14(%esi)
80100e64:	89 f8                	mov    %edi,%eax
80100e66:	03 45 0c             	add    0xc(%ebp),%eax
80100e69:	50                   	push   %eax
80100e6a:	ff 76 10             	push   0x10(%esi)
80100e6d:	e8 81 09 00 00       	call   801017f3 <writei>
80100e72:	89 c3                	mov    %eax,%ebx
80100e74:	83 c4 20             	add    $0x20,%esp
80100e77:	85 c0                	test   %eax,%eax
80100e79:	7e 03                	jle    80100e7e <filewrite+0x76>
        f->off += r;
80100e7b:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
80100e81:	ff 76 10             	push   0x10(%esi)
80100e84:	e8 3d 07 00 00       	call   801015c6 <iunlock>
      end_op();
80100e89:	e8 ca 18 00 00       	call   80102758 <end_op>

      if(r < 0)
80100e8e:	83 c4 10             	add    $0x10,%esp
80100e91:	85 db                	test   %ebx,%ebx
80100e93:	78 31                	js     80100ec6 <filewrite+0xbe>
        break;
      if(r != n1)
80100e95:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100e98:	75 1f                	jne    80100eb9 <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100e9a:	01 df                	add    %ebx,%edi
    while(i < n){
80100e9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100e9f:	7d 25                	jge    80100ec6 <filewrite+0xbe>
      int n1 = n - i;
80100ea1:	8b 45 10             	mov    0x10(%ebp),%eax
80100ea4:	29 f8                	sub    %edi,%eax
80100ea6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100ea9:	3d 00 06 00 00       	cmp    $0x600,%eax
80100eae:	7e 9e                	jle    80100e4e <filewrite+0x46>
        n1 = max;
80100eb0:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100eb7:	eb 95                	jmp    80100e4e <filewrite+0x46>
        panic("short filewrite");
80100eb9:	83 ec 0c             	sub    $0xc,%esp
80100ebc:	68 2f 6c 10 80       	push   $0x80106c2f
80100ec1:	e8 7b f4 ff ff       	call   80100341 <panic>
    }
    return i == n ? n : -1;
80100ec6:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ec9:	74 0d                	je     80100ed8 <filewrite+0xd0>
80100ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	c3                   	ret    
    return i == n ? n : -1;
80100ed8:	8b 45 10             	mov    0x10(%ebp),%eax
80100edb:	eb f3                	jmp    80100ed0 <filewrite+0xc8>
  panic("filewrite");
80100edd:	83 ec 0c             	sub    $0xc,%esp
80100ee0:	68 35 6c 10 80       	push   $0x80106c35
80100ee5:	e8 57 f4 ff ff       	call   80100341 <panic>
    return -1;
80100eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eef:	eb df                	jmp    80100ed0 <filewrite+0xc8>

80100ef1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100ef1:	55                   	push   %ebp
80100ef2:	89 e5                	mov    %esp,%ebp
80100ef4:	57                   	push   %edi
80100ef5:	56                   	push   %esi
80100ef6:	53                   	push   %ebx
80100ef7:	83 ec 0c             	sub    $0xc,%esp
80100efa:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100efc:	eb 01                	jmp    80100eff <skipelem+0xe>
    path++;
80100efe:	40                   	inc    %eax
  while(*path == '/')
80100eff:	8a 10                	mov    (%eax),%dl
80100f01:	80 fa 2f             	cmp    $0x2f,%dl
80100f04:	74 f8                	je     80100efe <skipelem+0xd>
  if(*path == 0)
80100f06:	84 d2                	test   %dl,%dl
80100f08:	74 4e                	je     80100f58 <skipelem+0x67>
80100f0a:	89 c3                	mov    %eax,%ebx
80100f0c:	eb 01                	jmp    80100f0f <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f0e:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f0f:	8a 13                	mov    (%ebx),%dl
80100f11:	80 fa 2f             	cmp    $0x2f,%dl
80100f14:	74 04                	je     80100f1a <skipelem+0x29>
80100f16:	84 d2                	test   %dl,%dl
80100f18:	75 f4                	jne    80100f0e <skipelem+0x1d>
  len = path - s;
80100f1a:	89 df                	mov    %ebx,%edi
80100f1c:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f1e:	83 ff 0d             	cmp    $0xd,%edi
80100f21:	7e 11                	jle    80100f34 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f23:	83 ec 04             	sub    $0x4,%esp
80100f26:	6a 0e                	push   $0xe
80100f28:	50                   	push   %eax
80100f29:	56                   	push   %esi
80100f2a:	e8 41 2f 00 00       	call   80103e70 <memmove>
80100f2f:	83 c4 10             	add    $0x10,%esp
80100f32:	eb 15                	jmp    80100f49 <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	57                   	push   %edi
80100f38:	50                   	push   %eax
80100f39:	56                   	push   %esi
80100f3a:	e8 31 2f 00 00       	call   80103e70 <memmove>
    name[len] = 0;
80100f3f:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f43:	83 c4 10             	add    $0x10,%esp
80100f46:	eb 01                	jmp    80100f49 <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100f48:	43                   	inc    %ebx
  while(*path == '/')
80100f49:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f4c:	74 fa                	je     80100f48 <skipelem+0x57>
  return path;
}
80100f4e:	89 d8                	mov    %ebx,%eax
80100f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f53:	5b                   	pop    %ebx
80100f54:	5e                   	pop    %esi
80100f55:	5f                   	pop    %edi
80100f56:	5d                   	pop    %ebp
80100f57:	c3                   	ret    
    return 0;
80100f58:	bb 00 00 00 00       	mov    $0x0,%ebx
80100f5d:	eb ef                	jmp    80100f4e <skipelem+0x5d>

80100f5f <bzero>:
{
80100f5f:	55                   	push   %ebp
80100f60:	89 e5                	mov    %esp,%ebp
80100f62:	53                   	push   %ebx
80100f63:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100f66:	52                   	push   %edx
80100f67:	50                   	push   %eax
80100f68:	e8 fd f1 ff ff       	call   8010016a <bread>
80100f6d:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100f6f:	8d 40 5c             	lea    0x5c(%eax),%eax
80100f72:	83 c4 0c             	add    $0xc,%esp
80100f75:	68 00 02 00 00       	push   $0x200
80100f7a:	6a 00                	push   $0x0
80100f7c:	50                   	push   %eax
80100f7d:	e8 78 2e 00 00       	call   80103dfa <memset>
  log_write(bp);
80100f82:	89 1c 24             	mov    %ebx,(%esp)
80100f85:	e8 7b 18 00 00       	call   80102805 <log_write>
  brelse(bp);
80100f8a:	89 1c 24             	mov    %ebx,(%esp)
80100f8d:	e8 41 f2 ff ff       	call   801001d3 <brelse>
}
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    

80100f9a <balloc>:
{
80100f9a:	55                   	push   %ebp
80100f9b:	89 e5                	mov    %esp,%ebp
80100f9d:	57                   	push   %edi
80100f9e:	56                   	push   %esi
80100f9f:	53                   	push   %ebx
80100fa0:	83 ec 1c             	sub    $0x1c,%esp
80100fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80100fa6:	be 00 00 00 00       	mov    $0x0,%esi
80100fab:	eb 5b                	jmp    80101008 <balloc+0x6e>
    bp = bread(dev, BBLOCK(b, sb));
80100fad:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80100fb3:	eb 61                	jmp    80101016 <balloc+0x7c>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80100fb5:	c1 fa 03             	sar    $0x3,%edx
80100fb8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100fbb:	8a 4c 17 5c          	mov    0x5c(%edi,%edx,1),%cl
80100fbf:	0f b6 f9             	movzbl %cl,%edi
80100fc2:	85 7d e4             	test   %edi,-0x1c(%ebp)
80100fc5:	74 7e                	je     80101045 <balloc+0xab>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80100fc7:	40                   	inc    %eax
80100fc8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80100fcd:	7f 25                	jg     80100ff4 <balloc+0x5a>
80100fcf:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80100fd2:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
80100fd8:	73 1a                	jae    80100ff4 <balloc+0x5a>
      m = 1 << (bi % 8);
80100fda:	89 c1                	mov    %eax,%ecx
80100fdc:	83 e1 07             	and    $0x7,%ecx
80100fdf:	ba 01 00 00 00       	mov    $0x1,%edx
80100fe4:	d3 e2                	shl    %cl,%edx
80100fe6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80100fe9:	89 c2                	mov    %eax,%edx
80100feb:	85 c0                	test   %eax,%eax
80100fed:	79 c6                	jns    80100fb5 <balloc+0x1b>
80100fef:	8d 50 07             	lea    0x7(%eax),%edx
80100ff2:	eb c1                	jmp    80100fb5 <balloc+0x1b>
    brelse(bp);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 75 e0             	push   -0x20(%ebp)
80100ffa:	e8 d4 f1 ff ff       	call   801001d3 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80100fff:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101005:	83 c4 10             	add    $0x10,%esp
80101008:	39 35 b4 15 11 80    	cmp    %esi,0x801115b4
8010100e:	76 28                	jbe    80101038 <balloc+0x9e>
    bp = bread(dev, BBLOCK(b, sb));
80101010:	89 f0                	mov    %esi,%eax
80101012:	85 f6                	test   %esi,%esi
80101014:	78 97                	js     80100fad <balloc+0x13>
80101016:	c1 f8 0c             	sar    $0xc,%eax
80101019:	83 ec 08             	sub    $0x8,%esp
8010101c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101022:	50                   	push   %eax
80101023:	ff 75 dc             	push   -0x24(%ebp)
80101026:	e8 3f f1 ff ff       	call   8010016a <bread>
8010102b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	b8 00 00 00 00       	mov    $0x0,%eax
80101036:	eb 90                	jmp    80100fc8 <balloc+0x2e>
  panic("balloc: out of blocks");
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 3f 6c 10 80       	push   $0x80106c3f
80101040:	e8 fc f2 ff ff       	call   80100341 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101045:	0b 4d e4             	or     -0x1c(%ebp),%ecx
80101048:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010104b:	88 4c 16 5c          	mov    %cl,0x5c(%esi,%edx,1)
        log_write(bp);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	56                   	push   %esi
80101053:	e8 ad 17 00 00       	call   80102805 <log_write>
        brelse(bp);
80101058:	89 34 24             	mov    %esi,(%esp)
8010105b:	e8 73 f1 ff ff       	call   801001d3 <brelse>
        bzero(dev, b + bi);
80101060:	89 da                	mov    %ebx,%edx
80101062:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101065:	e8 f5 fe ff ff       	call   80100f5f <bzero>
}
8010106a:	89 d8                	mov    %ebx,%eax
8010106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    

80101074 <bmap>:
{
80101074:	55                   	push   %ebp
80101075:	89 e5                	mov    %esp,%ebp
80101077:	57                   	push   %edi
80101078:	56                   	push   %esi
80101079:	53                   	push   %ebx
8010107a:	83 ec 1c             	sub    $0x1c,%esp
8010107d:	89 c3                	mov    %eax,%ebx
8010107f:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
80101081:	83 fa 0b             	cmp    $0xb,%edx
80101084:	76 45                	jbe    801010cb <bmap+0x57>
  bn -= NDIRECT;
80101086:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101089:	83 fe 7f             	cmp    $0x7f,%esi
8010108c:	77 7f                	ja     8010110d <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010108e:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101094:	85 c0                	test   %eax,%eax
80101096:	74 4a                	je     801010e2 <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101098:	83 ec 08             	sub    $0x8,%esp
8010109b:	50                   	push   %eax
8010109c:	ff 33                	push   (%ebx)
8010109e:	e8 c7 f0 ff ff       	call   8010016a <bread>
801010a3:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801010a5:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010ac:	8b 30                	mov    (%eax),%esi
801010ae:	83 c4 10             	add    $0x10,%esp
801010b1:	85 f6                	test   %esi,%esi
801010b3:	74 3c                	je     801010f1 <bmap+0x7d>
    brelse(bp);
801010b5:	83 ec 0c             	sub    $0xc,%esp
801010b8:	57                   	push   %edi
801010b9:	e8 15 f1 ff ff       	call   801001d3 <brelse>
    return addr;
801010be:	83 c4 10             	add    $0x10,%esp
}
801010c1:	89 f0                	mov    %esi,%eax
801010c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801010cb:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801010cf:	85 f6                	test   %esi,%esi
801010d1:	75 ee                	jne    801010c1 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801010d3:	8b 00                	mov    (%eax),%eax
801010d5:	e8 c0 fe ff ff       	call   80100f9a <balloc>
801010da:	89 c6                	mov    %eax,%esi
801010dc:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
801010e0:	eb df                	jmp    801010c1 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	e8 b1 fe ff ff       	call   80100f9a <balloc>
801010e9:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801010ef:	eb a7                	jmp    80101098 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801010f1:	8b 03                	mov    (%ebx),%eax
801010f3:	e8 a2 fe ff ff       	call   80100f9a <balloc>
801010f8:	89 c6                	mov    %eax,%esi
801010fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010fd:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	57                   	push   %edi
80101103:	e8 fd 16 00 00       	call   80102805 <log_write>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	eb a8                	jmp    801010b5 <bmap+0x41>
  panic("bmap: out of range");
8010110d:	83 ec 0c             	sub    $0xc,%esp
80101110:	68 55 6c 10 80       	push   $0x80106c55
80101115:	e8 27 f2 ff ff       	call   80100341 <panic>

8010111a <iget>:
{
8010111a:	55                   	push   %ebp
8010111b:	89 e5                	mov    %esp,%ebp
8010111d:	57                   	push   %edi
8010111e:	56                   	push   %esi
8010111f:	53                   	push   %ebx
80101120:	83 ec 28             	sub    $0x28,%esp
80101123:	89 c7                	mov    %eax,%edi
80101125:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101128:	68 60 f9 10 80       	push   $0x8010f960
8010112d:	e8 1c 2c 00 00       	call   80103d4e <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101132:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101135:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010113a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
8010113f:	eb 0a                	jmp    8010114b <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101141:	85 f6                	test   %esi,%esi
80101143:	74 39                	je     8010117e <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101145:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010114b:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101151:	73 33                	jae    80101186 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101153:	8b 43 08             	mov    0x8(%ebx),%eax
80101156:	85 c0                	test   %eax,%eax
80101158:	7e e7                	jle    80101141 <iget+0x27>
8010115a:	39 3b                	cmp    %edi,(%ebx)
8010115c:	75 e3                	jne    80101141 <iget+0x27>
8010115e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101161:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101164:	75 db                	jne    80101141 <iget+0x27>
      ip->ref++;
80101166:	40                   	inc    %eax
80101167:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	68 60 f9 10 80       	push   $0x8010f960
80101172:	e8 3c 2c 00 00       	call   80103db3 <release>
      return ip;
80101177:	83 c4 10             	add    $0x10,%esp
8010117a:	89 de                	mov    %ebx,%esi
8010117c:	eb 32                	jmp    801011b0 <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010117e:	85 c0                	test   %eax,%eax
80101180:	75 c3                	jne    80101145 <iget+0x2b>
      empty = ip;
80101182:	89 de                	mov    %ebx,%esi
80101184:	eb bf                	jmp    80101145 <iget+0x2b>
  if(empty == 0)
80101186:	85 f6                	test   %esi,%esi
80101188:	74 30                	je     801011ba <iget+0xa0>
  ip->dev = dev;
8010118a:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010118c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010118f:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101192:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101199:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 60 f9 10 80       	push   $0x8010f960
801011a8:	e8 06 2c 00 00       	call   80103db3 <release>
  return ip;
801011ad:	83 c4 10             	add    $0x10,%esp
}
801011b0:	89 f0                	mov    %esi,%eax
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
801011b9:	c3                   	ret    
    panic("iget: no inodes");
801011ba:	83 ec 0c             	sub    $0xc,%esp
801011bd:	68 68 6c 10 80       	push   $0x80106c68
801011c2:	e8 7a f1 ff ff       	call   80100341 <panic>

801011c7 <readsb>:
{
801011c7:	55                   	push   %ebp
801011c8:	89 e5                	mov    %esp,%ebp
801011ca:	53                   	push   %ebx
801011cb:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801011ce:	6a 01                	push   $0x1
801011d0:	ff 75 08             	push   0x8(%ebp)
801011d3:	e8 92 ef ff ff       	call   8010016a <bread>
801011d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801011da:	8d 40 5c             	lea    0x5c(%eax),%eax
801011dd:	83 c4 0c             	add    $0xc,%esp
801011e0:	6a 1c                	push   $0x1c
801011e2:	50                   	push   %eax
801011e3:	ff 75 0c             	push   0xc(%ebp)
801011e6:	e8 85 2c 00 00       	call   80103e70 <memmove>
  brelse(bp);
801011eb:	89 1c 24             	mov    %ebx,(%esp)
801011ee:	e8 e0 ef ff ff       	call   801001d3 <brelse>
}
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011f9:	c9                   	leave  
801011fa:	c3                   	ret    

801011fb <bfree>:
{
801011fb:	55                   	push   %ebp
801011fc:	89 e5                	mov    %esp,%ebp
801011fe:	56                   	push   %esi
801011ff:	53                   	push   %ebx
80101200:	89 c3                	mov    %eax,%ebx
80101202:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	68 b4 15 11 80       	push   $0x801115b4
8010120c:	50                   	push   %eax
8010120d:	e8 b5 ff ff ff       	call   801011c7 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101212:	89 f0                	mov    %esi,%eax
80101214:	c1 e8 0c             	shr    $0xc,%eax
80101217:	83 c4 08             	add    $0x8,%esp
8010121a:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101220:	50                   	push   %eax
80101221:	53                   	push   %ebx
80101222:	e8 43 ef ff ff       	call   8010016a <bread>
80101227:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101229:	89 f2                	mov    %esi,%edx
8010122b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
80101231:	89 f1                	mov    %esi,%ecx
80101233:	83 e1 07             	and    $0x7,%ecx
80101236:	b8 01 00 00 00       	mov    $0x1,%eax
8010123b:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
8010123d:	83 c4 10             	add    $0x10,%esp
80101240:	c1 fa 03             	sar    $0x3,%edx
80101243:	8a 4c 13 5c          	mov    0x5c(%ebx,%edx,1),%cl
80101247:	0f b6 f1             	movzbl %cl,%esi
8010124a:	85 c6                	test   %eax,%esi
8010124c:	74 23                	je     80101271 <bfree+0x76>
  bp->data[bi/8] &= ~m;
8010124e:	f7 d0                	not    %eax
80101250:	21 c8                	and    %ecx,%eax
80101252:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
80101256:	83 ec 0c             	sub    $0xc,%esp
80101259:	53                   	push   %ebx
8010125a:	e8 a6 15 00 00       	call   80102805 <log_write>
  brelse(bp);
8010125f:	89 1c 24             	mov    %ebx,(%esp)
80101262:	e8 6c ef ff ff       	call   801001d3 <brelse>
}
80101267:	83 c4 10             	add    $0x10,%esp
8010126a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010126d:	5b                   	pop    %ebx
8010126e:	5e                   	pop    %esi
8010126f:	5d                   	pop    %ebp
80101270:	c3                   	ret    
    panic("freeing free block");
80101271:	83 ec 0c             	sub    $0xc,%esp
80101274:	68 78 6c 10 80       	push   $0x80106c78
80101279:	e8 c3 f0 ff ff       	call   80100341 <panic>

8010127e <iinit>:
{
8010127e:	55                   	push   %ebp
8010127f:	89 e5                	mov    %esp,%ebp
80101281:	53                   	push   %ebx
80101282:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101285:	68 8b 6c 10 80       	push   $0x80106c8b
8010128a:	68 60 f9 10 80       	push   $0x8010f960
8010128f:	e8 83 29 00 00       	call   80103c17 <initlock>
  for(i = 0; i < NINODE; i++) {
80101294:	83 c4 10             	add    $0x10,%esp
80101297:	bb 00 00 00 00       	mov    $0x0,%ebx
8010129c:	eb 1f                	jmp    801012bd <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010129e:	83 ec 08             	sub    $0x8,%esp
801012a1:	68 92 6c 10 80       	push   $0x80106c92
801012a6:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012a9:	89 d0                	mov    %edx,%eax
801012ab:	c1 e0 04             	shl    $0x4,%eax
801012ae:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012b3:	50                   	push   %eax
801012b4:	e8 53 28 00 00       	call   80103b0c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801012b9:	43                   	inc    %ebx
801012ba:	83 c4 10             	add    $0x10,%esp
801012bd:	83 fb 31             	cmp    $0x31,%ebx
801012c0:	7e dc                	jle    8010129e <iinit+0x20>
  readsb(dev, &sb);
801012c2:	83 ec 08             	sub    $0x8,%esp
801012c5:	68 b4 15 11 80       	push   $0x801115b4
801012ca:	ff 75 08             	push   0x8(%ebp)
801012cd:	e8 f5 fe ff ff       	call   801011c7 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801012d2:	ff 35 cc 15 11 80    	push   0x801115cc
801012d8:	ff 35 c8 15 11 80    	push   0x801115c8
801012de:	ff 35 c4 15 11 80    	push   0x801115c4
801012e4:	ff 35 c0 15 11 80    	push   0x801115c0
801012ea:	ff 35 bc 15 11 80    	push   0x801115bc
801012f0:	ff 35 b8 15 11 80    	push   0x801115b8
801012f6:	ff 35 b4 15 11 80    	push   0x801115b4
801012fc:	68 f8 6c 10 80       	push   $0x80106cf8
80101301:	e8 d4 f2 ff ff       	call   801005da <cprintf>
}
80101306:	83 c4 30             	add    $0x30,%esp
80101309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010130c:	c9                   	leave  
8010130d:	c3                   	ret    

8010130e <ialloc>:
{
8010130e:	55                   	push   %ebp
8010130f:	89 e5                	mov    %esp,%ebp
80101311:	57                   	push   %edi
80101312:	56                   	push   %esi
80101313:	53                   	push   %ebx
80101314:	83 ec 1c             	sub    $0x1c,%esp
80101317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010131d:	bb 01 00 00 00       	mov    $0x1,%ebx
80101322:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101325:	39 1d bc 15 11 80    	cmp    %ebx,0x801115bc
8010132b:	76 3d                	jbe    8010136a <ialloc+0x5c>
    bp = bread(dev, IBLOCK(inum, sb));
8010132d:	89 d8                	mov    %ebx,%eax
8010132f:	c1 e8 03             	shr    $0x3,%eax
80101332:	83 ec 08             	sub    $0x8,%esp
80101335:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010133b:	50                   	push   %eax
8010133c:	ff 75 08             	push   0x8(%ebp)
8010133f:	e8 26 ee ff ff       	call   8010016a <bread>
80101344:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101346:	89 d8                	mov    %ebx,%eax
80101348:	83 e0 07             	and    $0x7,%eax
8010134b:	c1 e0 06             	shl    $0x6,%eax
8010134e:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101359:	74 1c                	je     80101377 <ialloc+0x69>
    brelse(bp);
8010135b:	83 ec 0c             	sub    $0xc,%esp
8010135e:	56                   	push   %esi
8010135f:	e8 6f ee ff ff       	call   801001d3 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101364:	43                   	inc    %ebx
80101365:	83 c4 10             	add    $0x10,%esp
80101368:	eb b8                	jmp    80101322 <ialloc+0x14>
  panic("ialloc: no inodes");
8010136a:	83 ec 0c             	sub    $0xc,%esp
8010136d:	68 98 6c 10 80       	push   $0x80106c98
80101372:	e8 ca ef ff ff       	call   80100341 <panic>
      memset(dip, 0, sizeof(*dip));
80101377:	83 ec 04             	sub    $0x4,%esp
8010137a:	6a 40                	push   $0x40
8010137c:	6a 00                	push   $0x0
8010137e:	57                   	push   %edi
8010137f:	e8 76 2a 00 00       	call   80103dfa <memset>
      dip->type = type;
80101384:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101387:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010138a:	89 34 24             	mov    %esi,(%esp)
8010138d:	e8 73 14 00 00       	call   80102805 <log_write>
      brelse(bp);
80101392:	89 34 24             	mov    %esi,(%esp)
80101395:	e8 39 ee ff ff       	call   801001d3 <brelse>
      return iget(dev, inum);
8010139a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010139d:	8b 45 08             	mov    0x8(%ebp),%eax
801013a0:	e8 75 fd ff ff       	call   8010111a <iget>
}
801013a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a8:	5b                   	pop    %ebx
801013a9:	5e                   	pop    %esi
801013aa:	5f                   	pop    %edi
801013ab:	5d                   	pop    %ebp
801013ac:	c3                   	ret    

801013ad <iupdate>:
{
801013ad:	55                   	push   %ebp
801013ae:	89 e5                	mov    %esp,%ebp
801013b0:	56                   	push   %esi
801013b1:	53                   	push   %ebx
801013b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801013b5:	8b 43 04             	mov    0x4(%ebx),%eax
801013b8:	c1 e8 03             	shr    $0x3,%eax
801013bb:	83 ec 08             	sub    $0x8,%esp
801013be:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801013c4:	50                   	push   %eax
801013c5:	ff 33                	push   (%ebx)
801013c7:	e8 9e ed ff ff       	call   8010016a <bread>
801013cc:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801013ce:	8b 43 04             	mov    0x4(%ebx),%eax
801013d1:	83 e0 07             	and    $0x7,%eax
801013d4:	c1 e0 06             	shl    $0x6,%eax
801013d7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801013db:	8b 53 50             	mov    0x50(%ebx),%edx
801013de:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801013e1:	66 8b 53 52          	mov    0x52(%ebx),%dx
801013e5:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801013e9:	8b 53 54             	mov    0x54(%ebx),%edx
801013ec:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801013f0:	66 8b 53 56          	mov    0x56(%ebx),%dx
801013f4:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801013f8:	8b 53 58             	mov    0x58(%ebx),%edx
801013fb:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801013fe:	83 c3 5c             	add    $0x5c,%ebx
80101401:	83 c0 0c             	add    $0xc,%eax
80101404:	83 c4 0c             	add    $0xc,%esp
80101407:	6a 34                	push   $0x34
80101409:	53                   	push   %ebx
8010140a:	50                   	push   %eax
8010140b:	e8 60 2a 00 00       	call   80103e70 <memmove>
  log_write(bp);
80101410:	89 34 24             	mov    %esi,(%esp)
80101413:	e8 ed 13 00 00       	call   80102805 <log_write>
  brelse(bp);
80101418:	89 34 24             	mov    %esi,(%esp)
8010141b:	e8 b3 ed ff ff       	call   801001d3 <brelse>
}
80101420:	83 c4 10             	add    $0x10,%esp
80101423:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101426:	5b                   	pop    %ebx
80101427:	5e                   	pop    %esi
80101428:	5d                   	pop    %ebp
80101429:	c3                   	ret    

8010142a <itrunc>:
{
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	57                   	push   %edi
8010142e:	56                   	push   %esi
8010142f:	53                   	push   %ebx
80101430:	83 ec 1c             	sub    $0x1c,%esp
80101433:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101435:	bb 00 00 00 00       	mov    $0x0,%ebx
8010143a:	eb 01                	jmp    8010143d <itrunc+0x13>
8010143c:	43                   	inc    %ebx
8010143d:	83 fb 0b             	cmp    $0xb,%ebx
80101440:	7f 19                	jg     8010145b <itrunc+0x31>
    if(ip->addrs[i]){
80101442:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101446:	85 d2                	test   %edx,%edx
80101448:	74 f2                	je     8010143c <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
8010144a:	8b 06                	mov    (%esi),%eax
8010144c:	e8 aa fd ff ff       	call   801011fb <bfree>
      ip->addrs[i] = 0;
80101451:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101458:	00 
80101459:	eb e1                	jmp    8010143c <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
8010145b:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101461:	85 c0                	test   %eax,%eax
80101463:	75 1b                	jne    80101480 <itrunc+0x56>
  ip->size = 0;
80101465:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	56                   	push   %esi
80101470:	e8 38 ff ff ff       	call   801013ad <iupdate>
}
80101475:	83 c4 10             	add    $0x10,%esp
80101478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147b:	5b                   	pop    %ebx
8010147c:	5e                   	pop    %esi
8010147d:	5f                   	pop    %edi
8010147e:	5d                   	pop    %ebp
8010147f:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	50                   	push   %eax
80101484:	ff 36                	push   (%esi)
80101486:	e8 df ec ff ff       	call   8010016a <bread>
8010148b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010148e:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
80101491:	83 c4 10             	add    $0x10,%esp
80101494:	bb 00 00 00 00       	mov    $0x0,%ebx
80101499:	eb 01                	jmp    8010149c <itrunc+0x72>
8010149b:	43                   	inc    %ebx
8010149c:	83 fb 7f             	cmp    $0x7f,%ebx
8010149f:	77 10                	ja     801014b1 <itrunc+0x87>
      if(a[j])
801014a1:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
801014a4:	85 d2                	test   %edx,%edx
801014a6:	74 f3                	je     8010149b <itrunc+0x71>
        bfree(ip->dev, a[j]);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 4c fd ff ff       	call   801011fb <bfree>
801014af:	eb ea                	jmp    8010149b <itrunc+0x71>
    brelse(bp);
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 e4             	push   -0x1c(%ebp)
801014b7:	e8 17 ed ff ff       	call   801001d3 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801014bc:	8b 06                	mov    (%esi),%eax
801014be:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801014c4:	e8 32 fd ff ff       	call   801011fb <bfree>
    ip->addrs[NDIRECT] = 0;
801014c9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801014d0:	00 00 00 
801014d3:	83 c4 10             	add    $0x10,%esp
801014d6:	eb 8d                	jmp    80101465 <itrunc+0x3b>

801014d8 <idup>:
{
801014d8:	55                   	push   %ebp
801014d9:	89 e5                	mov    %esp,%ebp
801014db:	53                   	push   %ebx
801014dc:	83 ec 10             	sub    $0x10,%esp
801014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801014e2:	68 60 f9 10 80       	push   $0x8010f960
801014e7:	e8 62 28 00 00       	call   80103d4e <acquire>
  ip->ref++;
801014ec:	8b 43 08             	mov    0x8(%ebx),%eax
801014ef:	40                   	inc    %eax
801014f0:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801014f3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801014fa:	e8 b4 28 00 00       	call   80103db3 <release>
}
801014ff:	89 d8                	mov    %ebx,%eax
80101501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101504:	c9                   	leave  
80101505:	c3                   	ret    

80101506 <ilock>:
{
80101506:	55                   	push   %ebp
80101507:	89 e5                	mov    %esp,%ebp
80101509:	56                   	push   %esi
8010150a:	53                   	push   %ebx
8010150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010150e:	85 db                	test   %ebx,%ebx
80101510:	74 22                	je     80101534 <ilock+0x2e>
80101512:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101516:	7e 1c                	jle    80101534 <ilock+0x2e>
  acquiresleep(&ip->lock);
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010151e:	50                   	push   %eax
8010151f:	e8 1b 26 00 00       	call   80103b3f <acquiresleep>
  if(ip->valid == 0){
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010152b:	74 14                	je     80101541 <ilock+0x3b>
}
8010152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101530:	5b                   	pop    %ebx
80101531:	5e                   	pop    %esi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
    panic("ilock");
80101534:	83 ec 0c             	sub    $0xc,%esp
80101537:	68 aa 6c 10 80       	push   $0x80106caa
8010153c:	e8 00 ee ff ff       	call   80100341 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101541:	8b 43 04             	mov    0x4(%ebx),%eax
80101544:	c1 e8 03             	shr    $0x3,%eax
80101547:	83 ec 08             	sub    $0x8,%esp
8010154a:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101550:	50                   	push   %eax
80101551:	ff 33                	push   (%ebx)
80101553:	e8 12 ec ff ff       	call   8010016a <bread>
80101558:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010155a:	8b 43 04             	mov    0x4(%ebx),%eax
8010155d:	83 e0 07             	and    $0x7,%eax
80101560:	c1 e0 06             	shl    $0x6,%eax
80101563:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101567:	8b 10                	mov    (%eax),%edx
80101569:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010156d:	66 8b 50 02          	mov    0x2(%eax),%dx
80101571:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101575:	8b 50 04             	mov    0x4(%eax),%edx
80101578:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010157c:	66 8b 50 06          	mov    0x6(%eax),%dx
80101580:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101584:	8b 50 08             	mov    0x8(%eax),%edx
80101587:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010158a:	83 c0 0c             	add    $0xc,%eax
8010158d:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101590:	83 c4 0c             	add    $0xc,%esp
80101593:	6a 34                	push   $0x34
80101595:	50                   	push   %eax
80101596:	52                   	push   %edx
80101597:	e8 d4 28 00 00       	call   80103e70 <memmove>
    brelse(bp);
8010159c:	89 34 24             	mov    %esi,(%esp)
8010159f:	e8 2f ec ff ff       	call   801001d3 <brelse>
    ip->valid = 1;
801015a4:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015ab:	83 c4 10             	add    $0x10,%esp
801015ae:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015b3:	0f 85 74 ff ff ff    	jne    8010152d <ilock+0x27>
      panic("ilock: no type");
801015b9:	83 ec 0c             	sub    $0xc,%esp
801015bc:	68 b0 6c 10 80       	push   $0x80106cb0
801015c1:	e8 7b ed ff ff       	call   80100341 <panic>

801015c6 <iunlock>:
{
801015c6:	55                   	push   %ebp
801015c7:	89 e5                	mov    %esp,%ebp
801015c9:	56                   	push   %esi
801015ca:	53                   	push   %ebx
801015cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015ce:	85 db                	test   %ebx,%ebx
801015d0:	74 2c                	je     801015fe <iunlock+0x38>
801015d2:	8d 73 0c             	lea    0xc(%ebx),%esi
801015d5:	83 ec 0c             	sub    $0xc,%esp
801015d8:	56                   	push   %esi
801015d9:	e8 eb 25 00 00       	call   80103bc9 <holdingsleep>
801015de:	83 c4 10             	add    $0x10,%esp
801015e1:	85 c0                	test   %eax,%eax
801015e3:	74 19                	je     801015fe <iunlock+0x38>
801015e5:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015e9:	7e 13                	jle    801015fe <iunlock+0x38>
  releasesleep(&ip->lock);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	56                   	push   %esi
801015ef:	e8 9a 25 00 00       	call   80103b8e <releasesleep>
}
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5d                   	pop    %ebp
801015fd:	c3                   	ret    
    panic("iunlock");
801015fe:	83 ec 0c             	sub    $0xc,%esp
80101601:	68 bf 6c 10 80       	push   $0x80106cbf
80101606:	e8 36 ed ff ff       	call   80100341 <panic>

8010160b <iput>:
{
8010160b:	55                   	push   %ebp
8010160c:	89 e5                	mov    %esp,%ebp
8010160e:	57                   	push   %edi
8010160f:	56                   	push   %esi
80101610:	53                   	push   %ebx
80101611:	83 ec 18             	sub    $0x18,%esp
80101614:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101617:	8d 73 0c             	lea    0xc(%ebx),%esi
8010161a:	56                   	push   %esi
8010161b:	e8 1f 25 00 00       	call   80103b3f <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101620:	83 c4 10             	add    $0x10,%esp
80101623:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101627:	74 07                	je     80101630 <iput+0x25>
80101629:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010162e:	74 33                	je     80101663 <iput+0x58>
  releasesleep(&ip->lock);
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	56                   	push   %esi
80101634:	e8 55 25 00 00       	call   80103b8e <releasesleep>
  acquire(&icache.lock);
80101639:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101640:	e8 09 27 00 00       	call   80103d4e <acquire>
  ip->ref--;
80101645:	8b 43 08             	mov    0x8(%ebx),%eax
80101648:	48                   	dec    %eax
80101649:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010164c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101653:	e8 5b 27 00 00       	call   80103db3 <release>
}
80101658:	83 c4 10             	add    $0x10,%esp
8010165b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165e:	5b                   	pop    %ebx
8010165f:	5e                   	pop    %esi
80101660:	5f                   	pop    %edi
80101661:	5d                   	pop    %ebp
80101662:	c3                   	ret    
    acquire(&icache.lock);
80101663:	83 ec 0c             	sub    $0xc,%esp
80101666:	68 60 f9 10 80       	push   $0x8010f960
8010166b:	e8 de 26 00 00       	call   80103d4e <acquire>
    int r = ip->ref;
80101670:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101673:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010167a:	e8 34 27 00 00       	call   80103db3 <release>
    if(r == 1){
8010167f:	83 c4 10             	add    $0x10,%esp
80101682:	83 ff 01             	cmp    $0x1,%edi
80101685:	75 a9                	jne    80101630 <iput+0x25>
      itrunc(ip);
80101687:	89 d8                	mov    %ebx,%eax
80101689:	e8 9c fd ff ff       	call   8010142a <itrunc>
      ip->type = 0;
8010168e:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101694:	83 ec 0c             	sub    $0xc,%esp
80101697:	53                   	push   %ebx
80101698:	e8 10 fd ff ff       	call   801013ad <iupdate>
      ip->valid = 0;
8010169d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	eb 87                	jmp    80101630 <iput+0x25>

801016a9 <iunlockput>:
{
801016a9:	55                   	push   %ebp
801016aa:	89 e5                	mov    %esp,%ebp
801016ac:	53                   	push   %ebx
801016ad:	83 ec 10             	sub    $0x10,%esp
801016b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801016b3:	53                   	push   %ebx
801016b4:	e8 0d ff ff ff       	call   801015c6 <iunlock>
  iput(ip);
801016b9:	89 1c 24             	mov    %ebx,(%esp)
801016bc:	e8 4a ff ff ff       	call   8010160b <iput>
}
801016c1:	83 c4 10             	add    $0x10,%esp
801016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c7:	c9                   	leave  
801016c8:	c3                   	ret    

801016c9 <stati>:
{
801016c9:	55                   	push   %ebp
801016ca:	89 e5                	mov    %esp,%ebp
801016cc:	8b 55 08             	mov    0x8(%ebp),%edx
801016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801016d2:	8b 0a                	mov    (%edx),%ecx
801016d4:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801016d7:	8b 4a 04             	mov    0x4(%edx),%ecx
801016da:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801016dd:	8b 4a 50             	mov    0x50(%edx),%ecx
801016e0:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801016e3:	66 8b 4a 56          	mov    0x56(%edx),%cx
801016e7:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801016eb:	8b 52 58             	mov    0x58(%edx),%edx
801016ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801016f1:	5d                   	pop    %ebp
801016f2:	c3                   	ret    

801016f3 <readi>:
{
801016f3:	55                   	push   %ebp
801016f4:	89 e5                	mov    %esp,%ebp
801016f6:	57                   	push   %edi
801016f7:	56                   	push   %esi
801016f8:	53                   	push   %ebx
801016f9:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101704:	74 2c                	je     80101732 <readi+0x3f>
  if(off > ip->size || off + n < off)
80101706:	8b 45 08             	mov    0x8(%ebp),%eax
80101709:	8b 40 58             	mov    0x58(%eax),%eax
8010170c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010170f:	0f 82 d0 00 00 00    	jb     801017e5 <readi+0xf2>
80101715:	8b 55 10             	mov    0x10(%ebp),%edx
80101718:	03 55 14             	add    0x14(%ebp),%edx
8010171b:	0f 82 cb 00 00 00    	jb     801017ec <readi+0xf9>
  if(off + n > ip->size)
80101721:	39 d0                	cmp    %edx,%eax
80101723:	73 06                	jae    8010172b <readi+0x38>
    n = ip->size - off;
80101725:	2b 45 10             	sub    0x10(%ebp),%eax
80101728:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010172b:	bf 00 00 00 00       	mov    $0x0,%edi
80101730:	eb 55                	jmp    80101787 <readi+0x94>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101732:	66 8b 40 52          	mov    0x52(%eax),%ax
80101736:	66 83 f8 09          	cmp    $0x9,%ax
8010173a:	0f 87 97 00 00 00    	ja     801017d7 <readi+0xe4>
80101740:	98                   	cwtl   
80101741:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101748:	85 c0                	test   %eax,%eax
8010174a:	0f 84 8e 00 00 00    	je     801017de <readi+0xeb>
    return devsw[ip->major].read(ip, dst, n);
80101750:	83 ec 04             	sub    $0x4,%esp
80101753:	ff 75 14             	push   0x14(%ebp)
80101756:	ff 75 0c             	push   0xc(%ebp)
80101759:	ff 75 08             	push   0x8(%ebp)
8010175c:	ff d0                	call   *%eax
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	eb 6c                	jmp    801017cf <readi+0xdc>
    memmove(dst, bp->data + off%BSIZE, m);
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	53                   	push   %ebx
80101767:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
8010176b:	50                   	push   %eax
8010176c:	ff 75 0c             	push   0xc(%ebp)
8010176f:	e8 fc 26 00 00       	call   80103e70 <memmove>
    brelse(bp);
80101774:	89 34 24             	mov    %esi,(%esp)
80101777:	e8 57 ea ff ff       	call   801001d3 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010177c:	01 df                	add    %ebx,%edi
8010177e:	01 5d 10             	add    %ebx,0x10(%ebp)
80101781:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101784:	83 c4 10             	add    $0x10,%esp
80101787:	39 7d 14             	cmp    %edi,0x14(%ebp)
8010178a:	76 40                	jbe    801017cc <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010178c:	8b 55 10             	mov    0x10(%ebp),%edx
8010178f:	c1 ea 09             	shr    $0x9,%edx
80101792:	8b 45 08             	mov    0x8(%ebp),%eax
80101795:	e8 da f8 ff ff       	call   80101074 <bmap>
8010179a:	83 ec 08             	sub    $0x8,%esp
8010179d:	50                   	push   %eax
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	ff 30                	push   (%eax)
801017a3:	e8 c2 e9 ff ff       	call   8010016a <bread>
801017a8:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801017aa:	8b 55 10             	mov    0x10(%ebp),%edx
801017ad:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801017b3:	b8 00 02 00 00       	mov    $0x200,%eax
801017b8:	29 d0                	sub    %edx,%eax
801017ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
801017bd:	29 f9                	sub    %edi,%ecx
801017bf:	89 c3                	mov    %eax,%ebx
801017c1:	83 c4 10             	add    $0x10,%esp
801017c4:	39 c8                	cmp    %ecx,%eax
801017c6:	76 9b                	jbe    80101763 <readi+0x70>
801017c8:	89 cb                	mov    %ecx,%ebx
801017ca:	eb 97                	jmp    80101763 <readi+0x70>
  return n;
801017cc:	8b 45 14             	mov    0x14(%ebp),%eax
}
801017cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d2:	5b                   	pop    %ebx
801017d3:	5e                   	pop    %esi
801017d4:	5f                   	pop    %edi
801017d5:	5d                   	pop    %ebp
801017d6:	c3                   	ret    
      return -1;
801017d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017dc:	eb f1                	jmp    801017cf <readi+0xdc>
801017de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017e3:	eb ea                	jmp    801017cf <readi+0xdc>
    return -1;
801017e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017ea:	eb e3                	jmp    801017cf <readi+0xdc>
801017ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017f1:	eb dc                	jmp    801017cf <readi+0xdc>

801017f3 <writei>:
{
801017f3:	55                   	push   %ebp
801017f4:	89 e5                	mov    %esp,%ebp
801017f6:	57                   	push   %edi
801017f7:	56                   	push   %esi
801017f8:	53                   	push   %ebx
801017f9:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801017fc:	8b 45 08             	mov    0x8(%ebp),%eax
801017ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101804:	74 2c                	je     80101832 <writei+0x3f>
  if(off > ip->size || off + n < off)
80101806:	8b 45 08             	mov    0x8(%ebp),%eax
80101809:	8b 7d 10             	mov    0x10(%ebp),%edi
8010180c:	39 78 58             	cmp    %edi,0x58(%eax)
8010180f:	0f 82 fd 00 00 00    	jb     80101912 <writei+0x11f>
80101815:	89 f8                	mov    %edi,%eax
80101817:	03 45 14             	add    0x14(%ebp),%eax
8010181a:	0f 82 f9 00 00 00    	jb     80101919 <writei+0x126>
  if(off + n > MAXFILE*BSIZE)
80101820:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101825:	0f 87 f5 00 00 00    	ja     80101920 <writei+0x12d>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010182b:	bf 00 00 00 00       	mov    $0x0,%edi
80101830:	eb 60                	jmp    80101892 <writei+0x9f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101832:	66 8b 40 52          	mov    0x52(%eax),%ax
80101836:	66 83 f8 09          	cmp    $0x9,%ax
8010183a:	0f 87 c4 00 00 00    	ja     80101904 <writei+0x111>
80101840:	98                   	cwtl   
80101841:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101848:	85 c0                	test   %eax,%eax
8010184a:	0f 84 bb 00 00 00    	je     8010190b <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101850:	83 ec 04             	sub    $0x4,%esp
80101853:	ff 75 14             	push   0x14(%ebp)
80101856:	ff 75 0c             	push   0xc(%ebp)
80101859:	ff 75 08             	push   0x8(%ebp)
8010185c:	ff d0                	call   *%eax
8010185e:	83 c4 10             	add    $0x10,%esp
80101861:	e9 85 00 00 00       	jmp    801018eb <writei+0xf8>
    memmove(bp->data + off%BSIZE, src, m);
80101866:	83 ec 04             	sub    $0x4,%esp
80101869:	56                   	push   %esi
8010186a:	ff 75 0c             	push   0xc(%ebp)
8010186d:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
80101871:	50                   	push   %eax
80101872:	e8 f9 25 00 00       	call   80103e70 <memmove>
    log_write(bp);
80101877:	89 1c 24             	mov    %ebx,(%esp)
8010187a:	e8 86 0f 00 00       	call   80102805 <log_write>
    brelse(bp);
8010187f:	89 1c 24             	mov    %ebx,(%esp)
80101882:	e8 4c e9 ff ff       	call   801001d3 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101887:	01 f7                	add    %esi,%edi
80101889:	01 75 10             	add    %esi,0x10(%ebp)
8010188c:	01 75 0c             	add    %esi,0xc(%ebp)
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101895:	73 40                	jae    801018d7 <writei+0xe4>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101897:	8b 55 10             	mov    0x10(%ebp),%edx
8010189a:	c1 ea 09             	shr    $0x9,%edx
8010189d:	8b 45 08             	mov    0x8(%ebp),%eax
801018a0:	e8 cf f7 ff ff       	call   80101074 <bmap>
801018a5:	83 ec 08             	sub    $0x8,%esp
801018a8:	50                   	push   %eax
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	ff 30                	push   (%eax)
801018ae:	e8 b7 e8 ff ff       	call   8010016a <bread>
801018b3:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
801018b5:	8b 55 10             	mov    0x10(%ebp),%edx
801018b8:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801018be:	b8 00 02 00 00       	mov    $0x200,%eax
801018c3:	29 d0                	sub    %edx,%eax
801018c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
801018c8:	29 f9                	sub    %edi,%ecx
801018ca:	89 c6                	mov    %eax,%esi
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	39 c8                	cmp    %ecx,%eax
801018d1:	76 93                	jbe    80101866 <writei+0x73>
801018d3:	89 ce                	mov    %ecx,%esi
801018d5:	eb 8f                	jmp    80101866 <writei+0x73>
  if(n > 0 && off > ip->size){
801018d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018db:	74 0b                	je     801018e8 <writei+0xf5>
801018dd:	8b 45 08             	mov    0x8(%ebp),%eax
801018e0:	8b 7d 10             	mov    0x10(%ebp),%edi
801018e3:	39 78 58             	cmp    %edi,0x58(%eax)
801018e6:	72 0b                	jb     801018f3 <writei+0x100>
  return n;
801018e8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ee:	5b                   	pop    %ebx
801018ef:	5e                   	pop    %esi
801018f0:	5f                   	pop    %edi
801018f1:	5d                   	pop    %ebp
801018f2:	c3                   	ret    
    ip->size = off;
801018f3:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	50                   	push   %eax
801018fa:	e8 ae fa ff ff       	call   801013ad <iupdate>
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	eb e4                	jmp    801018e8 <writei+0xf5>
      return -1;
80101904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101909:	eb e0                	jmp    801018eb <writei+0xf8>
8010190b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101910:	eb d9                	jmp    801018eb <writei+0xf8>
    return -1;
80101912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101917:	eb d2                	jmp    801018eb <writei+0xf8>
80101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010191e:	eb cb                	jmp    801018eb <writei+0xf8>
    return -1;
80101920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101925:	eb c4                	jmp    801018eb <writei+0xf8>

80101927 <namecmp>:
{
80101927:	55                   	push   %ebp
80101928:	89 e5                	mov    %esp,%ebp
8010192a:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010192d:	6a 0e                	push   $0xe
8010192f:	ff 75 0c             	push   0xc(%ebp)
80101932:	ff 75 08             	push   0x8(%ebp)
80101935:	e8 9c 25 00 00       	call   80103ed6 <strncmp>
}
8010193a:	c9                   	leave  
8010193b:	c3                   	ret    

8010193c <dirlookup>:
{
8010193c:	55                   	push   %ebp
8010193d:	89 e5                	mov    %esp,%ebp
8010193f:	57                   	push   %edi
80101940:	56                   	push   %esi
80101941:	53                   	push   %ebx
80101942:	83 ec 1c             	sub    $0x1c,%esp
80101945:	8b 75 08             	mov    0x8(%ebp),%esi
80101948:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
8010194b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101950:	75 07                	jne    80101959 <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101952:	bb 00 00 00 00       	mov    $0x0,%ebx
80101957:	eb 1d                	jmp    80101976 <dirlookup+0x3a>
    panic("dirlookup not DIR");
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	68 c7 6c 10 80       	push   $0x80106cc7
80101961:	e8 db e9 ff ff       	call   80100341 <panic>
      panic("dirlookup read");
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	68 d9 6c 10 80       	push   $0x80106cd9
8010196e:	e8 ce e9 ff ff       	call   80100341 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101973:	83 c3 10             	add    $0x10,%ebx
80101976:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101979:	76 48                	jbe    801019c3 <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010197b:	6a 10                	push   $0x10
8010197d:	53                   	push   %ebx
8010197e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101981:	50                   	push   %eax
80101982:	56                   	push   %esi
80101983:	e8 6b fd ff ff       	call   801016f3 <readi>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	83 f8 10             	cmp    $0x10,%eax
8010198e:	75 d6                	jne    80101966 <dirlookup+0x2a>
    if(de.inum == 0)
80101990:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101995:	74 dc                	je     80101973 <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
80101997:	83 ec 08             	sub    $0x8,%esp
8010199a:	8d 45 da             	lea    -0x26(%ebp),%eax
8010199d:	50                   	push   %eax
8010199e:	57                   	push   %edi
8010199f:	e8 83 ff ff ff       	call   80101927 <namecmp>
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	85 c0                	test   %eax,%eax
801019a9:	75 c8                	jne    80101973 <dirlookup+0x37>
      if(poff)
801019ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801019af:	74 05                	je     801019b6 <dirlookup+0x7a>
        *poff = off;
801019b1:	8b 45 10             	mov    0x10(%ebp),%eax
801019b4:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
801019b6:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801019ba:	8b 06                	mov    (%esi),%eax
801019bc:	e8 59 f7 ff ff       	call   8010111a <iget>
801019c1:	eb 05                	jmp    801019c8 <dirlookup+0x8c>
  return 0;
801019c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	5e                   	pop    %esi
801019cd:	5f                   	pop    %edi
801019ce:	5d                   	pop    %ebp
801019cf:	c3                   	ret    

801019d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	89 c3                	mov    %eax,%ebx
801019db:	89 55 e0             	mov    %edx,-0x20(%ebp)
801019de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
801019e1:	80 38 2f             	cmpb   $0x2f,(%eax)
801019e4:	74 17                	je     801019fd <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801019e6:	e8 2f 19 00 00       	call   8010331a <myproc>
801019eb:	83 ec 0c             	sub    $0xc,%esp
801019ee:	ff 70 68             	push   0x68(%eax)
801019f1:	e8 e2 fa ff ff       	call   801014d8 <idup>
801019f6:	89 c6                	mov    %eax,%esi
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	eb 53                	jmp    80101a50 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
801019fd:	ba 01 00 00 00       	mov    $0x1,%edx
80101a02:	b8 01 00 00 00       	mov    $0x1,%eax
80101a07:	e8 0e f7 ff ff       	call   8010111a <iget>
80101a0c:	89 c6                	mov    %eax,%esi
80101a0e:	eb 40                	jmp    80101a50 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	56                   	push   %esi
80101a14:	e8 90 fc ff ff       	call   801016a9 <iunlockput>
      return 0;
80101a19:	83 c4 10             	add    $0x10,%esp
80101a1c:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a21:	89 f0                	mov    %esi,%eax
80101a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101a2b:	83 ec 04             	sub    $0x4,%esp
80101a2e:	6a 00                	push   $0x0
80101a30:	ff 75 e4             	push   -0x1c(%ebp)
80101a33:	56                   	push   %esi
80101a34:	e8 03 ff ff ff       	call   8010193c <dirlookup>
80101a39:	89 c7                	mov    %eax,%edi
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	85 c0                	test   %eax,%eax
80101a40:	74 4a                	je     80101a8c <namex+0xbc>
    iunlockput(ip);
80101a42:	83 ec 0c             	sub    $0xc,%esp
80101a45:	56                   	push   %esi
80101a46:	e8 5e fc ff ff       	call   801016a9 <iunlockput>
80101a4b:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101a4e:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a53:	89 d8                	mov    %ebx,%eax
80101a55:	e8 97 f4 ff ff       	call   80100ef1 <skipelem>
80101a5a:	89 c3                	mov    %eax,%ebx
80101a5c:	85 c0                	test   %eax,%eax
80101a5e:	74 3c                	je     80101a9c <namex+0xcc>
    ilock(ip);
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	56                   	push   %esi
80101a64:	e8 9d fa ff ff       	call   80101506 <ilock>
    if(ip->type != T_DIR){
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a71:	75 9d                	jne    80101a10 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101a73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101a77:	74 b2                	je     80101a2b <namex+0x5b>
80101a79:	80 3b 00             	cmpb   $0x0,(%ebx)
80101a7c:	75 ad                	jne    80101a2b <namex+0x5b>
      iunlock(ip);
80101a7e:	83 ec 0c             	sub    $0xc,%esp
80101a81:	56                   	push   %esi
80101a82:	e8 3f fb ff ff       	call   801015c6 <iunlock>
      return ip;
80101a87:	83 c4 10             	add    $0x10,%esp
80101a8a:	eb 95                	jmp    80101a21 <namex+0x51>
      iunlockput(ip);
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	56                   	push   %esi
80101a90:	e8 14 fc ff ff       	call   801016a9 <iunlockput>
      return 0;
80101a95:	83 c4 10             	add    $0x10,%esp
80101a98:	89 fe                	mov    %edi,%esi
80101a9a:	eb 85                	jmp    80101a21 <namex+0x51>
  if(nameiparent){
80101a9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101aa0:	0f 84 7b ff ff ff    	je     80101a21 <namex+0x51>
    iput(ip);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 5c fb ff ff       	call   8010160b <iput>
    return 0;
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	89 de                	mov    %ebx,%esi
80101ab4:	e9 68 ff ff ff       	jmp    80101a21 <namex+0x51>

80101ab9 <dirlink>:
{
80101ab9:	55                   	push   %ebp
80101aba:	89 e5                	mov    %esp,%ebp
80101abc:	57                   	push   %edi
80101abd:	56                   	push   %esi
80101abe:	53                   	push   %ebx
80101abf:	83 ec 20             	sub    $0x20,%esp
80101ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101ac5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ac8:	6a 00                	push   $0x0
80101aca:	57                   	push   %edi
80101acb:	53                   	push   %ebx
80101acc:	e8 6b fe ff ff       	call   8010193c <dirlookup>
80101ad1:	83 c4 10             	add    $0x10,%esp
80101ad4:	85 c0                	test   %eax,%eax
80101ad6:	75 2d                	jne    80101b05 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ad8:	b8 00 00 00 00       	mov    $0x0,%eax
80101add:	89 c6                	mov    %eax,%esi
80101adf:	39 43 58             	cmp    %eax,0x58(%ebx)
80101ae2:	76 41                	jbe    80101b25 <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ae4:	6a 10                	push   $0x10
80101ae6:	50                   	push   %eax
80101ae7:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101aea:	50                   	push   %eax
80101aeb:	53                   	push   %ebx
80101aec:	e8 02 fc ff ff       	call   801016f3 <readi>
80101af1:	83 c4 10             	add    $0x10,%esp
80101af4:	83 f8 10             	cmp    $0x10,%eax
80101af7:	75 1f                	jne    80101b18 <dirlink+0x5f>
    if(de.inum == 0)
80101af9:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101afe:	74 25                	je     80101b25 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b00:	8d 46 10             	lea    0x10(%esi),%eax
80101b03:	eb d8                	jmp    80101add <dirlink+0x24>
    iput(ip);
80101b05:	83 ec 0c             	sub    $0xc,%esp
80101b08:	50                   	push   %eax
80101b09:	e8 fd fa ff ff       	call   8010160b <iput>
    return -1;
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb 3d                	jmp    80101b55 <dirlink+0x9c>
      panic("dirlink read");
80101b18:	83 ec 0c             	sub    $0xc,%esp
80101b1b:	68 e8 6c 10 80       	push   $0x80106ce8
80101b20:	e8 1c e8 ff ff       	call   80100341 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 0e                	push   $0xe
80101b2a:	57                   	push   %edi
80101b2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b2e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b31:	50                   	push   %eax
80101b32:	e8 d7 23 00 00       	call   80103f0e <strncpy>
  de.inum = inum;
80101b37:	8b 45 10             	mov    0x10(%ebp),%eax
80101b3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b3e:	6a 10                	push   $0x10
80101b40:	56                   	push   %esi
80101b41:	57                   	push   %edi
80101b42:	53                   	push   %ebx
80101b43:	e8 ab fc ff ff       	call   801017f3 <writei>
80101b48:	83 c4 20             	add    $0x20,%esp
80101b4b:	83 f8 10             	cmp    $0x10,%eax
80101b4e:	75 0d                	jne    80101b5d <dirlink+0xa4>
  return 0;
80101b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
    panic("dirlink");
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 e4 72 10 80       	push   $0x801072e4
80101b65:	e8 d7 e7 ff ff       	call   80100341 <panic>

80101b6a <namei>:

struct inode*
namei(char *path)
{
80101b6a:	55                   	push   %ebp
80101b6b:	89 e5                	mov    %esp,%ebp
80101b6d:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101b70:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101b73:	ba 00 00 00 00       	mov    $0x0,%edx
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	e8 50 fe ff ff       	call   801019d0 <namex>
}
80101b80:	c9                   	leave  
80101b81:	c3                   	ret    

80101b82 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101b82:	55                   	push   %ebp
80101b83:	89 e5                	mov    %esp,%ebp
80101b85:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101b8b:	ba 01 00 00 00       	mov    $0x1,%edx
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	e8 38 fe ff ff       	call   801019d0 <namex>
}
80101b98:	c9                   	leave  
80101b99:	c3                   	ret    

80101b9a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101b9a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b9c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ba1:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ba2:	88 c2                	mov    %al,%dl
80101ba4:	83 e2 c0             	and    $0xffffffc0,%edx
80101ba7:	80 fa 40             	cmp    $0x40,%dl
80101baa:	75 f0                	jne    80101b9c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101bac:	85 c9                	test   %ecx,%ecx
80101bae:	74 09                	je     80101bb9 <idewait+0x1f>
80101bb0:	a8 21                	test   $0x21,%al
80101bb2:	75 08                	jne    80101bbc <idewait+0x22>
    return -1;
  return 0;
80101bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101bb9:	89 c8                	mov    %ecx,%eax
80101bbb:	c3                   	ret    
    return -1;
80101bbc:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101bc1:	eb f6                	jmp    80101bb9 <idewait+0x1f>

80101bc3 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101bc3:	55                   	push   %ebp
80101bc4:	89 e5                	mov    %esp,%ebp
80101bc6:	56                   	push   %esi
80101bc7:	53                   	push   %ebx
  if(b == 0)
80101bc8:	85 c0                	test   %eax,%eax
80101bca:	0f 84 85 00 00 00    	je     80101c55 <idestart+0x92>
80101bd0:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101bd2:	8b 58 08             	mov    0x8(%eax),%ebx
80101bd5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101bdb:	0f 87 81 00 00 00    	ja     80101c62 <idestart+0x9f>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101be1:	b8 00 00 00 00       	mov    $0x0,%eax
80101be6:	e8 af ff ff ff       	call   80101b9a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101beb:	b0 00                	mov    $0x0,%al
80101bed:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101bf2:	ee                   	out    %al,(%dx)
80101bf3:	b0 01                	mov    $0x1,%al
80101bf5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101bfa:	ee                   	out    %al,(%dx)
80101bfb:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c00:	88 d8                	mov    %bl,%al
80101c02:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c03:	0f b6 c7             	movzbl %bh,%eax
80101c06:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c0b:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c0c:	89 d8                	mov    %ebx,%eax
80101c0e:	c1 f8 10             	sar    $0x10,%eax
80101c11:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c16:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c17:	8a 46 04             	mov    0x4(%esi),%al
80101c1a:	c1 e0 04             	shl    $0x4,%eax
80101c1d:	83 e0 10             	and    $0x10,%eax
80101c20:	c1 fb 18             	sar    $0x18,%ebx
80101c23:	83 e3 0f             	and    $0xf,%ebx
80101c26:	09 d8                	or     %ebx,%eax
80101c28:	83 c8 e0             	or     $0xffffffe0,%eax
80101c2b:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c30:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101c31:	f6 06 04             	testb  $0x4,(%esi)
80101c34:	74 39                	je     80101c6f <idestart+0xac>
80101c36:	b0 30                	mov    $0x30,%al
80101c38:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c3d:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101c3e:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101c41:	b9 80 00 00 00       	mov    $0x80,%ecx
80101c46:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101c4b:	fc                   	cld    
80101c4c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c51:	5b                   	pop    %ebx
80101c52:	5e                   	pop    %esi
80101c53:	5d                   	pop    %ebp
80101c54:	c3                   	ret    
    panic("idestart");
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 4b 6d 10 80       	push   $0x80106d4b
80101c5d:	e8 df e6 ff ff       	call   80100341 <panic>
    panic("incorrect blockno");
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 54 6d 10 80       	push   $0x80106d54
80101c6a:	e8 d2 e6 ff ff       	call   80100341 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c6f:	b0 20                	mov    $0x20,%al
80101c71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c76:	ee                   	out    %al,(%dx)
}
80101c77:	eb d5                	jmp    80101c4e <idestart+0x8b>

80101c79 <ideinit>:
{
80101c79:	55                   	push   %ebp
80101c7a:	89 e5                	mov    %esp,%ebp
80101c7c:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101c7f:	68 66 6d 10 80       	push   $0x80106d66
80101c84:	68 00 16 11 80       	push   $0x80111600
80101c89:	e8 89 1f 00 00       	call   80103c17 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101c8e:	83 c4 08             	add    $0x8,%esp
80101c91:	a1 84 17 11 80       	mov    0x80111784,%eax
80101c96:	48                   	dec    %eax
80101c97:	50                   	push   %eax
80101c98:	6a 0e                	push   $0xe
80101c9a:	e8 46 02 00 00       	call   80101ee5 <ioapicenable>
  idewait(0);
80101c9f:	b8 00 00 00 00       	mov    $0x0,%eax
80101ca4:	e8 f1 fe ff ff       	call   80101b9a <idewait>
80101ca9:	b0 f0                	mov    $0xf0,%al
80101cab:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cb0:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101cb1:	83 c4 10             	add    $0x10,%esp
80101cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
80101cb9:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101cbf:	7f 17                	jg     80101cd8 <ideinit+0x5f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cc6:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101cc7:	84 c0                	test   %al,%al
80101cc9:	75 03                	jne    80101cce <ideinit+0x55>
  for(i=0; i<1000; i++){
80101ccb:	41                   	inc    %ecx
80101ccc:	eb eb                	jmp    80101cb9 <ideinit+0x40>
      havedisk1 = 1;
80101cce:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101cd5:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cd8:	b0 e0                	mov    $0xe0,%al
80101cda:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cdf:	ee                   	out    %al,(%dx)
}
80101ce0:	c9                   	leave  
80101ce1:	c3                   	ret    

80101ce2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101ce2:	55                   	push   %ebp
80101ce3:	89 e5                	mov    %esp,%ebp
80101ce5:	57                   	push   %edi
80101ce6:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 00 16 11 80       	push   $0x80111600
80101cef:	e8 5a 20 00 00       	call   80103d4e <acquire>

  if((b = idequeue) == 0){
80101cf4:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	85 db                	test   %ebx,%ebx
80101cff:	74 4a                	je     80101d4b <ideintr+0x69>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d01:	8b 43 58             	mov    0x58(%ebx),%eax
80101d04:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d09:	f6 03 04             	testb  $0x4,(%ebx)
80101d0c:	74 4f                	je     80101d5d <ideintr+0x7b>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d0e:	8b 03                	mov    (%ebx),%eax
80101d10:	83 c8 02             	or     $0x2,%eax
80101d13:	89 03                	mov    %eax,(%ebx)
  b->flags &= ~B_DIRTY;
80101d15:	83 e0 fb             	and    $0xfffffffb,%eax
80101d18:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d1a:	83 ec 0c             	sub    $0xc,%esp
80101d1d:	53                   	push   %ebx
80101d1e:	e8 85 1c 00 00       	call   801039a8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101d23:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101d28:	83 c4 10             	add    $0x10,%esp
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <ideintr+0x52>
    idestart(idequeue);
80101d2f:	e8 8f fe ff ff       	call   80101bc3 <idestart>

  release(&idelock);
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 00 16 11 80       	push   $0x80111600
80101d3c:	e8 72 20 00 00       	call   80103db3 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
}
80101d44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d47:	5b                   	pop    %ebx
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
    release(&idelock);
80101d4b:	83 ec 0c             	sub    $0xc,%esp
80101d4e:	68 00 16 11 80       	push   $0x80111600
80101d53:	e8 5b 20 00 00       	call   80103db3 <release>
    return;
80101d58:	83 c4 10             	add    $0x10,%esp
80101d5b:	eb e7                	jmp    80101d44 <ideintr+0x62>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101d62:	e8 33 fe ff ff       	call   80101b9a <idewait>
80101d67:	85 c0                	test   %eax,%eax
80101d69:	78 a3                	js     80101d0e <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101d6b:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101d6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d73:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d78:	fc                   	cld    
80101d79:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101d7b:	eb 91                	jmp    80101d0e <ideintr+0x2c>

80101d7d <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101d7d:	55                   	push   %ebp
80101d7e:	89 e5                	mov    %esp,%ebp
80101d80:	53                   	push   %ebx
80101d81:	83 ec 10             	sub    $0x10,%esp
80101d84:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101d87:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d8a:	50                   	push   %eax
80101d8b:	e8 39 1e 00 00       	call   80103bc9 <holdingsleep>
80101d90:	83 c4 10             	add    $0x10,%esp
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 37                	je     80101dce <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101d97:	8b 03                	mov    (%ebx),%eax
80101d99:	83 e0 06             	and    $0x6,%eax
80101d9c:	83 f8 02             	cmp    $0x2,%eax
80101d9f:	74 3a                	je     80101ddb <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101da1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101da5:	74 09                	je     80101db0 <iderw+0x33>
80101da7:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101dae:	74 38                	je     80101de8 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	68 00 16 11 80       	push   $0x80111600
80101db8:	e8 91 1f 00 00       	call   80103d4e <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101dbd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101dcc:	eb 2a                	jmp    80101df8 <iderw+0x7b>
    panic("iderw: buf not locked");
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 6a 6d 10 80       	push   $0x80106d6a
80101dd6:	e8 66 e5 ff ff       	call   80100341 <panic>
    panic("iderw: nothing to do");
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	68 80 6d 10 80       	push   $0x80106d80
80101de3:	e8 59 e5 ff ff       	call   80100341 <panic>
    panic("iderw: ide disk 1 not present");
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 95 6d 10 80       	push   $0x80106d95
80101df0:	e8 4c e5 ff ff       	call   80100341 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101df5:	8d 50 58             	lea    0x58(%eax),%edx
80101df8:	8b 02                	mov    (%edx),%eax
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	75 f7                	jne    80101df5 <iderw+0x78>
    ;
  *pp = b;
80101dfe:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e00:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e06:	75 1a                	jne    80101e22 <iderw+0xa5>
    idestart(b);
80101e08:	89 d8                	mov    %ebx,%eax
80101e0a:	e8 b4 fd ff ff       	call   80101bc3 <idestart>
80101e0f:	eb 11                	jmp    80101e22 <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e11:	83 ec 08             	sub    $0x8,%esp
80101e14:	68 00 16 11 80       	push   $0x80111600
80101e19:	53                   	push   %ebx
80101e1a:	e8 17 1a 00 00       	call   80103836 <sleep>
80101e1f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101e22:	8b 03                	mov    (%ebx),%eax
80101e24:	83 e0 06             	and    $0x6,%eax
80101e27:	83 f8 02             	cmp    $0x2,%eax
80101e2a:	75 e5                	jne    80101e11 <iderw+0x94>
  }


  release(&idelock);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	68 00 16 11 80       	push   $0x80111600
80101e34:	e8 7a 1f 00 00       	call   80103db3 <release>
}
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e3f:	c9                   	leave  
80101e40:	c3                   	ret    

80101e41 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101e41:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101e47:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101e49:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e4e:	8b 40 10             	mov    0x10(%eax),%eax
}
80101e51:	c3                   	ret    

80101e52 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101e52:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101e58:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101e5a:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e5f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e62:	c3                   	ret    

80101e63 <ioapicinit>:

void
ioapicinit(void)
{
80101e63:	55                   	push   %ebp
80101e64:	89 e5                	mov    %esp,%ebp
80101e66:	57                   	push   %edi
80101e67:	56                   	push   %esi
80101e68:	53                   	push   %ebx
80101e69:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101e6c:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101e73:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101e76:	b8 01 00 00 00       	mov    $0x1,%eax
80101e7b:	e8 c1 ff ff ff       	call   80101e41 <ioapicread>
80101e80:	c1 e8 10             	shr    $0x10,%eax
80101e83:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101e86:	b8 00 00 00 00       	mov    $0x0,%eax
80101e8b:	e8 b1 ff ff ff       	call   80101e41 <ioapicread>
80101e90:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101e93:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101e9a:	39 c2                	cmp    %eax,%edx
80101e9c:	75 07                	jne    80101ea5 <ioapicinit+0x42>
{
80101e9e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ea3:	eb 34                	jmp    80101ed9 <ioapicinit+0x76>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 b4 6d 10 80       	push   $0x80106db4
80101ead:	e8 28 e7 ff ff       	call   801005da <cprintf>
80101eb2:	83 c4 10             	add    $0x10,%esp
80101eb5:	eb e7                	jmp    80101e9e <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101eb7:	8d 53 20             	lea    0x20(%ebx),%edx
80101eba:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101ec0:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101ec4:	89 f0                	mov    %esi,%eax
80101ec6:	e8 87 ff ff ff       	call   80101e52 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101ecb:	8d 46 01             	lea    0x1(%esi),%eax
80101ece:	ba 00 00 00 00       	mov    $0x0,%edx
80101ed3:	e8 7a ff ff ff       	call   80101e52 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101ed8:	43                   	inc    %ebx
80101ed9:	39 fb                	cmp    %edi,%ebx
80101edb:	7e da                	jle    80101eb7 <ioapicinit+0x54>
  }
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    

80101ee5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101ee5:	55                   	push   %ebp
80101ee6:	89 e5                	mov    %esp,%ebp
80101ee8:	53                   	push   %ebx
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101eef:	8d 50 20             	lea    0x20(%eax),%edx
80101ef2:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101ef6:	89 d8                	mov    %ebx,%eax
80101ef8:	e8 55 ff ff ff       	call   80101e52 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101efd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f00:	c1 e2 18             	shl    $0x18,%edx
80101f03:	8d 43 01             	lea    0x1(%ebx),%eax
80101f06:	e8 47 ff ff ff       	call   80101e52 <ioapicwrite>
}
80101f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0e:	c9                   	leave  
80101f0f:	c3                   	ret    

80101f10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	53                   	push   %ebx
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f1a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f20:	75 4c                	jne    80101f6e <kfree+0x5e>
80101f22:	81 fb 30 58 11 80    	cmp    $0x80115830,%ebx
80101f28:	72 44                	jb     80101f6e <kfree+0x5e>
80101f2a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101f30:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101f35:	77 37                	ja     80101f6e <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101f37:	83 ec 04             	sub    $0x4,%esp
80101f3a:	68 00 10 00 00       	push   $0x1000
80101f3f:	6a 01                	push   $0x1
80101f41:	53                   	push   %ebx
80101f42:	e8 b3 1e 00 00       	call   80103dfa <memset>

  if(kmem.use_lock)
80101f47:	83 c4 10             	add    $0x10,%esp
80101f4a:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f51:	75 28                	jne    80101f7b <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101f53:	a1 78 16 11 80       	mov    0x80111678,%eax
80101f58:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101f5a:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101f60:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f67:	75 24                	jne    80101f8d <kfree+0x7d>
    release(&kmem.lock);
}
80101f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f6c:	c9                   	leave  
80101f6d:	c3                   	ret    
    panic("kfree");
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	68 e6 6d 10 80       	push   $0x80106de6
80101f76:	e8 c6 e3 ff ff       	call   80100341 <panic>
    acquire(&kmem.lock);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	68 40 16 11 80       	push   $0x80111640
80101f83:	e8 c6 1d 00 00       	call   80103d4e <acquire>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	eb c6                	jmp    80101f53 <kfree+0x43>
    release(&kmem.lock);
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 40 16 11 80       	push   $0x80111640
80101f95:	e8 19 1e 00 00       	call   80103db3 <release>
80101f9a:	83 c4 10             	add    $0x10,%esp
}
80101f9d:	eb ca                	jmp    80101f69 <kfree+0x59>

80101f9f <freerange>:
{
80101f9f:	55                   	push   %ebp
80101fa0:	89 e5                	mov    %esp,%ebp
80101fa2:	56                   	push   %esi
80101fa3:	53                   	push   %ebx
80101fa4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	05 ff 0f 00 00       	add    $0xfff,%eax
80101faf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101fb4:	eb 0e                	jmp    80101fc4 <freerange+0x25>
    kfree(p);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	50                   	push   %eax
80101fba:	e8 51 ff ff ff       	call   80101f10 <kfree>
80101fbf:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80101fca:	39 de                	cmp    %ebx,%esi
80101fcc:	76 e8                	jbe    80101fb6 <freerange+0x17>
}
80101fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <kinit1>:
{
80101fd5:	55                   	push   %ebp
80101fd6:	89 e5                	mov    %esp,%ebp
80101fd8:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80101fdb:	68 ec 6d 10 80       	push   $0x80106dec
80101fe0:	68 40 16 11 80       	push   $0x80111640
80101fe5:	e8 2d 1c 00 00       	call   80103c17 <initlock>
  kmem.use_lock = 0;
80101fea:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80101ff1:	00 00 00 
  freerange(vstart, vend);
80101ff4:	83 c4 08             	add    $0x8,%esp
80101ff7:	ff 75 0c             	push   0xc(%ebp)
80101ffa:	ff 75 08             	push   0x8(%ebp)
80101ffd:	e8 9d ff ff ff       	call   80101f9f <freerange>
}
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	c9                   	leave  
80102006:	c3                   	ret    

80102007 <kinit2>:
{
80102007:	55                   	push   %ebp
80102008:	89 e5                	mov    %esp,%ebp
8010200a:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
8010200d:	ff 75 0c             	push   0xc(%ebp)
80102010:	ff 75 08             	push   0x8(%ebp)
80102013:	e8 87 ff ff ff       	call   80101f9f <freerange>
  kmem.use_lock = 1;
80102018:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010201f:	00 00 00 
}
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	c9                   	leave  
80102026:	c3                   	ret    

80102027 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102027:	55                   	push   %ebp
80102028:	89 e5                	mov    %esp,%ebp
8010202a:	53                   	push   %ebx
8010202b:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010202e:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102035:	75 21                	jne    80102058 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102037:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
8010203d:	85 db                	test   %ebx,%ebx
8010203f:	74 07                	je     80102048 <kalloc+0x21>
    kmem.freelist = r->next;
80102041:	8b 03                	mov    (%ebx),%eax
80102043:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
80102048:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010204f:	75 19                	jne    8010206a <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
80102051:	89 d8                	mov    %ebx,%eax
80102053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102056:	c9                   	leave  
80102057:	c3                   	ret    
    acquire(&kmem.lock);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 40 16 11 80       	push   $0x80111640
80102060:	e8 e9 1c 00 00       	call   80103d4e <acquire>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	eb cd                	jmp    80102037 <kalloc+0x10>
    release(&kmem.lock);
8010206a:	83 ec 0c             	sub    $0xc,%esp
8010206d:	68 40 16 11 80       	push   $0x80111640
80102072:	e8 3c 1d 00 00       	call   80103db3 <release>
80102077:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
8010207a:	eb d5                	jmp    80102051 <kalloc+0x2a>

8010207c <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010207c:	ba 64 00 00 00       	mov    $0x64,%edx
80102081:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102082:	a8 01                	test   $0x1,%al
80102084:	0f 84 b3 00 00 00    	je     8010213d <kbdgetc+0xc1>
8010208a:	ba 60 00 00 00       	mov    $0x60,%edx
8010208f:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102090:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102093:	3c e0                	cmp    $0xe0,%al
80102095:	74 61                	je     801020f8 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102097:	84 c0                	test   %al,%al
80102099:	78 6a                	js     80102105 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010209b:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
801020a1:	f6 c2 40             	test   $0x40,%dl
801020a4:	74 0f                	je     801020b5 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801020a6:	83 c8 80             	or     $0xffffff80,%eax
801020a9:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
801020ac:	83 e2 bf             	and    $0xffffffbf,%edx
801020af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
801020b5:	0f b6 91 20 6f 10 80 	movzbl -0x7fef90e0(%ecx),%edx
801020bc:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020c2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
801020c8:	0f b6 81 20 6e 10 80 	movzbl -0x7fef91e0(%ecx),%eax
801020cf:	31 c2                	xor    %eax,%edx
801020d1:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	83 e0 03             	and    $0x3,%eax
801020dc:	8b 04 85 00 6e 10 80 	mov    -0x7fef9200(,%eax,4),%eax
801020e3:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801020e7:	f6 c2 08             	test   $0x8,%dl
801020ea:	74 56                	je     80102142 <kbdgetc+0xc6>
    if('a' <= c && c <= 'z')
801020ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801020ef:	83 fa 19             	cmp    $0x19,%edx
801020f2:	77 3d                	ja     80102131 <kbdgetc+0xb5>
      c += 'A' - 'a';
801020f4:	83 e8 20             	sub    $0x20,%eax
801020f7:	c3                   	ret    
    shift |= E0ESC;
801020f8:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
801020ff:	b8 00 00 00 00       	mov    $0x0,%eax
80102104:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102105:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010210b:	f6 c2 40             	test   $0x40,%dl
8010210e:	75 05                	jne    80102115 <kbdgetc+0x99>
80102110:	89 c1                	mov    %eax,%ecx
80102112:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102115:	8a 81 20 6f 10 80    	mov    -0x7fef90e0(%ecx),%al
8010211b:	83 c8 40             	or     $0x40,%eax
8010211e:	0f b6 c0             	movzbl %al,%eax
80102121:	f7 d0                	not    %eax
80102123:	21 c2                	and    %eax,%edx
80102125:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
8010212b:	b8 00 00 00 00       	mov    $0x0,%eax
80102130:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102131:	8d 50 bf             	lea    -0x41(%eax),%edx
80102134:	83 fa 19             	cmp    $0x19,%edx
80102137:	77 09                	ja     80102142 <kbdgetc+0xc6>
      c += 'a' - 'A';
80102139:	83 c0 20             	add    $0x20,%eax
  }
  return c;
8010213c:	c3                   	ret    
    return -1;
8010213d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102142:	c3                   	ret    

80102143 <kbdintr>:

void
kbdintr(void)
{
80102143:	55                   	push   %ebp
80102144:	89 e5                	mov    %esp,%ebp
80102146:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102149:	68 7c 20 10 80       	push   $0x8010207c
8010214e:	e8 ac e5 ff ff       	call   801006ff <consoleintr>
}
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	c9                   	leave  
80102157:	c3                   	ret    

80102158 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102158:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
8010215e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102161:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102163:	a1 80 16 11 80       	mov    0x80111680,%eax
80102168:	8b 40 20             	mov    0x20(%eax),%eax
}
8010216b:	c3                   	ret    

8010216c <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216c:	ba 70 00 00 00       	mov    $0x70,%edx
80102171:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102172:	ba 71 00 00 00       	mov    $0x71,%edx
80102177:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102178:	0f b6 c0             	movzbl %al,%eax
}
8010217b:	c3                   	ret    

8010217c <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
8010217c:	55                   	push   %ebp
8010217d:	89 e5                	mov    %esp,%ebp
8010217f:	53                   	push   %ebx
80102180:	83 ec 04             	sub    $0x4,%esp
80102183:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102185:	b8 00 00 00 00       	mov    $0x0,%eax
8010218a:	e8 dd ff ff ff       	call   8010216c <cmos_read>
8010218f:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102191:	b8 02 00 00 00       	mov    $0x2,%eax
80102196:	e8 d1 ff ff ff       	call   8010216c <cmos_read>
8010219b:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010219e:	b8 04 00 00 00       	mov    $0x4,%eax
801021a3:	e8 c4 ff ff ff       	call   8010216c <cmos_read>
801021a8:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
801021ab:	b8 07 00 00 00       	mov    $0x7,%eax
801021b0:	e8 b7 ff ff ff       	call   8010216c <cmos_read>
801021b5:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801021b8:	b8 08 00 00 00       	mov    $0x8,%eax
801021bd:	e8 aa ff ff ff       	call   8010216c <cmos_read>
801021c2:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801021c5:	b8 09 00 00 00       	mov    $0x9,%eax
801021ca:	e8 9d ff ff ff       	call   8010216c <cmos_read>
801021cf:	89 43 14             	mov    %eax,0x14(%ebx)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
801021d6:	c3                   	ret    

801021d7 <lapicinit>:
  if(!lapic)
801021d7:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
801021de:	0f 84 fe 00 00 00    	je     801022e2 <lapicinit+0x10b>
{
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801021ea:	ba 3f 01 00 00       	mov    $0x13f,%edx
801021ef:	b8 3c 00 00 00       	mov    $0x3c,%eax
801021f4:	e8 5f ff ff ff       	call   80102158 <lapicw>
  lapicw(TDCR, X1);
801021f9:	ba 0b 00 00 00       	mov    $0xb,%edx
801021fe:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102203:	e8 50 ff ff ff       	call   80102158 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102208:	ba 20 00 02 00       	mov    $0x20020,%edx
8010220d:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102212:	e8 41 ff ff ff       	call   80102158 <lapicw>
  lapicw(TICR, 10000000);
80102217:	ba 80 96 98 00       	mov    $0x989680,%edx
8010221c:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102221:	e8 32 ff ff ff       	call   80102158 <lapicw>
  lapicw(LINT0, MASKED);
80102226:	ba 00 00 01 00       	mov    $0x10000,%edx
8010222b:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102230:	e8 23 ff ff ff       	call   80102158 <lapicw>
  lapicw(LINT1, MASKED);
80102235:	ba 00 00 01 00       	mov    $0x10000,%edx
8010223a:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010223f:	e8 14 ff ff ff       	call   80102158 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102244:	a1 80 16 11 80       	mov    0x80111680,%eax
80102249:	8b 40 30             	mov    0x30(%eax),%eax
8010224c:	c1 e8 10             	shr    $0x10,%eax
8010224f:	a8 fc                	test   $0xfc,%al
80102251:	75 7b                	jne    801022ce <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102253:	ba 33 00 00 00       	mov    $0x33,%edx
80102258:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010225d:	e8 f6 fe ff ff       	call   80102158 <lapicw>
  lapicw(ESR, 0);
80102262:	ba 00 00 00 00       	mov    $0x0,%edx
80102267:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010226c:	e8 e7 fe ff ff       	call   80102158 <lapicw>
  lapicw(ESR, 0);
80102271:	ba 00 00 00 00       	mov    $0x0,%edx
80102276:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010227b:	e8 d8 fe ff ff       	call   80102158 <lapicw>
  lapicw(EOI, 0);
80102280:	ba 00 00 00 00       	mov    $0x0,%edx
80102285:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010228a:	e8 c9 fe ff ff       	call   80102158 <lapicw>
  lapicw(ICRHI, 0);
8010228f:	ba 00 00 00 00       	mov    $0x0,%edx
80102294:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102299:	e8 ba fe ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010229e:	ba 00 85 08 00       	mov    $0x88500,%edx
801022a3:	b8 c0 00 00 00       	mov    $0xc0,%eax
801022a8:	e8 ab fe ff ff       	call   80102158 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801022ad:	a1 80 16 11 80       	mov    0x80111680,%eax
801022b2:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801022b8:	f6 c4 10             	test   $0x10,%ah
801022bb:	75 f0                	jne    801022ad <lapicinit+0xd6>
  lapicw(TPR, 0);
801022bd:	ba 00 00 00 00       	mov    $0x0,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	e8 8c fe ff ff       	call   80102158 <lapicw>
}
801022cc:	c9                   	leave  
801022cd:	c3                   	ret    
    lapicw(PCINT, MASKED);
801022ce:	ba 00 00 01 00       	mov    $0x10000,%edx
801022d3:	b8 d0 00 00 00       	mov    $0xd0,%eax
801022d8:	e8 7b fe ff ff       	call   80102158 <lapicw>
801022dd:	e9 71 ff ff ff       	jmp    80102253 <lapicinit+0x7c>
801022e2:	c3                   	ret    

801022e3 <lapicid>:
  if (!lapic)
801022e3:	a1 80 16 11 80       	mov    0x80111680,%eax
801022e8:	85 c0                	test   %eax,%eax
801022ea:	74 07                	je     801022f3 <lapicid+0x10>
  return lapic[ID] >> 24;
801022ec:	8b 40 20             	mov    0x20(%eax),%eax
801022ef:	c1 e8 18             	shr    $0x18,%eax
801022f2:	c3                   	ret    
    return 0;
801022f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022f8:	c3                   	ret    

801022f9 <lapiceoi>:
  if(lapic)
801022f9:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
80102300:	74 17                	je     80102319 <lapiceoi+0x20>
{
80102302:	55                   	push   %ebp
80102303:	89 e5                	mov    %esp,%ebp
80102305:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102308:	ba 00 00 00 00       	mov    $0x0,%edx
8010230d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102312:	e8 41 fe ff ff       	call   80102158 <lapicw>
}
80102317:	c9                   	leave  
80102318:	c3                   	ret    
80102319:	c3                   	ret    

8010231a <microdelay>:
}
8010231a:	c3                   	ret    

8010231b <lapicstartap>:
{
8010231b:	55                   	push   %ebp
8010231c:	89 e5                	mov    %esp,%ebp
8010231e:	57                   	push   %edi
8010231f:	56                   	push   %esi
80102320:	53                   	push   %ebx
80102321:	83 ec 0c             	sub    $0xc,%esp
80102324:	8b 75 08             	mov    0x8(%ebp),%esi
80102327:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	b0 0f                	mov    $0xf,%al
8010232c:	ba 70 00 00 00       	mov    $0x70,%edx
80102331:	ee                   	out    %al,(%dx)
80102332:	b0 0a                	mov    $0xa,%al
80102334:	ba 71 00 00 00       	mov    $0x71,%edx
80102339:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010233a:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102341:	00 00 
  wrv[1] = addr >> 4;
80102343:	89 f8                	mov    %edi,%eax
80102345:	c1 e8 04             	shr    $0x4,%eax
80102348:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010234e:	c1 e6 18             	shl    $0x18,%esi
80102351:	89 f2                	mov    %esi,%edx
80102353:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102358:	e8 fb fd ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010235d:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102362:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102367:	e8 ec fd ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010236c:	ba 00 85 00 00       	mov    $0x8500,%edx
80102371:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102376:	e8 dd fd ff ff       	call   80102158 <lapicw>
  for(i = 0; i < 2; i++){
8010237b:	bb 00 00 00 00       	mov    $0x0,%ebx
80102380:	eb 1f                	jmp    801023a1 <lapicstartap+0x86>
    lapicw(ICRHI, apicid<<24);
80102382:	89 f2                	mov    %esi,%edx
80102384:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102389:	e8 ca fd ff ff       	call   80102158 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010238e:	89 fa                	mov    %edi,%edx
80102390:	c1 ea 0c             	shr    $0xc,%edx
80102393:	80 ce 06             	or     $0x6,%dh
80102396:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010239b:	e8 b8 fd ff ff       	call   80102158 <lapicw>
  for(i = 0; i < 2; i++){
801023a0:	43                   	inc    %ebx
801023a1:	83 fb 01             	cmp    $0x1,%ebx
801023a4:	7e dc                	jle    80102382 <lapicstartap+0x67>
}
801023a6:	83 c4 0c             	add    $0xc,%esp
801023a9:	5b                   	pop    %ebx
801023aa:	5e                   	pop    %esi
801023ab:	5f                   	pop    %edi
801023ac:	5d                   	pop    %ebp
801023ad:	c3                   	ret    

801023ae <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801023ae:	55                   	push   %ebp
801023af:	89 e5                	mov    %esp,%ebp
801023b1:	57                   	push   %edi
801023b2:	56                   	push   %esi
801023b3:	53                   	push   %ebx
801023b4:	83 ec 3c             	sub    $0x3c,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801023ba:	b8 0b 00 00 00       	mov    $0xb,%eax
801023bf:	e8 a8 fd ff ff       	call   8010216c <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801023c4:	83 e0 04             	and    $0x4,%eax
801023c7:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801023c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023cc:	e8 ab fd ff ff       	call   8010217c <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801023d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801023d6:	e8 91 fd ff ff       	call   8010216c <cmos_read>
801023db:	a8 80                	test   $0x80,%al
801023dd:	75 ea                	jne    801023c9 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
801023df:	8d 75 b8             	lea    -0x48(%ebp),%esi
801023e2:	89 f0                	mov    %esi,%eax
801023e4:	e8 93 fd ff ff       	call   8010217c <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801023e9:	83 ec 04             	sub    $0x4,%esp
801023ec:	6a 18                	push   $0x18
801023ee:	56                   	push   %esi
801023ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023f2:	50                   	push   %eax
801023f3:	e8 49 1a 00 00       	call   80103e41 <memcmp>
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	85 c0                	test   %eax,%eax
801023fd:	75 ca                	jne    801023c9 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
801023ff:	85 ff                	test   %edi,%edi
80102401:	75 7e                	jne    80102481 <cmostime+0xd3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102403:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102406:	89 d0                	mov    %edx,%eax
80102408:	c1 e8 04             	shr    $0x4,%eax
8010240b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010240e:	01 c0                	add    %eax,%eax
80102410:	83 e2 0f             	and    $0xf,%edx
80102413:	01 d0                	add    %edx,%eax
80102415:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010241b:	89 d0                	mov    %edx,%eax
8010241d:	c1 e8 04             	shr    $0x4,%eax
80102420:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102423:	01 c0                	add    %eax,%eax
80102425:	83 e2 0f             	and    $0xf,%edx
80102428:	01 d0                	add    %edx,%eax
8010242a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010242d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102430:	89 d0                	mov    %edx,%eax
80102432:	c1 e8 04             	shr    $0x4,%eax
80102435:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102438:	01 c0                	add    %eax,%eax
8010243a:	83 e2 0f             	and    $0xf,%edx
8010243d:	01 d0                	add    %edx,%eax
8010243f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102442:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102445:	89 d0                	mov    %edx,%eax
80102447:	c1 e8 04             	shr    $0x4,%eax
8010244a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010244d:	01 c0                	add    %eax,%eax
8010244f:	83 e2 0f             	and    $0xf,%edx
80102452:	01 d0                	add    %edx,%eax
80102454:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102457:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010245a:	89 d0                	mov    %edx,%eax
8010245c:	c1 e8 04             	shr    $0x4,%eax
8010245f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102462:	01 c0                	add    %eax,%eax
80102464:	83 e2 0f             	and    $0xf,%edx
80102467:	01 d0                	add    %edx,%eax
80102469:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010246c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010246f:	89 d0                	mov    %edx,%eax
80102471:	c1 e8 04             	shr    $0x4,%eax
80102474:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102477:	01 c0                	add    %eax,%eax
80102479:	83 e2 0f             	and    $0xf,%edx
8010247c:	01 d0                	add    %edx,%eax
8010247e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102481:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102484:	b9 06 00 00 00       	mov    $0x6,%ecx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010248d:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5f                   	pop    %edi
8010249a:	5d                   	pop    %ebp
8010249b:	c3                   	ret    

8010249c <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	53                   	push   %ebx
801024a0:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801024a3:	ff 35 d4 16 11 80    	push   0x801116d4
801024a9:	ff 35 e4 16 11 80    	push   0x801116e4
801024af:	e8 b6 dc ff ff       	call   8010016a <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801024b4:	8b 58 5c             	mov    0x5c(%eax),%ebx
801024b7:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	ba 00 00 00 00       	mov    $0x0,%edx
801024c5:	eb 0c                	jmp    801024d3 <read_head+0x37>
    log.lh.block[i] = lh->block[i];
801024c7:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801024cb:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801024d2:	42                   	inc    %edx
801024d3:	39 d3                	cmp    %edx,%ebx
801024d5:	7f f0                	jg     801024c7 <read_head+0x2b>
  }
  brelse(buf);
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	50                   	push   %eax
801024db:	e8 f3 dc ff ff       	call   801001d3 <brelse>
}
801024e0:	83 c4 10             	add    $0x10,%esp
801024e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e6:	c9                   	leave  
801024e7:	c3                   	ret    

801024e8 <install_trans>:
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	57                   	push   %edi
801024ec:	56                   	push   %esi
801024ed:	53                   	push   %ebx
801024ee:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801024f1:	be 00 00 00 00       	mov    $0x0,%esi
801024f6:	eb 62                	jmp    8010255a <install_trans+0x72>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102500:	40                   	inc    %eax
80102501:	83 ec 08             	sub    $0x8,%esp
80102504:	50                   	push   %eax
80102505:	ff 35 e4 16 11 80    	push   0x801116e4
8010250b:	e8 5a dc ff ff       	call   8010016a <bread>
80102510:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102512:	83 c4 08             	add    $0x8,%esp
80102515:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
8010251c:	ff 35 e4 16 11 80    	push   0x801116e4
80102522:	e8 43 dc ff ff       	call   8010016a <bread>
80102527:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102529:	8d 57 5c             	lea    0x5c(%edi),%edx
8010252c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010252f:	83 c4 0c             	add    $0xc,%esp
80102532:	68 00 02 00 00       	push   $0x200
80102537:	52                   	push   %edx
80102538:	50                   	push   %eax
80102539:	e8 32 19 00 00       	call   80103e70 <memmove>
    bwrite(dbuf);  // write dst to disk
8010253e:	89 1c 24             	mov    %ebx,(%esp)
80102541:	e8 52 dc ff ff       	call   80100198 <bwrite>
    brelse(lbuf);
80102546:	89 3c 24             	mov    %edi,(%esp)
80102549:	e8 85 dc ff ff       	call   801001d3 <brelse>
    brelse(dbuf);
8010254e:	89 1c 24             	mov    %ebx,(%esp)
80102551:	e8 7d dc ff ff       	call   801001d3 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102556:	46                   	inc    %esi
80102557:	83 c4 10             	add    $0x10,%esp
8010255a:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102560:	7f 96                	jg     801024f8 <install_trans+0x10>
}
80102562:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102565:	5b                   	pop    %ebx
80102566:	5e                   	pop    %esi
80102567:	5f                   	pop    %edi
80102568:	5d                   	pop    %ebp
80102569:	c3                   	ret    

8010256a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010256a:	55                   	push   %ebp
8010256b:	89 e5                	mov    %esp,%ebp
8010256d:	53                   	push   %ebx
8010256e:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102571:	ff 35 d4 16 11 80    	push   0x801116d4
80102577:	ff 35 e4 16 11 80    	push   0x801116e4
8010257d:	e8 e8 db ff ff       	call   8010016a <bread>
80102582:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102584:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
8010258a:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	b8 00 00 00 00       	mov    $0x0,%eax
80102595:	eb 0c                	jmp    801025a3 <write_head+0x39>
    hb->block[i] = log.lh.block[i];
80102597:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
8010259e:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801025a2:	40                   	inc    %eax
801025a3:	39 c1                	cmp    %eax,%ecx
801025a5:	7f f0                	jg     80102597 <write_head+0x2d>
  }
  bwrite(buf);
801025a7:	83 ec 0c             	sub    $0xc,%esp
801025aa:	53                   	push   %ebx
801025ab:	e8 e8 db ff ff       	call   80100198 <bwrite>
  brelse(buf);
801025b0:	89 1c 24             	mov    %ebx,(%esp)
801025b3:	e8 1b dc ff ff       	call   801001d3 <brelse>
}
801025b8:	83 c4 10             	add    $0x10,%esp
801025bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025be:	c9                   	leave  
801025bf:	c3                   	ret    

801025c0 <recover_from_log>:

static void
recover_from_log(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 08             	sub    $0x8,%esp
  read_head();
801025c6:	e8 d1 fe ff ff       	call   8010249c <read_head>
  install_trans(); // if committed, copy from log to disk
801025cb:	e8 18 ff ff ff       	call   801024e8 <install_trans>
  log.lh.n = 0;
801025d0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801025d7:	00 00 00 
  write_head(); // clear the log
801025da:	e8 8b ff ff ff       	call   8010256a <write_head>
}
801025df:	c9                   	leave  
801025e0:	c3                   	ret    

801025e1 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801025e1:	55                   	push   %ebp
801025e2:	89 e5                	mov    %esp,%ebp
801025e4:	57                   	push   %edi
801025e5:	56                   	push   %esi
801025e6:	53                   	push   %ebx
801025e7:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801025ea:	be 00 00 00 00       	mov    $0x0,%esi
801025ef:	eb 62                	jmp    80102653 <write_log+0x72>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801025f1:	89 f0                	mov    %esi,%eax
801025f3:	03 05 d4 16 11 80    	add    0x801116d4,%eax
801025f9:	40                   	inc    %eax
801025fa:	83 ec 08             	sub    $0x8,%esp
801025fd:	50                   	push   %eax
801025fe:	ff 35 e4 16 11 80    	push   0x801116e4
80102604:	e8 61 db ff ff       	call   8010016a <bread>
80102609:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010260b:	83 c4 08             	add    $0x8,%esp
8010260e:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
80102615:	ff 35 e4 16 11 80    	push   0x801116e4
8010261b:	e8 4a db ff ff       	call   8010016a <bread>
80102620:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102622:	8d 50 5c             	lea    0x5c(%eax),%edx
80102625:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102628:	83 c4 0c             	add    $0xc,%esp
8010262b:	68 00 02 00 00       	push   $0x200
80102630:	52                   	push   %edx
80102631:	50                   	push   %eax
80102632:	e8 39 18 00 00       	call   80103e70 <memmove>
    bwrite(to);  // write the log
80102637:	89 1c 24             	mov    %ebx,(%esp)
8010263a:	e8 59 db ff ff       	call   80100198 <bwrite>
    brelse(from);
8010263f:	89 3c 24             	mov    %edi,(%esp)
80102642:	e8 8c db ff ff       	call   801001d3 <brelse>
    brelse(to);
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 84 db ff ff       	call   801001d3 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010264f:	46                   	inc    %esi
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102659:	7f 96                	jg     801025f1 <write_log+0x10>
  }
}
8010265b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010265e:	5b                   	pop    %ebx
8010265f:	5e                   	pop    %esi
80102660:	5f                   	pop    %edi
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    

80102663 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102663:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
8010266a:	7f 01                	jg     8010266d <commit+0xa>
8010266c:	c3                   	ret    
{
8010266d:	55                   	push   %ebp
8010266e:	89 e5                	mov    %esp,%ebp
80102670:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102673:	e8 69 ff ff ff       	call   801025e1 <write_log>
    write_head();    // Write header to disk -- the real commit
80102678:	e8 ed fe ff ff       	call   8010256a <write_head>
    install_trans(); // Now install writes to home locations
8010267d:	e8 66 fe ff ff       	call   801024e8 <install_trans>
    log.lh.n = 0;
80102682:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102689:	00 00 00 
    write_head();    // Erase the transaction from the log
8010268c:	e8 d9 fe ff ff       	call   8010256a <write_head>
  }
}
80102691:	c9                   	leave  
80102692:	c3                   	ret    

80102693 <initlog>:
{
80102693:	55                   	push   %ebp
80102694:	89 e5                	mov    %esp,%ebp
80102696:	53                   	push   %ebx
80102697:	83 ec 2c             	sub    $0x2c,%esp
8010269a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010269d:	68 20 70 10 80       	push   $0x80107020
801026a2:	68 a0 16 11 80       	push   $0x801116a0
801026a7:	e8 6b 15 00 00       	call   80103c17 <initlock>
  readsb(dev, &sb);
801026ac:	83 c4 08             	add    $0x8,%esp
801026af:	8d 45 dc             	lea    -0x24(%ebp),%eax
801026b2:	50                   	push   %eax
801026b3:	53                   	push   %ebx
801026b4:	e8 0e eb ff ff       	call   801011c7 <readsb>
  log.start = sb.logstart;
801026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801026bc:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
801026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801026c4:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
801026c9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
801026cf:	e8 ec fe ff ff       	call   801025c0 <recover_from_log>
}
801026d4:	83 c4 10             	add    $0x10,%esp
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
801026db:	c3                   	ret    

801026dc <begin_op>:
{
801026dc:	55                   	push   %ebp
801026dd:	89 e5                	mov    %esp,%ebp
801026df:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801026e2:	68 a0 16 11 80       	push   $0x801116a0
801026e7:	e8 62 16 00 00       	call   80103d4e <acquire>
801026ec:	83 c4 10             	add    $0x10,%esp
801026ef:	eb 15                	jmp    80102706 <begin_op+0x2a>
      sleep(&log, &log.lock);
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	68 a0 16 11 80       	push   $0x801116a0
801026f9:	68 a0 16 11 80       	push   $0x801116a0
801026fe:	e8 33 11 00 00       	call   80103836 <sleep>
80102703:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102706:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
8010270d:	75 e2                	jne    801026f1 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010270f:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102714:	8d 48 01             	lea    0x1(%eax),%ecx
80102717:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
8010271b:	8d 04 12             	lea    (%edx,%edx,1),%eax
8010271e:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102724:	83 f8 1e             	cmp    $0x1e,%eax
80102727:	7e 17                	jle    80102740 <begin_op+0x64>
      sleep(&log, &log.lock);
80102729:	83 ec 08             	sub    $0x8,%esp
8010272c:	68 a0 16 11 80       	push   $0x801116a0
80102731:	68 a0 16 11 80       	push   $0x801116a0
80102736:	e8 fb 10 00 00       	call   80103836 <sleep>
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	eb c6                	jmp    80102706 <begin_op+0x2a>
      log.outstanding += 1;
80102740:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 a0 16 11 80       	push   $0x801116a0
8010274e:	e8 60 16 00 00       	call   80103db3 <release>
}
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	c9                   	leave  
80102757:	c3                   	ret    

80102758 <end_op>:
{
80102758:	55                   	push   %ebp
80102759:	89 e5                	mov    %esp,%ebp
8010275b:	53                   	push   %ebx
8010275c:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010275f:	68 a0 16 11 80       	push   $0x801116a0
80102764:	e8 e5 15 00 00       	call   80103d4e <acquire>
  log.outstanding -= 1;
80102769:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010276e:	48                   	dec    %eax
8010276f:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
80102774:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
8010277a:	83 c4 10             	add    $0x10,%esp
8010277d:	85 db                	test   %ebx,%ebx
8010277f:	75 2c                	jne    801027ad <end_op+0x55>
  if(log.outstanding == 0){
80102781:	85 c0                	test   %eax,%eax
80102783:	75 35                	jne    801027ba <end_op+0x62>
    log.committing = 1;
80102785:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
8010278c:	00 00 00 
    do_commit = 1;
8010278f:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 a0 16 11 80       	push   $0x801116a0
8010279c:	e8 12 16 00 00       	call   80103db3 <release>
  if(do_commit){
801027a1:	83 c4 10             	add    $0x10,%esp
801027a4:	85 db                	test   %ebx,%ebx
801027a6:	75 24                	jne    801027cc <end_op+0x74>
}
801027a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ab:	c9                   	leave  
801027ac:	c3                   	ret    
    panic("log.committing");
801027ad:	83 ec 0c             	sub    $0xc,%esp
801027b0:	68 24 70 10 80       	push   $0x80107024
801027b5:	e8 87 db ff ff       	call   80100341 <panic>
    wakeup(&log);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 a0 16 11 80       	push   $0x801116a0
801027c2:	e8 e1 11 00 00       	call   801039a8 <wakeup>
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	eb c8                	jmp    80102794 <end_op+0x3c>
    commit();
801027cc:	e8 92 fe ff ff       	call   80102663 <commit>
    acquire(&log.lock);
801027d1:	83 ec 0c             	sub    $0xc,%esp
801027d4:	68 a0 16 11 80       	push   $0x801116a0
801027d9:	e8 70 15 00 00       	call   80103d4e <acquire>
    log.committing = 0;
801027de:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
801027e5:	00 00 00 
    wakeup(&log);
801027e8:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027ef:	e8 b4 11 00 00       	call   801039a8 <wakeup>
    release(&log.lock);
801027f4:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027fb:	e8 b3 15 00 00       	call   80103db3 <release>
80102800:	83 c4 10             	add    $0x10,%esp
}
80102803:	eb a3                	jmp    801027a8 <end_op+0x50>

80102805 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
80102808:	53                   	push   %ebx
80102809:	83 ec 04             	sub    $0x4,%esp
8010280c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010280f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102815:	83 fa 1d             	cmp    $0x1d,%edx
80102818:	7f 2a                	jg     80102844 <log_write+0x3f>
8010281a:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010281f:	48                   	dec    %eax
80102820:	39 c2                	cmp    %eax,%edx
80102822:	7d 20                	jge    80102844 <log_write+0x3f>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102824:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
8010282b:	7e 24                	jle    80102851 <log_write+0x4c>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010282d:	83 ec 0c             	sub    $0xc,%esp
80102830:	68 a0 16 11 80       	push   $0x801116a0
80102835:	e8 14 15 00 00       	call   80103d4e <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	b8 00 00 00 00       	mov    $0x0,%eax
80102842:	eb 1b                	jmp    8010285f <log_write+0x5a>
    panic("too big a transaction");
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 33 70 10 80       	push   $0x80107033
8010284c:	e8 f0 da ff ff       	call   80100341 <panic>
    panic("log_write outside of trans");
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 49 70 10 80       	push   $0x80107049
80102859:	e8 e3 da ff ff       	call   80100341 <panic>
  for (i = 0; i < log.lh.n; i++) {
8010285e:	40                   	inc    %eax
8010285f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102865:	39 c2                	cmp    %eax,%edx
80102867:	7e 0c                	jle    80102875 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102869:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010286c:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102873:	75 e9                	jne    8010285e <log_write+0x59>
      break;
  }
  log.lh.block[i] = b->blockno;
80102875:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102878:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
8010287f:	39 c2                	cmp    %eax,%edx
80102881:	74 18                	je     8010289b <log_write+0x96>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102883:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	68 a0 16 11 80       	push   $0x801116a0
8010288e:	e8 20 15 00 00       	call   80103db3 <release>
}
80102893:	83 c4 10             	add    $0x10,%esp
80102896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102899:	c9                   	leave  
8010289a:	c3                   	ret    
    log.lh.n++;
8010289b:	42                   	inc    %edx
8010289c:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801028a2:	eb df                	jmp    80102883 <log_write+0x7e>

801028a4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	53                   	push   %ebx
801028a8:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801028ab:	68 8e 00 00 00       	push   $0x8e
801028b0:	68 8c a4 10 80       	push   $0x8010a48c
801028b5:	68 00 70 00 80       	push   $0x80007000
801028ba:	e8 b1 15 00 00       	call   80103e70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801028bf:	83 c4 10             	add    $0x10,%esp
801028c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801028c7:	eb 06                	jmp    801028cf <startothers+0x2b>
801028c9:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801028cf:	8b 15 84 17 11 80    	mov    0x80111784,%edx
801028d5:	8d 04 92             	lea    (%edx,%edx,4),%eax
801028d8:	01 c0                	add    %eax,%eax
801028da:	01 d0                	add    %edx,%eax
801028dc:	c1 e0 04             	shl    $0x4,%eax
801028df:	05 a0 17 11 80       	add    $0x801117a0,%eax
801028e4:	39 d8                	cmp    %ebx,%eax
801028e6:	76 4c                	jbe    80102934 <startothers+0x90>
    if(c == mycpu())  // We've started already.
801028e8:	e8 98 09 00 00       	call   80103285 <mycpu>
801028ed:	39 c3                	cmp    %eax,%ebx
801028ef:	74 d8                	je     801028c9 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801028f1:	e8 31 f7 ff ff       	call   80102027 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801028f6:	05 00 10 00 00       	add    $0x1000,%eax
801028fb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102900:	c7 05 f8 6f 00 80 78 	movl   $0x80102978,0x80006ff8
80102907:	29 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010290a:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102911:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102914:	83 ec 08             	sub    $0x8,%esp
80102917:	68 00 70 00 00       	push   $0x7000
8010291c:	0f b6 03             	movzbl (%ebx),%eax
8010291f:	50                   	push   %eax
80102920:	e8 f6 f9 ff ff       	call   8010231b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102925:	83 c4 10             	add    $0x10,%esp
80102928:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010292e:	85 c0                	test   %eax,%eax
80102930:	74 f6                	je     80102928 <startothers+0x84>
80102932:	eb 95                	jmp    801028c9 <startothers+0x25>
      ;
  }
}
80102934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102937:	c9                   	leave  
80102938:	c3                   	ret    

80102939 <mpmain>:
{
80102939:	55                   	push   %ebp
8010293a:	89 e5                	mov    %esp,%ebp
8010293c:	53                   	push   %ebx
8010293d:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102940:	e8 a4 09 00 00       	call   801032e9 <cpuid>
80102945:	89 c3                	mov    %eax,%ebx
80102947:	e8 9d 09 00 00       	call   801032e9 <cpuid>
8010294c:	83 ec 04             	sub    $0x4,%esp
8010294f:	53                   	push   %ebx
80102950:	50                   	push   %eax
80102951:	68 64 70 10 80       	push   $0x80107064
80102956:	e8 7f dc ff ff       	call   801005da <cprintf>
  idtinit();       // load idt register
8010295b:	e8 a2 28 00 00       	call   80105202 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102960:	e8 20 09 00 00       	call   80103285 <mycpu>
80102965:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102967:	b8 01 00 00 00       	mov    $0x1,%eax
8010296c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102973:	e8 4e 0c 00 00       	call   801035c6 <scheduler>

80102978 <mpenter>:
{
80102978:	55                   	push   %ebp
80102979:	89 e5                	mov    %esp,%ebp
8010297b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010297e:	e8 4c 3b 00 00       	call   801064cf <switchkvm>
  seginit();
80102983:	e8 8a 37 00 00       	call   80106112 <seginit>
  lapicinit();
80102988:	e8 4a f8 ff ff       	call   801021d7 <lapicinit>
  mpmain();
8010298d:	e8 a7 ff ff ff       	call   80102939 <mpmain>

80102992 <main>:
{
80102992:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102996:	83 e4 f0             	and    $0xfffffff0,%esp
80102999:	ff 71 fc             	push   -0x4(%ecx)
8010299c:	55                   	push   %ebp
8010299d:	89 e5                	mov    %esp,%ebp
8010299f:	51                   	push   %ecx
801029a0:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801029a3:	68 00 00 40 80       	push   $0x80400000
801029a8:	68 30 58 11 80       	push   $0x80115830
801029ad:	e8 23 f6 ff ff       	call   80101fd5 <kinit1>
  kvmalloc();      // kernel page table
801029b2:	e8 eb 3f 00 00       	call   801069a2 <kvmalloc>
  mpinit();        // detect other processors
801029b7:	e8 b8 01 00 00       	call   80102b74 <mpinit>
  lapicinit();     // interrupt controller
801029bc:	e8 16 f8 ff ff       	call   801021d7 <lapicinit>
  seginit();       // segment descriptors
801029c1:	e8 4c 37 00 00       	call   80106112 <seginit>
  picinit();       // disable pic
801029c6:	e8 79 02 00 00       	call   80102c44 <picinit>
  ioapicinit();    // another interrupt controller
801029cb:	e8 93 f4 ff ff       	call   80101e63 <ioapicinit>
  consoleinit();   // console hardware
801029d0:	e8 77 de ff ff       	call   8010084c <consoleinit>
  uartinit();      // serial port
801029d5:	e8 21 2c 00 00       	call   801055fb <uartinit>
  pinit();         // process table
801029da:	e8 8c 08 00 00       	call   8010326b <pinit>
  tvinit();        // trap vectors
801029df:	e8 21 27 00 00       	call   80105105 <tvinit>
  binit();         // buffer cache
801029e4:	e8 09 d7 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
801029e9:	e8 de e1 ff ff       	call   80100bcc <fileinit>
  ideinit();       // disk 
801029ee:	e8 86 f2 ff ff       	call   80101c79 <ideinit>
  startothers();   // start other processors
801029f3:	e8 ac fe ff ff       	call   801028a4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801029f8:	83 c4 08             	add    $0x8,%esp
801029fb:	68 00 00 00 8e       	push   $0x8e000000
80102a00:	68 00 00 40 80       	push   $0x80400000
80102a05:	e8 fd f5 ff ff       	call   80102007 <kinit2>
  userinit();      // first user process
80102a0a:	e8 2e 09 00 00       	call   8010333d <userinit>
  mpmain();        // finish this processor's setup
80102a0f:	e8 25 ff ff ff       	call   80102939 <mpmain>

80102a14 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	56                   	push   %esi
80102a18:	53                   	push   %ebx
80102a19:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102a20:	b9 00 00 00 00       	mov    $0x0,%ecx
80102a25:	eb 07                	jmp    80102a2e <sum+0x1a>
    sum += addr[i];
80102a27:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102a2b:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102a2d:	41                   	inc    %ecx
80102a2e:	39 d1                	cmp    %edx,%ecx
80102a30:	7c f5                	jl     80102a27 <sum+0x13>
  return sum;
}
80102a32:	5b                   	pop    %ebx
80102a33:	5e                   	pop    %esi
80102a34:	5d                   	pop    %ebp
80102a35:	c3                   	ret    

80102a36 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102a36:	55                   	push   %ebp
80102a37:	89 e5                	mov    %esp,%ebp
80102a39:	56                   	push   %esi
80102a3a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102a3b:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102a41:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102a43:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102a45:	eb 03                	jmp    80102a4a <mpsearch1+0x14>
80102a47:	83 c3 10             	add    $0x10,%ebx
80102a4a:	39 f3                	cmp    %esi,%ebx
80102a4c:	73 29                	jae    80102a77 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102a4e:	83 ec 04             	sub    $0x4,%esp
80102a51:	6a 04                	push   $0x4
80102a53:	68 78 70 10 80       	push   $0x80107078
80102a58:	53                   	push   %ebx
80102a59:	e8 e3 13 00 00       	call   80103e41 <memcmp>
80102a5e:	83 c4 10             	add    $0x10,%esp
80102a61:	85 c0                	test   %eax,%eax
80102a63:	75 e2                	jne    80102a47 <mpsearch1+0x11>
80102a65:	ba 10 00 00 00       	mov    $0x10,%edx
80102a6a:	89 d8                	mov    %ebx,%eax
80102a6c:	e8 a3 ff ff ff       	call   80102a14 <sum>
80102a71:	84 c0                	test   %al,%al
80102a73:	75 d2                	jne    80102a47 <mpsearch1+0x11>
80102a75:	eb 05                	jmp    80102a7c <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102a77:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102a7c:	89 d8                	mov    %ebx,%eax
80102a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a81:	5b                   	pop    %ebx
80102a82:	5e                   	pop    %esi
80102a83:	5d                   	pop    %ebp
80102a84:	c3                   	ret    

80102a85 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
80102a88:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102a8b:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102a92:	c1 e0 08             	shl    $0x8,%eax
80102a95:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102a9c:	09 d0                	or     %edx,%eax
80102a9e:	c1 e0 04             	shl    $0x4,%eax
80102aa1:	74 1f                	je     80102ac2 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102aa3:	ba 00 04 00 00       	mov    $0x400,%edx
80102aa8:	e8 89 ff ff ff       	call   80102a36 <mpsearch1>
80102aad:	85 c0                	test   %eax,%eax
80102aaf:	75 0f                	jne    80102ac0 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102ab1:	ba 00 00 01 00       	mov    $0x10000,%edx
80102ab6:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102abb:	e8 76 ff ff ff       	call   80102a36 <mpsearch1>
}
80102ac0:	c9                   	leave  
80102ac1:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ac2:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ac9:	c1 e0 08             	shl    $0x8,%eax
80102acc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ad3:	09 d0                	or     %edx,%eax
80102ad5:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ad8:	2d 00 04 00 00       	sub    $0x400,%eax
80102add:	ba 00 04 00 00       	mov    $0x400,%edx
80102ae2:	e8 4f ff ff ff       	call   80102a36 <mpsearch1>
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	75 d5                	jne    80102ac0 <mpsearch+0x3b>
80102aeb:	eb c4                	jmp    80102ab1 <mpsearch+0x2c>

80102aed <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102aed:	55                   	push   %ebp
80102aee:	89 e5                	mov    %esp,%ebp
80102af0:	57                   	push   %edi
80102af1:	56                   	push   %esi
80102af2:	53                   	push   %ebx
80102af3:	83 ec 1c             	sub    $0x1c,%esp
80102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102af9:	e8 87 ff ff ff       	call   80102a85 <mpsearch>
80102afe:	89 c3                	mov    %eax,%ebx
80102b00:	85 c0                	test   %eax,%eax
80102b02:	74 53                	je     80102b57 <mpconfig+0x6a>
80102b04:	8b 70 04             	mov    0x4(%eax),%esi
80102b07:	85 f6                	test   %esi,%esi
80102b09:	74 50                	je     80102b5b <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102b0b:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102b11:	83 ec 04             	sub    $0x4,%esp
80102b14:	6a 04                	push   $0x4
80102b16:	68 7d 70 10 80       	push   $0x8010707d
80102b1b:	57                   	push   %edi
80102b1c:	e8 20 13 00 00       	call   80103e41 <memcmp>
80102b21:	83 c4 10             	add    $0x10,%esp
80102b24:	85 c0                	test   %eax,%eax
80102b26:	75 37                	jne    80102b5f <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102b28:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102b2e:	3c 01                	cmp    $0x1,%al
80102b30:	74 04                	je     80102b36 <mpconfig+0x49>
80102b32:	3c 04                	cmp    $0x4,%al
80102b34:	75 30                	jne    80102b66 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102b36:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102b3d:	89 f8                	mov    %edi,%eax
80102b3f:	e8 d0 fe ff ff       	call   80102a14 <sum>
80102b44:	84 c0                	test   %al,%al
80102b46:	75 25                	jne    80102b6d <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102b4b:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102b4d:	89 f8                	mov    %edi,%eax
80102b4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b52:	5b                   	pop    %ebx
80102b53:	5e                   	pop    %esi
80102b54:	5f                   	pop    %edi
80102b55:	5d                   	pop    %ebp
80102b56:	c3                   	ret    
    return 0;
80102b57:	89 c7                	mov    %eax,%edi
80102b59:	eb f2                	jmp    80102b4d <mpconfig+0x60>
80102b5b:	89 f7                	mov    %esi,%edi
80102b5d:	eb ee                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b5f:	bf 00 00 00 00       	mov    $0x0,%edi
80102b64:	eb e7                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b66:	bf 00 00 00 00       	mov    $0x0,%edi
80102b6b:	eb e0                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b6d:	bf 00 00 00 00       	mov    $0x0,%edi
80102b72:	eb d9                	jmp    80102b4d <mpconfig+0x60>

80102b74 <mpinit>:

void
mpinit(void)
{
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	57                   	push   %edi
80102b78:	56                   	push   %esi
80102b79:	53                   	push   %ebx
80102b7a:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102b7d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102b80:	e8 68 ff ff ff       	call   80102aed <mpconfig>
80102b85:	85 c0                	test   %eax,%eax
80102b87:	74 19                	je     80102ba2 <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102b89:	8b 50 24             	mov    0x24(%eax),%edx
80102b8c:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102b92:	8d 50 2c             	lea    0x2c(%eax),%edx
80102b95:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102b99:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102b9b:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ba0:	eb 20                	jmp    80102bc2 <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102ba2:	83 ec 0c             	sub    $0xc,%esp
80102ba5:	68 82 70 10 80       	push   $0x80107082
80102baa:	e8 92 d7 ff ff       	call   80100341 <panic>
    switch(*p){
80102baf:	bf 00 00 00 00       	mov    $0x0,%edi
80102bb4:	eb 0c                	jmp    80102bc2 <mpinit+0x4e>
80102bb6:	83 e8 03             	sub    $0x3,%eax
80102bb9:	3c 01                	cmp    $0x1,%al
80102bbb:	76 19                	jbe    80102bd6 <mpinit+0x62>
80102bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102bc2:	39 ca                	cmp    %ecx,%edx
80102bc4:	73 4a                	jae    80102c10 <mpinit+0x9c>
    switch(*p){
80102bc6:	8a 02                	mov    (%edx),%al
80102bc8:	3c 02                	cmp    $0x2,%al
80102bca:	74 37                	je     80102c03 <mpinit+0x8f>
80102bcc:	77 e8                	ja     80102bb6 <mpinit+0x42>
80102bce:	84 c0                	test   %al,%al
80102bd0:	74 09                	je     80102bdb <mpinit+0x67>
80102bd2:	3c 01                	cmp    $0x1,%al
80102bd4:	75 d9                	jne    80102baf <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102bd6:	83 c2 08             	add    $0x8,%edx
      continue;
80102bd9:	eb e7                	jmp    80102bc2 <mpinit+0x4e>
      if(ncpu < NCPU) {
80102bdb:	a1 84 17 11 80       	mov    0x80111784,%eax
80102be0:	83 f8 07             	cmp    $0x7,%eax
80102be3:	7f 19                	jg     80102bfe <mpinit+0x8a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102be5:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102be8:	01 f6                	add    %esi,%esi
80102bea:	01 c6                	add    %eax,%esi
80102bec:	c1 e6 04             	shl    $0x4,%esi
80102bef:	8a 5a 01             	mov    0x1(%edx),%bl
80102bf2:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102bf8:	40                   	inc    %eax
80102bf9:	a3 84 17 11 80       	mov    %eax,0x80111784
      p += sizeof(struct mpproc);
80102bfe:	83 c2 14             	add    $0x14,%edx
      continue;
80102c01:	eb bf                	jmp    80102bc2 <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102c03:	8a 42 01             	mov    0x1(%edx),%al
80102c06:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102c0b:	83 c2 08             	add    $0x8,%edx
      continue;
80102c0e:	eb b2                	jmp    80102bc2 <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102c10:	85 ff                	test   %edi,%edi
80102c12:	74 23                	je     80102c37 <mpinit+0xc3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c17:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102c1b:	74 12                	je     80102c2f <mpinit+0xbb>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1d:	b0 70                	mov    $0x70,%al
80102c1f:	ba 22 00 00 00       	mov    $0x22,%edx
80102c24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c25:	ba 23 00 00 00       	mov    $0x23,%edx
80102c2a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102c2b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2e:	ee                   	out    %al,(%dx)
  }
}
80102c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c32:	5b                   	pop    %ebx
80102c33:	5e                   	pop    %esi
80102c34:	5f                   	pop    %edi
80102c35:	5d                   	pop    %ebp
80102c36:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102c37:	83 ec 0c             	sub    $0xc,%esp
80102c3a:	68 9c 70 10 80       	push   $0x8010709c
80102c3f:	e8 fd d6 ff ff       	call   80100341 <panic>

80102c44 <picinit>:
80102c44:	b0 ff                	mov    $0xff,%al
80102c46:	ba 21 00 00 00       	mov    $0x21,%edx
80102c4b:	ee                   	out    %al,(%dx)
80102c4c:	ba a1 00 00 00       	mov    $0xa1,%edx
80102c51:	ee                   	out    %al,(%dx)
80102c52:	c3                   	ret    

80102c53 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102c53:	55                   	push   %ebp
80102c54:	89 e5                	mov    %esp,%ebp
80102c56:	57                   	push   %edi
80102c57:	56                   	push   %esi
80102c58:	53                   	push   %ebx
80102c59:	83 ec 0c             	sub    $0xc,%esp
80102c5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102c62:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102c6e:	e8 73 df ff ff       	call   80100be6 <filealloc>
80102c73:	89 03                	mov    %eax,(%ebx)
80102c75:	85 c0                	test   %eax,%eax
80102c77:	0f 84 88 00 00 00    	je     80102d05 <pipealloc+0xb2>
80102c7d:	e8 64 df ff ff       	call   80100be6 <filealloc>
80102c82:	89 06                	mov    %eax,(%esi)
80102c84:	85 c0                	test   %eax,%eax
80102c86:	74 7d                	je     80102d05 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102c88:	e8 9a f3 ff ff       	call   80102027 <kalloc>
80102c8d:	89 c7                	mov    %eax,%edi
80102c8f:	85 c0                	test   %eax,%eax
80102c91:	74 72                	je     80102d05 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102c93:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102c9a:	00 00 00 
  p->writeopen = 1;
80102c9d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102ca4:	00 00 00 
  p->nwrite = 0;
80102ca7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102cae:	00 00 00 
  p->nread = 0;
80102cb1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102cb8:	00 00 00 
  initlock(&p->lock, "pipe");
80102cbb:	83 ec 08             	sub    $0x8,%esp
80102cbe:	68 bb 70 10 80       	push   $0x801070bb
80102cc3:	50                   	push   %eax
80102cc4:	e8 4e 0f 00 00       	call   80103c17 <initlock>
  (*f0)->type = FD_PIPE;
80102cc9:	8b 03                	mov    (%ebx),%eax
80102ccb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102cd1:	8b 03                	mov    (%ebx),%eax
80102cd3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102cd7:	8b 03                	mov    (%ebx),%eax
80102cd9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102cdd:	8b 03                	mov    (%ebx),%eax
80102cdf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ce2:	8b 06                	mov    (%esi),%eax
80102ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102cea:	8b 06                	mov    (%esi),%eax
80102cec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102cf0:	8b 06                	mov    (%esi),%eax
80102cf2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102cf6:	8b 06                	mov    (%esi),%eax
80102cf8:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102cfb:	83 c4 10             	add    $0x10,%esp
80102cfe:	b8 00 00 00 00       	mov    $0x0,%eax
80102d03:	eb 29                	jmp    80102d2e <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d05:	8b 03                	mov    (%ebx),%eax
80102d07:	85 c0                	test   %eax,%eax
80102d09:	74 0c                	je     80102d17 <pipealloc+0xc4>
    fileclose(*f0);
80102d0b:	83 ec 0c             	sub    $0xc,%esp
80102d0e:	50                   	push   %eax
80102d0f:	e8 76 df ff ff       	call   80100c8a <fileclose>
80102d14:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102d17:	8b 06                	mov    (%esi),%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 19                	je     80102d36 <pipealloc+0xe3>
    fileclose(*f1);
80102d1d:	83 ec 0c             	sub    $0xc,%esp
80102d20:	50                   	push   %eax
80102d21:	e8 64 df ff ff       	call   80100c8a <fileclose>
80102d26:	83 c4 10             	add    $0x10,%esp
  return -1;
80102d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d31:	5b                   	pop    %ebx
80102d32:	5e                   	pop    %esi
80102d33:	5f                   	pop    %edi
80102d34:	5d                   	pop    %ebp
80102d35:	c3                   	ret    
  return -1;
80102d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d3b:	eb f1                	jmp    80102d2e <pipealloc+0xdb>

80102d3d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102d3d:	55                   	push   %ebp
80102d3e:	89 e5                	mov    %esp,%ebp
80102d40:	53                   	push   %ebx
80102d41:	83 ec 10             	sub    $0x10,%esp
80102d44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102d47:	53                   	push   %ebx
80102d48:	e8 01 10 00 00       	call   80103d4e <acquire>
  if(writable){
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102d54:	74 3f                	je     80102d95 <pipeclose+0x58>
    p->writeopen = 0;
80102d56:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102d5d:	00 00 00 
    wakeup(&p->nread);
80102d60:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	50                   	push   %eax
80102d6a:	e8 39 0c 00 00       	call   801039a8 <wakeup>
80102d6f:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102d72:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102d79:	75 09                	jne    80102d84 <pipeclose+0x47>
80102d7b:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102d82:	74 2f                	je     80102db3 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102d84:	83 ec 0c             	sub    $0xc,%esp
80102d87:	53                   	push   %ebx
80102d88:	e8 26 10 00 00       	call   80103db3 <release>
80102d8d:	83 c4 10             	add    $0x10,%esp
}
80102d90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d93:	c9                   	leave  
80102d94:	c3                   	ret    
    p->readopen = 0;
80102d95:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102d9c:	00 00 00 
    wakeup(&p->nwrite);
80102d9f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102da5:	83 ec 0c             	sub    $0xc,%esp
80102da8:	50                   	push   %eax
80102da9:	e8 fa 0b 00 00       	call   801039a8 <wakeup>
80102dae:	83 c4 10             	add    $0x10,%esp
80102db1:	eb bf                	jmp    80102d72 <pipeclose+0x35>
    release(&p->lock);
80102db3:	83 ec 0c             	sub    $0xc,%esp
80102db6:	53                   	push   %ebx
80102db7:	e8 f7 0f 00 00       	call   80103db3 <release>
    kfree((char*)p);
80102dbc:	89 1c 24             	mov    %ebx,(%esp)
80102dbf:	e8 4c f1 ff ff       	call   80101f10 <kfree>
80102dc4:	83 c4 10             	add    $0x10,%esp
80102dc7:	eb c7                	jmp    80102d90 <pipeclose+0x53>

80102dc9 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102dc9:	55                   	push   %ebp
80102dca:	89 e5                	mov    %esp,%ebp
80102dcc:	56                   	push   %esi
80102dcd:	53                   	push   %ebx
80102dce:	83 ec 1c             	sub    $0x1c,%esp
80102dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102dd4:	53                   	push   %ebx
80102dd5:	e8 74 0f 00 00       	call   80103d4e <acquire>
  for(i = 0; i < n; i++){
80102dda:	83 c4 10             	add    $0x10,%esp
80102ddd:	be 00 00 00 00       	mov    $0x0,%esi
80102de2:	3b 75 10             	cmp    0x10(%ebp),%esi
80102de5:	7c 41                	jl     80102e28 <pipewrite+0x5f>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102de7:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	50                   	push   %eax
80102df1:	e8 b2 0b 00 00       	call   801039a8 <wakeup>
  release(&p->lock);
80102df6:	89 1c 24             	mov    %ebx,(%esp)
80102df9:	e8 b5 0f 00 00       	call   80103db3 <release>
  return n;
80102dfe:	83 c4 10             	add    $0x10,%esp
80102e01:	8b 45 10             	mov    0x10(%ebp),%eax
80102e04:	eb 5c                	jmp    80102e62 <pipewrite+0x99>
      wakeup(&p->nread);
80102e06:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	50                   	push   %eax
80102e10:	e8 93 0b 00 00       	call   801039a8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e15:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e1b:	83 c4 08             	add    $0x8,%esp
80102e1e:	53                   	push   %ebx
80102e1f:	50                   	push   %eax
80102e20:	e8 11 0a 00 00       	call   80103836 <sleep>
80102e25:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102e28:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102e2e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102e34:	05 00 02 00 00       	add    $0x200,%eax
80102e39:	39 c2                	cmp    %eax,%edx
80102e3b:	75 2c                	jne    80102e69 <pipewrite+0xa0>
      if(p->readopen == 0 || myproc()->killed){
80102e3d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e44:	74 0b                	je     80102e51 <pipewrite+0x88>
80102e46:	e8 cf 04 00 00       	call   8010331a <myproc>
80102e4b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102e4f:	74 b5                	je     80102e06 <pipewrite+0x3d>
        release(&p->lock);
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	53                   	push   %ebx
80102e55:	e8 59 0f 00 00       	call   80103db3 <release>
        return -1;
80102e5a:	83 c4 10             	add    $0x10,%esp
80102e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e65:	5b                   	pop    %ebx
80102e66:	5e                   	pop    %esi
80102e67:	5d                   	pop    %ebp
80102e68:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102e69:	8d 42 01             	lea    0x1(%edx),%eax
80102e6c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102e72:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e7b:	8a 04 30             	mov    (%eax,%esi,1),%al
80102e7e:	88 45 f7             	mov    %al,-0x9(%ebp)
80102e81:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102e85:	46                   	inc    %esi
80102e86:	e9 57 ff ff ff       	jmp    80102de2 <pipewrite+0x19>

80102e8b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102e8b:	55                   	push   %ebp
80102e8c:	89 e5                	mov    %esp,%ebp
80102e8e:	57                   	push   %edi
80102e8f:	56                   	push   %esi
80102e90:	53                   	push   %ebx
80102e91:	83 ec 18             	sub    $0x18,%esp
80102e94:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e97:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80102e9a:	53                   	push   %ebx
80102e9b:	e8 ae 0e 00 00       	call   80103d4e <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	eb 13                	jmp    80102eb8 <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102ea5:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102eab:	83 ec 08             	sub    $0x8,%esp
80102eae:	53                   	push   %ebx
80102eaf:	50                   	push   %eax
80102eb0:	e8 81 09 00 00       	call   80103836 <sleep>
80102eb5:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102eb8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ebe:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ec4:	75 75                	jne    80102f3b <piperead+0xb0>
80102ec6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102ecc:	85 f6                	test   %esi,%esi
80102ece:	74 34                	je     80102f04 <piperead+0x79>
    if(myproc()->killed){
80102ed0:	e8 45 04 00 00       	call   8010331a <myproc>
80102ed5:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102ed9:	74 ca                	je     80102ea5 <piperead+0x1a>
      release(&p->lock);
80102edb:	83 ec 0c             	sub    $0xc,%esp
80102ede:	53                   	push   %ebx
80102edf:	e8 cf 0e 00 00       	call   80103db3 <release>
      return -1;
80102ee4:	83 c4 10             	add    $0x10,%esp
80102ee7:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102eec:	eb 43                	jmp    80102f31 <piperead+0xa6>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102eee:	8d 50 01             	lea    0x1(%eax),%edx
80102ef1:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102ef7:	25 ff 01 00 00       	and    $0x1ff,%eax
80102efc:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f00:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102f03:	46                   	inc    %esi
80102f04:	3b 75 10             	cmp    0x10(%ebp),%esi
80102f07:	7d 0e                	jge    80102f17 <piperead+0x8c>
    if(p->nread == p->nwrite)
80102f09:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f0f:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102f15:	75 d7                	jne    80102eee <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102f17:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	50                   	push   %eax
80102f21:	e8 82 0a 00 00       	call   801039a8 <wakeup>
  release(&p->lock);
80102f26:	89 1c 24             	mov    %ebx,(%esp)
80102f29:	e8 85 0e 00 00       	call   80103db3 <release>
  return i;
80102f2e:	83 c4 10             	add    $0x10,%esp
}
80102f31:	89 f0                	mov    %esi,%eax
80102f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f36:	5b                   	pop    %ebx
80102f37:	5e                   	pop    %esi
80102f38:	5f                   	pop    %edi
80102f39:	5d                   	pop    %ebp
80102f3a:	c3                   	ret    
80102f3b:	be 00 00 00 00       	mov    $0x0,%esi
80102f40:	eb c2                	jmp    80102f04 <piperead+0x79>

80102f42 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80102f42:	55                   	push   %ebp
80102f43:	89 e5                	mov    %esp,%ebp
80102f45:	53                   	push   %ebx
80102f46:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80102f49:	68 20 1d 11 80       	push   $0x80111d20
80102f4e:	e8 fb 0d 00 00       	call   80103d4e <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80102f5b:	eb 06                	jmp    80102f63 <allocproc+0x21>
80102f5d:	81 c3 88 00 00 00    	add    $0x88,%ebx
80102f63:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80102f69:	0f 83 80 00 00 00    	jae    80102fef <allocproc+0xad>
    if(p->state == UNUSED)
80102f6f:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80102f73:	75 e8                	jne    80102f5d <allocproc+0x1b>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80102f75:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80102f7c:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80102f81:	8d 50 01             	lea    0x1(%eax),%edx
80102f84:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80102f8a:	89 43 10             	mov    %eax,0x10(%ebx)
  p->prio = 5;
80102f8d:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
80102f94:	00 00 00 
  

  release(&ptable.lock);
80102f97:	83 ec 0c             	sub    $0xc,%esp
80102f9a:	68 20 1d 11 80       	push   $0x80111d20
80102f9f:	e8 0f 0e 00 00       	call   80103db3 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80102fa4:	e8 7e f0 ff ff       	call   80102027 <kalloc>
80102fa9:	89 43 08             	mov    %eax,0x8(%ebx)
80102fac:	83 c4 10             	add    $0x10,%esp
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	74 53                	je     80103006 <allocproc+0xc4>
  }
  
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80102fb3:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
80102fb9:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80102fbc:	c7 80 b0 0f 00 00 fa 	movl   $0x801050fa,0xfb0(%eax)
80102fc3:	50 10 80 

  sp -= sizeof *p->context;
80102fc6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80102fcb:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80102fce:	83 ec 04             	sub    $0x4,%esp
80102fd1:	6a 14                	push   $0x14
80102fd3:	6a 00                	push   $0x0
80102fd5:	50                   	push   %eax
80102fd6:	e8 1f 0e 00 00       	call   80103dfa <memset>
  p->context->eip = (uint)forkret;
80102fdb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80102fde:	c7 40 10 11 30 10 80 	movl   $0x80103011,0x10(%eax)

  return p;
80102fe5:	83 c4 10             	add    $0x10,%esp
}
80102fe8:	89 d8                	mov    %ebx,%eax
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fed:	c9                   	leave  
80102fee:	c3                   	ret    
  release(&ptable.lock);
80102fef:	83 ec 0c             	sub    $0xc,%esp
80102ff2:	68 20 1d 11 80       	push   $0x80111d20
80102ff7:	e8 b7 0d 00 00       	call   80103db3 <release>
  return 0;
80102ffc:	83 c4 10             	add    $0x10,%esp
80102fff:	bb 00 00 00 00       	mov    $0x0,%ebx
80103004:	eb e2                	jmp    80102fe8 <allocproc+0xa6>
    p->state = UNUSED;
80103006:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010300d:	89 c3                	mov    %eax,%ebx
8010300f:	eb d7                	jmp    80102fe8 <allocproc+0xa6>

80103011 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103011:	55                   	push   %ebp
80103012:	89 e5                	mov    %esp,%ebp
80103014:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103017:	68 20 1d 11 80       	push   $0x80111d20
8010301c:	e8 92 0d 00 00       	call   80103db3 <release>

  if (first) {
80103021:	83 c4 10             	add    $0x10,%esp
80103024:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010302b:	75 02                	jne    8010302f <forkret+0x1e>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010302d:	c9                   	leave  
8010302e:	c3                   	ret    
    first = 0;
8010302f:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103036:	00 00 00 
    iinit(ROOTDEV);
80103039:	83 ec 0c             	sub    $0xc,%esp
8010303c:	6a 01                	push   $0x1
8010303e:	e8 3b e2 ff ff       	call   8010127e <iinit>
    initlog(ROOTDEV);
80103043:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010304a:	e8 44 f6 ff ff       	call   80102693 <initlog>
8010304f:	83 c4 10             	add    $0x10,%esp
}
80103052:	eb d9                	jmp    8010302d <forkret+0x1c>

80103054 <insertProc>:
insertProc( struct proc *proc, unsigned int prio){
80103054:	55                   	push   %ebp
80103055:	89 e5                	mov    %esp,%ebp
80103057:	8b 45 08             	mov    0x8(%ebp),%eax
8010305a:	8b 55 0c             	mov    0xc(%ebp),%edx
	if(!prt->ultimo){
8010305d:	8b 0c d5 58 3f 11 80 	mov    -0x7feec0a8(,%edx,8),%ecx
80103064:	85 c9                	test   %ecx,%ecx
80103066:	74 1e                	je     80103086 <insertProc+0x32>
	   tmp->sigprio = proc;
80103068:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)
	   prt->ultimo = proc;
8010306e:	89 04 d5 58 3f 11 80 	mov    %eax,-0x7feec0a8(,%edx,8)
	   proc->sigprio = NULL;
80103075:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010307c:	00 00 00 
}
8010307f:	b8 01 00 00 00       	mov    $0x1,%eax
80103084:	5d                   	pop    %ebp
80103085:	c3                   	ret    
	   prt->primero = proc;
80103086:	81 c2 46 04 00 00    	add    $0x446,%edx
8010308c:	89 04 d5 24 1d 11 80 	mov    %eax,-0x7feee2dc(,%edx,8)
	   prt->ultimo = proc;
80103093:	89 04 d5 28 1d 11 80 	mov    %eax,-0x7feee2d8(,%edx,8)
	   proc->sigprio = NULL;
8010309a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801030a1:	00 00 00 
801030a4:	eb d9                	jmp    8010307f <insertProc+0x2b>

801030a6 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801030a6:	55                   	push   %ebp
801030a7:	89 e5                	mov    %esp,%ebp
801030a9:	56                   	push   %esi
801030aa:	53                   	push   %ebx
801030ab:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801030ad:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801030b2:	eb 06                	jmp    801030ba <wakeup1+0x14>
801030b4:	81 c3 88 00 00 00    	add    $0x88,%ebx
801030ba:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801030c0:	73 26                	jae    801030e8 <wakeup1+0x42>
    if(p->state == SLEEPING && p->chan == chan){
801030c2:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801030c6:	75 ec                	jne    801030b4 <wakeup1+0xe>
801030c8:	39 73 20             	cmp    %esi,0x20(%ebx)
801030cb:	75 e7                	jne    801030b4 <wakeup1+0xe>
      p->state = RUNNABLE;
801030cd:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      insertProc( p, p->prio);
801030d4:	83 ec 08             	sub    $0x8,%esp
801030d7:	ff b3 80 00 00 00    	push   0x80(%ebx)
801030dd:	53                   	push   %ebx
801030de:	e8 71 ff ff ff       	call   80103054 <insertProc>
801030e3:	83 c4 10             	add    $0x10,%esp
801030e6:	eb cc                	jmp    801030b4 <wakeup1+0xe>
    }
  }
     
}
801030e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030eb:	5b                   	pop    %ebx
801030ec:	5e                   	pop    %esi
801030ed:	5d                   	pop    %ebp
801030ee:	c3                   	ret    

801030ef <quitarProc>:
quitarProc(struct proc* proc, unsigned int prio){
801030ef:	55                   	push   %ebp
801030f0:	89 e5                	mov    %esp,%ebp
801030f2:	53                   	push   %ebx
801030f3:	8b 45 08             	mov    0x8(%ebp),%eax
801030f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	if(prt->primero != proc){
801030f9:	8b 14 cd 54 3f 11 80 	mov    -0x7feec0ac(,%ecx,8),%edx
80103100:	39 c2                	cmp    %eax,%edx
80103102:	74 0a                	je     8010310e <quitarProc+0x1f>
	   return 0;
80103104:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010310c:	c9                   	leave  
8010310d:	c3                   	ret    
	} else if(prt->primero){
8010310e:	85 d2                	test   %edx,%edx
80103110:	74 3f                	je     80103151 <quitarProc+0x62>
	   prt->primero = tmp2;
80103112:	8d 91 46 04 00 00    	lea    0x446(%ecx),%edx
80103118:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
8010311e:	89 1c d5 24 1d 11 80 	mov    %ebx,-0x7feee2dc(,%edx,8)
	   proc->sigprio = NULL;
80103125:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010312c:	00 00 00 
	   if(prt->ultimo == proc){
8010312f:	39 04 d5 28 1d 11 80 	cmp    %eax,-0x7feee2d8(,%edx,8)
80103136:	74 07                	je     8010313f <quitarProc+0x50>
	return 1;
80103138:	b8 01 00 00 00       	mov    $0x1,%eax
8010313d:	eb ca                	jmp    80103109 <quitarProc+0x1a>
	   	prt->ultimo = NULL;
8010313f:	c7 04 cd 58 3f 11 80 	movl   $0x0,-0x7feec0a8(,%ecx,8)
80103146:	00 00 00 00 
	return 1;
8010314a:	b8 01 00 00 00       	mov    $0x1,%eax
8010314f:	eb b8                	jmp    80103109 <quitarProc+0x1a>
80103151:	b8 01 00 00 00       	mov    $0x1,%eax
80103156:	eb b1                	jmp    80103109 <quitarProc+0x1a>

80103158 <getProcbyPID>:
getProcbyPID(int pid){
80103158:	55                   	push   %ebp
80103159:	89 e5                	mov    %esp,%ebp
8010315b:	56                   	push   %esi
8010315c:	53                   	push   %ebx
8010315d:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
80103160:	83 ec 0c             	sub    $0xc,%esp
80103163:	68 20 1d 11 80       	push   $0x80111d20
80103168:	e8 e1 0b 00 00       	call   80103d4e <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010316d:	83 c4 10             	add    $0x10,%esp
80103170:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103175:	eb 06                	jmp    8010317d <getProcbyPID+0x25>
80103177:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010317d:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103183:	73 28                	jae    801031ad <getProcbyPID+0x55>
      if (p->pid == pid) {
80103185:	39 73 10             	cmp    %esi,0x10(%ebx)
80103188:	75 ed                	jne    80103177 <getProcbyPID+0x1f>
          found = 1;
8010318a:	b8 01 00 00 00       	mov    $0x1,%eax
  if(found != 1){
8010318f:	83 f8 01             	cmp    $0x1,%eax
80103192:	75 20                	jne    801031b4 <getProcbyPID+0x5c>
  release(&ptable.lock);
80103194:	83 ec 0c             	sub    $0xc,%esp
80103197:	68 20 1d 11 80       	push   $0x80111d20
8010319c:	e8 12 0c 00 00       	call   80103db3 <release>
  return p;
801031a1:	83 c4 10             	add    $0x10,%esp
}
801031a4:	89 d8                	mov    %ebx,%eax
801031a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031a9:	5b                   	pop    %ebx
801031aa:	5e                   	pop    %esi
801031ab:	5d                   	pop    %ebp
801031ac:	c3                   	ret    
  int found = 0;
801031ad:	b8 00 00 00 00       	mov    $0x0,%eax
801031b2:	eb db                	jmp    8010318f <getProcbyPID+0x37>
  	return 0;
801031b4:	bb 00 00 00 00       	mov    $0x0,%ebx
801031b9:	eb e9                	jmp    801031a4 <getProcbyPID+0x4c>

801031bb <setNewPrio>:
setNewPrio(struct proc* p, unsigned int prio){
801031bb:	55                   	push   %ebp
801031bc:	89 e5                	mov    %esp,%ebp
801031be:	57                   	push   %edi
801031bf:	56                   	push   %esi
801031c0:	53                   	push   %ebx
801031c1:	83 ec 18             	sub    $0x18,%esp
801031c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct priotable* prt = &ptable.priotable[p->prio];
801031ca:	8b b3 80 00 00 00    	mov    0x80(%ebx),%esi
	acquire(&ptable.lock);
801031d0:	68 20 1d 11 80       	push   $0x80111d20
801031d5:	e8 74 0b 00 00       	call   80103d4e <acquire>
	if(prt->primero == p){
801031da:	83 c4 10             	add    $0x10,%esp
801031dd:	39 1c f5 54 3f 11 80 	cmp    %ebx,-0x7feec0ac(,%esi,8)
801031e4:	74 0f                	je     801031f5 <setNewPrio+0x3a>
	struct proc* anterior = prt->primero->sigprio;
801031e6:	8b 04 f5 54 3f 11 80 	mov    -0x7feec0ac(,%esi,8),%eax
801031ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
	while(actual != p){
801031f3:	eb 26                	jmp    8010321b <setNewPrio+0x60>
		quitarProc(p, p->prio);
801031f5:	83 ec 08             	sub    $0x8,%esp
801031f8:	ff b3 80 00 00 00    	push   0x80(%ebx)
801031fe:	53                   	push   %ebx
801031ff:	e8 eb fe ff ff       	call   801030ef <quitarProc>
		insertProc(p, prio);
80103204:	83 c4 08             	add    $0x8,%esp
80103207:	57                   	push   %edi
80103208:	53                   	push   %ebx
80103209:	e8 46 fe ff ff       	call   80103054 <insertProc>
8010320e:	83 c4 10             	add    $0x10,%esp
80103211:	eb d3                	jmp    801031e6 <setNewPrio+0x2b>
		anterior = actual;
80103213:	89 c2                	mov    %eax,%edx
		actual = actual->sigprio;
80103215:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
	while(actual != p){
8010321b:	39 d8                	cmp    %ebx,%eax
8010321d:	75 f4                	jne    80103213 <setNewPrio+0x58>
	anterior->sigprio = actual->sigprio;
8010321f:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103225:	89 8a 84 00 00 00    	mov    %ecx,0x84(%edx)
	if(anterior->sigprio == NULL){
8010322b:	85 c9                	test   %ecx,%ecx
8010322d:	74 33                	je     80103262 <setNewPrio+0xa7>
	actual->sigprio = NULL;
8010322f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80103236:	00 00 00 
	actual->prio = prio;
80103239:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
	insertProc(p, actual->prio);
8010323f:	83 ec 08             	sub    $0x8,%esp
80103242:	57                   	push   %edi
80103243:	53                   	push   %ebx
80103244:	e8 0b fe ff ff       	call   80103054 <insertProc>
	release(&ptable.lock);
80103249:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103250:	e8 5e 0b 00 00       	call   80103db3 <release>
}
80103255:	b8 00 00 00 00       	mov    $0x0,%eax
8010325a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
		prt->ultimo = anterior->sigprio;
80103262:	89 0c f5 58 3f 11 80 	mov    %ecx,-0x7feec0a8(,%esi,8)
80103269:	eb c4                	jmp    8010322f <setNewPrio+0x74>

8010326b <pinit>:
{
8010326b:	55                   	push   %ebp
8010326c:	89 e5                	mov    %esp,%ebp
8010326e:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103271:	68 c0 70 10 80       	push   $0x801070c0
80103276:	68 20 1d 11 80       	push   $0x80111d20
8010327b:	e8 97 09 00 00       	call   80103c17 <initlock>
}
80103280:	83 c4 10             	add    $0x10,%esp
80103283:	c9                   	leave  
80103284:	c3                   	ret    

80103285 <mycpu>:
{
80103285:	55                   	push   %ebp
80103286:	89 e5                	mov    %esp,%ebp
80103288:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010328b:	9c                   	pushf  
8010328c:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010328d:	f6 c4 02             	test   $0x2,%ah
80103290:	75 2c                	jne    801032be <mycpu+0x39>
  apicid = lapicid();
80103292:	e8 4c f0 ff ff       	call   801022e3 <lapicid>
80103297:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103299:	ba 00 00 00 00       	mov    $0x0,%edx
8010329e:	39 15 84 17 11 80    	cmp    %edx,0x80111784
801032a4:	7e 25                	jle    801032cb <mycpu+0x46>
    if (cpus[i].apicid == apicid)
801032a6:	8d 04 92             	lea    (%edx,%edx,4),%eax
801032a9:	01 c0                	add    %eax,%eax
801032ab:	01 d0                	add    %edx,%eax
801032ad:	c1 e0 04             	shl    $0x4,%eax
801032b0:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
801032b7:	39 c8                	cmp    %ecx,%eax
801032b9:	74 1d                	je     801032d8 <mycpu+0x53>
  for (i = 0; i < ncpu; ++i) {
801032bb:	42                   	inc    %edx
801032bc:	eb e0                	jmp    8010329e <mycpu+0x19>
    panic("mycpu called with interrupts enabled\n");
801032be:	83 ec 0c             	sub    $0xc,%esp
801032c1:	68 a4 71 10 80       	push   $0x801071a4
801032c6:	e8 76 d0 ff ff       	call   80100341 <panic>
  panic("unknown apicid\n");
801032cb:	83 ec 0c             	sub    $0xc,%esp
801032ce:	68 c7 70 10 80       	push   $0x801070c7
801032d3:	e8 69 d0 ff ff       	call   80100341 <panic>
      return &cpus[i];
801032d8:	8d 04 92             	lea    (%edx,%edx,4),%eax
801032db:	01 c0                	add    %eax,%eax
801032dd:	01 d0                	add    %edx,%eax
801032df:	c1 e0 04             	shl    $0x4,%eax
801032e2:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801032e7:	c9                   	leave  
801032e8:	c3                   	ret    

801032e9 <cpuid>:
cpuid() {
801032e9:	55                   	push   %ebp
801032ea:	89 e5                	mov    %esp,%ebp
801032ec:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801032ef:	e8 91 ff ff ff       	call   80103285 <mycpu>
801032f4:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801032f9:	c1 f8 04             	sar    $0x4,%eax
801032fc:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
801032ff:	89 ca                	mov    %ecx,%edx
80103301:	c1 e2 05             	shl    $0x5,%edx
80103304:	29 ca                	sub    %ecx,%edx
80103306:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103309:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010330c:	89 ca                	mov    %ecx,%edx
8010330e:	c1 e2 0f             	shl    $0xf,%edx
80103311:	29 ca                	sub    %ecx,%edx
80103313:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103316:	f7 d8                	neg    %eax
}
80103318:	c9                   	leave  
80103319:	c3                   	ret    

8010331a <myproc>:
myproc(void) {
8010331a:	55                   	push   %ebp
8010331b:	89 e5                	mov    %esp,%ebp
8010331d:	53                   	push   %ebx
8010331e:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103321:	e8 4e 09 00 00       	call   80103c74 <pushcli>
  c = mycpu();
80103326:	e8 5a ff ff ff       	call   80103285 <mycpu>
  p = c->proc;
8010332b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103331:	e8 79 09 00 00       	call   80103caf <popcli>
}
80103336:	89 d8                	mov    %ebx,%eax
80103338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010333b:	c9                   	leave  
8010333c:	c3                   	ret    

8010333d <userinit>:
{
8010333d:	55                   	push   %ebp
8010333e:	89 e5                	mov    %esp,%ebp
80103340:	53                   	push   %ebx
80103341:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103344:	e8 f9 fb ff ff       	call   80102f42 <allocproc>
80103349:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010334b:	a3 a4 3f 11 80       	mov    %eax,0x80113fa4
  if((p->pgdir = setupkvm()) == 0)
80103350:	e8 dd 35 00 00       	call   80106932 <setupkvm>
80103355:	89 43 04             	mov    %eax,0x4(%ebx)
80103358:	85 c0                	test   %eax,%eax
8010335a:	0f 84 cf 00 00 00    	je     8010342f <userinit+0xf2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103360:	83 ec 04             	sub    $0x4,%esp
80103363:	68 2c 00 00 00       	push   $0x2c
80103368:	68 60 a4 10 80       	push   $0x8010a460
8010336d:	50                   	push   %eax
8010336e:	e8 c6 32 00 00       	call   80106639 <inituvm>
  p->sz = PGSIZE;
80103373:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103379:	8b 43 18             	mov    0x18(%ebx),%eax
8010337c:	83 c4 0c             	add    $0xc,%esp
8010337f:	6a 4c                	push   $0x4c
80103381:	6a 00                	push   $0x0
80103383:	50                   	push   %eax
80103384:	e8 71 0a 00 00       	call   80103dfa <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103389:	8b 43 18             	mov    0x18(%ebx),%eax
8010338c:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103392:	8b 43 18             	mov    0x18(%ebx),%eax
80103395:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010339b:	8b 43 18             	mov    0x18(%ebx),%eax
8010339e:	8b 50 2c             	mov    0x2c(%eax),%edx
801033a1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033a5:	8b 43 18             	mov    0x18(%ebx),%eax
801033a8:	8b 50 2c             	mov    0x2c(%eax),%edx
801033ab:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033af:	8b 43 18             	mov    0x18(%ebx),%eax
801033b2:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033b9:	8b 43 18             	mov    0x18(%ebx),%eax
801033bc:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033c3:	8b 43 18             	mov    0x18(%ebx),%eax
801033c6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->prio = 5;
801033cd:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
801033d4:	00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033d7:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033da:	83 c4 0c             	add    $0xc,%esp
801033dd:	6a 10                	push   $0x10
801033df:	68 f0 70 10 80       	push   $0x801070f0
801033e4:	50                   	push   %eax
801033e5:	e8 68 0b 00 00       	call   80103f52 <safestrcpy>
  p->cwd = namei("/");
801033ea:	c7 04 24 f9 70 10 80 	movl   $0x801070f9,(%esp)
801033f1:	e8 74 e7 ff ff       	call   80101b6a <namei>
801033f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033f9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103400:	e8 49 09 00 00       	call   80103d4e <acquire>
  p->state = RUNNABLE;
80103405:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  insertProc( p, p->prio);
8010340c:	83 c4 08             	add    $0x8,%esp
8010340f:	ff b3 80 00 00 00    	push   0x80(%ebx)
80103415:	53                   	push   %ebx
80103416:	e8 39 fc ff ff       	call   80103054 <insertProc>
  release(&ptable.lock);
8010341b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103422:	e8 8c 09 00 00       	call   80103db3 <release>
}
80103427:	83 c4 10             	add    $0x10,%esp
8010342a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010342d:	c9                   	leave  
8010342e:	c3                   	ret    
    panic("userinit: out of memory?");
8010342f:	83 ec 0c             	sub    $0xc,%esp
80103432:	68 d7 70 10 80       	push   $0x801070d7
80103437:	e8 05 cf ff ff       	call   80100341 <panic>

8010343c <growproc>:
{
8010343c:	55                   	push   %ebp
8010343d:	89 e5                	mov    %esp,%ebp
8010343f:	56                   	push   %esi
80103440:	53                   	push   %ebx
80103441:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103444:	e8 d1 fe ff ff       	call   8010331a <myproc>
80103449:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
8010344b:	8b 00                	mov    (%eax),%eax
  if(n > 0){
8010344d:	85 f6                	test   %esi,%esi
8010344f:	7f 1b                	jg     8010346c <growproc+0x30>
  } else if(n < 0){
80103451:	78 36                	js     80103489 <growproc+0x4d>
  curproc->sz = sz;
80103453:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
80103455:	8b 43 04             	mov    0x4(%ebx),%eax
80103458:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010345d:	0f 22 d8             	mov    %eax,%cr3
  return 0;
80103460:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103465:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5d                   	pop    %ebp
8010346b:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010346c:	83 ec 04             	sub    $0x4,%esp
8010346f:	01 c6                	add    %eax,%esi
80103471:	56                   	push   %esi
80103472:	50                   	push   %eax
80103473:	ff 73 04             	push   0x4(%ebx)
80103476:	e8 54 33 00 00       	call   801067cf <allocuvm>
8010347b:	83 c4 10             	add    $0x10,%esp
8010347e:	85 c0                	test   %eax,%eax
80103480:	75 d1                	jne    80103453 <growproc+0x17>
      return -1;
80103482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103487:	eb dc                	jmp    80103465 <growproc+0x29>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103489:	83 ec 04             	sub    $0x4,%esp
8010348c:	01 c6                	add    %eax,%esi
8010348e:	56                   	push   %esi
8010348f:	50                   	push   %eax
80103490:	ff 73 04             	push   0x4(%ebx)
80103493:	e8 a7 32 00 00       	call   8010673f <deallocuvm>
80103498:	83 c4 10             	add    $0x10,%esp
8010349b:	85 c0                	test   %eax,%eax
8010349d:	75 b4                	jne    80103453 <growproc+0x17>
      return -1;
8010349f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a4:	eb bf                	jmp    80103465 <growproc+0x29>

801034a6 <fork>:
{
801034a6:	55                   	push   %ebp
801034a7:	89 e5                	mov    %esp,%ebp
801034a9:	57                   	push   %edi
801034aa:	56                   	push   %esi
801034ab:	53                   	push   %ebx
801034ac:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034af:	e8 66 fe ff ff       	call   8010331a <myproc>
801034b4:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034b6:	e8 87 fa ff ff       	call   80102f42 <allocproc>
801034bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034be:	85 c0                	test   %eax,%eax
801034c0:	0f 84 f9 00 00 00    	je     801035bf <fork+0x119>
801034c6:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034c8:	83 ec 08             	sub    $0x8,%esp
801034cb:	ff 33                	push   (%ebx)
801034cd:	ff 73 04             	push   0x4(%ebx)
801034d0:	e8 10 35 00 00       	call   801069e5 <copyuvm>
801034d5:	89 47 04             	mov    %eax,0x4(%edi)
801034d8:	83 c4 10             	add    $0x10,%esp
801034db:	85 c0                	test   %eax,%eax
801034dd:	74 36                	je     80103515 <fork+0x6f>
  np->sz = curproc->sz;
801034df:	8b 03                	mov    (%ebx),%eax
801034e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034e4:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801034e6:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->prio = curproc->prio;
801034e9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801034ef:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  *np->tf = *curproc->tf;
801034f5:	8b 73 18             	mov    0x18(%ebx),%esi
801034f8:	89 c8                	mov    %ecx,%eax
801034fa:	8b 79 18             	mov    0x18(%ecx),%edi
801034fd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103502:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103504:	8b 40 18             	mov    0x18(%eax),%eax
80103507:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010350e:	be 00 00 00 00       	mov    $0x0,%esi
80103513:	eb 27                	jmp    8010353c <fork+0x96>
    kfree(np->kstack);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010351b:	ff 73 08             	push   0x8(%ebx)
8010351e:	e8 ed e9 ff ff       	call   80101f10 <kfree>
    np->kstack = 0;
80103523:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010352a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103531:	83 c4 10             	add    $0x10,%esp
80103534:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103539:	eb 7a                	jmp    801035b5 <fork+0x10f>
  for(i = 0; i < NOFILE; i++)
8010353b:	46                   	inc    %esi
8010353c:	83 fe 0f             	cmp    $0xf,%esi
8010353f:	7f 1d                	jg     8010355e <fork+0xb8>
    if(curproc->ofile[i])
80103541:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103545:	85 c0                	test   %eax,%eax
80103547:	74 f2                	je     8010353b <fork+0x95>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103549:	83 ec 0c             	sub    $0xc,%esp
8010354c:	50                   	push   %eax
8010354d:	e8 f5 d6 ff ff       	call   80100c47 <filedup>
80103552:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103555:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103559:	83 c4 10             	add    $0x10,%esp
8010355c:	eb dd                	jmp    8010353b <fork+0x95>
  np->cwd = idup(curproc->cwd);
8010355e:	83 ec 0c             	sub    $0xc,%esp
80103561:	ff 73 68             	push   0x68(%ebx)
80103564:	e8 6f df ff ff       	call   801014d8 <idup>
80103569:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010356c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010356f:	83 c3 6c             	add    $0x6c,%ebx
80103572:	8d 47 6c             	lea    0x6c(%edi),%eax
80103575:	83 c4 0c             	add    $0xc,%esp
80103578:	6a 10                	push   $0x10
8010357a:	53                   	push   %ebx
8010357b:	50                   	push   %eax
8010357c:	e8 d1 09 00 00       	call   80103f52 <safestrcpy>
  pid = np->pid;
80103581:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103584:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010358b:	e8 be 07 00 00       	call   80103d4e <acquire>
  np->state = RUNNABLE;
80103590:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  insertProc( np, np->prio);
80103597:	83 c4 08             	add    $0x8,%esp
8010359a:	ff b7 80 00 00 00    	push   0x80(%edi)
801035a0:	57                   	push   %edi
801035a1:	e8 ae fa ff ff       	call   80103054 <insertProc>
  release(&ptable.lock);
801035a6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801035ad:	e8 01 08 00 00       	call   80103db3 <release>
  return pid;
801035b2:	83 c4 10             	add    $0x10,%esp
}
801035b5:	89 d8                	mov    %ebx,%eax
801035b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ba:	5b                   	pop    %ebx
801035bb:	5e                   	pop    %esi
801035bc:	5f                   	pop    %edi
801035bd:	5d                   	pop    %ebp
801035be:	c3                   	ret    
    return -1;
801035bf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035c4:	eb ef                	jmp    801035b5 <fork+0x10f>

801035c6 <scheduler>:
{
801035c6:	55                   	push   %ebp
801035c7:	89 e5                	mov    %esp,%ebp
801035c9:	56                   	push   %esi
801035ca:	53                   	push   %ebx
  struct cpu *c = mycpu();
801035cb:	e8 b5 fc ff ff       	call   80103285 <mycpu>
801035d0:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801035d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801035d9:	00 00 00 
801035dc:	eb 6c                	jmp    8010364a <scheduler+0x84>
    for(pi = ptable.priotable; pi < &ptable.priotable[10]; pi++){
801035de:	83 c0 08             	add    $0x8,%eax
801035e1:	3d a4 3f 11 80       	cmp    $0x80113fa4,%eax
801035e6:	73 52                	jae    8010363a <scheduler+0x74>
      if(!pi->primero)
801035e8:	8b 18                	mov    (%eax),%ebx
801035ea:	85 db                	test   %ebx,%ebx
801035ec:	74 f0                	je     801035de <scheduler+0x18>
      if(p->state != RUNNABLE) continue;
801035ee:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035f2:	75 ea                	jne    801035de <scheduler+0x18>
      c->proc = p;
801035f4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801035fa:	83 ec 0c             	sub    $0xc,%esp
801035fd:	53                   	push   %ebx
801035fe:	e8 da 2e 00 00       	call   801064dd <switchuvm>
      p->state = RUNNING;
80103603:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      quitarProc(p, p->prio);
8010360a:	83 c4 08             	add    $0x8,%esp
8010360d:	ff b3 80 00 00 00    	push   0x80(%ebx)
80103613:	53                   	push   %ebx
80103614:	e8 d6 fa ff ff       	call   801030ef <quitarProc>
      swtch(&(c->scheduler), p->context);
80103619:	83 c4 08             	add    $0x8,%esp
8010361c:	ff 73 1c             	push   0x1c(%ebx)
8010361f:	8d 46 04             	lea    0x4(%esi),%eax
80103622:	50                   	push   %eax
80103623:	e8 78 09 00 00       	call   80103fa0 <swtch>
      switchkvm();
80103628:	e8 a2 2e 00 00       	call   801064cf <switchkvm>
      c->proc = 0;
8010362d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103634:	00 00 00 
      break;
80103637:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	68 20 1d 11 80       	push   $0x80111d20
80103642:	e8 6c 07 00 00       	call   80103db3 <release>
    sti();
80103647:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010364a:	fb                   	sti    
    acquire(&ptable.lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	68 20 1d 11 80       	push   $0x80111d20
80103653:	e8 f6 06 00 00       	call   80103d4e <acquire>
    for(pi = ptable.priotable; pi < &ptable.priotable[10]; pi++){
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	b8 54 3f 11 80       	mov    $0x80113f54,%eax
80103660:	e9 7c ff ff ff       	jmp    801035e1 <scheduler+0x1b>

80103665 <sched>:
{
80103665:	55                   	push   %ebp
80103666:	89 e5                	mov    %esp,%ebp
80103668:	56                   	push   %esi
80103669:	53                   	push   %ebx
  struct proc *p = myproc();
8010366a:	e8 ab fc ff ff       	call   8010331a <myproc>
8010366f:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103671:	83 ec 0c             	sub    $0xc,%esp
80103674:	68 20 1d 11 80       	push   $0x80111d20
80103679:	e8 91 06 00 00       	call   80103d0f <holding>
8010367e:	83 c4 10             	add    $0x10,%esp
80103681:	85 c0                	test   %eax,%eax
80103683:	74 4f                	je     801036d4 <sched+0x6f>
  if(mycpu()->ncli != 1)
80103685:	e8 fb fb ff ff       	call   80103285 <mycpu>
8010368a:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103691:	75 4e                	jne    801036e1 <sched+0x7c>
  if(p->state == RUNNING)
80103693:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103697:	74 55                	je     801036ee <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103699:	9c                   	pushf  
8010369a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010369b:	f6 c4 02             	test   $0x2,%ah
8010369e:	75 5b                	jne    801036fb <sched+0x96>
  intena = mycpu()->intena;
801036a0:	e8 e0 fb ff ff       	call   80103285 <mycpu>
801036a5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036ab:	e8 d5 fb ff ff       	call   80103285 <mycpu>
801036b0:	83 ec 08             	sub    $0x8,%esp
801036b3:	ff 70 04             	push   0x4(%eax)
801036b6:	83 c3 1c             	add    $0x1c,%ebx
801036b9:	53                   	push   %ebx
801036ba:	e8 e1 08 00 00       	call   80103fa0 <swtch>
  mycpu()->intena = intena;
801036bf:	e8 c1 fb ff ff       	call   80103285 <mycpu>
801036c4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d0:	5b                   	pop    %ebx
801036d1:	5e                   	pop    %esi
801036d2:	5d                   	pop    %ebp
801036d3:	c3                   	ret    
    panic("sched ptable.lock");
801036d4:	83 ec 0c             	sub    $0xc,%esp
801036d7:	68 fb 70 10 80       	push   $0x801070fb
801036dc:	e8 60 cc ff ff       	call   80100341 <panic>
    panic("sched locks");
801036e1:	83 ec 0c             	sub    $0xc,%esp
801036e4:	68 0d 71 10 80       	push   $0x8010710d
801036e9:	e8 53 cc ff ff       	call   80100341 <panic>
    panic("sched running");
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	68 19 71 10 80       	push   $0x80107119
801036f6:	e8 46 cc ff ff       	call   80100341 <panic>
    panic("sched interruptible");
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	68 27 71 10 80       	push   $0x80107127
80103703:	e8 39 cc ff ff       	call   80100341 <panic>

80103708 <exit>:
{
80103708:	55                   	push   %ebp
80103709:	89 e5                	mov    %esp,%ebp
8010370b:	56                   	push   %esi
8010370c:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010370d:	e8 08 fc ff ff       	call   8010331a <myproc>
80103712:	89 c6                	mov    %eax,%esi
  curproc->status = status;
80103714:	8b 45 08             	mov    0x8(%ebp),%eax
80103717:	89 46 7c             	mov    %eax,0x7c(%esi)
  if(curproc == initproc)
8010371a:	39 35 a4 3f 11 80    	cmp    %esi,0x80113fa4
80103720:	74 07                	je     80103729 <exit+0x21>
  for(fd = 0; fd < NOFILE; fd++){
80103722:	bb 00 00 00 00       	mov    $0x0,%ebx
80103727:	eb 22                	jmp    8010374b <exit+0x43>
    panic("init exiting");
80103729:	83 ec 0c             	sub    $0xc,%esp
8010372c:	68 3b 71 10 80       	push   $0x8010713b
80103731:	e8 0b cc ff ff       	call   80100341 <panic>
      fileclose(curproc->ofile[fd]);
80103736:	83 ec 0c             	sub    $0xc,%esp
80103739:	50                   	push   %eax
8010373a:	e8 4b d5 ff ff       	call   80100c8a <fileclose>
      curproc->ofile[fd] = 0;
8010373f:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103746:	00 
80103747:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
8010374a:	43                   	inc    %ebx
8010374b:	83 fb 0f             	cmp    $0xf,%ebx
8010374e:	7f 0a                	jg     8010375a <exit+0x52>
    if(curproc->ofile[fd]){
80103750:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103754:	85 c0                	test   %eax,%eax
80103756:	75 de                	jne    80103736 <exit+0x2e>
80103758:	eb f0                	jmp    8010374a <exit+0x42>
  begin_op();
8010375a:	e8 7d ef ff ff       	call   801026dc <begin_op>
  iput(curproc->cwd);
8010375f:	83 ec 0c             	sub    $0xc,%esp
80103762:	ff 76 68             	push   0x68(%esi)
80103765:	e8 a1 de ff ff       	call   8010160b <iput>
  end_op();
8010376a:	e8 e9 ef ff ff       	call   80102758 <end_op>
  curproc->cwd = 0;
8010376f:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103776:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010377d:	e8 cc 05 00 00       	call   80103d4e <acquire>
  wakeup1(curproc->parent);
80103782:	8b 46 14             	mov    0x14(%esi),%eax
80103785:	e8 1c f9 ff ff       	call   801030a6 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010378a:	83 c4 10             	add    $0x10,%esp
8010378d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103792:	eb 06                	jmp    8010379a <exit+0x92>
80103794:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010379a:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801037a0:	73 1a                	jae    801037bc <exit+0xb4>
    if(p->parent == curproc){
801037a2:	39 73 14             	cmp    %esi,0x14(%ebx)
801037a5:	75 ed                	jne    80103794 <exit+0x8c>
      p->parent = initproc;
801037a7:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
801037ac:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801037af:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037b3:	75 df                	jne    80103794 <exit+0x8c>
        wakeup1(initproc);
801037b5:	e8 ec f8 ff ff       	call   801030a6 <wakeup1>
801037ba:	eb d8                	jmp    80103794 <exit+0x8c>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801037bc:	83 ec 04             	sub    $0x4,%esp
801037bf:	6a 00                	push   $0x0
801037c1:	68 00 00 00 80       	push   $0x80000000
801037c6:	ff 76 04             	push   0x4(%esi)
801037c9:	e8 71 2f 00 00       	call   8010673f <deallocuvm>
  curproc->state = ZOMBIE;
801037ce:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037d5:	e8 8b fe ff ff       	call   80103665 <sched>
  panic("zombie exit");
801037da:	c7 04 24 48 71 10 80 	movl   $0x80107148,(%esp)
801037e1:	e8 5b cb ff ff       	call   80100341 <panic>

801037e6 <yield>:
{
801037e6:	55                   	push   %ebp
801037e7:	89 e5                	mov    %esp,%ebp
801037e9:	53                   	push   %ebx
801037ea:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037ed:	68 20 1d 11 80       	push   $0x80111d20
801037f2:	e8 57 05 00 00       	call   80103d4e <acquire>
  myproc()->state = RUNNABLE;
801037f7:	e8 1e fb ff ff       	call   8010331a <myproc>
801037fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insertProc( myproc(), myproc()->prio);
80103803:	e8 12 fb ff ff       	call   8010331a <myproc>
80103808:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
8010380e:	e8 07 fb ff ff       	call   8010331a <myproc>
80103813:	83 c4 08             	add    $0x8,%esp
80103816:	53                   	push   %ebx
80103817:	50                   	push   %eax
80103818:	e8 37 f8 ff ff       	call   80103054 <insertProc>
  sched();
8010381d:	e8 43 fe ff ff       	call   80103665 <sched>
  release(&ptable.lock);
80103822:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103829:	e8 85 05 00 00       	call   80103db3 <release>
}
8010382e:	83 c4 10             	add    $0x10,%esp
80103831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103834:	c9                   	leave  
80103835:	c3                   	ret    

80103836 <sleep>:
{
80103836:	55                   	push   %ebp
80103837:	89 e5                	mov    %esp,%ebp
80103839:	56                   	push   %esi
8010383a:	53                   	push   %ebx
8010383b:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
8010383e:	e8 d7 fa ff ff       	call   8010331a <myproc>
  if(p == 0)
80103843:	85 c0                	test   %eax,%eax
80103845:	74 66                	je     801038ad <sleep+0x77>
80103847:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103849:	85 f6                	test   %esi,%esi
8010384b:	74 6d                	je     801038ba <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010384d:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103853:	74 18                	je     8010386d <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103855:	83 ec 0c             	sub    $0xc,%esp
80103858:	68 20 1d 11 80       	push   $0x80111d20
8010385d:	e8 ec 04 00 00       	call   80103d4e <acquire>
    release(lk);
80103862:	89 34 24             	mov    %esi,(%esp)
80103865:	e8 49 05 00 00       	call   80103db3 <release>
8010386a:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
8010386d:	8b 45 08             	mov    0x8(%ebp),%eax
80103870:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103873:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010387a:	e8 e6 fd ff ff       	call   80103665 <sched>
  p->chan = 0;
8010387f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103886:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
8010388c:	74 18                	je     801038a6 <sleep+0x70>
    release(&ptable.lock);
8010388e:	83 ec 0c             	sub    $0xc,%esp
80103891:	68 20 1d 11 80       	push   $0x80111d20
80103896:	e8 18 05 00 00       	call   80103db3 <release>
    acquire(lk);
8010389b:	89 34 24             	mov    %esi,(%esp)
8010389e:	e8 ab 04 00 00       	call   80103d4e <acquire>
801038a3:	83 c4 10             	add    $0x10,%esp
}
801038a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5d                   	pop    %ebp
801038ac:	c3                   	ret    
    panic("sleep");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 54 71 10 80       	push   $0x80107154
801038b5:	e8 87 ca ff ff       	call   80100341 <panic>
    panic("sleep without lk");
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	68 5a 71 10 80       	push   $0x8010715a
801038c2:	e8 7a ca ff ff       	call   80100341 <panic>

801038c7 <wait>:
{
801038c7:	55                   	push   %ebp
801038c8:	89 e5                	mov    %esp,%ebp
801038ca:	56                   	push   %esi
801038cb:	53                   	push   %ebx
  struct proc *curproc = myproc();
801038cc:	e8 49 fa ff ff       	call   8010331a <myproc>
801038d1:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038d3:	83 ec 0c             	sub    $0xc,%esp
801038d6:	68 20 1d 11 80       	push   $0x80111d20
801038db:	e8 6e 04 00 00       	call   80103d4e <acquire>
801038e0:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801038e3:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e8:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801038ed:	eb 68                	jmp    80103957 <wait+0x90>
        pid = p->pid;
801038ef:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	ff 73 08             	push   0x8(%ebx)
801038f8:	e8 13 e6 ff ff       	call   80101f10 <kfree>
        *status = p->status;
801038fd:	8b 53 7c             	mov    0x7c(%ebx),%edx
80103900:	8b 45 08             	mov    0x8(%ebp),%eax
80103903:	89 10                	mov    %edx,(%eax)
        p->kstack = 0;
80103905:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
8010390c:	83 c4 08             	add    $0x8,%esp
8010390f:	6a 00                	push   $0x0
80103911:	ff 73 04             	push   0x4(%ebx)
80103914:	e8 a3 2f 00 00       	call   801068bc <freevm>
        p->pid = 0;
80103919:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103920:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103927:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010392b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103932:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103939:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103940:	e8 6e 04 00 00       	call   80103db3 <release>
        return pid;
80103945:	83 c4 10             	add    $0x10,%esp
}
80103948:	89 f0                	mov    %esi,%eax
8010394a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010394d:	5b                   	pop    %ebx
8010394e:	5e                   	pop    %esi
8010394f:	5d                   	pop    %ebp
80103950:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103951:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103957:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
8010395d:	73 12                	jae    80103971 <wait+0xaa>
      if(p->parent != curproc)
8010395f:	39 73 14             	cmp    %esi,0x14(%ebx)
80103962:	75 ed                	jne    80103951 <wait+0x8a>
      if(p->state == ZOMBIE){
80103964:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103968:	74 85                	je     801038ef <wait+0x28>
      havekids = 1;
8010396a:	b8 01 00 00 00       	mov    $0x1,%eax
8010396f:	eb e0                	jmp    80103951 <wait+0x8a>
    if(!havekids || curproc->killed){
80103971:	85 c0                	test   %eax,%eax
80103973:	74 06                	je     8010397b <wait+0xb4>
80103975:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103979:	74 17                	je     80103992 <wait+0xcb>
      release(&ptable.lock);
8010397b:	83 ec 0c             	sub    $0xc,%esp
8010397e:	68 20 1d 11 80       	push   $0x80111d20
80103983:	e8 2b 04 00 00       	call   80103db3 <release>
      return -1;
80103988:	83 c4 10             	add    $0x10,%esp
8010398b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103990:	eb b6                	jmp    80103948 <wait+0x81>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103992:	83 ec 08             	sub    $0x8,%esp
80103995:	68 20 1d 11 80       	push   $0x80111d20
8010399a:	56                   	push   %esi
8010399b:	e8 96 fe ff ff       	call   80103836 <sleep>
    havekids = 0;
801039a0:	83 c4 10             	add    $0x10,%esp
801039a3:	e9 3b ff ff ff       	jmp    801038e3 <wait+0x1c>

801039a8 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801039a8:	55                   	push   %ebp
801039a9:	89 e5                	mov    %esp,%ebp
801039ab:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801039ae:	68 20 1d 11 80       	push   $0x80111d20
801039b3:	e8 96 03 00 00       	call   80103d4e <acquire>
  wakeup1(chan);
801039b8:	8b 45 08             	mov    0x8(%ebp),%eax
801039bb:	e8 e6 f6 ff ff       	call   801030a6 <wakeup1>
  release(&ptable.lock);
801039c0:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801039c7:	e8 e7 03 00 00       	call   80103db3 <release>
}
801039cc:	83 c4 10             	add    $0x10,%esp
801039cf:	c9                   	leave  
801039d0:	c3                   	ret    

801039d1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039d1:	55                   	push   %ebp
801039d2:	89 e5                	mov    %esp,%ebp
801039d4:	53                   	push   %ebx
801039d5:	83 ec 10             	sub    $0x10,%esp
801039d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039db:	68 20 1d 11 80       	push   $0x80111d20
801039e0:	e8 69 03 00 00       	call   80103d4e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801039ed:	eb 20                	jmp    80103a0f <kill+0x3e>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
801039ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insertProc( p, p->prio);
801039f6:	83 ec 08             	sub    $0x8,%esp
801039f9:	ff b0 80 00 00 00    	push   0x80(%eax)
801039ff:	50                   	push   %eax
80103a00:	e8 4f f6 ff ff       	call   80103054 <insertProc>
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	eb 1e                	jmp    80103a28 <kill+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0a:	05 88 00 00 00       	add    $0x88,%eax
80103a0f:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
80103a14:	73 2c                	jae    80103a42 <kill+0x71>
    if(p->pid == pid){
80103a16:	39 58 10             	cmp    %ebx,0x10(%eax)
80103a19:	75 ef                	jne    80103a0a <kill+0x39>
      p->killed = 1;
80103a1b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
80103a22:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a26:	74 c7                	je     801039ef <kill+0x1e>
      }
      release(&ptable.lock);
80103a28:	83 ec 0c             	sub    $0xc,%esp
80103a2b:	68 20 1d 11 80       	push   $0x80111d20
80103a30:	e8 7e 03 00 00       	call   80103db3 <release>
      return 0;
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    
  release(&ptable.lock);
80103a42:	83 ec 0c             	sub    $0xc,%esp
80103a45:	68 20 1d 11 80       	push   $0x80111d20
80103a4a:	e8 64 03 00 00       	call   80103db3 <release>
  return -1;
80103a4f:	83 c4 10             	add    $0x10,%esp
80103a52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a57:	eb e4                	jmp    80103a3d <kill+0x6c>

80103a59 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	56                   	push   %esi
80103a5d:	53                   	push   %ebx
80103a5e:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a61:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103a66:	eb 36                	jmp    80103a9e <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103a68:	b8 6b 71 10 80       	mov    $0x8010716b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103a6d:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a70:	52                   	push   %edx
80103a71:	50                   	push   %eax
80103a72:	ff 73 10             	push   0x10(%ebx)
80103a75:	68 6f 71 10 80       	push   $0x8010716f
80103a7a:	e8 5b cb ff ff       	call   801005da <cprintf>
    if(p->state == SLEEPING){
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a86:	74 3c                	je     80103ac4 <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a88:	83 ec 0c             	sub    $0xc,%esp
80103a8b:	68 ef 75 10 80       	push   $0x801075ef
80103a90:	e8 45 cb ff ff       	call   801005da <cprintf>
80103a95:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a98:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a9e:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103aa4:	73 5f                	jae    80103b05 <procdump+0xac>
    if(p->state == UNUSED)
80103aa6:	8b 43 0c             	mov    0xc(%ebx),%eax
80103aa9:	85 c0                	test   %eax,%eax
80103aab:	74 eb                	je     80103a98 <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103aad:	83 f8 05             	cmp    $0x5,%eax
80103ab0:	77 b6                	ja     80103a68 <procdump+0xf>
80103ab2:	8b 04 85 cc 71 10 80 	mov    -0x7fef8e34(,%eax,4),%eax
80103ab9:	85 c0                	test   %eax,%eax
80103abb:	75 b0                	jne    80103a6d <procdump+0x14>
      state = "???";
80103abd:	b8 6b 71 10 80       	mov    $0x8010716b,%eax
80103ac2:	eb a9                	jmp    80103a6d <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ac4:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ac7:	8b 40 0c             	mov    0xc(%eax),%eax
80103aca:	83 c0 08             	add    $0x8,%eax
80103acd:	83 ec 08             	sub    $0x8,%esp
80103ad0:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103ad3:	52                   	push   %edx
80103ad4:	50                   	push   %eax
80103ad5:	e8 58 01 00 00       	call   80103c32 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103ada:	83 c4 10             	add    $0x10,%esp
80103add:	be 00 00 00 00       	mov    $0x0,%esi
80103ae2:	eb 12                	jmp    80103af6 <procdump+0x9d>
        cprintf(" %p", pc[i]);
80103ae4:	83 ec 08             	sub    $0x8,%esp
80103ae7:	50                   	push   %eax
80103ae8:	68 c1 6b 10 80       	push   $0x80106bc1
80103aed:	e8 e8 ca ff ff       	call   801005da <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103af2:	46                   	inc    %esi
80103af3:	83 c4 10             	add    $0x10,%esp
80103af6:	83 fe 09             	cmp    $0x9,%esi
80103af9:	7f 8d                	jg     80103a88 <procdump+0x2f>
80103afb:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103aff:	85 c0                	test   %eax,%eax
80103b01:	75 e1                	jne    80103ae4 <procdump+0x8b>
80103b03:	eb 83                	jmp    80103a88 <procdump+0x2f>
  }
}
80103b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b08:	5b                   	pop    %ebx
80103b09:	5e                   	pop    %esi
80103b0a:	5d                   	pop    %ebp
80103b0b:	c3                   	ret    

80103b0c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b0c:	55                   	push   %ebp
80103b0d:	89 e5                	mov    %esp,%ebp
80103b0f:	53                   	push   %ebx
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b16:	68 e4 71 10 80       	push   $0x801071e4
80103b1b:	8d 43 04             	lea    0x4(%ebx),%eax
80103b1e:	50                   	push   %eax
80103b1f:	e8 f3 00 00 00       	call   80103c17 <initlock>
  lk->name = name;
80103b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b27:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b30:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3d:	c9                   	leave  
80103b3e:	c3                   	ret    

80103b3f <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b3f:	55                   	push   %ebp
80103b40:	89 e5                	mov    %esp,%ebp
80103b42:	56                   	push   %esi
80103b43:	53                   	push   %ebx
80103b44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b47:	8d 73 04             	lea    0x4(%ebx),%esi
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	56                   	push   %esi
80103b4e:	e8 fb 01 00 00       	call   80103d4e <acquire>
  while (lk->locked) {
80103b53:	83 c4 10             	add    $0x10,%esp
80103b56:	eb 0d                	jmp    80103b65 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103b58:	83 ec 08             	sub    $0x8,%esp
80103b5b:	56                   	push   %esi
80103b5c:	53                   	push   %ebx
80103b5d:	e8 d4 fc ff ff       	call   80103836 <sleep>
80103b62:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103b65:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b68:	75 ee                	jne    80103b58 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103b6a:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b70:	e8 a5 f7 ff ff       	call   8010331a <myproc>
80103b75:	8b 40 10             	mov    0x10(%eax),%eax
80103b78:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b7b:	83 ec 0c             	sub    $0xc,%esp
80103b7e:	56                   	push   %esi
80103b7f:	e8 2f 02 00 00       	call   80103db3 <release>
}
80103b84:	83 c4 10             	add    $0x10,%esp
80103b87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b8a:	5b                   	pop    %ebx
80103b8b:	5e                   	pop    %esi
80103b8c:	5d                   	pop    %ebp
80103b8d:	c3                   	ret    

80103b8e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b8e:	55                   	push   %ebp
80103b8f:	89 e5                	mov    %esp,%ebp
80103b91:	56                   	push   %esi
80103b92:	53                   	push   %ebx
80103b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b96:	8d 73 04             	lea    0x4(%ebx),%esi
80103b99:	83 ec 0c             	sub    $0xc,%esp
80103b9c:	56                   	push   %esi
80103b9d:	e8 ac 01 00 00       	call   80103d4e <acquire>
  lk->locked = 0;
80103ba2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ba8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103baf:	89 1c 24             	mov    %ebx,(%esp)
80103bb2:	e8 f1 fd ff ff       	call   801039a8 <wakeup>
  release(&lk->lk);
80103bb7:	89 34 24             	mov    %esi,(%esp)
80103bba:	e8 f4 01 00 00       	call   80103db3 <release>
}
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bc5:	5b                   	pop    %ebx
80103bc6:	5e                   	pop    %esi
80103bc7:	5d                   	pop    %ebp
80103bc8:	c3                   	ret    

80103bc9 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103bc9:	55                   	push   %ebp
80103bca:	89 e5                	mov    %esp,%ebp
80103bcc:	56                   	push   %esi
80103bcd:	53                   	push   %ebx
80103bce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103bd1:	8d 73 04             	lea    0x4(%ebx),%esi
80103bd4:	83 ec 0c             	sub    $0xc,%esp
80103bd7:	56                   	push   %esi
80103bd8:	e8 71 01 00 00       	call   80103d4e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103bdd:	83 c4 10             	add    $0x10,%esp
80103be0:	83 3b 00             	cmpl   $0x0,(%ebx)
80103be3:	75 17                	jne    80103bfc <holdingsleep+0x33>
80103be5:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	56                   	push   %esi
80103bee:	e8 c0 01 00 00       	call   80103db3 <release>
  return r;
}
80103bf3:	89 d8                	mov    %ebx,%eax
80103bf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf8:	5b                   	pop    %ebx
80103bf9:	5e                   	pop    %esi
80103bfa:	5d                   	pop    %ebp
80103bfb:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103bfc:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103bff:	e8 16 f7 ff ff       	call   8010331a <myproc>
80103c04:	3b 58 10             	cmp    0x10(%eax),%ebx
80103c07:	74 07                	je     80103c10 <holdingsleep+0x47>
80103c09:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c0e:	eb da                	jmp    80103bea <holdingsleep+0x21>
80103c10:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c15:	eb d3                	jmp    80103bea <holdingsleep+0x21>

80103c17 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c17:	55                   	push   %ebp
80103c18:	89 e5                	mov    %esp,%ebp
80103c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c20:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c30:	5d                   	pop    %ebp
80103c31:	c3                   	ret    

80103c32 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c32:	55                   	push   %ebp
80103c33:	89 e5                	mov    %esp,%ebp
80103c35:	53                   	push   %ebx
80103c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103c39:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3c:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c44:	83 f8 09             	cmp    $0x9,%eax
80103c47:	7f 21                	jg     80103c6a <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c49:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c4f:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c55:	77 13                	ja     80103c6a <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c57:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c5a:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c5d:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c5f:	40                   	inc    %eax
80103c60:	eb e2                	jmp    80103c44 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c62:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c69:	40                   	inc    %eax
80103c6a:	83 f8 09             	cmp    $0x9,%eax
80103c6d:	7e f3                	jle    80103c62 <getcallerpcs+0x30>
}
80103c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c72:	c9                   	leave  
80103c73:	c3                   	ret    

80103c74 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	53                   	push   %ebx
80103c78:	83 ec 04             	sub    $0x4,%esp
80103c7b:	9c                   	pushf  
80103c7c:	5b                   	pop    %ebx
  asm volatile("cli");
80103c7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c7e:	e8 02 f6 ff ff       	call   80103285 <mycpu>
80103c83:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c8a:	74 10                	je     80103c9c <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c8c:	e8 f4 f5 ff ff       	call   80103285 <mycpu>
80103c91:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9a:	c9                   	leave  
80103c9b:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c9c:	e8 e4 f5 ff ff       	call   80103285 <mycpu>
80103ca1:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103ca7:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103cad:	eb dd                	jmp    80103c8c <pushcli+0x18>

80103caf <popcli>:

void
popcli(void)
{
80103caf:	55                   	push   %ebp
80103cb0:	89 e5                	mov    %esp,%ebp
80103cb2:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cb5:	9c                   	pushf  
80103cb6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cb7:	f6 c4 02             	test   $0x2,%ah
80103cba:	75 28                	jne    80103ce4 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103cbc:	e8 c4 f5 ff ff       	call   80103285 <mycpu>
80103cc1:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103cc7:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103cca:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103cd0:	85 d2                	test   %edx,%edx
80103cd2:	78 1d                	js     80103cf1 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cd4:	e8 ac f5 ff ff       	call   80103285 <mycpu>
80103cd9:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103ce0:	74 1c                	je     80103cfe <popcli+0x4f>
    sti();
}
80103ce2:	c9                   	leave  
80103ce3:	c3                   	ret    
    panic("popcli - interruptible");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 ef 71 10 80       	push   $0x801071ef
80103cec:	e8 50 c6 ff ff       	call   80100341 <panic>
    panic("popcli");
80103cf1:	83 ec 0c             	sub    $0xc,%esp
80103cf4:	68 06 72 10 80       	push   $0x80107206
80103cf9:	e8 43 c6 ff ff       	call   80100341 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cfe:	e8 82 f5 ff ff       	call   80103285 <mycpu>
80103d03:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d0a:	74 d6                	je     80103ce2 <popcli+0x33>
  asm volatile("sti");
80103d0c:	fb                   	sti    
}
80103d0d:	eb d3                	jmp    80103ce2 <popcli+0x33>

80103d0f <holding>:
{
80103d0f:	55                   	push   %ebp
80103d10:	89 e5                	mov    %esp,%ebp
80103d12:	53                   	push   %ebx
80103d13:	83 ec 04             	sub    $0x4,%esp
80103d16:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103d19:	e8 56 ff ff ff       	call   80103c74 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d1e:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d21:	75 11                	jne    80103d34 <holding+0x25>
80103d23:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103d28:	e8 82 ff ff ff       	call   80103caf <popcli>
}
80103d2d:	89 d8                	mov    %ebx,%eax
80103d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d32:	c9                   	leave  
80103d33:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103d34:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103d37:	e8 49 f5 ff ff       	call   80103285 <mycpu>
80103d3c:	39 c3                	cmp    %eax,%ebx
80103d3e:	74 07                	je     80103d47 <holding+0x38>
80103d40:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d45:	eb e1                	jmp    80103d28 <holding+0x19>
80103d47:	bb 01 00 00 00       	mov    $0x1,%ebx
80103d4c:	eb da                	jmp    80103d28 <holding+0x19>

80103d4e <acquire>:
{
80103d4e:	55                   	push   %ebp
80103d4f:	89 e5                	mov    %esp,%ebp
80103d51:	53                   	push   %ebx
80103d52:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d55:	e8 1a ff ff ff       	call   80103c74 <pushcli>
  if(holding(lk))
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	ff 75 08             	push   0x8(%ebp)
80103d60:	e8 aa ff ff ff       	call   80103d0f <holding>
80103d65:	83 c4 10             	add    $0x10,%esp
80103d68:	85 c0                	test   %eax,%eax
80103d6a:	75 3a                	jne    80103da6 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103d6f:	b8 01 00 00 00       	mov    $0x1,%eax
80103d74:	f0 87 02             	lock xchg %eax,(%edx)
80103d77:	85 c0                	test   %eax,%eax
80103d79:	75 f1                	jne    80103d6c <acquire+0x1e>
  __sync_synchronize();
80103d7b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d83:	e8 fd f4 ff ff       	call   80103285 <mycpu>
80103d88:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8e:	83 c0 0c             	add    $0xc,%eax
80103d91:	83 ec 08             	sub    $0x8,%esp
80103d94:	50                   	push   %eax
80103d95:	8d 45 08             	lea    0x8(%ebp),%eax
80103d98:	50                   	push   %eax
80103d99:	e8 94 fe ff ff       	call   80103c32 <getcallerpcs>
}
80103d9e:	83 c4 10             	add    $0x10,%esp
80103da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da4:	c9                   	leave  
80103da5:	c3                   	ret    
    panic("acquire");
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	68 0d 72 10 80       	push   $0x8010720d
80103dae:	e8 8e c5 ff ff       	call   80100341 <panic>

80103db3 <release>:
{
80103db3:	55                   	push   %ebp
80103db4:	89 e5                	mov    %esp,%ebp
80103db6:	53                   	push   %ebx
80103db7:	83 ec 10             	sub    $0x10,%esp
80103dba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103dbd:	53                   	push   %ebx
80103dbe:	e8 4c ff ff ff       	call   80103d0f <holding>
80103dc3:	83 c4 10             	add    $0x10,%esp
80103dc6:	85 c0                	test   %eax,%eax
80103dc8:	74 23                	je     80103ded <release+0x3a>
  lk->pcs[0] = 0;
80103dca:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103dd1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103dd8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103ddd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103de3:	e8 c7 fe ff ff       	call   80103caf <popcli>
}
80103de8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103deb:	c9                   	leave  
80103dec:	c3                   	ret    
    panic("release");
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	68 15 72 10 80       	push   $0x80107215
80103df5:	e8 47 c5 ff ff       	call   80100341 <panic>

80103dfa <memset>:
80103dfa:	55                   	push   %ebp
80103dfb:	89 e5                	mov    %esp,%ebp
80103dfd:	57                   	push   %edi
80103dfe:	53                   	push   %ebx
80103dff:	8b 55 08             	mov    0x8(%ebp),%edx
80103e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e05:	f6 c2 03             	test   $0x3,%dl
80103e08:	75 29                	jne    80103e33 <memset+0x39>
80103e0a:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103e0e:	75 23                	jne    80103e33 <memset+0x39>
80103e10:	0f b6 f8             	movzbl %al,%edi
80103e13:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e16:	c1 e9 02             	shr    $0x2,%ecx
80103e19:	c1 e0 18             	shl    $0x18,%eax
80103e1c:	89 fb                	mov    %edi,%ebx
80103e1e:	c1 e3 10             	shl    $0x10,%ebx
80103e21:	09 d8                	or     %ebx,%eax
80103e23:	89 fb                	mov    %edi,%ebx
80103e25:	c1 e3 08             	shl    $0x8,%ebx
80103e28:	09 d8                	or     %ebx,%eax
80103e2a:	09 f8                	or     %edi,%eax
80103e2c:	89 d7                	mov    %edx,%edi
80103e2e:	fc                   	cld    
80103e2f:	f3 ab                	rep stos %eax,%es:(%edi)
80103e31:	eb 08                	jmp    80103e3b <memset+0x41>
80103e33:	89 d7                	mov    %edx,%edi
80103e35:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e38:	fc                   	cld    
80103e39:	f3 aa                	rep stos %al,%es:(%edi)
80103e3b:	89 d0                	mov    %edx,%eax
80103e3d:	5b                   	pop    %ebx
80103e3e:	5f                   	pop    %edi
80103e3f:	5d                   	pop    %ebp
80103e40:	c3                   	ret    

80103e41 <memcmp>:
80103e41:	55                   	push   %ebp
80103e42:	89 e5                	mov    %esp,%ebp
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103e49:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e4c:	8b 45 10             	mov    0x10(%ebp),%eax
80103e4f:	eb 04                	jmp    80103e55 <memcmp+0x14>
80103e51:	41                   	inc    %ecx
80103e52:	42                   	inc    %edx
80103e53:	89 f0                	mov    %esi,%eax
80103e55:	8d 70 ff             	lea    -0x1(%eax),%esi
80103e58:	85 c0                	test   %eax,%eax
80103e5a:	74 10                	je     80103e6c <memcmp+0x2b>
80103e5c:	8a 01                	mov    (%ecx),%al
80103e5e:	8a 1a                	mov    (%edx),%bl
80103e60:	38 d8                	cmp    %bl,%al
80103e62:	74 ed                	je     80103e51 <memcmp+0x10>
80103e64:	0f b6 c0             	movzbl %al,%eax
80103e67:	0f b6 db             	movzbl %bl,%ebx
80103e6a:	29 d8                	sub    %ebx,%eax
80103e6c:	5b                   	pop    %ebx
80103e6d:	5e                   	pop    %esi
80103e6e:	5d                   	pop    %ebp
80103e6f:	c3                   	ret    

80103e70 <memmove>:
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
80103e75:	8b 75 08             	mov    0x8(%ebp),%esi
80103e78:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e7b:	8b 45 10             	mov    0x10(%ebp),%eax
80103e7e:	39 f2                	cmp    %esi,%edx
80103e80:	73 36                	jae    80103eb8 <memmove+0x48>
80103e82:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e85:	39 f1                	cmp    %esi,%ecx
80103e87:	76 33                	jbe    80103ebc <memmove+0x4c>
80103e89:	8d 14 06             	lea    (%esi,%eax,1),%edx
80103e8c:	eb 08                	jmp    80103e96 <memmove+0x26>
80103e8e:	49                   	dec    %ecx
80103e8f:	4a                   	dec    %edx
80103e90:	8a 01                	mov    (%ecx),%al
80103e92:	88 02                	mov    %al,(%edx)
80103e94:	89 d8                	mov    %ebx,%eax
80103e96:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e99:	85 c0                	test   %eax,%eax
80103e9b:	75 f1                	jne    80103e8e <memmove+0x1e>
80103e9d:	eb 13                	jmp    80103eb2 <memmove+0x42>
80103e9f:	8a 02                	mov    (%edx),%al
80103ea1:	88 01                	mov    %al,(%ecx)
80103ea3:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ea6:	8d 52 01             	lea    0x1(%edx),%edx
80103ea9:	89 d8                	mov    %ebx,%eax
80103eab:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103eae:	85 c0                	test   %eax,%eax
80103eb0:	75 ed                	jne    80103e9f <memmove+0x2f>
80103eb2:	89 f0                	mov    %esi,%eax
80103eb4:	5b                   	pop    %ebx
80103eb5:	5e                   	pop    %esi
80103eb6:	5d                   	pop    %ebp
80103eb7:	c3                   	ret    
80103eb8:	89 f1                	mov    %esi,%ecx
80103eba:	eb ef                	jmp    80103eab <memmove+0x3b>
80103ebc:	89 f1                	mov    %esi,%ecx
80103ebe:	eb eb                	jmp    80103eab <memmove+0x3b>

80103ec0 <memcpy>:
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	ff 75 10             	push   0x10(%ebp)
80103ec9:	ff 75 0c             	push   0xc(%ebp)
80103ecc:	ff 75 08             	push   0x8(%ebp)
80103ecf:	e8 9c ff ff ff       	call   80103e70 <memmove>
80103ed4:	c9                   	leave  
80103ed5:	c3                   	ret    

80103ed6 <strncmp>:
80103ed6:	55                   	push   %ebp
80103ed7:	89 e5                	mov    %esp,%ebp
80103ed9:	53                   	push   %ebx
80103eda:	8b 55 08             	mov    0x8(%ebp),%edx
80103edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80103ee3:	eb 03                	jmp    80103ee8 <strncmp+0x12>
80103ee5:	48                   	dec    %eax
80103ee6:	42                   	inc    %edx
80103ee7:	41                   	inc    %ecx
80103ee8:	85 c0                	test   %eax,%eax
80103eea:	74 0a                	je     80103ef6 <strncmp+0x20>
80103eec:	8a 1a                	mov    (%edx),%bl
80103eee:	84 db                	test   %bl,%bl
80103ef0:	74 04                	je     80103ef6 <strncmp+0x20>
80103ef2:	3a 19                	cmp    (%ecx),%bl
80103ef4:	74 ef                	je     80103ee5 <strncmp+0xf>
80103ef6:	85 c0                	test   %eax,%eax
80103ef8:	74 0d                	je     80103f07 <strncmp+0x31>
80103efa:	0f b6 02             	movzbl (%edx),%eax
80103efd:	0f b6 11             	movzbl (%ecx),%edx
80103f00:	29 d0                	sub    %edx,%eax
80103f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f05:	c9                   	leave  
80103f06:	c3                   	ret    
80103f07:	b8 00 00 00 00       	mov    $0x0,%eax
80103f0c:	eb f4                	jmp    80103f02 <strncmp+0x2c>

80103f0e <strncpy>:
80103f0e:	55                   	push   %ebp
80103f0f:	89 e5                	mov    %esp,%ebp
80103f11:	57                   	push   %edi
80103f12:	56                   	push   %esi
80103f13:	53                   	push   %ebx
80103f14:	8b 45 08             	mov    0x8(%ebp),%eax
80103f17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f1a:	8b 55 10             	mov    0x10(%ebp),%edx
80103f1d:	89 c1                	mov    %eax,%ecx
80103f1f:	eb 04                	jmp    80103f25 <strncpy+0x17>
80103f21:	89 fb                	mov    %edi,%ebx
80103f23:	89 f1                	mov    %esi,%ecx
80103f25:	89 d6                	mov    %edx,%esi
80103f27:	4a                   	dec    %edx
80103f28:	85 f6                	test   %esi,%esi
80103f2a:	7e 10                	jle    80103f3c <strncpy+0x2e>
80103f2c:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f2f:	8d 71 01             	lea    0x1(%ecx),%esi
80103f32:	8a 1b                	mov    (%ebx),%bl
80103f34:	88 19                	mov    %bl,(%ecx)
80103f36:	84 db                	test   %bl,%bl
80103f38:	75 e7                	jne    80103f21 <strncpy+0x13>
80103f3a:	89 f1                	mov    %esi,%ecx
80103f3c:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103f3f:	85 d2                	test   %edx,%edx
80103f41:	7e 0a                	jle    80103f4d <strncpy+0x3f>
80103f43:	c6 01 00             	movb   $0x0,(%ecx)
80103f46:	89 da                	mov    %ebx,%edx
80103f48:	8d 49 01             	lea    0x1(%ecx),%ecx
80103f4b:	eb ef                	jmp    80103f3c <strncpy+0x2e>
80103f4d:	5b                   	pop    %ebx
80103f4e:	5e                   	pop    %esi
80103f4f:	5f                   	pop    %edi
80103f50:	5d                   	pop    %ebp
80103f51:	c3                   	ret    

80103f52 <safestrcpy>:
80103f52:	55                   	push   %ebp
80103f53:	89 e5                	mov    %esp,%ebp
80103f55:	57                   	push   %edi
80103f56:	56                   	push   %esi
80103f57:	53                   	push   %ebx
80103f58:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f5e:	8b 55 10             	mov    0x10(%ebp),%edx
80103f61:	85 d2                	test   %edx,%edx
80103f63:	7e 20                	jle    80103f85 <safestrcpy+0x33>
80103f65:	89 c1                	mov    %eax,%ecx
80103f67:	eb 04                	jmp    80103f6d <safestrcpy+0x1b>
80103f69:	89 fb                	mov    %edi,%ebx
80103f6b:	89 f1                	mov    %esi,%ecx
80103f6d:	4a                   	dec    %edx
80103f6e:	85 d2                	test   %edx,%edx
80103f70:	7e 10                	jle    80103f82 <safestrcpy+0x30>
80103f72:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f75:	8d 71 01             	lea    0x1(%ecx),%esi
80103f78:	8a 1b                	mov    (%ebx),%bl
80103f7a:	88 19                	mov    %bl,(%ecx)
80103f7c:	84 db                	test   %bl,%bl
80103f7e:	75 e9                	jne    80103f69 <safestrcpy+0x17>
80103f80:	89 f1                	mov    %esi,%ecx
80103f82:	c6 01 00             	movb   $0x0,(%ecx)
80103f85:	5b                   	pop    %ebx
80103f86:	5e                   	pop    %esi
80103f87:	5f                   	pop    %edi
80103f88:	5d                   	pop    %ebp
80103f89:	c3                   	ret    

80103f8a <strlen>:
80103f8a:	55                   	push   %ebp
80103f8b:	89 e5                	mov    %esp,%ebp
80103f8d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f90:	b8 00 00 00 00       	mov    $0x0,%eax
80103f95:	eb 01                	jmp    80103f98 <strlen+0xe>
80103f97:	40                   	inc    %eax
80103f98:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f9c:	75 f9                	jne    80103f97 <strlen+0xd>
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    

80103fa0 <swtch>:
80103fa0:	8b 44 24 04          	mov    0x4(%esp),%eax
80103fa4:	8b 54 24 08          	mov    0x8(%esp),%edx
80103fa8:	55                   	push   %ebp
80103fa9:	53                   	push   %ebx
80103faa:	56                   	push   %esi
80103fab:	57                   	push   %edi
80103fac:	89 20                	mov    %esp,(%eax)
80103fae:	89 d4                	mov    %edx,%esp
80103fb0:	5f                   	pop    %edi
80103fb1:	5e                   	pop    %esi
80103fb2:	5b                   	pop    %ebx
80103fb3:	5d                   	pop    %ebp
80103fb4:	c3                   	ret    

80103fb5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103fb5:	55                   	push   %ebp
80103fb6:	89 e5                	mov    %esp,%ebp
80103fb8:	53                   	push   %ebx
80103fb9:	83 ec 04             	sub    $0x4,%esp
80103fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103fbf:	e8 56 f3 ff ff       	call   8010331a <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103fc4:	8b 00                	mov    (%eax),%eax
80103fc6:	39 d8                	cmp    %ebx,%eax
80103fc8:	76 18                	jbe    80103fe2 <fetchint+0x2d>
80103fca:	8d 53 04             	lea    0x4(%ebx),%edx
80103fcd:	39 d0                	cmp    %edx,%eax
80103fcf:	72 18                	jb     80103fe9 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103fd1:	8b 13                	mov    (%ebx),%edx
80103fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd6:	89 10                	mov    %edx,(%eax)
  return 0;
80103fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe0:	c9                   	leave  
80103fe1:	c3                   	ret    
    return -1;
80103fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe7:	eb f4                	jmp    80103fdd <fetchint+0x28>
80103fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fee:	eb ed                	jmp    80103fdd <fetchint+0x28>

80103ff0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 04             	sub    $0x4,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103ffa:	e8 1b f3 ff ff       	call   8010331a <myproc>

  if(addr >= curproc->sz)
80103fff:	39 18                	cmp    %ebx,(%eax)
80104001:	76 23                	jbe    80104026 <fetchstr+0x36>
    return -1;
  *pp = (char*)addr;
80104003:	8b 55 0c             	mov    0xc(%ebp),%edx
80104006:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104008:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010400a:	89 d8                	mov    %ebx,%eax
8010400c:	eb 01                	jmp    8010400f <fetchstr+0x1f>
8010400e:	40                   	inc    %eax
8010400f:	39 d0                	cmp    %edx,%eax
80104011:	73 09                	jae    8010401c <fetchstr+0x2c>
    if(*s == 0)
80104013:	80 38 00             	cmpb   $0x0,(%eax)
80104016:	75 f6                	jne    8010400e <fetchstr+0x1e>
      return s - *pp;
80104018:	29 d8                	sub    %ebx,%eax
8010401a:	eb 05                	jmp    80104021 <fetchstr+0x31>
  }
  return -1;
8010401c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104021:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104024:	c9                   	leave  
80104025:	c3                   	ret    
    return -1;
80104026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010402b:	eb f4                	jmp    80104021 <fetchstr+0x31>

8010402d <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010402d:	55                   	push   %ebp
8010402e:	89 e5                	mov    %esp,%ebp
80104030:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104033:	e8 e2 f2 ff ff       	call   8010331a <myproc>
80104038:	8b 50 18             	mov    0x18(%eax),%edx
8010403b:	8b 45 08             	mov    0x8(%ebp),%eax
8010403e:	c1 e0 02             	shl    $0x2,%eax
80104041:	03 42 44             	add    0x44(%edx),%eax
80104044:	83 ec 08             	sub    $0x8,%esp
80104047:	ff 75 0c             	push   0xc(%ebp)
8010404a:	83 c0 04             	add    $0x4,%eax
8010404d:	50                   	push   %eax
8010404e:	e8 62 ff ff ff       	call   80103fb5 <fetchint>
}
80104053:	c9                   	leave  
80104054:	c3                   	ret    

80104055 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80104055:	55                   	push   %ebp
80104056:	89 e5                	mov    %esp,%ebp
80104058:	56                   	push   %esi
80104059:	53                   	push   %ebx
8010405a:	83 ec 10             	sub    $0x10,%esp
8010405d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104060:	e8 b5 f2 ff ff       	call   8010331a <myproc>
80104065:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104067:	83 ec 08             	sub    $0x8,%esp
8010406a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010406d:	50                   	push   %eax
8010406e:	ff 75 08             	push   0x8(%ebp)
80104071:	e8 b7 ff ff ff       	call   8010402d <argint>
80104076:	83 c4 10             	add    $0x10,%esp
80104079:	85 c0                	test   %eax,%eax
8010407b:	78 24                	js     801040a1 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010407d:	85 db                	test   %ebx,%ebx
8010407f:	78 27                	js     801040a8 <argptr+0x53>
80104081:	8b 16                	mov    (%esi),%edx
80104083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104086:	39 c2                	cmp    %eax,%edx
80104088:	76 25                	jbe    801040af <argptr+0x5a>
8010408a:	01 c3                	add    %eax,%ebx
8010408c:	39 da                	cmp    %ebx,%edx
8010408e:	72 26                	jb     801040b6 <argptr+0x61>
    return -1;
  *pp = (void*)i;
80104090:	8b 55 0c             	mov    0xc(%ebp),%edx
80104093:	89 02                	mov    %eax,(%edx)
  return 0;
80104095:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010409a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010409d:	5b                   	pop    %ebx
8010409e:	5e                   	pop    %esi
8010409f:	5d                   	pop    %ebp
801040a0:	c3                   	ret    
    return -1;
801040a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040a6:	eb f2                	jmp    8010409a <argptr+0x45>
    return -1;
801040a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040ad:	eb eb                	jmp    8010409a <argptr+0x45>
801040af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040b4:	eb e4                	jmp    8010409a <argptr+0x45>
801040b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040bb:	eb dd                	jmp    8010409a <argptr+0x45>

801040bd <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801040bd:	55                   	push   %ebp
801040be:	89 e5                	mov    %esp,%ebp
801040c0:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801040c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040c6:	50                   	push   %eax
801040c7:	ff 75 08             	push   0x8(%ebp)
801040ca:	e8 5e ff ff ff       	call   8010402d <argint>
801040cf:	83 c4 10             	add    $0x10,%esp
801040d2:	85 c0                	test   %eax,%eax
801040d4:	78 13                	js     801040e9 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
801040d6:	83 ec 08             	sub    $0x8,%esp
801040d9:	ff 75 0c             	push   0xc(%ebp)
801040dc:	ff 75 f4             	push   -0xc(%ebp)
801040df:	e8 0c ff ff ff       	call   80103ff0 <fetchstr>
801040e4:	83 c4 10             	add    $0x10,%esp
}
801040e7:	c9                   	leave  
801040e8:	c3                   	ret    
    return -1;
801040e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040ee:	eb f7                	jmp    801040e7 <argstr+0x2a>

801040f0 <syscall>:
[SYS_setprio] sys_setprio,
};

void
syscall(void)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801040f7:	e8 1e f2 ff ff       	call   8010331a <myproc>
801040fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801040fe:	8b 40 18             	mov    0x18(%eax),%eax
80104101:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104104:	8d 50 ff             	lea    -0x1(%eax),%edx
80104107:	83 fa 19             	cmp    $0x19,%edx
8010410a:	77 17                	ja     80104123 <syscall+0x33>
8010410c:	8b 14 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%edx
80104113:	85 d2                	test   %edx,%edx
80104115:	74 0c                	je     80104123 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
80104117:	ff d2                	call   *%edx
80104119:	89 c2                	mov    %eax,%edx
8010411b:	8b 43 18             	mov    0x18(%ebx),%eax
8010411e:	89 50 1c             	mov    %edx,0x1c(%eax)
80104121:	eb 1f                	jmp    80104142 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104123:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104126:	50                   	push   %eax
80104127:	52                   	push   %edx
80104128:	ff 73 10             	push   0x10(%ebx)
8010412b:	68 1d 72 10 80       	push   $0x8010721d
80104130:	e8 a5 c4 ff ff       	call   801005da <cprintf>
    curproc->tf->eax = -1;
80104135:	8b 43 18             	mov    0x18(%ebx),%eax
80104138:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010413f:	83 c4 10             	add    $0x10,%esp
  }
}
80104142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104145:	c9                   	leave  
80104146:	c3                   	ret    

80104147 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104147:	55                   	push   %ebp
80104148:	89 e5                	mov    %esp,%ebp
8010414a:	56                   	push   %esi
8010414b:	53                   	push   %ebx
8010414c:	83 ec 18             	sub    $0x18,%esp
8010414f:	89 d6                	mov    %edx,%esi
80104151:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104153:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104156:	52                   	push   %edx
80104157:	50                   	push   %eax
80104158:	e8 d0 fe ff ff       	call   8010402d <argint>
8010415d:	83 c4 10             	add    $0x10,%esp
80104160:	85 c0                	test   %eax,%eax
80104162:	78 35                	js     80104199 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104164:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104168:	77 28                	ja     80104192 <argfd+0x4b>
8010416a:	e8 ab f1 ff ff       	call   8010331a <myproc>
8010416f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104172:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104176:	85 c0                	test   %eax,%eax
80104178:	74 18                	je     80104192 <argfd+0x4b>
    return -1;
  if(pfd)
8010417a:	85 f6                	test   %esi,%esi
8010417c:	74 02                	je     80104180 <argfd+0x39>
    *pfd = fd;
8010417e:	89 16                	mov    %edx,(%esi)
  if(pf)
80104180:	85 db                	test   %ebx,%ebx
80104182:	74 1c                	je     801041a0 <argfd+0x59>
    *pf = f;
80104184:	89 03                	mov    %eax,(%ebx)
  return 0;
80104186:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010418b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010418e:	5b                   	pop    %ebx
8010418f:	5e                   	pop    %esi
80104190:	5d                   	pop    %ebp
80104191:	c3                   	ret    
    return -1;
80104192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104197:	eb f2                	jmp    8010418b <argfd+0x44>
    return -1;
80104199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419e:	eb eb                	jmp    8010418b <argfd+0x44>
  return 0;
801041a0:	b8 00 00 00 00       	mov    $0x0,%eax
801041a5:	eb e4                	jmp    8010418b <argfd+0x44>

801041a7 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801041a7:	55                   	push   %ebp
801041a8:	89 e5                	mov    %esp,%ebp
801041aa:	53                   	push   %ebx
801041ab:	83 ec 04             	sub    $0x4,%esp
801041ae:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801041b0:	e8 65 f1 ff ff       	call   8010331a <myproc>
801041b5:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
801041b7:	b8 00 00 00 00       	mov    $0x0,%eax
801041bc:	83 f8 0f             	cmp    $0xf,%eax
801041bf:	7f 10                	jg     801041d1 <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
801041c1:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041c6:	74 03                	je     801041cb <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
801041c8:	40                   	inc    %eax
801041c9:	eb f1                	jmp    801041bc <fdalloc+0x15>
      curproc->ofile[fd] = f;
801041cb:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
801041cf:	eb 05                	jmp    801041d6 <fdalloc+0x2f>
    }
  }
  return -1;
801041d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d9:	c9                   	leave  
801041da:	c3                   	ret    

801041db <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801041db:	55                   	push   %ebp
801041dc:	89 e5                	mov    %esp,%ebp
801041de:	56                   	push   %esi
801041df:	53                   	push   %ebx
801041e0:	83 ec 10             	sub    $0x10,%esp
801041e3:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801041e5:	b8 20 00 00 00       	mov    $0x20,%eax
801041ea:	89 c6                	mov    %eax,%esi
801041ec:	39 43 58             	cmp    %eax,0x58(%ebx)
801041ef:	76 2e                	jbe    8010421f <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801041f1:	6a 10                	push   $0x10
801041f3:	50                   	push   %eax
801041f4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801041f7:	50                   	push   %eax
801041f8:	53                   	push   %ebx
801041f9:	e8 f5 d4 ff ff       	call   801016f3 <readi>
801041fe:	83 c4 10             	add    $0x10,%esp
80104201:	83 f8 10             	cmp    $0x10,%eax
80104204:	75 0c                	jne    80104212 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104206:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
8010420b:	75 1e                	jne    8010422b <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010420d:	8d 46 10             	lea    0x10(%esi),%eax
80104210:	eb d8                	jmp    801041ea <isdirempty+0xf>
      panic("isdirempty: readi");
80104212:	83 ec 0c             	sub    $0xc,%esp
80104215:	68 ac 72 10 80       	push   $0x801072ac
8010421a:	e8 22 c1 ff ff       	call   80100341 <panic>
      return 0;
  }
  return 1;
8010421f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104224:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104227:	5b                   	pop    %ebx
80104228:	5e                   	pop    %esi
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
      return 0;
8010422b:	b8 00 00 00 00       	mov    $0x0,%eax
80104230:	eb f2                	jmp    80104224 <isdirempty+0x49>

80104232 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104232:	55                   	push   %ebp
80104233:	89 e5                	mov    %esp,%ebp
80104235:	57                   	push   %edi
80104236:	56                   	push   %esi
80104237:	53                   	push   %ebx
80104238:	83 ec 44             	sub    $0x44,%esp
8010423b:	89 d7                	mov    %edx,%edi
8010423d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104240:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104243:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104246:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104249:	52                   	push   %edx
8010424a:	50                   	push   %eax
8010424b:	e8 32 d9 ff ff       	call   80101b82 <nameiparent>
80104250:	89 c6                	mov    %eax,%esi
80104252:	83 c4 10             	add    $0x10,%esp
80104255:	85 c0                	test   %eax,%eax
80104257:	0f 84 32 01 00 00    	je     8010438f <create+0x15d>
    return 0;
  ilock(dp);
8010425d:	83 ec 0c             	sub    $0xc,%esp
80104260:	50                   	push   %eax
80104261:	e8 a0 d2 ff ff       	call   80101506 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104266:	83 c4 0c             	add    $0xc,%esp
80104269:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010426c:	50                   	push   %eax
8010426d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104270:	50                   	push   %eax
80104271:	56                   	push   %esi
80104272:	e8 c5 d6 ff ff       	call   8010193c <dirlookup>
80104277:	89 c3                	mov    %eax,%ebx
80104279:	83 c4 10             	add    $0x10,%esp
8010427c:	85 c0                	test   %eax,%eax
8010427e:	74 3c                	je     801042bc <create+0x8a>
    iunlockput(dp);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	56                   	push   %esi
80104284:	e8 20 d4 ff ff       	call   801016a9 <iunlockput>
    ilock(ip);
80104289:	89 1c 24             	mov    %ebx,(%esp)
8010428c:	e8 75 d2 ff ff       	call   80101506 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104291:	83 c4 10             	add    $0x10,%esp
80104294:	66 83 ff 02          	cmp    $0x2,%di
80104298:	75 07                	jne    801042a1 <create+0x6f>
8010429a:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010429f:	74 11                	je     801042b2 <create+0x80>
      return ip;
    iunlockput(ip);
801042a1:	83 ec 0c             	sub    $0xc,%esp
801042a4:	53                   	push   %ebx
801042a5:	e8 ff d3 ff ff       	call   801016a9 <iunlockput>
    return 0;
801042aa:	83 c4 10             	add    $0x10,%esp
801042ad:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042b2:	89 d8                	mov    %ebx,%eax
801042b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b7:	5b                   	pop    %ebx
801042b8:	5e                   	pop    %esi
801042b9:	5f                   	pop    %edi
801042ba:	5d                   	pop    %ebp
801042bb:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801042bc:	83 ec 08             	sub    $0x8,%esp
801042bf:	0f bf c7             	movswl %di,%eax
801042c2:	50                   	push   %eax
801042c3:	ff 36                	push   (%esi)
801042c5:	e8 44 d0 ff ff       	call   8010130e <ialloc>
801042ca:	89 c3                	mov    %eax,%ebx
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	85 c0                	test   %eax,%eax
801042d1:	74 53                	je     80104326 <create+0xf4>
  ilock(ip);
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	50                   	push   %eax
801042d7:	e8 2a d2 ff ff       	call   80101506 <ilock>
  ip->major = major;
801042dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801042df:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801042e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801042e6:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801042ea:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801042f0:	89 1c 24             	mov    %ebx,(%esp)
801042f3:	e8 b5 d0 ff ff       	call   801013ad <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801042f8:	83 c4 10             	add    $0x10,%esp
801042fb:	66 83 ff 01          	cmp    $0x1,%di
801042ff:	74 32                	je     80104333 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
80104301:	83 ec 04             	sub    $0x4,%esp
80104304:	ff 73 04             	push   0x4(%ebx)
80104307:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010430a:	50                   	push   %eax
8010430b:	56                   	push   %esi
8010430c:	e8 a8 d7 ff ff       	call   80101ab9 <dirlink>
80104311:	83 c4 10             	add    $0x10,%esp
80104314:	85 c0                	test   %eax,%eax
80104316:	78 6a                	js     80104382 <create+0x150>
  iunlockput(dp);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	56                   	push   %esi
8010431c:	e8 88 d3 ff ff       	call   801016a9 <iunlockput>
  return ip;
80104321:	83 c4 10             	add    $0x10,%esp
80104324:	eb 8c                	jmp    801042b2 <create+0x80>
    panic("create: ialloc");
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	68 be 72 10 80       	push   $0x801072be
8010432e:	e8 0e c0 ff ff       	call   80100341 <panic>
    dp->nlink++;  // for ".."
80104333:	66 8b 46 56          	mov    0x56(%esi),%ax
80104337:	40                   	inc    %eax
80104338:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010433c:	83 ec 0c             	sub    $0xc,%esp
8010433f:	56                   	push   %esi
80104340:	e8 68 d0 ff ff       	call   801013ad <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104345:	83 c4 0c             	add    $0xc,%esp
80104348:	ff 73 04             	push   0x4(%ebx)
8010434b:	68 ce 72 10 80       	push   $0x801072ce
80104350:	53                   	push   %ebx
80104351:	e8 63 d7 ff ff       	call   80101ab9 <dirlink>
80104356:	83 c4 10             	add    $0x10,%esp
80104359:	85 c0                	test   %eax,%eax
8010435b:	78 18                	js     80104375 <create+0x143>
8010435d:	83 ec 04             	sub    $0x4,%esp
80104360:	ff 76 04             	push   0x4(%esi)
80104363:	68 cd 72 10 80       	push   $0x801072cd
80104368:	53                   	push   %ebx
80104369:	e8 4b d7 ff ff       	call   80101ab9 <dirlink>
8010436e:	83 c4 10             	add    $0x10,%esp
80104371:	85 c0                	test   %eax,%eax
80104373:	79 8c                	jns    80104301 <create+0xcf>
      panic("create dots");
80104375:	83 ec 0c             	sub    $0xc,%esp
80104378:	68 d0 72 10 80       	push   $0x801072d0
8010437d:	e8 bf bf ff ff       	call   80100341 <panic>
    panic("create: dirlink");
80104382:	83 ec 0c             	sub    $0xc,%esp
80104385:	68 dc 72 10 80       	push   $0x801072dc
8010438a:	e8 b2 bf ff ff       	call   80100341 <panic>
    return 0;
8010438f:	89 c3                	mov    %eax,%ebx
80104391:	e9 1c ff ff ff       	jmp    801042b2 <create+0x80>

80104396 <sys_dup>:
{
80104396:	55                   	push   %ebp
80104397:	89 e5                	mov    %esp,%ebp
80104399:	53                   	push   %ebx
8010439a:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010439d:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043a0:	ba 00 00 00 00       	mov    $0x0,%edx
801043a5:	b8 00 00 00 00       	mov    $0x0,%eax
801043aa:	e8 98 fd ff ff       	call   80104147 <argfd>
801043af:	85 c0                	test   %eax,%eax
801043b1:	78 23                	js     801043d6 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
801043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b6:	e8 ec fd ff ff       	call   801041a7 <fdalloc>
801043bb:	89 c3                	mov    %eax,%ebx
801043bd:	85 c0                	test   %eax,%eax
801043bf:	78 1c                	js     801043dd <sys_dup+0x47>
  filedup(f);
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	ff 75 f4             	push   -0xc(%ebp)
801043c7:	e8 7b c8 ff ff       	call   80100c47 <filedup>
  return fd;
801043cc:	83 c4 10             	add    $0x10,%esp
}
801043cf:	89 d8                	mov    %ebx,%eax
801043d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d4:	c9                   	leave  
801043d5:	c3                   	ret    
    return -1;
801043d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043db:	eb f2                	jmp    801043cf <sys_dup+0x39>
    return -1;
801043dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043e2:	eb eb                	jmp    801043cf <sys_dup+0x39>

801043e4 <sys_dup2>:
{
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	53                   	push   %ebx
801043e8:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc();
801043eb:	e8 2a ef ff ff       	call   8010331a <myproc>
801043f0:	89 c3                	mov    %eax,%ebx
  if(argfd(0, 0, &f) < 0)
801043f2:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043f5:	ba 00 00 00 00       	mov    $0x0,%edx
801043fa:	b8 00 00 00 00       	mov    $0x0,%eax
801043ff:	e8 43 fd ff ff       	call   80104147 <argfd>
80104404:	85 c0                	test   %eax,%eax
80104406:	78 64                	js     8010446c <sys_dup2+0x88>
  if(argint(1, &gd) < 0)
80104408:	83 ec 08             	sub    $0x8,%esp
8010440b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010440e:	50                   	push   %eax
8010440f:	6a 01                	push   $0x1
80104411:	e8 17 fc ff ff       	call   8010402d <argint>
80104416:	83 c4 10             	add    $0x10,%esp
80104419:	85 c0                	test   %eax,%eax
8010441b:	78 56                	js     80104473 <sys_dup2+0x8f>
  if(gd < 0 || gd >= NOFILE)
8010441d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104421:	77 57                	ja     8010447a <sys_dup2+0x96>
  g=myproc()->ofile[gd];
80104423:	e8 f2 ee ff ff       	call   8010331a <myproc>
80104428:	89 c2                	mov    %eax,%edx
8010442a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442d:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
  if(f == g)
80104431:	39 55 f4             	cmp    %edx,-0xc(%ebp)
80104434:	74 31                	je     80104467 <sys_dup2+0x83>
  if( g != 0 ){
80104436:	85 d2                	test   %edx,%edx
80104438:	74 14                	je     8010444e <sys_dup2+0x6a>
    curproc->ofile[gd] = 0;
8010443a:	c7 44 83 28 00 00 00 	movl   $0x0,0x28(%ebx,%eax,4)
80104441:	00 
    fileclose(g);
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	52                   	push   %edx
80104446:	e8 3f c8 ff ff       	call   80100c8a <fileclose>
8010444b:	83 c4 10             	add    $0x10,%esp
  curproc->ofile[gd] = f;
8010444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104451:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104454:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(f);
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	50                   	push   %eax
8010445c:	e8 e6 c7 ff ff       	call   80100c47 <filedup>
  return gd;
80104461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104464:	83 c4 10             	add    $0x10,%esp
}
80104467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
    return -1;
8010446c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104471:	eb f4                	jmp    80104467 <sys_dup2+0x83>
    return -1;
80104473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104478:	eb ed                	jmp    80104467 <sys_dup2+0x83>
    return -1;
8010447a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010447f:	eb e6                	jmp    80104467 <sys_dup2+0x83>

80104481 <sys_read>:
{
80104481:	55                   	push   %ebp
80104482:	89 e5                	mov    %esp,%ebp
80104484:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104487:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010448a:	ba 00 00 00 00       	mov    $0x0,%edx
8010448f:	b8 00 00 00 00       	mov    $0x0,%eax
80104494:	e8 ae fc ff ff       	call   80104147 <argfd>
80104499:	85 c0                	test   %eax,%eax
8010449b:	78 43                	js     801044e0 <sys_read+0x5f>
8010449d:	83 ec 08             	sub    $0x8,%esp
801044a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044a3:	50                   	push   %eax
801044a4:	6a 02                	push   $0x2
801044a6:	e8 82 fb ff ff       	call   8010402d <argint>
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	85 c0                	test   %eax,%eax
801044b0:	78 2e                	js     801044e0 <sys_read+0x5f>
801044b2:	83 ec 04             	sub    $0x4,%esp
801044b5:	ff 75 f0             	push   -0x10(%ebp)
801044b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044bb:	50                   	push   %eax
801044bc:	6a 01                	push   $0x1
801044be:	e8 92 fb ff ff       	call   80104055 <argptr>
801044c3:	83 c4 10             	add    $0x10,%esp
801044c6:	85 c0                	test   %eax,%eax
801044c8:	78 16                	js     801044e0 <sys_read+0x5f>
  return fileread(f, p, n);
801044ca:	83 ec 04             	sub    $0x4,%esp
801044cd:	ff 75 f0             	push   -0x10(%ebp)
801044d0:	ff 75 ec             	push   -0x14(%ebp)
801044d3:	ff 75 f4             	push   -0xc(%ebp)
801044d6:	e8 a8 c8 ff ff       	call   80100d83 <fileread>
801044db:	83 c4 10             	add    $0x10,%esp
}
801044de:	c9                   	leave  
801044df:	c3                   	ret    
    return -1;
801044e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e5:	eb f7                	jmp    801044de <sys_read+0x5d>

801044e7 <sys_write>:
{
801044e7:	55                   	push   %ebp
801044e8:	89 e5                	mov    %esp,%ebp
801044ea:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
801044ed:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044f0:	ba 00 00 00 00       	mov    $0x0,%edx
801044f5:	b8 00 00 00 00       	mov    $0x0,%eax
801044fa:	e8 48 fc ff ff       	call   80104147 <argfd>
801044ff:	85 c0                	test   %eax,%eax
80104501:	78 43                	js     80104546 <sys_write+0x5f>
80104503:	83 ec 08             	sub    $0x8,%esp
80104506:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104509:	50                   	push   %eax
8010450a:	6a 02                	push   $0x2
8010450c:	e8 1c fb ff ff       	call   8010402d <argint>
80104511:	83 c4 10             	add    $0x10,%esp
80104514:	85 c0                	test   %eax,%eax
80104516:	78 2e                	js     80104546 <sys_write+0x5f>
80104518:	83 ec 04             	sub    $0x4,%esp
8010451b:	ff 75 f0             	push   -0x10(%ebp)
8010451e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104521:	50                   	push   %eax
80104522:	6a 01                	push   $0x1
80104524:	e8 2c fb ff ff       	call   80104055 <argptr>
80104529:	83 c4 10             	add    $0x10,%esp
8010452c:	85 c0                	test   %eax,%eax
8010452e:	78 16                	js     80104546 <sys_write+0x5f>
  return filewrite(f, p, n);
80104530:	83 ec 04             	sub    $0x4,%esp
80104533:	ff 75 f0             	push   -0x10(%ebp)
80104536:	ff 75 ec             	push   -0x14(%ebp)
80104539:	ff 75 f4             	push   -0xc(%ebp)
8010453c:	e8 c7 c8 ff ff       	call   80100e08 <filewrite>
80104541:	83 c4 10             	add    $0x10,%esp
}
80104544:	c9                   	leave  
80104545:	c3                   	ret    
    return -1;
80104546:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010454b:	eb f7                	jmp    80104544 <sys_write+0x5d>

8010454d <sys_close>:
{
8010454d:	55                   	push   %ebp
8010454e:	89 e5                	mov    %esp,%ebp
80104550:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104553:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104556:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104559:	b8 00 00 00 00       	mov    $0x0,%eax
8010455e:	e8 e4 fb ff ff       	call   80104147 <argfd>
80104563:	85 c0                	test   %eax,%eax
80104565:	78 25                	js     8010458c <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104567:	e8 ae ed ff ff       	call   8010331a <myproc>
8010456c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010456f:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104576:	00 
  fileclose(f);
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	ff 75 f0             	push   -0x10(%ebp)
8010457d:	e8 08 c7 ff ff       	call   80100c8a <fileclose>
  return 0;
80104582:	83 c4 10             	add    $0x10,%esp
80104585:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010458a:	c9                   	leave  
8010458b:	c3                   	ret    
    return -1;
8010458c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104591:	eb f7                	jmp    8010458a <sys_close+0x3d>

80104593 <sys_fstat>:
{
80104593:	55                   	push   %ebp
80104594:	89 e5                	mov    %esp,%ebp
80104596:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104599:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010459c:	ba 00 00 00 00       	mov    $0x0,%edx
801045a1:	b8 00 00 00 00       	mov    $0x0,%eax
801045a6:	e8 9c fb ff ff       	call   80104147 <argfd>
801045ab:	85 c0                	test   %eax,%eax
801045ad:	78 2a                	js     801045d9 <sys_fstat+0x46>
801045af:	83 ec 04             	sub    $0x4,%esp
801045b2:	6a 14                	push   $0x14
801045b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045b7:	50                   	push   %eax
801045b8:	6a 01                	push   $0x1
801045ba:	e8 96 fa ff ff       	call   80104055 <argptr>
801045bf:	83 c4 10             	add    $0x10,%esp
801045c2:	85 c0                	test   %eax,%eax
801045c4:	78 13                	js     801045d9 <sys_fstat+0x46>
  return filestat(f, st);
801045c6:	83 ec 08             	sub    $0x8,%esp
801045c9:	ff 75 f0             	push   -0x10(%ebp)
801045cc:	ff 75 f4             	push   -0xc(%ebp)
801045cf:	e8 68 c7 ff ff       	call   80100d3c <filestat>
801045d4:	83 c4 10             	add    $0x10,%esp
}
801045d7:	c9                   	leave  
801045d8:	c3                   	ret    
    return -1;
801045d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045de:	eb f7                	jmp    801045d7 <sys_fstat+0x44>

801045e0 <sys_link>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801045e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045eb:	50                   	push   %eax
801045ec:	6a 00                	push   $0x0
801045ee:	e8 ca fa ff ff       	call   801040bd <argstr>
801045f3:	83 c4 10             	add    $0x10,%esp
801045f6:	85 c0                	test   %eax,%eax
801045f8:	0f 88 d1 00 00 00    	js     801046cf <sys_link+0xef>
801045fe:	83 ec 08             	sub    $0x8,%esp
80104601:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104604:	50                   	push   %eax
80104605:	6a 01                	push   $0x1
80104607:	e8 b1 fa ff ff       	call   801040bd <argstr>
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	0f 88 b8 00 00 00    	js     801046cf <sys_link+0xef>
  begin_op();
80104617:	e8 c0 e0 ff ff       	call   801026dc <begin_op>
  if((ip = namei(old)) == 0){
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	ff 75 e0             	push   -0x20(%ebp)
80104622:	e8 43 d5 ff ff       	call   80101b6a <namei>
80104627:	89 c3                	mov    %eax,%ebx
80104629:	83 c4 10             	add    $0x10,%esp
8010462c:	85 c0                	test   %eax,%eax
8010462e:	0f 84 a2 00 00 00    	je     801046d6 <sys_link+0xf6>
  ilock(ip);
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	50                   	push   %eax
80104638:	e8 c9 ce ff ff       	call   80101506 <ilock>
  if(ip->type == T_DIR){
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104645:	0f 84 97 00 00 00    	je     801046e2 <sys_link+0x102>
  ip->nlink++;
8010464b:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010464f:	40                   	inc    %eax
80104650:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104654:	83 ec 0c             	sub    $0xc,%esp
80104657:	53                   	push   %ebx
80104658:	e8 50 cd ff ff       	call   801013ad <iupdate>
  iunlock(ip);
8010465d:	89 1c 24             	mov    %ebx,(%esp)
80104660:	e8 61 cf ff ff       	call   801015c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104665:	83 c4 08             	add    $0x8,%esp
80104668:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010466b:	50                   	push   %eax
8010466c:	ff 75 e4             	push   -0x1c(%ebp)
8010466f:	e8 0e d5 ff ff       	call   80101b82 <nameiparent>
80104674:	89 c6                	mov    %eax,%esi
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	85 c0                	test   %eax,%eax
8010467b:	0f 84 85 00 00 00    	je     80104706 <sys_link+0x126>
  ilock(dp);
80104681:	83 ec 0c             	sub    $0xc,%esp
80104684:	50                   	push   %eax
80104685:	e8 7c ce ff ff       	call   80101506 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010468a:	83 c4 10             	add    $0x10,%esp
8010468d:	8b 03                	mov    (%ebx),%eax
8010468f:	39 06                	cmp    %eax,(%esi)
80104691:	75 67                	jne    801046fa <sys_link+0x11a>
80104693:	83 ec 04             	sub    $0x4,%esp
80104696:	ff 73 04             	push   0x4(%ebx)
80104699:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010469c:	50                   	push   %eax
8010469d:	56                   	push   %esi
8010469e:	e8 16 d4 ff ff       	call   80101ab9 <dirlink>
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	85 c0                	test   %eax,%eax
801046a8:	78 50                	js     801046fa <sys_link+0x11a>
  iunlockput(dp);
801046aa:	83 ec 0c             	sub    $0xc,%esp
801046ad:	56                   	push   %esi
801046ae:	e8 f6 cf ff ff       	call   801016a9 <iunlockput>
  iput(ip);
801046b3:	89 1c 24             	mov    %ebx,(%esp)
801046b6:	e8 50 cf ff ff       	call   8010160b <iput>
  end_op();
801046bb:	e8 98 e0 ff ff       	call   80102758 <end_op>
  return 0;
801046c0:	83 c4 10             	add    $0x10,%esp
801046c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046cb:	5b                   	pop    %ebx
801046cc:	5e                   	pop    %esi
801046cd:	5d                   	pop    %ebp
801046ce:	c3                   	ret    
    return -1;
801046cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d4:	eb f2                	jmp    801046c8 <sys_link+0xe8>
    end_op();
801046d6:	e8 7d e0 ff ff       	call   80102758 <end_op>
    return -1;
801046db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e0:	eb e6                	jmp    801046c8 <sys_link+0xe8>
    iunlockput(ip);
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	53                   	push   %ebx
801046e6:	e8 be cf ff ff       	call   801016a9 <iunlockput>
    end_op();
801046eb:	e8 68 e0 ff ff       	call   80102758 <end_op>
    return -1;
801046f0:	83 c4 10             	add    $0x10,%esp
801046f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f8:	eb ce                	jmp    801046c8 <sys_link+0xe8>
    iunlockput(dp);
801046fa:	83 ec 0c             	sub    $0xc,%esp
801046fd:	56                   	push   %esi
801046fe:	e8 a6 cf ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104703:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	53                   	push   %ebx
8010470a:	e8 f7 cd ff ff       	call   80101506 <ilock>
  ip->nlink--;
8010470f:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104713:	48                   	dec    %eax
80104714:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104718:	89 1c 24             	mov    %ebx,(%esp)
8010471b:	e8 8d cc ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
80104720:	89 1c 24             	mov    %ebx,(%esp)
80104723:	e8 81 cf ff ff       	call   801016a9 <iunlockput>
  end_op();
80104728:	e8 2b e0 ff ff       	call   80102758 <end_op>
  return -1;
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104735:	eb 91                	jmp    801046c8 <sys_link+0xe8>

80104737 <sys_unlink>:
{
80104737:	55                   	push   %ebp
80104738:	89 e5                	mov    %esp,%ebp
8010473a:	57                   	push   %edi
8010473b:	56                   	push   %esi
8010473c:	53                   	push   %ebx
8010473d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104740:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104743:	50                   	push   %eax
80104744:	6a 00                	push   $0x0
80104746:	e8 72 f9 ff ff       	call   801040bd <argstr>
8010474b:	83 c4 10             	add    $0x10,%esp
8010474e:	85 c0                	test   %eax,%eax
80104750:	0f 88 7f 01 00 00    	js     801048d5 <sys_unlink+0x19e>
  begin_op();
80104756:	e8 81 df ff ff       	call   801026dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010475b:	83 ec 08             	sub    $0x8,%esp
8010475e:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104761:	50                   	push   %eax
80104762:	ff 75 c4             	push   -0x3c(%ebp)
80104765:	e8 18 d4 ff ff       	call   80101b82 <nameiparent>
8010476a:	89 c6                	mov    %eax,%esi
8010476c:	83 c4 10             	add    $0x10,%esp
8010476f:	85 c0                	test   %eax,%eax
80104771:	0f 84 eb 00 00 00    	je     80104862 <sys_unlink+0x12b>
  ilock(dp);
80104777:	83 ec 0c             	sub    $0xc,%esp
8010477a:	50                   	push   %eax
8010477b:	e8 86 cd ff ff       	call   80101506 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104780:	83 c4 08             	add    $0x8,%esp
80104783:	68 ce 72 10 80       	push   $0x801072ce
80104788:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010478b:	50                   	push   %eax
8010478c:	e8 96 d1 ff ff       	call   80101927 <namecmp>
80104791:	83 c4 10             	add    $0x10,%esp
80104794:	85 c0                	test   %eax,%eax
80104796:	0f 84 fa 00 00 00    	je     80104896 <sys_unlink+0x15f>
8010479c:	83 ec 08             	sub    $0x8,%esp
8010479f:	68 cd 72 10 80       	push   $0x801072cd
801047a4:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047a7:	50                   	push   %eax
801047a8:	e8 7a d1 ff ff       	call   80101927 <namecmp>
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	85 c0                	test   %eax,%eax
801047b2:	0f 84 de 00 00 00    	je     80104896 <sys_unlink+0x15f>
  if((ip = dirlookup(dp, name, &off)) == 0)
801047b8:	83 ec 04             	sub    $0x4,%esp
801047bb:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047be:	50                   	push   %eax
801047bf:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047c2:	50                   	push   %eax
801047c3:	56                   	push   %esi
801047c4:	e8 73 d1 ff ff       	call   8010193c <dirlookup>
801047c9:	89 c3                	mov    %eax,%ebx
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	85 c0                	test   %eax,%eax
801047d0:	0f 84 c0 00 00 00    	je     80104896 <sys_unlink+0x15f>
  ilock(ip);
801047d6:	83 ec 0c             	sub    $0xc,%esp
801047d9:	50                   	push   %eax
801047da:	e8 27 cd ff ff       	call   80101506 <ilock>
  if(ip->nlink < 1)
801047df:	83 c4 10             	add    $0x10,%esp
801047e2:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047e7:	0f 8e 81 00 00 00    	jle    8010486e <sys_unlink+0x137>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047ed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047f2:	0f 84 83 00 00 00    	je     8010487b <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
801047f8:	83 ec 04             	sub    $0x4,%esp
801047fb:	6a 10                	push   $0x10
801047fd:	6a 00                	push   $0x0
801047ff:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104802:	57                   	push   %edi
80104803:	e8 f2 f5 ff ff       	call   80103dfa <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104808:	6a 10                	push   $0x10
8010480a:	ff 75 c0             	push   -0x40(%ebp)
8010480d:	57                   	push   %edi
8010480e:	56                   	push   %esi
8010480f:	e8 df cf ff ff       	call   801017f3 <writei>
80104814:	83 c4 20             	add    $0x20,%esp
80104817:	83 f8 10             	cmp    $0x10,%eax
8010481a:	0f 85 8e 00 00 00    	jne    801048ae <sys_unlink+0x177>
  if(ip->type == T_DIR){
80104820:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104825:	0f 84 90 00 00 00    	je     801048bb <sys_unlink+0x184>
  iunlockput(dp);
8010482b:	83 ec 0c             	sub    $0xc,%esp
8010482e:	56                   	push   %esi
8010482f:	e8 75 ce ff ff       	call   801016a9 <iunlockput>
  ip->nlink--;
80104834:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104838:	48                   	dec    %eax
80104839:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010483d:	89 1c 24             	mov    %ebx,(%esp)
80104840:	e8 68 cb ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
80104845:	89 1c 24             	mov    %ebx,(%esp)
80104848:	e8 5c ce ff ff       	call   801016a9 <iunlockput>
  end_op();
8010484d:	e8 06 df ff ff       	call   80102758 <end_op>
  return 0;
80104852:	83 c4 10             	add    $0x10,%esp
80104855:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010485a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485d:	5b                   	pop    %ebx
8010485e:	5e                   	pop    %esi
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
    end_op();
80104862:	e8 f1 de ff ff       	call   80102758 <end_op>
    return -1;
80104867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010486c:	eb ec                	jmp    8010485a <sys_unlink+0x123>
    panic("unlink: nlink < 1");
8010486e:	83 ec 0c             	sub    $0xc,%esp
80104871:	68 ec 72 10 80       	push   $0x801072ec
80104876:	e8 c6 ba ff ff       	call   80100341 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010487b:	89 d8                	mov    %ebx,%eax
8010487d:	e8 59 f9 ff ff       	call   801041db <isdirempty>
80104882:	85 c0                	test   %eax,%eax
80104884:	0f 85 6e ff ff ff    	jne    801047f8 <sys_unlink+0xc1>
    iunlockput(ip);
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	53                   	push   %ebx
8010488e:	e8 16 ce ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104893:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	56                   	push   %esi
8010489a:	e8 0a ce ff ff       	call   801016a9 <iunlockput>
  end_op();
8010489f:	e8 b4 de ff ff       	call   80102758 <end_op>
  return -1;
801048a4:	83 c4 10             	add    $0x10,%esp
801048a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ac:	eb ac                	jmp    8010485a <sys_unlink+0x123>
    panic("unlink: writei");
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 fe 72 10 80       	push   $0x801072fe
801048b6:	e8 86 ba ff ff       	call   80100341 <panic>
    dp->nlink--;
801048bb:	66 8b 46 56          	mov    0x56(%esi),%ax
801048bf:	48                   	dec    %eax
801048c0:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801048c4:	83 ec 0c             	sub    $0xc,%esp
801048c7:	56                   	push   %esi
801048c8:	e8 e0 ca ff ff       	call   801013ad <iupdate>
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	e9 56 ff ff ff       	jmp    8010482b <sys_unlink+0xf4>
    return -1;
801048d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048da:	e9 7b ff ff ff       	jmp    8010485a <sys_unlink+0x123>

801048df <sys_open>:

int
sys_open(void)
{
801048df:	55                   	push   %ebp
801048e0:	89 e5                	mov    %esp,%ebp
801048e2:	57                   	push   %edi
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048eb:	50                   	push   %eax
801048ec:	6a 00                	push   $0x0
801048ee:	e8 ca f7 ff ff       	call   801040bd <argstr>
801048f3:	83 c4 10             	add    $0x10,%esp
801048f6:	85 c0                	test   %eax,%eax
801048f8:	0f 88 a0 00 00 00    	js     8010499e <sys_open+0xbf>
801048fe:	83 ec 08             	sub    $0x8,%esp
80104901:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104904:	50                   	push   %eax
80104905:	6a 01                	push   $0x1
80104907:	e8 21 f7 ff ff       	call   8010402d <argint>
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	85 c0                	test   %eax,%eax
80104911:	0f 88 87 00 00 00    	js     8010499e <sys_open+0xbf>
    return -1;

  begin_op();
80104917:	e8 c0 dd ff ff       	call   801026dc <begin_op>

  if(omode & O_CREATE){
8010491c:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104920:	0f 84 8b 00 00 00    	je     801049b1 <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	6a 00                	push   $0x0
8010492b:	b9 00 00 00 00       	mov    $0x0,%ecx
80104930:	ba 02 00 00 00       	mov    $0x2,%edx
80104935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104938:	e8 f5 f8 ff ff       	call   80104232 <create>
8010493d:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	85 c0                	test   %eax,%eax
80104944:	74 5f                	je     801049a5 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104946:	e8 9b c2 ff ff       	call   80100be6 <filealloc>
8010494b:	89 c3                	mov    %eax,%ebx
8010494d:	85 c0                	test   %eax,%eax
8010494f:	0f 84 b5 00 00 00    	je     80104a0a <sys_open+0x12b>
80104955:	e8 4d f8 ff ff       	call   801041a7 <fdalloc>
8010495a:	89 c7                	mov    %eax,%edi
8010495c:	85 c0                	test   %eax,%eax
8010495e:	0f 88 a6 00 00 00    	js     80104a0a <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104964:	83 ec 0c             	sub    $0xc,%esp
80104967:	56                   	push   %esi
80104968:	e8 59 cc ff ff       	call   801015c6 <iunlock>
  end_op();
8010496d:	e8 e6 dd ff ff       	call   80102758 <end_op>

  f->type = FD_INODE;
80104972:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104978:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010497b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104982:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	a8 01                	test   $0x1,%al
8010498a:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010498e:	a8 03                	test   $0x3,%al
80104990:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104994:	89 f8                	mov    %edi,%eax
80104996:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5f                   	pop    %edi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret    
    return -1;
8010499e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a3:	eb ef                	jmp    80104994 <sys_open+0xb5>
      end_op();
801049a5:	e8 ae dd ff ff       	call   80102758 <end_op>
      return -1;
801049aa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049af:	eb e3                	jmp    80104994 <sys_open+0xb5>
    if((ip = namei(path)) == 0){
801049b1:	83 ec 0c             	sub    $0xc,%esp
801049b4:	ff 75 e4             	push   -0x1c(%ebp)
801049b7:	e8 ae d1 ff ff       	call   80101b6a <namei>
801049bc:	89 c6                	mov    %eax,%esi
801049be:	83 c4 10             	add    $0x10,%esp
801049c1:	85 c0                	test   %eax,%eax
801049c3:	74 39                	je     801049fe <sys_open+0x11f>
    ilock(ip);
801049c5:	83 ec 0c             	sub    $0xc,%esp
801049c8:	50                   	push   %eax
801049c9:	e8 38 cb ff ff       	call   80101506 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801049ce:	83 c4 10             	add    $0x10,%esp
801049d1:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801049d6:	0f 85 6a ff ff ff    	jne    80104946 <sys_open+0x67>
801049dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049e0:	0f 84 60 ff ff ff    	je     80104946 <sys_open+0x67>
      iunlockput(ip);
801049e6:	83 ec 0c             	sub    $0xc,%esp
801049e9:	56                   	push   %esi
801049ea:	e8 ba cc ff ff       	call   801016a9 <iunlockput>
      end_op();
801049ef:	e8 64 dd ff ff       	call   80102758 <end_op>
      return -1;
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049fc:	eb 96                	jmp    80104994 <sys_open+0xb5>
      end_op();
801049fe:	e8 55 dd ff ff       	call   80102758 <end_op>
      return -1;
80104a03:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a08:	eb 8a                	jmp    80104994 <sys_open+0xb5>
    if(f)
80104a0a:	85 db                	test   %ebx,%ebx
80104a0c:	74 0c                	je     80104a1a <sys_open+0x13b>
      fileclose(f);
80104a0e:	83 ec 0c             	sub    $0xc,%esp
80104a11:	53                   	push   %ebx
80104a12:	e8 73 c2 ff ff       	call   80100c8a <fileclose>
80104a17:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
80104a1d:	56                   	push   %esi
80104a1e:	e8 86 cc ff ff       	call   801016a9 <iunlockput>
    end_op();
80104a23:	e8 30 dd ff ff       	call   80102758 <end_op>
    return -1;
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a30:	e9 5f ff ff ff       	jmp    80104994 <sys_open+0xb5>

80104a35 <sys_mkdir>:

int
sys_mkdir(void)
{
80104a35:	55                   	push   %ebp
80104a36:	89 e5                	mov    %esp,%ebp
80104a38:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a3b:	e8 9c dc ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a40:	83 ec 08             	sub    $0x8,%esp
80104a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a46:	50                   	push   %eax
80104a47:	6a 00                	push   $0x0
80104a49:	e8 6f f6 ff ff       	call   801040bd <argstr>
80104a4e:	83 c4 10             	add    $0x10,%esp
80104a51:	85 c0                	test   %eax,%eax
80104a53:	78 36                	js     80104a8b <sys_mkdir+0x56>
80104a55:	83 ec 0c             	sub    $0xc,%esp
80104a58:	6a 00                	push   $0x0
80104a5a:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a5f:	ba 01 00 00 00       	mov    $0x1,%edx
80104a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a67:	e8 c6 f7 ff ff       	call   80104232 <create>
80104a6c:	83 c4 10             	add    $0x10,%esp
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	74 18                	je     80104a8b <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a73:	83 ec 0c             	sub    $0xc,%esp
80104a76:	50                   	push   %eax
80104a77:	e8 2d cc ff ff       	call   801016a9 <iunlockput>
  end_op();
80104a7c:	e8 d7 dc ff ff       	call   80102758 <end_op>
  return 0;
80104a81:	83 c4 10             	add    $0x10,%esp
80104a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a89:	c9                   	leave  
80104a8a:	c3                   	ret    
    end_op();
80104a8b:	e8 c8 dc ff ff       	call   80102758 <end_op>
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb f2                	jmp    80104a89 <sys_mkdir+0x54>

80104a97 <sys_mknod>:

int
sys_mknod(void)
{
80104a97:	55                   	push   %ebp
80104a98:	89 e5                	mov    %esp,%ebp
80104a9a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a9d:	e8 3a dc ff ff       	call   801026dc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104aa2:	83 ec 08             	sub    $0x8,%esp
80104aa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa8:	50                   	push   %eax
80104aa9:	6a 00                	push   $0x0
80104aab:	e8 0d f6 ff ff       	call   801040bd <argstr>
80104ab0:	83 c4 10             	add    $0x10,%esp
80104ab3:	85 c0                	test   %eax,%eax
80104ab5:	78 62                	js     80104b19 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104ab7:	83 ec 08             	sub    $0x8,%esp
80104aba:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104abd:	50                   	push   %eax
80104abe:	6a 01                	push   $0x1
80104ac0:	e8 68 f5 ff ff       	call   8010402d <argint>
  if((argstr(0, &path)) < 0 ||
80104ac5:	83 c4 10             	add    $0x10,%esp
80104ac8:	85 c0                	test   %eax,%eax
80104aca:	78 4d                	js     80104b19 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104acc:	83 ec 08             	sub    $0x8,%esp
80104acf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ad2:	50                   	push   %eax
80104ad3:	6a 02                	push   $0x2
80104ad5:	e8 53 f5 ff ff       	call   8010402d <argint>
     argint(1, &major) < 0 ||
80104ada:	83 c4 10             	add    $0x10,%esp
80104add:	85 c0                	test   %eax,%eax
80104adf:	78 38                	js     80104b19 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104ae1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104ae5:	83 ec 0c             	sub    $0xc,%esp
80104ae8:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104aec:	50                   	push   %eax
80104aed:	ba 03 00 00 00       	mov    $0x3,%edx
80104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af5:	e8 38 f7 ff ff       	call   80104232 <create>
     argint(2, &minor) < 0 ||
80104afa:	83 c4 10             	add    $0x10,%esp
80104afd:	85 c0                	test   %eax,%eax
80104aff:	74 18                	je     80104b19 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104b01:	83 ec 0c             	sub    $0xc,%esp
80104b04:	50                   	push   %eax
80104b05:	e8 9f cb ff ff       	call   801016a9 <iunlockput>
  end_op();
80104b0a:	e8 49 dc ff ff       	call   80102758 <end_op>
  return 0;
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b17:	c9                   	leave  
80104b18:	c3                   	ret    
    end_op();
80104b19:	e8 3a dc ff ff       	call   80102758 <end_op>
    return -1;
80104b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b23:	eb f2                	jmp    80104b17 <sys_mknod+0x80>

80104b25 <sys_chdir>:

int
sys_chdir(void)
{
80104b25:	55                   	push   %ebp
80104b26:	89 e5                	mov    %esp,%ebp
80104b28:	56                   	push   %esi
80104b29:	53                   	push   %ebx
80104b2a:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104b2d:	e8 e8 e7 ff ff       	call   8010331a <myproc>
80104b32:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104b34:	e8 a3 db ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104b39:	83 ec 08             	sub    $0x8,%esp
80104b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b3f:	50                   	push   %eax
80104b40:	6a 00                	push   $0x0
80104b42:	e8 76 f5 ff ff       	call   801040bd <argstr>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	78 52                	js     80104ba0 <sys_chdir+0x7b>
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	ff 75 f4             	push   -0xc(%ebp)
80104b54:	e8 11 d0 ff ff       	call   80101b6a <namei>
80104b59:	89 c3                	mov    %eax,%ebx
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	85 c0                	test   %eax,%eax
80104b60:	74 3e                	je     80104ba0 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	50                   	push   %eax
80104b66:	e8 9b c9 ff ff       	call   80101506 <ilock>
  if(ip->type != T_DIR){
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b73:	75 37                	jne    80104bac <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	53                   	push   %ebx
80104b79:	e8 48 ca ff ff       	call   801015c6 <iunlock>
  iput(curproc->cwd);
80104b7e:	83 c4 04             	add    $0x4,%esp
80104b81:	ff 76 68             	push   0x68(%esi)
80104b84:	e8 82 ca ff ff       	call   8010160b <iput>
  end_op();
80104b89:	e8 ca db ff ff       	call   80102758 <end_op>
  curproc->cwd = ip;
80104b8e:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b91:	83 c4 10             	add    $0x10,%esp
80104b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b9c:	5b                   	pop    %ebx
80104b9d:	5e                   	pop    %esi
80104b9e:	5d                   	pop    %ebp
80104b9f:	c3                   	ret    
    end_op();
80104ba0:	e8 b3 db ff ff       	call   80102758 <end_op>
    return -1;
80104ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104baa:	eb ed                	jmp    80104b99 <sys_chdir+0x74>
    iunlockput(ip);
80104bac:	83 ec 0c             	sub    $0xc,%esp
80104baf:	53                   	push   %ebx
80104bb0:	e8 f4 ca ff ff       	call   801016a9 <iunlockput>
    end_op();
80104bb5:	e8 9e db ff ff       	call   80102758 <end_op>
    return -1;
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc2:	eb d5                	jmp    80104b99 <sys_chdir+0x74>

80104bc4 <sys_exec>:

int
sys_exec(void)
{
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	53                   	push   %ebx
80104bc8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104bce:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bd1:	50                   	push   %eax
80104bd2:	6a 00                	push   $0x0
80104bd4:	e8 e4 f4 ff ff       	call   801040bd <argstr>
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	78 38                	js     80104c18 <sys_exec+0x54>
80104be0:	83 ec 08             	sub    $0x8,%esp
80104be3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104be9:	50                   	push   %eax
80104bea:	6a 01                	push   $0x1
80104bec:	e8 3c f4 ff ff       	call   8010402d <argint>
80104bf1:	83 c4 10             	add    $0x10,%esp
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	78 20                	js     80104c18 <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bf8:	83 ec 04             	sub    $0x4,%esp
80104bfb:	68 80 00 00 00       	push   $0x80
80104c00:	6a 00                	push   $0x0
80104c02:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c08:	50                   	push   %eax
80104c09:	e8 ec f1 ff ff       	call   80103dfa <memset>
80104c0e:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104c11:	bb 00 00 00 00       	mov    $0x0,%ebx
80104c16:	eb 2a                	jmp    80104c42 <sys_exec+0x7e>
    return -1;
80104c18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c1d:	eb 76                	jmp    80104c95 <sys_exec+0xd1>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104c1f:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104c26:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104c2a:	83 ec 08             	sub    $0x8,%esp
80104c2d:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c33:	50                   	push   %eax
80104c34:	ff 75 f4             	push   -0xc(%ebp)
80104c37:	e8 54 bc ff ff       	call   80100890 <exec>
80104c3c:	83 c4 10             	add    $0x10,%esp
80104c3f:	eb 54                	jmp    80104c95 <sys_exec+0xd1>
  for(i=0;; i++){
80104c41:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104c42:	83 fb 1f             	cmp    $0x1f,%ebx
80104c45:	77 49                	ja     80104c90 <sys_exec+0xcc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104c47:	83 ec 08             	sub    $0x8,%esp
80104c4a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104c50:	50                   	push   %eax
80104c51:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104c57:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104c5a:	50                   	push   %eax
80104c5b:	e8 55 f3 ff ff       	call   80103fb5 <fetchint>
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	85 c0                	test   %eax,%eax
80104c65:	78 33                	js     80104c9a <sys_exec+0xd6>
    if(uarg == 0){
80104c67:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	74 ae                	je     80104c1f <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104c71:	83 ec 08             	sub    $0x8,%esp
80104c74:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c7b:	52                   	push   %edx
80104c7c:	50                   	push   %eax
80104c7d:	e8 6e f3 ff ff       	call   80103ff0 <fetchstr>
80104c82:	83 c4 10             	add    $0x10,%esp
80104c85:	85 c0                	test   %eax,%eax
80104c87:	79 b8                	jns    80104c41 <sys_exec+0x7d>
      return -1;
80104c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8e:	eb 05                	jmp    80104c95 <sys_exec+0xd1>
      return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c98:	c9                   	leave  
80104c99:	c3                   	ret    
      return -1;
80104c9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9f:	eb f4                	jmp    80104c95 <sys_exec+0xd1>

80104ca1 <sys_pipe>:

int
sys_pipe(void)
{
80104ca1:	55                   	push   %ebp
80104ca2:	89 e5                	mov    %esp,%ebp
80104ca4:	53                   	push   %ebx
80104ca5:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104ca8:	6a 08                	push   $0x8
80104caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cad:	50                   	push   %eax
80104cae:	6a 00                	push   $0x0
80104cb0:	e8 a0 f3 ff ff       	call   80104055 <argptr>
80104cb5:	83 c4 10             	add    $0x10,%esp
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	78 79                	js     80104d35 <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104cbc:	83 ec 08             	sub    $0x8,%esp
80104cbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cc2:	50                   	push   %eax
80104cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cc6:	50                   	push   %eax
80104cc7:	e8 87 df ff ff       	call   80102c53 <pipealloc>
80104ccc:	83 c4 10             	add    $0x10,%esp
80104ccf:	85 c0                	test   %eax,%eax
80104cd1:	78 69                	js     80104d3c <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd6:	e8 cc f4 ff ff       	call   801041a7 <fdalloc>
80104cdb:	89 c3                	mov    %eax,%ebx
80104cdd:	85 c0                	test   %eax,%eax
80104cdf:	78 21                	js     80104d02 <sys_pipe+0x61>
80104ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ce4:	e8 be f4 ff ff       	call   801041a7 <fdalloc>
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	78 15                	js     80104d02 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf0:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf5:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d00:	c9                   	leave  
80104d01:	c3                   	ret    
    if(fd0 >= 0)
80104d02:	85 db                	test   %ebx,%ebx
80104d04:	79 20                	jns    80104d26 <sys_pipe+0x85>
    fileclose(rf);
80104d06:	83 ec 0c             	sub    $0xc,%esp
80104d09:	ff 75 f0             	push   -0x10(%ebp)
80104d0c:	e8 79 bf ff ff       	call   80100c8a <fileclose>
    fileclose(wf);
80104d11:	83 c4 04             	add    $0x4,%esp
80104d14:	ff 75 ec             	push   -0x14(%ebp)
80104d17:	e8 6e bf ff ff       	call   80100c8a <fileclose>
    return -1;
80104d1c:	83 c4 10             	add    $0x10,%esp
80104d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d24:	eb d7                	jmp    80104cfd <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104d26:	e8 ef e5 ff ff       	call   8010331a <myproc>
80104d2b:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d32:	00 
80104d33:	eb d1                	jmp    80104d06 <sys_pipe+0x65>
    return -1;
80104d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3a:	eb c1                	jmp    80104cfd <sys_pipe+0x5c>
    return -1;
80104d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d41:	eb ba                	jmp    80104cfd <sys_pipe+0x5c>

80104d43 <sys_fork>:

pte_t *	walkpgdir(pde_t *pgdir, const void *va, int alloc);

int
sys_fork(void)
{
80104d43:	55                   	push   %ebp
80104d44:	89 e5                	mov    %esp,%ebp
80104d46:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d49:	e8 58 e7 ff ff       	call   801034a6 <fork>
}
80104d4e:	c9                   	leave  
80104d4f:	c3                   	ret    

80104d50 <sys_exit>:

int
sys_exit(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 20             	sub    $0x20,%esp
  int i;
  if(argint(0, &i) < 0)
80104d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d59:	50                   	push   %eax
80104d5a:	6a 00                	push   $0x0
80104d5c:	e8 cc f2 ff ff       	call   8010402d <argint>
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	85 c0                	test   %eax,%eax
80104d66:	78 1c                	js     80104d84 <sys_exit+0x34>
   return -1;
  i = (i << 8);
80104d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6b:	c1 e0 08             	shl    $0x8,%eax
80104d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  exit(i);
80104d71:	83 ec 0c             	sub    $0xc,%esp
80104d74:	50                   	push   %eax
80104d75:	e8 8e e9 ff ff       	call   80103708 <exit>
  return 0;  // not reached
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    
   return -1;
80104d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d89:	eb f7                	jmp    80104d82 <sys_exit+0x32>

80104d8b <sys_wait>:

int
sys_wait(void)
{
80104d8b:	55                   	push   %ebp
80104d8c:	89 e5                	mov    %esp,%ebp
80104d8e:	83 ec 1c             	sub    $0x1c,%esp
  int* i;
  
  if(argptr(0, (void**)&i, sizeof(*i)) < 0)
80104d91:	6a 04                	push   $0x4
80104d93:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d96:	50                   	push   %eax
80104d97:	6a 00                	push   $0x0
80104d99:	e8 b7 f2 ff ff       	call   80104055 <argptr>
80104d9e:	83 c4 10             	add    $0x10,%esp
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 10                	js     80104db5 <sys_wait+0x2a>
    return -1;
 
  return wait(i);
80104da5:	83 ec 0c             	sub    $0xc,%esp
80104da8:	ff 75 f4             	push   -0xc(%ebp)
80104dab:	e8 17 eb ff ff       	call   801038c7 <wait>
80104db0:	83 c4 10             	add    $0x10,%esp
}
80104db3:	c9                   	leave  
80104db4:	c3                   	ret    
    return -1;
80104db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dba:	eb f7                	jmp    80104db3 <sys_wait+0x28>

80104dbc <sys_kill>:

int
sys_kill(void)
{
80104dbc:	55                   	push   %ebp
80104dbd:	89 e5                	mov    %esp,%ebp
80104dbf:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104dc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dc5:	50                   	push   %eax
80104dc6:	6a 00                	push   $0x0
80104dc8:	e8 60 f2 ff ff       	call   8010402d <argint>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	78 10                	js     80104de4 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	ff 75 f4             	push   -0xc(%ebp)
80104dda:	e8 f2 eb ff ff       	call   801039d1 <kill>
80104ddf:	83 c4 10             	add    $0x10,%esp
}
80104de2:	c9                   	leave  
80104de3:	c3                   	ret    
    return -1;
80104de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de9:	eb f7                	jmp    80104de2 <sys_kill+0x26>

80104deb <sys_getpid>:

int
sys_getpid(void)
{
80104deb:	55                   	push   %ebp
80104dec:	89 e5                	mov    %esp,%ebp
80104dee:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104df1:	e8 24 e5 ff ff       	call   8010331a <myproc>
80104df6:	8b 40 10             	mov    0x10(%eax),%eax
}
80104df9:	c9                   	leave  
80104dfa:	c3                   	ret    

80104dfb <sys_sbrk>:

int
sys_sbrk(void)
{
80104dfb:	55                   	push   %ebp
80104dfc:	89 e5                	mov    %esp,%ebp
80104dfe:	57                   	push   %edi
80104dff:	56                   	push   %esi
80104e00:	53                   	push   %ebx
80104e01:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;
  
  if(argint(0, &n) < 0)
80104e04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e07:	50                   	push   %eax
80104e08:	6a 00                	push   $0x0
80104e0a:	e8 1e f2 ff ff       	call   8010402d <argint>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	78 53                	js     80104e69 <sys_sbrk+0x6e>
    return -1;
  
  addr = myproc()->sz;
80104e16:	e8 ff e4 ff ff       	call   8010331a <myproc>
80104e1b:	8b 18                	mov    (%eax),%ebx
80104e1d:	89 de                	mov    %ebx,%esi
  
  myproc()->sz = addr + n;
80104e1f:	89 df                	mov    %ebx,%edi
80104e21:	03 7d e4             	add    -0x1c(%ebp),%edi
80104e24:	e8 f1 e4 ff ff       	call   8010331a <myproc>
80104e29:	89 38                	mov    %edi,(%eax)
    // return -1;
  
  //en casos de n negativa o neutra no parece que entre a trap.c osea que si quiero hacer deallocation tiene que ser aqui digo yo
  //pero hacerlo aqui no seria lazy allocation pero no se donde mas ponerlo de todas formas
  // que se podria argumentar que al contrario que en el caso de reservar memoria que quieres hacerlo cuando lo necesites, despejar memoria querrias hacerlo cuanto antes pero bueno.
  if(n < 0){
80104e2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104e2f:	78 0a                	js     80104e3b <sys_sbrk+0x40>
  }
  
 
  
  return addr;
}
80104e31:	89 f0                	mov    %esi,%eax
80104e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e36:	5b                   	pop    %ebx
80104e37:	5e                   	pop    %esi
80104e38:	5f                   	pop    %edi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
     deallocuvm(myproc()->pgdir, addr, myproc()->sz);
80104e3b:	e8 da e4 ff ff       	call   8010331a <myproc>
80104e40:	8b 38                	mov    (%eax),%edi
80104e42:	e8 d3 e4 ff ff       	call   8010331a <myproc>
80104e47:	83 ec 04             	sub    $0x4,%esp
80104e4a:	57                   	push   %edi
80104e4b:	53                   	push   %ebx
80104e4c:	ff 70 04             	push   0x4(%eax)
80104e4f:	e8 eb 18 00 00       	call   8010673f <deallocuvm>
     lcr3(V2P(myproc()->pgdir));
80104e54:	e8 c1 e4 ff ff       	call   8010331a <myproc>
80104e59:	8b 40 04             	mov    0x4(%eax),%eax
80104e5c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80104e61:	0f 22 d8             	mov    %eax,%cr3
}
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	eb c8                	jmp    80104e31 <sys_sbrk+0x36>
    return -1;
80104e69:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e6e:	eb c1                	jmp    80104e31 <sys_sbrk+0x36>

80104e70 <sys_sleep>:

int
sys_sleep(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	53                   	push   %ebx
80104e74:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104e77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7a:	50                   	push   %eax
80104e7b:	6a 00                	push   $0x0
80104e7d:	e8 ab f1 ff ff       	call   8010402d <argint>
80104e82:	83 c4 10             	add    $0x10,%esp
80104e85:	85 c0                	test   %eax,%eax
80104e87:	78 75                	js     80104efe <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	68 e0 3f 11 80       	push   $0x80113fe0
80104e91:	e8 b8 ee ff ff       	call   80103d4e <acquire>
  ticks0 = ticks;
80104e96:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  while(ticks - ticks0 < n){
80104e9c:	83 c4 10             	add    $0x10,%esp
80104e9f:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104ea4:	29 d8                	sub    %ebx,%eax
80104ea6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104ea9:	73 39                	jae    80104ee4 <sys_sleep+0x74>
    if(myproc()->killed){
80104eab:	e8 6a e4 ff ff       	call   8010331a <myproc>
80104eb0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104eb4:	75 17                	jne    80104ecd <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104eb6:	83 ec 08             	sub    $0x8,%esp
80104eb9:	68 e0 3f 11 80       	push   $0x80113fe0
80104ebe:	68 c0 3f 11 80       	push   $0x80113fc0
80104ec3:	e8 6e e9 ff ff       	call   80103836 <sleep>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	eb d2                	jmp    80104e9f <sys_sleep+0x2f>
      release(&tickslock);
80104ecd:	83 ec 0c             	sub    $0xc,%esp
80104ed0:	68 e0 3f 11 80       	push   $0x80113fe0
80104ed5:	e8 d9 ee ff ff       	call   80103db3 <release>
      return -1;
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee2:	eb 15                	jmp    80104ef9 <sys_sleep+0x89>
  }
  release(&tickslock);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	68 e0 3f 11 80       	push   $0x80113fe0
80104eec:	e8 c2 ee ff ff       	call   80103db3 <release>
  return 0;
80104ef1:	83 c4 10             	add    $0x10,%esp
80104ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ef9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104efc:	c9                   	leave  
80104efd:	c3                   	ret    
    return -1;
80104efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f03:	eb f4                	jmp    80104ef9 <sys_sleep+0x89>

80104f05 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104f05:	55                   	push   %ebp
80104f06:	89 e5                	mov    %esp,%ebp
80104f08:	53                   	push   %ebx
80104f09:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104f0c:	68 e0 3f 11 80       	push   $0x80113fe0
80104f11:	e8 38 ee ff ff       	call   80103d4e <acquire>
  xticks = ticks;
80104f16:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  release(&tickslock);
80104f1c:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104f23:	e8 8b ee ff ff       	call   80103db3 <release>
  return xticks;
}
80104f28:	89 d8                	mov    %ebx,%eax
80104f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f2d:	c9                   	leave  
80104f2e:	c3                   	ret    

80104f2f <sys_date>:

int
sys_date(void)
{
80104f2f:	55                   	push   %ebp
80104f30:	89 e5                	mov    %esp,%ebp
80104f32:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *ptr;
  
  if(argptr(0, (void **) &ptr, sizeof(*ptr)) < 0)
80104f35:	6a 18                	push   $0x18
80104f37:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f3a:	50                   	push   %eax
80104f3b:	6a 00                	push   $0x0
80104f3d:	e8 13 f1 ff ff       	call   80104055 <argptr>
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 15                	js     80104f5e <sys_date+0x2f>
    return -1;
  cmostime(ptr);
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	ff 75 f4             	push   -0xc(%ebp)
80104f4f:	e8 5a d4 ff ff       	call   801023ae <cmostime>
  return 0;
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f5c:	c9                   	leave  
80104f5d:	c3                   	ret    
    return -1;
80104f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f63:	eb f7                	jmp    80104f5c <sys_date+0x2d>

80104f65 <sys_phmem>:

int
sys_phmem(void){
80104f65:	55                   	push   %ebp
80104f66:	89 e5                	mov    %esp,%ebp
80104f68:	57                   	push   %edi
80104f69:	56                   	push   %esi
80104f6a:	53                   	push   %ebx
80104f6b:	83 ec 24             	sub    $0x24,%esp
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
80104f6e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f71:	50                   	push   %eax
80104f72:	6a 00                	push   $0x0
80104f74:	e8 b4 f0 ff ff       	call   8010402d <argint>
80104f79:	83 c4 10             	add    $0x10,%esp
80104f7c:	85 c0                	test   %eax,%eax
80104f7e:	78 78                	js     80104ff8 <sys_phmem+0x93>
    return -1;
  if((p = getProcbyPID(pid)) == 0){
80104f80:	83 ec 0c             	sub    $0xc,%esp
80104f83:	ff 75 e4             	push   -0x1c(%ebp)
80104f86:	e8 cd e1 ff ff       	call   80103158 <getProcbyPID>
80104f8b:	89 c6                	mov    %eax,%esi
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	74 0c                	je     80104fa0 <sys_phmem+0x3b>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  int count = 0;
  pte_t *pte;
  uint a = 0;
80104f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  int count = 0;
80104f99:	bf 00 00 00 00       	mov    $0x0,%edi
80104f9e:	eb 1d                	jmp    80104fbd <sys_phmem+0x58>
  	cprintf("No existe un proceso con esa PID\n");
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	68 10 73 10 80       	push   $0x80107310
80104fa8:	e8 2d b6 ff ff       	call   801005da <cprintf>
  	return -1;
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104fb5:	eb 37                	jmp    80104fee <sys_phmem+0x89>
  for(; a  <= p->sz ; a += PGSIZE){
80104fb7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80104fbd:	39 1e                	cmp    %ebx,(%esi)
80104fbf:	72 19                	jb     80104fda <sys_phmem+0x75>
    pte = walkpgdir(p->pgdir, (char*)a, 0);
80104fc1:	83 ec 04             	sub    $0x4,%esp
80104fc4:	6a 00                	push   $0x0
80104fc6:	53                   	push   %ebx
80104fc7:	ff 76 04             	push   0x4(%esi)
80104fca:	e8 13 14 00 00       	call   801063e2 <walkpgdir>
    
    if((*pte & PTE_P) != 0){
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	f6 00 01             	testb  $0x1,(%eax)
80104fd5:	74 e0                	je     80104fb7 <sys_phmem+0x52>
      count++;
80104fd7:	47                   	inc    %edi
80104fd8:	eb dd                	jmp    80104fb7 <sys_phmem+0x52>
    }
  }
  
  uint end = (count*PGSIZE)/1024;
80104fda:	c1 e7 02             	shl    $0x2,%edi
  cprintf("%d", end);
80104fdd:	83 ec 08             	sub    $0x8,%esp
80104fe0:	57                   	push   %edi
80104fe1:	68 32 73 10 80       	push   $0x80107332
80104fe6:	e8 ef b5 ff ff       	call   801005da <cprintf>
  
  return end;
80104feb:	83 c4 10             	add    $0x10,%esp
}
80104fee:	89 f8                	mov    %edi,%eax
80104ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ff3:	5b                   	pop    %ebx
80104ff4:	5e                   	pop    %esi
80104ff5:	5f                   	pop    %edi
80104ff6:	5d                   	pop    %ebp
80104ff7:	c3                   	ret    
    return -1;
80104ff8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ffd:	eb ef                	jmp    80104fee <sys_phmem+0x89>

80104fff <sys_getprio>:

int
sys_getprio(void){
80104fff:	55                   	push   %ebp
80105000:	89 e5                	mov    %esp,%ebp
80105002:	83 ec 20             	sub    $0x20,%esp
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105008:	50                   	push   %eax
80105009:	6a 00                	push   $0x0
8010500b:	e8 1d f0 ff ff       	call   8010402d <argint>
80105010:	83 c4 10             	add    $0x10,%esp
80105013:	85 c0                	test   %eax,%eax
80105015:	78 31                	js     80105048 <sys_getprio+0x49>
    return -1;
  if((p = getProcbyPID(pid)) == 0){
80105017:	83 ec 0c             	sub    $0xc,%esp
8010501a:	ff 75 f4             	push   -0xc(%ebp)
8010501d:	e8 36 e1 ff ff       	call   80103158 <getProcbyPID>
80105022:	83 c4 10             	add    $0x10,%esp
80105025:	85 c0                	test   %eax,%eax
80105027:	74 08                	je     80105031 <sys_getprio+0x32>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  
  return p->prio;
80105029:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010502f:	c9                   	leave  
80105030:	c3                   	ret    
  	cprintf("No existe un proceso con esa PID\n");
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	68 10 73 10 80       	push   $0x80107310
80105039:	e8 9c b5 ff ff       	call   801005da <cprintf>
  	return -1;
8010503e:	83 c4 10             	add    $0x10,%esp
80105041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105046:	eb e7                	jmp    8010502f <sys_getprio+0x30>
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb e0                	jmp    8010502f <sys_getprio+0x30>

8010504f <sys_setprio>:

int
sys_setprio(void){
8010504f:	55                   	push   %ebp
80105050:	89 e5                	mov    %esp,%ebp
80105052:	56                   	push   %esi
80105053:	53                   	push   %ebx
80105054:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *p;
  int trampas;
  unsigned int a;
  if(argint(0, &pid) < 0)
80105057:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505a:	50                   	push   %eax
8010505b:	6a 00                	push   $0x0
8010505d:	e8 cb ef ff ff       	call   8010402d <argint>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	78 6b                	js     801050d4 <sys_setprio+0x85>
    return -1;
    
  if(argint(1, &trampas) < 0)
80105069:	83 ec 08             	sub    $0x8,%esp
8010506c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010506f:	50                   	push   %eax
80105070:	6a 01                	push   $0x1
80105072:	e8 b6 ef ff ff       	call   8010402d <argint>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 5d                	js     801050db <sys_setprio+0x8c>
    return -1;
  a = trampas;
8010507e:	8b 75 f0             	mov    -0x10(%ebp),%esi
  if((p = getProcbyPID(pid)) == 0){
80105081:	83 ec 0c             	sub    $0xc,%esp
80105084:	ff 75 f4             	push   -0xc(%ebp)
80105087:	e8 cc e0 ff ff       	call   80103158 <getProcbyPID>
8010508c:	89 c3                	mov    %eax,%ebx
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	85 c0                	test   %eax,%eax
80105093:	74 19                	je     801050ae <sys_setprio+0x5f>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  if(p->state == RUNNABLE){
80105095:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105099:	74 2a                	je     801050c5 <sys_setprio+0x76>
  	setNewPrio(p, a);
  } else {
  	p->prio = a;
8010509b:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  }
  
  return p->prio;
801050a1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
801050a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050aa:	5b                   	pop    %ebx
801050ab:	5e                   	pop    %esi
801050ac:	5d                   	pop    %ebp
801050ad:	c3                   	ret    
  	cprintf("No existe un proceso con esa PID\n");
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	68 10 73 10 80       	push   $0x80107310
801050b6:	e8 1f b5 ff ff       	call   801005da <cprintf>
  	return -1;
801050bb:	83 c4 10             	add    $0x10,%esp
801050be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c3:	eb e2                	jmp    801050a7 <sys_setprio+0x58>
  	setNewPrio(p, a);
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	56                   	push   %esi
801050c9:	50                   	push   %eax
801050ca:	e8 ec e0 ff ff       	call   801031bb <setNewPrio>
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	eb cd                	jmp    801050a1 <sys_setprio+0x52>
    return -1;
801050d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d9:	eb cc                	jmp    801050a7 <sys_setprio+0x58>
    return -1;
801050db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e0:	eb c5                	jmp    801050a7 <sys_setprio+0x58>

801050e2 <alltraps>:
801050e2:	1e                   	push   %ds
801050e3:	06                   	push   %es
801050e4:	0f a0                	push   %fs
801050e6:	0f a8                	push   %gs
801050e8:	60                   	pusha  
801050e9:	66 b8 10 00          	mov    $0x10,%ax
801050ed:	8e d8                	mov    %eax,%ds
801050ef:	8e c0                	mov    %eax,%es
801050f1:	54                   	push   %esp
801050f2:	e8 2f 01 00 00       	call   80105226 <trap>
801050f7:	83 c4 04             	add    $0x4,%esp

801050fa <trapret>:
801050fa:	61                   	popa   
801050fb:	0f a9                	pop    %gs
801050fd:	0f a1                	pop    %fs
801050ff:	07                   	pop    %es
80105100:	1f                   	pop    %ds
80105101:	83 c4 08             	add    $0x8,%esp
80105104:	cf                   	iret   

80105105 <tvinit>:
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
tvinit(void)
{
80105105:	55                   	push   %ebp
80105106:	89 e5                	mov    %esp,%ebp
80105108:	53                   	push   %ebx
80105109:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
8010510c:	b8 00 00 00 00       	mov    $0x0,%eax
80105111:	eb 72                	jmp    80105185 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105113:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
8010511a:	66 89 0c c5 20 40 11 	mov    %cx,-0x7feebfe0(,%eax,8)
80105121:	80 
80105122:	66 c7 04 c5 22 40 11 	movw   $0x8,-0x7feebfde(,%eax,8)
80105129:	80 08 00 
8010512c:	8a 14 c5 24 40 11 80 	mov    -0x7feebfdc(,%eax,8),%dl
80105133:	83 e2 e0             	and    $0xffffffe0,%edx
80105136:	88 14 c5 24 40 11 80 	mov    %dl,-0x7feebfdc(,%eax,8)
8010513d:	c6 04 c5 24 40 11 80 	movb   $0x0,-0x7feebfdc(,%eax,8)
80105144:	00 
80105145:	8a 14 c5 25 40 11 80 	mov    -0x7feebfdb(,%eax,8),%dl
8010514c:	83 e2 f0             	and    $0xfffffff0,%edx
8010514f:	83 ca 0e             	or     $0xe,%edx
80105152:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105159:	88 d3                	mov    %dl,%bl
8010515b:	83 e3 ef             	and    $0xffffffef,%ebx
8010515e:	88 1c c5 25 40 11 80 	mov    %bl,-0x7feebfdb(,%eax,8)
80105165:	83 e2 8f             	and    $0xffffff8f,%edx
80105168:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
8010516f:	83 ca 80             	or     $0xffffff80,%edx
80105172:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105179:	c1 e9 10             	shr    $0x10,%ecx
8010517c:	66 89 0c c5 26 40 11 	mov    %cx,-0x7feebfda(,%eax,8)
80105183:	80 
  for(i = 0; i < 256; i++)
80105184:	40                   	inc    %eax
80105185:	3d ff 00 00 00       	cmp    $0xff,%eax
8010518a:	7e 87                	jle    80105113 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010518c:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80105192:	66 89 15 20 42 11 80 	mov    %dx,0x80114220
80105199:	66 c7 05 22 42 11 80 	movw   $0x8,0x80114222
801051a0:	08 00 
801051a2:	a0 24 42 11 80       	mov    0x80114224,%al
801051a7:	83 e0 e0             	and    $0xffffffe0,%eax
801051aa:	a2 24 42 11 80       	mov    %al,0x80114224
801051af:	c6 05 24 42 11 80 00 	movb   $0x0,0x80114224
801051b6:	a0 25 42 11 80       	mov    0x80114225,%al
801051bb:	83 c8 0f             	or     $0xf,%eax
801051be:	a2 25 42 11 80       	mov    %al,0x80114225
801051c3:	83 e0 ef             	and    $0xffffffef,%eax
801051c6:	a2 25 42 11 80       	mov    %al,0x80114225
801051cb:	88 c1                	mov    %al,%cl
801051cd:	83 c9 60             	or     $0x60,%ecx
801051d0:	88 0d 25 42 11 80    	mov    %cl,0x80114225
801051d6:	83 c8 e0             	or     $0xffffffe0,%eax
801051d9:	a2 25 42 11 80       	mov    %al,0x80114225
801051de:	c1 ea 10             	shr    $0x10,%edx
801051e1:	66 89 15 26 42 11 80 	mov    %dx,0x80114226

  initlock(&tickslock, "time");
801051e8:	83 ec 08             	sub    $0x8,%esp
801051eb:	68 35 73 10 80       	push   $0x80107335
801051f0:	68 e0 3f 11 80       	push   $0x80113fe0
801051f5:	e8 1d ea ff ff       	call   80103c17 <initlock>
}
801051fa:	83 c4 10             	add    $0x10,%esp
801051fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105200:	c9                   	leave  
80105201:	c3                   	ret    

80105202 <idtinit>:

void
idtinit(void)
{
80105202:	55                   	push   %ebp
80105203:	89 e5                	mov    %esp,%ebp
80105205:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105208:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010520e:	b8 20 40 11 80       	mov    $0x80114020,%eax
80105213:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105217:	c1 e8 10             	shr    $0x10,%eax
8010521a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010521e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105221:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105224:	c9                   	leave  
80105225:	c3                   	ret    

80105226 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105226:	55                   	push   %ebp
80105227:	89 e5                	mov    %esp,%ebp
80105229:	57                   	push   %edi
8010522a:	56                   	push   %esi
8010522b:	53                   	push   %ebx
8010522c:	83 ec 1c             	sub    $0x1c,%esp
8010522f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  
  if(tf->trapno == T_SYSCALL){
80105232:	8b 43 30             	mov    0x30(%ebx),%eax
80105235:	83 f8 40             	cmp    $0x40,%eax
80105238:	74 13                	je     8010524d <trap+0x27>
    if(myproc()->killed)
      exit(0);
    return;
  }

  switch(tf->trapno){
8010523a:	83 e8 0e             	sub    $0xe,%eax
8010523d:	83 f8 31             	cmp    $0x31,%eax
80105240:	0f 87 78 02 00 00    	ja     801054be <trap+0x298>
80105246:	ff 24 85 70 74 10 80 	jmp    *-0x7fef8b90(,%eax,4)
    if(myproc()->killed)
8010524d:	e8 c8 e0 ff ff       	call   8010331a <myproc>
80105252:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105256:	75 2b                	jne    80105283 <trap+0x5d>
    myproc()->tf = tf;
80105258:	e8 bd e0 ff ff       	call   8010331a <myproc>
8010525d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105260:	e8 8b ee ff ff       	call   801040f0 <syscall>
    if(myproc()->killed)
80105265:	e8 b0 e0 ff ff       	call   8010331a <myproc>
8010526a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010526e:	0f 84 8c 00 00 00    	je     80105300 <trap+0xda>
      exit(0);
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	6a 00                	push   $0x0
80105279:	e8 8a e4 ff ff       	call   80103708 <exit>
8010527e:	83 c4 10             	add    $0x10,%esp
    return;
80105281:	eb 7d                	jmp    80105300 <trap+0xda>
      exit(0);
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	6a 00                	push   $0x0
80105288:	e8 7b e4 ff ff       	call   80103708 <exit>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	eb c6                	jmp    80105258 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105292:	e8 52 e0 ff ff       	call   801032e9 <cpuid>
80105297:	85 c0                	test   %eax,%eax
80105299:	74 6d                	je     80105308 <trap+0xe2>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010529b:	e8 59 d0 ff ff       	call   801022f9 <lapiceoi>
  }
  
  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
801052a0:	e8 75 e0 ff ff       	call   8010331a <myproc>
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 1b                	je     801052c4 <trap+0x9e>
801052a9:	e8 6c e0 ff ff       	call   8010331a <myproc>
801052ae:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052b2:	74 10                	je     801052c4 <trap+0x9e>
801052b4:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052b7:	83 e0 03             	and    $0x3,%eax
801052ba:	66 83 f8 03          	cmp    $0x3,%ax
801052be:	0f 84 8d 02 00 00    	je     80105551 <trap+0x32b>
    exit(tf->trapno+1);
    }

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801052c4:	e8 51 e0 ff ff       	call   8010331a <myproc>
801052c9:	85 c0                	test   %eax,%eax
801052cb:	74 0f                	je     801052dc <trap+0xb6>
801052cd:	e8 48 e0 ff ff       	call   8010331a <myproc>
801052d2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801052d6:	0f 84 8a 02 00 00    	je     80105566 <trap+0x340>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052dc:	e8 39 e0 ff ff       	call   8010331a <myproc>
801052e1:	85 c0                	test   %eax,%eax
801052e3:	74 1b                	je     80105300 <trap+0xda>
801052e5:	e8 30 e0 ff ff       	call   8010331a <myproc>
801052ea:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052ee:	74 10                	je     80105300 <trap+0xda>
801052f0:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052f3:	83 e0 03             	and    $0x3,%eax
801052f6:	66 83 f8 03          	cmp    $0x3,%ax
801052fa:	0f 84 7a 02 00 00    	je     8010557a <trap+0x354>
    exit(tf->trapno+1);
}
80105300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105303:	5b                   	pop    %ebx
80105304:	5e                   	pop    %esi
80105305:	5f                   	pop    %edi
80105306:	5d                   	pop    %ebp
80105307:	c3                   	ret    
      acquire(&tickslock);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	68 e0 3f 11 80       	push   $0x80113fe0
80105310:	e8 39 ea ff ff       	call   80103d4e <acquire>
      ticks++;
80105315:	ff 05 c0 3f 11 80    	incl   0x80113fc0
      wakeup(&ticks);
8010531b:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80105322:	e8 81 e6 ff ff       	call   801039a8 <wakeup>
      release(&tickslock);
80105327:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010532e:	e8 80 ea ff ff       	call   80103db3 <release>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	e9 60 ff ff ff       	jmp    8010529b <trap+0x75>
    ideintr();
8010533b:	e8 a2 c9 ff ff       	call   80101ce2 <ideintr>
    lapiceoi();
80105340:	e8 b4 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105345:	e9 56 ff ff ff       	jmp    801052a0 <trap+0x7a>
    kbdintr();
8010534a:	e8 f4 cd ff ff       	call   80102143 <kbdintr>
    lapiceoi();
8010534f:	e8 a5 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105354:	e9 47 ff ff ff       	jmp    801052a0 <trap+0x7a>
    uartintr();
80105359:	e8 2d 03 00 00       	call   8010568b <uartintr>
    lapiceoi();
8010535e:	e8 96 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105363:	e9 38 ff ff ff       	jmp    801052a0 <trap+0x7a>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105368:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
8010536b:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010536e:	e8 76 df ff ff       	call   801032e9 <cpuid>
80105373:	57                   	push   %edi
80105374:	0f b7 f6             	movzwl %si,%esi
80105377:	56                   	push   %esi
80105378:	50                   	push   %eax
80105379:	68 5c 73 10 80       	push   $0x8010735c
8010537e:	e8 57 b2 ff ff       	call   801005da <cprintf>
    lapiceoi();
80105383:	e8 71 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	e9 10 ff ff ff       	jmp    801052a0 <trap+0x7a>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105390:	0f 20 d6             	mov    %cr2,%esi
   uint va = PGROUNDDOWN(rcr2());
80105393:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((tf->err & 0x7) == 0x7){
80105399:	8b 43 34             	mov    0x34(%ebx),%eax
8010539c:	89 c2                	mov    %eax,%edx
8010539e:	83 e2 07             	and    $0x7,%edx
801053a1:	83 fa 07             	cmp    $0x7,%edx
801053a4:	0f 84 86 00 00 00    	je     80105430 <trap+0x20a>
    if((va >= myproc()->sz) && ((tf->err & 0x6))){
801053aa:	e8 6b df ff ff       	call   8010331a <myproc>
801053af:	39 30                	cmp    %esi,(%eax)
801053b1:	77 0b                	ja     801053be <trap+0x198>
801053b3:	8b 43 34             	mov    0x34(%ebx),%eax
801053b6:	a8 06                	test   $0x6,%al
801053b8:	0f 85 94 00 00 00    	jne    80105452 <trap+0x22c>
    if(va < myproc()->sz){
801053be:	e8 57 df ff ff       	call   8010331a <myproc>
801053c3:	39 30                	cmp    %esi,(%eax)
801053c5:	0f 86 d5 fe ff ff    	jbe    801052a0 <trap+0x7a>
      char *mem = kalloc();
801053cb:	e8 57 cc ff ff       	call   80102027 <kalloc>
801053d0:	89 c6                	mov    %eax,%esi
      if (mem  == 0) { 
801053d2:	85 c0                	test   %eax,%eax
801053d4:	0f 84 9a 00 00 00    	je     80105474 <trap+0x24e>
      memset(mem, 0, PGSIZE); // set the page to 0
801053da:	83 ec 04             	sub    $0x4,%esp
801053dd:	68 00 10 00 00       	push   $0x1000
801053e2:	6a 00                	push   $0x0
801053e4:	56                   	push   %esi
801053e5:	e8 10 ea ff ff       	call   80103dfa <memset>
801053ea:	0f 20 d7             	mov    %cr2,%edi
      if(mappages(myproc()->pgdir, (char*) PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) != 0){
801053ed:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801053f3:	e8 22 df ff ff       	call   8010331a <myproc>
801053f8:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801053ff:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80105405:	52                   	push   %edx
80105406:	68 00 10 00 00       	push   $0x1000
8010540b:	57                   	push   %edi
8010540c:	ff 70 04             	push   0x4(%eax)
8010540f:	e8 3f 10 00 00       	call   80106453 <mappages>
80105414:	83 c4 20             	add    $0x20,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	75 7a                	jne    80105495 <trap+0x26f>
      lcr3(V2P(myproc()->pgdir));
8010541b:	e8 fa de ff ff       	call   8010331a <myproc>
80105420:	8b 40 04             	mov    0x4(%eax),%eax
80105423:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105428:	0f 22 d8             	mov    %eax,%cr3
}
8010542b:	e9 70 fe ff ff       	jmp    801052a0 <trap+0x7a>
    	cprintf("Page violation.Write type. Error code: %d\n", tf->err);
80105430:	83 ec 08             	sub    $0x8,%esp
80105433:	50                   	push   %eax
80105434:	68 80 73 10 80       	push   $0x80107380
80105439:	e8 9c b1 ff ff       	call   801005da <cprintf>
    	myproc()->killed = 1;
8010543e:	e8 d7 de ff ff       	call   8010331a <myproc>
80105443:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    	break;
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	e9 4e fe ff ff       	jmp    801052a0 <trap+0x7a>
      cprintf("Tried to access beyond sz, Error code: %d\n", tf->err);
80105452:	83 ec 08             	sub    $0x8,%esp
80105455:	50                   	push   %eax
80105456:	68 ac 73 10 80       	push   $0x801073ac
8010545b:	e8 7a b1 ff ff       	call   801005da <cprintf>
      myproc()->killed = 1;
80105460:	e8 b5 de ff ff       	call   8010331a <myproc>
80105465:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
8010546c:	83 c4 10             	add    $0x10,%esp
8010546f:	e9 2c fe ff ff       	jmp    801052a0 <trap+0x7a>
        cprintf("usertrap(): kalloc ha fallado\n");
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	68 d8 73 10 80       	push   $0x801073d8
8010547c:	e8 59 b1 ff ff       	call   801005da <cprintf>
        myproc()->killed = 1;
80105481:	e8 94 de ff ff       	call   8010331a <myproc>
80105486:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	e9 45 ff ff ff       	jmp    801053da <trap+0x1b4>
        cprintf("usertrap(): mappages falló\n");
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	68 3a 73 10 80       	push   $0x8010733a
8010549d:	e8 38 b1 ff ff       	call   801005da <cprintf>
        kfree(mem);
801054a2:	89 34 24             	mov    %esi,(%esp)
801054a5:	e8 66 ca ff ff       	call   80101f10 <kfree>
        myproc()->killed = 1;
801054aa:	e8 6b de ff ff       	call   8010331a <myproc>
801054af:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	e9 5d ff ff ff       	jmp    8010541b <trap+0x1f5>
    if(myproc() == 0 || (tf->cs&3) == 0){
801054be:	e8 57 de ff ff       	call   8010331a <myproc>
801054c3:	85 c0                	test   %eax,%eax
801054c5:	74 5f                	je     80105526 <trap+0x300>
801054c7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801054cb:	74 59                	je     80105526 <trap+0x300>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801054cd:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054d0:	8b 43 38             	mov    0x38(%ebx),%eax
801054d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054d6:	e8 0e de ff ff       	call   801032e9 <cpuid>
801054db:	89 45 e0             	mov    %eax,-0x20(%ebp)
801054de:	8b 4b 34             	mov    0x34(%ebx),%ecx
801054e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801054e4:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801054e7:	e8 2e de ff ff       	call   8010331a <myproc>
801054ec:	8d 50 6c             	lea    0x6c(%eax),%edx
801054ef:	89 55 d8             	mov    %edx,-0x28(%ebp)
801054f2:	e8 23 de ff ff       	call   8010331a <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054f7:	57                   	push   %edi
801054f8:	ff 75 e4             	push   -0x1c(%ebp)
801054fb:	ff 75 e0             	push   -0x20(%ebp)
801054fe:	ff 75 dc             	push   -0x24(%ebp)
80105501:	56                   	push   %esi
80105502:	ff 75 d8             	push   -0x28(%ebp)
80105505:	ff 70 10             	push   0x10(%eax)
80105508:	68 2c 74 10 80       	push   $0x8010742c
8010550d:	e8 c8 b0 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
80105512:	83 c4 20             	add    $0x20,%esp
80105515:	e8 00 de ff ff       	call   8010331a <myproc>
8010551a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105521:	e9 7a fd ff ff       	jmp    801052a0 <trap+0x7a>
80105526:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105529:	8b 73 38             	mov    0x38(%ebx),%esi
8010552c:	e8 b8 dd ff ff       	call   801032e9 <cpuid>
80105531:	83 ec 0c             	sub    $0xc,%esp
80105534:	57                   	push   %edi
80105535:	56                   	push   %esi
80105536:	50                   	push   %eax
80105537:	ff 73 30             	push   0x30(%ebx)
8010553a:	68 f8 73 10 80       	push   $0x801073f8
8010553f:	e8 96 b0 ff ff       	call   801005da <cprintf>
      panic("trap");
80105544:	83 c4 14             	add    $0x14,%esp
80105547:	68 57 73 10 80       	push   $0x80107357
8010554c:	e8 f0 ad ff ff       	call   80100341 <panic>
    exit(tf->trapno+1);
80105551:	8b 43 30             	mov    0x30(%ebx),%eax
80105554:	40                   	inc    %eax
80105555:	83 ec 0c             	sub    $0xc,%esp
80105558:	50                   	push   %eax
80105559:	e8 aa e1 ff ff       	call   80103708 <exit>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	e9 5e fd ff ff       	jmp    801052c4 <trap+0x9e>
  if(myproc() && myproc()->state == RUNNING &&
80105566:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010556a:	0f 85 6c fd ff ff    	jne    801052dc <trap+0xb6>
    yield();
80105570:	e8 71 e2 ff ff       	call   801037e6 <yield>
80105575:	e9 62 fd ff ff       	jmp    801052dc <trap+0xb6>
    exit(tf->trapno+1);
8010557a:	8b 43 30             	mov    0x30(%ebx),%eax
8010557d:	40                   	inc    %eax
8010557e:	83 ec 0c             	sub    $0xc,%esp
80105581:	50                   	push   %eax
80105582:	e8 81 e1 ff ff       	call   80103708 <exit>
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	e9 71 fd ff ff       	jmp    80105300 <trap+0xda>

8010558f <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
8010558f:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
80105596:	74 14                	je     801055ac <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105598:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010559d:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010559e:	a8 01                	test   $0x1,%al
801055a0:	74 10                	je     801055b2 <uartgetc+0x23>
801055a2:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055a7:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801055a8:	0f b6 c0             	movzbl %al,%eax
801055ab:	c3                   	ret    
    return -1;
801055ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b1:	c3                   	ret    
    return -1;
801055b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b7:	c3                   	ret    

801055b8 <uartputc>:
  if(!uart)
801055b8:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
801055bf:	74 39                	je     801055fa <uartputc+0x42>
{
801055c1:	55                   	push   %ebp
801055c2:	89 e5                	mov    %esp,%ebp
801055c4:	53                   	push   %ebx
801055c5:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801055c8:	bb 00 00 00 00       	mov    $0x0,%ebx
801055cd:	eb 0e                	jmp    801055dd <uartputc+0x25>
    microdelay(10);
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	6a 0a                	push   $0xa
801055d4:	e8 41 cd ff ff       	call   8010231a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801055d9:	43                   	inc    %ebx
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	83 fb 7f             	cmp    $0x7f,%ebx
801055e0:	7f 0a                	jg     801055ec <uartputc+0x34>
801055e2:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055e7:	ec                   	in     (%dx),%al
801055e8:	a8 20                	test   $0x20,%al
801055ea:	74 e3                	je     801055cf <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801055ec:	8b 45 08             	mov    0x8(%ebp),%eax
801055ef:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055f4:	ee                   	out    %al,(%dx)
}
801055f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055f8:	c9                   	leave  
801055f9:	c3                   	ret    
801055fa:	c3                   	ret    

801055fb <uartinit>:
{
801055fb:	55                   	push   %ebp
801055fc:	89 e5                	mov    %esp,%ebp
801055fe:	56                   	push   %esi
801055ff:	53                   	push   %ebx
80105600:	b1 00                	mov    $0x0,%cl
80105602:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105607:	88 c8                	mov    %cl,%al
80105609:	ee                   	out    %al,(%dx)
8010560a:	be fb 03 00 00       	mov    $0x3fb,%esi
8010560f:	b0 80                	mov    $0x80,%al
80105611:	89 f2                	mov    %esi,%edx
80105613:	ee                   	out    %al,(%dx)
80105614:	b0 0c                	mov    $0xc,%al
80105616:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010561b:	ee                   	out    %al,(%dx)
8010561c:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105621:	88 c8                	mov    %cl,%al
80105623:	89 da                	mov    %ebx,%edx
80105625:	ee                   	out    %al,(%dx)
80105626:	b0 03                	mov    $0x3,%al
80105628:	89 f2                	mov    %esi,%edx
8010562a:	ee                   	out    %al,(%dx)
8010562b:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105630:	88 c8                	mov    %cl,%al
80105632:	ee                   	out    %al,(%dx)
80105633:	b0 01                	mov    $0x1,%al
80105635:	89 da                	mov    %ebx,%edx
80105637:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105638:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010563d:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010563e:	3c ff                	cmp    $0xff,%al
80105640:	74 42                	je     80105684 <uartinit+0x89>
  uart = 1;
80105642:	c7 05 20 48 11 80 01 	movl   $0x1,0x80114820
80105649:	00 00 00 
8010564c:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105651:	ec                   	in     (%dx),%al
80105652:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105657:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105658:	83 ec 08             	sub    $0x8,%esp
8010565b:	6a 00                	push   $0x0
8010565d:	6a 04                	push   $0x4
8010565f:	e8 81 c8 ff ff       	call   80101ee5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	bb 38 75 10 80       	mov    $0x80107538,%ebx
8010566c:	eb 10                	jmp    8010567e <uartinit+0x83>
    uartputc(*p);
8010566e:	83 ec 0c             	sub    $0xc,%esp
80105671:	0f be c0             	movsbl %al,%eax
80105674:	50                   	push   %eax
80105675:	e8 3e ff ff ff       	call   801055b8 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010567a:	43                   	inc    %ebx
8010567b:	83 c4 10             	add    $0x10,%esp
8010567e:	8a 03                	mov    (%ebx),%al
80105680:	84 c0                	test   %al,%al
80105682:	75 ea                	jne    8010566e <uartinit+0x73>
}
80105684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105687:	5b                   	pop    %ebx
80105688:	5e                   	pop    %esi
80105689:	5d                   	pop    %ebp
8010568a:	c3                   	ret    

8010568b <uartintr>:

void
uartintr(void)
{
8010568b:	55                   	push   %ebp
8010568c:	89 e5                	mov    %esp,%ebp
8010568e:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105691:	68 8f 55 10 80       	push   $0x8010558f
80105696:	e8 64 b0 ff ff       	call   801006ff <consoleintr>
}
8010569b:	83 c4 10             	add    $0x10,%esp
8010569e:	c9                   	leave  
8010569f:	c3                   	ret    

801056a0 <vector0>:
801056a0:	6a 00                	push   $0x0
801056a2:	6a 00                	push   $0x0
801056a4:	e9 39 fa ff ff       	jmp    801050e2 <alltraps>

801056a9 <vector1>:
801056a9:	6a 00                	push   $0x0
801056ab:	6a 01                	push   $0x1
801056ad:	e9 30 fa ff ff       	jmp    801050e2 <alltraps>

801056b2 <vector2>:
801056b2:	6a 00                	push   $0x0
801056b4:	6a 02                	push   $0x2
801056b6:	e9 27 fa ff ff       	jmp    801050e2 <alltraps>

801056bb <vector3>:
801056bb:	6a 00                	push   $0x0
801056bd:	6a 03                	push   $0x3
801056bf:	e9 1e fa ff ff       	jmp    801050e2 <alltraps>

801056c4 <vector4>:
801056c4:	6a 00                	push   $0x0
801056c6:	6a 04                	push   $0x4
801056c8:	e9 15 fa ff ff       	jmp    801050e2 <alltraps>

801056cd <vector5>:
801056cd:	6a 00                	push   $0x0
801056cf:	6a 05                	push   $0x5
801056d1:	e9 0c fa ff ff       	jmp    801050e2 <alltraps>

801056d6 <vector6>:
801056d6:	6a 00                	push   $0x0
801056d8:	6a 06                	push   $0x6
801056da:	e9 03 fa ff ff       	jmp    801050e2 <alltraps>

801056df <vector7>:
801056df:	6a 00                	push   $0x0
801056e1:	6a 07                	push   $0x7
801056e3:	e9 fa f9 ff ff       	jmp    801050e2 <alltraps>

801056e8 <vector8>:
801056e8:	6a 08                	push   $0x8
801056ea:	e9 f3 f9 ff ff       	jmp    801050e2 <alltraps>

801056ef <vector9>:
801056ef:	6a 00                	push   $0x0
801056f1:	6a 09                	push   $0x9
801056f3:	e9 ea f9 ff ff       	jmp    801050e2 <alltraps>

801056f8 <vector10>:
801056f8:	6a 0a                	push   $0xa
801056fa:	e9 e3 f9 ff ff       	jmp    801050e2 <alltraps>

801056ff <vector11>:
801056ff:	6a 0b                	push   $0xb
80105701:	e9 dc f9 ff ff       	jmp    801050e2 <alltraps>

80105706 <vector12>:
80105706:	6a 0c                	push   $0xc
80105708:	e9 d5 f9 ff ff       	jmp    801050e2 <alltraps>

8010570d <vector13>:
8010570d:	6a 0d                	push   $0xd
8010570f:	e9 ce f9 ff ff       	jmp    801050e2 <alltraps>

80105714 <vector14>:
80105714:	6a 0e                	push   $0xe
80105716:	e9 c7 f9 ff ff       	jmp    801050e2 <alltraps>

8010571b <vector15>:
8010571b:	6a 00                	push   $0x0
8010571d:	6a 0f                	push   $0xf
8010571f:	e9 be f9 ff ff       	jmp    801050e2 <alltraps>

80105724 <vector16>:
80105724:	6a 00                	push   $0x0
80105726:	6a 10                	push   $0x10
80105728:	e9 b5 f9 ff ff       	jmp    801050e2 <alltraps>

8010572d <vector17>:
8010572d:	6a 11                	push   $0x11
8010572f:	e9 ae f9 ff ff       	jmp    801050e2 <alltraps>

80105734 <vector18>:
80105734:	6a 00                	push   $0x0
80105736:	6a 12                	push   $0x12
80105738:	e9 a5 f9 ff ff       	jmp    801050e2 <alltraps>

8010573d <vector19>:
8010573d:	6a 00                	push   $0x0
8010573f:	6a 13                	push   $0x13
80105741:	e9 9c f9 ff ff       	jmp    801050e2 <alltraps>

80105746 <vector20>:
80105746:	6a 00                	push   $0x0
80105748:	6a 14                	push   $0x14
8010574a:	e9 93 f9 ff ff       	jmp    801050e2 <alltraps>

8010574f <vector21>:
8010574f:	6a 00                	push   $0x0
80105751:	6a 15                	push   $0x15
80105753:	e9 8a f9 ff ff       	jmp    801050e2 <alltraps>

80105758 <vector22>:
80105758:	6a 00                	push   $0x0
8010575a:	6a 16                	push   $0x16
8010575c:	e9 81 f9 ff ff       	jmp    801050e2 <alltraps>

80105761 <vector23>:
80105761:	6a 00                	push   $0x0
80105763:	6a 17                	push   $0x17
80105765:	e9 78 f9 ff ff       	jmp    801050e2 <alltraps>

8010576a <vector24>:
8010576a:	6a 00                	push   $0x0
8010576c:	6a 18                	push   $0x18
8010576e:	e9 6f f9 ff ff       	jmp    801050e2 <alltraps>

80105773 <vector25>:
80105773:	6a 00                	push   $0x0
80105775:	6a 19                	push   $0x19
80105777:	e9 66 f9 ff ff       	jmp    801050e2 <alltraps>

8010577c <vector26>:
8010577c:	6a 00                	push   $0x0
8010577e:	6a 1a                	push   $0x1a
80105780:	e9 5d f9 ff ff       	jmp    801050e2 <alltraps>

80105785 <vector27>:
80105785:	6a 00                	push   $0x0
80105787:	6a 1b                	push   $0x1b
80105789:	e9 54 f9 ff ff       	jmp    801050e2 <alltraps>

8010578e <vector28>:
8010578e:	6a 00                	push   $0x0
80105790:	6a 1c                	push   $0x1c
80105792:	e9 4b f9 ff ff       	jmp    801050e2 <alltraps>

80105797 <vector29>:
80105797:	6a 00                	push   $0x0
80105799:	6a 1d                	push   $0x1d
8010579b:	e9 42 f9 ff ff       	jmp    801050e2 <alltraps>

801057a0 <vector30>:
801057a0:	6a 00                	push   $0x0
801057a2:	6a 1e                	push   $0x1e
801057a4:	e9 39 f9 ff ff       	jmp    801050e2 <alltraps>

801057a9 <vector31>:
801057a9:	6a 00                	push   $0x0
801057ab:	6a 1f                	push   $0x1f
801057ad:	e9 30 f9 ff ff       	jmp    801050e2 <alltraps>

801057b2 <vector32>:
801057b2:	6a 00                	push   $0x0
801057b4:	6a 20                	push   $0x20
801057b6:	e9 27 f9 ff ff       	jmp    801050e2 <alltraps>

801057bb <vector33>:
801057bb:	6a 00                	push   $0x0
801057bd:	6a 21                	push   $0x21
801057bf:	e9 1e f9 ff ff       	jmp    801050e2 <alltraps>

801057c4 <vector34>:
801057c4:	6a 00                	push   $0x0
801057c6:	6a 22                	push   $0x22
801057c8:	e9 15 f9 ff ff       	jmp    801050e2 <alltraps>

801057cd <vector35>:
801057cd:	6a 00                	push   $0x0
801057cf:	6a 23                	push   $0x23
801057d1:	e9 0c f9 ff ff       	jmp    801050e2 <alltraps>

801057d6 <vector36>:
801057d6:	6a 00                	push   $0x0
801057d8:	6a 24                	push   $0x24
801057da:	e9 03 f9 ff ff       	jmp    801050e2 <alltraps>

801057df <vector37>:
801057df:	6a 00                	push   $0x0
801057e1:	6a 25                	push   $0x25
801057e3:	e9 fa f8 ff ff       	jmp    801050e2 <alltraps>

801057e8 <vector38>:
801057e8:	6a 00                	push   $0x0
801057ea:	6a 26                	push   $0x26
801057ec:	e9 f1 f8 ff ff       	jmp    801050e2 <alltraps>

801057f1 <vector39>:
801057f1:	6a 00                	push   $0x0
801057f3:	6a 27                	push   $0x27
801057f5:	e9 e8 f8 ff ff       	jmp    801050e2 <alltraps>

801057fa <vector40>:
801057fa:	6a 00                	push   $0x0
801057fc:	6a 28                	push   $0x28
801057fe:	e9 df f8 ff ff       	jmp    801050e2 <alltraps>

80105803 <vector41>:
80105803:	6a 00                	push   $0x0
80105805:	6a 29                	push   $0x29
80105807:	e9 d6 f8 ff ff       	jmp    801050e2 <alltraps>

8010580c <vector42>:
8010580c:	6a 00                	push   $0x0
8010580e:	6a 2a                	push   $0x2a
80105810:	e9 cd f8 ff ff       	jmp    801050e2 <alltraps>

80105815 <vector43>:
80105815:	6a 00                	push   $0x0
80105817:	6a 2b                	push   $0x2b
80105819:	e9 c4 f8 ff ff       	jmp    801050e2 <alltraps>

8010581e <vector44>:
8010581e:	6a 00                	push   $0x0
80105820:	6a 2c                	push   $0x2c
80105822:	e9 bb f8 ff ff       	jmp    801050e2 <alltraps>

80105827 <vector45>:
80105827:	6a 00                	push   $0x0
80105829:	6a 2d                	push   $0x2d
8010582b:	e9 b2 f8 ff ff       	jmp    801050e2 <alltraps>

80105830 <vector46>:
80105830:	6a 00                	push   $0x0
80105832:	6a 2e                	push   $0x2e
80105834:	e9 a9 f8 ff ff       	jmp    801050e2 <alltraps>

80105839 <vector47>:
80105839:	6a 00                	push   $0x0
8010583b:	6a 2f                	push   $0x2f
8010583d:	e9 a0 f8 ff ff       	jmp    801050e2 <alltraps>

80105842 <vector48>:
80105842:	6a 00                	push   $0x0
80105844:	6a 30                	push   $0x30
80105846:	e9 97 f8 ff ff       	jmp    801050e2 <alltraps>

8010584b <vector49>:
8010584b:	6a 00                	push   $0x0
8010584d:	6a 31                	push   $0x31
8010584f:	e9 8e f8 ff ff       	jmp    801050e2 <alltraps>

80105854 <vector50>:
80105854:	6a 00                	push   $0x0
80105856:	6a 32                	push   $0x32
80105858:	e9 85 f8 ff ff       	jmp    801050e2 <alltraps>

8010585d <vector51>:
8010585d:	6a 00                	push   $0x0
8010585f:	6a 33                	push   $0x33
80105861:	e9 7c f8 ff ff       	jmp    801050e2 <alltraps>

80105866 <vector52>:
80105866:	6a 00                	push   $0x0
80105868:	6a 34                	push   $0x34
8010586a:	e9 73 f8 ff ff       	jmp    801050e2 <alltraps>

8010586f <vector53>:
8010586f:	6a 00                	push   $0x0
80105871:	6a 35                	push   $0x35
80105873:	e9 6a f8 ff ff       	jmp    801050e2 <alltraps>

80105878 <vector54>:
80105878:	6a 00                	push   $0x0
8010587a:	6a 36                	push   $0x36
8010587c:	e9 61 f8 ff ff       	jmp    801050e2 <alltraps>

80105881 <vector55>:
80105881:	6a 00                	push   $0x0
80105883:	6a 37                	push   $0x37
80105885:	e9 58 f8 ff ff       	jmp    801050e2 <alltraps>

8010588a <vector56>:
8010588a:	6a 00                	push   $0x0
8010588c:	6a 38                	push   $0x38
8010588e:	e9 4f f8 ff ff       	jmp    801050e2 <alltraps>

80105893 <vector57>:
80105893:	6a 00                	push   $0x0
80105895:	6a 39                	push   $0x39
80105897:	e9 46 f8 ff ff       	jmp    801050e2 <alltraps>

8010589c <vector58>:
8010589c:	6a 00                	push   $0x0
8010589e:	6a 3a                	push   $0x3a
801058a0:	e9 3d f8 ff ff       	jmp    801050e2 <alltraps>

801058a5 <vector59>:
801058a5:	6a 00                	push   $0x0
801058a7:	6a 3b                	push   $0x3b
801058a9:	e9 34 f8 ff ff       	jmp    801050e2 <alltraps>

801058ae <vector60>:
801058ae:	6a 00                	push   $0x0
801058b0:	6a 3c                	push   $0x3c
801058b2:	e9 2b f8 ff ff       	jmp    801050e2 <alltraps>

801058b7 <vector61>:
801058b7:	6a 00                	push   $0x0
801058b9:	6a 3d                	push   $0x3d
801058bb:	e9 22 f8 ff ff       	jmp    801050e2 <alltraps>

801058c0 <vector62>:
801058c0:	6a 00                	push   $0x0
801058c2:	6a 3e                	push   $0x3e
801058c4:	e9 19 f8 ff ff       	jmp    801050e2 <alltraps>

801058c9 <vector63>:
801058c9:	6a 00                	push   $0x0
801058cb:	6a 3f                	push   $0x3f
801058cd:	e9 10 f8 ff ff       	jmp    801050e2 <alltraps>

801058d2 <vector64>:
801058d2:	6a 00                	push   $0x0
801058d4:	6a 40                	push   $0x40
801058d6:	e9 07 f8 ff ff       	jmp    801050e2 <alltraps>

801058db <vector65>:
801058db:	6a 00                	push   $0x0
801058dd:	6a 41                	push   $0x41
801058df:	e9 fe f7 ff ff       	jmp    801050e2 <alltraps>

801058e4 <vector66>:
801058e4:	6a 00                	push   $0x0
801058e6:	6a 42                	push   $0x42
801058e8:	e9 f5 f7 ff ff       	jmp    801050e2 <alltraps>

801058ed <vector67>:
801058ed:	6a 00                	push   $0x0
801058ef:	6a 43                	push   $0x43
801058f1:	e9 ec f7 ff ff       	jmp    801050e2 <alltraps>

801058f6 <vector68>:
801058f6:	6a 00                	push   $0x0
801058f8:	6a 44                	push   $0x44
801058fa:	e9 e3 f7 ff ff       	jmp    801050e2 <alltraps>

801058ff <vector69>:
801058ff:	6a 00                	push   $0x0
80105901:	6a 45                	push   $0x45
80105903:	e9 da f7 ff ff       	jmp    801050e2 <alltraps>

80105908 <vector70>:
80105908:	6a 00                	push   $0x0
8010590a:	6a 46                	push   $0x46
8010590c:	e9 d1 f7 ff ff       	jmp    801050e2 <alltraps>

80105911 <vector71>:
80105911:	6a 00                	push   $0x0
80105913:	6a 47                	push   $0x47
80105915:	e9 c8 f7 ff ff       	jmp    801050e2 <alltraps>

8010591a <vector72>:
8010591a:	6a 00                	push   $0x0
8010591c:	6a 48                	push   $0x48
8010591e:	e9 bf f7 ff ff       	jmp    801050e2 <alltraps>

80105923 <vector73>:
80105923:	6a 00                	push   $0x0
80105925:	6a 49                	push   $0x49
80105927:	e9 b6 f7 ff ff       	jmp    801050e2 <alltraps>

8010592c <vector74>:
8010592c:	6a 00                	push   $0x0
8010592e:	6a 4a                	push   $0x4a
80105930:	e9 ad f7 ff ff       	jmp    801050e2 <alltraps>

80105935 <vector75>:
80105935:	6a 00                	push   $0x0
80105937:	6a 4b                	push   $0x4b
80105939:	e9 a4 f7 ff ff       	jmp    801050e2 <alltraps>

8010593e <vector76>:
8010593e:	6a 00                	push   $0x0
80105940:	6a 4c                	push   $0x4c
80105942:	e9 9b f7 ff ff       	jmp    801050e2 <alltraps>

80105947 <vector77>:
80105947:	6a 00                	push   $0x0
80105949:	6a 4d                	push   $0x4d
8010594b:	e9 92 f7 ff ff       	jmp    801050e2 <alltraps>

80105950 <vector78>:
80105950:	6a 00                	push   $0x0
80105952:	6a 4e                	push   $0x4e
80105954:	e9 89 f7 ff ff       	jmp    801050e2 <alltraps>

80105959 <vector79>:
80105959:	6a 00                	push   $0x0
8010595b:	6a 4f                	push   $0x4f
8010595d:	e9 80 f7 ff ff       	jmp    801050e2 <alltraps>

80105962 <vector80>:
80105962:	6a 00                	push   $0x0
80105964:	6a 50                	push   $0x50
80105966:	e9 77 f7 ff ff       	jmp    801050e2 <alltraps>

8010596b <vector81>:
8010596b:	6a 00                	push   $0x0
8010596d:	6a 51                	push   $0x51
8010596f:	e9 6e f7 ff ff       	jmp    801050e2 <alltraps>

80105974 <vector82>:
80105974:	6a 00                	push   $0x0
80105976:	6a 52                	push   $0x52
80105978:	e9 65 f7 ff ff       	jmp    801050e2 <alltraps>

8010597d <vector83>:
8010597d:	6a 00                	push   $0x0
8010597f:	6a 53                	push   $0x53
80105981:	e9 5c f7 ff ff       	jmp    801050e2 <alltraps>

80105986 <vector84>:
80105986:	6a 00                	push   $0x0
80105988:	6a 54                	push   $0x54
8010598a:	e9 53 f7 ff ff       	jmp    801050e2 <alltraps>

8010598f <vector85>:
8010598f:	6a 00                	push   $0x0
80105991:	6a 55                	push   $0x55
80105993:	e9 4a f7 ff ff       	jmp    801050e2 <alltraps>

80105998 <vector86>:
80105998:	6a 00                	push   $0x0
8010599a:	6a 56                	push   $0x56
8010599c:	e9 41 f7 ff ff       	jmp    801050e2 <alltraps>

801059a1 <vector87>:
801059a1:	6a 00                	push   $0x0
801059a3:	6a 57                	push   $0x57
801059a5:	e9 38 f7 ff ff       	jmp    801050e2 <alltraps>

801059aa <vector88>:
801059aa:	6a 00                	push   $0x0
801059ac:	6a 58                	push   $0x58
801059ae:	e9 2f f7 ff ff       	jmp    801050e2 <alltraps>

801059b3 <vector89>:
801059b3:	6a 00                	push   $0x0
801059b5:	6a 59                	push   $0x59
801059b7:	e9 26 f7 ff ff       	jmp    801050e2 <alltraps>

801059bc <vector90>:
801059bc:	6a 00                	push   $0x0
801059be:	6a 5a                	push   $0x5a
801059c0:	e9 1d f7 ff ff       	jmp    801050e2 <alltraps>

801059c5 <vector91>:
801059c5:	6a 00                	push   $0x0
801059c7:	6a 5b                	push   $0x5b
801059c9:	e9 14 f7 ff ff       	jmp    801050e2 <alltraps>

801059ce <vector92>:
801059ce:	6a 00                	push   $0x0
801059d0:	6a 5c                	push   $0x5c
801059d2:	e9 0b f7 ff ff       	jmp    801050e2 <alltraps>

801059d7 <vector93>:
801059d7:	6a 00                	push   $0x0
801059d9:	6a 5d                	push   $0x5d
801059db:	e9 02 f7 ff ff       	jmp    801050e2 <alltraps>

801059e0 <vector94>:
801059e0:	6a 00                	push   $0x0
801059e2:	6a 5e                	push   $0x5e
801059e4:	e9 f9 f6 ff ff       	jmp    801050e2 <alltraps>

801059e9 <vector95>:
801059e9:	6a 00                	push   $0x0
801059eb:	6a 5f                	push   $0x5f
801059ed:	e9 f0 f6 ff ff       	jmp    801050e2 <alltraps>

801059f2 <vector96>:
801059f2:	6a 00                	push   $0x0
801059f4:	6a 60                	push   $0x60
801059f6:	e9 e7 f6 ff ff       	jmp    801050e2 <alltraps>

801059fb <vector97>:
801059fb:	6a 00                	push   $0x0
801059fd:	6a 61                	push   $0x61
801059ff:	e9 de f6 ff ff       	jmp    801050e2 <alltraps>

80105a04 <vector98>:
80105a04:	6a 00                	push   $0x0
80105a06:	6a 62                	push   $0x62
80105a08:	e9 d5 f6 ff ff       	jmp    801050e2 <alltraps>

80105a0d <vector99>:
80105a0d:	6a 00                	push   $0x0
80105a0f:	6a 63                	push   $0x63
80105a11:	e9 cc f6 ff ff       	jmp    801050e2 <alltraps>

80105a16 <vector100>:
80105a16:	6a 00                	push   $0x0
80105a18:	6a 64                	push   $0x64
80105a1a:	e9 c3 f6 ff ff       	jmp    801050e2 <alltraps>

80105a1f <vector101>:
80105a1f:	6a 00                	push   $0x0
80105a21:	6a 65                	push   $0x65
80105a23:	e9 ba f6 ff ff       	jmp    801050e2 <alltraps>

80105a28 <vector102>:
80105a28:	6a 00                	push   $0x0
80105a2a:	6a 66                	push   $0x66
80105a2c:	e9 b1 f6 ff ff       	jmp    801050e2 <alltraps>

80105a31 <vector103>:
80105a31:	6a 00                	push   $0x0
80105a33:	6a 67                	push   $0x67
80105a35:	e9 a8 f6 ff ff       	jmp    801050e2 <alltraps>

80105a3a <vector104>:
80105a3a:	6a 00                	push   $0x0
80105a3c:	6a 68                	push   $0x68
80105a3e:	e9 9f f6 ff ff       	jmp    801050e2 <alltraps>

80105a43 <vector105>:
80105a43:	6a 00                	push   $0x0
80105a45:	6a 69                	push   $0x69
80105a47:	e9 96 f6 ff ff       	jmp    801050e2 <alltraps>

80105a4c <vector106>:
80105a4c:	6a 00                	push   $0x0
80105a4e:	6a 6a                	push   $0x6a
80105a50:	e9 8d f6 ff ff       	jmp    801050e2 <alltraps>

80105a55 <vector107>:
80105a55:	6a 00                	push   $0x0
80105a57:	6a 6b                	push   $0x6b
80105a59:	e9 84 f6 ff ff       	jmp    801050e2 <alltraps>

80105a5e <vector108>:
80105a5e:	6a 00                	push   $0x0
80105a60:	6a 6c                	push   $0x6c
80105a62:	e9 7b f6 ff ff       	jmp    801050e2 <alltraps>

80105a67 <vector109>:
80105a67:	6a 00                	push   $0x0
80105a69:	6a 6d                	push   $0x6d
80105a6b:	e9 72 f6 ff ff       	jmp    801050e2 <alltraps>

80105a70 <vector110>:
80105a70:	6a 00                	push   $0x0
80105a72:	6a 6e                	push   $0x6e
80105a74:	e9 69 f6 ff ff       	jmp    801050e2 <alltraps>

80105a79 <vector111>:
80105a79:	6a 00                	push   $0x0
80105a7b:	6a 6f                	push   $0x6f
80105a7d:	e9 60 f6 ff ff       	jmp    801050e2 <alltraps>

80105a82 <vector112>:
80105a82:	6a 00                	push   $0x0
80105a84:	6a 70                	push   $0x70
80105a86:	e9 57 f6 ff ff       	jmp    801050e2 <alltraps>

80105a8b <vector113>:
80105a8b:	6a 00                	push   $0x0
80105a8d:	6a 71                	push   $0x71
80105a8f:	e9 4e f6 ff ff       	jmp    801050e2 <alltraps>

80105a94 <vector114>:
80105a94:	6a 00                	push   $0x0
80105a96:	6a 72                	push   $0x72
80105a98:	e9 45 f6 ff ff       	jmp    801050e2 <alltraps>

80105a9d <vector115>:
80105a9d:	6a 00                	push   $0x0
80105a9f:	6a 73                	push   $0x73
80105aa1:	e9 3c f6 ff ff       	jmp    801050e2 <alltraps>

80105aa6 <vector116>:
80105aa6:	6a 00                	push   $0x0
80105aa8:	6a 74                	push   $0x74
80105aaa:	e9 33 f6 ff ff       	jmp    801050e2 <alltraps>

80105aaf <vector117>:
80105aaf:	6a 00                	push   $0x0
80105ab1:	6a 75                	push   $0x75
80105ab3:	e9 2a f6 ff ff       	jmp    801050e2 <alltraps>

80105ab8 <vector118>:
80105ab8:	6a 00                	push   $0x0
80105aba:	6a 76                	push   $0x76
80105abc:	e9 21 f6 ff ff       	jmp    801050e2 <alltraps>

80105ac1 <vector119>:
80105ac1:	6a 00                	push   $0x0
80105ac3:	6a 77                	push   $0x77
80105ac5:	e9 18 f6 ff ff       	jmp    801050e2 <alltraps>

80105aca <vector120>:
80105aca:	6a 00                	push   $0x0
80105acc:	6a 78                	push   $0x78
80105ace:	e9 0f f6 ff ff       	jmp    801050e2 <alltraps>

80105ad3 <vector121>:
80105ad3:	6a 00                	push   $0x0
80105ad5:	6a 79                	push   $0x79
80105ad7:	e9 06 f6 ff ff       	jmp    801050e2 <alltraps>

80105adc <vector122>:
80105adc:	6a 00                	push   $0x0
80105ade:	6a 7a                	push   $0x7a
80105ae0:	e9 fd f5 ff ff       	jmp    801050e2 <alltraps>

80105ae5 <vector123>:
80105ae5:	6a 00                	push   $0x0
80105ae7:	6a 7b                	push   $0x7b
80105ae9:	e9 f4 f5 ff ff       	jmp    801050e2 <alltraps>

80105aee <vector124>:
80105aee:	6a 00                	push   $0x0
80105af0:	6a 7c                	push   $0x7c
80105af2:	e9 eb f5 ff ff       	jmp    801050e2 <alltraps>

80105af7 <vector125>:
80105af7:	6a 00                	push   $0x0
80105af9:	6a 7d                	push   $0x7d
80105afb:	e9 e2 f5 ff ff       	jmp    801050e2 <alltraps>

80105b00 <vector126>:
80105b00:	6a 00                	push   $0x0
80105b02:	6a 7e                	push   $0x7e
80105b04:	e9 d9 f5 ff ff       	jmp    801050e2 <alltraps>

80105b09 <vector127>:
80105b09:	6a 00                	push   $0x0
80105b0b:	6a 7f                	push   $0x7f
80105b0d:	e9 d0 f5 ff ff       	jmp    801050e2 <alltraps>

80105b12 <vector128>:
80105b12:	6a 00                	push   $0x0
80105b14:	68 80 00 00 00       	push   $0x80
80105b19:	e9 c4 f5 ff ff       	jmp    801050e2 <alltraps>

80105b1e <vector129>:
80105b1e:	6a 00                	push   $0x0
80105b20:	68 81 00 00 00       	push   $0x81
80105b25:	e9 b8 f5 ff ff       	jmp    801050e2 <alltraps>

80105b2a <vector130>:
80105b2a:	6a 00                	push   $0x0
80105b2c:	68 82 00 00 00       	push   $0x82
80105b31:	e9 ac f5 ff ff       	jmp    801050e2 <alltraps>

80105b36 <vector131>:
80105b36:	6a 00                	push   $0x0
80105b38:	68 83 00 00 00       	push   $0x83
80105b3d:	e9 a0 f5 ff ff       	jmp    801050e2 <alltraps>

80105b42 <vector132>:
80105b42:	6a 00                	push   $0x0
80105b44:	68 84 00 00 00       	push   $0x84
80105b49:	e9 94 f5 ff ff       	jmp    801050e2 <alltraps>

80105b4e <vector133>:
80105b4e:	6a 00                	push   $0x0
80105b50:	68 85 00 00 00       	push   $0x85
80105b55:	e9 88 f5 ff ff       	jmp    801050e2 <alltraps>

80105b5a <vector134>:
80105b5a:	6a 00                	push   $0x0
80105b5c:	68 86 00 00 00       	push   $0x86
80105b61:	e9 7c f5 ff ff       	jmp    801050e2 <alltraps>

80105b66 <vector135>:
80105b66:	6a 00                	push   $0x0
80105b68:	68 87 00 00 00       	push   $0x87
80105b6d:	e9 70 f5 ff ff       	jmp    801050e2 <alltraps>

80105b72 <vector136>:
80105b72:	6a 00                	push   $0x0
80105b74:	68 88 00 00 00       	push   $0x88
80105b79:	e9 64 f5 ff ff       	jmp    801050e2 <alltraps>

80105b7e <vector137>:
80105b7e:	6a 00                	push   $0x0
80105b80:	68 89 00 00 00       	push   $0x89
80105b85:	e9 58 f5 ff ff       	jmp    801050e2 <alltraps>

80105b8a <vector138>:
80105b8a:	6a 00                	push   $0x0
80105b8c:	68 8a 00 00 00       	push   $0x8a
80105b91:	e9 4c f5 ff ff       	jmp    801050e2 <alltraps>

80105b96 <vector139>:
80105b96:	6a 00                	push   $0x0
80105b98:	68 8b 00 00 00       	push   $0x8b
80105b9d:	e9 40 f5 ff ff       	jmp    801050e2 <alltraps>

80105ba2 <vector140>:
80105ba2:	6a 00                	push   $0x0
80105ba4:	68 8c 00 00 00       	push   $0x8c
80105ba9:	e9 34 f5 ff ff       	jmp    801050e2 <alltraps>

80105bae <vector141>:
80105bae:	6a 00                	push   $0x0
80105bb0:	68 8d 00 00 00       	push   $0x8d
80105bb5:	e9 28 f5 ff ff       	jmp    801050e2 <alltraps>

80105bba <vector142>:
80105bba:	6a 00                	push   $0x0
80105bbc:	68 8e 00 00 00       	push   $0x8e
80105bc1:	e9 1c f5 ff ff       	jmp    801050e2 <alltraps>

80105bc6 <vector143>:
80105bc6:	6a 00                	push   $0x0
80105bc8:	68 8f 00 00 00       	push   $0x8f
80105bcd:	e9 10 f5 ff ff       	jmp    801050e2 <alltraps>

80105bd2 <vector144>:
80105bd2:	6a 00                	push   $0x0
80105bd4:	68 90 00 00 00       	push   $0x90
80105bd9:	e9 04 f5 ff ff       	jmp    801050e2 <alltraps>

80105bde <vector145>:
80105bde:	6a 00                	push   $0x0
80105be0:	68 91 00 00 00       	push   $0x91
80105be5:	e9 f8 f4 ff ff       	jmp    801050e2 <alltraps>

80105bea <vector146>:
80105bea:	6a 00                	push   $0x0
80105bec:	68 92 00 00 00       	push   $0x92
80105bf1:	e9 ec f4 ff ff       	jmp    801050e2 <alltraps>

80105bf6 <vector147>:
80105bf6:	6a 00                	push   $0x0
80105bf8:	68 93 00 00 00       	push   $0x93
80105bfd:	e9 e0 f4 ff ff       	jmp    801050e2 <alltraps>

80105c02 <vector148>:
80105c02:	6a 00                	push   $0x0
80105c04:	68 94 00 00 00       	push   $0x94
80105c09:	e9 d4 f4 ff ff       	jmp    801050e2 <alltraps>

80105c0e <vector149>:
80105c0e:	6a 00                	push   $0x0
80105c10:	68 95 00 00 00       	push   $0x95
80105c15:	e9 c8 f4 ff ff       	jmp    801050e2 <alltraps>

80105c1a <vector150>:
80105c1a:	6a 00                	push   $0x0
80105c1c:	68 96 00 00 00       	push   $0x96
80105c21:	e9 bc f4 ff ff       	jmp    801050e2 <alltraps>

80105c26 <vector151>:
80105c26:	6a 00                	push   $0x0
80105c28:	68 97 00 00 00       	push   $0x97
80105c2d:	e9 b0 f4 ff ff       	jmp    801050e2 <alltraps>

80105c32 <vector152>:
80105c32:	6a 00                	push   $0x0
80105c34:	68 98 00 00 00       	push   $0x98
80105c39:	e9 a4 f4 ff ff       	jmp    801050e2 <alltraps>

80105c3e <vector153>:
80105c3e:	6a 00                	push   $0x0
80105c40:	68 99 00 00 00       	push   $0x99
80105c45:	e9 98 f4 ff ff       	jmp    801050e2 <alltraps>

80105c4a <vector154>:
80105c4a:	6a 00                	push   $0x0
80105c4c:	68 9a 00 00 00       	push   $0x9a
80105c51:	e9 8c f4 ff ff       	jmp    801050e2 <alltraps>

80105c56 <vector155>:
80105c56:	6a 00                	push   $0x0
80105c58:	68 9b 00 00 00       	push   $0x9b
80105c5d:	e9 80 f4 ff ff       	jmp    801050e2 <alltraps>

80105c62 <vector156>:
80105c62:	6a 00                	push   $0x0
80105c64:	68 9c 00 00 00       	push   $0x9c
80105c69:	e9 74 f4 ff ff       	jmp    801050e2 <alltraps>

80105c6e <vector157>:
80105c6e:	6a 00                	push   $0x0
80105c70:	68 9d 00 00 00       	push   $0x9d
80105c75:	e9 68 f4 ff ff       	jmp    801050e2 <alltraps>

80105c7a <vector158>:
80105c7a:	6a 00                	push   $0x0
80105c7c:	68 9e 00 00 00       	push   $0x9e
80105c81:	e9 5c f4 ff ff       	jmp    801050e2 <alltraps>

80105c86 <vector159>:
80105c86:	6a 00                	push   $0x0
80105c88:	68 9f 00 00 00       	push   $0x9f
80105c8d:	e9 50 f4 ff ff       	jmp    801050e2 <alltraps>

80105c92 <vector160>:
80105c92:	6a 00                	push   $0x0
80105c94:	68 a0 00 00 00       	push   $0xa0
80105c99:	e9 44 f4 ff ff       	jmp    801050e2 <alltraps>

80105c9e <vector161>:
80105c9e:	6a 00                	push   $0x0
80105ca0:	68 a1 00 00 00       	push   $0xa1
80105ca5:	e9 38 f4 ff ff       	jmp    801050e2 <alltraps>

80105caa <vector162>:
80105caa:	6a 00                	push   $0x0
80105cac:	68 a2 00 00 00       	push   $0xa2
80105cb1:	e9 2c f4 ff ff       	jmp    801050e2 <alltraps>

80105cb6 <vector163>:
80105cb6:	6a 00                	push   $0x0
80105cb8:	68 a3 00 00 00       	push   $0xa3
80105cbd:	e9 20 f4 ff ff       	jmp    801050e2 <alltraps>

80105cc2 <vector164>:
80105cc2:	6a 00                	push   $0x0
80105cc4:	68 a4 00 00 00       	push   $0xa4
80105cc9:	e9 14 f4 ff ff       	jmp    801050e2 <alltraps>

80105cce <vector165>:
80105cce:	6a 00                	push   $0x0
80105cd0:	68 a5 00 00 00       	push   $0xa5
80105cd5:	e9 08 f4 ff ff       	jmp    801050e2 <alltraps>

80105cda <vector166>:
80105cda:	6a 00                	push   $0x0
80105cdc:	68 a6 00 00 00       	push   $0xa6
80105ce1:	e9 fc f3 ff ff       	jmp    801050e2 <alltraps>

80105ce6 <vector167>:
80105ce6:	6a 00                	push   $0x0
80105ce8:	68 a7 00 00 00       	push   $0xa7
80105ced:	e9 f0 f3 ff ff       	jmp    801050e2 <alltraps>

80105cf2 <vector168>:
80105cf2:	6a 00                	push   $0x0
80105cf4:	68 a8 00 00 00       	push   $0xa8
80105cf9:	e9 e4 f3 ff ff       	jmp    801050e2 <alltraps>

80105cfe <vector169>:
80105cfe:	6a 00                	push   $0x0
80105d00:	68 a9 00 00 00       	push   $0xa9
80105d05:	e9 d8 f3 ff ff       	jmp    801050e2 <alltraps>

80105d0a <vector170>:
80105d0a:	6a 00                	push   $0x0
80105d0c:	68 aa 00 00 00       	push   $0xaa
80105d11:	e9 cc f3 ff ff       	jmp    801050e2 <alltraps>

80105d16 <vector171>:
80105d16:	6a 00                	push   $0x0
80105d18:	68 ab 00 00 00       	push   $0xab
80105d1d:	e9 c0 f3 ff ff       	jmp    801050e2 <alltraps>

80105d22 <vector172>:
80105d22:	6a 00                	push   $0x0
80105d24:	68 ac 00 00 00       	push   $0xac
80105d29:	e9 b4 f3 ff ff       	jmp    801050e2 <alltraps>

80105d2e <vector173>:
80105d2e:	6a 00                	push   $0x0
80105d30:	68 ad 00 00 00       	push   $0xad
80105d35:	e9 a8 f3 ff ff       	jmp    801050e2 <alltraps>

80105d3a <vector174>:
80105d3a:	6a 00                	push   $0x0
80105d3c:	68 ae 00 00 00       	push   $0xae
80105d41:	e9 9c f3 ff ff       	jmp    801050e2 <alltraps>

80105d46 <vector175>:
80105d46:	6a 00                	push   $0x0
80105d48:	68 af 00 00 00       	push   $0xaf
80105d4d:	e9 90 f3 ff ff       	jmp    801050e2 <alltraps>

80105d52 <vector176>:
80105d52:	6a 00                	push   $0x0
80105d54:	68 b0 00 00 00       	push   $0xb0
80105d59:	e9 84 f3 ff ff       	jmp    801050e2 <alltraps>

80105d5e <vector177>:
80105d5e:	6a 00                	push   $0x0
80105d60:	68 b1 00 00 00       	push   $0xb1
80105d65:	e9 78 f3 ff ff       	jmp    801050e2 <alltraps>

80105d6a <vector178>:
80105d6a:	6a 00                	push   $0x0
80105d6c:	68 b2 00 00 00       	push   $0xb2
80105d71:	e9 6c f3 ff ff       	jmp    801050e2 <alltraps>

80105d76 <vector179>:
80105d76:	6a 00                	push   $0x0
80105d78:	68 b3 00 00 00       	push   $0xb3
80105d7d:	e9 60 f3 ff ff       	jmp    801050e2 <alltraps>

80105d82 <vector180>:
80105d82:	6a 00                	push   $0x0
80105d84:	68 b4 00 00 00       	push   $0xb4
80105d89:	e9 54 f3 ff ff       	jmp    801050e2 <alltraps>

80105d8e <vector181>:
80105d8e:	6a 00                	push   $0x0
80105d90:	68 b5 00 00 00       	push   $0xb5
80105d95:	e9 48 f3 ff ff       	jmp    801050e2 <alltraps>

80105d9a <vector182>:
80105d9a:	6a 00                	push   $0x0
80105d9c:	68 b6 00 00 00       	push   $0xb6
80105da1:	e9 3c f3 ff ff       	jmp    801050e2 <alltraps>

80105da6 <vector183>:
80105da6:	6a 00                	push   $0x0
80105da8:	68 b7 00 00 00       	push   $0xb7
80105dad:	e9 30 f3 ff ff       	jmp    801050e2 <alltraps>

80105db2 <vector184>:
80105db2:	6a 00                	push   $0x0
80105db4:	68 b8 00 00 00       	push   $0xb8
80105db9:	e9 24 f3 ff ff       	jmp    801050e2 <alltraps>

80105dbe <vector185>:
80105dbe:	6a 00                	push   $0x0
80105dc0:	68 b9 00 00 00       	push   $0xb9
80105dc5:	e9 18 f3 ff ff       	jmp    801050e2 <alltraps>

80105dca <vector186>:
80105dca:	6a 00                	push   $0x0
80105dcc:	68 ba 00 00 00       	push   $0xba
80105dd1:	e9 0c f3 ff ff       	jmp    801050e2 <alltraps>

80105dd6 <vector187>:
80105dd6:	6a 00                	push   $0x0
80105dd8:	68 bb 00 00 00       	push   $0xbb
80105ddd:	e9 00 f3 ff ff       	jmp    801050e2 <alltraps>

80105de2 <vector188>:
80105de2:	6a 00                	push   $0x0
80105de4:	68 bc 00 00 00       	push   $0xbc
80105de9:	e9 f4 f2 ff ff       	jmp    801050e2 <alltraps>

80105dee <vector189>:
80105dee:	6a 00                	push   $0x0
80105df0:	68 bd 00 00 00       	push   $0xbd
80105df5:	e9 e8 f2 ff ff       	jmp    801050e2 <alltraps>

80105dfa <vector190>:
80105dfa:	6a 00                	push   $0x0
80105dfc:	68 be 00 00 00       	push   $0xbe
80105e01:	e9 dc f2 ff ff       	jmp    801050e2 <alltraps>

80105e06 <vector191>:
80105e06:	6a 00                	push   $0x0
80105e08:	68 bf 00 00 00       	push   $0xbf
80105e0d:	e9 d0 f2 ff ff       	jmp    801050e2 <alltraps>

80105e12 <vector192>:
80105e12:	6a 00                	push   $0x0
80105e14:	68 c0 00 00 00       	push   $0xc0
80105e19:	e9 c4 f2 ff ff       	jmp    801050e2 <alltraps>

80105e1e <vector193>:
80105e1e:	6a 00                	push   $0x0
80105e20:	68 c1 00 00 00       	push   $0xc1
80105e25:	e9 b8 f2 ff ff       	jmp    801050e2 <alltraps>

80105e2a <vector194>:
80105e2a:	6a 00                	push   $0x0
80105e2c:	68 c2 00 00 00       	push   $0xc2
80105e31:	e9 ac f2 ff ff       	jmp    801050e2 <alltraps>

80105e36 <vector195>:
80105e36:	6a 00                	push   $0x0
80105e38:	68 c3 00 00 00       	push   $0xc3
80105e3d:	e9 a0 f2 ff ff       	jmp    801050e2 <alltraps>

80105e42 <vector196>:
80105e42:	6a 00                	push   $0x0
80105e44:	68 c4 00 00 00       	push   $0xc4
80105e49:	e9 94 f2 ff ff       	jmp    801050e2 <alltraps>

80105e4e <vector197>:
80105e4e:	6a 00                	push   $0x0
80105e50:	68 c5 00 00 00       	push   $0xc5
80105e55:	e9 88 f2 ff ff       	jmp    801050e2 <alltraps>

80105e5a <vector198>:
80105e5a:	6a 00                	push   $0x0
80105e5c:	68 c6 00 00 00       	push   $0xc6
80105e61:	e9 7c f2 ff ff       	jmp    801050e2 <alltraps>

80105e66 <vector199>:
80105e66:	6a 00                	push   $0x0
80105e68:	68 c7 00 00 00       	push   $0xc7
80105e6d:	e9 70 f2 ff ff       	jmp    801050e2 <alltraps>

80105e72 <vector200>:
80105e72:	6a 00                	push   $0x0
80105e74:	68 c8 00 00 00       	push   $0xc8
80105e79:	e9 64 f2 ff ff       	jmp    801050e2 <alltraps>

80105e7e <vector201>:
80105e7e:	6a 00                	push   $0x0
80105e80:	68 c9 00 00 00       	push   $0xc9
80105e85:	e9 58 f2 ff ff       	jmp    801050e2 <alltraps>

80105e8a <vector202>:
80105e8a:	6a 00                	push   $0x0
80105e8c:	68 ca 00 00 00       	push   $0xca
80105e91:	e9 4c f2 ff ff       	jmp    801050e2 <alltraps>

80105e96 <vector203>:
80105e96:	6a 00                	push   $0x0
80105e98:	68 cb 00 00 00       	push   $0xcb
80105e9d:	e9 40 f2 ff ff       	jmp    801050e2 <alltraps>

80105ea2 <vector204>:
80105ea2:	6a 00                	push   $0x0
80105ea4:	68 cc 00 00 00       	push   $0xcc
80105ea9:	e9 34 f2 ff ff       	jmp    801050e2 <alltraps>

80105eae <vector205>:
80105eae:	6a 00                	push   $0x0
80105eb0:	68 cd 00 00 00       	push   $0xcd
80105eb5:	e9 28 f2 ff ff       	jmp    801050e2 <alltraps>

80105eba <vector206>:
80105eba:	6a 00                	push   $0x0
80105ebc:	68 ce 00 00 00       	push   $0xce
80105ec1:	e9 1c f2 ff ff       	jmp    801050e2 <alltraps>

80105ec6 <vector207>:
80105ec6:	6a 00                	push   $0x0
80105ec8:	68 cf 00 00 00       	push   $0xcf
80105ecd:	e9 10 f2 ff ff       	jmp    801050e2 <alltraps>

80105ed2 <vector208>:
80105ed2:	6a 00                	push   $0x0
80105ed4:	68 d0 00 00 00       	push   $0xd0
80105ed9:	e9 04 f2 ff ff       	jmp    801050e2 <alltraps>

80105ede <vector209>:
80105ede:	6a 00                	push   $0x0
80105ee0:	68 d1 00 00 00       	push   $0xd1
80105ee5:	e9 f8 f1 ff ff       	jmp    801050e2 <alltraps>

80105eea <vector210>:
80105eea:	6a 00                	push   $0x0
80105eec:	68 d2 00 00 00       	push   $0xd2
80105ef1:	e9 ec f1 ff ff       	jmp    801050e2 <alltraps>

80105ef6 <vector211>:
80105ef6:	6a 00                	push   $0x0
80105ef8:	68 d3 00 00 00       	push   $0xd3
80105efd:	e9 e0 f1 ff ff       	jmp    801050e2 <alltraps>

80105f02 <vector212>:
80105f02:	6a 00                	push   $0x0
80105f04:	68 d4 00 00 00       	push   $0xd4
80105f09:	e9 d4 f1 ff ff       	jmp    801050e2 <alltraps>

80105f0e <vector213>:
80105f0e:	6a 00                	push   $0x0
80105f10:	68 d5 00 00 00       	push   $0xd5
80105f15:	e9 c8 f1 ff ff       	jmp    801050e2 <alltraps>

80105f1a <vector214>:
80105f1a:	6a 00                	push   $0x0
80105f1c:	68 d6 00 00 00       	push   $0xd6
80105f21:	e9 bc f1 ff ff       	jmp    801050e2 <alltraps>

80105f26 <vector215>:
80105f26:	6a 00                	push   $0x0
80105f28:	68 d7 00 00 00       	push   $0xd7
80105f2d:	e9 b0 f1 ff ff       	jmp    801050e2 <alltraps>

80105f32 <vector216>:
80105f32:	6a 00                	push   $0x0
80105f34:	68 d8 00 00 00       	push   $0xd8
80105f39:	e9 a4 f1 ff ff       	jmp    801050e2 <alltraps>

80105f3e <vector217>:
80105f3e:	6a 00                	push   $0x0
80105f40:	68 d9 00 00 00       	push   $0xd9
80105f45:	e9 98 f1 ff ff       	jmp    801050e2 <alltraps>

80105f4a <vector218>:
80105f4a:	6a 00                	push   $0x0
80105f4c:	68 da 00 00 00       	push   $0xda
80105f51:	e9 8c f1 ff ff       	jmp    801050e2 <alltraps>

80105f56 <vector219>:
80105f56:	6a 00                	push   $0x0
80105f58:	68 db 00 00 00       	push   $0xdb
80105f5d:	e9 80 f1 ff ff       	jmp    801050e2 <alltraps>

80105f62 <vector220>:
80105f62:	6a 00                	push   $0x0
80105f64:	68 dc 00 00 00       	push   $0xdc
80105f69:	e9 74 f1 ff ff       	jmp    801050e2 <alltraps>

80105f6e <vector221>:
80105f6e:	6a 00                	push   $0x0
80105f70:	68 dd 00 00 00       	push   $0xdd
80105f75:	e9 68 f1 ff ff       	jmp    801050e2 <alltraps>

80105f7a <vector222>:
80105f7a:	6a 00                	push   $0x0
80105f7c:	68 de 00 00 00       	push   $0xde
80105f81:	e9 5c f1 ff ff       	jmp    801050e2 <alltraps>

80105f86 <vector223>:
80105f86:	6a 00                	push   $0x0
80105f88:	68 df 00 00 00       	push   $0xdf
80105f8d:	e9 50 f1 ff ff       	jmp    801050e2 <alltraps>

80105f92 <vector224>:
80105f92:	6a 00                	push   $0x0
80105f94:	68 e0 00 00 00       	push   $0xe0
80105f99:	e9 44 f1 ff ff       	jmp    801050e2 <alltraps>

80105f9e <vector225>:
80105f9e:	6a 00                	push   $0x0
80105fa0:	68 e1 00 00 00       	push   $0xe1
80105fa5:	e9 38 f1 ff ff       	jmp    801050e2 <alltraps>

80105faa <vector226>:
80105faa:	6a 00                	push   $0x0
80105fac:	68 e2 00 00 00       	push   $0xe2
80105fb1:	e9 2c f1 ff ff       	jmp    801050e2 <alltraps>

80105fb6 <vector227>:
80105fb6:	6a 00                	push   $0x0
80105fb8:	68 e3 00 00 00       	push   $0xe3
80105fbd:	e9 20 f1 ff ff       	jmp    801050e2 <alltraps>

80105fc2 <vector228>:
80105fc2:	6a 00                	push   $0x0
80105fc4:	68 e4 00 00 00       	push   $0xe4
80105fc9:	e9 14 f1 ff ff       	jmp    801050e2 <alltraps>

80105fce <vector229>:
80105fce:	6a 00                	push   $0x0
80105fd0:	68 e5 00 00 00       	push   $0xe5
80105fd5:	e9 08 f1 ff ff       	jmp    801050e2 <alltraps>

80105fda <vector230>:
80105fda:	6a 00                	push   $0x0
80105fdc:	68 e6 00 00 00       	push   $0xe6
80105fe1:	e9 fc f0 ff ff       	jmp    801050e2 <alltraps>

80105fe6 <vector231>:
80105fe6:	6a 00                	push   $0x0
80105fe8:	68 e7 00 00 00       	push   $0xe7
80105fed:	e9 f0 f0 ff ff       	jmp    801050e2 <alltraps>

80105ff2 <vector232>:
80105ff2:	6a 00                	push   $0x0
80105ff4:	68 e8 00 00 00       	push   $0xe8
80105ff9:	e9 e4 f0 ff ff       	jmp    801050e2 <alltraps>

80105ffe <vector233>:
80105ffe:	6a 00                	push   $0x0
80106000:	68 e9 00 00 00       	push   $0xe9
80106005:	e9 d8 f0 ff ff       	jmp    801050e2 <alltraps>

8010600a <vector234>:
8010600a:	6a 00                	push   $0x0
8010600c:	68 ea 00 00 00       	push   $0xea
80106011:	e9 cc f0 ff ff       	jmp    801050e2 <alltraps>

80106016 <vector235>:
80106016:	6a 00                	push   $0x0
80106018:	68 eb 00 00 00       	push   $0xeb
8010601d:	e9 c0 f0 ff ff       	jmp    801050e2 <alltraps>

80106022 <vector236>:
80106022:	6a 00                	push   $0x0
80106024:	68 ec 00 00 00       	push   $0xec
80106029:	e9 b4 f0 ff ff       	jmp    801050e2 <alltraps>

8010602e <vector237>:
8010602e:	6a 00                	push   $0x0
80106030:	68 ed 00 00 00       	push   $0xed
80106035:	e9 a8 f0 ff ff       	jmp    801050e2 <alltraps>

8010603a <vector238>:
8010603a:	6a 00                	push   $0x0
8010603c:	68 ee 00 00 00       	push   $0xee
80106041:	e9 9c f0 ff ff       	jmp    801050e2 <alltraps>

80106046 <vector239>:
80106046:	6a 00                	push   $0x0
80106048:	68 ef 00 00 00       	push   $0xef
8010604d:	e9 90 f0 ff ff       	jmp    801050e2 <alltraps>

80106052 <vector240>:
80106052:	6a 00                	push   $0x0
80106054:	68 f0 00 00 00       	push   $0xf0
80106059:	e9 84 f0 ff ff       	jmp    801050e2 <alltraps>

8010605e <vector241>:
8010605e:	6a 00                	push   $0x0
80106060:	68 f1 00 00 00       	push   $0xf1
80106065:	e9 78 f0 ff ff       	jmp    801050e2 <alltraps>

8010606a <vector242>:
8010606a:	6a 00                	push   $0x0
8010606c:	68 f2 00 00 00       	push   $0xf2
80106071:	e9 6c f0 ff ff       	jmp    801050e2 <alltraps>

80106076 <vector243>:
80106076:	6a 00                	push   $0x0
80106078:	68 f3 00 00 00       	push   $0xf3
8010607d:	e9 60 f0 ff ff       	jmp    801050e2 <alltraps>

80106082 <vector244>:
80106082:	6a 00                	push   $0x0
80106084:	68 f4 00 00 00       	push   $0xf4
80106089:	e9 54 f0 ff ff       	jmp    801050e2 <alltraps>

8010608e <vector245>:
8010608e:	6a 00                	push   $0x0
80106090:	68 f5 00 00 00       	push   $0xf5
80106095:	e9 48 f0 ff ff       	jmp    801050e2 <alltraps>

8010609a <vector246>:
8010609a:	6a 00                	push   $0x0
8010609c:	68 f6 00 00 00       	push   $0xf6
801060a1:	e9 3c f0 ff ff       	jmp    801050e2 <alltraps>

801060a6 <vector247>:
801060a6:	6a 00                	push   $0x0
801060a8:	68 f7 00 00 00       	push   $0xf7
801060ad:	e9 30 f0 ff ff       	jmp    801050e2 <alltraps>

801060b2 <vector248>:
801060b2:	6a 00                	push   $0x0
801060b4:	68 f8 00 00 00       	push   $0xf8
801060b9:	e9 24 f0 ff ff       	jmp    801050e2 <alltraps>

801060be <vector249>:
801060be:	6a 00                	push   $0x0
801060c0:	68 f9 00 00 00       	push   $0xf9
801060c5:	e9 18 f0 ff ff       	jmp    801050e2 <alltraps>

801060ca <vector250>:
801060ca:	6a 00                	push   $0x0
801060cc:	68 fa 00 00 00       	push   $0xfa
801060d1:	e9 0c f0 ff ff       	jmp    801050e2 <alltraps>

801060d6 <vector251>:
801060d6:	6a 00                	push   $0x0
801060d8:	68 fb 00 00 00       	push   $0xfb
801060dd:	e9 00 f0 ff ff       	jmp    801050e2 <alltraps>

801060e2 <vector252>:
801060e2:	6a 00                	push   $0x0
801060e4:	68 fc 00 00 00       	push   $0xfc
801060e9:	e9 f4 ef ff ff       	jmp    801050e2 <alltraps>

801060ee <vector253>:
801060ee:	6a 00                	push   $0x0
801060f0:	68 fd 00 00 00       	push   $0xfd
801060f5:	e9 e8 ef ff ff       	jmp    801050e2 <alltraps>

801060fa <vector254>:
801060fa:	6a 00                	push   $0x0
801060fc:	68 fe 00 00 00       	push   $0xfe
80106101:	e9 dc ef ff ff       	jmp    801050e2 <alltraps>

80106106 <vector255>:
80106106:	6a 00                	push   $0x0
80106108:	68 ff 00 00 00       	push   $0xff
8010610d:	e9 d0 ef ff ff       	jmp    801050e2 <alltraps>

80106112 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106112:	55                   	push   %ebp
80106113:	89 e5                	mov    %esp,%ebp
80106115:	57                   	push   %edi
80106116:	56                   	push   %esi
80106117:	53                   	push   %ebx
80106118:	83 ec 2c             	sub    $0x2c,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010611b:	e8 c9 d1 ff ff       	call   801032e9 <cpuid>
80106120:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106122:	8d 14 80             	lea    (%eax,%eax,4),%edx
80106125:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80106128:	8d 04 01             	lea    (%ecx,%eax,1),%eax
8010612b:	c1 e0 04             	shl    $0x4,%eax
8010612e:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
80106135:	ff ff 
80106137:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
8010613e:	00 00 
80106140:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80106147:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
8010614a:	01 d9                	add    %ebx,%ecx
8010614c:	c1 e1 04             	shl    $0x4,%ecx
8010614f:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80106156:	83 e6 f0             	and    $0xfffffff0,%esi
80106159:	89 f7                	mov    %esi,%edi
8010615b:	83 cf 0a             	or     $0xa,%edi
8010615e:	89 fa                	mov    %edi,%edx
80106160:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106166:	83 ce 1a             	or     $0x1a,%esi
80106169:	89 f2                	mov    %esi,%edx
8010616b:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106171:	83 e6 9f             	and    $0xffffff9f,%esi
80106174:	89 f2                	mov    %esi,%edx
80106176:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
8010617c:	83 ce 80             	or     $0xffffff80,%esi
8010617f:	89 f2                	mov    %esi,%edx
80106181:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106187:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
8010618e:	83 ce 0f             	or     $0xf,%esi
80106191:	89 f2                	mov    %esi,%edx
80106193:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106199:	89 f7                	mov    %esi,%edi
8010619b:	83 e7 ef             	and    $0xffffffef,%edi
8010619e:	89 fa                	mov    %edi,%edx
801061a0:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801061a6:	83 e6 cf             	and    $0xffffffcf,%esi
801061a9:	89 f2                	mov    %esi,%edx
801061ab:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801061b1:	89 f7                	mov    %esi,%edi
801061b3:	83 cf 40             	or     $0x40,%edi
801061b6:	89 fa                	mov    %edi,%edx
801061b8:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801061be:	83 ce c0             	or     $0xffffffc0,%esi
801061c1:	89 f2                	mov    %esi,%edx
801061c3:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801061c9:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801061d0:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
801061d7:	ff ff 
801061d9:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
801061e0:	00 00 
801061e2:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
801061e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801061ec:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801061ef:	c1 e1 04             	shl    $0x4,%ecx
801061f2:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
801061f9:	83 e6 f0             	and    $0xfffffff0,%esi
801061fc:	89 f7                	mov    %esi,%edi
801061fe:	83 cf 02             	or     $0x2,%edi
80106201:	89 fa                	mov    %edi,%edx
80106203:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106209:	83 ce 12             	or     $0x12,%esi
8010620c:	89 f2                	mov    %esi,%edx
8010620e:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106214:	83 e6 9f             	and    $0xffffff9f,%esi
80106217:	89 f2                	mov    %esi,%edx
80106219:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
8010621f:	83 ce 80             	or     $0xffffff80,%esi
80106222:	89 f2                	mov    %esi,%edx
80106224:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
8010622a:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80106231:	83 ce 0f             	or     $0xf,%esi
80106234:	89 f2                	mov    %esi,%edx
80106236:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010623c:	89 f7                	mov    %esi,%edi
8010623e:	83 e7 ef             	and    $0xffffffef,%edi
80106241:	89 fa                	mov    %edi,%edx
80106243:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106249:	83 e6 cf             	and    $0xffffffcf,%esi
8010624c:	89 f2                	mov    %esi,%edx
8010624e:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106254:	89 f7                	mov    %esi,%edi
80106256:	83 cf 40             	or     $0x40,%edi
80106259:	89 fa                	mov    %edi,%edx
8010625b:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106261:	83 ce c0             	or     $0xffffffc0,%esi
80106264:	89 f2                	mov    %esi,%edx
80106266:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010626c:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106273:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
8010627a:	ff ff 
8010627c:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
80106283:	00 00 
80106285:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
8010628c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010628f:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106292:	c1 e1 04             	shl    $0x4,%ecx
80106295:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
8010629c:	83 e6 f0             	and    $0xfffffff0,%esi
8010629f:	89 f7                	mov    %esi,%edi
801062a1:	83 cf 0a             	or     $0xa,%edi
801062a4:	89 fa                	mov    %edi,%edx
801062a6:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801062ac:	89 f7                	mov    %esi,%edi
801062ae:	83 cf 1a             	or     $0x1a,%edi
801062b1:	89 fa                	mov    %edi,%edx
801062b3:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801062b9:	83 ce 7a             	or     $0x7a,%esi
801062bc:	89 f2                	mov    %esi,%edx
801062be:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801062c4:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
801062cb:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
801062d2:	83 ce 0f             	or     $0xf,%esi
801062d5:	89 f2                	mov    %esi,%edx
801062d7:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062dd:	89 f7                	mov    %esi,%edi
801062df:	83 e7 ef             	and    $0xffffffef,%edi
801062e2:	89 fa                	mov    %edi,%edx
801062e4:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062ea:	83 e6 cf             	and    $0xffffffcf,%esi
801062ed:	89 f2                	mov    %esi,%edx
801062ef:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062f5:	89 f7                	mov    %esi,%edi
801062f7:	83 cf 40             	or     $0x40,%edi
801062fa:	89 fa                	mov    %edi,%edx
801062fc:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106302:	83 ce c0             	or     $0xffffffc0,%esi
80106305:	89 f2                	mov    %esi,%edx
80106307:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010630d:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106314:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
8010631b:	ff ff 
8010631d:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
80106324:	00 00 
80106326:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
8010632d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106330:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106333:	c1 e1 04             	shl    $0x4,%ecx
80106336:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
8010633d:	83 e6 f0             	and    $0xfffffff0,%esi
80106340:	89 f7                	mov    %esi,%edi
80106342:	83 cf 02             	or     $0x2,%edi
80106345:	89 fa                	mov    %edi,%edx
80106347:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010634d:	89 f7                	mov    %esi,%edi
8010634f:	83 cf 12             	or     $0x12,%edi
80106352:	89 fa                	mov    %edi,%edx
80106354:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010635a:	83 ce 72             	or     $0x72,%esi
8010635d:	89 f2                	mov    %esi,%edx
8010635f:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106365:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
8010636c:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
80106373:	83 ce 0f             	or     $0xf,%esi
80106376:	89 f2                	mov    %esi,%edx
80106378:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010637e:	89 f7                	mov    %esi,%edi
80106380:	83 e7 ef             	and    $0xffffffef,%edi
80106383:	89 fa                	mov    %edi,%edx
80106385:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010638b:	83 e6 cf             	and    $0xffffffcf,%esi
8010638e:	89 f2                	mov    %esi,%edx
80106390:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106396:	89 f7                	mov    %esi,%edi
80106398:	83 cf 40             	or     $0x40,%edi
8010639b:	89 fa                	mov    %edi,%edx
8010639d:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801063a3:	83 ce c0             	or     $0xffffffc0,%esi
801063a6:	89 f2                	mov    %esi,%edx
801063a8:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801063ae:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801063b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801063b8:	01 da                	add    %ebx,%edx
801063ba:	c1 e2 04             	shl    $0x4,%edx
801063bd:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
801063c3:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
801063c9:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
801063cd:	c1 ea 10             	shr    $0x10,%edx
801063d0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801063d4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801063d7:	0f 01 10             	lgdtl  (%eax)
}
801063da:	83 c4 2c             	add    $0x2c,%esp
801063dd:	5b                   	pop    %ebx
801063de:	5e                   	pop    %esi
801063df:	5f                   	pop    %edi
801063e0:	5d                   	pop    %ebp
801063e1:	c3                   	ret    

801063e2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801063e2:	55                   	push   %ebp
801063e3:	89 e5                	mov    %esp,%ebp
801063e5:	56                   	push   %esi
801063e6:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801063e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801063ea:	c1 ee 16             	shr    $0x16,%esi
801063ed:	c1 e6 02             	shl    $0x2,%esi
801063f0:	03 75 08             	add    0x8(%ebp),%esi
  if(*pde & PTE_P){
801063f3:	8b 1e                	mov    (%esi),%ebx
801063f5:	f6 c3 01             	test   $0x1,%bl
801063f8:	74 21                	je     8010641b <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801063fa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106400:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106406:	8b 45 0c             	mov    0xc(%ebp),%eax
80106409:	c1 e8 0c             	shr    $0xc,%eax
8010640c:	25 ff 03 00 00       	and    $0x3ff,%eax
80106411:	8d 04 83             	lea    (%ebx,%eax,4),%eax
}
80106414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106417:	5b                   	pop    %ebx
80106418:	5e                   	pop    %esi
80106419:	5d                   	pop    %ebp
8010641a:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010641b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010641f:	74 2b                	je     8010644c <walkpgdir+0x6a>
80106421:	e8 01 bc ff ff       	call   80102027 <kalloc>
80106426:	89 c3                	mov    %eax,%ebx
80106428:	85 c0                	test   %eax,%eax
8010642a:	74 20                	je     8010644c <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
8010642c:	83 ec 04             	sub    $0x4,%esp
8010642f:	68 00 10 00 00       	push   $0x1000
80106434:	6a 00                	push   $0x0
80106436:	50                   	push   %eax
80106437:	e8 be d9 ff ff       	call   80103dfa <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010643c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106442:	83 c8 07             	or     $0x7,%eax
80106445:	89 06                	mov    %eax,(%esi)
80106447:	83 c4 10             	add    $0x10,%esp
8010644a:	eb ba                	jmp    80106406 <walkpgdir+0x24>
      return 0;
8010644c:	b8 00 00 00 00       	mov    $0x0,%eax
80106451:	eb c1                	jmp    80106414 <walkpgdir+0x32>

80106453 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106453:	55                   	push   %ebp
80106454:	89 e5                	mov    %esp,%ebp
80106456:	57                   	push   %edi
80106457:	56                   	push   %esi
80106458:	53                   	push   %ebx
80106459:	83 ec 1c             	sub    $0x1c,%esp
8010645c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010645f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106462:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106465:	89 c3                	mov    %eax,%ebx
80106467:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010646d:	03 45 10             	add    0x10(%ebp),%eax
80106470:	48                   	dec    %eax
80106471:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106479:	83 ec 04             	sub    $0x4,%esp
8010647c:	6a 01                	push   $0x1
8010647e:	53                   	push   %ebx
8010647f:	57                   	push   %edi
80106480:	e8 5d ff ff ff       	call   801063e2 <walkpgdir>
80106485:	83 c4 10             	add    $0x10,%esp
80106488:	85 c0                	test   %eax,%eax
8010648a:	74 2f                	je     801064bb <mappages+0x68>
      return -1;
    if(*pte & PTE_P)
8010648c:	f6 00 01             	testb  $0x1,(%eax)
8010648f:	75 1d                	jne    801064ae <mappages+0x5b>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106491:	89 f2                	mov    %esi,%edx
80106493:	0b 55 18             	or     0x18(%ebp),%edx
80106496:	83 ca 01             	or     $0x1,%edx
80106499:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010649b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010649e:	74 28                	je     801064c8 <mappages+0x75>
      break;
    a += PGSIZE;
801064a0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801064a6:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801064ac:	eb cb                	jmp    80106479 <mappages+0x26>
      panic("remap");
801064ae:	83 ec 0c             	sub    $0xc,%esp
801064b1:	68 40 75 10 80       	push   $0x80107540
801064b6:	e8 86 9e ff ff       	call   80100341 <panic>
      return -1;
801064bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801064c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064c3:	5b                   	pop    %ebx
801064c4:	5e                   	pop    %esi
801064c5:	5f                   	pop    %edi
801064c6:	5d                   	pop    %ebp
801064c7:	c3                   	ret    
  return 0;
801064c8:	b8 00 00 00 00       	mov    $0x0,%eax
801064cd:	eb f1                	jmp    801064c0 <mappages+0x6d>

801064cf <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801064cf:	a1 24 48 11 80       	mov    0x80114824,%eax
801064d4:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801064d9:	0f 22 d8             	mov    %eax,%cr3
}
801064dc:	c3                   	ret    

801064dd <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801064dd:	55                   	push   %ebp
801064de:	89 e5                	mov    %esp,%ebp
801064e0:	57                   	push   %edi
801064e1:	56                   	push   %esi
801064e2:	53                   	push   %ebx
801064e3:	83 ec 1c             	sub    $0x1c,%esp
801064e6:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801064e9:	85 f6                	test   %esi,%esi
801064eb:	0f 84 21 01 00 00    	je     80106612 <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801064f1:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801064f5:	0f 84 24 01 00 00    	je     8010661f <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801064fb:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801064ff:	0f 84 27 01 00 00    	je     8010662c <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
80106505:	e8 6a d7 ff ff       	call   80103c74 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010650a:	e8 76 cd ff ff       	call   80103285 <mycpu>
8010650f:	89 c3                	mov    %eax,%ebx
80106511:	e8 6f cd ff ff       	call   80103285 <mycpu>
80106516:	8d 78 08             	lea    0x8(%eax),%edi
80106519:	e8 67 cd ff ff       	call   80103285 <mycpu>
8010651e:	83 c0 08             	add    $0x8,%eax
80106521:	c1 e8 10             	shr    $0x10,%eax
80106524:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106527:	e8 59 cd ff ff       	call   80103285 <mycpu>
8010652c:	83 c0 08             	add    $0x8,%eax
8010652f:	c1 e8 18             	shr    $0x18,%eax
80106532:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106539:	67 00 
8010653b:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106542:	8a 4d e4             	mov    -0x1c(%ebp),%cl
80106545:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010654b:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106551:	83 e2 f0             	and    $0xfffffff0,%edx
80106554:	88 d1                	mov    %dl,%cl
80106556:	83 c9 09             	or     $0x9,%ecx
80106559:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
8010655f:	83 ca 19             	or     $0x19,%edx
80106562:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106568:	83 e2 9f             	and    $0xffffff9f,%edx
8010656b:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106571:	83 ca 80             	or     $0xffffff80,%edx
80106574:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010657a:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80106580:	88 d1                	mov    %dl,%cl
80106582:	83 e1 f0             	and    $0xfffffff0,%ecx
80106585:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010658b:	88 d1                	mov    %dl,%cl
8010658d:	83 e1 e0             	and    $0xffffffe0,%ecx
80106590:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106596:	83 e2 c0             	and    $0xffffffc0,%edx
80106599:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010659f:	83 ca 40             	or     $0x40,%edx
801065a2:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801065a8:	83 e2 7f             	and    $0x7f,%edx
801065ab:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801065b1:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801065b7:	e8 c9 cc ff ff       	call   80103285 <mycpu>
801065bc:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801065c2:	83 e2 ef             	and    $0xffffffef,%edx
801065c5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801065cb:	e8 b5 cc ff ff       	call   80103285 <mycpu>
801065d0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801065d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801065d9:	e8 a7 cc ff ff       	call   80103285 <mycpu>
801065de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801065e7:	e8 99 cc ff ff       	call   80103285 <mycpu>
801065ec:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801065f2:	b8 28 00 00 00       	mov    $0x28,%eax
801065f7:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801065fa:	8b 46 04             	mov    0x4(%esi),%eax
801065fd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106602:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106605:	e8 a5 d6 ff ff       	call   80103caf <popcli>
}
8010660a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010660d:	5b                   	pop    %ebx
8010660e:	5e                   	pop    %esi
8010660f:	5f                   	pop    %edi
80106610:	5d                   	pop    %ebp
80106611:	c3                   	ret    
    panic("switchuvm: no process");
80106612:	83 ec 0c             	sub    $0xc,%esp
80106615:	68 46 75 10 80       	push   $0x80107546
8010661a:	e8 22 9d ff ff       	call   80100341 <panic>
    panic("switchuvm: no kstack");
8010661f:	83 ec 0c             	sub    $0xc,%esp
80106622:	68 5c 75 10 80       	push   $0x8010755c
80106627:	e8 15 9d ff ff       	call   80100341 <panic>
    panic("switchuvm: no pgdir");
8010662c:	83 ec 0c             	sub    $0xc,%esp
8010662f:	68 71 75 10 80       	push   $0x80107571
80106634:	e8 08 9d ff ff       	call   80100341 <panic>

80106639 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106639:	55                   	push   %ebp
8010663a:	89 e5                	mov    %esp,%ebp
8010663c:	56                   	push   %esi
8010663d:	53                   	push   %ebx
8010663e:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106641:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106647:	77 4b                	ja     80106694 <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
80106649:	e8 d9 b9 ff ff       	call   80102027 <kalloc>
8010664e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106650:	83 ec 04             	sub    $0x4,%esp
80106653:	68 00 10 00 00       	push   $0x1000
80106658:	6a 00                	push   $0x0
8010665a:	50                   	push   %eax
8010665b:	e8 9a d7 ff ff       	call   80103dfa <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106660:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106667:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010666d:	50                   	push   %eax
8010666e:	68 00 10 00 00       	push   $0x1000
80106673:	6a 00                	push   $0x0
80106675:	ff 75 08             	push   0x8(%ebp)
80106678:	e8 d6 fd ff ff       	call   80106453 <mappages>
  memmove(mem, init, sz);
8010667d:	83 c4 1c             	add    $0x1c,%esp
80106680:	56                   	push   %esi
80106681:	ff 75 0c             	push   0xc(%ebp)
80106684:	53                   	push   %ebx
80106685:	e8 e6 d7 ff ff       	call   80103e70 <memmove>
}
8010668a:	83 c4 10             	add    $0x10,%esp
8010668d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106690:	5b                   	pop    %ebx
80106691:	5e                   	pop    %esi
80106692:	5d                   	pop    %ebp
80106693:	c3                   	ret    
    panic("inituvm: more than a page");
80106694:	83 ec 0c             	sub    $0xc,%esp
80106697:	68 85 75 10 80       	push   $0x80107585
8010669c:	e8 a0 9c ff ff       	call   80100341 <panic>

801066a1 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801066a1:	55                   	push   %ebp
801066a2:	89 e5                	mov    %esp,%ebp
801066a4:	57                   	push   %edi
801066a5:	56                   	push   %esi
801066a6:	53                   	push   %ebx
801066a7:	83 ec 0c             	sub    $0xc,%esp
801066aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801066ad:	89 fb                	mov    %edi,%ebx
801066af:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801066b5:	74 3c                	je     801066f3 <loaduvm+0x52>
    panic("loaduvm: addr must be page aligned");
801066b7:	83 ec 0c             	sub    $0xc,%esp
801066ba:	68 0c 76 10 80       	push   $0x8010760c
801066bf:	e8 7d 9c ff ff       	call   80100341 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801066c4:	83 ec 0c             	sub    $0xc,%esp
801066c7:	68 9f 75 10 80       	push   $0x8010759f
801066cc:	e8 70 9c ff ff       	call   80100341 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801066d1:	05 00 00 00 80       	add    $0x80000000,%eax
801066d6:	56                   	push   %esi
801066d7:	89 da                	mov    %ebx,%edx
801066d9:	03 55 14             	add    0x14(%ebp),%edx
801066dc:	52                   	push   %edx
801066dd:	50                   	push   %eax
801066de:	ff 75 10             	push   0x10(%ebp)
801066e1:	e8 0d b0 ff ff       	call   801016f3 <readi>
801066e6:	83 c4 10             	add    $0x10,%esp
801066e9:	39 f0                	cmp    %esi,%eax
801066eb:	75 4b                	jne    80106738 <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
801066ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066f3:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801066f6:	73 33                	jae    8010672b <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801066f8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
801066fb:	83 ec 04             	sub    $0x4,%esp
801066fe:	6a 00                	push   $0x0
80106700:	50                   	push   %eax
80106701:	ff 75 08             	push   0x8(%ebp)
80106704:	e8 d9 fc ff ff       	call   801063e2 <walkpgdir>
80106709:	83 c4 10             	add    $0x10,%esp
8010670c:	85 c0                	test   %eax,%eax
8010670e:	74 b4                	je     801066c4 <loaduvm+0x23>
    pa = PTE_ADDR(*pte);
80106710:	8b 00                	mov    (%eax),%eax
80106712:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106717:	8b 75 18             	mov    0x18(%ebp),%esi
8010671a:	29 de                	sub    %ebx,%esi
8010671c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106722:	76 ad                	jbe    801066d1 <loaduvm+0x30>
      n = PGSIZE;
80106724:	be 00 10 00 00       	mov    $0x1000,%esi
80106729:	eb a6                	jmp    801066d1 <loaduvm+0x30>
      return -1;
  }
  return 0;
8010672b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106730:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106733:	5b                   	pop    %ebx
80106734:	5e                   	pop    %esi
80106735:	5f                   	pop    %edi
80106736:	5d                   	pop    %ebp
80106737:	c3                   	ret    
      return -1;
80106738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673d:	eb f1                	jmp    80106730 <loaduvm+0x8f>

8010673f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010673f:	55                   	push   %ebp
80106740:	89 e5                	mov    %esp,%ebp
80106742:	57                   	push   %edi
80106743:	56                   	push   %esi
80106744:	53                   	push   %ebx
80106745:	83 ec 0c             	sub    $0xc,%esp
80106748:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010674b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010674e:	39 45 10             	cmp    %eax,0x10(%ebp)
80106751:	73 74                	jae    801067c7 <deallocuvm+0x88>
    return oldsz;

  a = PGROUNDUP(newsz);
80106753:	8b 45 10             	mov    0x10(%ebp),%eax
80106756:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010675c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106762:	eb 13                	jmp    80106777 <deallocuvm+0x38>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106764:	c1 eb 16             	shr    $0x16,%ebx
80106767:	43                   	inc    %ebx
80106768:	c1 e3 16             	shl    $0x16,%ebx
8010676b:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106777:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
8010677a:	73 48                	jae    801067c4 <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010677c:	83 ec 04             	sub    $0x4,%esp
8010677f:	6a 00                	push   $0x0
80106781:	53                   	push   %ebx
80106782:	57                   	push   %edi
80106783:	e8 5a fc ff ff       	call   801063e2 <walkpgdir>
80106788:	89 c6                	mov    %eax,%esi
    if(!pte)
8010678a:	83 c4 10             	add    $0x10,%esp
8010678d:	85 c0                	test   %eax,%eax
8010678f:	74 d3                	je     80106764 <deallocuvm+0x25>
    else if((*pte & PTE_P) != 0){
80106791:	8b 00                	mov    (%eax),%eax
80106793:	a8 01                	test   $0x1,%al
80106795:	74 da                	je     80106771 <deallocuvm+0x32>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106797:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010679c:	74 19                	je     801067b7 <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
8010679e:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801067a3:	83 ec 0c             	sub    $0xc,%esp
801067a6:	50                   	push   %eax
801067a7:	e8 64 b7 ff ff       	call   80101f10 <kfree>
      *pte = 0;
801067ac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	eb ba                	jmp    80106771 <deallocuvm+0x32>
        panic("kfree");
801067b7:	83 ec 0c             	sub    $0xc,%esp
801067ba:	68 e6 6d 10 80       	push   $0x80106de6
801067bf:	e8 7d 9b ff ff       	call   80100341 <panic>
    }
  }
  return newsz;
801067c4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801067c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ca:	5b                   	pop    %ebx
801067cb:	5e                   	pop    %esi
801067cc:	5f                   	pop    %edi
801067cd:	5d                   	pop    %ebp
801067ce:	c3                   	ret    

801067cf <allocuvm>:
{
801067cf:	55                   	push   %ebp
801067d0:	89 e5                	mov    %esp,%ebp
801067d2:	57                   	push   %edi
801067d3:	56                   	push   %esi
801067d4:	53                   	push   %ebx
801067d5:	83 ec 1c             	sub    $0x1c,%esp
801067d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801067db:	8b 45 10             	mov    0x10(%ebp),%eax
801067de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067e1:	85 c0                	test   %eax,%eax
801067e3:	0f 88 c1 00 00 00    	js     801068aa <allocuvm+0xdb>
  if(newsz < oldsz)
801067e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801067ec:	39 45 10             	cmp    %eax,0x10(%ebp)
801067ef:	72 5c                	jb     8010684d <allocuvm+0x7e>
  a = PGROUNDUP(oldsz);
801067f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801067f4:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801067fa:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106800:	3b 75 10             	cmp    0x10(%ebp),%esi
80106803:	0f 83 a8 00 00 00    	jae    801068b1 <allocuvm+0xe2>
    mem = kalloc();
80106809:	e8 19 b8 ff ff       	call   80102027 <kalloc>
8010680e:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106810:	85 c0                	test   %eax,%eax
80106812:	74 3e                	je     80106852 <allocuvm+0x83>
    memset(mem, 0, PGSIZE);
80106814:	83 ec 04             	sub    $0x4,%esp
80106817:	68 00 10 00 00       	push   $0x1000
8010681c:	6a 00                	push   $0x0
8010681e:	50                   	push   %eax
8010681f:	e8 d6 d5 ff ff       	call   80103dfa <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106824:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010682b:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106831:	50                   	push   %eax
80106832:	68 00 10 00 00       	push   $0x1000
80106837:	56                   	push   %esi
80106838:	57                   	push   %edi
80106839:	e8 15 fc ff ff       	call   80106453 <mappages>
8010683e:	83 c4 20             	add    $0x20,%esp
80106841:	85 c0                	test   %eax,%eax
80106843:	78 35                	js     8010687a <allocuvm+0xab>
  for(; a < newsz; a += PGSIZE){
80106845:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010684b:	eb b3                	jmp    80106800 <allocuvm+0x31>
    return oldsz;
8010684d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106850:	eb 5f                	jmp    801068b1 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106852:	83 ec 0c             	sub    $0xc,%esp
80106855:	68 bd 75 10 80       	push   $0x801075bd
8010685a:	e8 7b 9d ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010685f:	83 c4 0c             	add    $0xc,%esp
80106862:	ff 75 0c             	push   0xc(%ebp)
80106865:	ff 75 10             	push   0x10(%ebp)
80106868:	57                   	push   %edi
80106869:	e8 d1 fe ff ff       	call   8010673f <deallocuvm>
      return 0;
8010686e:	83 c4 10             	add    $0x10,%esp
80106871:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106878:	eb 37                	jmp    801068b1 <allocuvm+0xe2>
      cprintf("allocuvm out of memory (2)\n");
8010687a:	83 ec 0c             	sub    $0xc,%esp
8010687d:	68 d5 75 10 80       	push   $0x801075d5
80106882:	e8 53 9d ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106887:	83 c4 0c             	add    $0xc,%esp
8010688a:	ff 75 0c             	push   0xc(%ebp)
8010688d:	ff 75 10             	push   0x10(%ebp)
80106890:	57                   	push   %edi
80106891:	e8 a9 fe ff ff       	call   8010673f <deallocuvm>
      kfree(mem);
80106896:	89 1c 24             	mov    %ebx,(%esp)
80106899:	e8 72 b6 ff ff       	call   80101f10 <kfree>
      return 0;
8010689e:	83 c4 10             	add    $0x10,%esp
801068a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801068a8:	eb 07                	jmp    801068b1 <allocuvm+0xe2>
    return 0;
801068aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801068b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068b7:	5b                   	pop    %ebx
801068b8:	5e                   	pop    %esi
801068b9:	5f                   	pop    %edi
801068ba:	5d                   	pop    %ebp
801068bb:	c3                   	ret    

801068bc <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
801068bc:	55                   	push   %ebp
801068bd:	89 e5                	mov    %esp,%ebp
801068bf:	56                   	push   %esi
801068c0:	53                   	push   %ebx
801068c1:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801068c4:	85 f6                	test   %esi,%esi
801068c6:	74 0d                	je     801068d5 <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
801068c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801068cc:	75 14                	jne    801068e2 <freevm+0x26>
{
801068ce:	bb 00 00 00 00       	mov    $0x0,%ebx
801068d3:	eb 23                	jmp    801068f8 <freevm+0x3c>
    panic("freevm: no pgdir");
801068d5:	83 ec 0c             	sub    $0xc,%esp
801068d8:	68 f1 75 10 80       	push   $0x801075f1
801068dd:	e8 5f 9a ff ff       	call   80100341 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801068e2:	83 ec 04             	sub    $0x4,%esp
801068e5:	6a 00                	push   $0x0
801068e7:	68 00 00 00 80       	push   $0x80000000
801068ec:	56                   	push   %esi
801068ed:	e8 4d fe ff ff       	call   8010673f <deallocuvm>
801068f2:	83 c4 10             	add    $0x10,%esp
801068f5:	eb d7                	jmp    801068ce <freevm+0x12>
  for(i = 0; i < NPDENTRIES; i++){
801068f7:	43                   	inc    %ebx
801068f8:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801068fe:	77 1f                	ja     8010691f <freevm+0x63>
    if(pgdir[i] & PTE_P){
80106900:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106903:	a8 01                	test   $0x1,%al
80106905:	74 f0                	je     801068f7 <freevm+0x3b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106907:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010690c:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106911:	83 ec 0c             	sub    $0xc,%esp
80106914:	50                   	push   %eax
80106915:	e8 f6 b5 ff ff       	call   80101f10 <kfree>
8010691a:	83 c4 10             	add    $0x10,%esp
8010691d:	eb d8                	jmp    801068f7 <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
8010691f:	83 ec 0c             	sub    $0xc,%esp
80106922:	56                   	push   %esi
80106923:	e8 e8 b5 ff ff       	call   80101f10 <kfree>
}
80106928:	83 c4 10             	add    $0x10,%esp
8010692b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010692e:	5b                   	pop    %ebx
8010692f:	5e                   	pop    %esi
80106930:	5d                   	pop    %ebp
80106931:	c3                   	ret    

80106932 <setupkvm>:
{
80106932:	55                   	push   %ebp
80106933:	89 e5                	mov    %esp,%ebp
80106935:	56                   	push   %esi
80106936:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106937:	e8 eb b6 ff ff       	call   80102027 <kalloc>
8010693c:	89 c6                	mov    %eax,%esi
8010693e:	85 c0                	test   %eax,%eax
80106940:	74 57                	je     80106999 <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
80106942:	83 ec 04             	sub    $0x4,%esp
80106945:	68 00 10 00 00       	push   $0x1000
8010694a:	6a 00                	push   $0x0
8010694c:	50                   	push   %eax
8010694d:	e8 a8 d4 ff ff       	call   80103dfa <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106952:	83 c4 10             	add    $0x10,%esp
80106955:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
8010695a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106960:	73 37                	jae    80106999 <setupkvm+0x67>
                (uint)k->phys_start, k->perm) < 0) {
80106962:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106965:	83 ec 0c             	sub    $0xc,%esp
80106968:	ff 73 0c             	push   0xc(%ebx)
8010696b:	52                   	push   %edx
8010696c:	8b 43 08             	mov    0x8(%ebx),%eax
8010696f:	29 d0                	sub    %edx,%eax
80106971:	50                   	push   %eax
80106972:	ff 33                	push   (%ebx)
80106974:	56                   	push   %esi
80106975:	e8 d9 fa ff ff       	call   80106453 <mappages>
8010697a:	83 c4 20             	add    $0x20,%esp
8010697d:	85 c0                	test   %eax,%eax
8010697f:	78 05                	js     80106986 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106981:	83 c3 10             	add    $0x10,%ebx
80106984:	eb d4                	jmp    8010695a <setupkvm+0x28>
      freevm(pgdir, 0);
80106986:	83 ec 08             	sub    $0x8,%esp
80106989:	6a 00                	push   $0x0
8010698b:	56                   	push   %esi
8010698c:	e8 2b ff ff ff       	call   801068bc <freevm>
      return 0;
80106991:	83 c4 10             	add    $0x10,%esp
80106994:	be 00 00 00 00       	mov    $0x0,%esi
}
80106999:	89 f0                	mov    %esi,%eax
8010699b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010699e:	5b                   	pop    %ebx
8010699f:	5e                   	pop    %esi
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    

801069a2 <kvmalloc>:
{
801069a2:	55                   	push   %ebp
801069a3:	89 e5                	mov    %esp,%ebp
801069a5:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801069a8:	e8 85 ff ff ff       	call   80106932 <setupkvm>
801069ad:	a3 24 48 11 80       	mov    %eax,0x80114824
  switchkvm();
801069b2:	e8 18 fb ff ff       	call   801064cf <switchkvm>
}
801069b7:	c9                   	leave  
801069b8:	c3                   	ret    

801069b9 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801069b9:	55                   	push   %ebp
801069ba:	89 e5                	mov    %esp,%ebp
801069bc:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801069bf:	6a 00                	push   $0x0
801069c1:	ff 75 0c             	push   0xc(%ebp)
801069c4:	ff 75 08             	push   0x8(%ebp)
801069c7:	e8 16 fa ff ff       	call   801063e2 <walkpgdir>
  if(pte == 0)
801069cc:	83 c4 10             	add    $0x10,%esp
801069cf:	85 c0                	test   %eax,%eax
801069d1:	74 05                	je     801069d8 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801069d3:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801069d6:	c9                   	leave  
801069d7:	c3                   	ret    
    panic("clearpteu");
801069d8:	83 ec 0c             	sub    $0xc,%esp
801069db:	68 02 76 10 80       	push   $0x80107602
801069e0:	e8 5c 99 ff ff       	call   80100341 <panic>

801069e5 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801069e5:	55                   	push   %ebp
801069e6:	89 e5                	mov    %esp,%ebp
801069e8:	57                   	push   %edi
801069e9:	56                   	push   %esi
801069ea:	53                   	push   %ebx
801069eb:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801069ee:	e8 3f ff ff ff       	call   80106932 <setupkvm>
801069f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
801069f6:	85 c0                	test   %eax,%eax
801069f8:	0f 84 b5 00 00 00    	je     80106ab3 <copyuvm+0xce>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801069fe:	be 00 00 00 00       	mov    $0x0,%esi
80106a03:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106a06:	eb 06                	jmp    80106a0e <copyuvm+0x29>
80106a08:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106a0e:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106a11:	0f 83 9c 00 00 00    	jae    80106ab3 <copyuvm+0xce>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106a17:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106a1a:	83 ec 04             	sub    $0x4,%esp
80106a1d:	6a 00                	push   $0x0
80106a1f:	56                   	push   %esi
80106a20:	53                   	push   %ebx
80106a21:	e8 bc f9 ff ff       	call   801063e2 <walkpgdir>
80106a26:	83 c4 10             	add    $0x10,%esp
80106a29:	85 c0                	test   %eax,%eax
80106a2b:	74 db                	je     80106a08 <copyuvm+0x23>
      continue; //panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106a2d:	8b 00                	mov    (%eax),%eax
80106a2f:	a8 01                	test   $0x1,%al
80106a31:	74 d5                	je     80106a08 <copyuvm+0x23>
      continue; //panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106a33:	89 c2                	mov    %eax,%edx
80106a35:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a3b:	89 55 e0             	mov    %edx,-0x20(%ebp)
    flags = PTE_FLAGS(*pte);
80106a3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80106a43:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if((mem = kalloc()) == 0)
80106a46:	e8 dc b5 ff ff       	call   80102027 <kalloc>
80106a4b:	89 c7                	mov    %eax,%edi
80106a4d:	85 c0                	test   %eax,%eax
80106a4f:	74 4b                	je     80106a9c <copyuvm+0xb7>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a54:	05 00 00 00 80       	add    $0x80000000,%eax
80106a59:	83 ec 04             	sub    $0x4,%esp
80106a5c:	68 00 10 00 00       	push   $0x1000
80106a61:	50                   	push   %eax
80106a62:	57                   	push   %edi
80106a63:	e8 08 d4 ff ff       	call   80103e70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106a68:	83 c4 04             	add    $0x4,%esp
80106a6b:	ff 75 dc             	push   -0x24(%ebp)
80106a6e:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106a74:	50                   	push   %eax
80106a75:	68 00 10 00 00       	push   $0x1000
80106a7a:	ff 75 e4             	push   -0x1c(%ebp)
80106a7d:	ff 75 d8             	push   -0x28(%ebp)
80106a80:	e8 ce f9 ff ff       	call   80106453 <mappages>
80106a85:	83 c4 20             	add    $0x20,%esp
80106a88:	85 c0                	test   %eax,%eax
80106a8a:	0f 89 78 ff ff ff    	jns    80106a08 <copyuvm+0x23>
      kfree(mem);
80106a90:	83 ec 0c             	sub    $0xc,%esp
80106a93:	57                   	push   %edi
80106a94:	e8 77 b4 ff ff       	call   80101f10 <kfree>
      goto bad;
80106a99:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106a9c:	83 ec 08             	sub    $0x8,%esp
80106a9f:	6a 01                	push   $0x1
80106aa1:	ff 75 d8             	push   -0x28(%ebp)
80106aa4:	e8 13 fe ff ff       	call   801068bc <freevm>
  return 0;
80106aa9:	83 c4 10             	add    $0x10,%esp
80106aac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
}
80106ab3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ab9:	5b                   	pop    %ebx
80106aba:	5e                   	pop    %esi
80106abb:	5f                   	pop    %edi
80106abc:	5d                   	pop    %ebp
80106abd:	c3                   	ret    

80106abe <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106abe:	55                   	push   %ebp
80106abf:	89 e5                	mov    %esp,%ebp
80106ac1:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ac4:	6a 00                	push   $0x0
80106ac6:	ff 75 0c             	push   0xc(%ebp)
80106ac9:	ff 75 08             	push   0x8(%ebp)
80106acc:	e8 11 f9 ff ff       	call   801063e2 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ad1:	8b 00                	mov    (%eax),%eax
80106ad3:	83 c4 10             	add    $0x10,%esp
80106ad6:	a8 01                	test   $0x1,%al
80106ad8:	74 10                	je     80106aea <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106ada:	a8 04                	test   $0x4,%al
80106adc:	74 13                	je     80106af1 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ade:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ae3:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106ae8:	c9                   	leave  
80106ae9:	c3                   	ret    
    return 0;
80106aea:	b8 00 00 00 00       	mov    $0x0,%eax
80106aef:	eb f7                	jmp    80106ae8 <uva2ka+0x2a>
    return 0;
80106af1:	b8 00 00 00 00       	mov    $0x0,%eax
80106af6:	eb f0                	jmp    80106ae8 <uva2ka+0x2a>

80106af8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106af8:	55                   	push   %ebp
80106af9:	89 e5                	mov    %esp,%ebp
80106afb:	57                   	push   %edi
80106afc:	56                   	push   %esi
80106afd:	53                   	push   %ebx
80106afe:	83 ec 0c             	sub    $0xc,%esp
80106b01:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106b04:	eb 25                	jmp    80106b2b <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106b06:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b09:	29 f2                	sub    %esi,%edx
80106b0b:	01 d0                	add    %edx,%eax
80106b0d:	83 ec 04             	sub    $0x4,%esp
80106b10:	53                   	push   %ebx
80106b11:	ff 75 10             	push   0x10(%ebp)
80106b14:	50                   	push   %eax
80106b15:	e8 56 d3 ff ff       	call   80103e70 <memmove>
    len -= n;
80106b1a:	29 df                	sub    %ebx,%edi
    buf += n;
80106b1c:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106b1f:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106b25:	89 45 0c             	mov    %eax,0xc(%ebp)
80106b28:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106b2b:	85 ff                	test   %edi,%edi
80106b2d:	74 2f                	je     80106b5e <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106b2f:	8b 75 0c             	mov    0xc(%ebp),%esi
80106b32:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106b38:	83 ec 08             	sub    $0x8,%esp
80106b3b:	56                   	push   %esi
80106b3c:	ff 75 08             	push   0x8(%ebp)
80106b3f:	e8 7a ff ff ff       	call   80106abe <uva2ka>
    if(pa0 == 0)
80106b44:	83 c4 10             	add    $0x10,%esp
80106b47:	85 c0                	test   %eax,%eax
80106b49:	74 20                	je     80106b6b <copyout+0x73>
    n = PGSIZE - (va - va0);
80106b4b:	89 f3                	mov    %esi,%ebx
80106b4d:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106b50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106b56:	39 df                	cmp    %ebx,%edi
80106b58:	73 ac                	jae    80106b06 <copyout+0xe>
      n = len;
80106b5a:	89 fb                	mov    %edi,%ebx
80106b5c:	eb a8                	jmp    80106b06 <copyout+0xe>
  }
  return 0;
80106b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b66:	5b                   	pop    %ebx
80106b67:	5e                   	pop    %esi
80106b68:	5f                   	pop    %edi
80106b69:	5d                   	pop    %ebp
80106b6a:	c3                   	ret    
      return -1;
80106b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b70:	eb f1                	jmp    80106b63 <copyout+0x6b>
