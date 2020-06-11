.data
array: .space 1024
n: .word 0 # SL phan tu

strNhapN: .asciiz "Nhap so luong phan tu n(n>0): "
strNhapPhanTu: .asciiz "array["
strNhapPhanTu_: .asciiz "] = "
strXuatArray: .asciiz "array: "
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

	
	# Thay doi gia tri bien dem va tang gia tri cua array
	addi $s1, $s1, 4
	addi $s3, $s3, 1


	blt $s3, $s2, NhapMangNPhanTu




############# Ket thuc phan nhap mang


##### 
ChuongTrinhChinh:

	lw $a1, n
	la $a2, array
	jal XuatArray

	j KetThuc

#####
# Ket thuc chuong trinh
KetThuc:
	li $v0, 10
	syscall















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






