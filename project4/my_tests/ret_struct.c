struct str {
    int a;
    int b;
    char c; 
};

struct str func(int a, int b) {
    struct str tmp;

    tmp.a = a; 
    tmp.b = b;
    tmp.c = 'a';

    return tmp;
}

int main() {
    struct str ret;
    int a;
    int b;

    a = 150;
    b = 200;
    ret = func(a, b);

    write_int(ret.a);
    write_string("\n");
    write_int(ret.b);
    write_string("\n");
    write_char(ret.c);
    write_string("\n");
}