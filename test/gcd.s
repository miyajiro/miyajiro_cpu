start:
	jal	ra, main # jal ra 48
gcd.7:
	beq	a0, zero, beq.17 # beq a0 zero 36
	blt	a1, a0, blt.18	# blt a1 a0 12
	sub	a1, a1, a0 # sub a1 a1 a0
	jal	zero, gcd.7	# jal zero -12
blt.18:
	sub	a0, a0, a1	# sub a0 a0 a1
	sw	sp, a1, 8	# sw sp a1 8
	addi	a1, a0, 0 # addi a1 a0 0
	lw	a0, sp, 8	# lw a0 sp 8
	jal	zero, gcd.7	# jal zero -32
beq.17:
	addi	a0, a1, 0	# addi a0 a1 0
	jalr	zero, ra, 0	# jalr zero ra 0
main:
	addi	a0, zero, 2023 # addi a0 zero 2023
	addi	a1, zero, 343 # addi a1 zero 343
	sw	sp, ra, -8 # sw sp ra -8
	addi	sp, sp, -8 # addi sp sp -8
	jal	ra, gcd.7	# jal ra -60
	addi	sp, sp, 8	# addi sp sp 8
	lw	ra, sp, -8	# lw ra sp -8