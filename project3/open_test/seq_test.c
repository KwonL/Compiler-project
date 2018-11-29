int a;

void kk(void) {
    return;
}

int a(); /* error */

int main() {
    int a;
    int *b;
    char c;
    struct str1 {int a;} *y;

    a = 0;
    foo(); /* error */
    b = 0; /* error */
    &a = NULL; /* error */
    a = y->a;
    a = -a;
    c = -c; /* error */
    c = c++;
    y = y++; /* error */
    a < c; /* error */

    *"string";

    return 0;
}
