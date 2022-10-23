	.file	"create.c"
	.intel_syntax noprefix
	.text
	.globl	Create
	.type	Create, @function			# void Create(int n)
Create:
	push	rbp							# Стандартный пролог
	mov	rbp, rsp						# -
	mov	DWORD PTR -20[rbp], edi			# Сохраняем аргумент функции (n) на стек
	mov	DWORD PTR -8[rbp], 0			# Счетчик j = 0
	mov	DWORD PTR -12[rbp], 0			# Счётчик k = 0
	mov	DWORD PTR -4[rbp], 0			# Счётчик цикла i = 0
	jmp	.L2								# Переход к проверке условия цикла for
.L5:									# Тело цикла, условие if
	mov	eax, DWORD PTR -4[rbp]			# Загружаем счётчик цилка в eax/rax
	cdqe
	lea	rdx, 0[0+rax*4]				# Умножаем на 4 и кладём в rdx
	lea	rax, ARRAY_A[rip]			# Кладём указатель на начало массива ARRAY_A в rax
	mov	eax, DWORD PTR [rdx+rax]	# В eax загружаем значение элемента массива ARRAY_A
	and	eax, 1						# Кладём в eax последний бит значения элемента массива ARRAY_A
	test	eax, eax				# Проверяем равен ли бит нулю
	je	.L3							# Если равен, то элемент массива чётный, переходим к .L3 (else)
	mov	eax, DWORD PTR -4[rbp]		# Снова загружаем в eax счётчик цикла i
	cdqe							# sign-extend rax
	lea	rdx, 0[0+rax*4]				# Умножаем на 4 и кладём в rdx
	lea	rax, ARRAY_A[rip]			# Кладём указатель на начало массива ARRAY_A в rax
	mov	eax, DWORD PTR [rdx+rax]	# В eax загружаем значение элемента массива ARRAY_A по счётчику i
	mov	edx, DWORD PTR -8[rbp]		# Загружаем в edx счётчик j
	movsx	rdx, edx				# mov with sign-extend rdx
	lea	rcx, 0[0+rdx*4]				# Умножаем на 4 и кладём в rcx
	lea	rdx, ARRAY_B[rip]			# Кладём указатель на начало массива ARRAY_B в rdx
	mov	DWORD PTR [rcx+rdx], eax	# Записываем в массив B по счётчику j значение элемента массива A по счётчику i
	add	DWORD PTR -8[rbp], 1		# ++j
	jmp	.L4							# Переходим к действию каждую итерацию for
.L3:								# ARRAY_A[i] % 2 != 0 <-- False
	mov	eax, DWORD PTR -20[rbp]		# Загружаем в eax значение аргумента функции n
	sub	eax, 1						# n -= 1
	sub	eax, DWORD PTR -12[rbp]		# n -= k
	mov	edx, eax					# Записываем указатель для массива ARRAY_B в edx
	mov	eax, DWORD PTR -4[rbp]		# Загружаем в eax счётчик цикла i
	cdqe							# sign-extend
	lea	rcx, 0[0+rax*4]				# Умножаем на 4 и кладём в rcx
	lea	rax, ARRAY_A[rip]			# Кладём указатель на начало массива ARRAY_A в rax
	mov	eax, DWORD PTR [rcx+rax]	# Записываем в eax значение элемента массива ARRAY_A по счётчику i
	movsx	rdx, edx				# mov with sign-extend
	lea	rcx, 0[0+rdx*4]				# Умножаем на 4 и кладём в rcx
	lea	rdx, ARRAY_B[rip]			# Кладём указатель на начало массива ARRAY_B в rdx
	mov	DWORD PTR [rcx+rdx], eax	# ARRAY_B[n - 1 - k] = ARRAY_A[i];
	add	DWORD PTR -12[rbp], 1		# ++k;
.L4:								# Итерация for (++i)
	add	DWORD PTR -4[rbp], 1		# ++i
.L2:									# Проверка условия цикла for		
	mov	eax, DWORD PTR -4[rbp]		# Загружаем int i из стека в eax
	cmp	eax, DWORD PTR -20[rbp]		# Сравниваем i с аргументом функции n
	jl	.L5							# Если i < n, то переходим к телу цикла
	nop
	nop
	pop	rbp
	ret