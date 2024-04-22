# xv6-nbs
##ESTADO

###Boletin 2

####Date - done

####dup2 - done

####exitwait - done(~) solo salen como 60 procesos en el test pero segun codigo deberian ser mas. parece tener mas que ver con fork pero tendre que revisarlo

###Boletin 3

##1 la base -done. va sbrk basico

##2 advanced lazy
###negative alloc- va? los test van raros con los valores que imprime (coge como 1 de valor por defecto cuando deberia ser 0, no tengo ni idea de por que pasa, pero te podria decir que va lo de el alloc negativo por trastear yo mismo con los tests)
##handling of errors, me falta pillar el de la guarda pero en verdad tengo que ver mas lo de error code
## lo del read (test tsbrk3) va? el ir va, la cosa es que no le he hecho nada especifico para que lo haga
## tsbrk2 -> el recursivo imprime puntos hasta que se pasa del espacio que tiene, esto lo pilla un panic normalmente, lo he quitado y va a mas hasta que lo pilla nuestro handler de que se pasa de listo. trasteando con lo del codigo de error es uno de los puntos donde el codigo de error es un 0x07, como el de tsbrk5 de la pagina de guarda
##tsbrk, que vaya el fork no se ni por donde cogerlo

## boletin 4
1: esta hecho, el xv6 tira asi que en principio va (he probao que tire al menos ls pero vamos ahora mismo funciona todo con prioridad 5, esto se cambia con lo de las sys calls del 2
2: hay que hacer las llamadas al sistema

## extra phmem -donde
