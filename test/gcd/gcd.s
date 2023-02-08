start:

	jal	ra, main # 0


min_caml_print_int:
	bge		a0,	zero,	print_int_nonneg #4
	addi	a1,	zero,	45	# 8
	write	a1 # 12
	sub		a0,	zero, a0 # 16
print_int_nonneg:
	addi	a2,	sp,	0 # 20 #呼び出し時のspの値を保存
print_int_loop_stack:
	addi	t0, zero, 10 # 24
	rem		a1,	a0,	t0 # 28
	addi	a1, a1, 48 # 32	#'0'=48
	sw		sp,	a1,	-2 # 36
	addi	sp,	sp,	-2 # 40
	addi	t0,	zero, 10 # 44
	div		a0,	a0,	t0 # 48
	bne		a0,	zero,	print_int_loop_stack # 52
print_int_loop_print:
	addi	sp,	sp,	 2 # 56
	lw		a1,	sp,	-2 # 60
	write	a1 # 64
	bne		sp,	a2,	print_int_loop_print # 68
	jalr	zero,	ra,	0 # 72
	
gcd.7:
	beq	a0, zero, beq.17	# 76
	blt	a1, a0, blt.18	# 80
	sub	a1, a1, a0	# 84
	jal	zero, gcd.7	# 88
blt.18:
	sub	a0, a0, a1	# 92
	sw	sp, a1, -2	# 96
	addi	a1, a0, 0	# 100
	lw	a0, sp, -2	# 104
	jal	zero, gcd.7	# 108
beq.17:
	addi	a0, a1, 0	# 112
	jalr	zero, ra, 0	# 116
main:
	lui	a0, 5	# 120
	addi	a0, a0, 1120	# 124
	lui	a1, 82	# 128
	addi	a1, a1, 1628	# 132
	sw	sp, ra, -2	# 136
	addi	sp, sp, -2	# 140
	jal	ra, gcd.7	# 144
	addi	sp, sp, 2	# 148
	lw	ra, sp, -2	# 152
	sw	sp, ra, -2	# 156
	addi	sp, sp, -2	# 160
	jal	ra, min_caml_print_int	# 164
	addi	sp, sp, 2	# 168
	lw	ra, sp, -2	# 172
