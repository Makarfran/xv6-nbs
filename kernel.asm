
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
80100046:	e8 fd 3c 00 00       	call   80103d48 <acquire>

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
8010007a:	e8 2e 3d 00 00       	call   80103dad <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 af 3a 00 00       	call   80103b39 <acquiresleep>
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
801000c8:	e8 e0 3c 00 00       	call   80103dad <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 61 3a 00 00       	call   80103b39 <acquiresleep>
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
801000e8:	68 40 6b 10 80       	push   $0x80106b40
801000ed:	e8 4f 02 00 00       	call   80100341 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 51 6b 10 80       	push   $0x80106b51
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 09 3b 00 00       	call   80103c11 <initlock>
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
80100138:	68 58 6b 10 80       	push   $0x80106b58
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 c0 39 00 00       	call   80103b06 <initsleeplock>
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
801001a6:	e8 18 3a 00 00       	call   80103bc3 <holdingsleep>
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
801001c9:	68 5f 6b 10 80       	push   $0x80106b5f
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
801001e2:	e8 dc 39 00 00       	call   80103bc3 <holdingsleep>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	85 c0                	test   %eax,%eax
801001ec:	74 69                	je     80100257 <brelse+0x84>
    panic("brelse");

  releasesleep(&b->lock);
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 91 39 00 00       	call   80103b88 <releasesleep>

  acquire(&bcache.lock);
801001f7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001fe:	e8 45 3b 00 00       	call   80103d48 <acquire>
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
80100248:	e8 60 3b 00 00       	call   80103dad <release>
}
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
    panic("brelse");
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 66 6b 10 80       	push   $0x80106b66
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
80100286:	e8 bd 3a 00 00       	call   80103d48 <acquire>
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
801002bb:	e8 70 35 00 00       	call   80103830 <sleep>
801002c0:	83 c4 10             	add    $0x10,%esp
801002c3:	eb d1                	jmp    80100296 <consoleread+0x32>
        release(&cons.lock);
801002c5:	83 ec 0c             	sub    $0xc,%esp
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 db 3a 00 00       	call   80103dad <release>
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
8010032a:	e8 7e 3a 00 00       	call   80103dad <release>
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
8010035c:	68 6d 6b 10 80       	push   $0x80106b6d
80100361:	e8 74 02 00 00       	call   801005da <cprintf>
  cprintf(s);
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 69 02 00 00       	call   801005da <cprintf>
  cprintf("\n");
80100371:	c7 04 24 85 75 10 80 	movl   $0x80107585,(%esp)
80100378:	e8 5d 02 00 00       	call   801005da <cprintf>
  getcallerpcs(&s, pcs);
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100383:	50                   	push   %eax
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 9f 38 00 00       	call   80103c2c <getcallerpcs>
  for(i=0; i<10; i++)
8010038d:	83 c4 10             	add    $0x10,%esp
80100390:	bb 00 00 00 00       	mov    $0x0,%ebx
80100395:	eb 15                	jmp    801003ac <panic+0x6b>
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
8010039e:	68 81 6b 10 80       	push   $0x80106b81
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
8010046c:	68 85 6b 10 80       	push   $0x80106b85
80100471:	e8 cb fe ff ff       	call   80100341 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100476:	83 ec 04             	sub    $0x4,%esp
80100479:	68 60 0e 00 00       	push   $0xe60
8010047e:	68 a0 80 0b 80       	push   $0x800b80a0
80100483:	68 00 80 0b 80       	push   $0x800b8000
80100488:	e8 dd 39 00 00       	call   80103e6a <memmove>
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
801004a7:	e8 48 39 00 00       	call   80103df4 <memset>
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
801004d4:	e8 b6 50 00 00       	call   8010558f <uartputc>
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
801004ed:	e8 9d 50 00 00       	call   8010558f <uartputc>
801004f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f9:	e8 91 50 00 00       	call   8010558f <uartputc>
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 85 50 00 00       	call   8010558f <uartputc>
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
80100540:	8a 92 b0 6b 10 80    	mov    -0x7fef9450(%edx),%dl
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
8010059b:	e8 a8 37 00 00       	call   80103d48 <acquire>
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
801005c0:	e8 e8 37 00 00       	call   80103dad <release>
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
80100607:	e8 3c 37 00 00       	call   80103d48 <acquire>
8010060c:	83 c4 10             	add    $0x10,%esp
8010060f:	eb de                	jmp    801005ef <cprintf+0x15>
    panic("null fmt");
80100611:	83 ec 0c             	sub    $0xc,%esp
80100614:	68 9f 6b 10 80       	push   $0x80106b9f
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
8010069c:	bb 98 6b 10 80       	mov    $0x80106b98,%ebx
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
801006f5:	e8 b3 36 00 00       	call   80103dad <release>
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
80100710:	e8 33 36 00 00       	call   80103d48 <acquire>
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
801007b8:	e8 e5 31 00 00       	call   801039a2 <wakeup>
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
80100831:	e8 77 35 00 00       	call   80103dad <release>
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
80100845:	e8 09 32 00 00       	call   80103a53 <procdump>
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
80100852:	68 a8 6b 10 80       	push   $0x80106ba8
80100857:	68 20 ef 10 80       	push   $0x8010ef20
8010085c:	e8 b0 33 00 00       	call   80103c11 <initlock>

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
8010091c:	68 c1 6b 10 80       	push   $0x80106bc1
80100921:	e8 b4 fc ff ff       	call   801005da <cprintf>
    return -1;
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010092e:	eb dc                	jmp    8010090c <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
80100930:	e8 c2 5f 00 00       	call   801068f7 <setupkvm>
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
801009c6:	e8 c9 5d 00 00       	call   80106794 <allocuvm>
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
801009fc:	e8 65 5c 00 00       	call   80106666 <loaduvm>
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
80100a3e:	e8 51 5d 00 00       	call   80106794 <allocuvm>
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
80100a6b:	e8 11 5e 00 00       	call   80106881 <freevm>
80100a70:	83 c4 10             	add    $0x10,%esp
80100a73:	e9 76 fe ff ff       	jmp    801008ee <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100a78:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7e:	83 ec 08             	sub    $0x8,%esp
80100a81:	50                   	push   %eax
80100a82:	57                   	push   %edi
80100a83:	e8 f6 5e 00 00       	call   8010697e <clearpteu>
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
80100ab3:	e8 cc 34 00 00       	call   80103f84 <strlen>
80100ab8:	29 c6                	sub    %eax,%esi
80100aba:	4e                   	dec    %esi
80100abb:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100abe:	83 c4 04             	add    $0x4,%esp
80100ac1:	ff 33                	push   (%ebx)
80100ac3:	e8 bc 34 00 00       	call   80103f84 <strlen>
80100ac8:	40                   	inc    %eax
80100ac9:	50                   	push   %eax
80100aca:	ff 33                	push   (%ebx)
80100acc:	56                   	push   %esi
80100acd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad3:	e8 e5 5f 00 00       	call   80106abd <copyout>
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
80100b33:	e8 85 5f 00 00       	call   80106abd <copyout>
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
80100b6d:	e8 da 33 00 00       	call   80103f4c <safestrcpy>
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
80100b9b:	e8 02 59 00 00       	call   801064a2 <switchuvm>
  freevm(oldpgdir, 1);
80100ba0:	83 c4 08             	add    $0x8,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	53                   	push   %ebx
80100ba6:	e8 d6 5c 00 00       	call   80106881 <freevm>
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
80100bd2:	68 cd 6b 10 80       	push   $0x80106bcd
80100bd7:	68 60 ef 10 80       	push   $0x8010ef60
80100bdc:	e8 30 30 00 00       	call   80103c11 <initlock>
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
80100bf2:	e8 51 31 00 00       	call   80103d48 <acquire>
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
80100c21:	e8 87 31 00 00       	call   80103dad <release>
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
80100c38:	e8 70 31 00 00       	call   80103dad <release>
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
80100c56:	e8 ed 30 00 00       	call   80103d48 <acquire>
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
80100c71:	e8 37 31 00 00       	call   80103dad <release>
  return f;
}
80100c76:	89 d8                	mov    %ebx,%eax
80100c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7b:	c9                   	leave  
80100c7c:	c3                   	ret    
    panic("filedup");
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	68 d4 6b 10 80       	push   $0x80106bd4
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
80100c9b:	e8 a8 30 00 00       	call   80103d48 <acquire>
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
80100cd3:	e8 d5 30 00 00       	call   80103dad <release>

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
80100d05:	68 dc 6b 10 80       	push   $0x80106bdc
80100d0a:	e8 32 f6 ff ff       	call   80100341 <panic>
    release(&ftable.lock);
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 60 ef 10 80       	push   $0x8010ef60
80100d17:	e8 91 30 00 00       	call   80103dad <release>
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
80100df7:	68 e6 6b 10 80       	push   $0x80106be6
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
80100ebc:	68 ef 6b 10 80       	push   $0x80106bef
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
80100ee0:	68 f5 6b 10 80       	push   $0x80106bf5
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
80100f2a:	e8 3b 2f 00 00       	call   80103e6a <memmove>
80100f2f:	83 c4 10             	add    $0x10,%esp
80100f32:	eb 15                	jmp    80100f49 <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	57                   	push   %edi
80100f38:	50                   	push   %eax
80100f39:	56                   	push   %esi
80100f3a:	e8 2b 2f 00 00       	call   80103e6a <memmove>
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
80100f7d:	e8 72 2e 00 00       	call   80103df4 <memset>
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
8010103b:	68 ff 6b 10 80       	push   $0x80106bff
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
80101110:	68 15 6c 10 80       	push   $0x80106c15
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
8010112d:	e8 16 2c 00 00       	call   80103d48 <acquire>
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
80101172:	e8 36 2c 00 00       	call   80103dad <release>
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
801011a8:	e8 00 2c 00 00       	call   80103dad <release>
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
801011bd:	68 28 6c 10 80       	push   $0x80106c28
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
801011e6:	e8 7f 2c 00 00       	call   80103e6a <memmove>
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
80101274:	68 38 6c 10 80       	push   $0x80106c38
80101279:	e8 c3 f0 ff ff       	call   80100341 <panic>

8010127e <iinit>:
{
8010127e:	55                   	push   %ebp
8010127f:	89 e5                	mov    %esp,%ebp
80101281:	53                   	push   %ebx
80101282:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101285:	68 4b 6c 10 80       	push   $0x80106c4b
8010128a:	68 60 f9 10 80       	push   $0x8010f960
8010128f:	e8 7d 29 00 00       	call   80103c11 <initlock>
  for(i = 0; i < NINODE; i++) {
80101294:	83 c4 10             	add    $0x10,%esp
80101297:	bb 00 00 00 00       	mov    $0x0,%ebx
8010129c:	eb 1f                	jmp    801012bd <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010129e:	83 ec 08             	sub    $0x8,%esp
801012a1:	68 52 6c 10 80       	push   $0x80106c52
801012a6:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012a9:	89 d0                	mov    %edx,%eax
801012ab:	c1 e0 04             	shl    $0x4,%eax
801012ae:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012b3:	50                   	push   %eax
801012b4:	e8 4d 28 00 00       	call   80103b06 <initsleeplock>
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
801012fc:	68 b8 6c 10 80       	push   $0x80106cb8
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
8010136d:	68 58 6c 10 80       	push   $0x80106c58
80101372:	e8 ca ef ff ff       	call   80100341 <panic>
      memset(dip, 0, sizeof(*dip));
80101377:	83 ec 04             	sub    $0x4,%esp
8010137a:	6a 40                	push   $0x40
8010137c:	6a 00                	push   $0x0
8010137e:	57                   	push   %edi
8010137f:	e8 70 2a 00 00       	call   80103df4 <memset>
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
8010140b:	e8 5a 2a 00 00       	call   80103e6a <memmove>
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
801014e7:	e8 5c 28 00 00       	call   80103d48 <acquire>
  ip->ref++;
801014ec:	8b 43 08             	mov    0x8(%ebx),%eax
801014ef:	40                   	inc    %eax
801014f0:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801014f3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801014fa:	e8 ae 28 00 00       	call   80103dad <release>
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
8010151f:	e8 15 26 00 00       	call   80103b39 <acquiresleep>
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
80101537:	68 6a 6c 10 80       	push   $0x80106c6a
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
80101597:	e8 ce 28 00 00       	call   80103e6a <memmove>
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
801015bc:	68 70 6c 10 80       	push   $0x80106c70
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
801015d9:	e8 e5 25 00 00       	call   80103bc3 <holdingsleep>
801015de:	83 c4 10             	add    $0x10,%esp
801015e1:	85 c0                	test   %eax,%eax
801015e3:	74 19                	je     801015fe <iunlock+0x38>
801015e5:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015e9:	7e 13                	jle    801015fe <iunlock+0x38>
  releasesleep(&ip->lock);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	56                   	push   %esi
801015ef:	e8 94 25 00 00       	call   80103b88 <releasesleep>
}
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5d                   	pop    %ebp
801015fd:	c3                   	ret    
    panic("iunlock");
801015fe:	83 ec 0c             	sub    $0xc,%esp
80101601:	68 7f 6c 10 80       	push   $0x80106c7f
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
8010161b:	e8 19 25 00 00       	call   80103b39 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101620:	83 c4 10             	add    $0x10,%esp
80101623:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101627:	74 07                	je     80101630 <iput+0x25>
80101629:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010162e:	74 33                	je     80101663 <iput+0x58>
  releasesleep(&ip->lock);
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	56                   	push   %esi
80101634:	e8 4f 25 00 00       	call   80103b88 <releasesleep>
  acquire(&icache.lock);
80101639:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101640:	e8 03 27 00 00       	call   80103d48 <acquire>
  ip->ref--;
80101645:	8b 43 08             	mov    0x8(%ebx),%eax
80101648:	48                   	dec    %eax
80101649:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010164c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101653:	e8 55 27 00 00       	call   80103dad <release>
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
8010166b:	e8 d8 26 00 00       	call   80103d48 <acquire>
    int r = ip->ref;
80101670:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101673:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010167a:	e8 2e 27 00 00       	call   80103dad <release>
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
8010176f:	e8 f6 26 00 00       	call   80103e6a <memmove>
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
80101872:	e8 f3 25 00 00       	call   80103e6a <memmove>
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
80101935:	e8 96 25 00 00       	call   80103ed0 <strncmp>
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
8010195c:	68 87 6c 10 80       	push   $0x80106c87
80101961:	e8 db e9 ff ff       	call   80100341 <panic>
      panic("dirlookup read");
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	68 99 6c 10 80       	push   $0x80106c99
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
80101b1b:	68 a8 6c 10 80       	push   $0x80106ca8
80101b20:	e8 1c e8 ff ff       	call   80100341 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 0e                	push   $0xe
80101b2a:	57                   	push   %edi
80101b2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b2e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b31:	50                   	push   %eax
80101b32:	e8 d1 23 00 00       	call   80103f08 <strncpy>
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
80101b60:	68 a4 72 10 80       	push   $0x801072a4
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
80101c58:	68 0b 6d 10 80       	push   $0x80106d0b
80101c5d:	e8 df e6 ff ff       	call   80100341 <panic>
    panic("incorrect blockno");
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 14 6d 10 80       	push   $0x80106d14
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
80101c7f:	68 26 6d 10 80       	push   $0x80106d26
80101c84:	68 00 16 11 80       	push   $0x80111600
80101c89:	e8 83 1f 00 00       	call   80103c11 <initlock>
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
80101cef:	e8 54 20 00 00       	call   80103d48 <acquire>

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
80101d1e:	e8 7f 1c 00 00       	call   801039a2 <wakeup>

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
80101d3c:	e8 6c 20 00 00       	call   80103dad <release>
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
80101d53:	e8 55 20 00 00       	call   80103dad <release>
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
80101d8b:	e8 33 1e 00 00       	call   80103bc3 <holdingsleep>
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
80101db8:	e8 8b 1f 00 00       	call   80103d48 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101dbd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101dcc:	eb 2a                	jmp    80101df8 <iderw+0x7b>
    panic("iderw: buf not locked");
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 2a 6d 10 80       	push   $0x80106d2a
80101dd6:	e8 66 e5 ff ff       	call   80100341 <panic>
    panic("iderw: nothing to do");
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	68 40 6d 10 80       	push   $0x80106d40
80101de3:	e8 59 e5 ff ff       	call   80100341 <panic>
    panic("iderw: ide disk 1 not present");
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 55 6d 10 80       	push   $0x80106d55
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
80101e1a:	e8 11 1a 00 00       	call   80103830 <sleep>
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
80101e34:	e8 74 1f 00 00       	call   80103dad <release>
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
80101ea8:	68 74 6d 10 80       	push   $0x80106d74
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
80101f42:	e8 ad 1e 00 00       	call   80103df4 <memset>

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
80101f71:	68 a6 6d 10 80       	push   $0x80106da6
80101f76:	e8 c6 e3 ff ff       	call   80100341 <panic>
    acquire(&kmem.lock);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	68 40 16 11 80       	push   $0x80111640
80101f83:	e8 c0 1d 00 00       	call   80103d48 <acquire>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	eb c6                	jmp    80101f53 <kfree+0x43>
    release(&kmem.lock);
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 40 16 11 80       	push   $0x80111640
80101f95:	e8 13 1e 00 00       	call   80103dad <release>
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
80101fdb:	68 ac 6d 10 80       	push   $0x80106dac
80101fe0:	68 40 16 11 80       	push   $0x80111640
80101fe5:	e8 27 1c 00 00       	call   80103c11 <initlock>
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
80102060:	e8 e3 1c 00 00       	call   80103d48 <acquire>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	eb cd                	jmp    80102037 <kalloc+0x10>
    release(&kmem.lock);
8010206a:	83 ec 0c             	sub    $0xc,%esp
8010206d:	68 40 16 11 80       	push   $0x80111640
80102072:	e8 36 1d 00 00       	call   80103dad <release>
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
801020b5:	0f b6 91 e0 6e 10 80 	movzbl -0x7fef9120(%ecx),%edx
801020bc:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020c2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
801020c8:	0f b6 81 e0 6d 10 80 	movzbl -0x7fef9220(%ecx),%eax
801020cf:	31 c2                	xor    %eax,%edx
801020d1:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	83 e0 03             	and    $0x3,%eax
801020dc:	8b 04 85 c0 6d 10 80 	mov    -0x7fef9240(,%eax,4),%eax
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
80102115:	8a 81 e0 6e 10 80    	mov    -0x7fef9120(%ecx),%al
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
801023f3:	e8 43 1a 00 00       	call   80103e3b <memcmp>
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
80102539:	e8 2c 19 00 00       	call   80103e6a <memmove>
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
80102632:	e8 33 18 00 00       	call   80103e6a <memmove>
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
8010269d:	68 e0 6f 10 80       	push   $0x80106fe0
801026a2:	68 a0 16 11 80       	push   $0x801116a0
801026a7:	e8 65 15 00 00       	call   80103c11 <initlock>
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
801026e7:	e8 5c 16 00 00       	call   80103d48 <acquire>
801026ec:	83 c4 10             	add    $0x10,%esp
801026ef:	eb 15                	jmp    80102706 <begin_op+0x2a>
      sleep(&log, &log.lock);
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	68 a0 16 11 80       	push   $0x801116a0
801026f9:	68 a0 16 11 80       	push   $0x801116a0
801026fe:	e8 2d 11 00 00       	call   80103830 <sleep>
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
80102736:	e8 f5 10 00 00       	call   80103830 <sleep>
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	eb c6                	jmp    80102706 <begin_op+0x2a>
      log.outstanding += 1;
80102740:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 a0 16 11 80       	push   $0x801116a0
8010274e:	e8 5a 16 00 00       	call   80103dad <release>
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
80102764:	e8 df 15 00 00       	call   80103d48 <acquire>
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
8010279c:	e8 0c 16 00 00       	call   80103dad <release>
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
801027b0:	68 e4 6f 10 80       	push   $0x80106fe4
801027b5:	e8 87 db ff ff       	call   80100341 <panic>
    wakeup(&log);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 a0 16 11 80       	push   $0x801116a0
801027c2:	e8 db 11 00 00       	call   801039a2 <wakeup>
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	eb c8                	jmp    80102794 <end_op+0x3c>
    commit();
801027cc:	e8 92 fe ff ff       	call   80102663 <commit>
    acquire(&log.lock);
801027d1:	83 ec 0c             	sub    $0xc,%esp
801027d4:	68 a0 16 11 80       	push   $0x801116a0
801027d9:	e8 6a 15 00 00       	call   80103d48 <acquire>
    log.committing = 0;
801027de:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
801027e5:	00 00 00 
    wakeup(&log);
801027e8:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027ef:	e8 ae 11 00 00       	call   801039a2 <wakeup>
    release(&log.lock);
801027f4:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027fb:	e8 ad 15 00 00       	call   80103dad <release>
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
80102835:	e8 0e 15 00 00       	call   80103d48 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	b8 00 00 00 00       	mov    $0x0,%eax
80102842:	eb 1b                	jmp    8010285f <log_write+0x5a>
    panic("too big a transaction");
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 f3 6f 10 80       	push   $0x80106ff3
8010284c:	e8 f0 da ff ff       	call   80100341 <panic>
    panic("log_write outside of trans");
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 09 70 10 80       	push   $0x80107009
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
8010288e:	e8 1a 15 00 00       	call   80103dad <release>
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
801028ba:	e8 ab 15 00 00       	call   80103e6a <memmove>

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
80102951:	68 24 70 10 80       	push   $0x80107024
80102956:	e8 7f dc ff ff       	call   801005da <cprintf>
  idtinit();       // load idt register
8010295b:	e8 8e 28 00 00       	call   801051ee <idtinit>
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
8010297e:	e8 11 3b 00 00       	call   80106494 <switchkvm>
  seginit();
80102983:	e8 61 37 00 00       	call   801060e9 <seginit>
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
801029b2:	e8 b0 3f 00 00       	call   80106967 <kvmalloc>
  mpinit();        // detect other processors
801029b7:	e8 b8 01 00 00       	call   80102b74 <mpinit>
  lapicinit();     // interrupt controller
801029bc:	e8 16 f8 ff ff       	call   801021d7 <lapicinit>
  seginit();       // segment descriptors
801029c1:	e8 23 37 00 00       	call   801060e9 <seginit>
  picinit();       // disable pic
801029c6:	e8 79 02 00 00       	call   80102c44 <picinit>
  ioapicinit();    // another interrupt controller
801029cb:	e8 93 f4 ff ff       	call   80101e63 <ioapicinit>
  consoleinit();   // console hardware
801029d0:	e8 77 de ff ff       	call   8010084c <consoleinit>
  uartinit();      // serial port
801029d5:	e8 f8 2b 00 00       	call   801055d2 <uartinit>
  pinit();         // process table
801029da:	e8 8c 08 00 00       	call   8010326b <pinit>
  tvinit();        // trap vectors
801029df:	e8 0d 27 00 00       	call   801050f1 <tvinit>
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
80102a53:	68 38 70 10 80       	push   $0x80107038
80102a58:	53                   	push   %ebx
80102a59:	e8 dd 13 00 00       	call   80103e3b <memcmp>
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
80102b16:	68 3d 70 10 80       	push   $0x8010703d
80102b1b:	57                   	push   %edi
80102b1c:	e8 1a 13 00 00       	call   80103e3b <memcmp>
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
80102ba5:	68 42 70 10 80       	push   $0x80107042
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
80102c3a:	68 5c 70 10 80       	push   $0x8010705c
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
80102cbe:	68 7b 70 10 80       	push   $0x8010707b
80102cc3:	50                   	push   %eax
80102cc4:	e8 48 0f 00 00       	call   80103c11 <initlock>
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
80102d48:	e8 fb 0f 00 00       	call   80103d48 <acquire>
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
80102d6a:	e8 33 0c 00 00       	call   801039a2 <wakeup>
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
80102d88:	e8 20 10 00 00       	call   80103dad <release>
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
80102da9:	e8 f4 0b 00 00       	call   801039a2 <wakeup>
80102dae:	83 c4 10             	add    $0x10,%esp
80102db1:	eb bf                	jmp    80102d72 <pipeclose+0x35>
    release(&p->lock);
80102db3:	83 ec 0c             	sub    $0xc,%esp
80102db6:	53                   	push   %ebx
80102db7:	e8 f1 0f 00 00       	call   80103dad <release>
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
80102dd5:	e8 6e 0f 00 00       	call   80103d48 <acquire>
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
80102df1:	e8 ac 0b 00 00       	call   801039a2 <wakeup>
  release(&p->lock);
80102df6:	89 1c 24             	mov    %ebx,(%esp)
80102df9:	e8 af 0f 00 00       	call   80103dad <release>
  return n;
80102dfe:	83 c4 10             	add    $0x10,%esp
80102e01:	8b 45 10             	mov    0x10(%ebp),%eax
80102e04:	eb 5c                	jmp    80102e62 <pipewrite+0x99>
      wakeup(&p->nread);
80102e06:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	50                   	push   %eax
80102e10:	e8 8d 0b 00 00       	call   801039a2 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e15:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e1b:	83 c4 08             	add    $0x8,%esp
80102e1e:	53                   	push   %ebx
80102e1f:	50                   	push   %eax
80102e20:	e8 0b 0a 00 00       	call   80103830 <sleep>
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
80102e55:	e8 53 0f 00 00       	call   80103dad <release>
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
80102e9b:	e8 a8 0e 00 00       	call   80103d48 <acquire>
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
80102eb0:	e8 7b 09 00 00       	call   80103830 <sleep>
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
80102edf:	e8 c9 0e 00 00       	call   80103dad <release>
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
80102f21:	e8 7c 0a 00 00       	call   801039a2 <wakeup>
  release(&p->lock);
80102f26:	89 1c 24             	mov    %ebx,(%esp)
80102f29:	e8 7f 0e 00 00       	call   80103dad <release>
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
80102f4e:	e8 f5 0d 00 00       	call   80103d48 <acquire>

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
80102f9f:	e8 09 0e 00 00       	call   80103dad <release>

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
80102fbc:	c7 80 b0 0f 00 00 e6 	movl   $0x801050e6,0xfb0(%eax)
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
80102fd6:	e8 19 0e 00 00       	call   80103df4 <memset>
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
80102ff7:	e8 b1 0d 00 00       	call   80103dad <release>
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
8010301c:	e8 8c 0d 00 00       	call   80103dad <release>

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
80103168:	e8 db 0b 00 00       	call   80103d48 <acquire>
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
8010319c:	e8 0c 0c 00 00       	call   80103dad <release>
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
801031d5:	e8 6e 0b 00 00       	call   80103d48 <acquire>
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
80103250:	e8 58 0b 00 00       	call   80103dad <release>
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
80103271:	68 80 70 10 80       	push   $0x80107080
80103276:	68 20 1d 11 80       	push   $0x80111d20
8010327b:	e8 91 09 00 00       	call   80103c11 <initlock>
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
801032c1:	68 64 71 10 80       	push   $0x80107164
801032c6:	e8 76 d0 ff ff       	call   80100341 <panic>
  panic("unknown apicid\n");
801032cb:	83 ec 0c             	sub    $0xc,%esp
801032ce:	68 87 70 10 80       	push   $0x80107087
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
80103321:	e8 48 09 00 00       	call   80103c6e <pushcli>
  c = mycpu();
80103326:	e8 5a ff ff ff       	call   80103285 <mycpu>
  p = c->proc;
8010332b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103331:	e8 73 09 00 00       	call   80103ca9 <popcli>
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
80103350:	e8 a2 35 00 00       	call   801068f7 <setupkvm>
80103355:	89 43 04             	mov    %eax,0x4(%ebx)
80103358:	85 c0                	test   %eax,%eax
8010335a:	0f 84 cf 00 00 00    	je     8010342f <userinit+0xf2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103360:	83 ec 04             	sub    $0x4,%esp
80103363:	68 2c 00 00 00       	push   $0x2c
80103368:	68 60 a4 10 80       	push   $0x8010a460
8010336d:	50                   	push   %eax
8010336e:	e8 8b 32 00 00       	call   801065fe <inituvm>
  p->sz = PGSIZE;
80103373:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103379:	8b 43 18             	mov    0x18(%ebx),%eax
8010337c:	83 c4 0c             	add    $0xc,%esp
8010337f:	6a 4c                	push   $0x4c
80103381:	6a 00                	push   $0x0
80103383:	50                   	push   %eax
80103384:	e8 6b 0a 00 00       	call   80103df4 <memset>
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
801033df:	68 b0 70 10 80       	push   $0x801070b0
801033e4:	50                   	push   %eax
801033e5:	e8 62 0b 00 00       	call   80103f4c <safestrcpy>
  p->cwd = namei("/");
801033ea:	c7 04 24 b9 70 10 80 	movl   $0x801070b9,(%esp)
801033f1:	e8 74 e7 ff ff       	call   80101b6a <namei>
801033f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033f9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103400:	e8 43 09 00 00       	call   80103d48 <acquire>
  p->state = RUNNABLE;
80103405:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  insertProc( p, p->prio);
8010340c:	83 c4 08             	add    $0x8,%esp
8010340f:	ff b3 80 00 00 00    	push   0x80(%ebx)
80103415:	53                   	push   %ebx
80103416:	e8 39 fc ff ff       	call   80103054 <insertProc>
  release(&ptable.lock);
8010341b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103422:	e8 86 09 00 00       	call   80103dad <release>
}
80103427:	83 c4 10             	add    $0x10,%esp
8010342a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010342d:	c9                   	leave  
8010342e:	c3                   	ret    
    panic("userinit: out of memory?");
8010342f:	83 ec 0c             	sub    $0xc,%esp
80103432:	68 97 70 10 80       	push   $0x80107097
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
80103476:	e8 19 33 00 00       	call   80106794 <allocuvm>
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
80103493:	e8 6c 32 00 00       	call   80106704 <deallocuvm>
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
801034d0:	e8 d5 34 00 00       	call   801069aa <copyuvm>
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
8010357c:	e8 cb 09 00 00       	call   80103f4c <safestrcpy>
  pid = np->pid;
80103581:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103584:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010358b:	e8 b8 07 00 00       	call   80103d48 <acquire>
  np->state = RUNNABLE;
80103590:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  insertProc( np, np->prio);
80103597:	83 c4 08             	add    $0x8,%esp
8010359a:	ff b7 80 00 00 00    	push   0x80(%edi)
801035a0:	57                   	push   %edi
801035a1:	e8 ae fa ff ff       	call   80103054 <insertProc>
  release(&ptable.lock);
801035a6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801035ad:	e8 fb 07 00 00       	call   80103dad <release>
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
801035fe:	e8 9f 2e 00 00       	call   801064a2 <switchuvm>
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
80103623:	e8 72 09 00 00       	call   80103f9a <swtch>
      switchkvm();
80103628:	e8 67 2e 00 00       	call   80106494 <switchkvm>
      c->proc = 0;
8010362d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103634:	00 00 00 
      break;
80103637:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	68 20 1d 11 80       	push   $0x80111d20
80103642:	e8 66 07 00 00       	call   80103dad <release>
    sti();
