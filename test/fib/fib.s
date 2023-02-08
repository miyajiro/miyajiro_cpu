start:

	jal	ra, main


min_caml_print_int:
	bge		a0,	zero,	print_int_nonneg
	addi	a1,	zero,	45	#'-'=45
	write	a1
	sub		a0,	zero, a0
print_int_nonneg:
	addi	a2,	sp,	0	#呼び出し時のspの値を保存
print_int_loop_stack:
	addi	t0, zero, 10
	rem		a1,	a0,	t0
	addi	a1, a1, 48	#'0'=48
	sw		sp,	a1,	-2
	addi	sp,	sp,	-2
	addi	t0,	zero, 10
	div		a0,	a0,	t0
	bne		a0,	zero,	print_int_loop_stack
print_int_loop_print:
	addi	sp,	sp,	 2
	lw		a1,	sp,	-2
	write	a1
	bne		sp,	a2,	print_int_loop_print
	jalr	zero,	ra,	0

fib.10:
	addi	t0, zero, 1	#2
	blt	t0, a0, blt.24	#2
	jalr	zero, ra, 0	#2
blt.24:
	addi	a1, a0, -1	#3
	sw	sp, a0, -2	#3
	addi	a0, a1, 0	#3
	sw	sp, ra, -4	#3
	addi	sp, sp, -4	#3
	jal	ra, fib.10	#3
	addi	sp, sp, 4	#3
	lw	ra, sp, -4	#3
	lw	a1, sp, -2	#3
	addi	a1, a1, -2	#3
	sw	sp, a0, -4	#3
	addi	a0, a1, 0	#3
	sw	sp, ra, -6	#3
	addi	sp, sp, -6	#3
	jal	ra, fib.10	#3
	addi	sp, sp, 6	#3
	lw	ra, sp, -6	#3
	lw	a1, sp, -4	#3
	add	a0, a1, a0	#3
	jalr	zero, ra, 0	#3
main:
	addi	a0, zero, 30	#4
	sw	sp, ra, -2	#4
	addi	sp, sp, -2	#4
	jal	ra, fib.10	#4
	addi	sp, sp, 2	#4
	lw	ra, sp, -2	#4
	sw	sp, ra, -2	#4
	addi	sp, sp, -2	#4
	jal	ra, min_caml_print_int	#4
	addi	sp, sp, 2	#4
	lw	ra, sp, -2	#4
