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
	push_const 1
	add
	push_reg sp
	fetch
	push_reg sp
	fetch
	push_const 1
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
	fetch
	shift_sp -1
	fetch
	shift_sp -1
	shift_sp 2
	shift_sp -2
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
