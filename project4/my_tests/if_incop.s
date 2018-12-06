	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
func :
	shift_sp 1
func_start :
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_reg fp
	push_const 1
	add
	fetch
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
func_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
func_end :
main :
	shift_sp 2
main_start :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_const 2
	assign
	fetch
	shift_sp -1
label_0 :
	push_reg fp
	push_const 1
	add
	fetch
	push_reg fp
	push_const 2
	add
	fetch
	less_equal
	branch_false label_1
	shift_sp 1
	push_const label_2
	push_reg fp
	push_reg fp
	push_const 1
	add
	fetch
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump func
label_2 :
	shift_sp -1
	jump label_3
label_1 :
	shift_sp 1
	push_const label_4
	push_reg fp
	push_reg fp
	push_const 2
	add
	fetch
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump func
label_4 :
	shift_sp -1
label_3 :
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
label_5 :
	push_reg fp
	push_const 1
	add
	fetch
	push_reg fp
	push_const 2
	add
	fetch
	equal
	branch_false label_6
	shift_sp 1
	push_const label_7
	push_reg fp
	push_reg fp
	push_const 1
	add
	fetch
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump func
label_7 :
	shift_sp -1
label_6 :
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	sub
	assign
	fetch
	push_const 1
	add
	shift_sp -1
	shift_sp 1
	push_const label_8
	push_reg fp
	push_reg fp
	push_const 2
	add
	fetch
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump func
label_8 :
	shift_sp -1
label_9 :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	fetch
	push_const 1
	sub
	assign
	fetch
	push_reg fp
	push_const 2
	add
	fetch
	equal
	branch_false label_10
	push_const 104
	write_char
Str1. string "kkkk\n"
	push_const Str1
	write_string
label_10 :
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
