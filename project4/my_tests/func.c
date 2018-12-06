int func(int a, int b) {
    return a + b;
}

int main() {
    int a;
    int b;

    a = 1;
    b = 2;

    write_int(func(a,b));
    write_string("\n");
}