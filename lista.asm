global _start
extern printf

section .data
	slist dd 0
	cclist dd 0
	wclist dd 0

	opc0 db "\n---------------------------------------------------|\nMenu principal: \n1) Crear categoria \n2) Pasar a categoria siguiente \n3) Volver a categoria anterior \n4) Listar categorias \n5) Borrar categoria seleccionada \n6) Anexar un objeto a la categoria seleccionada \n7) Borrar objeto \n8) Listar objetos de la categoria seleccionada \n9) Salir \n\n"
	length1 equ $-opc0
	consulta db "Ingrese una opcion: %i"
	opc1 db "Ingrese nombre de la categoria: "
	opc2 db "Ingrese nombre del objeto: "
	opc3 db "Ingrese una ID de un objeto a eliminar: "
	msj1 db "Fin del programa!"
	msj2 db "Se ha avanzado a la categoria siguiente!"
	msj3 db "Se ha retrocedido a la categoria anterior!"
	msj4 db "La lista de categoria(s) es:\n\n"
	msj5 db "No hay categorias que mostrar :("
	msj6 db "Se ha eliminado la categoria seleccionada!"
	msj7 db "No hay categorias creadas :("
	msj8 db "Se ha aniadido el objeto a la categoria seleccionada!"
	msj9 db "Se ha eliminado el objeto indicado!"
	msj10 db "\nHa ingresado un id incorrecto!"
	msj11 db "No hay objetos en la categoria seleccionada!"
	msj12 db "La lista de objeto(s) de la categoria seleccionada es:\n"
	msj13 db "Ha ingresado una opcion incorrecta!"

	ast db "*"
	pun db ". "
	salto db "\n"
section .text
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, consulta
	mov edx, 20
	int 0x80
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
			mov edx, 2
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