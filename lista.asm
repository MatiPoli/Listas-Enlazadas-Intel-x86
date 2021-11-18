global _start

section .data
    slist dd 0x00000000
    cclist dd 0x00000000
    wclist dd 0x00000000

opc0 db "\n---------------------------------------------------|\nMenu principal: \n1) Crear categoria \n2) Pasar a categoria siguiente \n3) Volver a categoria anterior \n4) Listar categorias \n5) Borrar categoria seleccionada \n6) Anexar un objeto a la categoria seleccionada \n7) Borrar objeto \n8) Listar objetos de la categoria seleccionada \n9) Salir \n\n",0xa, 0xd,'$'
len0 equ $-opc0


consulta db "Ingrese una opcion: ",0xa, 0xd,'$'
lenc equ $-consulta

opc1 db "Ingrese nombre de la categoria: ",0xa, 0xd,'$' ;El 0xa es para salto de linea y el 0xd es para que el cursor vuelva a la posicion 0 
len1 equ $-opc1

opc2 db "Ingrese nombre del objeto: ",0xa, 0xd,'$'
len2 equ $-opc2

opc3 db "Ingrese una ID de un objeto a eliminar: ",0xa, 0xd,'$'
len3 equ $-opc3

msj1 db "Fin del programa!",0xa, 0xd,'$'
lenm1 equ $-msj1

msj2 db "Se ha avanzado a la categoria siguiente!",0xa, 0xd,'$'
lenm2 equ $-msj2

msj3 db "Se ha retrocedido a la categoria anterior!",0xa, 0xd,'$'
lenm3 equ $-msj3

msj4 db "La lista de categoria(s) es:",0xa, 0xa, 0xd,'$'
lenm4 equ $-msj4

msj5 db "No hay categorias que mostrar :(",0xa, 0xd,'$'
lenm5 equ $-msj5

msj6 db "Se ha eliminado la categoria seleccionada!",0xa, 0xd,'$'
lenm6 equ $-msj6

msj7 db "No hay categorias creadas :(",0xa, 0xd,'$'
lenm7 equ $-msj7

msj8 db "Se ha aniadido el objeto a la categoria seleccionada!",0xa, 0xd,'$'
lenm8 equ $-msj8

msj9 db "Se ha eliminado el objeto indicado!",0xa, 0xd,'$'
lenm9 equ $-msj9

msj10 db 0xa,"Ha ingresado un id incorrecto!",0xa, 0xd,'$'
lenm10 equ $-msj10

msj11 db "No hay objetos en la categoria seleccionada!",0xa, 0xd,'$'
lenm11 equ $-msj11

msj12 db "La lista de objeto(s) de la categoria seleccionada es:",0xa, 0xa, 0xd,'$'
lenm12 equ $-msj12

msj13 db "Ha ingresado una opcion incorrecta!",0xa, 0xd,'$'
lenm13 equ $-msj13

break dd 0x00000000

ast db "*"

pun db ". "
lenpun equ $-pun

salto db "\n",'$'
lensalto equ $-salto

section .bss
user_input resb 25    ; user input
 user_input_length equ $- user_input

user_input1 resb 1    ; user input
 user_input_length1 equ $- user_input1

outputBuffer    resb    4     


section .text
 global _start
_start:


;-------------------------------------------
;Falta pasar esto
;main:
;addi $sp, $sp, -4 #Guardo $ra
;sw $ra, 0($sp)
;-------------------------------------------


