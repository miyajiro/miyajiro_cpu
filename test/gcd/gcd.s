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
	
gcd.7:
	beq	a0, zero, beq.17	#2
	blt	a1, a0, blt.18	#3
	sub	a1, a1, a0	#3
	jal	zero, gcd.7	#3
blt.18:
	sub	a0, a0, a1	#4
	sw	sp, a1, -2	#4
	addi	a1, a0, 0	#4
	lw	a0, sp, -2	#4
	jal	zero, gcd.7	#4
beq.17:
	addi	a0, a1, 0	#2
	jalr	zero, ra, 0	#2
main:
	lui	a0, 5	#5
	addi	a0, a0, 1120	#5
	lui	a1, 82	#5
	addi	a1, a1, 1628	#5
	sw	sp, ra, -2	#5
	addi	sp, sp, -2	#5
	jal	ra, gcd.7	#5
	addi	sp, sp, 2	#5
	lw	ra, sp, -2	#5
	sw	sp, ra, -2	#5
	addi	sp, sp, -2	#5
	jal	ra, min_caml_print_int	#5
	addi	sp, sp, 2	#5
	lw	ra, sp, -2	#5
