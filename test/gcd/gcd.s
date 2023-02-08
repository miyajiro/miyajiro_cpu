start:

	jal	ra, main # 0


min_caml_print_int:
	bge		a0,	zero,	print_int_nonneg # 2
	addi	a1,	zero,	45	# 4
	write	a1 # 6
	sub		a0,	zero, a0 # 8
print_int_nonneg:
	addi	a2,	sp,	0 # 10 #呼び出し時のspの値を保存
print_int_loop_stack:
	addi	t0, zero, 10 # 12
	rem		a1,	a0,	t0 # 14
	addi	a1, a1, 48 # 16	#'0'=48
	sw		sp,	a1,	-2 # 18
	addi	sp,	sp,	-2 # 20
	addi	t0,	zero, 10 # 22
	div		a0,	a0,	t0 # 24
	bne		a0,	zero,	print_int_loop_stack # 26
print_int_loop_print:
	addi	sp,	sp,	 2 # 28
	lw		a1,	sp,	-2 # 30
	write	a1 # 32
	bne		sp,	a2,	print_int_loop_print # 34
	jalr	zero,	ra,	0 # 36
	
gcd.7:
	beq	a0, zero, beq.17	# 38
	blt	a1, a0, blt.18	# 40
	sub	a1, a1, a0	# 42
	jal	zero, gcd.7	# 44
blt.18:
	sub	a0, a0, a1	# 46
	sw	sp, a1, -2	# 48
	addi	a1, a0, 0	# 50
	lw	a0, sp, -2	# 52
	jal	zero, gcd.7	# 54
beq.17:
	addi	a0, a1, 0	# 56
	jalr	zero, ra, 0	# 58
main:
	lui	a0, 5	# 60
	addi	a0, a0, 1120	# 62
	lui	a1, 82	# 64
	addi	a1, a1, 1628	# 66
	sw	sp, ra, -2	# 68
	addi	sp, sp, -2	# 70
	jal	ra, gcd.7	# 72
	addi	sp, sp, 2	# 74
	lw	ra, sp, -2	# 76
	sw	sp, ra, -2	# 78
	addi	sp, sp, -2	# 80
	jal	ra, min_caml_print_int	# 82
	addi	sp, sp, 2	# 84
	lw	ra, sp, -2	# 86