while2:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, opc0 ;Muestro menu
      mov edx, len0
      int 0x80 

      mov eax, 4  
      mov ebx, 1  
      mov ecx, consulta ;"Ingrese una opcion: "
      mov edx, lenc
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
         
      mov  eax, 3 ; sys_read
      mov  ebx, 0 ; stdin
      mov  ecx, user_input ; user input
      mov  edx, user_input_length ; max length
      int  80h
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------

      mov eax, 0;
      jmp opcion1
      retorno1:
      jmp opcion4
      retorno4:
      jmp finwhile2
      mov eax, [user_input]

      sub eax, 0x30
      cmp eax,1 ;compare               ;https://www.youtube.com/watch?v=cFGJhn97e3s&list=PLmxT2pVYo5LB5EzTPZGfFN0c2GDiSXgQe&index=2
      jl opc  ;Jump if less
      cmp eax,9 ;compare
      jg opc ;Jump if greater

      jmp finif18


      opc:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj13 ;"Ha ingresado una opcion incorrecta!"
      mov edx, lenm13
      int 0x80 
      call saltodelinea
      jmp while2
      finif18:
      cmp eax,1
      je opcion1
      cmp eax,2
      je opcion2
      cmp eax,3
      je opcion3
      cmp eax,4
      je opcion4
      cmp eax,5
      je opcion5
      cmp eax,6
      je opcion6
      cmp eax,7
      je opcion7
      cmp eax,8
      je opcion8
      cmp eax,9
      je finwhile2

      opcion1:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, opc1 ;"Ingrese nombre de la categoria: "
      mov edx, len1
      int 0x80
      ;-------------------------------------------
      call saltodelinea


      ;jal smalloc #Pido un bloque de memoria

      ;move $a0, $v0 #Muevo la direccion del bloque obtenido a $a0
      ;li $v0, 8  #Guardo el nombre de la nueva categoria en el bloque creado
      ;syscall
      ;-------------------------------------------
      call smalloc

      push eax

      mov  ecx, eax ; user input
      mov  eax, 3 ; sys_read
      mov  ebx, 0 ; stdin
      mov  edx, 16 ; max length
      int  80h
      pop eax

      call newcategory ;Obtengo la nueva categoria            ;PONER UN RET CUANDO HAGAN FUNCIONES CON CALL
      ;jmp while2
      jmp retorno1

      opcion2:
      call nextcategory
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp esi,0
      jne finif15
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif15:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj2 ;"Se ha avanzado a la categoria siguiente!"
      mov edx, lenm2
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2


      opcion3:
      call prevcategory
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp esi,0
      jne finif16
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif16:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj3 ;"Se ha retrocedido a la categoria anterior!"
      mov edx, lenm3
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      opcion4:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj4 ;"La lista de categoria(s) es:"
      mov edx, lenm4
      int 0x80
      call listarcategory 
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp esi,0
      jne finif6 ;Verifico si hay categorias creadas

      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj5 ;"No hay categorias que mostrar :("
      mov edx, lenm5
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------

      finif6:
      ;jmp while2
      jmp retorno4

      opcion5:
      call delcategory
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp esi, 0
      jne finif7
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif7:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj6 ;"Se ha eliminado la categoria seleccionada!"
      mov edx, lenm6
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2


      opcion6:
      call newobject
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp esi, 0
      jne finif8
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif8:
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj8 ;"Se ha aniadido el objeto a la categoria seleccionada!"
      mov edx, lenm8
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2


      opcion7:
      call delobject ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente
      ;'3' si es que ha ingresado un id incorrecto o que no existe
      ;'4' si es que no hay objetos en la categoria seleccionada

      cmp esi,0
      jne finif9
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif9:
      cmp esi,3
      jne finif10
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj10 ;"Ha ingresado un id incorrecto!"
      mov edx, lenm10
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif10:
      cmp esi,4
      jne finif11
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj11 ;"No hay objetos en la categoria seleccionada!"
      mov edx, lenm11
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

      finif11:
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj9 ;"Se ha eliminado el objeto indicado!"
      mov edx, lenm9
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2




      opcion8:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj12 ;"La lista de objeto(s) de la categoria seleccionada es:"
      mov edx, lenm12
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------

      call listarobject
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente
      ;'3' si es que no hay objetos en la categoria seleccionada

      cmp esi ,0
      jne finif12

      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj7 ;"No hay categorias creadas :("
      mov edx, lenm7
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------

      finif12:
      cmp esi,3
      jne while2
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj11 ;"No hay objetos en la categoria seleccionada!"
      mov edx, lenm11
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      jmp while2

   finwhile2:
   ;-------------------------------------------
   call saltodelinea
   ;-------------------------------------------
   mov eax, 4  
   mov ebx, 1  
   mov ecx, msj1 ;"Fin del programa!"
   mov edx, lenm1
   int 0x80
   ;-------------------------------------------
   ;lw $ra,0($sp) #Vuelvo a cargar $ra
   ;addi $sp, $sp, 4
   ;jr $ra
   ;-------------------------------------------
   mov eax, 1
   mov ebx, 0
   int 0x80

