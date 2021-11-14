.data 0x10001000
#Punteros a listas
slist: .word 0 #Puntero al primer nodo de la lista de objetos eliminados
cclist: .word 0 #Puntero al primer nodo de la lista de categorias
wclist: .word 0 #Puntero a la categoria seleccionada

#Textos
opc0: .asciiz "\n---------------------------------------------------|\nMenu principal: \n1) Crear categoria \n2) Pasar a categoria siguiente \n3) Volver a categoria anterior \n4) Listar categorias \n5) Borrar categoria seleccionada \n6) Anexar un objeto a la categoria seleccionada \n7) Borrar objeto \n8) Listar objetos de la categoria seleccionada \n9) Salir \n\n"
consulta: .asciiz "Ingrese una opcion: "
opc1: .asciiz "Ingrese nombre de la categoria: "
opc2: .asciiz "Ingrese nombre del objeto: "
opc3: .asciiz "Ingrese una ID de un objeto a eliminar: "
msj1: .asciiz "Fin del programa!"
msj2: .asciiz "Se ha avanzado a la categoria siguiente!"
msj3: .asciiz "Se ha retrocedido a la categoria anterior!"
msj4: .asciiz "La lista de categoria(s) es:\n\n"
msj5: .asciiz "No hay categorias que mostrar :("
msj6: .asciiz "Se ha eliminado la categoria seleccionada!"
msj7: .asciiz "No hay categorias creadas :("
msj8: .asciiz "Se ha aniadido el objeto a la categoria seleccionada!"
msj9: .asciiz "Se ha eliminado el objeto indicado!"
msj10: .asciiz "\nHa ingresado un id incorrecto!"
msj11: .asciiz "No hay objetos en la categoria seleccionada!"
msj12: .asciiz "La lista de objeto(s) de la categoria seleccionada es:\n"
msj13: .asciiz "Ha ingresado una opcion incorrecta!"

ast: .asciiz "*"
pun: .asciiz ". "
salto: .asciiz "\n"

.text
main:
addi $sp, $sp, -4 #Guardo $ra
sw $ra, 0($sp)

