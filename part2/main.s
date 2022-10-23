	.file	"main.c"
	.intel_syntax noprefix
	.text								# Новая секция
	.globl	ARRAY_A						# В ней лежит символ ARRAY_A
	.bss								# Который неинициализирован (секция .bss)
	.align 32							# Выравнивание, на x86_64 не очень-то и нужно
	.type	ARRAY_A, @object
	.size	ARRAY_A, 4194304			# В ARRAY_A 1048576 * 4 байт (длина массива на размер инта)
ARRAY_A:
	.zero	4194304
	.globl	ARRAY_B						# Cимвол ARRAY_B
	.align 32
	.type	ARRAY_B, @object
	.size	ARRAY_B, 4194304			# В ARRAY_B 1048576 * 4 байт
ARRAY_B:
	.zero	4194304
	.section	.rodata
.LC0:
	.string	"%d"						# Строка "%d" для ввода n
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp							# Стандартный пролог
	mov	rbp, rsp						# -
	sub	rsp, 32							# -
	mov	DWORD PTR -20[rbp], edi		# rbp[-20] := edi — это первый аргумент, `argc` (edi)
	mov	QWORD PTR -32[rbp], rsi		# rbp := rsi — это второй аргумент, `argv` (rsi)
	lea	rax, -4[rbp]				# Загружаем int n в rax
	mov	rsi, rax				 	# Кладём rax в rsi
	lea	rax, .LC0[rip]				# Записываем в rax адрес строки "%d"
	mov	rdi, rax					# Кладём адрес строки "%d" в rdi
	mov	eax, 0						# Обнуляем eax/rax
	call	__isoc99_scanf@PLT		# Вызываем scanf("%d", &n), при этом rdi содержит адрес строки "%d", а rsi — адрес переменной n
	mov	eax, DWORD PTR -4[rbp]		# Загружаем n в eax
	mov	edi, eax					# Кладём n в edi
	call	Input@PLT				# Вызываем Input(n)
	mov	eax, DWORD PTR -4[rbp]		# Снова кладём n в eax
	mov	edi, eax					# Кладём n в edi
	call	Create@PLT				# Вызываем Create(n)
	mov	eax, DWORD PTR -4[rbp]		# Снова кладём n в eax
	mov	edi, eax					# Кладём n в edi
	call	Print@PLT				# Вызываем Print(n)
	mov	eax, 0						# Обнуляем eax/rax
	leave							# Эпилог 1/2
	ret								# Эпилог 2/2