saltodelinea:
	mov eax, 4  
	mov ebx, 1  
	mov ecx, salto ;"Ingrese una opcion: "
	mov edx, lensalto
	int 0x80
	ret


listarcategory:
    mov esi, 0
    mov ebp, esp
    mov eax, [cclist]

    cmp eax, 0
    je finloop2
    loop2:

        mov ebx, [wclist]
        mov eax, [cclist]
        cmp eax, ebx
        push eax
        jne finif5

        mov eax, 4
        mov ebx, 1
        mov ecx, ast
        mov edx, 1
        int 0x80

        finif5:
            
            mov ebx, 1
            mov eax, [cclist]
            mov ecx, [eax+8]
            mov eax, 4
            mov edx, 16
            int 0x80

            mov eax, 4
            mov ebx, 1
            mov ecx, salto
            mov edx, lensalto
            int 0x80

            mov eax, [cclist]
            mov eax, [eax+12]

            mov esi, 1

            cmp eax, [cclist]
            je finloop2
            jmp loop2
    finloop2:
    mov esp, ebp
    ret

listarobject:
    mov esi, 0
    mov ebp, esp

    mov eax, [cclist]
    cmp eax, 0
    je finloop3
    mov esi, 3

    mov eax, [eax+4]
    cmp eax, 0
    je finloop3

    push eax
    mov edi, eax

    loop3:
        pop eax
        push eax
        mov eax, [eax+4]
        add eax, 0x30
        mov [outputBuffer], eax
        mov eax, 4
        mov ebx, 1
        mov ecx, outputBuffer
        mov edx, 1
        int 0x80

        mov eax, 4
        mov ebx, 1
        mov ecx, pun
        mov edx, lenpun
        int 0x80

        pop eax
        push eax
        mov ecx, [eax+8]
        mov eax, 4
        mov ebx, 1
        mov edx, 16
        int 0x80


        mov eax, 4
        mov ebx, 1
        mov ecx, salto
        mov edx, lensalto
        int 0x80


        pop eax
        mov eax, [eax+12]
        push eax
        mov esi, 1
        cmp eax, edi
        je finloop3
        jmp loop3
    finloop3:
    mov esp, ebp
    ret


nextcategory:
      mov esi, 0
      mov ebx, [wclist] ;Cargo la direccion de la categoria seleccionada, iria [wclist] si fuera el contenido
      cmp ebx, 0
      je finif14 ;Verifico si hay algun nodo en la lista de categorias

      mov esi, 1
      mov ecx, [ebx+12] ;Cargo la direccion de la siguiente categoria
      mov [wclist], ecx

      finif14:
      ret

prevcategory:
      mov esi, 0
      mov ebx, [wclist] ;Cargo la direccion de la categoria seleccionada
      cmp ebx, 0
      je finif17

      mov esi, 1
      mov ecx, [ebx]
      mov [wclist], ecx 

      finif17:
      ret