#Menu
while2: 
    li $v0, 4
    la $a0, opc0 #Muestro el menu
    syscall

    li $v0, 4
    la $a0, consulta #"Ingrese una opcion: "
    syscall
    jal saltodelinea

    li $v0, 5 #Leo la opcion ingresada
    syscall 
    move $t0, $v0 #Muevo la opcion a un temporal
    
    jal saltodelinea

    #Verifico que opcion ha ingresado
    li $t1, 1
    li $t2, 9
    blt $t0,$t1,opc #Verifico que la opcion ingresada esté entre 1 y 9
    bgt $t0,$t2,opc 
    j finif18

    opc:
    li $v0, 4
    la $a0, msj13 #"Ha ingresado una opcion incorrecta!"
    syscall
    jal saltodelinea 
    j while2

  	 finif18:
    beq $t0, 1, opcion1 #Crear categoria
    beq $t0, 2, opcion2 #Pasar a categoria siguiente
    beq $t0, 3, opcion3 #Volver a categoria anterior
    beq $t0, 4, opcion4 #Listar categorias
    beq $t0, 5, opcion5 #Borrar categoria seleccionada
    beq $t0, 6, opcion6 #Anexar un objeto a la categoria seleccionada
    beq $t0, 7, opcion7 #Borrar objeto
    beq $t0, 8, opcion8 #Listar objetos de la categoria seleccionada
    beq $t0, 9, finwhile2 #Salir
    opcion1: 
    li $v0, 4
    la $a0, opc1 #"Ingrese nombre de la categoria": 
    syscall
    jal saltodelinea 

    jal smalloc #Pido un bloque de memoria

    move $a0, $v0 #Muevo la direccion del bloque obtenido a $a0
    li $v0, 8  #Guardo el nombre de la nueva categoria en el bloque creado
    syscall
    jal newcategory #Obtengo la nueva categoria
    j while2

    opcion2: 
    jal nextcategory
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente

    bne $v0, $0, finif15
    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    j while2

    finif15:
    li $v0, 4
    la $a0, msj2 #"Se ha avanzado a la categoria siguiente!"
    syscall
    jal saltodelinea
    j while2

    opcion3: 
    jal prevcategory
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente

    bne $v0, $0, finif16
    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    j while2

    finif16:
    li $v0, 4
    la $a0, msj3 #"Se ha retrocedido a la categoria anterior!"
    syscall
    jal saltodelinea
    j while2

    opcion4:
    li $v0, 4
    la $a0, msj4 #"La lista de categoria(s) es:"
    syscall
    jal listarcategory 
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente

    bne $v0, $0, finif6  #Verifico si hay categorias creadas

    li $v0, 4
    la $a0, msj5 #"No hay categorias que mostrar :("
    syscall
    jal saltodelinea
    finif6:
    j while2

    opcion5: 
    jal delcategory
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente

    bne $v0, $0, finif7 #Verifico si hay categorias creadas
    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    j while2
    finif7:
    li $v0, 4
    la $a0, msj6 #"Se ha eliminado la categoria seleccionada!"
    syscall
    jal saltodelinea

    j while2

    opcion6:
    jal newobject 
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente

    bne $v0, $0, finif8 #Verifico si hay categorias creadas
    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    j while2
    finif8:

    jal saltodelinea
    li $v0, 4
    la $a0, msj8 #"Se ha aniadido el objeto a la categoria seleccionada!"
    syscall
    jal saltodelinea
    j while2

    opcion7:
    jal delobject #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente
    #'3' si es que ha ingresado un id incorrecto o que no existe
    #'4' si es que no hay objetos en la categoria seleccionada

    bne $v0, $0, finif9
    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    j while2
    finif9:

    li $t0, 3
    bne $v0, $t0, finif10
    li $v0, 4
    la $a0, msj10 #"Ha ingresado un id incorrecto!"
    syscall
    jal saltodelinea
    j while2
    finif10:
    li $t0, 4
    bne $v0, $t0, finif11
    li $v0, 4
    la $a0, msj11 #"No hay objetos en la categoria seleccionada!"
    syscall
    jal saltodelinea
    j while2
    finif11:

    jal saltodelinea
    li $v0, 4
    la $a0, msj9 #"Se ha eliminado el objeto indicado!"
    syscall
    jal saltodelinea
    j while2

    opcion8:
    li $v0, 4
    la $a0, msj12 #"La lista de objeto(s) de la categoria seleccionada es:"
    syscall
    jal saltodelinea

    jal listarobject
    #Devuelve a $v0 con:
    #'1' si es que hay categorias creadas anteriormente
    #'0' si es que no hay categorias creadas anteriormente
    #'3' si es que no hay objetos en la categoria seleccionada

    bne $v0, $0, finif12

    li $v0, 4
    la $a0, msj7 #"No hay categorias creadas :("
    syscall
    jal saltodelinea
    finif12:

    li $t0, 3
    bne $v0, $t0, while2
    li $v0, 4
    la $a0, msj11 #"No hay objetos en la categoria seleccionada!"
    syscall
    jal saltodelinea
    j while2

finwhile2:


jal saltodelinea
li $v0, 4
la $a0, msj1 #"Fin del programa!"
syscall


lw $ra,0($sp) #Vuelvo a cargar $ra
addi $sp, $sp, 4
jr $ra

saltodelinea:
   li $v0, 4
   la $a0, salto #"\n"
   syscall
   jr $ra

listarcategory:
	lw $t1, cclist($0) #Cargo la direccion del primer nodo de la lista de categorias
	li $v0, 0 
	beq $t1, $0, finloop2 #Verifico si hay algun nodo en la lista de categorias
	lw $t2, cclist($0) #Cargo la direccion del primer nodo de la lista de categorias
	lw $t3, wclist($0) #Cargo la direccion de la categoria seleccionada
	loop2:
		bne $t2, $t3, finif5 #Verifico si la categoria a mostrar es la seleccionada

		li $v0, 4
		la $a0, ast #"*"
		syscall

		finif5:

		li $v0, 4
		lw $a0, 8($t2) #Muestro el nombre de la categoria
		syscall

		li $v0, 4
		la $a0, salto #"\n"
		syscall

		lw $t2, 12($t2) #Cargo la direccion del siguiente nodo
		li $v0, 1

		beq $t2, $t1, finloop2 #Verifico si ya recorri la lista entera
		j loop2
	finloop2:
	jr $ra

