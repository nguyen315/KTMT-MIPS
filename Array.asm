.data
array: .space 1024
n: .word 0 # SL phan tu

strNhapN: .asciiz "Nhap so luong phan tu n(n>0): "
strNhapPhanTu: .asciiz "array["
strNhapPhanTu_: .asciiz "] = "
strDauPhay: .asciiz ", "


.text
main:
############# Bat dau phan nhap n
NhapN:
	la $a0, strNhapN
	li $v0, 4
	syscall

	li $v0,5
	syscall
	blez $v0, NhapN
	
sw $v0, n

############# Ket thuc phan nhap n



############# Bat dau phan nhap mang

# $s2 luu so phan tu n
lw $s2, n
# $s3 la bien dem 
li $s3, 0

# Load dia chi array[0] vao $s1
la $s1, array

# Bat dau nhap mang
NhapMangNPhanTu:
	### In ra string huong dan nhap: array[...]
	la $a0, strNhapPhanTu
	li $v0, 4
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall

	la $a0, strNhapPhanTu_
	li $v0, 4
	syscall
	###


	
	# syscall 5 de nhap int
	li $v0,5
	syscall

	# Luu vao array tuong ung
	sw $v0, ($s1)

	
	# Thay doi gia tri cac bien dem
	addi $s1, $s1, 4
	addi $s3, $s3, 1


	blt $s3, $s2, NhapMangNPhanTu

############# Ket thuc phan nhap mang

# Main
jal LietKeSNT
j FinishProcedure

############# Liet ke phan tu la so nguyen to

#### Ham Chinh
LietKeSNT:
	# Khoi tao bien dem o $t0
	li $t0, 0
	la $t5, array
	move $t6, $ra

	# --- Duyet tung phan tu trong mang
	Loop:
		# Lay gia tri array[$t0] luu vao $t1
		
		lw $t1, ($t5)
		jal isPrime
		
		# Kiem tra gia tri tra ve o $v0
		beq $v0, $zero, SetUpNextLoop
		# Neu bang 1 thi in gia tri SNT		
		move $a0, $t1
		li $v0, 1
		syscall

		la $a0, strDauPhay
		li $v0, 4
		syscall

		SetUpNextLoop:
			# Tang bien dem
			addi $t0, $t0, 1
			addi $t5, $t5, 4 # $t5 luu gia tri dia chi phan tu array hien tai
			# So sanh dieu kien dung vong lap
			blt $t0, $s2, Loop

	# ket thuc ham
	move $ra, $t6
	jr $ra

# ---------- Ket thuc ham chinh

#### Kiem tra mot so la so nguyen to
isPrime:
	blt $t1, 2, isPrimeFalse # t1 < 2
	beq $t1, 2, isPrimeTrue # t1 == 2

	# t1 > 2 
	# Khoi tao bien dem o $t2
	li $t2, 2
	IsPrimeLoop:
		div $t3, $t1, $t2       # $t3 = $t1 / $t2
		mfhi $t4                # $t4 = so du
		beq $t4, $zero, isPrimeFalse
		# Tang bien dem
		addi $t2, $t2, 1
		# So sanh dieu kien dung vong lap
		blt $t2, $t1, IsPrimeLoop

	isPrimeTrue:
		li $v0, 1
		jr $ra
	isPrimeFalse:	
		li $v0, 0
		jr $ra

############# Ket thucc liet ke phan tu la so nguyen to

# Ket thuc chuong trinh
FinishProcedure:
li $v0, 10
syscall
