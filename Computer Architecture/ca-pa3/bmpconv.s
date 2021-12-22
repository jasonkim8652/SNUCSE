#----------------------------------------------------------------
#
#  4190.308 Computer Architecture (Fall 2021)
#
#  Project #3: Image Convolution in RISC-V Assembly
#
#  October 25, 2021
#
#  Jaehoon Shim (mattjs@snu.ac.kr)
#  Ikjoon Son (ikjoon.son@snu.ac.kr)
#  Seongyeop Jeong (seongyeop.jeong@snu.ac.kr)
#  Systems Software & Architecture Laboratory
#  Dept. of Computer Science and Engineering
#  Seoul National University
#
#----------------------------------------------------------------

####################
# void bmpconv(unsigned char *imgptr, int h, int w, unsigned char *k, unsigned char *outptr)
####################

	.globl bmpconv
bmpconv:
	#stack Kernal
	addi sp, sp, -4
	lw t0, 0(a3)
	andi t1, t0, 0xFF
	sw t1, 0(sp) #(0,0)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1,t0,0xFF
	sw t1, 0(sp) #(0,1)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1, t0, 0xFF
	sw t1, 0(sp) #(0,2)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1, t0, 0xFF
	sw t1, 0(sp) #(1,0)
	lw t0, 4(a3)
	addi sp, sp, -4
	andi t1,t0,0xFF
	sw t1, 0(sp) #(1,1)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1,t0,0xFF
	sw t1, 0(sp) #(1,2)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1, t0, 0xFF
	sw t1, 0(sp) #(2,0)
	srli t0, t0, 8
	addi sp,sp,-4
	andi t1, t0, 0xFF
	sw t1, 0(sp) #(2,1)
	lw t0, 8(a3)
	addi sp, sp, -4
	andi t1, t0, 0xFF
	sw t1,0(sp) #(2,2)
	#width, height notification
	addi a2, a2,-2
	slli a3, a2, 1
	addi a1, a1, -2
	add a3, a3, a2
	addi a3, a3, 1#a3 is width checker
	#where to go
	addi a2, a2, 2
	slli t3, a2, 1
	add t3, t3, a2
	addi t3, t3, 3
	srli t3, t3, 2
	slli t3, t3, 2#t3 is jumper
	#counter
	add t0, zero, zero #t0 is counter
	add a2, zero, zero #a2 is line counter
	addi sp, sp, -12
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	addi a0, a0, -4
	
	beq zero, zero, Reading0

Reading0:
	lw t0, 0(sp)
	lw a2, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	addi a0, a0, 4
	lw t1, 0(a0)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,0)R
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,1)R
	lw t1, 4(a0)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,2)R
	add t4, a0, t3
	lw t1, 0(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,0)R
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,1)R
	lw t1, 4(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,2)R
	add t4,t4, t3
	lw t1, 0(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,0)R
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,1)R
	lw t1, 4(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,2)R
	addi sp, sp, -16
	sw a0, 12(sp)
	sw a1, 8(sp)
	sw a4, 4(sp)
	sw a2, 0(sp)
	add a0, sp, 84#a0 is sp for kernal
	add a4, sp, 48#a4 is sp for bitmap
	add a1, zero, zero #a0 is counter
	add t4, zero, zero
	beq zero, zero, Result	
Reading1:
	lw t0, 0(sp)
	lw a2, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	lw t1, 0(a0)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,0)G
	lw t1, 4(a0)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,1)G
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,2)R
	add t4, a0, t3
	lw t1, 0(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,0)R
	lw t1, 4(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,1)R
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,2)R
	add t4,t4, t3
	lw t1, 0(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,0)R
	lw t1, 4(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,1)R
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,2)R
	addi sp, sp, -16
	sw a0, 12(sp)
	sw a1, 8(sp)
	sw a4, 4(sp)
	sw a2, 0(sp)
	add a0, sp, 84#a0 is sp for kernal
	add a4, sp, 48#a4 is sp for bitmap
	add a1, zero, zero #a0 is counter
	add t4, zero, zero
	beq zero, zero, Result	
Reading2:
	lw t0, 0(sp)
	lw a2, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	lw t1, 0(a0)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,0)R
	lw t1, 4(a0)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,1)R
	lw t1, 8(a0)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,2)R
	add t4, a0, t3
	lw t1, 0(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,0)R
	lw t1, 4(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,1)R
	lw t1, 8(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,2)R
	add t4,t4, t3
	lw t1, 0(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,0)R
	lw t1, 4(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,1)R
	lw t1, 8(t4)
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,2)R
	addi sp, sp, -16
	sw a0, 12(sp)
	sw a1, 8(sp)
	sw a4, 4(sp)
	sw a2, 0(sp)
	add a0, sp, 84#a0 is sp for kernal
	add a4, sp, 48#a4 is sp for bitmap
	add a1, zero, zero #a0 is counter
	add t4, zero, zero
	beq zero, zero, Result	