80103647:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010364a:	fb                   	sti    
    acquire(&ptable.lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	68 20 1d 11 80       	push   $0x80111d20
80103653:	e8 f0 06 00 00       	call   80103d48 <acquire>
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
80103679:	e8 8b 06 00 00       	call   80103d09 <holding>
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
801036ba:	e8 db 08 00 00       	call   80103f9a <swtch>
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
801036d7:	68 bb 70 10 80       	push   $0x801070bb
801036dc:	e8 60 cc ff ff       	call   80100341 <panic>
    panic("sched locks");
801036e1:	83 ec 0c             	sub    $0xc,%esp
801036e4:	68 cd 70 10 80       	push   $0x801070cd
801036e9:	e8 53 cc ff ff       	call   80100341 <panic>
    panic("sched running");
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	68 d9 70 10 80       	push   $0x801070d9
801036f6:	e8 46 cc ff ff       	call   80100341 <panic>
    panic("sched interruptible");
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	68 e7 70 10 80       	push   $0x801070e7
80103703:	e8 39 cc ff ff       	call   80100341 <panic>

80103708 <exit>:
{
80103708:	55                   	push   %ebp
80103709:	89 e5                	mov    %esp,%ebp
8010370b:	56                   	push   %esi
8010370c:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010370d:	e8 08 fc ff ff       	call   8010331a <myproc>
  if(curproc == initproc)
80103712:	39 05 a4 3f 11 80    	cmp    %eax,0x80113fa4
80103718:	74 09                	je     80103723 <exit+0x1b>
8010371a:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010371c:	bb 00 00 00 00       	mov    $0x0,%ebx
80103721:	eb 22                	jmp    80103745 <exit+0x3d>
    panic("init exiting");
80103723:	83 ec 0c             	sub    $0xc,%esp
80103726:	68 fb 70 10 80       	push   $0x801070fb
8010372b:	e8 11 cc ff ff       	call   80100341 <panic>
      fileclose(curproc->ofile[fd]);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	50                   	push   %eax
80103734:	e8 51 d5 ff ff       	call   80100c8a <fileclose>
      curproc->ofile[fd] = 0;
80103739:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103740:	00 
80103741:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103744:	43                   	inc    %ebx
80103745:	83 fb 0f             	cmp    $0xf,%ebx
80103748:	7f 0a                	jg     80103754 <exit+0x4c>
    if(curproc->ofile[fd]){
8010374a:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010374e:	85 c0                	test   %eax,%eax
80103750:	75 de                	jne    80103730 <exit+0x28>
80103752:	eb f0                	jmp    80103744 <exit+0x3c>
  begin_op();
80103754:	e8 83 ef ff ff       	call   801026dc <begin_op>
  iput(curproc->cwd);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	ff 76 68             	push   0x68(%esi)
8010375f:	e8 a7 de ff ff       	call   8010160b <iput>
  end_op();
80103764:	e8 ef ef ff ff       	call   80102758 <end_op>
  curproc->cwd = 0;
80103769:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103770:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103777:	e8 cc 05 00 00       	call   80103d48 <acquire>
  wakeup1(curproc->parent);
8010377c:	8b 46 14             	mov    0x14(%esi),%eax
8010377f:	e8 22 f9 ff ff       	call   801030a6 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103784:	83 c4 10             	add    $0x10,%esp
80103787:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010378c:	eb 06                	jmp    80103794 <exit+0x8c>
8010378e:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103794:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
8010379a:	73 1a                	jae    801037b6 <exit+0xae>
    if(p->parent == curproc){
8010379c:	39 73 14             	cmp    %esi,0x14(%ebx)
8010379f:	75 ed                	jne    8010378e <exit+0x86>
      p->parent = initproc;
801037a1:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
801037a6:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801037a9:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037ad:	75 df                	jne    8010378e <exit+0x86>
        wakeup1(initproc);
801037af:	e8 f2 f8 ff ff       	call   801030a6 <wakeup1>
801037b4:	eb d8                	jmp    8010378e <exit+0x86>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801037b6:	83 ec 04             	sub    $0x4,%esp
801037b9:	6a 00                	push   $0x0
801037bb:	68 00 00 00 80       	push   $0x80000000
801037c0:	ff 76 04             	push   0x4(%esi)
801037c3:	e8 3c 2f 00 00       	call   80106704 <deallocuvm>
  curproc->state = ZOMBIE;
801037c8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037cf:	e8 91 fe ff ff       	call   80103665 <sched>
  panic("zombie exit");
801037d4:	c7 04 24 08 71 10 80 	movl   $0x80107108,(%esp)
801037db:	e8 61 cb ff ff       	call   80100341 <panic>

801037e0 <yield>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037e7:	68 20 1d 11 80       	push   $0x80111d20
801037ec:	e8 57 05 00 00       	call   80103d48 <acquire>
  myproc()->state = RUNNABLE;
801037f1:	e8 24 fb ff ff       	call   8010331a <myproc>
801037f6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insertProc( myproc(), myproc()->prio);
801037fd:	e8 18 fb ff ff       	call   8010331a <myproc>
80103802:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
80103808:	e8 0d fb ff ff       	call   8010331a <myproc>
8010380d:	83 c4 08             	add    $0x8,%esp
80103810:	53                   	push   %ebx
80103811:	50                   	push   %eax
80103812:	e8 3d f8 ff ff       	call   80103054 <insertProc>
  sched();
80103817:	e8 49 fe ff ff       	call   80103665 <sched>
  release(&ptable.lock);
8010381c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103823:	e8 85 05 00 00       	call   80103dad <release>
}
80103828:	83 c4 10             	add    $0x10,%esp
8010382b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010382e:	c9                   	leave  
8010382f:	c3                   	ret    

80103830 <sleep>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103838:	e8 dd fa ff ff       	call   8010331a <myproc>
  if(p == 0)
8010383d:	85 c0                	test   %eax,%eax
8010383f:	74 66                	je     801038a7 <sleep+0x77>
80103841:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103843:	85 f6                	test   %esi,%esi
80103845:	74 6d                	je     801038b4 <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103847:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
8010384d:	74 18                	je     80103867 <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010384f:	83 ec 0c             	sub    $0xc,%esp
80103852:	68 20 1d 11 80       	push   $0x80111d20
80103857:	e8 ec 04 00 00       	call   80103d48 <acquire>
    release(lk);
8010385c:	89 34 24             	mov    %esi,(%esp)
8010385f:	e8 49 05 00 00       	call   80103dad <release>
80103864:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103867:	8b 45 08             	mov    0x8(%ebp),%eax
8010386a:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010386d:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103874:	e8 ec fd ff ff       	call   80103665 <sched>
  p->chan = 0;
80103879:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103880:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103886:	74 18                	je     801038a0 <sleep+0x70>
    release(&ptable.lock);
80103888:	83 ec 0c             	sub    $0xc,%esp
8010388b:	68 20 1d 11 80       	push   $0x80111d20
80103890:	e8 18 05 00 00       	call   80103dad <release>
    acquire(lk);
80103895:	89 34 24             	mov    %esi,(%esp)
80103898:	e8 ab 04 00 00       	call   80103d48 <acquire>
8010389d:	83 c4 10             	add    $0x10,%esp
}
801038a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a3:	5b                   	pop    %ebx
801038a4:	5e                   	pop    %esi
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    
    panic("sleep");
801038a7:	83 ec 0c             	sub    $0xc,%esp
801038aa:	68 14 71 10 80       	push   $0x80107114
801038af:	e8 8d ca ff ff       	call   80100341 <panic>
    panic("sleep without lk");
801038b4:	83 ec 0c             	sub    $0xc,%esp
801038b7:	68 1a 71 10 80       	push   $0x8010711a
801038bc:	e8 80 ca ff ff       	call   80100341 <panic>

801038c1 <wait>:
{
801038c1:	55                   	push   %ebp
801038c2:	89 e5                	mov    %esp,%ebp
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
  struct proc *curproc = myproc();
801038c6:	e8 4f fa ff ff       	call   8010331a <myproc>
801038cb:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 20 1d 11 80       	push   $0x80111d20
801038d5:	e8 6e 04 00 00       	call   80103d48 <acquire>
801038da:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801038dd:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e2:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801038e7:	eb 68                	jmp    80103951 <wait+0x90>
        pid = p->pid;
801038e9:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038ec:	83 ec 0c             	sub    $0xc,%esp
801038ef:	ff 73 08             	push   0x8(%ebx)
801038f2:	e8 19 e6 ff ff       	call   80101f10 <kfree>
        *status = p->status;
801038f7:	8b 53 7c             	mov    0x7c(%ebx),%edx
801038fa:	8b 45 08             	mov    0x8(%ebp),%eax
801038fd:	89 10                	mov    %edx,(%eax)
        p->kstack = 0;
801038ff:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
80103906:	83 c4 08             	add    $0x8,%esp
80103909:	6a 00                	push   $0x0
8010390b:	ff 73 04             	push   0x4(%ebx)
8010390e:	e8 6e 2f 00 00       	call   80106881 <freevm>
        p->pid = 0;
80103913:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010391a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103921:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103925:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010392c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103933:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010393a:	e8 6e 04 00 00       	call   80103dad <release>
        return pid;
8010393f:	83 c4 10             	add    $0x10,%esp
}
80103942:	89 f0                	mov    %esi,%eax
80103944:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103947:	5b                   	pop    %ebx
80103948:	5e                   	pop    %esi
80103949:	5d                   	pop    %ebp
8010394a:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010394b:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103951:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103957:	73 12                	jae    8010396b <wait+0xaa>
      if(p->parent != curproc)
80103959:	39 73 14             	cmp    %esi,0x14(%ebx)
8010395c:	75 ed                	jne    8010394b <wait+0x8a>
      if(p->state == ZOMBIE){
8010395e:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103962:	74 85                	je     801038e9 <wait+0x28>
      havekids = 1;
80103964:	b8 01 00 00 00       	mov    $0x1,%eax
80103969:	eb e0                	jmp    8010394b <wait+0x8a>
    if(!havekids || curproc->killed){
8010396b:	85 c0                	test   %eax,%eax
8010396d:	74 06                	je     80103975 <wait+0xb4>
8010396f:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103973:	74 17                	je     8010398c <wait+0xcb>
      release(&ptable.lock);
80103975:	83 ec 0c             	sub    $0xc,%esp
80103978:	68 20 1d 11 80       	push   $0x80111d20
8010397d:	e8 2b 04 00 00       	call   80103dad <release>
      return -1;
80103982:	83 c4 10             	add    $0x10,%esp
80103985:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010398a:	eb b6                	jmp    80103942 <wait+0x81>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010398c:	83 ec 08             	sub    $0x8,%esp
8010398f:	68 20 1d 11 80       	push   $0x80111d20
80103994:	56                   	push   %esi
80103995:	e8 96 fe ff ff       	call   80103830 <sleep>
    havekids = 0;
8010399a:	83 c4 10             	add    $0x10,%esp
8010399d:	e9 3b ff ff ff       	jmp    801038dd <wait+0x1c>

801039a2 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801039a2:	55                   	push   %ebp
801039a3:	89 e5                	mov    %esp,%ebp
801039a5:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801039a8:	68 20 1d 11 80       	push   $0x80111d20
801039ad:	e8 96 03 00 00       	call   80103d48 <acquire>
  wakeup1(chan);
801039b2:	8b 45 08             	mov    0x8(%ebp),%eax
801039b5:	e8 ec f6 ff ff       	call   801030a6 <wakeup1>
  release(&ptable.lock);
801039ba:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801039c1:	e8 e7 03 00 00       	call   80103dad <release>
}
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	c9                   	leave  
801039ca:	c3                   	ret    

801039cb <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039cb:	55                   	push   %ebp
801039cc:	89 e5                	mov    %esp,%ebp
801039ce:	53                   	push   %ebx
801039cf:	83 ec 10             	sub    $0x10,%esp
801039d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039d5:	68 20 1d 11 80       	push   $0x80111d20
801039da:	e8 69 03 00 00       	call   80103d48 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801039e7:	eb 20                	jmp    80103a09 <kill+0x3e>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
801039e9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insertProc( p, p->prio);
801039f0:	83 ec 08             	sub    $0x8,%esp
801039f3:	ff b0 80 00 00 00    	push   0x80(%eax)
801039f9:	50                   	push   %eax
801039fa:	e8 55 f6 ff ff       	call   80103054 <insertProc>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	eb 1e                	jmp    80103a22 <kill+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a04:	05 88 00 00 00       	add    $0x88,%eax
80103a09:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
80103a0e:	73 2c                	jae    80103a3c <kill+0x71>
    if(p->pid == pid){
80103a10:	39 58 10             	cmp    %ebx,0x10(%eax)
80103a13:	75 ef                	jne    80103a04 <kill+0x39>
      p->killed = 1;
80103a15:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
80103a1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a20:	74 c7                	je     801039e9 <kill+0x1e>
      }
      release(&ptable.lock);
80103a22:	83 ec 0c             	sub    $0xc,%esp
80103a25:	68 20 1d 11 80       	push   $0x80111d20
80103a2a:	e8 7e 03 00 00       	call   80103dad <release>
      return 0;
80103a2f:	83 c4 10             	add    $0x10,%esp
80103a32:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3a:	c9                   	leave  
80103a3b:	c3                   	ret    
  release(&ptable.lock);
80103a3c:	83 ec 0c             	sub    $0xc,%esp
80103a3f:	68 20 1d 11 80       	push   $0x80111d20
80103a44:	e8 64 03 00 00       	call   80103dad <release>
  return -1;
80103a49:	83 c4 10             	add    $0x10,%esp
80103a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a51:	eb e4                	jmp    80103a37 <kill+0x6c>

80103a53 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a53:	55                   	push   %ebp
80103a54:	89 e5                	mov    %esp,%ebp
80103a56:	56                   	push   %esi
80103a57:	53                   	push   %ebx
80103a58:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a5b:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103a60:	eb 36                	jmp    80103a98 <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103a62:	b8 2b 71 10 80       	mov    $0x8010712b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103a67:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a6a:	52                   	push   %edx
80103a6b:	50                   	push   %eax
80103a6c:	ff 73 10             	push   0x10(%ebx)
80103a6f:	68 2f 71 10 80       	push   $0x8010712f
80103a74:	e8 61 cb ff ff       	call   801005da <cprintf>
    if(p->state == SLEEPING){
80103a79:	83 c4 10             	add    $0x10,%esp
80103a7c:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a80:	74 3c                	je     80103abe <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 85 75 10 80       	push   $0x80107585
80103a8a:	e8 4b cb ff ff       	call   801005da <cprintf>
80103a8f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a92:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a98:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103a9e:	73 5f                	jae    80103aff <procdump+0xac>
    if(p->state == UNUSED)
80103aa0:	8b 43 0c             	mov    0xc(%ebx),%eax
80103aa3:	85 c0                	test   %eax,%eax
80103aa5:	74 eb                	je     80103a92 <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103aa7:	83 f8 05             	cmp    $0x5,%eax
80103aaa:	77 b6                	ja     80103a62 <procdump+0xf>
80103aac:	8b 04 85 8c 71 10 80 	mov    -0x7fef8e74(,%eax,4),%eax
80103ab3:	85 c0                	test   %eax,%eax
80103ab5:	75 b0                	jne    80103a67 <procdump+0x14>
      state = "???";
80103ab7:	b8 2b 71 10 80       	mov    $0x8010712b,%eax
80103abc:	eb a9                	jmp    80103a67 <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103abe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ac1:	8b 40 0c             	mov    0xc(%eax),%eax
80103ac4:	83 c0 08             	add    $0x8,%eax
80103ac7:	83 ec 08             	sub    $0x8,%esp
80103aca:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103acd:	52                   	push   %edx
80103ace:	50                   	push   %eax
80103acf:	e8 58 01 00 00       	call   80103c2c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	be 00 00 00 00       	mov    $0x0,%esi
80103adc:	eb 12                	jmp    80103af0 <procdump+0x9d>
        cprintf(" %p", pc[i]);
80103ade:	83 ec 08             	sub    $0x8,%esp
80103ae1:	50                   	push   %eax
80103ae2:	68 81 6b 10 80       	push   $0x80106b81
80103ae7:	e8 ee ca ff ff       	call   801005da <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103aec:	46                   	inc    %esi
80103aed:	83 c4 10             	add    $0x10,%esp
80103af0:	83 fe 09             	cmp    $0x9,%esi
80103af3:	7f 8d                	jg     80103a82 <procdump+0x2f>
80103af5:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103af9:	85 c0                	test   %eax,%eax
80103afb:	75 e1                	jne    80103ade <procdump+0x8b>
80103afd:	eb 83                	jmp    80103a82 <procdump+0x2f>
  }
}
80103aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b02:	5b                   	pop    %ebx
80103b03:	5e                   	pop    %esi
80103b04:	5d                   	pop    %ebp
80103b05:	c3                   	ret    

80103b06 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b06:	55                   	push   %ebp
80103b07:	89 e5                	mov    %esp,%ebp
80103b09:	53                   	push   %ebx
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b10:	68 a4 71 10 80       	push   $0x801071a4
80103b15:	8d 43 04             	lea    0x4(%ebx),%eax
80103b18:	50                   	push   %eax
80103b19:	e8 f3 00 00 00       	call   80103c11 <initlock>
  lk->name = name;
80103b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b21:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b2a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b37:	c9                   	leave  
80103b38:	c3                   	ret    

80103b39 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b39:	55                   	push   %ebp
80103b3a:	89 e5                	mov    %esp,%ebp
80103b3c:	56                   	push   %esi
80103b3d:	53                   	push   %ebx
80103b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b41:	8d 73 04             	lea    0x4(%ebx),%esi
80103b44:	83 ec 0c             	sub    $0xc,%esp
80103b47:	56                   	push   %esi
80103b48:	e8 fb 01 00 00       	call   80103d48 <acquire>
  while (lk->locked) {
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	eb 0d                	jmp    80103b5f <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103b52:	83 ec 08             	sub    $0x8,%esp
80103b55:	56                   	push   %esi
80103b56:	53                   	push   %ebx
80103b57:	e8 d4 fc ff ff       	call   80103830 <sleep>
80103b5c:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103b5f:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b62:	75 ee                	jne    80103b52 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103b64:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b6a:	e8 ab f7 ff ff       	call   8010331a <myproc>
80103b6f:	8b 40 10             	mov    0x10(%eax),%eax
80103b72:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b75:	83 ec 0c             	sub    $0xc,%esp
80103b78:	56                   	push   %esi
80103b79:	e8 2f 02 00 00       	call   80103dad <release>
}
80103b7e:	83 c4 10             	add    $0x10,%esp
80103b81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b84:	5b                   	pop    %ebx
80103b85:	5e                   	pop    %esi
80103b86:	5d                   	pop    %ebp
80103b87:	c3                   	ret    

80103b88 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b88:	55                   	push   %ebp
80103b89:	89 e5                	mov    %esp,%ebp
80103b8b:	56                   	push   %esi
80103b8c:	53                   	push   %ebx
80103b8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b90:	8d 73 04             	lea    0x4(%ebx),%esi
80103b93:	83 ec 0c             	sub    $0xc,%esp
80103b96:	56                   	push   %esi
80103b97:	e8 ac 01 00 00       	call   80103d48 <acquire>
  lk->locked = 0;
80103b9c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ba2:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103ba9:	89 1c 24             	mov    %ebx,(%esp)
80103bac:	e8 f1 fd ff ff       	call   801039a2 <wakeup>
  release(&lk->lk);
80103bb1:	89 34 24             	mov    %esi,(%esp)
80103bb4:	e8 f4 01 00 00       	call   80103dad <release>
}
80103bb9:	83 c4 10             	add    $0x10,%esp
80103bbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bbf:	5b                   	pop    %ebx
80103bc0:	5e                   	pop    %esi
80103bc1:	5d                   	pop    %ebp
80103bc2:	c3                   	ret    

80103bc3 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103bc3:	55                   	push   %ebp
80103bc4:	89 e5                	mov    %esp,%ebp
80103bc6:	56                   	push   %esi
80103bc7:	53                   	push   %ebx
80103bc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103bcb:	8d 73 04             	lea    0x4(%ebx),%esi
80103bce:	83 ec 0c             	sub    $0xc,%esp
80103bd1:	56                   	push   %esi
80103bd2:	e8 71 01 00 00       	call   80103d48 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bdd:	75 17                	jne    80103bf6 <holdingsleep+0x33>
80103bdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	56                   	push   %esi
80103be8:	e8 c0 01 00 00       	call   80103dad <release>
  return r;
}
80103bed:	89 d8                	mov    %ebx,%eax
80103bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5d                   	pop    %ebp
80103bf5:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103bf6:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103bf9:	e8 1c f7 ff ff       	call   8010331a <myproc>
80103bfe:	3b 58 10             	cmp    0x10(%eax),%ebx
80103c01:	74 07                	je     80103c0a <holdingsleep+0x47>
80103c03:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c08:	eb da                	jmp    80103be4 <holdingsleep+0x21>
80103c0a:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c0f:	eb d3                	jmp    80103be4 <holdingsleep+0x21>

80103c11 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c11:	55                   	push   %ebp
80103c12:	89 e5                	mov    %esp,%ebp
80103c14:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c17:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c1a:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c2a:	5d                   	pop    %ebp
80103c2b:	c3                   	ret    

80103c2c <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c2c:	55                   	push   %ebp
80103c2d:	89 e5                	mov    %esp,%ebp
80103c2f:	53                   	push   %ebx
80103c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103c33:	8b 45 08             	mov    0x8(%ebp),%eax
80103c36:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c39:	b8 00 00 00 00       	mov    $0x0,%eax
80103c3e:	83 f8 09             	cmp    $0x9,%eax
80103c41:	7f 21                	jg     80103c64 <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c43:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c49:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c4f:	77 13                	ja     80103c64 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c51:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c54:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c57:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c59:	40                   	inc    %eax
80103c5a:	eb e2                	jmp    80103c3e <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c5c:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c63:	40                   	inc    %eax
80103c64:	83 f8 09             	cmp    $0x9,%eax
80103c67:	7e f3                	jle    80103c5c <getcallerpcs+0x30>
}
80103c69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c6c:	c9                   	leave  
80103c6d:	c3                   	ret    

80103c6e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c6e:	55                   	push   %ebp
80103c6f:	89 e5                	mov    %esp,%ebp
80103c71:	53                   	push   %ebx
80103c72:	83 ec 04             	sub    $0x4,%esp
80103c75:	9c                   	pushf  
80103c76:	5b                   	pop    %ebx
  asm volatile("cli");
80103c77:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c78:	e8 08 f6 ff ff       	call   80103285 <mycpu>
80103c7d:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c84:	74 10                	je     80103c96 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c86:	e8 fa f5 ff ff       	call   80103285 <mycpu>
80103c8b:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c94:	c9                   	leave  
80103c95:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c96:	e8 ea f5 ff ff       	call   80103285 <mycpu>
80103c9b:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103ca1:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103ca7:	eb dd                	jmp    80103c86 <pushcli+0x18>

80103ca9 <popcli>:

void
popcli(void)
{
80103ca9:	55                   	push   %ebp
80103caa:	89 e5                	mov    %esp,%ebp
80103cac:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103caf:	9c                   	pushf  
80103cb0:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cb1:	f6 c4 02             	test   $0x2,%ah
80103cb4:	75 28                	jne    80103cde <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103cb6:	e8 ca f5 ff ff       	call   80103285 <mycpu>
80103cbb:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103cc1:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103cc4:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103cca:	85 d2                	test   %edx,%edx
80103ccc:	78 1d                	js     80103ceb <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cce:	e8 b2 f5 ff ff       	call   80103285 <mycpu>
80103cd3:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cda:	74 1c                	je     80103cf8 <popcli+0x4f>
    sti();
}
80103cdc:	c9                   	leave  
80103cdd:	c3                   	ret    
    panic("popcli - interruptible");
80103cde:	83 ec 0c             	sub    $0xc,%esp
80103ce1:	68 af 71 10 80       	push   $0x801071af
80103ce6:	e8 56 c6 ff ff       	call   80100341 <panic>
    panic("popcli");
80103ceb:	83 ec 0c             	sub    $0xc,%esp
80103cee:	68 c6 71 10 80       	push   $0x801071c6
80103cf3:	e8 49 c6 ff ff       	call   80100341 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cf8:	e8 88 f5 ff ff       	call   80103285 <mycpu>
80103cfd:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d04:	74 d6                	je     80103cdc <popcli+0x33>
  asm volatile("sti");
80103d06:	fb                   	sti    
}
80103d07:	eb d3                	jmp    80103cdc <popcli+0x33>

80103d09 <holding>:
{
80103d09:	55                   	push   %ebp
80103d0a:	89 e5                	mov    %esp,%ebp
80103d0c:	53                   	push   %ebx
80103d0d:	83 ec 04             	sub    $0x4,%esp
80103d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103d13:	e8 56 ff ff ff       	call   80103c6e <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d18:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d1b:	75 11                	jne    80103d2e <holding+0x25>
80103d1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103d22:	e8 82 ff ff ff       	call   80103ca9 <popcli>
}
80103d27:	89 d8                	mov    %ebx,%eax
80103d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d2c:	c9                   	leave  
80103d2d:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103d2e:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103d31:	e8 4f f5 ff ff       	call   80103285 <mycpu>
80103d36:	39 c3                	cmp    %eax,%ebx
80103d38:	74 07                	je     80103d41 <holding+0x38>
80103d3a:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d3f:	eb e1                	jmp    80103d22 <holding+0x19>
80103d41:	bb 01 00 00 00       	mov    $0x1,%ebx
80103d46:	eb da                	jmp    80103d22 <holding+0x19>

80103d48 <acquire>:
{
80103d48:	55                   	push   %ebp
80103d49:	89 e5                	mov    %esp,%ebp
80103d4b:	53                   	push   %ebx
80103d4c:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d4f:	e8 1a ff ff ff       	call   80103c6e <pushcli>
  if(holding(lk))
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	ff 75 08             	push   0x8(%ebp)
80103d5a:	e8 aa ff ff ff       	call   80103d09 <holding>
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	85 c0                	test   %eax,%eax
80103d64:	75 3a                	jne    80103da0 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103d66:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103d69:	b8 01 00 00 00       	mov    $0x1,%eax
80103d6e:	f0 87 02             	lock xchg %eax,(%edx)
80103d71:	85 c0                	test   %eax,%eax
80103d73:	75 f1                	jne    80103d66 <acquire+0x1e>
  __sync_synchronize();
80103d75:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d7d:	e8 03 f5 ff ff       	call   80103285 <mycpu>
80103d82:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d85:	8b 45 08             	mov    0x8(%ebp),%eax
80103d88:	83 c0 0c             	add    $0xc,%eax
80103d8b:	83 ec 08             	sub    $0x8,%esp
80103d8e:	50                   	push   %eax
80103d8f:	8d 45 08             	lea    0x8(%ebp),%eax
80103d92:	50                   	push   %eax
80103d93:	e8 94 fe ff ff       	call   80103c2c <getcallerpcs>
}
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9e:	c9                   	leave  
80103d9f:	c3                   	ret    
    panic("acquire");
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 cd 71 10 80       	push   $0x801071cd
80103da8:	e8 94 c5 ff ff       	call   80100341 <panic>

80103dad <release>:
{
80103dad:	55                   	push   %ebp
80103dae:	89 e5                	mov    %esp,%ebp
80103db0:	53                   	push   %ebx
80103db1:	83 ec 10             	sub    $0x10,%esp
80103db4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103db7:	53                   	push   %ebx
80103db8:	e8 4c ff ff ff       	call   80103d09 <holding>
80103dbd:	83 c4 10             	add    $0x10,%esp
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	74 23                	je     80103de7 <release+0x3a>
  lk->pcs[0] = 0;
80103dc4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103dcb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103dd2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103dd7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103ddd:	e8 c7 fe ff ff       	call   80103ca9 <popcli>
}
80103de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de5:	c9                   	leave  
80103de6:	c3                   	ret    
    panic("release");
80103de7:	83 ec 0c             	sub    $0xc,%esp
80103dea:	68 d5 71 10 80       	push   $0x801071d5
80103def:	e8 4d c5 ff ff       	call   80100341 <panic>

80103df4 <memset>:
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	57                   	push   %edi
80103df8:	53                   	push   %ebx
80103df9:	8b 55 08             	mov    0x8(%ebp),%edx
80103dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dff:	f6 c2 03             	test   $0x3,%dl
80103e02:	75 29                	jne    80103e2d <memset+0x39>
80103e04:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103e08:	75 23                	jne    80103e2d <memset+0x39>
80103e0a:	0f b6 f8             	movzbl %al,%edi
80103e0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e10:	c1 e9 02             	shr    $0x2,%ecx
80103e13:	c1 e0 18             	shl    $0x18,%eax
80103e16:	89 fb                	mov    %edi,%ebx
80103e18:	c1 e3 10             	shl    $0x10,%ebx
80103e1b:	09 d8                	or     %ebx,%eax
80103e1d:	89 fb                	mov    %edi,%ebx
80103e1f:	c1 e3 08             	shl    $0x8,%ebx
80103e22:	09 d8                	or     %ebx,%eax
80103e24:	09 f8                	or     %edi,%eax
80103e26:	89 d7                	mov    %edx,%edi
80103e28:	fc                   	cld    
80103e29:	f3 ab                	rep stos %eax,%es:(%edi)
80103e2b:	eb 08                	jmp    80103e35 <memset+0x41>
80103e2d:	89 d7                	mov    %edx,%edi
80103e2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e32:	fc                   	cld    
80103e33:	f3 aa                	rep stos %al,%es:(%edi)
80103e35:	89 d0                	mov    %edx,%eax
80103e37:	5b                   	pop    %ebx
80103e38:	5f                   	pop    %edi
80103e39:	5d                   	pop    %ebp
80103e3a:	c3                   	ret    

80103e3b <memcmp>:
80103e3b:	55                   	push   %ebp
80103e3c:	89 e5                	mov    %esp,%ebp
80103e3e:	56                   	push   %esi
80103e3f:	53                   	push   %ebx
80103e40:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103e43:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e46:	8b 45 10             	mov    0x10(%ebp),%eax
80103e49:	eb 04                	jmp    80103e4f <memcmp+0x14>
80103e4b:	41                   	inc    %ecx
80103e4c:	42                   	inc    %edx
80103e4d:	89 f0                	mov    %esi,%eax
80103e4f:	8d 70 ff             	lea    -0x1(%eax),%esi
80103e52:	85 c0                	test   %eax,%eax
80103e54:	74 10                	je     80103e66 <memcmp+0x2b>
80103e56:	8a 01                	mov    (%ecx),%al
80103e58:	8a 1a                	mov    (%edx),%bl
80103e5a:	38 d8                	cmp    %bl,%al
80103e5c:	74 ed                	je     80103e4b <memcmp+0x10>
80103e5e:	0f b6 c0             	movzbl %al,%eax
80103e61:	0f b6 db             	movzbl %bl,%ebx
80103e64:	29 d8                	sub    %ebx,%eax
80103e66:	5b                   	pop    %ebx
80103e67:	5e                   	pop    %esi
80103e68:	5d                   	pop    %ebp
80103e69:	c3                   	ret    

80103e6a <memmove>:
80103e6a:	55                   	push   %ebp
80103e6b:	89 e5                	mov    %esp,%ebp
80103e6d:	56                   	push   %esi
80103e6e:	53                   	push   %ebx
80103e6f:	8b 75 08             	mov    0x8(%ebp),%esi
80103e72:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e75:	8b 45 10             	mov    0x10(%ebp),%eax
80103e78:	39 f2                	cmp    %esi,%edx
80103e7a:	73 36                	jae    80103eb2 <memmove+0x48>
80103e7c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e7f:	39 f1                	cmp    %esi,%ecx
80103e81:	76 33                	jbe    80103eb6 <memmove+0x4c>
80103e83:	8d 14 06             	lea    (%esi,%eax,1),%edx
80103e86:	eb 08                	jmp    80103e90 <memmove+0x26>
80103e88:	49                   	dec    %ecx
80103e89:	4a                   	dec    %edx
80103e8a:	8a 01                	mov    (%ecx),%al
80103e8c:	88 02                	mov    %al,(%edx)
80103e8e:	89 d8                	mov    %ebx,%eax
80103e90:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e93:	85 c0                	test   %eax,%eax
80103e95:	75 f1                	jne    80103e88 <memmove+0x1e>
80103e97:	eb 13                	jmp    80103eac <memmove+0x42>
80103e99:	8a 02                	mov    (%edx),%al
80103e9b:	88 01                	mov    %al,(%ecx)
80103e9d:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ea0:	8d 52 01             	lea    0x1(%edx),%edx
80103ea3:	89 d8                	mov    %ebx,%eax
80103ea5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103ea8:	85 c0                	test   %eax,%eax
80103eaa:	75 ed                	jne    80103e99 <memmove+0x2f>
80103eac:	89 f0                	mov    %esi,%eax
80103eae:	5b                   	pop    %ebx
80103eaf:	5e                   	pop    %esi
80103eb0:	5d                   	pop    %ebp
80103eb1:	c3                   	ret    
80103eb2:	89 f1                	mov    %esi,%ecx
80103eb4:	eb ef                	jmp    80103ea5 <memmove+0x3b>
80103eb6:	89 f1                	mov    %esi,%ecx
80103eb8:	eb eb                	jmp    80103ea5 <memmove+0x3b>

80103eba <memcpy>:
80103eba:	55                   	push   %ebp
80103ebb:	89 e5                	mov    %esp,%ebp
80103ebd:	83 ec 0c             	sub    $0xc,%esp
80103ec0:	ff 75 10             	push   0x10(%ebp)
80103ec3:	ff 75 0c             	push   0xc(%ebp)
80103ec6:	ff 75 08             	push   0x8(%ebp)
80103ec9:	e8 9c ff ff ff       	call   80103e6a <memmove>
80103ece:	c9                   	leave  
80103ecf:	c3                   	ret    

80103ed0 <strncmp>:
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103eda:	8b 45 10             	mov    0x10(%ebp),%eax
80103edd:	eb 03                	jmp    80103ee2 <strncmp+0x12>
80103edf:	48                   	dec    %eax
80103ee0:	42                   	inc    %edx
80103ee1:	41                   	inc    %ecx
80103ee2:	85 c0                	test   %eax,%eax
80103ee4:	74 0a                	je     80103ef0 <strncmp+0x20>
80103ee6:	8a 1a                	mov    (%edx),%bl
80103ee8:	84 db                	test   %bl,%bl
80103eea:	74 04                	je     80103ef0 <strncmp+0x20>
80103eec:	3a 19                	cmp    (%ecx),%bl
80103eee:	74 ef                	je     80103edf <strncmp+0xf>
80103ef0:	85 c0                	test   %eax,%eax
80103ef2:	74 0d                	je     80103f01 <strncmp+0x31>
80103ef4:	0f b6 02             	movzbl (%edx),%eax
80103ef7:	0f b6 11             	movzbl (%ecx),%edx
80103efa:	29 d0                	sub    %edx,%eax
80103efc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eff:	c9                   	leave  
80103f00:	c3                   	ret    
80103f01:	b8 00 00 00 00       	mov    $0x0,%eax
80103f06:	eb f4                	jmp    80103efc <strncmp+0x2c>

