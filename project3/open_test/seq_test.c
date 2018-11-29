int a;

int main() {
    int a;
    int *b;
    char c;
    struct str1 {int a;} *y;

    a = 0;
    foo(); /* error */
    b = 0; /* error */
    &a = NULL;
    a = y->a;
    a = -a;
    c = -c; /* error */
    c = c++;
    y = y++; /* error */
    a < c; /* error */

    return 0;
}
