int func(int a) {
    return a;
}

void print_func(char* s) {
    write_string(s);
}

int main() {
    int a;
    int b;
    int c;

    a = 3000;
    b = 5000;

    c = func(a + b);
    
    write_int(c);
    write_string("\n");

    print_func("Hi\n");
}