80103f08 <strncpy>:
80103f08:	55                   	push   %ebp
80103f09:	89 e5                	mov    %esp,%ebp
80103f0b:	57                   	push   %edi
80103f0c:	56                   	push   %esi
80103f0d:	53                   	push   %ebx
80103f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f14:	8b 55 10             	mov    0x10(%ebp),%edx
80103f17:	89 c1                	mov    %eax,%ecx
80103f19:	eb 04                	jmp    80103f1f <strncpy+0x17>
80103f1b:	89 fb                	mov    %edi,%ebx
80103f1d:	89 f1                	mov    %esi,%ecx
80103f1f:	89 d6                	mov    %edx,%esi
80103f21:	4a                   	dec    %edx
80103f22:	85 f6                	test   %esi,%esi
80103f24:	7e 10                	jle    80103f36 <strncpy+0x2e>
80103f26:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f29:	8d 71 01             	lea    0x1(%ecx),%esi
80103f2c:	8a 1b                	mov    (%ebx),%bl
80103f2e:	88 19                	mov    %bl,(%ecx)
80103f30:	84 db                	test   %bl,%bl
80103f32:	75 e7                	jne    80103f1b <strncpy+0x13>
80103f34:	89 f1                	mov    %esi,%ecx
80103f36:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103f39:	85 d2                	test   %edx,%edx
80103f3b:	7e 0a                	jle    80103f47 <strncpy+0x3f>
80103f3d:	c6 01 00             	movb   $0x0,(%ecx)
80103f40:	89 da                	mov    %ebx,%edx
80103f42:	8d 49 01             	lea    0x1(%ecx),%ecx
80103f45:	eb ef                	jmp    80103f36 <strncpy+0x2e>
80103f47:	5b                   	pop    %ebx
80103f48:	5e                   	pop    %esi
80103f49:	5f                   	pop    %edi
80103f4a:	5d                   	pop    %ebp
80103f4b:	c3                   	ret    

80103f4c <safestrcpy>:
80103f4c:	55                   	push   %ebp
80103f4d:	89 e5                	mov    %esp,%ebp
80103f4f:	57                   	push   %edi
80103f50:	56                   	push   %esi
80103f51:	53                   	push   %ebx
80103f52:	8b 45 08             	mov    0x8(%ebp),%eax
80103f55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f58:	8b 55 10             	mov    0x10(%ebp),%edx
80103f5b:	85 d2                	test   %edx,%edx
80103f5d:	7e 20                	jle    80103f7f <safestrcpy+0x33>
80103f5f:	89 c1                	mov    %eax,%ecx
80103f61:	eb 04                	jmp    80103f67 <safestrcpy+0x1b>
80103f63:	89 fb                	mov    %edi,%ebx
80103f65:	89 f1                	mov    %esi,%ecx
80103f67:	4a                   	dec    %edx
80103f68:	85 d2                	test   %edx,%edx
80103f6a:	7e 10                	jle    80103f7c <safestrcpy+0x30>
80103f6c:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f6f:	8d 71 01             	lea    0x1(%ecx),%esi
80103f72:	8a 1b                	mov    (%ebx),%bl
80103f74:	88 19                	mov    %bl,(%ecx)
80103f76:	84 db                	test   %bl,%bl
80103f78:	75 e9                	jne    80103f63 <safestrcpy+0x17>
80103f7a:	89 f1                	mov    %esi,%ecx
80103f7c:	c6 01 00             	movb   $0x0,(%ecx)
80103f7f:	5b                   	pop    %ebx
80103f80:	5e                   	pop    %esi
80103f81:	5f                   	pop    %edi
80103f82:	5d                   	pop    %ebp
80103f83:	c3                   	ret    

80103f84 <strlen>:
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	8b 55 08             	mov    0x8(%ebp),%edx
80103f8a:	b8 00 00 00 00       	mov    $0x0,%eax
80103f8f:	eb 01                	jmp    80103f92 <strlen+0xe>
80103f91:	40                   	inc    %eax
80103f92:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f96:	75 f9                	jne    80103f91 <strlen+0xd>
80103f98:	5d                   	pop    %ebp
80103f99:	c3                   	ret    

80103f9a <swtch>:
80103f9a:	8b 44 24 04          	mov    0x4(%esp),%eax
80103f9e:	8b 54 24 08          	mov    0x8(%esp),%edx
80103fa2:	55                   	push   %ebp
80103fa3:	53                   	push   %ebx
80103fa4:	56                   	push   %esi
80103fa5:	57                   	push   %edi
80103fa6:	89 20                	mov    %esp,(%eax)
80103fa8:	89 d4                	mov    %edx,%esp
80103faa:	5f                   	pop    %edi
80103fab:	5e                   	pop    %esi
80103fac:	5b                   	pop    %ebx
80103fad:	5d                   	pop    %ebp
80103fae:	c3                   	ret    

80103faf <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103faf:	55                   	push   %ebp
80103fb0:	89 e5                	mov    %esp,%ebp
80103fb2:	53                   	push   %ebx
80103fb3:	83 ec 04             	sub    $0x4,%esp
80103fb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103fb9:	e8 5c f3 ff ff       	call   8010331a <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103fbe:	8b 00                	mov    (%eax),%eax
80103fc0:	39 d8                	cmp    %ebx,%eax
80103fc2:	76 18                	jbe    80103fdc <fetchint+0x2d>
80103fc4:	8d 53 04             	lea    0x4(%ebx),%edx
80103fc7:	39 d0                	cmp    %edx,%eax
80103fc9:	72 18                	jb     80103fe3 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103fcb:	8b 13                	mov    (%ebx),%edx
80103fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd0:	89 10                	mov    %edx,(%eax)
  return 0;
80103fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fda:	c9                   	leave  
80103fdb:	c3                   	ret    
    return -1;
80103fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe1:	eb f4                	jmp    80103fd7 <fetchint+0x28>
80103fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe8:	eb ed                	jmp    80103fd7 <fetchint+0x28>

80103fea <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fea:	55                   	push   %ebp
80103feb:	89 e5                	mov    %esp,%ebp
80103fed:	53                   	push   %ebx
80103fee:	83 ec 04             	sub    $0x4,%esp
80103ff1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103ff4:	e8 21 f3 ff ff       	call   8010331a <myproc>

  if(addr >= curproc->sz)
80103ff9:	39 18                	cmp    %ebx,(%eax)
80103ffb:	76 23                	jbe    80104020 <fetchstr+0x36>
    return -1;
  *pp = (char*)addr;
80103ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
80104000:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104002:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104004:	89 d8                	mov    %ebx,%eax
80104006:	eb 01                	jmp    80104009 <fetchstr+0x1f>
80104008:	40                   	inc    %eax
80104009:	39 d0                	cmp    %edx,%eax
8010400b:	73 09                	jae    80104016 <fetchstr+0x2c>
    if(*s == 0)
8010400d:	80 38 00             	cmpb   $0x0,(%eax)
80104010:	75 f6                	jne    80104008 <fetchstr+0x1e>
      return s - *pp;
80104012:	29 d8                	sub    %ebx,%eax
80104014:	eb 05                	jmp    8010401b <fetchstr+0x31>
  }
  return -1;
80104016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010401b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010401e:	c9                   	leave  
8010401f:	c3                   	ret    
    return -1;
80104020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104025:	eb f4                	jmp    8010401b <fetchstr+0x31>

80104027 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104027:	55                   	push   %ebp
80104028:	89 e5                	mov    %esp,%ebp
8010402a:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010402d:	e8 e8 f2 ff ff       	call   8010331a <myproc>
80104032:	8b 50 18             	mov    0x18(%eax),%edx
80104035:	8b 45 08             	mov    0x8(%ebp),%eax
80104038:	c1 e0 02             	shl    $0x2,%eax
8010403b:	03 42 44             	add    0x44(%edx),%eax
8010403e:	83 ec 08             	sub    $0x8,%esp
80104041:	ff 75 0c             	push   0xc(%ebp)
80104044:	83 c0 04             	add    $0x4,%eax
80104047:	50                   	push   %eax
80104048:	e8 62 ff ff ff       	call   80103faf <fetchint>
}
8010404d:	c9                   	leave  
8010404e:	c3                   	ret    

8010404f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
8010404f:	55                   	push   %ebp
80104050:	89 e5                	mov    %esp,%ebp
80104052:	56                   	push   %esi
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
80104057:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010405a:	e8 bb f2 ff ff       	call   8010331a <myproc>
8010405f:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104061:	83 ec 08             	sub    $0x8,%esp
80104064:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104067:	50                   	push   %eax
80104068:	ff 75 08             	push   0x8(%ebp)
8010406b:	e8 b7 ff ff ff       	call   80104027 <argint>
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	85 c0                	test   %eax,%eax
80104075:	78 24                	js     8010409b <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104077:	85 db                	test   %ebx,%ebx
80104079:	78 27                	js     801040a2 <argptr+0x53>
8010407b:	8b 16                	mov    (%esi),%edx
8010407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104080:	39 c2                	cmp    %eax,%edx
80104082:	76 25                	jbe    801040a9 <argptr+0x5a>
80104084:	01 c3                	add    %eax,%ebx
80104086:	39 da                	cmp    %ebx,%edx
80104088:	72 26                	jb     801040b0 <argptr+0x61>
    return -1;
  *pp = (void*)i;
8010408a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010408d:	89 02                	mov    %eax,(%edx)
  return 0;
8010408f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104094:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104097:	5b                   	pop    %ebx
80104098:	5e                   	pop    %esi
80104099:	5d                   	pop    %ebp
8010409a:	c3                   	ret    
    return -1;
8010409b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040a0:	eb f2                	jmp    80104094 <argptr+0x45>
    return -1;
801040a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040a7:	eb eb                	jmp    80104094 <argptr+0x45>
801040a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040ae:	eb e4                	jmp    80104094 <argptr+0x45>
801040b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040b5:	eb dd                	jmp    80104094 <argptr+0x45>

801040b7 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801040b7:	55                   	push   %ebp
801040b8:	89 e5                	mov    %esp,%ebp
801040ba:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801040bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040c0:	50                   	push   %eax
801040c1:	ff 75 08             	push   0x8(%ebp)
801040c4:	e8 5e ff ff ff       	call   80104027 <argint>
801040c9:	83 c4 10             	add    $0x10,%esp
801040cc:	85 c0                	test   %eax,%eax
801040ce:	78 13                	js     801040e3 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
801040d0:	83 ec 08             	sub    $0x8,%esp
801040d3:	ff 75 0c             	push   0xc(%ebp)
801040d6:	ff 75 f4             	push   -0xc(%ebp)
801040d9:	e8 0c ff ff ff       	call   80103fea <fetchstr>
801040de:	83 c4 10             	add    $0x10,%esp
}
801040e1:	c9                   	leave  
801040e2:	c3                   	ret    
    return -1;
801040e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e8:	eb f7                	jmp    801040e1 <argstr+0x2a>

801040ea <syscall>:
[SYS_setprio] sys_setprio,
};

void
syscall(void)
{
801040ea:	55                   	push   %ebp
801040eb:	89 e5                	mov    %esp,%ebp
801040ed:	53                   	push   %ebx
801040ee:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801040f1:	e8 24 f2 ff ff       	call   8010331a <myproc>
801040f6:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801040f8:	8b 40 18             	mov    0x18(%eax),%eax
801040fb:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040fe:	8d 50 ff             	lea    -0x1(%eax),%edx
80104101:	83 fa 19             	cmp    $0x19,%edx
80104104:	77 17                	ja     8010411d <syscall+0x33>
80104106:	8b 14 85 00 72 10 80 	mov    -0x7fef8e00(,%eax,4),%edx
8010410d:	85 d2                	test   %edx,%edx
8010410f:	74 0c                	je     8010411d <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
80104111:	ff d2                	call   *%edx
80104113:	89 c2                	mov    %eax,%edx
80104115:	8b 43 18             	mov    0x18(%ebx),%eax
80104118:	89 50 1c             	mov    %edx,0x1c(%eax)
8010411b:	eb 1f                	jmp    8010413c <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010411d:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104120:	50                   	push   %eax
80104121:	52                   	push   %edx
80104122:	ff 73 10             	push   0x10(%ebx)
80104125:	68 dd 71 10 80       	push   $0x801071dd
8010412a:	e8 ab c4 ff ff       	call   801005da <cprintf>
    curproc->tf->eax = -1;
8010412f:	8b 43 18             	mov    0x18(%ebx),%eax
80104132:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104139:	83 c4 10             	add    $0x10,%esp
  }
}
8010413c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010413f:	c9                   	leave  
80104140:	c3                   	ret    

80104141 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104141:	55                   	push   %ebp
80104142:	89 e5                	mov    %esp,%ebp
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 18             	sub    $0x18,%esp
80104149:	89 d6                	mov    %edx,%esi
8010414b:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010414d:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104150:	52                   	push   %edx
80104151:	50                   	push   %eax
80104152:	e8 d0 fe ff ff       	call   80104027 <argint>
80104157:	83 c4 10             	add    $0x10,%esp
8010415a:	85 c0                	test   %eax,%eax
8010415c:	78 35                	js     80104193 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010415e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104162:	77 28                	ja     8010418c <argfd+0x4b>
80104164:	e8 b1 f1 ff ff       	call   8010331a <myproc>
80104169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010416c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104170:	85 c0                	test   %eax,%eax
80104172:	74 18                	je     8010418c <argfd+0x4b>
    return -1;
  if(pfd)
80104174:	85 f6                	test   %esi,%esi
80104176:	74 02                	je     8010417a <argfd+0x39>
    *pfd = fd;
80104178:	89 16                	mov    %edx,(%esi)
  if(pf)
8010417a:	85 db                	test   %ebx,%ebx
8010417c:	74 1c                	je     8010419a <argfd+0x59>
    *pf = f;
8010417e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104180:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104185:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104188:	5b                   	pop    %ebx
80104189:	5e                   	pop    %esi
8010418a:	5d                   	pop    %ebp
8010418b:	c3                   	ret    
    return -1;
8010418c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104191:	eb f2                	jmp    80104185 <argfd+0x44>
    return -1;
80104193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104198:	eb eb                	jmp    80104185 <argfd+0x44>
  return 0;
8010419a:	b8 00 00 00 00       	mov    $0x0,%eax
8010419f:	eb e4                	jmp    80104185 <argfd+0x44>

801041a1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801041a1:	55                   	push   %ebp
801041a2:	89 e5                	mov    %esp,%ebp
801041a4:	53                   	push   %ebx
801041a5:	83 ec 04             	sub    $0x4,%esp
801041a8:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801041aa:	e8 6b f1 ff ff       	call   8010331a <myproc>
801041af:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
801041b1:	b8 00 00 00 00       	mov    $0x0,%eax
801041b6:	83 f8 0f             	cmp    $0xf,%eax
801041b9:	7f 10                	jg     801041cb <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
801041bb:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041c0:	74 03                	je     801041c5 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
801041c2:	40                   	inc    %eax
801041c3:	eb f1                	jmp    801041b6 <fdalloc+0x15>
      curproc->ofile[fd] = f;
801041c5:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
801041c9:	eb 05                	jmp    801041d0 <fdalloc+0x2f>
    }
  }
  return -1;
801041cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d3:	c9                   	leave  
801041d4:	c3                   	ret    

801041d5 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801041d5:	55                   	push   %ebp
801041d6:	89 e5                	mov    %esp,%ebp
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 10             	sub    $0x10,%esp
801041dd:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801041df:	b8 20 00 00 00       	mov    $0x20,%eax
801041e4:	89 c6                	mov    %eax,%esi
801041e6:	39 43 58             	cmp    %eax,0x58(%ebx)
801041e9:	76 2e                	jbe    80104219 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801041eb:	6a 10                	push   $0x10
801041ed:	50                   	push   %eax
801041ee:	8d 45 e8             	lea    -0x18(%ebp),%eax
801041f1:	50                   	push   %eax
801041f2:	53                   	push   %ebx
801041f3:	e8 fb d4 ff ff       	call   801016f3 <readi>
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	83 f8 10             	cmp    $0x10,%eax
801041fe:	75 0c                	jne    8010420c <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104200:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104205:	75 1e                	jne    80104225 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104207:	8d 46 10             	lea    0x10(%esi),%eax
8010420a:	eb d8                	jmp    801041e4 <isdirempty+0xf>
      panic("isdirempty: readi");
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	68 6c 72 10 80       	push   $0x8010726c
80104214:	e8 28 c1 ff ff       	call   80100341 <panic>
      return 0;
  }
  return 1;
80104219:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010421e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5d                   	pop    %ebp
80104224:	c3                   	ret    
      return 0;
80104225:	b8 00 00 00 00       	mov    $0x0,%eax
8010422a:	eb f2                	jmp    8010421e <isdirempty+0x49>

8010422c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010422c:	55                   	push   %ebp
8010422d:	89 e5                	mov    %esp,%ebp
8010422f:	57                   	push   %edi
80104230:	56                   	push   %esi
80104231:	53                   	push   %ebx
80104232:	83 ec 44             	sub    $0x44,%esp
80104235:	89 d7                	mov    %edx,%edi
80104237:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
8010423a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010423d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104240:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104243:	52                   	push   %edx
80104244:	50                   	push   %eax
80104245:	e8 38 d9 ff ff       	call   80101b82 <nameiparent>
8010424a:	89 c6                	mov    %eax,%esi
8010424c:	83 c4 10             	add    $0x10,%esp
8010424f:	85 c0                	test   %eax,%eax
80104251:	0f 84 32 01 00 00    	je     80104389 <create+0x15d>
    return 0;
  ilock(dp);
80104257:	83 ec 0c             	sub    $0xc,%esp
8010425a:	50                   	push   %eax
8010425b:	e8 a6 d2 ff ff       	call   80101506 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104260:	83 c4 0c             	add    $0xc,%esp
80104263:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104266:	50                   	push   %eax
80104267:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010426a:	50                   	push   %eax
8010426b:	56                   	push   %esi
8010426c:	e8 cb d6 ff ff       	call   8010193c <dirlookup>
80104271:	89 c3                	mov    %eax,%ebx
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	85 c0                	test   %eax,%eax
80104278:	74 3c                	je     801042b6 <create+0x8a>
    iunlockput(dp);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	56                   	push   %esi
8010427e:	e8 26 d4 ff ff       	call   801016a9 <iunlockput>
    ilock(ip);
80104283:	89 1c 24             	mov    %ebx,(%esp)
80104286:	e8 7b d2 ff ff       	call   80101506 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010428b:	83 c4 10             	add    $0x10,%esp
8010428e:	66 83 ff 02          	cmp    $0x2,%di
80104292:	75 07                	jne    8010429b <create+0x6f>
80104294:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104299:	74 11                	je     801042ac <create+0x80>
      return ip;
    iunlockput(ip);
8010429b:	83 ec 0c             	sub    $0xc,%esp
8010429e:	53                   	push   %ebx
8010429f:	e8 05 d4 ff ff       	call   801016a9 <iunlockput>
    return 0;
801042a4:	83 c4 10             	add    $0x10,%esp
801042a7:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042ac:	89 d8                	mov    %ebx,%eax
801042ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b1:	5b                   	pop    %ebx
801042b2:	5e                   	pop    %esi
801042b3:	5f                   	pop    %edi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801042b6:	83 ec 08             	sub    $0x8,%esp
801042b9:	0f bf c7             	movswl %di,%eax
801042bc:	50                   	push   %eax
801042bd:	ff 36                	push   (%esi)
801042bf:	e8 4a d0 ff ff       	call   8010130e <ialloc>
801042c4:	89 c3                	mov    %eax,%ebx
801042c6:	83 c4 10             	add    $0x10,%esp
801042c9:	85 c0                	test   %eax,%eax
801042cb:	74 53                	je     80104320 <create+0xf4>
  ilock(ip);
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	50                   	push   %eax
801042d1:	e8 30 d2 ff ff       	call   80101506 <ilock>
  ip->major = major;
801042d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801042d9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801042dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801042e0:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801042e4:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801042ea:	89 1c 24             	mov    %ebx,(%esp)
801042ed:	e8 bb d0 ff ff       	call   801013ad <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801042f2:	83 c4 10             	add    $0x10,%esp
801042f5:	66 83 ff 01          	cmp    $0x1,%di
801042f9:	74 32                	je     8010432d <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
801042fb:	83 ec 04             	sub    $0x4,%esp
801042fe:	ff 73 04             	push   0x4(%ebx)
80104301:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104304:	50                   	push   %eax
80104305:	56                   	push   %esi
80104306:	e8 ae d7 ff ff       	call   80101ab9 <dirlink>
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	85 c0                	test   %eax,%eax
80104310:	78 6a                	js     8010437c <create+0x150>
  iunlockput(dp);
80104312:	83 ec 0c             	sub    $0xc,%esp
80104315:	56                   	push   %esi
80104316:	e8 8e d3 ff ff       	call   801016a9 <iunlockput>
  return ip;
8010431b:	83 c4 10             	add    $0x10,%esp
8010431e:	eb 8c                	jmp    801042ac <create+0x80>
    panic("create: ialloc");
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 7e 72 10 80       	push   $0x8010727e
80104328:	e8 14 c0 ff ff       	call   80100341 <panic>
    dp->nlink++;  // for ".."
8010432d:	66 8b 46 56          	mov    0x56(%esi),%ax
80104331:	40                   	inc    %eax
80104332:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	56                   	push   %esi
8010433a:	e8 6e d0 ff ff       	call   801013ad <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010433f:	83 c4 0c             	add    $0xc,%esp
80104342:	ff 73 04             	push   0x4(%ebx)
80104345:	68 8e 72 10 80       	push   $0x8010728e
8010434a:	53                   	push   %ebx
8010434b:	e8 69 d7 ff ff       	call   80101ab9 <dirlink>
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	85 c0                	test   %eax,%eax
80104355:	78 18                	js     8010436f <create+0x143>
80104357:	83 ec 04             	sub    $0x4,%esp
8010435a:	ff 76 04             	push   0x4(%esi)
8010435d:	68 8d 72 10 80       	push   $0x8010728d
80104362:	53                   	push   %ebx
80104363:	e8 51 d7 ff ff       	call   80101ab9 <dirlink>
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	85 c0                	test   %eax,%eax
8010436d:	79 8c                	jns    801042fb <create+0xcf>
      panic("create dots");
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	68 90 72 10 80       	push   $0x80107290
80104377:	e8 c5 bf ff ff       	call   80100341 <panic>
    panic("create: dirlink");
8010437c:	83 ec 0c             	sub    $0xc,%esp
8010437f:	68 9c 72 10 80       	push   $0x8010729c
80104384:	e8 b8 bf ff ff       	call   80100341 <panic>
    return 0;
80104389:	89 c3                	mov    %eax,%ebx
8010438b:	e9 1c ff ff ff       	jmp    801042ac <create+0x80>

80104390 <sys_dup>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104397:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010439a:	ba 00 00 00 00       	mov    $0x0,%edx
8010439f:	b8 00 00 00 00       	mov    $0x0,%eax
801043a4:	e8 98 fd ff ff       	call   80104141 <argfd>
801043a9:	85 c0                	test   %eax,%eax
801043ab:	78 23                	js     801043d0 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
801043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b0:	e8 ec fd ff ff       	call   801041a1 <fdalloc>
801043b5:	89 c3                	mov    %eax,%ebx
801043b7:	85 c0                	test   %eax,%eax
801043b9:	78 1c                	js     801043d7 <sys_dup+0x47>
  filedup(f);
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	ff 75 f4             	push   -0xc(%ebp)
801043c1:	e8 81 c8 ff ff       	call   80100c47 <filedup>
  return fd;
801043c6:	83 c4 10             	add    $0x10,%esp
}
801043c9:	89 d8                	mov    %ebx,%eax
801043cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ce:	c9                   	leave  
801043cf:	c3                   	ret    
    return -1;
801043d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043d5:	eb f2                	jmp    801043c9 <sys_dup+0x39>
    return -1;
801043d7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043dc:	eb eb                	jmp    801043c9 <sys_dup+0x39>

