	.file	"print.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"%d "
	.text
	.globl	Print
	.type	Print, @function 		# void Print(int n)
Print:
	push	rbp						# Стандартный пролог
	mov	rbp, rsp					# -
	sub	rsp, 32						# -
	mov	DWORD PTR -20[rbp], edi		# Сохраняем аргумент функции (n) на стек
	mov	DWORD PTR -4[rbp], 0		# Счетчик цикла i = 0
	jmp	.L2							# Переход к проверке условия цикла
.L3:								# Тело цикла
	mov	eax, DWORD PTR -4[rbp]		# Загружаем счётчик цилка в eax/rax
	cdqe							# sign-extend
	lea	rdx, 0[0+rax*4]				# Умножаем на 4 и кладём в rdx
	lea	rax, ARRAY_B[rip]			# Кладём указатель на начало массива ARRAY_B в rax
	mov	eax, DWORD PTR [rdx+rax]	# В eax снова загружаем счетчик цикла — значение элемента массива
	mov	esi, eax					# Кладём в esi индекс элемента массива
	lea	rax, .LC0[rip]				# Кладём в rax адрес строки "%d "
	mov	rdi, rax					# Кладём rax в rdi
	mov	eax, 0						# Обнуляем eax/rax
	call	printf@PLT				# Вызываем printf, при этом в rdi — адрес строки, в esi — индекс элемента массива
	add	DWORD PTR -4[rbp], 1		# ++i
.L2:								# Проверка условия цикла
	mov	eax, DWORD PTR -4[rbp]		# Загружаем int i из стека в eax
	cmp	eax, DWORD PTR -20[rbp]		# Сравниваем i с аргументом функции n
	jl	.L3							# Если i < n, то переходим к телу цикла
	nop								
	nop
	leave
	ret