newcategory:
      mov ebp, esp

      mov edx, eax ; para que no se pierda en la llamada

      call smalloc

      ;LO QUE RETORNA SMALLOC POR DEFECTO DEBERIA ESTAR EN EAX
      mov ecx, eax
	 ;vuelve a ser el argumento de la funcion

      ;SUPONGO Q V0 (LO QUE RETORNO SMALLOC ES ecx)
      mov dword [ecx+4], 0
      mov [ecx+8], edx

      ;dejo de usar t7(eax) y t4(ebx), los puedo reutilizar

      ; t1 = eax
      mov edx, [cclist] ;Cargo la direccion del primer nodo de la lista de categorias
      mov [cclist], ecx ;Actualizo dicha direccion
      cmp edx, 0
      je first ;Verifico si ya habia categorias

      ;t3 = ebx
      mov ebx, [edx] ;Cargo la direccion del nodo anterior
      mov [ecx], ebx ;La guardo en el nodo nuevo
      mov [ebx + 12], ecx ;Actualizo la parte del nodo siguiente del nodo anterior con el nodo nuevo
      mov [edx], ecx ;Actualizo la parte del nodo anterior del nodo siguiente con el nodo nuevo
      mov [ecx + 12], edx ;Actualizo la parte del nodo siguiente del nodo nuevo con el nodo correspondiente

      jmp fin

      first:
      mov [ecx], ecx ;Al ser el primer nodo, tiene que apuntarse a si mismo
      mov [ecx + 12], ecx
      mov [wclist], ecx ;Actualizo la direccion de la categoria seleccionada con el nodo nuevo

      fin:
      mov esp, ebp
      ret

newobject:
	mov ebp, esp
      ;v0 es esi
      mov esi, 0

      ;t1 es ebx
      mov ebx, [wclist] ;Cargo la direccion de la categoria seleccionada
      cmp ebx, 0
      je fin5 ;Verifico si hay algun nodo en la lista de categorias

      mov esi, 4  
      mov ebx, 1  
      mov ecx, opc2 ;"Ingrese nombre del objeto: "
      mov edx, len2
      int 0x80
      ;-------------------------------------------
      call saltodelinea
      ;-------------------------------------------
      
      call smalloc ;Pido un bloque de memoria

      ;SUPONGO Q LO QUE RETORNO SMALLOC ESTA EN EAX

      mov  ecx, eax
      mov  eax, 3 ; sys_read
      mov  ebx, 0 ; stdin
      mov  edx, 16 ; max length
      int  80h

      ;t7 es ebx
      mov ebx, eax

      call smalloc ;Pido un bloque de memoria


      mov [eax + 8], ebx ;Guardo la direccion del nodo con el nombre del objeto
      mov ecx, [wclist] ;Cargo la direccion de la categoria seleccionada (ECX es t1)
      mov ecx, [ecx + 4] ;Cargo la direccion de la lista de objetos de dicha categoria

      ;DEBERIA GUARDAR EAX (DESPUES LO HAGO)
      cmp ecx, 0
      je first2 ;Verifico si hay objetos en la lista

      ;EBX es t3 y EAX es v0
      mov ebx, [ecx] ;Cargo la direccion del nodo anterior
      mov [eax], ebx ;La guardo en el nodo nuevo
      mov [ebx + 12], eax ;Actualizo la parte del nodo siguiente del nodo anterior con el nodo nuevo
      mov [ecx ], eax ;Actualizo la parte del nodo anterior del nodo siguiente con el nodo nuevo
      mov [eax + 12], ecx ;Actualizo la parte del nodo siguiente del nodo nuevo con el nodo correspondiente

      ;EDX es t4
      mov edx, [ecx + 4] ;Cargo la ID del nodo siguiente
      add edx, 1 ;Le sumo 1
      mov [eax + 4], edx ;Actualizo la ID del nuevo nodo

      jmp fin2 ;eax y ebx van a ser distintos, entonces salto a fin2

      first2: 
      mov [eax], eax ;Al ser el primer nodo, tiene que apuntarse a si mismo
      mov [eax + 12], eax
      mov dword [eax + 4], 1 ;Actualizo la ID del nuevo nodo con '1'
      
      fin2:
      mov ecx, [wclist] ;Cargo la direccion de la categoria seleccionada
      mov [ecx + 4], eax ;Actualizo la direccion que apunta a la lista de objetos
      mov esi, 1

      fin5:

      mov esp, ebp
      ret