801043de <sys_dup2>:
{
801043de:	55                   	push   %ebp
801043df:	89 e5                	mov    %esp,%ebp
801043e1:	53                   	push   %ebx
801043e2:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc();
801043e5:	e8 30 ef ff ff       	call   8010331a <myproc>
801043ea:	89 c3                	mov    %eax,%ebx
  if(argfd(0, 0, &f) < 0)
801043ec:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043ef:	ba 00 00 00 00       	mov    $0x0,%edx
801043f4:	b8 00 00 00 00       	mov    $0x0,%eax
801043f9:	e8 43 fd ff ff       	call   80104141 <argfd>
801043fe:	85 c0                	test   %eax,%eax
80104400:	78 64                	js     80104466 <sys_dup2+0x88>
  if(argint(1, &gd) < 0)
80104402:	83 ec 08             	sub    $0x8,%esp
80104405:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104408:	50                   	push   %eax
80104409:	6a 01                	push   $0x1
8010440b:	e8 17 fc ff ff       	call   80104027 <argint>
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	85 c0                	test   %eax,%eax
80104415:	78 56                	js     8010446d <sys_dup2+0x8f>
  if(gd < 0 || gd >= NOFILE)
80104417:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010441b:	77 57                	ja     80104474 <sys_dup2+0x96>
  g=myproc()->ofile[gd];
8010441d:	e8 f8 ee ff ff       	call   8010331a <myproc>
80104422:	89 c2                	mov    %eax,%edx
80104424:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104427:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
  if(f == g)
8010442b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
8010442e:	74 31                	je     80104461 <sys_dup2+0x83>
  if( g != 0 ){
80104430:	85 d2                	test   %edx,%edx
80104432:	74 14                	je     80104448 <sys_dup2+0x6a>
    curproc->ofile[gd] = 0;
80104434:	c7 44 83 28 00 00 00 	movl   $0x0,0x28(%ebx,%eax,4)
8010443b:	00 
    fileclose(g);
8010443c:	83 ec 0c             	sub    $0xc,%esp
8010443f:	52                   	push   %edx
80104440:	e8 45 c8 ff ff       	call   80100c8a <fileclose>
80104445:	83 c4 10             	add    $0x10,%esp
  curproc->ofile[gd] = f;
80104448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010444e:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(f);
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	50                   	push   %eax
80104456:	e8 ec c7 ff ff       	call   80100c47 <filedup>
  return gd;
8010445b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010445e:	83 c4 10             	add    $0x10,%esp
}
80104461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104464:	c9                   	leave  
80104465:	c3                   	ret    
    return -1;
80104466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010446b:	eb f4                	jmp    80104461 <sys_dup2+0x83>
    return -1;
8010446d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104472:	eb ed                	jmp    80104461 <sys_dup2+0x83>
    return -1;
80104474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104479:	eb e6                	jmp    80104461 <sys_dup2+0x83>

8010447b <sys_read>:
{
8010447b:	55                   	push   %ebp
8010447c:	89 e5                	mov    %esp,%ebp
8010447e:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104481:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104484:	ba 00 00 00 00       	mov    $0x0,%edx
80104489:	b8 00 00 00 00       	mov    $0x0,%eax
8010448e:	e8 ae fc ff ff       	call   80104141 <argfd>
80104493:	85 c0                	test   %eax,%eax
80104495:	78 43                	js     801044da <sys_read+0x5f>
80104497:	83 ec 08             	sub    $0x8,%esp
8010449a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010449d:	50                   	push   %eax
8010449e:	6a 02                	push   $0x2
801044a0:	e8 82 fb ff ff       	call   80104027 <argint>
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	85 c0                	test   %eax,%eax
801044aa:	78 2e                	js     801044da <sys_read+0x5f>
801044ac:	83 ec 04             	sub    $0x4,%esp
801044af:	ff 75 f0             	push   -0x10(%ebp)
801044b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044b5:	50                   	push   %eax
801044b6:	6a 01                	push   $0x1
801044b8:	e8 92 fb ff ff       	call   8010404f <argptr>
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	85 c0                	test   %eax,%eax
801044c2:	78 16                	js     801044da <sys_read+0x5f>
  return fileread(f, p, n);
801044c4:	83 ec 04             	sub    $0x4,%esp
801044c7:	ff 75 f0             	push   -0x10(%ebp)
801044ca:	ff 75 ec             	push   -0x14(%ebp)
801044cd:	ff 75 f4             	push   -0xc(%ebp)
801044d0:	e8 ae c8 ff ff       	call   80100d83 <fileread>
801044d5:	83 c4 10             	add    $0x10,%esp
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
    return -1;
801044da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044df:	eb f7                	jmp    801044d8 <sys_read+0x5d>

801044e1 <sys_write>:
{
801044e1:	55                   	push   %ebp
801044e2:	89 e5                	mov    %esp,%ebp
801044e4:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
801044e7:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044ea:	ba 00 00 00 00       	mov    $0x0,%edx
801044ef:	b8 00 00 00 00       	mov    $0x0,%eax
801044f4:	e8 48 fc ff ff       	call   80104141 <argfd>
801044f9:	85 c0                	test   %eax,%eax
801044fb:	78 43                	js     80104540 <sys_write+0x5f>
801044fd:	83 ec 08             	sub    $0x8,%esp
80104500:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104503:	50                   	push   %eax
80104504:	6a 02                	push   $0x2
80104506:	e8 1c fb ff ff       	call   80104027 <argint>
8010450b:	83 c4 10             	add    $0x10,%esp
8010450e:	85 c0                	test   %eax,%eax
80104510:	78 2e                	js     80104540 <sys_write+0x5f>
80104512:	83 ec 04             	sub    $0x4,%esp
80104515:	ff 75 f0             	push   -0x10(%ebp)
80104518:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010451b:	50                   	push   %eax
8010451c:	6a 01                	push   $0x1
8010451e:	e8 2c fb ff ff       	call   8010404f <argptr>
80104523:	83 c4 10             	add    $0x10,%esp
80104526:	85 c0                	test   %eax,%eax
80104528:	78 16                	js     80104540 <sys_write+0x5f>
  return filewrite(f, p, n);
8010452a:	83 ec 04             	sub    $0x4,%esp
8010452d:	ff 75 f0             	push   -0x10(%ebp)
80104530:	ff 75 ec             	push   -0x14(%ebp)
80104533:	ff 75 f4             	push   -0xc(%ebp)
80104536:	e8 cd c8 ff ff       	call   80100e08 <filewrite>
8010453b:	83 c4 10             	add    $0x10,%esp
}
8010453e:	c9                   	leave  
8010453f:	c3                   	ret    
    return -1;
80104540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104545:	eb f7                	jmp    8010453e <sys_write+0x5d>

80104547 <sys_close>:
{
80104547:	55                   	push   %ebp
80104548:	89 e5                	mov    %esp,%ebp
8010454a:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010454d:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104550:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104553:	b8 00 00 00 00       	mov    $0x0,%eax
80104558:	e8 e4 fb ff ff       	call   80104141 <argfd>
8010455d:	85 c0                	test   %eax,%eax
8010455f:	78 25                	js     80104586 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104561:	e8 b4 ed ff ff       	call   8010331a <myproc>
80104566:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104569:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104570:	00 
  fileclose(f);
80104571:	83 ec 0c             	sub    $0xc,%esp
80104574:	ff 75 f0             	push   -0x10(%ebp)
80104577:	e8 0e c7 ff ff       	call   80100c8a <fileclose>
  return 0;
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104584:	c9                   	leave  
80104585:	c3                   	ret    
    return -1;
80104586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458b:	eb f7                	jmp    80104584 <sys_close+0x3d>

8010458d <sys_fstat>:
{
8010458d:	55                   	push   %ebp
8010458e:	89 e5                	mov    %esp,%ebp
80104590:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104593:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104596:	ba 00 00 00 00       	mov    $0x0,%edx
8010459b:	b8 00 00 00 00       	mov    $0x0,%eax
801045a0:	e8 9c fb ff ff       	call   80104141 <argfd>
801045a5:	85 c0                	test   %eax,%eax
801045a7:	78 2a                	js     801045d3 <sys_fstat+0x46>
801045a9:	83 ec 04             	sub    $0x4,%esp
801045ac:	6a 14                	push   $0x14
801045ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045b1:	50                   	push   %eax
801045b2:	6a 01                	push   $0x1
801045b4:	e8 96 fa ff ff       	call   8010404f <argptr>
801045b9:	83 c4 10             	add    $0x10,%esp
801045bc:	85 c0                	test   %eax,%eax
801045be:	78 13                	js     801045d3 <sys_fstat+0x46>
  return filestat(f, st);
801045c0:	83 ec 08             	sub    $0x8,%esp
801045c3:	ff 75 f0             	push   -0x10(%ebp)
801045c6:	ff 75 f4             	push   -0xc(%ebp)
801045c9:	e8 6e c7 ff ff       	call   80100d3c <filestat>
801045ce:	83 c4 10             	add    $0x10,%esp
}
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
    return -1;
801045d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d8:	eb f7                	jmp    801045d1 <sys_fstat+0x44>

801045da <sys_link>:
{
801045da:	55                   	push   %ebp
801045db:	89 e5                	mov    %esp,%ebp
801045dd:	56                   	push   %esi
801045de:	53                   	push   %ebx
801045df:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801045e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045e5:	50                   	push   %eax
801045e6:	6a 00                	push   $0x0
801045e8:	e8 ca fa ff ff       	call   801040b7 <argstr>
801045ed:	83 c4 10             	add    $0x10,%esp
801045f0:	85 c0                	test   %eax,%eax
801045f2:	0f 88 d1 00 00 00    	js     801046c9 <sys_link+0xef>
801045f8:	83 ec 08             	sub    $0x8,%esp
801045fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045fe:	50                   	push   %eax
801045ff:	6a 01                	push   $0x1
80104601:	e8 b1 fa ff ff       	call   801040b7 <argstr>
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	85 c0                	test   %eax,%eax
8010460b:	0f 88 b8 00 00 00    	js     801046c9 <sys_link+0xef>
  begin_op();
80104611:	e8 c6 e0 ff ff       	call   801026dc <begin_op>
  if((ip = namei(old)) == 0){
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	ff 75 e0             	push   -0x20(%ebp)
8010461c:	e8 49 d5 ff ff       	call   80101b6a <namei>
80104621:	89 c3                	mov    %eax,%ebx
80104623:	83 c4 10             	add    $0x10,%esp
80104626:	85 c0                	test   %eax,%eax
80104628:	0f 84 a2 00 00 00    	je     801046d0 <sys_link+0xf6>
  ilock(ip);
8010462e:	83 ec 0c             	sub    $0xc,%esp
80104631:	50                   	push   %eax
80104632:	e8 cf ce ff ff       	call   80101506 <ilock>
  if(ip->type == T_DIR){
80104637:	83 c4 10             	add    $0x10,%esp
8010463a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010463f:	0f 84 97 00 00 00    	je     801046dc <sys_link+0x102>
  ip->nlink++;
80104645:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104649:	40                   	inc    %eax
8010464a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010464e:	83 ec 0c             	sub    $0xc,%esp
80104651:	53                   	push   %ebx
80104652:	e8 56 cd ff ff       	call   801013ad <iupdate>
  iunlock(ip);
80104657:	89 1c 24             	mov    %ebx,(%esp)
8010465a:	e8 67 cf ff ff       	call   801015c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010465f:	83 c4 08             	add    $0x8,%esp
80104662:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104665:	50                   	push   %eax
80104666:	ff 75 e4             	push   -0x1c(%ebp)
80104669:	e8 14 d5 ff ff       	call   80101b82 <nameiparent>
8010466e:	89 c6                	mov    %eax,%esi
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	85 c0                	test   %eax,%eax
80104675:	0f 84 85 00 00 00    	je     80104700 <sys_link+0x126>
  ilock(dp);
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	50                   	push   %eax
8010467f:	e8 82 ce ff ff       	call   80101506 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104684:	83 c4 10             	add    $0x10,%esp
80104687:	8b 03                	mov    (%ebx),%eax
80104689:	39 06                	cmp    %eax,(%esi)
8010468b:	75 67                	jne    801046f4 <sys_link+0x11a>
8010468d:	83 ec 04             	sub    $0x4,%esp
80104690:	ff 73 04             	push   0x4(%ebx)
80104693:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104696:	50                   	push   %eax
80104697:	56                   	push   %esi
80104698:	e8 1c d4 ff ff       	call   80101ab9 <dirlink>
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	85 c0                	test   %eax,%eax
801046a2:	78 50                	js     801046f4 <sys_link+0x11a>
  iunlockput(dp);
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	56                   	push   %esi
801046a8:	e8 fc cf ff ff       	call   801016a9 <iunlockput>
  iput(ip);
801046ad:	89 1c 24             	mov    %ebx,(%esp)
801046b0:	e8 56 cf ff ff       	call   8010160b <iput>
  end_op();
801046b5:	e8 9e e0 ff ff       	call   80102758 <end_op>
  return 0;
801046ba:	83 c4 10             	add    $0x10,%esp
801046bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c5:	5b                   	pop    %ebx
801046c6:	5e                   	pop    %esi
801046c7:	5d                   	pop    %ebp
801046c8:	c3                   	ret    
    return -1;
801046c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ce:	eb f2                	jmp    801046c2 <sys_link+0xe8>
    end_op();
801046d0:	e8 83 e0 ff ff       	call   80102758 <end_op>
    return -1;
801046d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046da:	eb e6                	jmp    801046c2 <sys_link+0xe8>
    iunlockput(ip);
801046dc:	83 ec 0c             	sub    $0xc,%esp
801046df:	53                   	push   %ebx
801046e0:	e8 c4 cf ff ff       	call   801016a9 <iunlockput>
    end_op();
801046e5:	e8 6e e0 ff ff       	call   80102758 <end_op>
    return -1;
801046ea:	83 c4 10             	add    $0x10,%esp
801046ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f2:	eb ce                	jmp    801046c2 <sys_link+0xe8>
    iunlockput(dp);
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	56                   	push   %esi
801046f8:	e8 ac cf ff ff       	call   801016a9 <iunlockput>
    goto bad;
801046fd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	53                   	push   %ebx
80104704:	e8 fd cd ff ff       	call   80101506 <ilock>
  ip->nlink--;
80104709:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010470d:	48                   	dec    %eax
8010470e:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104712:	89 1c 24             	mov    %ebx,(%esp)
80104715:	e8 93 cc ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
8010471a:	89 1c 24             	mov    %ebx,(%esp)
8010471d:	e8 87 cf ff ff       	call   801016a9 <iunlockput>
  end_op();
80104722:	e8 31 e0 ff ff       	call   80102758 <end_op>
  return -1;
80104727:	83 c4 10             	add    $0x10,%esp
8010472a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472f:	eb 91                	jmp    801046c2 <sys_link+0xe8>

80104731 <sys_unlink>:
{
80104731:	55                   	push   %ebp
80104732:	89 e5                	mov    %esp,%ebp
80104734:	57                   	push   %edi
80104735:	56                   	push   %esi
80104736:	53                   	push   %ebx
80104737:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010473a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010473d:	50                   	push   %eax
8010473e:	6a 00                	push   $0x0
80104740:	e8 72 f9 ff ff       	call   801040b7 <argstr>
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	85 c0                	test   %eax,%eax
8010474a:	0f 88 7f 01 00 00    	js     801048cf <sys_unlink+0x19e>
  begin_op();
80104750:	e8 87 df ff ff       	call   801026dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104755:	83 ec 08             	sub    $0x8,%esp
80104758:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010475b:	50                   	push   %eax
8010475c:	ff 75 c4             	push   -0x3c(%ebp)
8010475f:	e8 1e d4 ff ff       	call   80101b82 <nameiparent>
80104764:	89 c6                	mov    %eax,%esi
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	85 c0                	test   %eax,%eax
8010476b:	0f 84 eb 00 00 00    	je     8010485c <sys_unlink+0x12b>
  ilock(dp);
80104771:	83 ec 0c             	sub    $0xc,%esp
80104774:	50                   	push   %eax
80104775:	e8 8c cd ff ff       	call   80101506 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010477a:	83 c4 08             	add    $0x8,%esp
8010477d:	68 8e 72 10 80       	push   $0x8010728e
80104782:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104785:	50                   	push   %eax
80104786:	e8 9c d1 ff ff       	call   80101927 <namecmp>
8010478b:	83 c4 10             	add    $0x10,%esp
8010478e:	85 c0                	test   %eax,%eax
80104790:	0f 84 fa 00 00 00    	je     80104890 <sys_unlink+0x15f>
80104796:	83 ec 08             	sub    $0x8,%esp
80104799:	68 8d 72 10 80       	push   $0x8010728d
8010479e:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047a1:	50                   	push   %eax
801047a2:	e8 80 d1 ff ff       	call   80101927 <namecmp>
801047a7:	83 c4 10             	add    $0x10,%esp
801047aa:	85 c0                	test   %eax,%eax
801047ac:	0f 84 de 00 00 00    	je     80104890 <sys_unlink+0x15f>
  if((ip = dirlookup(dp, name, &off)) == 0)
801047b2:	83 ec 04             	sub    $0x4,%esp
801047b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047b8:	50                   	push   %eax
801047b9:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047bc:	50                   	push   %eax
801047bd:	56                   	push   %esi
801047be:	e8 79 d1 ff ff       	call   8010193c <dirlookup>
801047c3:	89 c3                	mov    %eax,%ebx
801047c5:	83 c4 10             	add    $0x10,%esp
801047c8:	85 c0                	test   %eax,%eax
801047ca:	0f 84 c0 00 00 00    	je     80104890 <sys_unlink+0x15f>
  ilock(ip);
801047d0:	83 ec 0c             	sub    $0xc,%esp
801047d3:	50                   	push   %eax
801047d4:	e8 2d cd ff ff       	call   80101506 <ilock>
  if(ip->nlink < 1)
801047d9:	83 c4 10             	add    $0x10,%esp
801047dc:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047e1:	0f 8e 81 00 00 00    	jle    80104868 <sys_unlink+0x137>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047e7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047ec:	0f 84 83 00 00 00    	je     80104875 <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
801047f2:	83 ec 04             	sub    $0x4,%esp
801047f5:	6a 10                	push   $0x10
801047f7:	6a 00                	push   $0x0
801047f9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801047fc:	57                   	push   %edi
801047fd:	e8 f2 f5 ff ff       	call   80103df4 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104802:	6a 10                	push   $0x10
80104804:	ff 75 c0             	push   -0x40(%ebp)
80104807:	57                   	push   %edi
80104808:	56                   	push   %esi
80104809:	e8 e5 cf ff ff       	call   801017f3 <writei>
8010480e:	83 c4 20             	add    $0x20,%esp
80104811:	83 f8 10             	cmp    $0x10,%eax
80104814:	0f 85 8e 00 00 00    	jne    801048a8 <sys_unlink+0x177>
  if(ip->type == T_DIR){
8010481a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010481f:	0f 84 90 00 00 00    	je     801048b5 <sys_unlink+0x184>
  iunlockput(dp);
80104825:	83 ec 0c             	sub    $0xc,%esp
80104828:	56                   	push   %esi
80104829:	e8 7b ce ff ff       	call   801016a9 <iunlockput>
  ip->nlink--;
8010482e:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104832:	48                   	dec    %eax
80104833:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104837:	89 1c 24             	mov    %ebx,(%esp)
8010483a:	e8 6e cb ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
8010483f:	89 1c 24             	mov    %ebx,(%esp)
80104842:	e8 62 ce ff ff       	call   801016a9 <iunlockput>
  end_op();
80104847:	e8 0c df ff ff       	call   80102758 <end_op>
  return 0;
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104854:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104857:	5b                   	pop    %ebx
80104858:	5e                   	pop    %esi
80104859:	5f                   	pop    %edi
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
    end_op();
8010485c:	e8 f7 de ff ff       	call   80102758 <end_op>
    return -1;
80104861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104866:	eb ec                	jmp    80104854 <sys_unlink+0x123>
    panic("unlink: nlink < 1");
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 ac 72 10 80       	push   $0x801072ac
80104870:	e8 cc ba ff ff       	call   80100341 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104875:	89 d8                	mov    %ebx,%eax
80104877:	e8 59 f9 ff ff       	call   801041d5 <isdirempty>
8010487c:	85 c0                	test   %eax,%eax
8010487e:	0f 85 6e ff ff ff    	jne    801047f2 <sys_unlink+0xc1>
    iunlockput(ip);
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	53                   	push   %ebx
80104888:	e8 1c ce ff ff       	call   801016a9 <iunlockput>
    goto bad;
8010488d:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	56                   	push   %esi
80104894:	e8 10 ce ff ff       	call   801016a9 <iunlockput>
  end_op();
80104899:	e8 ba de ff ff       	call   80102758 <end_op>
  return -1;
8010489e:	83 c4 10             	add    $0x10,%esp
801048a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a6:	eb ac                	jmp    80104854 <sys_unlink+0x123>
    panic("unlink: writei");
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 be 72 10 80       	push   $0x801072be
801048b0:	e8 8c ba ff ff       	call   80100341 <panic>
    dp->nlink--;
801048b5:	66 8b 46 56          	mov    0x56(%esi),%ax
801048b9:	48                   	dec    %eax
801048ba:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	56                   	push   %esi
801048c2:	e8 e6 ca ff ff       	call   801013ad <iupdate>
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	e9 56 ff ff ff       	jmp    80104825 <sys_unlink+0xf4>
    return -1;
801048cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d4:	e9 7b ff ff ff       	jmp    80104854 <sys_unlink+0x123>

801048d9 <sys_open>:

int
sys_open(void)
{
801048d9:	55                   	push   %ebp
801048da:	89 e5                	mov    %esp,%ebp
801048dc:	57                   	push   %edi
801048dd:	56                   	push   %esi
801048de:	53                   	push   %ebx
801048df:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048e5:	50                   	push   %eax
801048e6:	6a 00                	push   $0x0
801048e8:	e8 ca f7 ff ff       	call   801040b7 <argstr>
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	85 c0                	test   %eax,%eax
801048f2:	0f 88 a0 00 00 00    	js     80104998 <sys_open+0xbf>
801048f8:	83 ec 08             	sub    $0x8,%esp
801048fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048fe:	50                   	push   %eax
801048ff:	6a 01                	push   $0x1
80104901:	e8 21 f7 ff ff       	call   80104027 <argint>
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	85 c0                	test   %eax,%eax
8010490b:	0f 88 87 00 00 00    	js     80104998 <sys_open+0xbf>
    return -1;

  begin_op();
80104911:	e8 c6 dd ff ff       	call   801026dc <begin_op>

  if(omode & O_CREATE){
80104916:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
8010491a:	0f 84 8b 00 00 00    	je     801049ab <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
80104920:	83 ec 0c             	sub    $0xc,%esp
80104923:	6a 00                	push   $0x0
80104925:	b9 00 00 00 00       	mov    $0x0,%ecx
8010492a:	ba 02 00 00 00       	mov    $0x2,%edx
8010492f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104932:	e8 f5 f8 ff ff       	call   8010422c <create>
80104937:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104939:	83 c4 10             	add    $0x10,%esp
8010493c:	85 c0                	test   %eax,%eax
8010493e:	74 5f                	je     8010499f <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104940:	e8 a1 c2 ff ff       	call   80100be6 <filealloc>
80104945:	89 c3                	mov    %eax,%ebx
80104947:	85 c0                	test   %eax,%eax
80104949:	0f 84 b5 00 00 00    	je     80104a04 <sys_open+0x12b>
8010494f:	e8 4d f8 ff ff       	call   801041a1 <fdalloc>
80104954:	89 c7                	mov    %eax,%edi
80104956:	85 c0                	test   %eax,%eax
80104958:	0f 88 a6 00 00 00    	js     80104a04 <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010495e:	83 ec 0c             	sub    $0xc,%esp
80104961:	56                   	push   %esi
80104962:	e8 5f cc ff ff       	call   801015c6 <iunlock>
  end_op();
80104967:	e8 ec dd ff ff       	call   80102758 <end_op>

  f->type = FD_INODE;
8010496c:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104972:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104975:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010497c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010497f:	83 c4 10             	add    $0x10,%esp
80104982:	a8 01                	test   $0x1,%al
80104984:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104988:	a8 03                	test   $0x3,%al
8010498a:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
8010498e:	89 f8                	mov    %edi,%eax
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	5b                   	pop    %ebx
80104994:	5e                   	pop    %esi
80104995:	5f                   	pop    %edi
80104996:	5d                   	pop    %ebp
80104997:	c3                   	ret    
    return -1;
80104998:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010499d:	eb ef                	jmp    8010498e <sys_open+0xb5>
      end_op();
8010499f:	e8 b4 dd ff ff       	call   80102758 <end_op>
      return -1;
801049a4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a9:	eb e3                	jmp    8010498e <sys_open+0xb5>
    if((ip = namei(path)) == 0){
801049ab:	83 ec 0c             	sub    $0xc,%esp
801049ae:	ff 75 e4             	push   -0x1c(%ebp)
801049b1:	e8 b4 d1 ff ff       	call   80101b6a <namei>
801049b6:	89 c6                	mov    %eax,%esi
801049b8:	83 c4 10             	add    $0x10,%esp
801049bb:	85 c0                	test   %eax,%eax
801049bd:	74 39                	je     801049f8 <sys_open+0x11f>
    ilock(ip);
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	50                   	push   %eax
801049c3:	e8 3e cb ff ff       	call   80101506 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801049d0:	0f 85 6a ff ff ff    	jne    80104940 <sys_open+0x67>
801049d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049da:	0f 84 60 ff ff ff    	je     80104940 <sys_open+0x67>
      iunlockput(ip);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	56                   	push   %esi
801049e4:	e8 c0 cc ff ff       	call   801016a9 <iunlockput>
      end_op();
801049e9:	e8 6a dd ff ff       	call   80102758 <end_op>
      return -1;
801049ee:	83 c4 10             	add    $0x10,%esp
801049f1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049f6:	eb 96                	jmp    8010498e <sys_open+0xb5>
      end_op();
801049f8:	e8 5b dd ff ff       	call   80102758 <end_op>
      return -1;
801049fd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a02:	eb 8a                	jmp    8010498e <sys_open+0xb5>
    if(f)
80104a04:	85 db                	test   %ebx,%ebx
80104a06:	74 0c                	je     80104a14 <sys_open+0x13b>
      fileclose(f);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	53                   	push   %ebx
80104a0c:	e8 79 c2 ff ff       	call   80100c8a <fileclose>
80104a11:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	56                   	push   %esi
80104a18:	e8 8c cc ff ff       	call   801016a9 <iunlockput>
    end_op();
80104a1d:	e8 36 dd ff ff       	call   80102758 <end_op>
    return -1;
80104a22:	83 c4 10             	add    $0x10,%esp
80104a25:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a2a:	e9 5f ff ff ff       	jmp    8010498e <sys_open+0xb5>

80104a2f <sys_mkdir>:

int
sys_mkdir(void)
{
80104a2f:	55                   	push   %ebp
80104a30:	89 e5                	mov    %esp,%ebp
80104a32:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a35:	e8 a2 dc ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a3a:	83 ec 08             	sub    $0x8,%esp
80104a3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a40:	50                   	push   %eax
80104a41:	6a 00                	push   $0x0
80104a43:	e8 6f f6 ff ff       	call   801040b7 <argstr>
80104a48:	83 c4 10             	add    $0x10,%esp
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	78 36                	js     80104a85 <sys_mkdir+0x56>
80104a4f:	83 ec 0c             	sub    $0xc,%esp
80104a52:	6a 00                	push   $0x0
80104a54:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a59:	ba 01 00 00 00       	mov    $0x1,%edx
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	e8 c6 f7 ff ff       	call   8010422c <create>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 c0                	test   %eax,%eax
80104a6b:	74 18                	je     80104a85 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a6d:	83 ec 0c             	sub    $0xc,%esp
80104a70:	50                   	push   %eax
80104a71:	e8 33 cc ff ff       	call   801016a9 <iunlockput>
  end_op();
80104a76:	e8 dd dc ff ff       	call   80102758 <end_op>
  return 0;
80104a7b:	83 c4 10             	add    $0x10,%esp
80104a7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a83:	c9                   	leave  
80104a84:	c3                   	ret    
    end_op();
80104a85:	e8 ce dc ff ff       	call   80102758 <end_op>
    return -1;
80104a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8f:	eb f2                	jmp    80104a83 <sys_mkdir+0x54>

80104a91 <sys_mknod>:

int
sys_mknod(void)
{
80104a91:	55                   	push   %ebp
80104a92:	89 e5                	mov    %esp,%ebp
80104a94:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a97:	e8 40 dc ff ff       	call   801026dc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104a9c:	83 ec 08             	sub    $0x8,%esp
80104a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa2:	50                   	push   %eax
80104aa3:	6a 00                	push   $0x0
80104aa5:	e8 0d f6 ff ff       	call   801040b7 <argstr>
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	85 c0                	test   %eax,%eax
80104aaf:	78 62                	js     80104b13 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104ab1:	83 ec 08             	sub    $0x8,%esp
80104ab4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ab7:	50                   	push   %eax
80104ab8:	6a 01                	push   $0x1
80104aba:	e8 68 f5 ff ff       	call   80104027 <argint>
  if((argstr(0, &path)) < 0 ||
80104abf:	83 c4 10             	add    $0x10,%esp
80104ac2:	85 c0                	test   %eax,%eax
80104ac4:	78 4d                	js     80104b13 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104ac6:	83 ec 08             	sub    $0x8,%esp
80104ac9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104acc:	50                   	push   %eax
80104acd:	6a 02                	push   $0x2
80104acf:	e8 53 f5 ff ff       	call   80104027 <argint>
     argint(1, &major) < 0 ||
80104ad4:	83 c4 10             	add    $0x10,%esp
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	78 38                	js     80104b13 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104adb:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104ae6:	50                   	push   %eax
80104ae7:	ba 03 00 00 00       	mov    $0x3,%edx
80104aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aef:	e8 38 f7 ff ff       	call   8010422c <create>
     argint(2, &minor) < 0 ||
80104af4:	83 c4 10             	add    $0x10,%esp
80104af7:	85 c0                	test   %eax,%eax
80104af9:	74 18                	je     80104b13 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	50                   	push   %eax
80104aff:	e8 a5 cb ff ff       	call   801016a9 <iunlockput>
  end_op();
80104b04:	e8 4f dc ff ff       	call   80102758 <end_op>
  return 0;
80104b09:	83 c4 10             	add    $0x10,%esp
80104b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b11:	c9                   	leave  
80104b12:	c3                   	ret    
    end_op();
80104b13:	e8 40 dc ff ff       	call   80102758 <end_op>
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1d:	eb f2                	jmp    80104b11 <sys_mknod+0x80>

80104b1f <sys_chdir>:

int
sys_chdir(void)
{
80104b1f:	55                   	push   %ebp
80104b20:	89 e5                	mov    %esp,%ebp
80104b22:	56                   	push   %esi
80104b23:	53                   	push   %ebx
80104b24:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104b27:	e8 ee e7 ff ff       	call   8010331a <myproc>
80104b2c:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104b2e:	e8 a9 db ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104b33:	83 ec 08             	sub    $0x8,%esp
80104b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b39:	50                   	push   %eax
80104b3a:	6a 00                	push   $0x0
80104b3c:	e8 76 f5 ff ff       	call   801040b7 <argstr>
80104b41:	83 c4 10             	add    $0x10,%esp
80104b44:	85 c0                	test   %eax,%eax
80104b46:	78 52                	js     80104b9a <sys_chdir+0x7b>
80104b48:	83 ec 0c             	sub    $0xc,%esp
80104b4b:	ff 75 f4             	push   -0xc(%ebp)
80104b4e:	e8 17 d0 ff ff       	call   80101b6a <namei>
80104b53:	89 c3                	mov    %eax,%ebx
80104b55:	83 c4 10             	add    $0x10,%esp
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	74 3e                	je     80104b9a <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104b5c:	83 ec 0c             	sub    $0xc,%esp
80104b5f:	50                   	push   %eax
80104b60:	e8 a1 c9 ff ff       	call   80101506 <ilock>
  if(ip->type != T_DIR){
80104b65:	83 c4 10             	add    $0x10,%esp
80104b68:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b6d:	75 37                	jne    80104ba6 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	53                   	push   %ebx
80104b73:	e8 4e ca ff ff       	call   801015c6 <iunlock>
  iput(curproc->cwd);
80104b78:	83 c4 04             	add    $0x4,%esp
80104b7b:	ff 76 68             	push   0x68(%esi)
80104b7e:	e8 88 ca ff ff       	call   8010160b <iput>
  end_op();
80104b83:	e8 d0 db ff ff       	call   80102758 <end_op>
  curproc->cwd = ip;
80104b88:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b8b:	83 c4 10             	add    $0x10,%esp
80104b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b96:	5b                   	pop    %ebx
80104b97:	5e                   	pop    %esi
80104b98:	5d                   	pop    %ebp
80104b99:	c3                   	ret    
    end_op();
80104b9a:	e8 b9 db ff ff       	call   80102758 <end_op>
    return -1;
80104b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba4:	eb ed                	jmp    80104b93 <sys_chdir+0x74>
    iunlockput(ip);
80104ba6:	83 ec 0c             	sub    $0xc,%esp
80104ba9:	53                   	push   %ebx
80104baa:	e8 fa ca ff ff       	call   801016a9 <iunlockput>
    end_op();
80104baf:	e8 a4 db ff ff       	call   80102758 <end_op>
    return -1;
80104bb4:	83 c4 10             	add    $0x10,%esp
80104bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bbc:	eb d5                	jmp    80104b93 <sys_chdir+0x74>

80104bbe <sys_exec>:

int
sys_exec(void)
{
80104bbe:	55                   	push   %ebp
80104bbf:	89 e5                	mov    %esp,%ebp
80104bc1:	53                   	push   %ebx
80104bc2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104bc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcb:	50                   	push   %eax
80104bcc:	6a 00                	push   $0x0
80104bce:	e8 e4 f4 ff ff       	call   801040b7 <argstr>
80104bd3:	83 c4 10             	add    $0x10,%esp
80104bd6:	85 c0                	test   %eax,%eax
80104bd8:	78 38                	js     80104c12 <sys_exec+0x54>
80104bda:	83 ec 08             	sub    $0x8,%esp
80104bdd:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104be3:	50                   	push   %eax
80104be4:	6a 01                	push   $0x1
80104be6:	e8 3c f4 ff ff       	call   80104027 <argint>
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	85 c0                	test   %eax,%eax
80104bf0:	78 20                	js     80104c12 <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bf2:	83 ec 04             	sub    $0x4,%esp
80104bf5:	68 80 00 00 00       	push   $0x80
80104bfa:	6a 00                	push   $0x0
80104bfc:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c02:	50                   	push   %eax
80104c03:	e8 ec f1 ff ff       	call   80103df4 <memset>
80104c08:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104c0b:	bb 00 00 00 00       	mov    $0x0,%ebx
80104c10:	eb 2a                	jmp    80104c3c <sys_exec+0x7e>
    return -1;
80104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c17:	eb 76                	jmp    80104c8f <sys_exec+0xd1>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104c19:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104c20:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104c24:	83 ec 08             	sub    $0x8,%esp
80104c27:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c2d:	50                   	push   %eax
80104c2e:	ff 75 f4             	push   -0xc(%ebp)
80104c31:	e8 5a bc ff ff       	call   80100890 <exec>
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	eb 54                	jmp    80104c8f <sys_exec+0xd1>
  for(i=0;; i++){
80104c3b:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104c3c:	83 fb 1f             	cmp    $0x1f,%ebx
80104c3f:	77 49                	ja     80104c8a <sys_exec+0xcc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104c41:	83 ec 08             	sub    $0x8,%esp
80104c44:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104c4a:	50                   	push   %eax
80104c4b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104c51:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104c54:	50                   	push   %eax
80104c55:	e8 55 f3 ff ff       	call   80103faf <fetchint>
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	78 33                	js     80104c94 <sys_exec+0xd6>
    if(uarg == 0){
80104c61:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c67:	85 c0                	test   %eax,%eax
80104c69:	74 ae                	je     80104c19 <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104c6b:	83 ec 08             	sub    $0x8,%esp
80104c6e:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c75:	52                   	push   %edx
80104c76:	50                   	push   %eax
80104c77:	e8 6e f3 ff ff       	call   80103fea <fetchstr>
80104c7c:	83 c4 10             	add    $0x10,%esp
80104c7f:	85 c0                	test   %eax,%eax
80104c81:	79 b8                	jns    80104c3b <sys_exec+0x7d>
      return -1;
80104c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c88:	eb 05                	jmp    80104c8f <sys_exec+0xd1>
      return -1;
80104c8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    
      return -1;
80104c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c99:	eb f4                	jmp    80104c8f <sys_exec+0xd1>

80104c9b <sys_pipe>:

int
sys_pipe(void)
{
80104c9b:	55                   	push   %ebp
80104c9c:	89 e5                	mov    %esp,%ebp
80104c9e:	53                   	push   %ebx
80104c9f:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104ca2:	6a 08                	push   $0x8
80104ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca7:	50                   	push   %eax
80104ca8:	6a 00                	push   $0x0
80104caa:	e8 a0 f3 ff ff       	call   8010404f <argptr>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	78 79                	js     80104d2f <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104cb6:	83 ec 08             	sub    $0x8,%esp
80104cb9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cbc:	50                   	push   %eax
80104cbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cc0:	50                   	push   %eax
80104cc1:	e8 8d df ff ff       	call   80102c53 <pipealloc>
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	85 c0                	test   %eax,%eax
80104ccb:	78 69                	js     80104d36 <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd0:	e8 cc f4 ff ff       	call   801041a1 <fdalloc>
80104cd5:	89 c3                	mov    %eax,%ebx
80104cd7:	85 c0                	test   %eax,%eax
80104cd9:	78 21                	js     80104cfc <sys_pipe+0x61>
80104cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cde:	e8 be f4 ff ff       	call   801041a1 <fdalloc>
80104ce3:	85 c0                	test   %eax,%eax
80104ce5:	78 15                	js     80104cfc <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cea:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cef:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cfa:	c9                   	leave  
80104cfb:	c3                   	ret    
    if(fd0 >= 0)
80104cfc:	85 db                	test   %ebx,%ebx
80104cfe:	79 20                	jns    80104d20 <sys_pipe+0x85>
    fileclose(rf);
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	ff 75 f0             	push   -0x10(%ebp)
80104d06:	e8 7f bf ff ff       	call   80100c8a <fileclose>
    fileclose(wf);
80104d0b:	83 c4 04             	add    $0x4,%esp
80104d0e:	ff 75 ec             	push   -0x14(%ebp)
80104d11:	e8 74 bf ff ff       	call   80100c8a <fileclose>
    return -1;
80104d16:	83 c4 10             	add    $0x10,%esp
80104d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1e:	eb d7                	jmp    80104cf7 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104d20:	e8 f5 e5 ff ff       	call   8010331a <myproc>
80104d25:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d2c:	00 
80104d2d:	eb d1                	jmp    80104d00 <sys_pipe+0x65>
    return -1;
80104d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d34:	eb c1                	jmp    80104cf7 <sys_pipe+0x5c>
    return -1;
80104d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3b:	eb ba                	jmp    80104cf7 <sys_pipe+0x5c>

80104d3d <sys_fork>:

pte_t *	walkpgdir(pde_t *pgdir, const void *va, int alloc);

int
sys_fork(void)
{
80104d3d:	55                   	push   %ebp
80104d3e:	89 e5                	mov    %esp,%ebp
80104d40:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d43:	e8 5e e7 ff ff       	call   801034a6 <fork>
}
80104d48:	c9                   	leave  
80104d49:	c3                   	ret    

80104d4a <sys_exit>:

int
sys_exit(void)
{
80104d4a:	55                   	push   %ebp
80104d4b:	89 e5                	mov    %esp,%ebp
80104d4d:	83 ec 20             	sub    $0x20,%esp
  int i;
  if(argint(0, &i) < 0)
80104d50:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d53:	50                   	push   %eax
80104d54:	6a 00                	push   $0x0
80104d56:	e8 cc f2 ff ff       	call   80104027 <argint>
80104d5b:	83 c4 10             	add    $0x10,%esp
80104d5e:	85 c0                	test   %eax,%eax
80104d60:	78 1e                	js     80104d80 <sys_exit+0x36>
   return -1;
  myproc()->status = i;
80104d62:	e8 b3 e5 ff ff       	call   8010331a <myproc>
80104d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d6a:	89 50 7c             	mov    %edx,0x7c(%eax)
  exit(i);
80104d6d:	83 ec 0c             	sub    $0xc,%esp
80104d70:	52                   	push   %edx
80104d71:	e8 92 e9 ff ff       	call   80103708 <exit>
  return 0;  // not reached
80104d76:	83 c4 10             	add    $0x10,%esp
80104d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d7e:	c9                   	leave  
80104d7f:	c3                   	ret    
   return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb f7                	jmp    80104d7e <sys_exit+0x34>

80104d87 <sys_wait>:

int
sys_wait(void)
{
80104d87:	55                   	push   %ebp
80104d88:	89 e5                	mov    %esp,%ebp
80104d8a:	83 ec 1c             	sub    $0x1c,%esp
  int* i;
  if(argptr(0, (void**)&i, sizeof(*i)) < 0)
80104d8d:	6a 04                	push   $0x4
80104d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d92:	50                   	push   %eax
80104d93:	6a 00                	push   $0x0
80104d95:	e8 b5 f2 ff ff       	call   8010404f <argptr>
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	78 10                	js     80104db1 <sys_wait+0x2a>
    return -1;
  return wait(i);
80104da1:	83 ec 0c             	sub    $0xc,%esp
80104da4:	ff 75 f4             	push   -0xc(%ebp)
80104da7:	e8 15 eb ff ff       	call   801038c1 <wait>
80104dac:	83 c4 10             	add    $0x10,%esp
}
80104daf:	c9                   	leave  
80104db0:	c3                   	ret    
    return -1;
80104db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db6:	eb f7                	jmp    80104daf <sys_wait+0x28>

80104db8 <sys_kill>:

int
sys_kill(void)
{
80104db8:	55                   	push   %ebp
80104db9:	89 e5                	mov    %esp,%ebp
80104dbb:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dc1:	50                   	push   %eax
80104dc2:	6a 00                	push   $0x0
80104dc4:	e8 5e f2 ff ff       	call   80104027 <argint>
80104dc9:	83 c4 10             	add    $0x10,%esp
80104dcc:	85 c0                	test   %eax,%eax
80104dce:	78 10                	js     80104de0 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
80104dd3:	ff 75 f4             	push   -0xc(%ebp)
80104dd6:	e8 f0 eb ff ff       	call   801039cb <kill>
80104ddb:	83 c4 10             	add    $0x10,%esp
}
80104dde:	c9                   	leave  
80104ddf:	c3                   	ret    
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb f7                	jmp    80104dde <sys_kill+0x26>

80104de7 <sys_getpid>:

int
sys_getpid(void)
{
80104de7:	55                   	push   %ebp
80104de8:	89 e5                	mov    %esp,%ebp
80104dea:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104ded:	e8 28 e5 ff ff       	call   8010331a <myproc>
80104df2:	8b 40 10             	mov    0x10(%eax),%eax
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    

80104df7 <sys_sbrk>:

int
sys_sbrk(void)
{
80104df7:	55                   	push   %ebp
80104df8:	89 e5                	mov    %esp,%ebp
80104dfa:	57                   	push   %edi
80104dfb:	56                   	push   %esi
80104dfc:	53                   	push   %ebx
80104dfd:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;
  
  if(argint(0, &n) < 0)
80104e00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e03:	50                   	push   %eax
80104e04:	6a 00                	push   $0x0
80104e06:	e8 1c f2 ff ff       	call   80104027 <argint>
80104e0b:	83 c4 10             	add    $0x10,%esp
80104e0e:	85 c0                	test   %eax,%eax
80104e10:	78 43                	js     80104e55 <sys_sbrk+0x5e>
    return -1;
  
  addr = myproc()->sz;
80104e12:	e8 03 e5 ff ff       	call   8010331a <myproc>
80104e17:	8b 18                	mov    (%eax),%ebx
80104e19:	89 de                	mov    %ebx,%esi
  
  myproc()->sz = addr + n;
80104e1b:	89 df                	mov    %ebx,%edi
80104e1d:	03 7d e4             	add    -0x1c(%ebp),%edi
80104e20:	e8 f5 e4 ff ff       	call   8010331a <myproc>
80104e25:	89 38                	mov    %edi,(%eax)
    // return -1;
  
  //en casos de n negativa o neutra no parece que entre a trap.c osea que si quiero hacer deallocation tiene que ser aqui digo yo
  //pero hacerlo aqui no seria lazy allocation pero no se donde mas ponerlo de todas formas
  // que se podria argumentar que al contrario que en el caso de reservar memoria que quieres hacerlo cuando lo necesites, despejar memoria querrias hacerlo cuanto antes pero bueno.
  if(n < 0){
80104e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104e2b:	78 0a                	js     80104e37 <sys_sbrk+0x40>
  }
  
 
  
  return addr;
}
80104e2d:	89 f0                	mov    %esi,%eax
80104e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
     deallocuvm(myproc()->pgdir, addr, myproc()->sz);
80104e37:	e8 de e4 ff ff       	call   8010331a <myproc>
80104e3c:	8b 38                	mov    (%eax),%edi
80104e3e:	e8 d7 e4 ff ff       	call   8010331a <myproc>
80104e43:	83 ec 04             	sub    $0x4,%esp
80104e46:	57                   	push   %edi
80104e47:	53                   	push   %ebx
80104e48:	ff 70 04             	push   0x4(%eax)
80104e4b:	e8 b4 18 00 00       	call   80106704 <deallocuvm>
80104e50:	83 c4 10             	add    $0x10,%esp
80104e53:	eb d8                	jmp    80104e2d <sys_sbrk+0x36>
    return -1;
80104e55:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e5a:	eb d1                	jmp    80104e2d <sys_sbrk+0x36>

80104e5c <sys_sleep>:

int
sys_sleep(void)
{
80104e5c:	55                   	push   %ebp
80104e5d:	89 e5                	mov    %esp,%ebp
80104e5f:	53                   	push   %ebx
80104e60:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104e63:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e66:	50                   	push   %eax
80104e67:	6a 00                	push   $0x0
80104e69:	e8 b9 f1 ff ff       	call   80104027 <argint>
80104e6e:	83 c4 10             	add    $0x10,%esp
80104e71:	85 c0                	test   %eax,%eax
80104e73:	78 75                	js     80104eea <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104e75:	83 ec 0c             	sub    $0xc,%esp
80104e78:	68 e0 3f 11 80       	push   $0x80113fe0
80104e7d:	e8 c6 ee ff ff       	call   80103d48 <acquire>
  ticks0 = ticks;
80104e82:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  while(ticks - ticks0 < n){
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104e90:	29 d8                	sub    %ebx,%eax
80104e92:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e95:	73 39                	jae    80104ed0 <sys_sleep+0x74>
    if(myproc()->killed){
80104e97:	e8 7e e4 ff ff       	call   8010331a <myproc>
80104e9c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104ea0:	75 17                	jne    80104eb9 <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104ea2:	83 ec 08             	sub    $0x8,%esp
80104ea5:	68 e0 3f 11 80       	push   $0x80113fe0
80104eaa:	68 c0 3f 11 80       	push   $0x80113fc0
80104eaf:	e8 7c e9 ff ff       	call   80103830 <sleep>
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	eb d2                	jmp    80104e8b <sys_sleep+0x2f>
      release(&tickslock);
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	68 e0 3f 11 80       	push   $0x80113fe0
80104ec1:	e8 e7 ee ff ff       	call   80103dad <release>
      return -1;
80104ec6:	83 c4 10             	add    $0x10,%esp
80104ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ece:	eb 15                	jmp    80104ee5 <sys_sleep+0x89>
  }
  release(&tickslock);
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	68 e0 3f 11 80       	push   $0x80113fe0
80104ed8:	e8 d0 ee ff ff       	call   80103dad <release>
  return 0;
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee8:	c9                   	leave  
80104ee9:	c3                   	ret    
    return -1;
80104eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eef:	eb f4                	jmp    80104ee5 <sys_sleep+0x89>

80104ef1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104ef1:	55                   	push   %ebp
80104ef2:	89 e5                	mov    %esp,%ebp
80104ef4:	53                   	push   %ebx
80104ef5:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104ef8:	68 e0 3f 11 80       	push   $0x80113fe0
80104efd:	e8 46 ee ff ff       	call   80103d48 <acquire>
  xticks = ticks;
80104f02:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  release(&tickslock);
80104f08:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104f0f:	e8 99 ee ff ff       	call   80103dad <release>
  return xticks;
}
80104f14:	89 d8                	mov    %ebx,%eax
80104f16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f19:	c9                   	leave  
80104f1a:	c3                   	ret    

80104f1b <sys_date>:

int
sys_date(void)
{
80104f1b:	55                   	push   %ebp
80104f1c:	89 e5                	mov    %esp,%ebp
80104f1e:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *ptr;
  
  if(argptr(0, (void **) &ptr, sizeof(*ptr)) < 0)
80104f21:	6a 18                	push   $0x18
80104f23:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f26:	50                   	push   %eax
80104f27:	6a 00                	push   $0x0
80104f29:	e8 21 f1 ff ff       	call   8010404f <argptr>
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	85 c0                	test   %eax,%eax
80104f33:	78 15                	js     80104f4a <sys_date+0x2f>
    return -1;
  cmostime(ptr);
80104f35:	83 ec 0c             	sub    $0xc,%esp
80104f38:	ff 75 f4             	push   -0xc(%ebp)
80104f3b:	e8 6e d4 ff ff       	call   801023ae <cmostime>
  return 0;
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f48:	c9                   	leave  
80104f49:	c3                   	ret    
    return -1;
80104f4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4f:	eb f7                	jmp    80104f48 <sys_date+0x2d>

80104f51 <sys_phmem>:

int
sys_phmem(void){
80104f51:	55                   	push   %ebp
80104f52:	89 e5                	mov    %esp,%ebp
80104f54:	57                   	push   %edi
80104f55:	56                   	push   %esi
80104f56:	53                   	push   %ebx
80104f57:	83 ec 24             	sub    $0x24,%esp
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
80104f5a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f5d:	50                   	push   %eax
80104f5e:	6a 00                	push   $0x0
80104f60:	e8 c2 f0 ff ff       	call   80104027 <argint>
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	78 78                	js     80104fe4 <sys_phmem+0x93>
    return -1;
  if((p = getProcbyPID(pid)) == 0){
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	ff 75 e4             	push   -0x1c(%ebp)
80104f72:	e8 e1 e1 ff ff       	call   80103158 <getProcbyPID>
80104f77:	89 c6                	mov    %eax,%esi
80104f79:	83 c4 10             	add    $0x10,%esp
80104f7c:	85 c0                	test   %eax,%eax
80104f7e:	74 0c                	je     80104f8c <sys_phmem+0x3b>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  int count = 0;
  pte_t *pte;
  uint a = 0;
80104f80:	bb 00 00 00 00       	mov    $0x0,%ebx
  int count = 0;
80104f85:	bf 00 00 00 00       	mov    $0x0,%edi
80104f8a:	eb 1d                	jmp    80104fa9 <sys_phmem+0x58>
  	cprintf("No existe un proceso con esa PID\n");
80104f8c:	83 ec 0c             	sub    $0xc,%esp
80104f8f:	68 d0 72 10 80       	push   $0x801072d0
80104f94:	e8 41 b6 ff ff       	call   801005da <cprintf>
  	return -1;
80104f99:	83 c4 10             	add    $0x10,%esp
80104f9c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104fa1:	eb 37                	jmp    80104fda <sys_phmem+0x89>
  for(; a  <= p->sz ; a += PGSIZE){
80104fa3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80104fa9:	39 1e                	cmp    %ebx,(%esi)
80104fab:	72 19                	jb     80104fc6 <sys_phmem+0x75>
    pte = walkpgdir(p->pgdir, (char*)a, 0);
80104fad:	83 ec 04             	sub    $0x4,%esp
80104fb0:	6a 00                	push   $0x0
80104fb2:	53                   	push   %ebx
80104fb3:	ff 76 04             	push   0x4(%esi)
80104fb6:	e8 fe 13 00 00       	call   801063b9 <walkpgdir>
    
    if((*pte & PTE_P) != 0){
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	f6 00 01             	testb  $0x1,(%eax)
80104fc1:	74 e0                	je     80104fa3 <sys_phmem+0x52>
      count++;
80104fc3:	47                   	inc    %edi
80104fc4:	eb dd                	jmp    80104fa3 <sys_phmem+0x52>
    }
  }
  
  uint end = (count*PGSIZE)/1024;
80104fc6:	c1 e7 02             	shl    $0x2,%edi
  cprintf("%d", end);
80104fc9:	83 ec 08             	sub    $0x8,%esp
80104fcc:	57                   	push   %edi
80104fcd:	68 f2 72 10 80       	push   $0x801072f2
80104fd2:	e8 03 b6 ff ff       	call   801005da <cprintf>
  
  return end;
80104fd7:	83 c4 10             	add    $0x10,%esp
}
80104fda:	89 f8                	mov    %edi,%eax
80104fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5f                   	pop    %edi
80104fe2:	5d                   	pop    %ebp
80104fe3:	c3                   	ret    
    return -1;
80104fe4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104fe9:	eb ef                	jmp    80104fda <sys_phmem+0x89>

80104feb <sys_getprio>:

int
sys_getprio(void){
80104feb:	55                   	push   %ebp
80104fec:	89 e5                	mov    %esp,%ebp
80104fee:	83 ec 20             	sub    $0x20,%esp
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
80104ff1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff4:	50                   	push   %eax
80104ff5:	6a 00                	push   $0x0
80104ff7:	e8 2b f0 ff ff       	call   80104027 <argint>
80104ffc:	83 c4 10             	add    $0x10,%esp
80104fff:	85 c0                	test   %eax,%eax
80105001:	78 31                	js     80105034 <sys_getprio+0x49>
    return -1;
  if((p = getProcbyPID(pid)) == 0){
80105003:	83 ec 0c             	sub    $0xc,%esp
80105006:	ff 75 f4             	push   -0xc(%ebp)
80105009:	e8 4a e1 ff ff       	call   80103158 <getProcbyPID>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	74 08                	je     8010501d <sys_getprio+0x32>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  
  return p->prio;
80105015:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010501b:	c9                   	leave  
8010501c:	c3                   	ret    
  	cprintf("No existe un proceso con esa PID\n");
8010501d:	83 ec 0c             	sub    $0xc,%esp
80105020:	68 d0 72 10 80       	push   $0x801072d0
80105025:	e8 b0 b5 ff ff       	call   801005da <cprintf>
  	return -1;
8010502a:	83 c4 10             	add    $0x10,%esp
8010502d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105032:	eb e7                	jmp    8010501b <sys_getprio+0x30>
    return -1;
80105034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105039:	eb e0                	jmp    8010501b <sys_getprio+0x30>

8010503b <sys_setprio>:

int
sys_setprio(void){
8010503b:	55                   	push   %ebp
8010503c:	89 e5                	mov    %esp,%ebp
8010503e:	56                   	push   %esi
8010503f:	53                   	push   %ebx
80105040:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *p;
  int trampas;
  unsigned int a;
  if(argint(0, &pid) < 0)
80105043:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105046:	50                   	push   %eax
80105047:	6a 00                	push   $0x0
80105049:	e8 d9 ef ff ff       	call   80104027 <argint>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	85 c0                	test   %eax,%eax
80105053:	78 6b                	js     801050c0 <sys_setprio+0x85>
    return -1;
    
  if(argint(1, &trampas) < 0)
80105055:	83 ec 08             	sub    $0x8,%esp
80105058:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010505b:	50                   	push   %eax
8010505c:	6a 01                	push   $0x1
8010505e:	e8 c4 ef ff ff       	call   80104027 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 5d                	js     801050c7 <sys_setprio+0x8c>
    return -1;
  a = trampas;
8010506a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  if((p = getProcbyPID(pid)) == 0){
8010506d:	83 ec 0c             	sub    $0xc,%esp
80105070:	ff 75 f4             	push   -0xc(%ebp)
80105073:	e8 e0 e0 ff ff       	call   80103158 <getProcbyPID>
80105078:	89 c3                	mov    %eax,%ebx
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	85 c0                	test   %eax,%eax
8010507f:	74 19                	je     8010509a <sys_setprio+0x5f>
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  if(p->state == RUNNABLE){
80105081:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105085:	74 2a                	je     801050b1 <sys_setprio+0x76>
  	setNewPrio(p, a);
  } else {
  	p->prio = a;
80105087:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  }
  
  return p->prio;
8010508d:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80105093:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105096:	5b                   	pop    %ebx
80105097:	5e                   	pop    %esi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret    
  	cprintf("No existe un proceso con esa PID\n");
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	68 d0 72 10 80       	push   $0x801072d0
801050a2:	e8 33 b5 ff ff       	call   801005da <cprintf>
  	return -1;
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050af:	eb e2                	jmp    80105093 <sys_setprio+0x58>
  	setNewPrio(p, a);
801050b1:	83 ec 08             	sub    $0x8,%esp
801050b4:	56                   	push   %esi
801050b5:	50                   	push   %eax
801050b6:	e8 00 e1 ff ff       	call   801031bb <setNewPrio>
801050bb:	83 c4 10             	add    $0x10,%esp
801050be:	eb cd                	jmp    8010508d <sys_setprio+0x52>
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb cc                	jmp    80105093 <sys_setprio+0x58>
    return -1;
801050c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cc:	eb c5                	jmp    80105093 <sys_setprio+0x58>

801050ce <alltraps>:
801050ce:	1e                   	push   %ds
801050cf:	06                   	push   %es
801050d0:	0f a0                	push   %fs
801050d2:	0f a8                	push   %gs
801050d4:	60                   	pusha  
801050d5:	66 b8 10 00          	mov    $0x10,%ax
801050d9:	8e d8                	mov    %eax,%ds
801050db:	8e c0                	mov    %eax,%es
801050dd:	54                   	push   %esp
801050de:	e8 2f 01 00 00       	call   80105212 <trap>
801050e3:	83 c4 04             	add    $0x4,%esp

801050e6 <trapret>:
801050e6:	61                   	popa   
801050e7:	0f a9                	pop    %gs
801050e9:	0f a1                	pop    %fs
801050eb:	07                   	pop    %es
801050ec:	1f                   	pop    %ds
801050ed:	83 c4 08             	add    $0x8,%esp
801050f0:	cf                   	iret   

801050f1 <tvinit>:
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
tvinit(void)
{
801050f1:	55                   	push   %ebp
801050f2:	89 e5                	mov    %esp,%ebp
801050f4:	53                   	push   %ebx
801050f5:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
801050f8:	b8 00 00 00 00       	mov    $0x0,%eax
801050fd:	eb 72                	jmp    80105171 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801050ff:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80105106:	66 89 0c c5 20 40 11 	mov    %cx,-0x7feebfe0(,%eax,8)
8010510d:	80 
8010510e:	66 c7 04 c5 22 40 11 	movw   $0x8,-0x7feebfde(,%eax,8)
80105115:	80 08 00 
80105118:	8a 14 c5 24 40 11 80 	mov    -0x7feebfdc(,%eax,8),%dl
8010511f:	83 e2 e0             	and    $0xffffffe0,%edx
80105122:	88 14 c5 24 40 11 80 	mov    %dl,-0x7feebfdc(,%eax,8)
80105129:	c6 04 c5 24 40 11 80 	movb   $0x0,-0x7feebfdc(,%eax,8)
80105130:	00 
80105131:	8a 14 c5 25 40 11 80 	mov    -0x7feebfdb(,%eax,8),%dl
80105138:	83 e2 f0             	and    $0xfffffff0,%edx
8010513b:	83 ca 0e             	or     $0xe,%edx
8010513e:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105145:	88 d3                	mov    %dl,%bl
80105147:	83 e3 ef             	and    $0xffffffef,%ebx
8010514a:	88 1c c5 25 40 11 80 	mov    %bl,-0x7feebfdb(,%eax,8)
80105151:	83 e2 8f             	and    $0xffffff8f,%edx
80105154:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
8010515b:	83 ca 80             	or     $0xffffff80,%edx
8010515e:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105165:	c1 e9 10             	shr    $0x10,%ecx
80105168:	66 89 0c c5 26 40 11 	mov    %cx,-0x7feebfda(,%eax,8)
8010516f:	80 
  for(i = 0; i < 256; i++)
80105170:	40                   	inc    %eax
80105171:	3d ff 00 00 00       	cmp    $0xff,%eax
80105176:	7e 87                	jle    801050ff <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105178:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
8010517e:	66 89 15 20 42 11 80 	mov    %dx,0x80114220
80105185:	66 c7 05 22 42 11 80 	movw   $0x8,0x80114222
8010518c:	08 00 
8010518e:	a0 24 42 11 80       	mov    0x80114224,%al
80105193:	83 e0 e0             	and    $0xffffffe0,%eax
80105196:	a2 24 42 11 80       	mov    %al,0x80114224
8010519b:	c6 05 24 42 11 80 00 	movb   $0x0,0x80114224
801051a2:	a0 25 42 11 80       	mov    0x80114225,%al
801051a7:	83 c8 0f             	or     $0xf,%eax
801051aa:	a2 25 42 11 80       	mov    %al,0x80114225
801051af:	83 e0 ef             	and    $0xffffffef,%eax
801051b2:	a2 25 42 11 80       	mov    %al,0x80114225
801051b7:	88 c1                	mov    %al,%cl
801051b9:	83 c9 60             	or     $0x60,%ecx
801051bc:	88 0d 25 42 11 80    	mov    %cl,0x80114225
801051c2:	83 c8 e0             	or     $0xffffffe0,%eax
801051c5:	a2 25 42 11 80       	mov    %al,0x80114225
801051ca:	c1 ea 10             	shr    $0x10,%edx
801051cd:	66 89 15 26 42 11 80 	mov    %dx,0x80114226

  initlock(&tickslock, "time");
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	68 f5 72 10 80       	push   $0x801072f5
801051dc:	68 e0 3f 11 80       	push   $0x80113fe0
801051e1:	e8 2b ea ff ff       	call   80103c11 <initlock>
}
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051ec:	c9                   	leave  
801051ed:	c3                   	ret    

801051ee <idtinit>:

void
idtinit(void)
{
801051ee:	55                   	push   %ebp
801051ef:	89 e5                	mov    %esp,%ebp
801051f1:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801051f4:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801051fa:	b8 20 40 11 80       	mov    $0x80114020,%eax
801051ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105203:	c1 e8 10             	shr    $0x10,%eax
80105206:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010520a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010520d:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105210:	c9                   	leave  
80105211:	c3                   	ret    

80105212 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105212:	55                   	push   %ebp
80105213:	89 e5                	mov    %esp,%ebp
80105215:	57                   	push   %edi
80105216:	56                   	push   %esi
80105217:	53                   	push   %ebx
80105218:	83 ec 1c             	sub    $0x1c,%esp
8010521b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  
  if(tf->trapno == T_SYSCALL){
8010521e:	8b 43 30             	mov    0x30(%ebx),%eax
80105221:	83 f8 40             	cmp    $0x40,%eax
80105224:	74 13                	je     80105239 <trap+0x27>
    if(myproc()->killed)
      exit(0);
    return;
  }

  switch(tf->trapno){
80105226:	83 e8 0e             	sub    $0xe,%eax
80105229:	83 f8 31             	cmp    $0x31,%eax
8010522c:	0f 87 5f 02 00 00    	ja     80105491 <trap+0x27f>
80105232:	ff 24 85 0c 74 10 80 	jmp    *-0x7fef8bf4(,%eax,4)
    if(myproc()->killed)
80105239:	e8 dc e0 ff ff       	call   8010331a <myproc>
8010523e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105242:	75 2b                	jne    8010526f <trap+0x5d>
    myproc()->tf = tf;
80105244:	e8 d1 e0 ff ff       	call   8010331a <myproc>
80105249:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010524c:	e8 99 ee ff ff       	call   801040ea <syscall>
    if(myproc()->killed)
80105251:	e8 c4 e0 ff ff       	call   8010331a <myproc>
80105256:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010525a:	0f 84 8c 00 00 00    	je     801052ec <trap+0xda>
      exit(0);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	6a 00                	push   $0x0
80105265:	e8 9e e4 ff ff       	call   80103708 <exit>
8010526a:	83 c4 10             	add    $0x10,%esp
    return;
8010526d:	eb 7d                	jmp    801052ec <trap+0xda>
      exit(0);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	6a 00                	push   $0x0
80105274:	e8 8f e4 ff ff       	call   80103708 <exit>
80105279:	83 c4 10             	add    $0x10,%esp
8010527c:	eb c6                	jmp    80105244 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010527e:	e8 66 e0 ff ff       	call   801032e9 <cpuid>
80105283:	85 c0                	test   %eax,%eax
80105285:	74 6d                	je     801052f4 <trap+0xe2>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105287:	e8 6d d0 ff ff       	call   801022f9 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010528c:	e8 89 e0 ff ff       	call   8010331a <myproc>
80105291:	85 c0                	test   %eax,%eax
80105293:	74 1b                	je     801052b0 <trap+0x9e>
80105295:	e8 80 e0 ff ff       	call   8010331a <myproc>
8010529a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010529e:	74 10                	je     801052b0 <trap+0x9e>
801052a0:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052a3:	83 e0 03             	and    $0x3,%eax
801052a6:	66 83 f8 03          	cmp    $0x3,%ax
801052aa:	0f 84 74 02 00 00    	je     80105524 <trap+0x312>
    exit(tf->trapno + 0x80);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801052b0:	e8 65 e0 ff ff       	call   8010331a <myproc>
801052b5:	85 c0                	test   %eax,%eax
801052b7:	74 0f                	je     801052c8 <trap+0xb6>
801052b9:	e8 5c e0 ff ff       	call   8010331a <myproc>
801052be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801052c2:	0f 84 73 02 00 00    	je     8010553b <trap+0x329>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052c8:	e8 4d e0 ff ff       	call   8010331a <myproc>
801052cd:	85 c0                	test   %eax,%eax
801052cf:	74 1b                	je     801052ec <trap+0xda>
801052d1:	e8 44 e0 ff ff       	call   8010331a <myproc>
801052d6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052da:	74 10                	je     801052ec <trap+0xda>
801052dc:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052df:	83 e0 03             	and    $0x3,%eax
801052e2:	66 83 f8 03          	cmp    $0x3,%ax
801052e6:	0f 84 63 02 00 00    	je     8010554f <trap+0x33d>
    exit(tf->trapno + 0x80 );
}
801052ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ef:	5b                   	pop    %ebx
801052f0:	5e                   	pop    %esi
801052f1:	5f                   	pop    %edi
801052f2:	5d                   	pop    %ebp
801052f3:	c3                   	ret    
      acquire(&tickslock);
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	68 e0 3f 11 80       	push   $0x80113fe0
801052fc:	e8 47 ea ff ff       	call   80103d48 <acquire>
      ticks++;
80105301:	ff 05 c0 3f 11 80    	incl   0x80113fc0
      wakeup(&ticks);
80105307:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
8010530e:	e8 8f e6 ff ff       	call   801039a2 <wakeup>
      release(&tickslock);
80105313:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010531a:	e8 8e ea ff ff       	call   80103dad <release>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	e9 60 ff ff ff       	jmp    80105287 <trap+0x75>
    ideintr();
80105327:	e8 b6 c9 ff ff       	call   80101ce2 <ideintr>
    lapiceoi();
8010532c:	e8 c8 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105331:	e9 56 ff ff ff       	jmp    8010528c <trap+0x7a>
    kbdintr();
80105336:	e8 08 ce ff ff       	call   80102143 <kbdintr>
    lapiceoi();
8010533b:	e8 b9 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105340:	e9 47 ff ff ff       	jmp    8010528c <trap+0x7a>
    uartintr();
80105345:	e8 18 03 00 00       	call   80105662 <uartintr>
    lapiceoi();
8010534a:	e8 aa cf ff ff       	call   801022f9 <lapiceoi>
    break;
8010534f:	e9 38 ff ff ff       	jmp    8010528c <trap+0x7a>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105354:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105357:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010535a:	e8 8a df ff ff       	call   801032e9 <cpuid>
8010535f:	57                   	push   %edi
80105360:	0f b7 f6             	movzwl %si,%esi
80105363:	56                   	push   %esi
80105364:	50                   	push   %eax
80105365:	68 2c 73 10 80       	push   $0x8010732c
8010536a:	e8 6b b2 ff ff       	call   801005da <cprintf>
    lapiceoi();
8010536f:	e8 85 cf ff ff       	call   801022f9 <lapiceoi>
    break;
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	e9 10 ff ff ff       	jmp    8010528c <trap+0x7a>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010537c:	0f 20 d6             	mov    %cr2,%esi
   uint va = PGROUNDDOWN(rcr2());
8010537f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if(va >= myproc()->sz){
80105385:	e8 90 df ff ff       	call   8010331a <myproc>
8010538a:	39 30                	cmp    %esi,(%eax)
8010538c:	0f 86 9b 00 00 00    	jbe    8010542d <trap+0x21b>
    if((tf->err & 0x7) == 0x7){
80105392:	8b 43 34             	mov    0x34(%ebx),%eax
80105395:	89 c2                	mov    %eax,%edx
80105397:	83 e2 07             	and    $0x7,%edx
8010539a:	83 fa 07             	cmp    $0x7,%edx
8010539d:	0f 84 ab 00 00 00    	je     8010544e <trap+0x23c>
    if(va < myproc()->sz){
801053a3:	e8 72 df ff ff       	call   8010331a <myproc>
801053a8:	39 30                	cmp    %esi,(%eax)
801053aa:	0f 86 dc fe ff ff    	jbe    8010528c <trap+0x7a>
      char *mem = kalloc();
801053b0:	e8 72 cc ff ff       	call   80102027 <kalloc>
801053b5:	89 c6                	mov    %eax,%esi
      if (mem  == 0) { 
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 84 b1 00 00 00    	je     80105470 <trap+0x25e>
      memset(mem, 0, PGSIZE); // set the page to 0
801053bf:	83 ec 04             	sub    $0x4,%esp
801053c2:	68 00 10 00 00       	push   $0x1000
801053c7:	6a 00                	push   $0x0
801053c9:	56                   	push   %esi
801053ca:	e8 25 ea ff ff       	call   80103df4 <memset>
801053cf:	0f 20 d7             	mov    %cr2,%edi
      if(mappages(myproc()->pgdir, (char*) PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) != 0){
801053d2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801053d8:	e8 3d df ff ff       	call   8010331a <myproc>
801053dd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801053e4:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801053ea:	52                   	push   %edx
801053eb:	68 00 10 00 00       	push   $0x1000
801053f0:	57                   	push   %edi
801053f1:	ff 70 04             	push   0x4(%eax)
801053f4:	e8 31 10 00 00       	call   8010642a <mappages>
801053f9:	83 c4 20             	add    $0x20,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	0f 84 88 fe ff ff    	je     8010528c <trap+0x7a>
        cprintf("usertrap(): mappages falló\n");
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	68 0a 73 10 80       	push   $0x8010730a
8010540c:	e8 c9 b1 ff ff       	call   801005da <cprintf>
        kfree(mem);
80105411:	89 34 24             	mov    %esi,(%esp)
80105414:	e8 f7 ca ff ff       	call   80101f10 <kfree>
        myproc()->killed = 1;
80105419:	e8 fc de ff ff       	call   8010331a <myproc>
8010541e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	e9 5f fe ff ff       	jmp    8010528c <trap+0x7a>
      cprintf("usertrap(): va mayor que tamano\n");
8010542d:	83 ec 0c             	sub    $0xc,%esp
80105430:	68 50 73 10 80       	push   $0x80107350
80105435:	e8 a0 b1 ff ff       	call   801005da <cprintf>
      myproc()->killed = 1;
8010543a:	e8 db de ff ff       	call   8010331a <myproc>
8010543f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	e9 44 ff ff ff       	jmp    80105392 <trap+0x180>
    	cprintf("te has paso %d\n", tf->err);
8010544e:	83 ec 08             	sub    $0x8,%esp
80105451:	50                   	push   %eax
80105452:	68 fa 72 10 80       	push   $0x801072fa
80105457:	e8 7e b1 ff ff       	call   801005da <cprintf>
    	myproc()->killed = 1;
8010545c:	e8 b9 de ff ff       	call   8010331a <myproc>
80105461:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	e9 33 ff ff ff       	jmp    801053a3 <trap+0x191>
        cprintf("usertrap(): kalloc ha fallado\n");
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	68 74 73 10 80       	push   $0x80107374
80105478:	e8 5d b1 ff ff       	call   801005da <cprintf>
        myproc()->killed = 1;
8010547d:	e8 98 de ff ff       	call   8010331a <myproc>
80105482:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	e9 2e ff ff ff       	jmp    801053bf <trap+0x1ad>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105491:	e8 84 de ff ff       	call   8010331a <myproc>
80105496:	85 c0                	test   %eax,%eax
80105498:	74 5f                	je     801054f9 <trap+0x2e7>
8010549a:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010549e:	74 59                	je     801054f9 <trap+0x2e7>
801054a0:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054a3:	8b 43 38             	mov    0x38(%ebx),%eax
801054a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054a9:	e8 3b de ff ff       	call   801032e9 <cpuid>
801054ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801054b1:	8b 4b 34             	mov    0x34(%ebx),%ecx
801054b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801054b7:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801054ba:	e8 5b de ff ff       	call   8010331a <myproc>
801054bf:	8d 50 6c             	lea    0x6c(%eax),%edx
801054c2:	89 55 d8             	mov    %edx,-0x28(%ebp)
801054c5:	e8 50 de ff ff       	call   8010331a <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054ca:	57                   	push   %edi
801054cb:	ff 75 e4             	push   -0x1c(%ebp)
801054ce:	ff 75 e0             	push   -0x20(%ebp)
801054d1:	ff 75 dc             	push   -0x24(%ebp)
801054d4:	56                   	push   %esi
801054d5:	ff 75 d8             	push   -0x28(%ebp)
801054d8:	ff 70 10             	push   0x10(%eax)
801054db:	68 c8 73 10 80       	push   $0x801073c8
801054e0:	e8 f5 b0 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
801054e5:	83 c4 20             	add    $0x20,%esp
801054e8:	e8 2d de ff ff       	call   8010331a <myproc>
801054ed:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801054f4:	e9 93 fd ff ff       	jmp    8010528c <trap+0x7a>
801054f9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801054fc:	8b 73 38             	mov    0x38(%ebx),%esi
801054ff:	e8 e5 dd ff ff       	call   801032e9 <cpuid>
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	57                   	push   %edi
80105508:	56                   	push   %esi
80105509:	50                   	push   %eax
8010550a:	ff 73 30             	push   0x30(%ebx)
8010550d:	68 94 73 10 80       	push   $0x80107394
80105512:	e8 c3 b0 ff ff       	call   801005da <cprintf>
      panic("trap");
80105517:	83 c4 14             	add    $0x14,%esp
8010551a:	68 27 73 10 80       	push   $0x80107327
8010551f:	e8 1d ae ff ff       	call   80100341 <panic>
    exit(tf->trapno + 0x80);
80105524:	8b 43 30             	mov    0x30(%ebx),%eax
80105527:	83 e8 80             	sub    $0xffffff80,%eax
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	50                   	push   %eax
8010552e:	e8 d5 e1 ff ff       	call   80103708 <exit>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	e9 75 fd ff ff       	jmp    801052b0 <trap+0x9e>
  if(myproc() && myproc()->state == RUNNING &&
8010553b:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010553f:	0f 85 83 fd ff ff    	jne    801052c8 <trap+0xb6>
    yield();
80105545:	e8 96 e2 ff ff       	call   801037e0 <yield>
8010554a:	e9 79 fd ff ff       	jmp    801052c8 <trap+0xb6>
    exit(tf->trapno + 0x80 );
8010554f:	8b 43 30             	mov    0x30(%ebx),%eax
80105552:	83 e8 80             	sub    $0xffffff80,%eax
80105555:	83 ec 0c             	sub    $0xc,%esp
80105558:	50                   	push   %eax
80105559:	e8 aa e1 ff ff       	call   80103708 <exit>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	e9 86 fd ff ff       	jmp    801052ec <trap+0xda>

80105566 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105566:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
8010556d:	74 14                	je     80105583 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010556f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105574:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105575:	a8 01                	test   $0x1,%al
80105577:	74 10                	je     80105589 <uartgetc+0x23>
80105579:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010557e:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010557f:	0f b6 c0             	movzbl %al,%eax
80105582:	c3                   	ret    
    return -1;
80105583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105588:	c3                   	ret    
    return -1;
80105589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558e:	c3                   	ret    

8010558f <uartputc>:
  if(!uart)
8010558f:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
80105596:	74 39                	je     801055d1 <uartputc+0x42>
{
80105598:	55                   	push   %ebp
80105599:	89 e5                	mov    %esp,%ebp
8010559b:	53                   	push   %ebx
8010559c:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010559f:	bb 00 00 00 00       	mov    $0x0,%ebx
801055a4:	eb 0e                	jmp    801055b4 <uartputc+0x25>
    microdelay(10);
801055a6:	83 ec 0c             	sub    $0xc,%esp
801055a9:	6a 0a                	push   $0xa
801055ab:	e8 6a cd ff ff       	call   8010231a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801055b0:	43                   	inc    %ebx
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	83 fb 7f             	cmp    $0x7f,%ebx
801055b7:	7f 0a                	jg     801055c3 <uartputc+0x34>
801055b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055be:	ec                   	in     (%dx),%al
801055bf:	a8 20                	test   $0x20,%al
801055c1:	74 e3                	je     801055a6 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801055c3:	8b 45 08             	mov    0x8(%ebp),%eax
801055c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055cb:	ee                   	out    %al,(%dx)
}
801055cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055cf:	c9                   	leave  
801055d0:	c3                   	ret    
801055d1:	c3                   	ret    

801055d2 <uartinit>:
{
801055d2:	55                   	push   %ebp
801055d3:	89 e5                	mov    %esp,%ebp
801055d5:	56                   	push   %esi
801055d6:	53                   	push   %ebx
801055d7:	b1 00                	mov    $0x0,%cl
801055d9:	ba fa 03 00 00       	mov    $0x3fa,%edx
801055de:	88 c8                	mov    %cl,%al
801055e0:	ee                   	out    %al,(%dx)
801055e1:	be fb 03 00 00       	mov    $0x3fb,%esi
801055e6:	b0 80                	mov    $0x80,%al
801055e8:	89 f2                	mov    %esi,%edx
801055ea:	ee                   	out    %al,(%dx)
801055eb:	b0 0c                	mov    $0xc,%al
801055ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055f2:	ee                   	out    %al,(%dx)
801055f3:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801055f8:	88 c8                	mov    %cl,%al
801055fa:	89 da                	mov    %ebx,%edx
801055fc:	ee                   	out    %al,(%dx)
801055fd:	b0 03                	mov    $0x3,%al
801055ff:	89 f2                	mov    %esi,%edx
80105601:	ee                   	out    %al,(%dx)
80105602:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105607:	88 c8                	mov    %cl,%al
80105609:	ee                   	out    %al,(%dx)
8010560a:	b0 01                	mov    $0x1,%al
8010560c:	89 da                	mov    %ebx,%edx
8010560e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010560f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105614:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105615:	3c ff                	cmp    $0xff,%al
80105617:	74 42                	je     8010565b <uartinit+0x89>
  uart = 1;
80105619:	c7 05 20 48 11 80 01 	movl   $0x1,0x80114820
80105620:	00 00 00 
80105623:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105628:	ec                   	in     (%dx),%al
80105629:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010562e:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010562f:	83 ec 08             	sub    $0x8,%esp
80105632:	6a 00                	push   $0x0
80105634:	6a 04                	push   $0x4
80105636:	e8 aa c8 ff ff       	call   80101ee5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010563b:	83 c4 10             	add    $0x10,%esp
8010563e:	bb d4 74 10 80       	mov    $0x801074d4,%ebx
80105643:	eb 10                	jmp    80105655 <uartinit+0x83>
    uartputc(*p);
80105645:	83 ec 0c             	sub    $0xc,%esp
80105648:	0f be c0             	movsbl %al,%eax
8010564b:	50                   	push   %eax
8010564c:	e8 3e ff ff ff       	call   8010558f <uartputc>
  for(p="xv6...\n"; *p; p++)
80105651:	43                   	inc    %ebx
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	8a 03                	mov    (%ebx),%al
80105657:	84 c0                	test   %al,%al
80105659:	75 ea                	jne    80105645 <uartinit+0x73>
}
8010565b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010565e:	5b                   	pop    %ebx
8010565f:	5e                   	pop    %esi
80105660:	5d                   	pop    %ebp
80105661:	c3                   	ret    

80105662 <uartintr>:

void
uartintr(void)
{
80105662:	55                   	push   %ebp
80105663:	89 e5                	mov    %esp,%ebp
80105665:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105668:	68 66 55 10 80       	push   $0x80105566
8010566d:	e8 8d b0 ff ff       	call   801006ff <consoleintr>
}
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	c9                   	leave  
80105676:	c3                   	ret    

80105677 <vector0>:
80105677:	6a 00                	push   $0x0
80105679:	6a 00                	push   $0x0
8010567b:	e9 4e fa ff ff       	jmp    801050ce <alltraps>

80105680 <vector1>:
80105680:	6a 00                	push   $0x0
80105682:	6a 01                	push   $0x1
80105684:	e9 45 fa ff ff       	jmp    801050ce <alltraps>

80105689 <vector2>:
80105689:	6a 00                	push   $0x0
8010568b:	6a 02                	push   $0x2
8010568d:	e9 3c fa ff ff       	jmp    801050ce <alltraps>

80105692 <vector3>:
80105692:	6a 00                	push   $0x0
80105694:	6a 03                	push   $0x3
80105696:	e9 33 fa ff ff       	jmp    801050ce <alltraps>

8010569b <vector4>:
8010569b:	6a 00                	push   $0x0
8010569d:	6a 04                	push   $0x4
8010569f:	e9 2a fa ff ff       	jmp    801050ce <alltraps>

801056a4 <vector5>:
801056a4:	6a 00                	push   $0x0
801056a6:	6a 05                	push   $0x5
801056a8:	e9 21 fa ff ff       	jmp    801050ce <alltraps>

801056ad <vector6>:
801056ad:	6a 00                	push   $0x0
801056af:	6a 06                	push   $0x6
801056b1:	e9 18 fa ff ff       	jmp    801050ce <alltraps>

801056b6 <vector7>:
801056b6:	6a 00                	push   $0x0
801056b8:	6a 07                	push   $0x7
801056ba:	e9 0f fa ff ff       	jmp    801050ce <alltraps>

801056bf <vector8>:
801056bf:	6a 08                	push   $0x8
801056c1:	e9 08 fa ff ff       	jmp    801050ce <alltraps>

801056c6 <vector9>:
801056c6:	6a 00                	push   $0x0
801056c8:	6a 09                	push   $0x9
801056ca:	e9 ff f9 ff ff       	jmp    801050ce <alltraps>

801056cf <vector10>:
801056cf:	6a 0a                	push   $0xa
801056d1:	e9 f8 f9 ff ff       	jmp    801050ce <alltraps>

801056d6 <vector11>:
801056d6:	6a 0b                	push   $0xb
801056d8:	e9 f1 f9 ff ff       	jmp    801050ce <alltraps>

801056dd <vector12>:
801056dd:	6a 0c                	push   $0xc
801056df:	e9 ea f9 ff ff       	jmp    801050ce <alltraps>

801056e4 <vector13>:
801056e4:	6a 0d                	push   $0xd
801056e6:	e9 e3 f9 ff ff       	jmp    801050ce <alltraps>

801056eb <vector14>:
801056eb:	6a 0e                	push   $0xe
801056ed:	e9 dc f9 ff ff       	jmp    801050ce <alltraps>

801056f2 <vector15>:
801056f2:	6a 00                	push   $0x0
801056f4:	6a 0f                	push   $0xf
801056f6:	e9 d3 f9 ff ff       	jmp    801050ce <alltraps>

801056fb <vector16>:
801056fb:	6a 00                	push   $0x0
801056fd:	6a 10                	push   $0x10
801056ff:	e9 ca f9 ff ff       	jmp    801050ce <alltraps>

80105704 <vector17>:
80105704:	6a 11                	push   $0x11
80105706:	e9 c3 f9 ff ff       	jmp    801050ce <alltraps>

8010570b <vector18>:
8010570b:	6a 00                	push   $0x0
8010570d:	6a 12                	push   $0x12
8010570f:	e9 ba f9 ff ff       	jmp    801050ce <alltraps>

80105714 <vector19>:
80105714:	6a 00                	push   $0x0
80105716:	6a 13                	push   $0x13
80105718:	e9 b1 f9 ff ff       	jmp    801050ce <alltraps>

8010571d <vector20>:
8010571d:	6a 00                	push   $0x0
8010571f:	6a 14                	push   $0x14
80105721:	e9 a8 f9 ff ff       	jmp    801050ce <alltraps>

80105726 <vector21>:
80105726:	6a 00                	push   $0x0
80105728:	6a 15                	push   $0x15
8010572a:	e9 9f f9 ff ff       	jmp    801050ce <alltraps>

8010572f <vector22>:
8010572f:	6a 00                	push   $0x0
80105731:	6a 16                	push   $0x16
80105733:	e9 96 f9 ff ff       	jmp    801050ce <alltraps>

80105738 <vector23>:
80105738:	6a 00                	push   $0x0
8010573a:	6a 17                	push   $0x17
8010573c:	e9 8d f9 ff ff       	jmp    801050ce <alltraps>

80105741 <vector24>:
80105741:	6a 00                	push   $0x0
80105743:	6a 18                	push   $0x18
80105745:	e9 84 f9 ff ff       	jmp    801050ce <alltraps>

8010574a <vector25>:
8010574a:	6a 00                	push   $0x0
8010574c:	6a 19                	push   $0x19
8010574e:	e9 7b f9 ff ff       	jmp    801050ce <alltraps>

80105753 <vector26>:
80105753:	6a 00                	push   $0x0
80105755:	6a 1a                	push   $0x1a
80105757:	e9 72 f9 ff ff       	jmp    801050ce <alltraps>

8010575c <vector27>:
8010575c:	6a 00                	push   $0x0
8010575e:	6a 1b                	push   $0x1b
80105760:	e9 69 f9 ff ff       	jmp    801050ce <alltraps>

80105765 <vector28>:
80105765:	6a 00                	push   $0x0
80105767:	6a 1c                	push   $0x1c
80105769:	e9 60 f9 ff ff       	jmp    801050ce <alltraps>

8010576e <vector29>:
8010576e:	6a 00                	push   $0x0
80105770:	6a 1d                	push   $0x1d
80105772:	e9 57 f9 ff ff       	jmp    801050ce <alltraps>

80105777 <vector30>:
80105777:	6a 00                	push   $0x0
80105779:	6a 1e                	push   $0x1e
8010577b:	e9 4e f9 ff ff       	jmp    801050ce <alltraps>

80105780 <vector31>:
80105780:	6a 00                	push   $0x0
80105782:	6a 1f                	push   $0x1f
80105784:	e9 45 f9 ff ff       	jmp    801050ce <alltraps>

80105789 <vector32>:
80105789:	6a 00                	push   $0x0
8010578b:	6a 20                	push   $0x20
8010578d:	e9 3c f9 ff ff       	jmp    801050ce <alltraps>

80105792 <vector33>:
80105792:	6a 00                	push   $0x0
80105794:	6a 21                	push   $0x21
80105796:	e9 33 f9 ff ff       	jmp    801050ce <alltraps>

8010579b <vector34>:
8010579b:	6a 00                	push   $0x0
8010579d:	6a 22                	push   $0x22
8010579f:	e9 2a f9 ff ff       	jmp    801050ce <alltraps>

801057a4 <vector35>:
801057a4:	6a 00                	push   $0x0
801057a6:	6a 23                	push   $0x23
801057a8:	e9 21 f9 ff ff       	jmp    801050ce <alltraps>

801057ad <vector36>:
801057ad:	6a 00                	push   $0x0
801057af:	6a 24                	push   $0x24
801057b1:	e9 18 f9 ff ff       	jmp    801050ce <alltraps>

801057b6 <vector37>:
801057b6:	6a 00                	push   $0x0
801057b8:	6a 25                	push   $0x25
801057ba:	e9 0f f9 ff ff       	jmp    801050ce <alltraps>

801057bf <vector38>:
801057bf:	6a 00                	push   $0x0
801057c1:	6a 26                	push   $0x26
801057c3:	e9 06 f9 ff ff       	jmp    801050ce <alltraps>

801057c8 <vector39>:
801057c8:	6a 00                	push   $0x0
801057ca:	6a 27                	push   $0x27
801057cc:	e9 fd f8 ff ff       	jmp    801050ce <alltraps>

801057d1 <vector40>:
801057d1:	6a 00                	push   $0x0
801057d3:	6a 28                	push   $0x28
801057d5:	e9 f4 f8 ff ff       	jmp    801050ce <alltraps>

801057da <vector41>:
801057da:	6a 00                	push   $0x0
801057dc:	6a 29                	push   $0x29
801057de:	e9 eb f8 ff ff       	jmp    801050ce <alltraps>

801057e3 <vector42>:
801057e3:	6a 00                	push   $0x0
801057e5:	6a 2a                	push   $0x2a
801057e7:	e9 e2 f8 ff ff       	jmp    801050ce <alltraps>

801057ec <vector43>:
801057ec:	6a 00                	push   $0x0
801057ee:	6a 2b                	push   $0x2b
801057f0:	e9 d9 f8 ff ff       	jmp    801050ce <alltraps>

801057f5 <vector44>:
801057f5:	6a 00                	push   $0x0
801057f7:	6a 2c                	push   $0x2c
801057f9:	e9 d0 f8 ff ff       	jmp    801050ce <alltraps>

801057fe <vector45>:
801057fe:	6a 00                	push   $0x0
80105800:	6a 2d                	push   $0x2d
80105802:	e9 c7 f8 ff ff       	jmp    801050ce <alltraps>

80105807 <vector46>:
80105807:	6a 00                	push   $0x0
80105809:	6a 2e                	push   $0x2e
8010580b:	e9 be f8 ff ff       	jmp    801050ce <alltraps>

80105810 <vector47>:
80105810:	6a 00                	push   $0x0
80105812:	6a 2f                	push   $0x2f
80105814:	e9 b5 f8 ff ff       	jmp    801050ce <alltraps>

80105819 <vector48>:
80105819:	6a 00                	push   $0x0
8010581b:	6a 30                	push   $0x30
8010581d:	e9 ac f8 ff ff       	jmp    801050ce <alltraps>

80105822 <vector49>:
80105822:	6a 00                	push   $0x0
80105824:	6a 31                	push   $0x31
80105826:	e9 a3 f8 ff ff       	jmp    801050ce <alltraps>

8010582b <vector50>:
8010582b:	6a 00                	push   $0x0
8010582d:	6a 32                	push   $0x32
8010582f:	e9 9a f8 ff ff       	jmp    801050ce <alltraps>

80105834 <vector51>:
80105834:	6a 00                	push   $0x0
80105836:	6a 33                	push   $0x33
80105838:	e9 91 f8 ff ff       	jmp    801050ce <alltraps>

8010583d <vector52>:
8010583d:	6a 00                	push   $0x0
8010583f:	6a 34                	push   $0x34
80105841:	e9 88 f8 ff ff       	jmp    801050ce <alltraps>

80105846 <vector53>:
80105846:	6a 00                	push   $0x0
80105848:	6a 35                	push   $0x35
8010584a:	e9 7f f8 ff ff       	jmp    801050ce <alltraps>

8010584f <vector54>:
8010584f:	6a 00                	push   $0x0
80105851:	6a 36                	push   $0x36
80105853:	e9 76 f8 ff ff       	jmp    801050ce <alltraps>

80105858 <vector55>:
80105858:	6a 00                	push   $0x0
8010585a:	6a 37                	push   $0x37
8010585c:	e9 6d f8 ff ff       	jmp    801050ce <alltraps>

80105861 <vector56>:
80105861:	6a 00                	push   $0x0
80105863:	6a 38                	push   $0x38
80105865:	e9 64 f8 ff ff       	jmp    801050ce <alltraps>

8010586a <vector57>:
8010586a:	6a 00                	push   $0x0
8010586c:	6a 39                	push   $0x39
8010586e:	e9 5b f8 ff ff       	jmp    801050ce <alltraps>

80105873 <vector58>:
80105873:	6a 00                	push   $0x0
80105875:	6a 3a                	push   $0x3a
80105877:	e9 52 f8 ff ff       	jmp    801050ce <alltraps>

8010587c <vector59>:
8010587c:	6a 00                	push   $0x0
8010587e:	6a 3b                	push   $0x3b
80105880:	e9 49 f8 ff ff       	jmp    801050ce <alltraps>

80105885 <vector60>:
80105885:	6a 00                	push   $0x0
80105887:	6a 3c                	push   $0x3c
80105889:	e9 40 f8 ff ff       	jmp    801050ce <alltraps>

8010588e <vector61>:
8010588e:	6a 00                	push   $0x0
80105890:	6a 3d                	push   $0x3d
80105892:	e9 37 f8 ff ff       	jmp    801050ce <alltraps>

80105897 <vector62>:
80105897:	6a 00                	push   $0x0
80105899:	6a 3e                	push   $0x3e
8010589b:	e9 2e f8 ff ff       	jmp    801050ce <alltraps>

801058a0 <vector63>:
801058a0:	6a 00                	push   $0x0
801058a2:	6a 3f                	push   $0x3f
801058a4:	e9 25 f8 ff ff       	jmp    801050ce <alltraps>

801058a9 <vector64>:
801058a9:	6a 00                	push   $0x0
801058ab:	6a 40                	push   $0x40
801058ad:	e9 1c f8 ff ff       	jmp    801050ce <alltraps>

801058b2 <vector65>:
801058b2:	6a 00                	push   $0x0
801058b4:	6a 41                	push   $0x41
801058b6:	e9 13 f8 ff ff       	jmp    801050ce <alltraps>

801058bb <vector66>:
801058bb:	6a 00                	push   $0x0
801058bd:	6a 42                	push   $0x42
801058bf:	e9 0a f8 ff ff       	jmp    801050ce <alltraps>

801058c4 <vector67>:
801058c4:	6a 00                	push   $0x0
801058c6:	6a 43                	push   $0x43
801058c8:	e9 01 f8 ff ff       	jmp    801050ce <alltraps>

801058cd <vector68>:
801058cd:	6a 00                	push   $0x0
801058cf:	6a 44                	push   $0x44
801058d1:	e9 f8 f7 ff ff       	jmp    801050ce <alltraps>

801058d6 <vector69>:
801058d6:	6a 00                	push   $0x0
801058d8:	6a 45                	push   $0x45
801058da:	e9 ef f7 ff ff       	jmp    801050ce <alltraps>

801058df <vector70>:
801058df:	6a 00                	push   $0x0
801058e1:	6a 46                	push   $0x46
801058e3:	e9 e6 f7 ff ff       	jmp    801050ce <alltraps>

801058e8 <vector71>:
801058e8:	6a 00                	push   $0x0
801058ea:	6a 47                	push   $0x47
801058ec:	e9 dd f7 ff ff       	jmp    801050ce <alltraps>

801058f1 <vector72>:
801058f1:	6a 00                	push   $0x0
801058f3:	6a 48                	push   $0x48
801058f5:	e9 d4 f7 ff ff       	jmp    801050ce <alltraps>

801058fa <vector73>:
801058fa:	6a 00                	push   $0x0
801058fc:	6a 49                	push   $0x49
801058fe:	e9 cb f7 ff ff       	jmp    801050ce <alltraps>

80105903 <vector74>:
80105903:	6a 00                	push   $0x0
80105905:	6a 4a                	push   $0x4a
80105907:	e9 c2 f7 ff ff       	jmp    801050ce <alltraps>

8010590c <vector75>:
8010590c:	6a 00                	push   $0x0
8010590e:	6a 4b                	push   $0x4b
80105910:	e9 b9 f7 ff ff       	jmp    801050ce <alltraps>

80105915 <vector76>:
80105915:	6a 00                	push   $0x0
80105917:	6a 4c                	push   $0x4c
80105919:	e9 b0 f7 ff ff       	jmp    801050ce <alltraps>

8010591e <vector77>:
8010591e:	6a 00                	push   $0x0
80105920:	6a 4d                	push   $0x4d
80105922:	e9 a7 f7 ff ff       	jmp    801050ce <alltraps>

80105927 <vector78>:
80105927:	6a 00                	push   $0x0
80105929:	6a 4e                	push   $0x4e
8010592b:	e9 9e f7 ff ff       	jmp    801050ce <alltraps>

80105930 <vector79>:
80105930:	6a 00                	push   $0x0
80105932:	6a 4f                	push   $0x4f
80105934:	e9 95 f7 ff ff       	jmp    801050ce <alltraps>

80105939 <vector80>:
80105939:	6a 00                	push   $0x0
8010593b:	6a 50                	push   $0x50
8010593d:	e9 8c f7 ff ff       	jmp    801050ce <alltraps>

80105942 <vector81>:
80105942:	6a 00                	push   $0x0
80105944:	6a 51                	push   $0x51
80105946:	e9 83 f7 ff ff       	jmp    801050ce <alltraps>

8010594b <vector82>:
8010594b:	6a 00                	push   $0x0
8010594d:	6a 52                	push   $0x52
8010594f:	e9 7a f7 ff ff       	jmp    801050ce <alltraps>

80105954 <vector83>:
80105954:	6a 00                	push   $0x0
80105956:	6a 53                	push   $0x53
80105958:	e9 71 f7 ff ff       	jmp    801050ce <alltraps>

8010595d <vector84>:
8010595d:	6a 00                	push   $0x0
8010595f:	6a 54                	push   $0x54
80105961:	e9 68 f7 ff ff       	jmp    801050ce <alltraps>

80105966 <vector85>:
80105966:	6a 00                	push   $0x0
80105968:	6a 55                	push   $0x55
8010596a:	e9 5f f7 ff ff       	jmp    801050ce <alltraps>

8010596f <vector86>:
8010596f:	6a 00                	push   $0x0
80105971:	6a 56                	push   $0x56
80105973:	e9 56 f7 ff ff       	jmp    801050ce <alltraps>

80105978 <vector87>:
80105978:	6a 00                	push   $0x0
8010597a:	6a 57                	push   $0x57
8010597c:	e9 4d f7 ff ff       	jmp    801050ce <alltraps>

80105981 <vector88>:
80105981:	6a 00                	push   $0x0
80105983:	6a 58                	push   $0x58
80105985:	e9 44 f7 ff ff       	jmp    801050ce <alltraps>

8010598a <vector89>:
8010598a:	6a 00                	push   $0x0
8010598c:	6a 59                	push   $0x59
8010598e:	e9 3b f7 ff ff       	jmp    801050ce <alltraps>

80105993 <vector90>:
80105993:	6a 00                	push   $0x0
80105995:	6a 5a                	push   $0x5a
80105997:	e9 32 f7 ff ff       	jmp    801050ce <alltraps>

8010599c <vector91>:
8010599c:	6a 00                	push   $0x0
8010599e:	6a 5b                	push   $0x5b
801059a0:	e9 29 f7 ff ff       	jmp    801050ce <alltraps>

801059a5 <vector92>:
801059a5:	6a 00                	push   $0x0
801059a7:	6a 5c                	push   $0x5c
801059a9:	e9 20 f7 ff ff       	jmp    801050ce <alltraps>

801059ae <vector93>:
801059ae:	6a 00                	push   $0x0
801059b0:	6a 5d                	push   $0x5d
801059b2:	e9 17 f7 ff ff       	jmp    801050ce <alltraps>

801059b7 <vector94>:
801059b7:	6a 00                	push   $0x0
801059b9:	6a 5e                	push   $0x5e
801059bb:	e9 0e f7 ff ff       	jmp    801050ce <alltraps>

801059c0 <vector95>:
801059c0:	6a 00                	push   $0x0
801059c2:	6a 5f                	push   $0x5f
801059c4:	e9 05 f7 ff ff       	jmp    801050ce <alltraps>

801059c9 <vector96>:
801059c9:	6a 00                	push   $0x0
801059cb:	6a 60                	push   $0x60
801059cd:	e9 fc f6 ff ff       	jmp    801050ce <alltraps>

801059d2 <vector97>:
801059d2:	6a 00                	push   $0x0
801059d4:	6a 61                	push   $0x61
801059d6:	e9 f3 f6 ff ff       	jmp    801050ce <alltraps>

801059db <vector98>:
801059db:	6a 00                	push   $0x0
801059dd:	6a 62                	push   $0x62
801059df:	e9 ea f6 ff ff       	jmp    801050ce <alltraps>

801059e4 <vector99>:
801059e4:	6a 00                	push   $0x0
801059e6:	6a 63                	push   $0x63
801059e8:	e9 e1 f6 ff ff       	jmp    801050ce <alltraps>

801059ed <vector100>:
801059ed:	6a 00                	push   $0x0
801059ef:	6a 64                	push   $0x64
801059f1:	e9 d8 f6 ff ff       	jmp    801050ce <alltraps>

801059f6 <vector101>:
801059f6:	6a 00                	push   $0x0
801059f8:	6a 65                	push   $0x65
801059fa:	e9 cf f6 ff ff       	jmp    801050ce <alltraps>

801059ff <vector102>:
801059ff:	6a 00                	push   $0x0
80105a01:	6a 66                	push   $0x66
80105a03:	e9 c6 f6 ff ff       	jmp    801050ce <alltraps>

80105a08 <vector103>:
80105a08:	6a 00                	push   $0x0
80105a0a:	6a 67                	push   $0x67
80105a0c:	e9 bd f6 ff ff       	jmp    801050ce <alltraps>

80105a11 <vector104>:
80105a11:	6a 00                	push   $0x0
80105a13:	6a 68                	push   $0x68
80105a15:	e9 b4 f6 ff ff       	jmp    801050ce <alltraps>

80105a1a <vector105>:
80105a1a:	6a 00                	push   $0x0
80105a1c:	6a 69                	push   $0x69
80105a1e:	e9 ab f6 ff ff       	jmp    801050ce <alltraps>

80105a23 <vector106>:
80105a23:	6a 00                	push   $0x0
80105a25:	6a 6a                	push   $0x6a
80105a27:	e9 a2 f6 ff ff       	jmp    801050ce <alltraps>

80105a2c <vector107>:
80105a2c:	6a 00                	push   $0x0
80105a2e:	6a 6b                	push   $0x6b
80105a30:	e9 99 f6 ff ff       	jmp    801050ce <alltraps>

80105a35 <vector108>:
80105a35:	6a 00                	push   $0x0
80105a37:	6a 6c                	push   $0x6c
80105a39:	e9 90 f6 ff ff       	jmp    801050ce <alltraps>

80105a3e <vector109>:
80105a3e:	6a 00                	push   $0x0
80105a40:	6a 6d                	push   $0x6d
80105a42:	e9 87 f6 ff ff       	jmp    801050ce <alltraps>

80105a47 <vector110>:
80105a47:	6a 00                	push   $0x0
80105a49:	6a 6e                	push   $0x6e
80105a4b:	e9 7e f6 ff ff       	jmp    801050ce <alltraps>

80105a50 <vector111>:
80105a50:	6a 00                	push   $0x0
80105a52:	6a 6f                	push   $0x6f
80105a54:	e9 75 f6 ff ff       	jmp    801050ce <alltraps>

80105a59 <vector112>:
80105a59:	6a 00                	push   $0x0
80105a5b:	6a 70                	push   $0x70
80105a5d:	e9 6c f6 ff ff       	jmp    801050ce <alltraps>

80105a62 <vector113>:
80105a62:	6a 00                	push   $0x0
80105a64:	6a 71                	push   $0x71
80105a66:	e9 63 f6 ff ff       	jmp    801050ce <alltraps>

80105a6b <vector114>:
80105a6b:	6a 00                	push   $0x0
80105a6d:	6a 72                	push   $0x72
80105a6f:	e9 5a f6 ff ff       	jmp    801050ce <alltraps>

80105a74 <vector115>:
80105a74:	6a 00                	push   $0x0
80105a76:	6a 73                	push   $0x73
80105a78:	e9 51 f6 ff ff       	jmp    801050ce <alltraps>

80105a7d <vector116>:
80105a7d:	6a 00                	push   $0x0
80105a7f:	6a 74                	push   $0x74
80105a81:	e9 48 f6 ff ff       	jmp    801050ce <alltraps>

80105a86 <vector117>:
80105a86:	6a 00                	push   $0x0
80105a88:	6a 75                	push   $0x75
80105a8a:	e9 3f f6 ff ff       	jmp    801050ce <alltraps>

80105a8f <vector118>:
80105a8f:	6a 00                	push   $0x0
80105a91:	6a 76                	push   $0x76
80105a93:	e9 36 f6 ff ff       	jmp    801050ce <alltraps>

80105a98 <vector119>:
80105a98:	6a 00                	push   $0x0
80105a9a:	6a 77                	push   $0x77
80105a9c:	e9 2d f6 ff ff       	jmp    801050ce <alltraps>

80105aa1 <vector120>:
80105aa1:	6a 00                	push   $0x0
80105aa3:	6a 78                	push   $0x78
80105aa5:	e9 24 f6 ff ff       	jmp    801050ce <alltraps>

80105aaa <vector121>:
80105aaa:	6a 00                	push   $0x0
80105aac:	6a 79                	push   $0x79
80105aae:	e9 1b f6 ff ff       	jmp    801050ce <alltraps>

80105ab3 <vector122>:
80105ab3:	6a 00                	push   $0x0
80105ab5:	6a 7a                	push   $0x7a
80105ab7:	e9 12 f6 ff ff       	jmp    801050ce <alltraps>

80105abc <vector123>:
80105abc:	6a 00                	push   $0x0
80105abe:	6a 7b                	push   $0x7b
80105ac0:	e9 09 f6 ff ff       	jmp    801050ce <alltraps>

80105ac5 <vector124>:
80105ac5:	6a 00                	push   $0x0
80105ac7:	6a 7c                	push   $0x7c
80105ac9:	e9 00 f6 ff ff       	jmp    801050ce <alltraps>

80105ace <vector125>:
80105ace:	6a 00                	push   $0x0
80105ad0:	6a 7d                	push   $0x7d
80105ad2:	e9 f7 f5 ff ff       	jmp    801050ce <alltraps>

80105ad7 <vector126>:
80105ad7:	6a 00                	push   $0x0
80105ad9:	6a 7e                	push   $0x7e
80105adb:	e9 ee f5 ff ff       	jmp    801050ce <alltraps>

80105ae0 <vector127>:
80105ae0:	6a 00                	push   $0x0
80105ae2:	6a 7f                	push   $0x7f
80105ae4:	e9 e5 f5 ff ff       	jmp    801050ce <alltraps>

80105ae9 <vector128>:
80105ae9:	6a 00                	push   $0x0
80105aeb:	68 80 00 00 00       	push   $0x80
80105af0:	e9 d9 f5 ff ff       	jmp    801050ce <alltraps>

80105af5 <vector129>:
80105af5:	6a 00                	push   $0x0
80105af7:	68 81 00 00 00       	push   $0x81
80105afc:	e9 cd f5 ff ff       	jmp    801050ce <alltraps>

80105b01 <vector130>:
80105b01:	6a 00                	push   $0x0
80105b03:	68 82 00 00 00       	push   $0x82
80105b08:	e9 c1 f5 ff ff       	jmp    801050ce <alltraps>

80105b0d <vector131>:
80105b0d:	6a 00                	push   $0x0
80105b0f:	68 83 00 00 00       	push   $0x83
80105b14:	e9 b5 f5 ff ff       	jmp    801050ce <alltraps>

80105b19 <vector132>:
80105b19:	6a 00                	push   $0x0
80105b1b:	68 84 00 00 00       	push   $0x84
80105b20:	e9 a9 f5 ff ff       	jmp    801050ce <alltraps>

80105b25 <vector133>:
80105b25:	6a 00                	push   $0x0
80105b27:	68 85 00 00 00       	push   $0x85
80105b2c:	e9 9d f5 ff ff       	jmp    801050ce <alltraps>

80105b31 <vector134>:
80105b31:	6a 00                	push   $0x0
80105b33:	68 86 00 00 00       	push   $0x86
80105b38:	e9 91 f5 ff ff       	jmp    801050ce <alltraps>

80105b3d <vector135>:
80105b3d:	6a 00                	push   $0x0
80105b3f:	68 87 00 00 00       	push   $0x87
80105b44:	e9 85 f5 ff ff       	jmp    801050ce <alltraps>

80105b49 <vector136>:
80105b49:	6a 00                	push   $0x0
80105b4b:	68 88 00 00 00       	push   $0x88
80105b50:	e9 79 f5 ff ff       	jmp    801050ce <alltraps>

80105b55 <vector137>:
80105b55:	6a 00                	push   $0x0
80105b57:	68 89 00 00 00       	push   $0x89
80105b5c:	e9 6d f5 ff ff       	jmp    801050ce <alltraps>

80105b61 <vector138>:
80105b61:	6a 00                	push   $0x0
80105b63:	68 8a 00 00 00       	push   $0x8a
80105b68:	e9 61 f5 ff ff       	jmp    801050ce <alltraps>

80105b6d <vector139>:
80105b6d:	6a 00                	push   $0x0
80105b6f:	68 8b 00 00 00       	push   $0x8b
80105b74:	e9 55 f5 ff ff       	jmp    801050ce <alltraps>

80105b79 <vector140>:
80105b79:	6a 00                	push   $0x0
80105b7b:	68 8c 00 00 00       	push   $0x8c
80105b80:	e9 49 f5 ff ff       	jmp    801050ce <alltraps>

80105b85 <vector141>:
80105b85:	6a 00                	push   $0x0
80105b87:	68 8d 00 00 00       	push   $0x8d
80105b8c:	e9 3d f5 ff ff       	jmp    801050ce <alltraps>

80105b91 <vector142>:
80105b91:	6a 00                	push   $0x0
80105b93:	68 8e 00 00 00       	push   $0x8e
80105b98:	e9 31 f5 ff ff       	jmp    801050ce <alltraps>

80105b9d <vector143>:
80105b9d:	6a 00                	push   $0x0
80105b9f:	68 8f 00 00 00       	push   $0x8f
80105ba4:	e9 25 f5 ff ff       	jmp    801050ce <alltraps>

80105ba9 <vector144>:
80105ba9:	6a 00                	push   $0x0
80105bab:	68 90 00 00 00       	push   $0x90
80105bb0:	e9 19 f5 ff ff       	jmp    801050ce <alltraps>

80105bb5 <vector145>:
80105bb5:	6a 00                	push   $0x0
80105bb7:	68 91 00 00 00       	push   $0x91
80105bbc:	e9 0d f5 ff ff       	jmp    801050ce <alltraps>

80105bc1 <vector146>:
80105bc1:	6a 00                	push   $0x0
80105bc3:	68 92 00 00 00       	push   $0x92
80105bc8:	e9 01 f5 ff ff       	jmp    801050ce <alltraps>

80105bcd <vector147>:
80105bcd:	6a 00                	push   $0x0
80105bcf:	68 93 00 00 00       	push   $0x93
80105bd4:	e9 f5 f4 ff ff       	jmp    801050ce <alltraps>

80105bd9 <vector148>:
80105bd9:	6a 00                	push   $0x0
80105bdb:	68 94 00 00 00       	push   $0x94
80105be0:	e9 e9 f4 ff ff       	jmp    801050ce <alltraps>

80105be5 <vector149>:
80105be5:	6a 00                	push   $0x0
80105be7:	68 95 00 00 00       	push   $0x95
80105bec:	e9 dd f4 ff ff       	jmp    801050ce <alltraps>

80105bf1 <vector150>:
80105bf1:	6a 00                	push   $0x0
80105bf3:	68 96 00 00 00       	push   $0x96
80105bf8:	e9 d1 f4 ff ff       	jmp    801050ce <alltraps>

80105bfd <vector151>:
80105bfd:	6a 00                	push   $0x0
80105bff:	68 97 00 00 00       	push   $0x97
80105c04:	e9 c5 f4 ff ff       	jmp    801050ce <alltraps>

80105c09 <vector152>:
80105c09:	6a 00                	push   $0x0
80105c0b:	68 98 00 00 00       	push   $0x98
80105c10:	e9 b9 f4 ff ff       	jmp    801050ce <alltraps>

80105c15 <vector153>:
80105c15:	6a 00                	push   $0x0
80105c17:	68 99 00 00 00       	push   $0x99
80105c1c:	e9 ad f4 ff ff       	jmp    801050ce <alltraps>

80105c21 <vector154>:
80105c21:	6a 00                	push   $0x0
80105c23:	68 9a 00 00 00       	push   $0x9a
80105c28:	e9 a1 f4 ff ff       	jmp    801050ce <alltraps>

80105c2d <vector155>:
80105c2d:	6a 00                	push   $0x0
80105c2f:	68 9b 00 00 00       	push   $0x9b
80105c34:	e9 95 f4 ff ff       	jmp    801050ce <alltraps>

80105c39 <vector156>:
80105c39:	6a 00                	push   $0x0
80105c3b:	68 9c 00 00 00       	push   $0x9c
80105c40:	e9 89 f4 ff ff       	jmp    801050ce <alltraps>

80105c45 <vector157>:
80105c45:	6a 00                	push   $0x0
80105c47:	68 9d 00 00 00       	push   $0x9d
80105c4c:	e9 7d f4 ff ff       	jmp    801050ce <alltraps>

80105c51 <vector158>:
80105c51:	6a 00                	push   $0x0
80105c53:	68 9e 00 00 00       	push   $0x9e
80105c58:	e9 71 f4 ff ff       	jmp    801050ce <alltraps>

80105c5d <vector159>:
80105c5d:	6a 00                	push   $0x0
80105c5f:	68 9f 00 00 00       	push   $0x9f
80105c64:	e9 65 f4 ff ff       	jmp    801050ce <alltraps>

80105c69 <vector160>:
80105c69:	6a 00                	push   $0x0
80105c6b:	68 a0 00 00 00       	push   $0xa0
80105c70:	e9 59 f4 ff ff       	jmp    801050ce <alltraps>

80105c75 <vector161>:
80105c75:	6a 00                	push   $0x0
80105c77:	68 a1 00 00 00       	push   $0xa1
80105c7c:	e9 4d f4 ff ff       	jmp    801050ce <alltraps>

80105c81 <vector162>:
80105c81:	6a 00                	push   $0x0
80105c83:	68 a2 00 00 00       	push   $0xa2
80105c88:	e9 41 f4 ff ff       	jmp    801050ce <alltraps>

80105c8d <vector163>:
80105c8d:	6a 00                	push   $0x0
80105c8f:	68 a3 00 00 00       	push   $0xa3
80105c94:	e9 35 f4 ff ff       	jmp    801050ce <alltraps>

80105c99 <vector164>:
80105c99:	6a 00                	push   $0x0
80105c9b:	68 a4 00 00 00       	push   $0xa4
80105ca0:	e9 29 f4 ff ff       	jmp    801050ce <alltraps>

80105ca5 <vector165>:
80105ca5:	6a 00                	push   $0x0
80105ca7:	68 a5 00 00 00       	push   $0xa5
80105cac:	e9 1d f4 ff ff       	jmp    801050ce <alltraps>

80105cb1 <vector166>:
80105cb1:	6a 00                	push   $0x0
80105cb3:	68 a6 00 00 00       	push   $0xa6
80105cb8:	e9 11 f4 ff ff       	jmp    801050ce <alltraps>

80105cbd <vector167>:
80105cbd:	6a 00                	push   $0x0
80105cbf:	68 a7 00 00 00       	push   $0xa7
80105cc4:	e9 05 f4 ff ff       	jmp    801050ce <alltraps>

80105cc9 <vector168>:
80105cc9:	6a 00                	push   $0x0
80105ccb:	68 a8 00 00 00       	push   $0xa8
80105cd0:	e9 f9 f3 ff ff       	jmp    801050ce <alltraps>

80105cd5 <vector169>:
80105cd5:	6a 00                	push   $0x0
80105cd7:	68 a9 00 00 00       	push   $0xa9
80105cdc:	e9 ed f3 ff ff       	jmp    801050ce <alltraps>

80105ce1 <vector170>:
80105ce1:	6a 00                	push   $0x0
80105ce3:	68 aa 00 00 00       	push   $0xaa
80105ce8:	e9 e1 f3 ff ff       	jmp    801050ce <alltraps>

80105ced <vector171>:
80105ced:	6a 00                	push   $0x0
80105cef:	68 ab 00 00 00       	push   $0xab
80105cf4:	e9 d5 f3 ff ff       	jmp    801050ce <alltraps>

80105cf9 <vector172>:
80105cf9:	6a 00                	push   $0x0
80105cfb:	68 ac 00 00 00       	push   $0xac
80105d00:	e9 c9 f3 ff ff       	jmp    801050ce <alltraps>

80105d05 <vector173>:
80105d05:	6a 00                	push   $0x0
80105d07:	68 ad 00 00 00       	push   $0xad
80105d0c:	e9 bd f3 ff ff       	jmp    801050ce <alltraps>

80105d11 <vector174>:
80105d11:	6a 00                	push   $0x0
80105d13:	68 ae 00 00 00       	push   $0xae
80105d18:	e9 b1 f3 ff ff       	jmp    801050ce <alltraps>

80105d1d <vector175>:
80105d1d:	6a 00                	push   $0x0
80105d1f:	68 af 00 00 00       	push   $0xaf
80105d24:	e9 a5 f3 ff ff       	jmp    801050ce <alltraps>

80105d29 <vector176>:
80105d29:	6a 00                	push   $0x0
80105d2b:	68 b0 00 00 00       	push   $0xb0
80105d30:	e9 99 f3 ff ff       	jmp    801050ce <alltraps>

80105d35 <vector177>:
80105d35:	6a 00                	push   $0x0
80105d37:	68 b1 00 00 00       	push   $0xb1
80105d3c:	e9 8d f3 ff ff       	jmp    801050ce <alltraps>

80105d41 <vector178>:
80105d41:	6a 00                	push   $0x0
80105d43:	68 b2 00 00 00       	push   $0xb2
80105d48:	e9 81 f3 ff ff       	jmp    801050ce <alltraps>

80105d4d <vector179>:
80105d4d:	6a 00                	push   $0x0
80105d4f:	68 b3 00 00 00       	push   $0xb3
80105d54:	e9 75 f3 ff ff       	jmp    801050ce <alltraps>

80105d59 <vector180>:
80105d59:	6a 00                	push   $0x0
80105d5b:	68 b4 00 00 00       	push   $0xb4
80105d60:	e9 69 f3 ff ff       	jmp    801050ce <alltraps>

80105d65 <vector181>:
80105d65:	6a 00                	push   $0x0
80105d67:	68 b5 00 00 00       	push   $0xb5
80105d6c:	e9 5d f3 ff ff       	jmp    801050ce <alltraps>

80105d71 <vector182>:
80105d71:	6a 00                	push   $0x0
80105d73:	68 b6 00 00 00       	push   $0xb6
80105d78:	e9 51 f3 ff ff       	jmp    801050ce <alltraps>

80105d7d <vector183>:
80105d7d:	6a 00                	push   $0x0
80105d7f:	68 b7 00 00 00       	push   $0xb7
80105d84:	e9 45 f3 ff ff       	jmp    801050ce <alltraps>

80105d89 <vector184>:
80105d89:	6a 00                	push   $0x0
80105d8b:	68 b8 00 00 00       	push   $0xb8
80105d90:	e9 39 f3 ff ff       	jmp    801050ce <alltraps>

80105d95 <vector185>:
80105d95:	6a 00                	push   $0x0
80105d97:	68 b9 00 00 00       	push   $0xb9
80105d9c:	e9 2d f3 ff ff       	jmp    801050ce <alltraps>

80105da1 <vector186>:
80105da1:	6a 00                	push   $0x0
80105da3:	68 ba 00 00 00       	push   $0xba
80105da8:	e9 21 f3 ff ff       	jmp    801050ce <alltraps>

80105dad <vector187>:
80105dad:	6a 00                	push   $0x0
80105daf:	68 bb 00 00 00       	push   $0xbb
80105db4:	e9 15 f3 ff ff       	jmp    801050ce <alltraps>

80105db9 <vector188>:
80105db9:	6a 00                	push   $0x0
80105dbb:	68 bc 00 00 00       	push   $0xbc
80105dc0:	e9 09 f3 ff ff       	jmp    801050ce <alltraps>

80105dc5 <vector189>:
80105dc5:	6a 00                	push   $0x0
80105dc7:	68 bd 00 00 00       	push   $0xbd
80105dcc:	e9 fd f2 ff ff       	jmp    801050ce <alltraps>

80105dd1 <vector190>:
80105dd1:	6a 00                	push   $0x0
80105dd3:	68 be 00 00 00       	push   $0xbe
80105dd8:	e9 f1 f2 ff ff       	jmp    801050ce <alltraps>

80105ddd <vector191>:
80105ddd:	6a 00                	push   $0x0
80105ddf:	68 bf 00 00 00       	push   $0xbf
80105de4:	e9 e5 f2 ff ff       	jmp    801050ce <alltraps>

80105de9 <vector192>:
80105de9:	6a 00                	push   $0x0
80105deb:	68 c0 00 00 00       	push   $0xc0
80105df0:	e9 d9 f2 ff ff       	jmp    801050ce <alltraps>

80105df5 <vector193>:
80105df5:	6a 00                	push   $0x0
80105df7:	68 c1 00 00 00       	push   $0xc1
80105dfc:	e9 cd f2 ff ff       	jmp    801050ce <alltraps>

80105e01 <vector194>:
80105e01:	6a 00                	push   $0x0
80105e03:	68 c2 00 00 00       	push   $0xc2
80105e08:	e9 c1 f2 ff ff       	jmp    801050ce <alltraps>

80105e0d <vector195>:
80105e0d:	6a 00                	push   $0x0
80105e0f:	68 c3 00 00 00       	push   $0xc3
80105e14:	e9 b5 f2 ff ff       	jmp    801050ce <alltraps>

80105e19 <vector196>:
80105e19:	6a 00                	push   $0x0
80105e1b:	68 c4 00 00 00       	push   $0xc4
80105e20:	e9 a9 f2 ff ff       	jmp    801050ce <alltraps>

80105e25 <vector197>:
80105e25:	6a 00                	push   $0x0
80105e27:	68 c5 00 00 00       	push   $0xc5
80105e2c:	e9 9d f2 ff ff       	jmp    801050ce <alltraps>

80105e31 <vector198>:
80105e31:	6a 00                	push   $0x0
80105e33:	68 c6 00 00 00       	push   $0xc6
80105e38:	e9 91 f2 ff ff       	jmp    801050ce <alltraps>

80105e3d <vector199>:
80105e3d:	6a 00                	push   $0x0
80105e3f:	68 c7 00 00 00       	push   $0xc7
80105e44:	e9 85 f2 ff ff       	jmp    801050ce <alltraps>

80105e49 <vector200>:
80105e49:	6a 00                	push   $0x0
80105e4b:	68 c8 00 00 00       	push   $0xc8
80105e50:	e9 79 f2 ff ff       	jmp    801050ce <alltraps>

80105e55 <vector201>:
80105e55:	6a 00                	push   $0x0
80105e57:	68 c9 00 00 00       	push   $0xc9
80105e5c:	e9 6d f2 ff ff       	jmp    801050ce <alltraps>

80105e61 <vector202>:
80105e61:	6a 00                	push   $0x0
80105e63:	68 ca 00 00 00       	push   $0xca
80105e68:	e9 61 f2 ff ff       	jmp    801050ce <alltraps>

80105e6d <vector203>:
80105e6d:	6a 00                	push   $0x0
80105e6f:	68 cb 00 00 00       	push   $0xcb
80105e74:	e9 55 f2 ff ff       	jmp    801050ce <alltraps>

80105e79 <vector204>:
80105e79:	6a 00                	push   $0x0
80105e7b:	68 cc 00 00 00       	push   $0xcc
80105e80:	e9 49 f2 ff ff       	jmp    801050ce <alltraps>

80105e85 <vector205>:
80105e85:	6a 00                	push   $0x0
80105e87:	68 cd 00 00 00       	push   $0xcd
80105e8c:	e9 3d f2 ff ff       	jmp    801050ce <alltraps>

80105e91 <vector206>:
80105e91:	6a 00                	push   $0x0
80105e93:	68 ce 00 00 00       	push   $0xce
80105e98:	e9 31 f2 ff ff       	jmp    801050ce <alltraps>

80105e9d <vector207>:
80105e9d:	6a 00                	push   $0x0
80105e9f:	68 cf 00 00 00       	push   $0xcf
80105ea4:	e9 25 f2 ff ff       	jmp    801050ce <alltraps>

80105ea9 <vector208>:
80105ea9:	6a 00                	push   $0x0
80105eab:	68 d0 00 00 00       	push   $0xd0
80105eb0:	e9 19 f2 ff ff       	jmp    801050ce <alltraps>

80105eb5 <vector209>:
80105eb5:	6a 00                	push   $0x0
80105eb7:	68 d1 00 00 00       	push   $0xd1
80105ebc:	e9 0d f2 ff ff       	jmp    801050ce <alltraps>

80105ec1 <vector210>:
80105ec1:	6a 00                	push   $0x0
80105ec3:	68 d2 00 00 00       	push   $0xd2
80105ec8:	e9 01 f2 ff ff       	jmp    801050ce <alltraps>

80105ecd <vector211>:
80105ecd:	6a 00                	push   $0x0
80105ecf:	68 d3 00 00 00       	push   $0xd3
80105ed4:	e9 f5 f1 ff ff       	jmp    801050ce <alltraps>

80105ed9 <vector212>:
80105ed9:	6a 00                	push   $0x0
80105edb:	68 d4 00 00 00       	push   $0xd4
80105ee0:	e9 e9 f1 ff ff       	jmp    801050ce <alltraps>

80105ee5 <vector213>:
80105ee5:	6a 00                	push   $0x0
80105ee7:	68 d5 00 00 00       	push   $0xd5
80105eec:	e9 dd f1 ff ff       	jmp    801050ce <alltraps>

80105ef1 <vector214>:
80105ef1:	6a 00                	push   $0x0
80105ef3:	68 d6 00 00 00       	push   $0xd6
80105ef8:	e9 d1 f1 ff ff       	jmp    801050ce <alltraps>

80105efd <vector215>:
80105efd:	6a 00                	push   $0x0
80105eff:	68 d7 00 00 00       	push   $0xd7
80105f04:	e9 c5 f1 ff ff       	jmp    801050ce <alltraps>

80105f09 <vector216>:
80105f09:	6a 00                	push   $0x0
80105f0b:	68 d8 00 00 00       	push   $0xd8
80105f10:	e9 b9 f1 ff ff       	jmp    801050ce <alltraps>

80105f15 <vector217>:
80105f15:	6a 00                	push   $0x0
80105f17:	68 d9 00 00 00       	push   $0xd9
80105f1c:	e9 ad f1 ff ff       	jmp    801050ce <alltraps>

80105f21 <vector218>:
80105f21:	6a 00                	push   $0x0
80105f23:	68 da 00 00 00       	push   $0xda
80105f28:	e9 a1 f1 ff ff       	jmp    801050ce <alltraps>

80105f2d <vector219>:
80105f2d:	6a 00                	push   $0x0
80105f2f:	68 db 00 00 00       	push   $0xdb
80105f34:	e9 95 f1 ff ff       	jmp    801050ce <alltraps>

80105f39 <vector220>:
80105f39:	6a 00                	push   $0x0
80105f3b:	68 dc 00 00 00       	push   $0xdc
80105f40:	e9 89 f1 ff ff       	jmp    801050ce <alltraps>

80105f45 <vector221>:
80105f45:	6a 00                	push   $0x0
80105f47:	68 dd 00 00 00       	push   $0xdd
80105f4c:	e9 7d f1 ff ff       	jmp    801050ce <alltraps>

80105f51 <vector222>:
80105f51:	6a 00                	push   $0x0
80105f53:	68 de 00 00 00       	push   $0xde
80105f58:	e9 71 f1 ff ff       	jmp    801050ce <alltraps>

80105f5d <vector223>:
80105f5d:	6a 00                	push   $0x0
80105f5f:	68 df 00 00 00       	push   $0xdf
80105f64:	e9 65 f1 ff ff       	jmp    801050ce <alltraps>

80105f69 <vector224>:
80105f69:	6a 00                	push   $0x0
80105f6b:	68 e0 00 00 00       	push   $0xe0
80105f70:	e9 59 f1 ff ff       	jmp    801050ce <alltraps>

80105f75 <vector225>:
80105f75:	6a 00                	push   $0x0
80105f77:	68 e1 00 00 00       	push   $0xe1
80105f7c:	e9 4d f1 ff ff       	jmp    801050ce <alltraps>

80105f81 <vector226>:
80105f81:	6a 00                	push   $0x0
80105f83:	68 e2 00 00 00       	push   $0xe2
80105f88:	e9 41 f1 ff ff       	jmp    801050ce <alltraps>

80105f8d <vector227>:
80105f8d:	6a 00                	push   $0x0
80105f8f:	68 e3 00 00 00       	push   $0xe3
80105f94:	e9 35 f1 ff ff       	jmp    801050ce <alltraps>

80105f99 <vector228>:
80105f99:	6a 00                	push   $0x0
80105f9b:	68 e4 00 00 00       	push   $0xe4
80105fa0:	e9 29 f1 ff ff       	jmp    801050ce <alltraps>

80105fa5 <vector229>:
80105fa5:	6a 00                	push   $0x0
80105fa7:	68 e5 00 00 00       	push   $0xe5
80105fac:	e9 1d f1 ff ff       	jmp    801050ce <alltraps>

80105fb1 <vector230>:
80105fb1:	6a 00                	push   $0x0
80105fb3:	68 e6 00 00 00       	push   $0xe6
80105fb8:	e9 11 f1 ff ff       	jmp    801050ce <alltraps>

80105fbd <vector231>:
80105fbd:	6a 00                	push   $0x0
80105fbf:	68 e7 00 00 00       	push   $0xe7
80105fc4:	e9 05 f1 ff ff       	jmp    801050ce <alltraps>

80105fc9 <vector232>:
80105fc9:	6a 00                	push   $0x0
80105fcb:	68 e8 00 00 00       	push   $0xe8
80105fd0:	e9 f9 f0 ff ff       	jmp    801050ce <alltraps>

80105fd5 <vector233>:
80105fd5:	6a 00                	push   $0x0
80105fd7:	68 e9 00 00 00       	push   $0xe9
80105fdc:	e9 ed f0 ff ff       	jmp    801050ce <alltraps>

80105fe1 <vector234>:
80105fe1:	6a 00                	push   $0x0
80105fe3:	68 ea 00 00 00       	push   $0xea
80105fe8:	e9 e1 f0 ff ff       	jmp    801050ce <alltraps>

80105fed <vector235>:
80105fed:	6a 00                	push   $0x0
80105fef:	68 eb 00 00 00       	push   $0xeb
80105ff4:	e9 d5 f0 ff ff       	jmp    801050ce <alltraps>

80105ff9 <vector236>:
80105ff9:	6a 00                	push   $0x0
80105ffb:	68 ec 00 00 00       	push   $0xec
80106000:	e9 c9 f0 ff ff       	jmp    801050ce <alltraps>

80106005 <vector237>:
80106005:	6a 00                	push   $0x0
80106007:	68 ed 00 00 00       	push   $0xed
8010600c:	e9 bd f0 ff ff       	jmp    801050ce <alltraps>

80106011 <vector238>:
80106011:	6a 00                	push   $0x0
80106013:	68 ee 00 00 00       	push   $0xee
80106018:	e9 b1 f0 ff ff       	jmp    801050ce <alltraps>

8010601d <vector239>:
8010601d:	6a 00                	push   $0x0
8010601f:	68 ef 00 00 00       	push   $0xef
80106024:	e9 a5 f0 ff ff       	jmp    801050ce <alltraps>

80106029 <vector240>:
80106029:	6a 00                	push   $0x0
8010602b:	68 f0 00 00 00       	push   $0xf0
80106030:	e9 99 f0 ff ff       	jmp    801050ce <alltraps>

80106035 <vector241>:
80106035:	6a 00                	push   $0x0
80106037:	68 f1 00 00 00       	push   $0xf1
8010603c:	e9 8d f0 ff ff       	jmp    801050ce <alltraps>

80106041 <vector242>:
80106041:	6a 00                	push   $0x0
80106043:	68 f2 00 00 00       	push   $0xf2
80106048:	e9 81 f0 ff ff       	jmp    801050ce <alltraps>

8010604d <vector243>:
8010604d:	6a 00                	push   $0x0
8010604f:	68 f3 00 00 00       	push   $0xf3
80106054:	e9 75 f0 ff ff       	jmp    801050ce <alltraps>

80106059 <vector244>:
80106059:	6a 00                	push   $0x0
8010605b:	68 f4 00 00 00       	push   $0xf4
80106060:	e9 69 f0 ff ff       	jmp    801050ce <alltraps>

80106065 <vector245>:
80106065:	6a 00                	push   $0x0
80106067:	68 f5 00 00 00       	push   $0xf5
8010606c:	e9 5d f0 ff ff       	jmp    801050ce <alltraps>

80106071 <vector246>:
80106071:	6a 00                	push   $0x0
80106073:	68 f6 00 00 00       	push   $0xf6
80106078:	e9 51 f0 ff ff       	jmp    801050ce <alltraps>

8010607d <vector247>:
8010607d:	6a 00                	push   $0x0
8010607f:	68 f7 00 00 00       	push   $0xf7
80106084:	e9 45 f0 ff ff       	jmp    801050ce <alltraps>

80106089 <vector248>:
80106089:	6a 00                	push   $0x0
8010608b:	68 f8 00 00 00       	push   $0xf8
80106090:	e9 39 f0 ff ff       	jmp    801050ce <alltraps>

80106095 <vector249>:
80106095:	6a 00                	push   $0x0
80106097:	68 f9 00 00 00       	push   $0xf9
8010609c:	e9 2d f0 ff ff       	jmp    801050ce <alltraps>

801060a1 <vector250>:
801060a1:	6a 00                	push   $0x0
801060a3:	68 fa 00 00 00       	push   $0xfa
801060a8:	e9 21 f0 ff ff       	jmp    801050ce <alltraps>

801060ad <vector251>:
801060ad:	6a 00                	push   $0x0
801060af:	68 fb 00 00 00       	push   $0xfb
801060b4:	e9 15 f0 ff ff       	jmp    801050ce <alltraps>

801060b9 <vector252>:
801060b9:	6a 00                	push   $0x0
801060bb:	68 fc 00 00 00       	push   $0xfc
801060c0:	e9 09 f0 ff ff       	jmp    801050ce <alltraps>

801060c5 <vector253>:
801060c5:	6a 00                	push   $0x0
801060c7:	68 fd 00 00 00       	push   $0xfd
801060cc:	e9 fd ef ff ff       	jmp    801050ce <alltraps>

801060d1 <vector254>:
801060d1:	6a 00                	push   $0x0
801060d3:	68 fe 00 00 00       	push   $0xfe
801060d8:	e9 f1 ef ff ff       	jmp    801050ce <alltraps>

801060dd <vector255>:
801060dd:	6a 00                	push   $0x0
801060df:	68 ff 00 00 00       	push   $0xff
801060e4:	e9 e5 ef ff ff       	jmp    801050ce <alltraps>

801060e9 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801060e9:	55                   	push   %ebp
801060ea:	89 e5                	mov    %esp,%ebp
801060ec:	57                   	push   %edi
801060ed:	56                   	push   %esi
801060ee:	53                   	push   %ebx
801060ef:	83 ec 2c             	sub    $0x2c,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801060f2:	e8 f2 d1 ff ff       	call   801032e9 <cpuid>
801060f7:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801060f9:	8d 14 80             	lea    (%eax,%eax,4),%edx
801060fc:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
801060ff:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80106102:	c1 e0 04             	shl    $0x4,%eax
80106105:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
8010610c:	ff ff 
8010610e:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80106115:	00 00 
80106117:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
8010611e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80106121:	01 d9                	add    %ebx,%ecx
80106123:	c1 e1 04             	shl    $0x4,%ecx
80106126:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
8010612d:	83 e6 f0             	and    $0xfffffff0,%esi
80106130:	89 f7                	mov    %esi,%edi
80106132:	83 cf 0a             	or     $0xa,%edi
80106135:	89 fa                	mov    %edi,%edx
80106137:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
8010613d:	83 ce 1a             	or     $0x1a,%esi
80106140:	89 f2                	mov    %esi,%edx
80106142:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106148:	83 e6 9f             	and    $0xffffff9f,%esi
8010614b:	89 f2                	mov    %esi,%edx
8010614d:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106153:	83 ce 80             	or     $0xffffff80,%esi
80106156:	89 f2                	mov    %esi,%edx
80106158:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
8010615e:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
80106165:	83 ce 0f             	or     $0xf,%esi
80106168:	89 f2                	mov    %esi,%edx
8010616a:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106170:	89 f7                	mov    %esi,%edi
80106172:	83 e7 ef             	and    $0xffffffef,%edi
80106175:	89 fa                	mov    %edi,%edx
80106177:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
8010617d:	83 e6 cf             	and    $0xffffffcf,%esi
80106180:	89 f2                	mov    %esi,%edx
80106182:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106188:	89 f7                	mov    %esi,%edi
8010618a:	83 cf 40             	or     $0x40,%edi
8010618d:	89 fa                	mov    %edi,%edx
8010618f:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106195:	83 ce c0             	or     $0xffffffc0,%esi
80106198:	89 f2                	mov    %esi,%edx
8010619a:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801061a0:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801061a7:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
801061ae:	ff ff 
801061b0:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
801061b7:	00 00 
801061b9:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
801061c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801061c3:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801061c6:	c1 e1 04             	shl    $0x4,%ecx
801061c9:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
801061d0:	83 e6 f0             	and    $0xfffffff0,%esi
801061d3:	89 f7                	mov    %esi,%edi
801061d5:	83 cf 02             	or     $0x2,%edi
801061d8:	89 fa                	mov    %edi,%edx
801061da:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
801061e0:	83 ce 12             	or     $0x12,%esi
801061e3:	89 f2                	mov    %esi,%edx
801061e5:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
801061eb:	83 e6 9f             	and    $0xffffff9f,%esi
801061ee:	89 f2                	mov    %esi,%edx
801061f0:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
801061f6:	83 ce 80             	or     $0xffffff80,%esi
801061f9:	89 f2                	mov    %esi,%edx
801061fb:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106201:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80106208:	83 ce 0f             	or     $0xf,%esi
8010620b:	89 f2                	mov    %esi,%edx
8010620d:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106213:	89 f7                	mov    %esi,%edi
80106215:	83 e7 ef             	and    $0xffffffef,%edi
80106218:	89 fa                	mov    %edi,%edx
8010621a:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106220:	83 e6 cf             	and    $0xffffffcf,%esi
80106223:	89 f2                	mov    %esi,%edx
80106225:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010622b:	89 f7                	mov    %esi,%edi
8010622d:	83 cf 40             	or     $0x40,%edi
80106230:	89 fa                	mov    %edi,%edx
80106232:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106238:	83 ce c0             	or     $0xffffffc0,%esi
8010623b:	89 f2                	mov    %esi,%edx
8010623d:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106243:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010624a:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
80106251:	ff ff 
80106253:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
8010625a:	00 00 
8010625c:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
80106263:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106266:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106269:	c1 e1 04             	shl    $0x4,%ecx
8010626c:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
80106273:	83 e6 f0             	and    $0xfffffff0,%esi
80106276:	89 f7                	mov    %esi,%edi
80106278:	83 cf 0a             	or     $0xa,%edi
8010627b:	89 fa                	mov    %edi,%edx
8010627d:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80106283:	89 f7                	mov    %esi,%edi
80106285:	83 cf 1a             	or     $0x1a,%edi
80106288:	89 fa                	mov    %edi,%edx
8010628a:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80106290:	83 ce 7a             	or     $0x7a,%esi
80106293:	89 f2                	mov    %esi,%edx
80106295:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
8010629b:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
801062a2:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
801062a9:	83 ce 0f             	or     $0xf,%esi
801062ac:	89 f2                	mov    %esi,%edx
801062ae:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062b4:	89 f7                	mov    %esi,%edi
801062b6:	83 e7 ef             	and    $0xffffffef,%edi
801062b9:	89 fa                	mov    %edi,%edx
801062bb:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062c1:	83 e6 cf             	and    $0xffffffcf,%esi
801062c4:	89 f2                	mov    %esi,%edx
801062c6:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062cc:	89 f7                	mov    %esi,%edi
801062ce:	83 cf 40             	or     $0x40,%edi
801062d1:	89 fa                	mov    %edi,%edx
801062d3:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062d9:	83 ce c0             	or     $0xffffffc0,%esi
801062dc:	89 f2                	mov    %esi,%edx
801062de:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801062e4:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801062eb:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
801062f2:	ff ff 
801062f4:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
801062fb:	00 00 
801062fd:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
80106304:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106307:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
8010630a:	c1 e1 04             	shl    $0x4,%ecx
8010630d:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
80106314:	83 e6 f0             	and    $0xfffffff0,%esi
80106317:	89 f7                	mov    %esi,%edi
80106319:	83 cf 02             	or     $0x2,%edi
8010631c:	89 fa                	mov    %edi,%edx
8010631e:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106324:	89 f7                	mov    %esi,%edi
80106326:	83 cf 12             	or     $0x12,%edi
80106329:	89 fa                	mov    %edi,%edx
8010632b:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106331:	83 ce 72             	or     $0x72,%esi
80106334:	89 f2                	mov    %esi,%edx
80106336:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010633c:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
80106343:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
8010634a:	83 ce 0f             	or     $0xf,%esi
8010634d:	89 f2                	mov    %esi,%edx
8010634f:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106355:	89 f7                	mov    %esi,%edi
80106357:	83 e7 ef             	and    $0xffffffef,%edi
8010635a:	89 fa                	mov    %edi,%edx
8010635c:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106362:	83 e6 cf             	and    $0xffffffcf,%esi
80106365:	89 f2                	mov    %esi,%edx
80106367:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010636d:	89 f7                	mov    %esi,%edi
8010636f:	83 cf 40             	or     $0x40,%edi
80106372:	89 fa                	mov    %edi,%edx
80106374:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010637a:	83 ce c0             	or     $0xffffffc0,%esi
8010637d:	89 f2                	mov    %esi,%edx
8010637f:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106385:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010638c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010638f:	01 da                	add    %ebx,%edx
80106391:	c1 e2 04             	shl    $0x4,%edx
80106394:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
8010639a:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
801063a0:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
801063a4:	c1 ea 10             	shr    $0x10,%edx
801063a7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801063ab:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801063ae:	0f 01 10             	lgdtl  (%eax)
}
801063b1:	83 c4 2c             	add    $0x2c,%esp
801063b4:	5b                   	pop    %ebx
801063b5:	5e                   	pop    %esi
801063b6:	5f                   	pop    %edi
801063b7:	5d                   	pop    %ebp
801063b8:	c3                   	ret    

801063b9 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801063b9:	55                   	push   %ebp
801063ba:	89 e5                	mov    %esp,%ebp
801063bc:	56                   	push   %esi
801063bd:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801063be:	8b 75 0c             	mov    0xc(%ebp),%esi
801063c1:	c1 ee 16             	shr    $0x16,%esi
801063c4:	c1 e6 02             	shl    $0x2,%esi
801063c7:	03 75 08             	add    0x8(%ebp),%esi
  if(*pde & PTE_P){
801063ca:	8b 1e                	mov    (%esi),%ebx
801063cc:	f6 c3 01             	test   $0x1,%bl
801063cf:	74 21                	je     801063f2 <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801063d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801063d7:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801063dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801063e0:	c1 e8 0c             	shr    $0xc,%eax
801063e3:	25 ff 03 00 00       	and    $0x3ff,%eax
801063e8:	8d 04 83             	lea    (%ebx,%eax,4),%eax
}
801063eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063ee:	5b                   	pop    %ebx
801063ef:	5e                   	pop    %esi
801063f0:	5d                   	pop    %ebp
801063f1:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801063f6:	74 2b                	je     80106423 <walkpgdir+0x6a>
801063f8:	e8 2a bc ff ff       	call   80102027 <kalloc>
801063fd:	89 c3                	mov    %eax,%ebx
801063ff:	85 c0                	test   %eax,%eax
80106401:	74 20                	je     80106423 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80106403:	83 ec 04             	sub    $0x4,%esp
80106406:	68 00 10 00 00       	push   $0x1000
8010640b:	6a 00                	push   $0x0
8010640d:	50                   	push   %eax
8010640e:	e8 e1 d9 ff ff       	call   80103df4 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106413:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106419:	83 c8 07             	or     $0x7,%eax
8010641c:	89 06                	mov    %eax,(%esi)
8010641e:	83 c4 10             	add    $0x10,%esp
80106421:	eb ba                	jmp    801063dd <walkpgdir+0x24>
      return 0;
80106423:	b8 00 00 00 00       	mov    $0x0,%eax
80106428:	eb c1                	jmp    801063eb <walkpgdir+0x32>

8010642a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010642a:	55                   	push   %ebp
8010642b:	89 e5                	mov    %esp,%ebp
8010642d:	57                   	push   %edi
8010642e:	56                   	push   %esi
8010642f:	53                   	push   %ebx
80106430:	83 ec 1c             	sub    $0x1c,%esp
80106433:	8b 7d 08             	mov    0x8(%ebp),%edi
80106436:	8b 45 0c             	mov    0xc(%ebp),%eax
80106439:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010643c:	89 c3                	mov    %eax,%ebx
8010643e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106444:	03 45 10             	add    0x10(%ebp),%eax
80106447:	48                   	dec    %eax
80106448:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010644d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106450:	eb 0c                	jmp    8010645e <mappages+0x34>
    //if(*pte & PTE_P)
      //panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80106452:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80106458:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010645e:	83 ec 04             	sub    $0x4,%esp
80106461:	6a 01                	push   $0x1
80106463:	53                   	push   %ebx
80106464:	57                   	push   %edi
80106465:	e8 4f ff ff ff       	call   801063b9 <walkpgdir>
8010646a:	83 c4 10             	add    $0x10,%esp
8010646d:	85 c0                	test   %eax,%eax
8010646f:	74 16                	je     80106487 <mappages+0x5d>
    *pte = pa | perm | PTE_P;
80106471:	89 f2                	mov    %esi,%edx
80106473:	0b 55 18             	or     0x18(%ebp),%edx
80106476:	83 ca 01             	or     $0x1,%edx
80106479:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010647b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010647e:	75 d2                	jne    80106452 <mappages+0x28>
  }
  return 0;
80106480:	b8 00 00 00 00       	mov    $0x0,%eax
80106485:	eb 05                	jmp    8010648c <mappages+0x62>
      return -1;
80106487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010648c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010648f:	5b                   	pop    %ebx
80106490:	5e                   	pop    %esi
80106491:	5f                   	pop    %edi
80106492:	5d                   	pop    %ebp
80106493:	c3                   	ret    

80106494 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106494:	a1 24 48 11 80       	mov    0x80114824,%eax
80106499:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010649e:	0f 22 d8             	mov    %eax,%cr3
}
801064a1:	c3                   	ret    

801064a2 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801064a2:	55                   	push   %ebp
801064a3:	89 e5                	mov    %esp,%ebp
801064a5:	57                   	push   %edi
801064a6:	56                   	push   %esi
801064a7:	53                   	push   %ebx
801064a8:	83 ec 1c             	sub    $0x1c,%esp
801064ab:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801064ae:	85 f6                	test   %esi,%esi
801064b0:	0f 84 21 01 00 00    	je     801065d7 <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801064b6:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801064ba:	0f 84 24 01 00 00    	je     801065e4 <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801064c0:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801064c4:	0f 84 27 01 00 00    	je     801065f1 <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
801064ca:	e8 9f d7 ff ff       	call   80103c6e <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801064cf:	e8 b1 cd ff ff       	call   80103285 <mycpu>
801064d4:	89 c3                	mov    %eax,%ebx
801064d6:	e8 aa cd ff ff       	call   80103285 <mycpu>
801064db:	8d 78 08             	lea    0x8(%eax),%edi
801064de:	e8 a2 cd ff ff       	call   80103285 <mycpu>
801064e3:	83 c0 08             	add    $0x8,%eax
801064e6:	c1 e8 10             	shr    $0x10,%eax
801064e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064ec:	e8 94 cd ff ff       	call   80103285 <mycpu>
801064f1:	83 c0 08             	add    $0x8,%eax
801064f4:	c1 e8 18             	shr    $0x18,%eax
801064f7:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801064fe:	67 00 
80106500:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106507:	8a 4d e4             	mov    -0x1c(%ebp),%cl
8010650a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106510:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106516:	83 e2 f0             	and    $0xfffffff0,%edx
80106519:	88 d1                	mov    %dl,%cl
8010651b:	83 c9 09             	or     $0x9,%ecx
8010651e:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
80106524:	83 ca 19             	or     $0x19,%edx
80106527:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010652d:	83 e2 9f             	and    $0xffffff9f,%edx
80106530:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106536:	83 ca 80             	or     $0xffffff80,%edx
80106539:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010653f:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80106545:	88 d1                	mov    %dl,%cl
80106547:	83 e1 f0             	and    $0xfffffff0,%ecx
8010654a:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106550:	88 d1                	mov    %dl,%cl
80106552:	83 e1 e0             	and    $0xffffffe0,%ecx
80106555:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010655b:	83 e2 c0             	and    $0xffffffc0,%edx
8010655e:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106564:	83 ca 40             	or     $0x40,%edx
80106567:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010656d:	83 e2 7f             	and    $0x7f,%edx
80106570:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106576:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010657c:	e8 04 cd ff ff       	call   80103285 <mycpu>
80106581:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80106587:	83 e2 ef             	and    $0xffffffef,%edx
8010658a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106590:	e8 f0 cc ff ff       	call   80103285 <mycpu>
80106595:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010659b:	8b 5e 08             	mov    0x8(%esi),%ebx
8010659e:	e8 e2 cc ff ff       	call   80103285 <mycpu>
801065a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065a9:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801065ac:	e8 d4 cc ff ff       	call   80103285 <mycpu>
801065b1:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801065b7:	b8 28 00 00 00       	mov    $0x28,%eax
801065bc:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801065bf:	8b 46 04             	mov    0x4(%esi),%eax
801065c2:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065c7:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801065ca:	e8 da d6 ff ff       	call   80103ca9 <popcli>
}
801065cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d2:	5b                   	pop    %ebx
801065d3:	5e                   	pop    %esi
801065d4:	5f                   	pop    %edi
801065d5:	5d                   	pop    %ebp
801065d6:	c3                   	ret    
    panic("switchuvm: no process");
801065d7:	83 ec 0c             	sub    $0xc,%esp
801065da:	68 dc 74 10 80       	push   $0x801074dc
801065df:	e8 5d 9d ff ff       	call   80100341 <panic>
    panic("switchuvm: no kstack");
801065e4:	83 ec 0c             	sub    $0xc,%esp
801065e7:	68 f2 74 10 80       	push   $0x801074f2
801065ec:	e8 50 9d ff ff       	call   80100341 <panic>
    panic("switchuvm: no pgdir");
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	68 07 75 10 80       	push   $0x80107507
801065f9:	e8 43 9d ff ff       	call   80100341 <panic>

801065fe <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801065fe:	55                   	push   %ebp
801065ff:	89 e5                	mov    %esp,%ebp
80106601:	56                   	push   %esi
80106602:	53                   	push   %ebx
80106603:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106606:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010660c:	77 4b                	ja     80106659 <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
8010660e:	e8 14 ba ff ff       	call   80102027 <kalloc>
80106613:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106615:	83 ec 04             	sub    $0x4,%esp
80106618:	68 00 10 00 00       	push   $0x1000
8010661d:	6a 00                	push   $0x0
8010661f:	50                   	push   %eax
80106620:	e8 cf d7 ff ff       	call   80103df4 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106625:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010662c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106632:	50                   	push   %eax
80106633:	68 00 10 00 00       	push   $0x1000
80106638:	6a 00                	push   $0x0
8010663a:	ff 75 08             	push   0x8(%ebp)
8010663d:	e8 e8 fd ff ff       	call   8010642a <mappages>
  memmove(mem, init, sz);
80106642:	83 c4 1c             	add    $0x1c,%esp
80106645:	56                   	push   %esi
80106646:	ff 75 0c             	push   0xc(%ebp)
80106649:	53                   	push   %ebx
8010664a:	e8 1b d8 ff ff       	call   80103e6a <memmove>
}
8010664f:	83 c4 10             	add    $0x10,%esp
80106652:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106655:	5b                   	pop    %ebx
80106656:	5e                   	pop    %esi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret    
    panic("inituvm: more than a page");
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 1b 75 10 80       	push   $0x8010751b
80106661:	e8 db 9c ff ff       	call   80100341 <panic>

80106666 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106666:	55                   	push   %ebp
80106667:	89 e5                	mov    %esp,%ebp
80106669:	57                   	push   %edi
8010666a:	56                   	push   %esi
8010666b:	53                   	push   %ebx
8010666c:	83 ec 0c             	sub    $0xc,%esp
8010666f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106672:	89 fb                	mov    %edi,%ebx
80106674:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010667a:	74 3c                	je     801066b8 <loaduvm+0x52>
    panic("loaduvm: addr must be page aligned");
8010667c:	83 ec 0c             	sub    $0xc,%esp
8010667f:	68 a4 75 10 80       	push   $0x801075a4
80106684:	e8 b8 9c ff ff       	call   80100341 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106689:	83 ec 0c             	sub    $0xc,%esp
8010668c:	68 35 75 10 80       	push   $0x80107535
80106691:	e8 ab 9c ff ff       	call   80100341 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106696:	05 00 00 00 80       	add    $0x80000000,%eax
8010669b:	56                   	push   %esi
8010669c:	89 da                	mov    %ebx,%edx
8010669e:	03 55 14             	add    0x14(%ebp),%edx
801066a1:	52                   	push   %edx
801066a2:	50                   	push   %eax
801066a3:	ff 75 10             	push   0x10(%ebp)
801066a6:	e8 48 b0 ff ff       	call   801016f3 <readi>
801066ab:	83 c4 10             	add    $0x10,%esp
801066ae:	39 f0                	cmp    %esi,%eax
801066b0:	75 4b                	jne    801066fd <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
801066b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066b8:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801066bb:	73 33                	jae    801066f0 <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801066bd:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
801066c0:	83 ec 04             	sub    $0x4,%esp
801066c3:	6a 00                	push   $0x0
801066c5:	50                   	push   %eax
801066c6:	ff 75 08             	push   0x8(%ebp)
801066c9:	e8 eb fc ff ff       	call   801063b9 <walkpgdir>
801066ce:	83 c4 10             	add    $0x10,%esp
801066d1:	85 c0                	test   %eax,%eax
801066d3:	74 b4                	je     80106689 <loaduvm+0x23>
    pa = PTE_ADDR(*pte);
801066d5:	8b 00                	mov    (%eax),%eax
801066d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801066dc:	8b 75 18             	mov    0x18(%ebp),%esi
801066df:	29 de                	sub    %ebx,%esi
801066e1:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066e7:	76 ad                	jbe    80106696 <loaduvm+0x30>
      n = PGSIZE;
801066e9:	be 00 10 00 00       	mov    $0x1000,%esi
801066ee:	eb a6                	jmp    80106696 <loaduvm+0x30>
      return -1;
  }
  return 0;
801066f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f8:	5b                   	pop    %ebx
801066f9:	5e                   	pop    %esi
801066fa:	5f                   	pop    %edi
801066fb:	5d                   	pop    %ebp
801066fc:	c3                   	ret    
      return -1;
801066fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106702:	eb f1                	jmp    801066f5 <loaduvm+0x8f>

80106704 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	57                   	push   %edi
80106708:	56                   	push   %esi
80106709:	53                   	push   %ebx
8010670a:	83 ec 0c             	sub    $0xc,%esp
8010670d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106710:	8b 45 0c             	mov    0xc(%ebp),%eax
80106713:	39 45 10             	cmp    %eax,0x10(%ebp)
80106716:	73 74                	jae    8010678c <deallocuvm+0x88>
    return oldsz;

  a = PGROUNDUP(newsz);
80106718:	8b 45 10             	mov    0x10(%ebp),%eax
8010671b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106721:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106727:	eb 13                	jmp    8010673c <deallocuvm+0x38>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106729:	c1 eb 16             	shr    $0x16,%ebx
8010672c:	43                   	inc    %ebx
8010672d:	c1 e3 16             	shl    $0x16,%ebx
80106730:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106736:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010673c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
8010673f:	73 48                	jae    80106789 <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106741:	83 ec 04             	sub    $0x4,%esp
80106744:	6a 00                	push   $0x0
80106746:	53                   	push   %ebx
80106747:	57                   	push   %edi
80106748:	e8 6c fc ff ff       	call   801063b9 <walkpgdir>
8010674d:	89 c6                	mov    %eax,%esi
    if(!pte)
8010674f:	83 c4 10             	add    $0x10,%esp
80106752:	85 c0                	test   %eax,%eax
80106754:	74 d3                	je     80106729 <deallocuvm+0x25>
    else if((*pte & PTE_P) != 0){
80106756:	8b 00                	mov    (%eax),%eax
80106758:	a8 01                	test   $0x1,%al
8010675a:	74 da                	je     80106736 <deallocuvm+0x32>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010675c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106761:	74 19                	je     8010677c <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
80106763:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106768:	83 ec 0c             	sub    $0xc,%esp
8010676b:	50                   	push   %eax
8010676c:	e8 9f b7 ff ff       	call   80101f10 <kfree>
      *pte = 0;
80106771:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106777:	83 c4 10             	add    $0x10,%esp
8010677a:	eb ba                	jmp    80106736 <deallocuvm+0x32>
        panic("kfree");
8010677c:	83 ec 0c             	sub    $0xc,%esp
8010677f:	68 a6 6d 10 80       	push   $0x80106da6
80106784:	e8 b8 9b ff ff       	call   80100341 <panic>
    }
  }
  return newsz;
80106789:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010678c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678f:	5b                   	pop    %ebx
80106790:	5e                   	pop    %esi
80106791:	5f                   	pop    %edi
80106792:	5d                   	pop    %ebp
80106793:	c3                   	ret    

80106794 <allocuvm>:
{
80106794:	55                   	push   %ebp
80106795:	89 e5                	mov    %esp,%ebp
80106797:	57                   	push   %edi
80106798:	56                   	push   %esi
80106799:	53                   	push   %ebx
8010679a:	83 ec 1c             	sub    $0x1c,%esp
8010679d:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801067a0:	8b 45 10             	mov    0x10(%ebp),%eax
801067a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067a6:	85 c0                	test   %eax,%eax
801067a8:	0f 88 c1 00 00 00    	js     8010686f <allocuvm+0xdb>
  if(newsz < oldsz)
801067ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801067b1:	39 45 10             	cmp    %eax,0x10(%ebp)
801067b4:	72 5c                	jb     80106812 <allocuvm+0x7e>
  a = PGROUNDUP(oldsz);
801067b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801067b9:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801067bf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801067c5:	3b 75 10             	cmp    0x10(%ebp),%esi
801067c8:	0f 83 a8 00 00 00    	jae    80106876 <allocuvm+0xe2>
    mem = kalloc();
801067ce:	e8 54 b8 ff ff       	call   80102027 <kalloc>
801067d3:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801067d5:	85 c0                	test   %eax,%eax
801067d7:	74 3e                	je     80106817 <allocuvm+0x83>
    memset(mem, 0, PGSIZE);
801067d9:	83 ec 04             	sub    $0x4,%esp
801067dc:	68 00 10 00 00       	push   $0x1000
801067e1:	6a 00                	push   $0x0
801067e3:	50                   	push   %eax
801067e4:	e8 0b d6 ff ff       	call   80103df4 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801067e9:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801067f0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067f6:	50                   	push   %eax
801067f7:	68 00 10 00 00       	push   $0x1000
801067fc:	56                   	push   %esi
801067fd:	57                   	push   %edi
801067fe:	e8 27 fc ff ff       	call   8010642a <mappages>
80106803:	83 c4 20             	add    $0x20,%esp
80106806:	85 c0                	test   %eax,%eax
80106808:	78 35                	js     8010683f <allocuvm+0xab>
  for(; a < newsz; a += PGSIZE){
8010680a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106810:	eb b3                	jmp    801067c5 <allocuvm+0x31>
    return oldsz;
80106812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106815:	eb 5f                	jmp    80106876 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106817:	83 ec 0c             	sub    $0xc,%esp
8010681a:	68 53 75 10 80       	push   $0x80107553
8010681f:	e8 b6 9d ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106824:	83 c4 0c             	add    $0xc,%esp
80106827:	ff 75 0c             	push   0xc(%ebp)
8010682a:	ff 75 10             	push   0x10(%ebp)
8010682d:	57                   	push   %edi
8010682e:	e8 d1 fe ff ff       	call   80106704 <deallocuvm>
      return 0;
80106833:	83 c4 10             	add    $0x10,%esp
80106836:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010683d:	eb 37                	jmp    80106876 <allocuvm+0xe2>
      cprintf("allocuvm out of memory (2)\n");
8010683f:	83 ec 0c             	sub    $0xc,%esp
80106842:	68 6b 75 10 80       	push   $0x8010756b
80106847:	e8 8e 9d ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010684c:	83 c4 0c             	add    $0xc,%esp
8010684f:	ff 75 0c             	push   0xc(%ebp)
80106852:	ff 75 10             	push   0x10(%ebp)
80106855:	57                   	push   %edi
80106856:	e8 a9 fe ff ff       	call   80106704 <deallocuvm>
      kfree(mem);
8010685b:	89 1c 24             	mov    %ebx,(%esp)
8010685e:	e8 ad b6 ff ff       	call   80101f10 <kfree>
      return 0;
80106863:	83 c4 10             	add    $0x10,%esp
80106866:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010686d:	eb 07                	jmp    80106876 <allocuvm+0xe2>
    return 0;
8010686f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010687c:	5b                   	pop    %ebx
8010687d:	5e                   	pop    %esi
8010687e:	5f                   	pop    %edi
8010687f:	5d                   	pop    %ebp
80106880:	c3                   	ret    

80106881 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
80106881:	55                   	push   %ebp
80106882:	89 e5                	mov    %esp,%ebp
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106889:	85 f6                	test   %esi,%esi
8010688b:	74 0d                	je     8010689a <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
8010688d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106891:	75 14                	jne    801068a7 <freevm+0x26>
{
80106893:	bb 00 00 00 00       	mov    $0x0,%ebx
80106898:	eb 23                	jmp    801068bd <freevm+0x3c>
    panic("freevm: no pgdir");
8010689a:	83 ec 0c             	sub    $0xc,%esp
8010689d:	68 87 75 10 80       	push   $0x80107587
801068a2:	e8 9a 9a ff ff       	call   80100341 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801068a7:	83 ec 04             	sub    $0x4,%esp
801068aa:	6a 00                	push   $0x0
801068ac:	68 00 00 00 80       	push   $0x80000000
801068b1:	56                   	push   %esi
801068b2:	e8 4d fe ff ff       	call   80106704 <deallocuvm>
801068b7:	83 c4 10             	add    $0x10,%esp
801068ba:	eb d7                	jmp    80106893 <freevm+0x12>
  for(i = 0; i < NPDENTRIES; i++){
801068bc:	43                   	inc    %ebx
801068bd:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801068c3:	77 1f                	ja     801068e4 <freevm+0x63>
    if(pgdir[i] & PTE_P){
801068c5:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801068c8:	a8 01                	test   $0x1,%al
801068ca:	74 f0                	je     801068bc <freevm+0x3b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801068cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068d1:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801068d6:	83 ec 0c             	sub    $0xc,%esp
801068d9:	50                   	push   %eax
801068da:	e8 31 b6 ff ff       	call   80101f10 <kfree>
801068df:	83 c4 10             	add    $0x10,%esp
801068e2:	eb d8                	jmp    801068bc <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
801068e4:	83 ec 0c             	sub    $0xc,%esp
801068e7:	56                   	push   %esi
801068e8:	e8 23 b6 ff ff       	call   80101f10 <kfree>
}
801068ed:	83 c4 10             	add    $0x10,%esp
801068f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068f3:	5b                   	pop    %ebx
801068f4:	5e                   	pop    %esi
801068f5:	5d                   	pop    %ebp
801068f6:	c3                   	ret    

801068f7 <setupkvm>:
{
801068f7:	55                   	push   %ebp
801068f8:	89 e5                	mov    %esp,%ebp
801068fa:	56                   	push   %esi
801068fb:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801068fc:	e8 26 b7 ff ff       	call   80102027 <kalloc>
80106901:	89 c6                	mov    %eax,%esi
80106903:	85 c0                	test   %eax,%eax
80106905:	74 57                	je     8010695e <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
80106907:	83 ec 04             	sub    $0x4,%esp
8010690a:	68 00 10 00 00       	push   $0x1000
8010690f:	6a 00                	push   $0x0
80106911:	50                   	push   %eax
80106912:	e8 dd d4 ff ff       	call   80103df4 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106917:	83 c4 10             	add    $0x10,%esp
8010691a:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
8010691f:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106925:	73 37                	jae    8010695e <setupkvm+0x67>
                (uint)k->phys_start, k->perm) < 0) {
80106927:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010692a:	83 ec 0c             	sub    $0xc,%esp
8010692d:	ff 73 0c             	push   0xc(%ebx)
80106930:	52                   	push   %edx
80106931:	8b 43 08             	mov    0x8(%ebx),%eax
80106934:	29 d0                	sub    %edx,%eax
80106936:	50                   	push   %eax
80106937:	ff 33                	push   (%ebx)
80106939:	56                   	push   %esi
8010693a:	e8 eb fa ff ff       	call   8010642a <mappages>
8010693f:	83 c4 20             	add    $0x20,%esp
80106942:	85 c0                	test   %eax,%eax
80106944:	78 05                	js     8010694b <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106946:	83 c3 10             	add    $0x10,%ebx
80106949:	eb d4                	jmp    8010691f <setupkvm+0x28>
      freevm(pgdir, 0);
8010694b:	83 ec 08             	sub    $0x8,%esp
8010694e:	6a 00                	push   $0x0
80106950:	56                   	push   %esi
80106951:	e8 2b ff ff ff       	call   80106881 <freevm>
      return 0;
80106956:	83 c4 10             	add    $0x10,%esp
80106959:	be 00 00 00 00       	mov    $0x0,%esi
}
8010695e:	89 f0                	mov    %esi,%eax
80106960:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106963:	5b                   	pop    %ebx
80106964:	5e                   	pop    %esi
80106965:	5d                   	pop    %ebp
80106966:	c3                   	ret    

80106967 <kvmalloc>:
{
80106967:	55                   	push   %ebp
80106968:	89 e5                	mov    %esp,%ebp
8010696a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010696d:	e8 85 ff ff ff       	call   801068f7 <setupkvm>
80106972:	a3 24 48 11 80       	mov    %eax,0x80114824
  switchkvm();
80106977:	e8 18 fb ff ff       	call   80106494 <switchkvm>
}
8010697c:	c9                   	leave  
8010697d:	c3                   	ret    

8010697e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010697e:	55                   	push   %ebp
8010697f:	89 e5                	mov    %esp,%ebp
80106981:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106984:	6a 00                	push   $0x0
80106986:	ff 75 0c             	push   0xc(%ebp)
80106989:	ff 75 08             	push   0x8(%ebp)
8010698c:	e8 28 fa ff ff       	call   801063b9 <walkpgdir>
  if(pte == 0)
80106991:	83 c4 10             	add    $0x10,%esp
80106994:	85 c0                	test   %eax,%eax
80106996:	74 05                	je     8010699d <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106998:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010699b:	c9                   	leave  
8010699c:	c3                   	ret    
    panic("clearpteu");
8010699d:	83 ec 0c             	sub    $0xc,%esp
801069a0:	68 98 75 10 80       	push   $0x80107598
801069a5:	e8 97 99 ff ff       	call   80100341 <panic>

801069aa <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801069aa:	55                   	push   %ebp
801069ab:	89 e5                	mov    %esp,%ebp
801069ad:	57                   	push   %edi
801069ae:	56                   	push   %esi
801069af:	53                   	push   %ebx
801069b0:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801069b3:	e8 3f ff ff ff       	call   801068f7 <setupkvm>
801069b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
801069bb:	85 c0                	test   %eax,%eax
801069bd:	0f 84 b5 00 00 00    	je     80106a78 <copyuvm+0xce>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801069c3:	be 00 00 00 00       	mov    $0x0,%esi
801069c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801069cb:	eb 06                	jmp    801069d3 <copyuvm+0x29>
801069cd:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069d3:	3b 75 0c             	cmp    0xc(%ebp),%esi
801069d6:	0f 83 9c 00 00 00    	jae    80106a78 <copyuvm+0xce>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801069dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801069df:	83 ec 04             	sub    $0x4,%esp
801069e2:	6a 00                	push   $0x0
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
801069e6:	e8 ce f9 ff ff       	call   801063b9 <walkpgdir>
801069eb:	83 c4 10             	add    $0x10,%esp
801069ee:	85 c0                	test   %eax,%eax
801069f0:	74 db                	je     801069cd <copyuvm+0x23>
      continue; //panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801069f2:	8b 00                	mov    (%eax),%eax
801069f4:	a8 01                	test   $0x1,%al
801069f6:	74 d5                	je     801069cd <copyuvm+0x23>
      continue; //panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801069f8:	89 c2                	mov    %eax,%edx
801069fa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a00:	89 55 e0             	mov    %edx,-0x20(%ebp)
    flags = PTE_FLAGS(*pte);
80106a03:	25 ff 0f 00 00       	and    $0xfff,%eax
80106a08:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if((mem = kalloc()) == 0)
80106a0b:	e8 17 b6 ff ff       	call   80102027 <kalloc>
80106a10:	89 c7                	mov    %eax,%edi
80106a12:	85 c0                	test   %eax,%eax
80106a14:	74 4b                	je     80106a61 <copyuvm+0xb7>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a19:	05 00 00 00 80       	add    $0x80000000,%eax
80106a1e:	83 ec 04             	sub    $0x4,%esp
80106a21:	68 00 10 00 00       	push   $0x1000
80106a26:	50                   	push   %eax
80106a27:	57                   	push   %edi
80106a28:	e8 3d d4 ff ff       	call   80103e6a <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106a2d:	83 c4 04             	add    $0x4,%esp
80106a30:	ff 75 dc             	push   -0x24(%ebp)
80106a33:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106a39:	50                   	push   %eax
80106a3a:	68 00 10 00 00       	push   $0x1000
80106a3f:	ff 75 e4             	push   -0x1c(%ebp)
80106a42:	ff 75 d8             	push   -0x28(%ebp)
80106a45:	e8 e0 f9 ff ff       	call   8010642a <mappages>
80106a4a:	83 c4 20             	add    $0x20,%esp
80106a4d:	85 c0                	test   %eax,%eax
80106a4f:	0f 89 78 ff ff ff    	jns    801069cd <copyuvm+0x23>
      kfree(mem);
80106a55:	83 ec 0c             	sub    $0xc,%esp
80106a58:	57                   	push   %edi
80106a59:	e8 b2 b4 ff ff       	call   80101f10 <kfree>
      goto bad;
80106a5e:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106a61:	83 ec 08             	sub    $0x8,%esp
80106a64:	6a 01                	push   $0x1
80106a66:	ff 75 d8             	push   -0x28(%ebp)
80106a69:	e8 13 fe ff ff       	call   80106881 <freevm>
  return 0;
80106a6e:	83 c4 10             	add    $0x10,%esp
80106a71:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
}
80106a78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7e:	5b                   	pop    %ebx
80106a7f:	5e                   	pop    %esi
80106a80:	5f                   	pop    %edi
80106a81:	5d                   	pop    %ebp
80106a82:	c3                   	ret    

80106a83 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106a83:	55                   	push   %ebp
80106a84:	89 e5                	mov    %esp,%ebp
80106a86:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a89:	6a 00                	push   $0x0
80106a8b:	ff 75 0c             	push   0xc(%ebp)
80106a8e:	ff 75 08             	push   0x8(%ebp)
80106a91:	e8 23 f9 ff ff       	call   801063b9 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106a96:	8b 00                	mov    (%eax),%eax
80106a98:	83 c4 10             	add    $0x10,%esp
80106a9b:	a8 01                	test   $0x1,%al
80106a9d:	74 10                	je     80106aaf <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106a9f:	a8 04                	test   $0x4,%al
80106aa1:	74 13                	je     80106ab6 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106aa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aa8:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106aad:	c9                   	leave  
80106aae:	c3                   	ret    
    return 0;
80106aaf:	b8 00 00 00 00       	mov    $0x0,%eax
80106ab4:	eb f7                	jmp    80106aad <uva2ka+0x2a>
    return 0;
80106ab6:	b8 00 00 00 00       	mov    $0x0,%eax
80106abb:	eb f0                	jmp    80106aad <uva2ka+0x2a>

80106abd <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106abd:	55                   	push   %ebp
80106abe:	89 e5                	mov    %esp,%ebp
80106ac0:	57                   	push   %edi
80106ac1:	56                   	push   %esi
80106ac2:	53                   	push   %ebx
80106ac3:	83 ec 0c             	sub    $0xc,%esp
80106ac6:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ac9:	eb 25                	jmp    80106af0 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106acb:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ace:	29 f2                	sub    %esi,%edx
80106ad0:	01 d0                	add    %edx,%eax
80106ad2:	83 ec 04             	sub    $0x4,%esp
80106ad5:	53                   	push   %ebx
80106ad6:	ff 75 10             	push   0x10(%ebp)
80106ad9:	50                   	push   %eax
80106ada:	e8 8b d3 ff ff       	call   80103e6a <memmove>
    len -= n;
80106adf:	29 df                	sub    %ebx,%edi
    buf += n;
80106ae1:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106ae4:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106aea:	89 45 0c             	mov    %eax,0xc(%ebp)
80106aed:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106af0:	85 ff                	test   %edi,%edi
80106af2:	74 2f                	je     80106b23 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106af4:	8b 75 0c             	mov    0xc(%ebp),%esi
80106af7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106afd:	83 ec 08             	sub    $0x8,%esp
80106b00:	56                   	push   %esi
80106b01:	ff 75 08             	push   0x8(%ebp)
80106b04:	e8 7a ff ff ff       	call   80106a83 <uva2ka>
    if(pa0 == 0)
80106b09:	83 c4 10             	add    $0x10,%esp
80106b0c:	85 c0                	test   %eax,%eax
80106b0e:	74 20                	je     80106b30 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106b10:	89 f3                	mov    %esi,%ebx
80106b12:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106b15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106b1b:	39 df                	cmp    %ebx,%edi
80106b1d:	73 ac                	jae    80106acb <copyout+0xe>
      n = len;
80106b1f:	89 fb                	mov    %edi,%ebx
80106b21:	eb a8                	jmp    80106acb <copyout+0xe>
  }
  return 0;
80106b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b2b:	5b                   	pop    %ebx
80106b2c:	5e                   	pop    %esi
80106b2d:	5f                   	pop    %edi
80106b2e:	5d                   	pop    %ebp
80106b2f:	c3                   	ret    
      return -1;
80106b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b35:	eb f1                	jmp    80106b28 <copyout+0x6b>
