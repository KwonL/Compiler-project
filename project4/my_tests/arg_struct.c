struct str1 {
    int a;
    int b; 
};

struct str2 {
    int ab;
    int bc;
};

struct str1 func(struct str2 kk) {
    struct str1 tmp;

    tmp.a = kk.ab;
    tmp.b = kk.bc;

    return tmp;
}

int main() {
    struct str1 ret;
    struct str2 arg;

    arg.ab = 7;
    arg.bc = 14;
    
    ret = func(arg);

    write_int(ret.a);
    write_string("\n");
    write_int(ret.b);
    write_string("\n");     
}