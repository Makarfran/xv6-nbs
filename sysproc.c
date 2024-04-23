#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

pte_t *	walkpgdir(pde_t *pgdir, const void *va, int alloc);

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  int i;
  if(argint(0, &i) < 0)
   return -1;
  myproc()->status = i;
  exit(i);
  return 0;  // not reached
}

int
sys_wait(void)
{
  int* i;
  if(argptr(0, (void**)&i, sizeof(*i)) < 0)
    return -1;
  return wait(i);
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;
  
  if(argint(0, &n) < 0)
    return -1;
  
  addr = myproc()->sz;
  
  myproc()->sz = addr + n;
  
  //if(growproc(n) < 0)
    // return -1;
  
  //en casos de n negativa o neutra no parece que entre a trap.c osea que si quiero hacer deallocation tiene que ser aqui digo yo
  //pero hacerlo aqui no seria lazy allocation pero no se donde mas ponerlo de todas formas
  // que se podria argumentar que al contrario que en el caso de reservar memoria que quieres hacerlo cuando lo necesites, despejar memoria querrias hacerlo cuanto antes pero bueno.
  if(n < 0){
     deallocuvm(myproc()->pgdir, addr, myproc()->sz);
  }
  
 
  
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_date(void)
{
  struct rtcdate *ptr;
  
  if(argptr(0, (void **) &ptr, sizeof(*ptr)) < 0)
    return -1;
  cmostime(ptr);
  return 0;
}

int
sys_phmem(void){
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
    return -1;
  if((p = getProcbyPID(pid)) == 0){
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  int count = 0;
  pte_t *pte;
  uint a = 0;
  for(; a  <= p->sz ; a += PGSIZE){
    pte = walkpgdir(p->pgdir, (char*)a, 0);
    
    if((*pte & PTE_P) != 0){
      count++;
    }
  }
  
  uint end = (count*PGSIZE)/1024;
  cprintf("%d", end);
  
  return end;
}

int
sys_getprio(void){
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0)
    return -1;
  if((p = getProcbyPID(pid)) == 0){
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  
  return p->prio;
}

int
sys_setprio(void){
  int pid;
  struct proc *p;
  int trampas;
  unsigned int a;
  if(argint(0, &pid) < 0)
    return -1;
    
  if(argint(1, &trampas) < 0)
    return -1;
  a = trampas;
  if((p = getProcbyPID(pid)) == 0){
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  if(p->state == RUNNABLE){
  	setNewPrio(p, a);
  } else {
  	p->prio = a;
  }
  
  return p->prio;
}

