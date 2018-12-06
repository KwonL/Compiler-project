	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
func :
	shift_sp 2
func_start :
	push_reg fp
	push_const 3
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
	push_const 3
	add
	push_const 1
	add
	push_reg sp
	fetch
	push_reg fp
	push_const 1
	add
	push_const 1
	add
	fetch
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const -1
	add
	push_const -2
	add
	push_reg fp
	push_const -1
	add
	push_const -1
	add
	push_reg fp
	push_const 3
	add
	fetch
	shift_sp -1
	push_reg fp
	push_const 4
	add
	fetch
	assign
	push_reg fp
	push_const 3
	add
	fetch
	assign
func_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
func_end :
main :
	shift_sp 4
main_start :
	push_reg fp
	push_const 3
	add
	push_reg sp
	fetch
	push_const 7
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 3
	add
	push_const 1
	add
	push_reg sp
	fetch
	push_const 14
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	push_const 1
	add
	shift_sp 2
	push_const label_0
	push_reg fp
	push_reg fp
	push_const 3
	add
	fetch
	push_reg fp
	push_const 4
	add
	fetch
	push_reg sp
	push_const -2
	add
	pop_reg fp
	jump func
label_0 :
	push_reg sp
	push_const -2
	add
	fetch
	push_reg sp
	push_const -1
	add
	fetch
	assign
	shift_sp -1
	push_reg sp
	push_const -2
	add
	fetch
	push_reg sp
	push_const -1
	add
	fetch
	assign
	shift_sp -1
	shift_sp -2
	shift_sp -2
	push_reg fp
	push_const 1
	add
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
	push_reg fp
	push_const 1
	add
	push_const 1
	add
	fetch
	write_int
Str1. string "\n"
	push_const Str1
	write_string
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
