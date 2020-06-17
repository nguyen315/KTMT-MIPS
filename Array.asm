.data
array: .space 1024
n: .word 0 # SL phan tu
max: .word 0

strKQTong: .asciiz "Ket qua tong cac phan tu trong mang la: "
strNhapN: .asciiz "Nhap so luong phan tu n(n>0): "
strNhapPhanTu: .asciiz "array["
strNhapPhanTu_: .asciiz "] = "
strXuatArray: .asciiz "array: "
strDauPhay: .asciiz ", "
strNhapX: .asciiz "Nhap vao gia tri cua x can tim: "
strViTriX: .asciiz "X nam o vi tri thu: "
strMax: .asciiz "Max: "



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

	
	# Thay doi gia tri bien dem va tang gia tri cua array
	addi $s1, $s1, 4
	addi $s3, $s3, 1


	blt $s3, $s2, NhapMangNPhanTu




############# Ket thuc phan nhap mang

# Main
#jal LietKeSNT
jal findX
j FinishProcedure


# ---------- Ket thuc ham chinh









################# FUNCTION #################


############# Xuat phan tu
# $a1 luu n, $a2 luu dia chi array[0]

XuatArray:
	
	la $a0, strXuatArray
	li $v0, 4
	syscall	

	# a3 la bien dem
	li $a3, 0

	LoopXuatArray:
		# Dua so trong arr vao $a0 de xuat
		lw $a0, ($a2)
	
		li $v0, 1
		syscall

		# Thay doi gia tri bien dem va tang gia tri cua array
		addi $a2, $a2, 4
		addi $a3, $a3, 1 

		# Xuat dau phay cho de nhin
		# Neu la so cuoi thi khong xuat dau phay
		blt $a3, $1, XuatDauPhay
		j TiepTucLoop
		XuatDauPhay:
			la $a0, strDauPhay
			li $v0, 4
			syscall

		
		TiepTucLoop:
			blt $a3, $a1, LoopXuatArray
	

	# Xong het thi return lai chuong trinh chinh
	jr $ra

############# Ket thuc xuat phan tu




############# Tim Max
# $a1 luu n, $a2 luu dia chi array[0]
# $v0 luu gia tri Max
TimMax:
	# Gan $v0 = array[0]
	lw $v0, ($a2)
	
	# $a3 la bien dem
	li $a3, 0
	
	LoopTimMax:

		# neu array[x] <= $v0 thi nhay toi TiepTucTimMax ma khong thay doi gia tri max
		lw $a0, ($a2)
		ble $a0, $v0, TiepTucTimMax
		
		# Thay doi gia tri max
		lw $v0, ($a2)

		TiepTucTimMax:
			# Thay doi gia tri bien dem va tang gia tri cua array
			addi $a2, $a2, 4
			addi $a3, $a3, 1 
			
			blt $a3, $a1, LoopTimMax
			
	# Xong het thi quay lai chuong trinh chinh
	# max duoc luu trong $v0 khi return
	
	jr $ra			

############# Ket thuc tim max



############# Liet ke phan tu la so nguyen to

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
############# Ket thucc liet ke phan tu la so nguyen to


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

#### Ket thuc kiem tra so nguyen to

#### Ket thuc chuong trinh
FinishProcedure:
li $v0, 10
syscall


########### Tinh Tong cac phan tu trong mang

sumArr:
	lw $a1, n # $a1 = so phan tu trong mang
	la $s0, array
	li $a0, 0
	li $s1, 0 # Bien dem
	j sumLoop


sumLoop: # Tong cac gia tri trong mang arrInt
	beq $s1, $a1, resultSum
	lw $t0, ($s0)
	add $a0, $a0, $t0
	addi $s0, $s0, 4
	addi $s1, $s1, 1
	j sumLoop

resultSum:
	move $t0, $a0
	la $a0, strKQTong
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
  jr $ra

findX:
	la $s0, array
	lw $s1, n # So phan tu
	la $a0, strNhapX
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	li $t1, 0 # Bien dem
	j findLoop
findLoop:
	beq $t1, $s1, N_A # Khong co x trong mang
	lw $t2, ($s0)
	beq $t0, $t2, Pos # Co x trong mang => tra ve vi tri cua x
	addi $s0, $s0, 4
	addi $t1, $t1, 1
	j findLoop
Pos:
	addi $t1, $t1, 1
	la $a0, strViTriX
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	jr $ra
N_A:
	li $a0, -1
	li $v0, 1
	syscall
	jr $ra
