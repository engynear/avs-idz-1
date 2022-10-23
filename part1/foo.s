	.file	"foo.c" 			# Имя файла
	.intel_syntax noprefix		# Синтаксис ассемблера
	.text						# Начало секции кода
	.local	ARRAY_A				# Объявляем символ ARRAY_A, но не экспортируем
	.comm	ARRAY_A,4194304,32	# Выделение памяти ARRAY_A, неинициализированный массив (https://sourceware.org/binutils/docs/as/bss.html)
	.local	ARRAY_B				# Объявляем символ ARRAY_B, но не экспортируем
	.comm	ARRAY_B,4194304,32	# Выделение памяти массиву ARRAY_B, неинициализированный массив (https://sourceware.org/binutils/docs/as/bss.html)
	.section	.rodata			# Переход в секцию .rodata
.LC0:							# Метка `.LC0`
	.string	"%d"				# Строка "%d" для ввода n и значений массива
.LC1:							# Метка `.LC1`
	.string	"%d "				# Строка "%d " для вывода значений массива
	.text						# Секция текст?
	.globl	main				# Экспортируем символ main
	.type	main, @function		# Говорим, что main - функция
main:
.LFB0:
	.cfi_startproc				# -
	endbr64						# -
	push	rbp					# Сохраняем последний rbp в стеке
	.cfi_def_cfa_offset 16		# -
	.cfi_offset 6, -16			# -
	mov	rbp, rsp				# rbp := rsp (устанавливаем rbp)
	.cfi_def_cfa_register 6		# -
	sub	rsp, 48					# Выделяем 32 байта на стеке (подвинули rsp)
	mov	DWORD PTR -36[rbp], edi	# rbp[-36] := edi — это первый аргумент, `argc` (edi)
	mov	QWORD PTR -48[rbp], rsi # rbp := rsi — это второй аргумент, `argv` (rsi)
	mov	rax, QWORD PTR fs:40	# stack protection, игнорируем
	mov	QWORD PTR -8[rbp], rax	# stack protection, игнорируем
	xor	eax, eax				# обнуляет eax
	mov	DWORD PTR -16[rbp], 0 	# переменная j = 0
	mov	DWORD PTR -12[rbp], 0	# переменная k = 0
	lea	rax, -24[rbp]			# rax := rbp - 24
	mov	rsi, rax				# Перемещаем rax в rsi
	lea	rax, .LC0[rip]			# Вычисляем адрес строки "%d" в rax
	mov	rdi, rax				# Перемещаем rax в rdi
	mov	eax, 0					# Присваиваем eax/rax 0
	call	__isoc99_scanf@PLT	# Вызываем scanf, в этот момент в rax = 0, в rdi = адрес строки "%d", в rsi = адрес переменной n
	mov	DWORD PTR -20[rbp], 0	# переменная i = 0
	jmp	.L2						# Переход к метке `.L2` (проверка условия цикла)
.L3:							# Метка `.L3`
	mov	eax, DWORD PTR -20[rbp]	# Перемещаем значение переменной i в eax
	cdqe						# Convert Doubleword to Qwadword — расширяет eax до rax, делает sign-extend
	lea	rdx, 0[0+rax*4]			# rdx := rax * 4, вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, ARRAY_A[rip]		# Помещает адрес начала массива ARRAY_A в rax
	add	rax, rdx				# Складываем rax и rdx
	mov	rsi, rax				# Записываем rax в rsi
	lea	rax, .LC0[rip]			# Вычисляем адрес строки "%d", кладём в rax
	mov	rdi, rax				# Записываем rax в rdi
	mov	eax, 0					# Присваиваем eax/rax 0
	call	__isoc99_scanf@PLT 	# Вызываем scanf, в этот момент rax = 0, в rdi - адрес строки "%d", в rsi - адрес массива ARRAY_A (это ввод массива ARRAY_A)
	add	DWORD PTR -20[rbp], 1 	# ++i