listarobject:
	lw $t1, wclist($0) #Cargo la direccion de la categoria seleccionada
	li $v0, 0
	beq $t1, $0, finloop3 #Verifico si hay algun nodo en la lista de categorias
	li $v0, 3

	lw $t1, 4($t1)
	beq $t1, $0, finloop3 #Verifico si hay algun nodo en la lista de objetos en la categoria seleccionada

	move $t2, $t1

	loop3:
		li $v0, 1
		lw $a0, 4($t2) #Muestro la ID del objeto actual
		syscall

		li $v0, 4
		la $a0, pun #". "
		syscall
		li $v0, 4
		lw $a0, 8($t2) #Muestro el nombre del objeto actual
		syscall
		

		li $v0, 4
		la $a0, salto #"\n "
		syscall

		lw $t2, 12($t2) #Cargo la direccion del siguiente nodo

		li $v0, 1
		beq $t2, $t1, finloop3 #Verifico si ya recorri la lista entera
		j loop3
	finloop3:
	jr $ra

nextcategory:
	li $v0, 0
	lw $t0, wclist #Cargo la direccion de la categoria seleccionada
	beq $t0, $0, finif14 #Verifico si hay algun nodo en la lista de categorias
	li $v0, 1
	lw $t1, 12($t0) #Cargo la direccion de la siguiente categoria
	sw $t1, wclist #Actualizo la categoria seleccionada
	finif14:
	jr $ra

prevcategory:
	li $v0, 0
	lw $t0, wclist #Cargo la direccion de la categoria seleccionada
	beq $t0, $0, finif17 #Verifico si hay algun nodo en la lista de categorias
	li $v0, 1
	lw $t1, 0($t0) #Cargo la direccion de la categoria anterior
	sw $t1, wclist #Actualizo la categoria seleccionada
	finif17:
	jr $ra

newcategory:
	move $t7, $a0 #Muevo el argumento a un temporal

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal smalloc #Pido un bloque de memoria

	li $t4, 0
	sw $t4, 4($v0) #Inicializo la direccion a la lista de objetos en 0
	sw $t7, 8($v0) #Cargo la direccion del nodo con el nombre de la categoria
	
	lw $t1, cclist #Cargo la direccion del primer nodo de la lista de categorias
	sw $v0, cclist #Actualizo dicha direccion
	beq $t1, $0, first #Verifico si ya habia categorias


	lw $t3, 0($t1) #Cargo la direccion del nodo anterior
	sw $t3, 0($v0) #La guardo en el nodo nuevo
	sw $v0, 12($t3) #Actualizo la parte del nodo siguiente del nodo anterior con el nodo nuevo
	sw $v0, 0($t1) #Actualizo la parte del nodo anterior del nodo siguiente con el nodo nuevo
	sw $t1, 12($v0) #Actualizo la parte del nodo siguiente del nodo nuevo con el nodo correspondiente

	j fin

	first: 
	sw $v0, 0($v0) #Al ser el primer nodo, tiene que apuntarse a si mismo
	sw $v0, 12($v0) 
	sw $v0, wclist #Actualizo la direccion de la categoria seleccionada con el nodo nuevo

	fin:
	lw $ra,0($sp)
	addi $sp, $sp, 4
	jr $ra

