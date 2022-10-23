	.file	"input.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	Input
	.type	Input, @function 		# void Input(int n)
Input:
	endbr64							# Стандартный пролог
	push	rbp						# -
	mov	rbp, rsp					# -
	sub	rsp, 32						# -
	mov	DWORD PTR -20[rbp], edi		# Сохраняем аргумент функции (n) на стек
	mov	DWORD PTR -4[rbp], 0		# Счётчик цикла i = 0
	jmp	.L2							# Переход к проверке условия цикла
.L3:
	mov	eax, DWORD PTR -4[rbp]		# Загружаем счётчик цилка в eax/rax
	cdqe							# sign-extend
	lea	rdx, 0[0+rax*4]				# Умножаем на 4 и кладём в rdx
	lea	rax, ARRAY_A[rip]			# Кладём указатель на начало массива ARRAY_A в rax
	add	rax, rdx					# Получаем указатель на i-ый элемент массива в rax
	mov	rsi, rax					# Кладём в rsi из rax указатель на i-ый элемент массива
	lea	rax, .LC0[rip]				# Кладём в rax адрес строки "%d"
	mov	rdi, rax					# Кладём в rdi из rax адрес строки "%d"
	mov	eax, 0						# Обнуляем rax
	call	__isoc99_scanf@PLT 		# Вызываем scanf, при этом в rdi - адрес строки "%d", в rsi - адрес i-го элемента массива, в rdx - i
	add	DWORD PTR -4[rbp], 1		# ++i
.L2:								# Проверка условия цикла
	mov	eax, DWORD PTR -4[rbp]		# Загружаем int i из стека в eax
	cmp	eax, DWORD PTR -20[rbp]		# Сравниваем i с аргументом функции n
	jl	.L3							# Если i < n, то переходим к телу цикла
	nop								
	nop
	leave
	ret