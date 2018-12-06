	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
main :
	shift_sp 11
main_start :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_const 2
	assign
	fetch
	shift_sp -1
	push_const Lglob+1
	push_const 0
	add
	push_reg sp
	fetch
	push_const 10
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	push_const 3
	add
	push_reg sp
	fetch
	push_const Lglob+1
	assign
	fetch
	shift_sp -1
	push_const Lglob+0
	push_reg sp
	fetch
	push_reg fp
	push_const 1
	add
	assign
	fetch
	shift_sp -1
	push_const Lglob+0
	fetch
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
	push_const Lglob+0
	push_reg sp
	fetch
	push_const Lglob+1
	assign
	fetch
	shift_sp -1
	push_const Lglob+0
	fetch
	fetch
	write_int
Str1. string "\n"
	push_const Str1
	write_string
	push_reg fp
	push_const 2
	add
	push_const 3
	add
	fetch
	fetch
	write_int
Str2. string "\n"
	push_const Str2
	write_string
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 11