newobject:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 0

	lw $t1, wclist($0) #Cargo la direccion de la categoria seleccionada
	beq $t1, $0, fin5 #Verifico si hay algun nodo en la lista de categorias

	li $v0, 4
	la $a0, opc2 #"Ingrese nombre del objeto: "
	syscall
	jal saltodelinea
	
	jal smalloc #Pido un bloque de memoria

	move $a0, $v0 #Muevo la direccion del bloque obtenido a $a0
   li $v0, 8  #Guardo el nombre de la nueva categoria en el bloque creado
	syscall

	move $t7, $a0 #Muevo el argumento a un temporal

	jal smalloc #Pido un bloque de memoria


	sw $t7, 8($v0) #Guardo la direccion del nodo con el nombre del objeto
	lw $t1, wclist($0) #Cargo la direccion de la categoria seleccionada
	lw $t1, 4($t1) #Cargo la direccion de la lista de objetos de dicha categoria

	beq $t1, $0, first2 #Verifico si hay objetos en la lista

	lw $t3, 0($t1) #Cargo la direccion del nodo anterior
	sw $t3, 0($v0) #La guardo en el nodo nuevo
	sw $v0, 12($t3) #Actualizo la parte del nodo siguiente del nodo anterior con el nodo nuevo
	sw $v0, 0($t1) #Actualizo la parte del nodo anterior del nodo siguiente con el nodo nuevo
	sw $t1, 12($v0) #Actualizo la parte del nodo siguiente del nodo nuevo con el nodo correspondiente

	lw $t4, 4($t1) #Cargo la ID del nodo siguiente
	addi $t4, $t4, 1 #Le sumo 1
	sw $t4, 4($v0) #Actualizo la ID del nuevo nodo

	j fin2

	first2: 
	sw $v0, 0($v0) #Al ser el primer nodo, tiene que apuntarse a si mismo
	sw $v0, 12($v0)
	li $t4, 1 
	sw $t4, 4($v0) #Actualizo la ID del nuevo nodo con '1'

	fin2:
	lw $t1, wclist($0) #Cargo la direccion de la categoria seleccionada
	sw $v0, 4($t1) #Actualizo la direccion que apunta a la lista de objetos
	li $v0, 1

	fin5:
	lw $ra,0($sp)
	addi $sp, $sp, 4
	jr $ra

delcategory:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t6, 0
	li $v0, 0

	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada
	beq $t7, $0, fin4 #Verifico si hay algun nodo en la lista de categorias

	li $v0, 1
	lw $t7, 4($t7) #Cargo la direccion de la lista de objetos de dicha categoria
	beq $t7, $0, finloop #Verifico si hay objetos en la lista
	move $t1, $t7

	loop:
		lw $t3, 12($t1) #Cargo la direccion del siguiente nodo

		lw $t0, 8($t1) #Cargo la direccion del nodo que contiene el nombre del objeto
		move $a0, $t0 
		jal sfree #Libero ese nodo

		move $a0, $t1
		jal sfree #Libero el nodo del objeto

		move $t1, $t3 #Avanza al siguiente

		beq $t7, $t1, finloop #Verifico si recorri toda la lista
		j loop
	finloop:
	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada
	lw $t3, cclist($0) #Cargo la direccion del primer nodo de la lista de categorias

	lw $t4, 12($t7) #Cargo la direccion del siguiente nodo
	bne $t4, $t7, finif4 #Si la direccion del siguiente nodo es igual a la categoria seleccionada, es porque hay 1 sola categoria
	sw $0, cclist #Pongo en 0 a la direccion del primer nodo de la lista de categorias
	j fin3
	finif4:
	bne $t3, $t7, finif3 #Verifico la categoria a borrar es la primera de la lista
	lw $t1, 12($t7) #Cargo la direccion del siguiente nodo
	sw $t1, cclist #Actualizo la direccion del primer nodo de la lista de categorias 
	finif3:
	lw $t1, 12($t7) #Cargo la direccion del siguiente nodo
	lw $t2, 0($t7) #Cargo la direccion del nodo anterior

	sw $t2, 0($t1) #Actualizo la parte de la direccion del nodo anterior del nodo anterior
	sw $t1, 12($t2) #Actualizo la parte de la direccion del siguiente nodo del nodo siguiente

	move $t6, $t1 
	fin3:
	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada

	lw $t0, 8($t7) #Cargo la direccion del nodo que contiene el nombre de la categoria
	move $a0, $t0 
	jal sfree #Libero dicho nodo

	move $a0, $t7
	jal sfree #Libero el nodo de la categoria

	sw $t6, wclist($0) #Actualizo la direccion de la categoria seleccionada con la siguiente categoria

	fin4:
	lw $ra,0($sp)
	addi $sp, $sp, 4
	jr $ra

