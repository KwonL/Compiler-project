	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
main :
	shift_sp 2
main_start :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_const 0
	assign
	fetch
	shift_sp -1
label_0 :
	push_reg fp
	push_const 1
	add
	fetch
	push_const 6
	less
	branch_false label_1
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_const 0
	assign
	fetch
	shift_sp -1
label_2 :
	push_reg fp
	push_const 2
	add
	fetch
	push_const 3
	less
	branch_false label_3
	push_reg fp
	push_const 2
	add
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	add
	assign
	fetch
	push_const 1
	sub
	shift_sp -1
	jump label_2
label_3 :
label_4 :
	push_reg fp
	push_const 1
	add
	fetch
	push_const 5
	equal
	branch_false label_5
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	add
	assign
	fetch
	push_const 1
	sub
	shift_sp -1
	jump label_0
label_5 :
	push_reg fp
	push_const 1
	add
	fetch
	write_int
Str1. string "\n"
	push_const Str1
	write_string
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	add
	assign
	fetch
	push_const 1
	sub
	shift_sp -1
	jump label_0
label_1 :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_const 0
	assign
	fetch
	shift_sp -1
label_6 :
	push_reg fp
	push_const 1
	add
	fetch
	push_const 10
	less
	branch_false label_9
	jump label_8
label_7 :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	add
	assign
	fetch
	push_const 1
	sub
	jump label_6
label_8 :
label_10 :
	push_reg fp
	push_const 1
	add
	fetch
	push_const 5
	equal
	branch_false label_11
	jump label_9
label_11 :
	push_reg fp
	push_const 1
	add
	fetch
	write_int
Str2. string "\n"
	push_const Str2
	write_string
	jump label_7
label_9 :
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
