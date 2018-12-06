int *a;
int b[10];

int main() {
    int c;
    int* kk[10];

    c = 2;
    b[0] = 10;
    kk[3] = b;
    
    a = &c;
    write_int(*a);
    write_string("\n");

    a = b;
    write_int(*a);
    write_string("\n");
    write_int(*kk[3]);
    write_string("\n");
}