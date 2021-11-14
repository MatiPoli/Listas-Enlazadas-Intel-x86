global _start

section .data
	slist dd 0
	cclist dd 0
	wclist dd 0

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


ast db "*"

pun db ". "
lenpun equ $-pun

salto db "\n",'$'
lensalto equ $-salto

section .bss
user_input resb 25    ; user input
 user_input_length equ $- user_input

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

      mov eax,1
      cmp eax,1 ;compare               ;https://www.youtube.com/watch?v=cFGJhn97e3s&list=PLmxT2pVYo5LB5EzTPZGfFN0c2GDiSXgQe&index=2
      jl opc  ;Jump if less
      mov ebx,9
      cmp ebx,9 ;compare
      jg opc ;Jump if greater
      jmp finif18


      opc:
      mov eax, 4  
      mov ebx, 1  
      mov ecx, msj13 ;"Ha ingresado una opcion incorrecta!"
      mov edx, lenm13
      int 0x80 

      finif18:
      cmp ecx,1
      je opcion1
      cmp ecx,2
      je opcion2
      cmp ecx,3
      je opcion3
      cmp ecx,4
      je opcion4
      cmp ecx,5
      je opcion5
      cmp ecx,6
      je opcion6
      cmp ecx,7
      je opcion7
      cmp ecx,8
      je opcion8
      cmp ecx,9
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
      call newcategory ;Obtengo la nueva categoria            ;PONER UN RET CUANDO HAGAN FUNCIONES CON CALL
      jmp while2

      opcion2:
      call nextcategory
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp eax,0
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

      cmp eax,0
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

      cmp eax,0
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
      jmp while2

      opcion5:
      call delcategory
      ;Devuelve a $v0 con:
      ;'1' si es que hay categorias creadas anteriormente
      ;'0' si es que no hay categorias creadas anteriormente

      cmp eax, 0
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

      cmp eax, 0
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

      cmp eax,0
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
      cmp eax,3
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
      cmp eax,4
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

      cmp eax,0
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
      cmp eax,3
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

   saltodelinea:
    mov eax, 4  
    mov ebx, 1  
    mov ecx, salto ;"Ingrese una opcion: "
    mov edx, lensalto
    int 0x80
    ret
 
mov eax, 1
mov ebx, 0
int 0x80

listarcategory:
	mov esi, 0
	mov ebp, esp
	mov eax, [cclist]
	push eax
	cmp eax, 0
	je finloop2
	loop2:
	    pop eax
		mov ebx, [wclist]
		cmp eax, ebx
		push eax
		jne finif5

		mov eax, 4
		mov ebx, 1
		mov ecx, ast
		mov edx, 1
		int 0x80

		finif5:
			mov eax, 4
			mov ebx, 1
			pop eax
			mov ecx, [eax+8]
			push eax
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
