	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
main :
	shift_sp 4
main_start :
	push_reg fp
	push_const 2
	add
	push_const 0
	add
	push_reg sp
	fetch
	push_const 100
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	push_const 1
	add
	push_reg sp
	fetch
	push_const 200
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	push_const 2
	add
	push_reg sp
	fetch
	push_const 300
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_reg fp
	push_const 2
	add
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 1
	add
	fetch
	push_const 1
	add
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
	push_reg fp
	push_const 2
	add
	push_const 2
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
	fetch
	write_int
Str2. string "\n"
	push_const Str2
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
	fetch
	write_int
Str3. string "\n"
	push_const Str3
	write_string
	push_reg fp
	push_const 1
	add
	fetch
	push_const 0
	add
	fetch
	write_int
Str4. string "\n"
	push_const Str4
	write_string
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
