.data
array: .space 1024
n: .word 0 # SL phan tu

strNhapN: .asciiz "Nhap so luong phan tu n(n>0): "
strNhapPhanTu: .asciiz "array["
strNhapPhanTu_: .asciiz "] = "


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



# Ket thuc chuong trinh
li $v0, 10
syscall
