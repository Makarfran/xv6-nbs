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
  if(argint(0, &i) < 0) //coger el estado
   return -1;
  i = (i << 8); //se mueve 8 bits pa que no lo pille como tener error pero hay que retener el estado y tal
                //mas por el tema de que el test no pille los que usen exit como fallidos.
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
  
  if(argint(0, &n) < 0) //tamaño de cambio
    return -1;
  
  addr = myproc()->sz; //address con tamaño actual
  
  myproc()->sz = addr + n; //le sumamos el nuevo
  
  //if(growproc(n) < 0)
    // return -1;
  
  //Si es negativo (ie. liberar espacio) tiene sentido liberarlo cuanto antes en vez de que sea lazy
  //a parte de que puede que no entre en el trapframe en los tests para hacerlo de otra manera
  if(n < 0){
     deallocuvm(myproc()->pgdir, addr, myproc()->sz);
     lcr3(V2P(myproc()->pgdir));
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
  
  if(argptr(0, (void **) &ptr, sizeof(*ptr)) < 0) //cogemos el puntero de rtcdate que nos pasa el usuario 
    return -1;
  cmostime(ptr); //aplicamos cmostime que guarda el tiempo y la fecha en este
  return 0; //devolvemos 0 para mostrar que no ha habido error
}

int
sys_phmem(void){
  int pid;
  struct proc *p;
  if(argint(0, &pid) < 0) //conseguimos el pid
    return -1;
  if((p = getProcbyPID(pid)) == 0){ //conseguimos el proceso mediante su pid
  	cprintf("No existe un proceso con esa PID\n");
  	return -1;
  }
  int count = 0; //inicia cuenta a 0
  pte_t *pte;
  uint a = 0;
  for(; a  <= p->sz ; a += PGSIZE){ //vamos a ir recorriendo la tabla de paginas que va a aumentar la cuenta solo
    pte = walkpgdir(p->pgdir, (char*)a, 0); //en paginas con bit presente
    
    if((*pte & PTE_P) != 0){
      count++;
    }
  }
  
  uint end = (count*PGSIZE)/1024; //nº pag presentes * tamaño de pagina es el tamaño en bytes lo dividimos entre 1024
  cprintf("%d", end);//imprimo los kb? esto es una prueba o lo tenia que hacer, no me acuerdo
  
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

