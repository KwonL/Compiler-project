	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
main :
	shift_sp 28
main_start :
	push_reg fp
	push_const 15
	add
	push_reg sp
	fetch
	push_const 3
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 15
	add
	push_const 1
	add
	push_reg sp
	fetch
	push_const 8
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 15
	add
	push_const 2
	add
	push_reg sp
	fetch
	push_const 10
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 15
	add
	push_const 3
	add
	push_reg sp
	fetch
	push_const 12
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 15
	add
	push_const 4
	add
	push_const 5
	add
	push_reg sp
	fetch
	push_const 5
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
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg sp
	fetch
	push_const 1
	add
	push_reg fp
	push_const 15
	add
	fetch
	shift_sp -1
	push_reg fp
	push_const 28
	add
	fetch
	assign
	push_reg fp
	push_const 27
	add
	fetch
	assign
	push_reg fp
	push_const 26
	add
	fetch
	assign
	push_reg fp
	push_const 25
	add
	fetch
	assign
	push_reg fp
	push_const 24
	add
	fetch
	assign
	push_reg fp
	push_const 23
	add
	fetch
	assign
	push_reg fp
	push_const 22
	add
	fetch
	assign
	push_reg fp
	push_const 21
	add
	fetch
	assign
	push_reg fp
	push_const 20
	add
	fetch
	assign
	push_reg fp
	push_const 19
	add
	fetch
	assign
	push_reg fp
	push_const 18
	add
	fetch
	assign
	push_reg fp
	push_const 17
	add
	fetch
	assign
	push_reg fp
	push_const 16
	add
	fetch
	assign
	push_reg fp
	push_const 15
	add
	fetch
	assign
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	shift_sp 14
	shift_sp -14
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
	push_reg fp
	push_const 1
	add
	push_const 2
	add
	fetch
	write_int
Str2. string "\n"
	push_const Str2
	write_string
	push_reg fp
	push_const 1
	add
	push_const 3
	add
	fetch
	write_int
Str3. string "\n"
	push_const Str3
	write_string
	push_reg fp
	push_const 1
	add
	push_const 4
	add
	push_const 5
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