delcategory:
      mov ebp, esp

    ;t6 es ebx 
    ;v0 es esi

      mov ebx, 0
      mov esi, 0

    ;ecx es t7

      mov ecx, [wclist]
      cmp ecx, 0
      je fin4

      mov esi, 1
      mov ecx, [ecx+4]
      cmp ecx, 0
      je finloop
      ;edx es t1
      mov edx, ecx


    loop:
            ;eax es t3
            mov eax, [edx+12]
            mov edi, [edx+8] 
            call sfree

            mov edi, edx
            call sfree

            mov edx, eax
            cmp ecx, edx
            je finloop

            jmp loop

    finloop:
      mov ecx, [wclist]
      mov eax, [cclist]

      ;edi es t4
      mov edi, [ecx+12]

      cmp edi, ecx
      jne finif4

      mov dword [cclist], 0

      jmp fin3

    finif4:

      cmp eax, ecx
      jne finif3

      mov edx, [ecx+12]
      mov [cclist], edx

    finif3:
      mov edx, [ecx+12]
      ;eax pasa a ser t2
      mov eax, [ecx]

      mov [edx], eax
      mov [eax+12], edx

      mov ebx, edx

    fin3:
      mov ecx, [wclist]

      ;edx pasa a ser t0
      mov edx, [ecx+8]
      mov edi, edx
      call sfree

      mov edi, ecx
      call sfree

      mov [wclist], ebx

    fin4:
    mov esp, ebp
    ret


delobject:
    mov ebp, esp
    
    mov esi, 0

    mov ecx, [wclist]
    cmp ecx, 0
    je finwhile
  

    mov esi, 4
    mov edx, [ecx+4]
    cmp edx, 0
    je finwhile

    mov eax, 4  
    mov ebx, 1  
    mov ecx, opc3
    mov edx, len3
    int 0x80
    call saltodelinea

    mov  eax, 3
    mov  ebx, 0
    mov  ecx, user_input
    mov  edx, user_input_length
    int  80h
    call saltodelinea



    
    mov esi, 3
    mov ecx, [wclist]
    mov eax, [ecx+4]

    mov ebx, [eax+12]
    mov edx, [eax]
    cmp edx, eax
    jne finif2

    mov ebx, [eax+4]
    mov edi, [user_input]
    sub edi, 0x30
    cmp edi, ebx
    jne finwhile

    mov esi, 1
    mov dword [ecx+4], 0

    mov edi, [eax+8]
    call sfree

    mov edi, eax
    call sfree

    jmp finwhile
    finif2:

    mov ebx, [eax+4]
    cmp ebx, edi
    jne while

    mov edx, [eax+12]
    mov ecx, [wclist]
    mov [ecx+4], edx
    mov ecx, eax

      while:
            mov ebx, [eax+4]
            cmp ebx, edi
            jne finif
            mov esi, 1

            mov ebx, [eax]
            mov edx, [eax+12]
            mov [ebx+12], edx
            mov [edx], ebx

            mov edi, [eax+8]
            call sfree

            mov edi, eax
            call sfree

            jmp finwhile
            finif:

            mov edx, [eax+12]
            mov eax, edx

            cmp ecx, eax
            je finwhile
            jmp while
      finwhile:

      mov esp, ebp
      ret

smalloc:
	mov eax, [slist]
	cmp eax, 0
	jmp sbrk
	mov ebx, [eax+12]
	mov [slist], ebx
	ret
sbrk:
	mov eax, 45              
    mov ebx, [break]
    add ebx, 16
    int 0x80
    mov [break], eax
    ret
sfree:
	mov eax, [slist]
	mov [edi], eax
	mov [slist], edi
	ret