.L2:							# Метка `.L2` (проверка условия цикла `for` для ввода массива ARRAY_A) 
	mov	eax, DWORD PTR -24[rbp] # eax:= rbp[-24] (загрузка значения n из стека в eax)
	cmp	DWORD PTR -20[rbp], eax # Сравниваем rbp[-20] и eax (i и n)
	jl	.L3						# Если i < n, то переходим к метке `.L3`
	mov	DWORD PTR -20[rbp], 0	# Если нет, присваиваем переменной i значение 0
	jmp	.L4						# Переход к метке `.L4` (едем дальше по программе)
.L7:							# Метка `.L7` (проверка условия цикла `for` для формирования массива B)
	mov	eax, DWORD PTR -20[rbp] # eax := rbp[-20] (загрузка значения i из стека в eax)
	cdqe						# Convert Doubleword to Qwadword — расширяет eax до rax, делает sign-extend
	lea	rdx, 0[0+rax*4]			# rdx =	rax * 4, вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, ARRAY_A[rip]		# rax = array_a (помещаем адрес начала массива ARRAY_A в rax)
	mov	eax, DWORD PTR [rdx+rax] # eax = array_a[rdx] (загружаем значение из массива ARRAY_A в eax)
	and	eax, 1					# Помещаем в eax последний бит элемента массива (чтобы проверить чётность)
	test	eax, eax			# По факту проверяем, равен ли eax нулю (последний бит равен 0)
	je	.L5						# Если равен, значит число чётное, переходим к метке `.L5`
	mov	eax, DWORD PTR -20[rbp] # Если нет, значит нечётное, дальше eax := rbp[-20] (загрузка значения i из стека в eax)
	cdqe						# Convert Doubleword to Qwadword — расширяет eax до rax, делает sign-extend
	lea	rdx, 0[0+rax*4]			# rdx = 0 + rax * 4 (вычисляем адрес (rax*4)[0], который равен rax*4)
	lea	rax, ARRAY_A[rip]		# rax = array_a (помещаем адрес начала массива ARRAY_A в rax)
	mov	eax, DWORD PTR [rdx+rax] # eax = array_a[rdx] (загружаем значение из массива ARRAY_A в eax)
	mov	edx, DWORD PTR -16[rbp] # edx := rbp[-16] (загрузка значение переменной j из стека в edx)
	movsx	rdx, edx			# Копирует из edx в rdx с расширением знака
	lea	rcx, 0[0+rdx*4]			# rcx = 0 + rdx * 4 (вычисляем адрес (rdx*4)[0], который равен rdx*4)
	lea	rdx, ARRAY_B[rip]		# rdx = array_b (помещаем адрес начала массива ARRAY_B в rdx)
	mov	DWORD PTR [rcx+rdx], eax # array_b[rcx] = eax (записываем значение eax в массив ARRAY_B)
	add	DWORD PTR -16[rbp], 1	# ++j
	jmp	.L6						# Переход к метке `.L6` (действие каждую итерацию for)