delobject:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 0

	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada
	beq $t7, $0, finwhile #Verifico si hay algun nodo en la lista de categorias
	li $v0, 4
	lw $t0, 4($t7) #Cargo la direccion de la lista de objetos de dicha categoria
	beq $t0, $0, finwhile #Verifico si hay objetos en la lista

	li $v0, 4
   la $a0, opc3 #"Cargo la direccion de la categoria seleccionada"
   syscall
   jal saltodelinea
     
   li $v0, 5 #Leo la ID ingresada
   syscall

   move $t4, $v0 #Muevo la ID a un temporal


	li $v0, 3

	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada
	lw $t1, 4($t7) #Cargo la direccion de la lista de objetos de dicha categoria

	lw $t2, 12($t1) #Cargo la direccion del siguiente nodo
	lw $t3, 0($t1) #Cargo la direccion del nodo anterior
	bne $t3, $t1, finif2 #Verifico si hay un solo nodo en la lista

	lw $t2, 4($t1) #Cargo la ID de del objeto
	bne $t4, $t2, finwhile #Veo si es la ID que buscaba

	li $v0, 1
	sw $0, 4($t7) #Pongo en 0 la parte de la direccion a la lista de objetos de la categoria seleccionada

	lw $t0, 8($t1) #Cargo la direccion al nodo que contiene el nombre del objeto
	move $a0, $t0
	jal sfree #Libero dicho nodo
	move $a0, $t1
	jal sfree #Libero el nodo del objeto
	j finwhile
	finif2:

	lw $t2, 4($t1) #Cargo la ID del primer objeto de la lista
	bne $t2, $t4, while #Veo si es la ID que buscaba

	lw $t3, 12($t1) #Cargo la direccion del siguiente nodo
	lw $t7, wclist($0) #Cargo la direccion de la categoria seleccionada
	sw $t3, 4($t7) #Actualizo la parte de la direccion de la lista de objetos de dicho categoria
	move $t7, $t1

	while:
		lw $t2, 4($t1) #Cargo la ID del objeto actual
		bne $t2, $t4, finif #Veo si es la ID que buscaba
		li $v0, 1

		lw $t6, 0($t1) #Cargo la direccion del nodo anterior
		lw $t5, 12($t1) #Cargo la direccion del nodo siguiente
		sw $t5, 12($t6) #Actualizo la parte de la direccion al nodo siguiente del nodo anterior
		sw $t6, 0($t5) #Actualizo la parte de la direccion al nodo anterior del nodo siguiente

		lw $t0, 8($t1) #Cargo la direccion al nodo que contiene el nombre del objeto
		move $a0, $t0
		jal sfree #Libero dicho nodo
		move $a0, $t1 
		jal sfree #Libero el nodo del objeto

		j finwhile
		finif:

		lw $t3, 12($t1) #Cargo la direccion del siguiente nodo
		move $t1, $t3

		beq $t7, $t1, finwhile #Verifico si recorri toda la lista
		j while
	finwhile:

	lw $ra,0($sp)
	addi $sp, $sp, 4
	jr $ra

smalloc:
	lw $t0, slist #Cargo la direccion de la lista de nodos eliminados
	beqz $t0, sbrk #Si no hay nodos disponibles pide un bloque
	move $v0, $t0 
	lw $t0, 12($t0) #Cargo la direccion del siguiente nodo disponible
	sw $t0, slist #Actualizo la direccion a la lista de nodos eliminados
	jr $ra
sbrk:
	li $a0, 16 #Pido un nodo de 16 bytes de tamaño (4 palabras)
	li $v0, 9
	syscall #Devuelvo la direccion de dicho nodo en $v0
	jr $ra
sfree:
	lw $t0, slist #Cargo la direccion de la lista de nodos eliminados
	sw $t0, 12($a0) #Actualizo parte del nodo siguiente del nodo a eliminar con el primer nodo (o 0) de dicha lista
	sw $a0, slist #Actualizo la direccion a la lista de nodos eliminados
	jr $ra