struct str {
    int a;
    int b;
    int c;
    int d;
    int x[10];
};

int main() {
    struct str a1;
    struct str a2;

    a2.a = 3;
    a2.b = 8;
    a2.c = 10;
    a2.d = 12;
    a2.x[5] = 5;
    a1 = a2;

    write_int(a1.a);
    write_string("\n");
    write_int(a1.b);
    write_string("\n");
    write_int(a1.c);
    write_string("\n");
    write_int(a1.d);
    write_string("\n");
    write_int(a1.x[5]);
    write_string("\n");
}