.L5:							# Метка `.L5` (ARRAY_A[i] чётное)
	mov	eax, DWORD PTR -24[rbp]	# eax:= rbp[-24] (загрузка значения n из стека в eax)
	sub	eax, 1					# n -= 1
	sub	eax, DWORD PTR -12[rbp]	# n -= k
	mov	edx, eax				# edx:= eax (загрузка значения n в edx, это будет индекс элемента в который будем записывать в массиве ARRAY_B)
	mov	eax, DWORD PTR -20[rbp]	# eax := rbp[-4] (загрузка значения i из стека в eax), это будет индекс элемента, который вытащим из ARRAY_A
	cdqe						# Convert Doubleword to Qwadword — расширяет eax до rax, делает sign-extend
	lea	rcx, 0[0+rax*4]			# rcx = 0 + rax * 4 (вычисляем адрес (rax*4)[0], который равен rax*4)
	lea	rax, ARRAY_A[rip]		# Помещаем в rax адрес начала массива ARRAY_A
	mov	eax, DWORD PTR [rcx+rax]	# eax = array_a[rcx] (загружаем значение из массива ARRAY_A в eax, rcx = индекс элемента в ARRAY_A)
	movsx	rdx, edx			# Копирует из rdx в edx с расширением знака
	lea	rcx, 0[0+rdx*4]			# rcx = 0 + rdx * 4 (вычисляем адрес (rdx*4)[0], который равен rdx*4)
	lea	rdx, ARRAY_B[rip]		# rdx = array_b[rip] (помещаем в rdx адрес начала массива ARRAY_B)
	mov	DWORD PTR [rcx+rdx], eax # array_b[rcx] = eax (записываем значение eax в массив ARRAY_B, в eax лежит элемент массива ARRAY_A)
	add	DWORD PTR -12[rbp], 1 	# ++k
.L6:							# Метка `.L6`
	add	DWORD PTR -20[rbp], 1	# ++i в for
.L4:
	mov	eax, DWORD PTR -24[rbp] # eax:= rbp[-24] (загрузка значения n из стека в eax)
	cmp	DWORD PTR -20[rbp], eax  # Сравниваем rbp[-20] и eax (i и n)
	jl	.L7						# Если i < n, то переходим к метке `.L7`
	mov	DWORD PTR -20[rbp], 0	# Если нет, присваиваем переменной i значение 0
	jmp	.L8						# Переход к метке `.L8` (едем дальше по программе)
.L9:							# Метка `.L9` (вывод массива ARRAY_B)
	mov	eax, DWORD PTR -20[rbp]	# eax:= rbp[-4] (загрузка значения i из стека в eax)
	cdqe						# Convert Doubleword to Qwadword — расширяет eax до rax, делает sign-extend
	lea	rdx, 0[0+rax*4]			# rdx = 0 + rax * 4 (вычисляем адрес (rax*4)[0], который равен rax*4)
	lea	rax, ARRAY_B[rip]		# Помещаем в rax адрес начала массива ARRAY_B
	mov	eax, DWORD PTR [rdx+rax] # eax = array_b[rdx] (загружаем значение из массива ARRAY_B в eax, rdx = индекс элемента в ARRAY_B, rax - адрес начала массива ARRAY_B)
	mov	esi, eax				# esi = eax (помещаем значение eax в esi)
	lea	rax, .LC1[rip]			# Помещаем в rax адрес строки "%d " из .LC1" 
	mov	rdi, rax				# rdi = rax (помещаем адрес строки "%d " в rdi)
	mov	eax, 0					# eax = 0
	call	printf@PLT			# Вызываем функцию printf, в этот момент в rdi лежит адрес строки "%d ", в esi - значение элемента массива ARRAY_B
	add	DWORD PTR -20[rbp], 1	# ++i
.L8:							# Метка `.L8` (проверка условия последнего for и эпилог)
	mov	eax, DWORD PTR -24[rbp] # eax:= rbp[-16] (загрузка значения n из стека в eax)
	cmp	DWORD PTR -20[rbp], eax 	# Сравниваем rbp[-4] и eax (i и n)
	jl	.L9						# Если i < n, то переходим к метке `.L9`
	mov	eax, 0					# Если нет, то эпилог
	mov	rdx, QWORD PTR -8[rbp] 	# stack protection
	sub	rdx, QWORD PTR fs:40	# stack protection
	je	.L11					# stack protection
	call	__stack_chk_fail@PLT	# stack protection
.L11:							# Метка `.L11` эпилог
	leave						# Эпилог 1/2
	.cfi_def_cfa 7, 8			# -
	ret							# Эпилог 2/2
	.cfi_endproc				# -
.LFE0: 							# Дальше мета-информация gcc
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
