
bootblock.o:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	78 7c                	js     7c9e <readsect+0x12>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  xor     %eax, %eax              # Zero segments not ready for use
    7c3b:	31 c0                	xor    %eax,%eax
  movw    %ax, %fs                # -> FS
    7c3d:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3f:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c41:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c46:	e8 e5 00 00 00       	call   7d30 <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4b:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c4f:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c52:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c54:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c58:	66 ef                	out    %ax,(%dx)

00007c5a <spin>:
spin:
  jmp     spin
    7c5a:	eb fe                	jmp    7c5a <spin>
    7c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00007c60 <gdt>:
	...
    7c68:	ff                   	(bad)  
    7c69:	ff 00                	incl   (%eax)
    7c6b:	00 00                	add    %al,(%eax)
    7c6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c74:	00                   	.byte 0x0
    7c75:	92                   	xchg   %eax,%edx
    7c76:	cf                   	iret   
	...

00007c78 <gdtdesc>:
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%eax)
	...

00007c7e <waitdisk>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c7e:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c83:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c84:	83 e0 c0             	and    $0xffffffc0,%eax
    7c87:	3c 40                	cmp    $0x40,%al
    7c89:	75 f8                	jne    7c83 <waitdisk+0x5>
    ;
}
    7c8b:	c3                   	ret    

00007c8c <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c8c:	55                   	push   %ebp
    7c8d:	89 e5                	mov    %esp,%ebp
    7c8f:	57                   	push   %edi
    7c90:	50                   	push   %eax
    7c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  // Issue command.
  waitdisk();
    7c94:	e8 e5 ff ff ff       	call   7c7e <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c99:	b0 01                	mov    $0x1,%al
    7c9b:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca0:	ee                   	out    %al,(%dx)
    7ca1:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7ca6:	88 c8                	mov    %cl,%al
    7ca8:	ee                   	out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
    7ca9:	89 c8                	mov    %ecx,%eax
    7cab:	c1 e8 08             	shr    $0x8,%eax
    7cae:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cb3:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
    7cb4:	89 c8                	mov    %ecx,%eax
    7cb6:	c1 e8 10             	shr    $0x10,%eax
    7cb9:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cbe:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cbf:	89 c8                	mov    %ecx,%eax
    7cc1:	c1 e8 18             	shr    $0x18,%eax
    7cc4:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc7:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7ccc:	ee                   	out    %al,(%dx)
    7ccd:	b0 20                	mov    $0x20,%al
    7ccf:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cd4:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd5:	e8 a4 ff ff ff       	call   7c7e <waitdisk>
  asm volatile("cld; rep insl" :
    7cda:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cdd:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ce2:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce7:	fc                   	cld    
    7ce8:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7cea:	5a                   	pop    %edx
    7ceb:	5f                   	pop    %edi
    7cec:	5d                   	pop    %ebp
    7ced:	c3                   	ret    

00007cee <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7cee:	55                   	push   %ebp
    7cef:	89 e5                	mov    %esp,%ebp
    7cf1:	57                   	push   %edi
    7cf2:	56                   	push   %esi
    7cf3:	53                   	push   %ebx
    7cf4:	83 ec 0c             	sub    $0xc,%esp
    7cf7:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uchar* epa;

  epa = pa + count;
    7cfd:	8b 75 0c             	mov    0xc(%ebp),%esi
    7d00:	01 fe                	add    %edi,%esi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d02:	89 d8                	mov    %ebx,%eax
    7d04:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d09:	29 c7                	sub    %eax,%edi

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d0b:	c1 eb 09             	shr    $0x9,%ebx
    7d0e:	43                   	inc    %ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d0f:	39 f7                	cmp    %esi,%edi
    7d11:	73 15                	jae    7d28 <readseg+0x3a>
    readsect(pa, offset);
    7d13:	50                   	push   %eax
    7d14:	50                   	push   %eax
    7d15:	53                   	push   %ebx
    7d16:	57                   	push   %edi
    7d17:	e8 70 ff ff ff       	call   7c8c <readsect>
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d1c:	81 c7 00 02 00 00    	add    $0x200,%edi
    7d22:	43                   	inc    %ebx
    7d23:	83 c4 10             	add    $0x10,%esp
    7d26:	eb e7                	jmp    7d0f <readseg+0x21>
}
    7d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d2b:	5b                   	pop    %ebx
    7d2c:	5e                   	pop    %esi
    7d2d:	5f                   	pop    %edi
    7d2e:	5d                   	pop    %ebp
    7d2f:	c3                   	ret    

00007d30 <bootmain>:
{
    7d30:	55                   	push   %ebp
    7d31:	89 e5                	mov    %esp,%ebp
    7d33:	57                   	push   %edi
    7d34:	56                   	push   %esi
    7d35:	53                   	push   %ebx
    7d36:	83 ec 10             	sub    $0x10,%esp
  readseg((uchar*)elf, 4096, 0);
    7d39:	6a 00                	push   $0x0
    7d3b:	68 00 10 00 00       	push   $0x1000
    7d40:	68 00 00 01 00       	push   $0x10000
    7d45:	e8 a4 ff ff ff       	call   7cee <readseg>
  if(elf->magic != ELF_MAGIC)
    7d4a:	83 c4 10             	add    $0x10,%esp
    7d4d:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d54:	45 4c 46 
    7d57:	75 54                	jne    7dad <bootmain+0x7d>
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d59:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d5e:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d64:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7d6b:	c1 e0 05             	shl    $0x5,%eax
    7d6e:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  for(; ph < eph; ph++){
    7d71:	39 f3                	cmp    %esi,%ebx
    7d73:	73 2b                	jae    7da0 <bootmain+0x70>
    pa = (uchar*)ph->paddr;
    7d75:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d78:	50                   	push   %eax
    7d79:	ff 73 04             	push   0x4(%ebx)
    7d7c:	ff 73 10             	push   0x10(%ebx)
    7d7f:	57                   	push   %edi
    7d80:	e8 69 ff ff ff       	call   7cee <readseg>
    if(ph->memsz > ph->filesz)
    7d85:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7d88:	8b 43 10             	mov    0x10(%ebx),%eax
    7d8b:	83 c4 10             	add    $0x10,%esp
    7d8e:	39 c1                	cmp    %eax,%ecx
    7d90:	76 09                	jbe    7d9b <bootmain+0x6b>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7d92:	01 c7                	add    %eax,%edi
    7d94:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7d96:	31 c0                	xor    %eax,%eax
    7d98:	fc                   	cld    
    7d99:	f3 aa                	rep stos %al,%es:(%edi)
  for(; ph < eph; ph++){
    7d9b:	83 c3 20             	add    $0x20,%ebx
    7d9e:	eb d1                	jmp    7d71 <bootmain+0x41>
}
    7da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7da3:	5b                   	pop    %ebx
    7da4:	5e                   	pop    %esi
    7da5:	5f                   	pop    %edi
    7da6:	5d                   	pop    %ebp
  entry();
    7da7:	ff 25 18 00 01 00    	jmp    *0x10018
}
    7dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7db0:	5b                   	pop    %ebx
    7db1:	5e                   	pop    %esi
    7db2:	5f                   	pop    %edi
    7db3:	5d                   	pop    %ebp
    7db4:	c3                   	ret    