Reading3:
	lw t0, 0(sp)
	lw a2, 4(sp)
	lw a1, 8(sp)
	addi sp, sp, 12
	lw t1, 0(a0)
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,0)R
	lw t1, 4(a0)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,1)R
	lw t1, 8(a0)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(0,2)R
	add t4, a0, t3
	lw t1, 0(t4)
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,0)R
	lw t1, 4(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,1)R
	lw t1, 8(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(1,2)R
	add t4,t4, t3
	lw t1, 0(t4)
	srli t1, t1, 24
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,0)R
	lw t1, 4(t4)
	srli t1, t1, 16
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,1)R
	lw t1, 8(t4)
	srli t1, t1, 8
	andi t2, t1, 0xFF
	addi sp, sp, -4
	sw t2, 0(sp) #(2,2)R
	addi sp, sp, -16
	sw a0, 12(sp)
	sw a1, 8(sp)
	sw a4, 4(sp)
	sw a2, 0(sp)
	add a0, sp, 84#a0 is sp for kernal
	add a4, sp, 48#a4 is sp for bitmap
	add a1, zero, zero #a1 is counter
	add t4, zero, zero
	beq zero, zero, Result	


Result:
	lw t1, 0(a0) #Kernal
	slli t1, t1, 24
	ble t1, zero, Resultminus
	lw t2, 0(a4) #bitmap
	add t4, t4, t2 #t4 is result
	addi a0, a0, -4
	addi a4, a4, -4
	addi a1, a1, 1
	addi a2, zero, 9
	beq a1, a2, ResultAfter
	beq zero, zero, Result
	
Resultminus:
	beq t1, zero, Resultzero
	lw t2, 0(a4) #bitmap
	sub t4, t4, t2 #t4 is result
	addi a0, a0, -4
	addi a4, a4, -4
	addi a1, a1, 1
	addi a2, zero, 9
	beq a1, a2, ResultAfter
	beq zero, zero, Result
	
Resultzero:
	lw t2, 0(a4) #bitmap
	addi a0, a0, -4
	addi a4, a4, -4
	addi a1, a1, 1
	addi a2, zero, 9
	beq a1, a2, ResultAfter
	beq zero, zero, Result

ResultAfter:
	addi a2, zero, 255
	bge t4, a2, Result255
	ble t4, zero, Result0
	lw a2, 0(sp)
	lw a4, 4(sp)
	lw a1, 8(sp)
	lw a0, 12(sp)
	addi sp, sp, 52
	addi t0, t0, 1
	beq t0, a3, nextline
	addi sp, sp, -12
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	andi t0, t0, 0B11
	add a2, zero, zero
	beq t0, a2, Resultsav0
	addi a2, a2, 1
	beq t0, a2, Resultsav1
	addi a2, a2, 1
	beq t0, a2, Resultsav2
	addi a2, a2, 1
	beq t0, a2, Resultsav3
Resultsav0:
	lw a1, 0(a4)
	slli t4, t4, 24
	or a1, a1, t4
	sw a1, 0(a4)
	addi a4, a4, 4
	beq zero, zero, Reading0

Resultsav1:
	add a1, zero, zero
	or a1, a1, t4
	sw a1, 0(a4)
	beq zero, zero, Reading1
Resultsav2:
	lw a1, 0(a4)
	slli t4, t4, 8
	or a1, a1, t4
	sw a1, 0(a4)
	beq zero, zero, Reading2
Resultsav3:
	lw a1, 0(a4)
	slli t4, t4, 16
	or a1, a1, t4
	sw a1, 0(a4)
	beq zero, zero, Reading3
	
Result0:
	add t4, zero, zero
	lw a2, 0(sp)
	lw a4, 4(sp)
	lw a1, 8(sp)
	lw a0, 12(sp)
	addi sp, sp, 52
	addi t0, t0, 1
	beq t0, a3, nextline
	addi sp, sp, -12
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	andi t0, t0, 0B11
	add a2, zero, zero
	beq t0, a2, Resultsav0
	addi a2, a2, 1
	beq t0, a2, Resultsav1
	addi a2, a2, 1
	beq t0, a2, Resultsav2
	addi a2, a2, 1
	beq t0, a2, Resultsav3
	
Result255:
	addi t4, zero, 255
	lw a2, 0(sp)
	lw a4, 4(sp)
	lw a1, 8(sp)
	lw a0, 12(sp)
	addi sp, sp, 52
	addi t0, t0, 1
	beq t0, a3, nextline
	addi sp, sp, -12
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	andi t0, t0, 0B11
	add a2, zero, zero
	beq t0, a2, Resultsav0
	addi a2, a2, 1
	beq t0, a2, Resultsav1
	addi a2, a2, 1
	beq t0, a2, Resultsav2
	addi a2, a2, 1
	beq t0, a2, Resultsav3
nextline:
	addi a2, a2, 1
	beq a2, a1, Finish 
	addi t1, a3, -1
	andi t1, t1, 3
	beq t1, zero, nextline_none
	addi a0, a0, 4
	addi a4, a4, 4
	andi t1, a3, 0B11
	beq t1, zero, nextline_more
	addi sp, sp, -12
	add t0, zero, zero
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	beq zero, zero, Reading0
nextline_none:
	addi a0, a0, 4
	andi t1, a3, 0B11
	beq t1, zero, nextline_more
	addi sp, sp, -12
	add t0, zero, zero
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	beq zero, zero, Reading0
nextline_more:
	addi a0, a0, 4
	addi sp, sp, -12
	add t0, zero, zero
	sw t0, 0(sp)
	sw a2, 4(sp)
	sw a1, 8(sp)
	beq zero, zero, Reading0	
Finish:
	addi sp, sp, 36
	ret
