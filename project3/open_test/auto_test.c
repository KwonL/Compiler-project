int func1() {
    int a;
    int b;
    char a; /* error */

    char c;

    return c = a + b; /* error */
}

char str;

struct str {
    int a;
};

int main() {
    int a;
    struct str str;

    func1(a); /* error */

    not_declared_func(); /* error */

    return 0;
}
