	push_const EXIT
	push_reg fp
	push_reg sp
	pop_reg fp
	jump main
EXIT :
	exit
func :
func_start :
	push_reg fp
	push_const -1
	add
	push_const -1
	add
	push_reg fp
	push_const 1
	add
	fetch
	assign
	jump func_final
func_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
func_end :
print_func :
print_func_start :
	push_reg fp
	push_const 1
	add
	fetch
	write_string
print_func_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
print_func_end :
main :
	shift_sp 3
main_start :
	push_reg fp
	push_const 1
	add
	push_reg sp
	fetch
	push_const 3000
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 2
	add
	push_reg sp
	fetch
	push_const 5000
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 3
	add
	push_reg sp
	fetch
	shift_sp 1
	push_const label_0
	push_reg fp
	push_reg fp
	push_const 1
	add
	fetch
	push_reg fp
	push_const 2
	add
	fetch
	add
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump func
label_0 :
	assign
	fetch
	shift_sp -1
	push_reg fp
	push_const 3
	add
	fetch
	write_int
Str0. string "\n"
	push_const Str0
	write_string
	shift_sp 1
	push_const label_1
	push_reg fp
Str1. string "Hi\n"
	push_const Str1
	push_reg sp
	push_const -1
	add
	pop_reg fp
	jump print_func
label_1 :
	shift_sp -1
main_final :
	push_reg fp
	pop_reg sp
	pop_reg fp
	pop_reg pc
main_end :
Lglob.	data 0
