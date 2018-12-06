void func(int a) {
    int b;
    b = a;

    write_int(b);
    write_string("\n");
}

int main() {
    int a;
    int b;
    
     a = 1;
     b = 2;

     if (a <= b) {
         func(a);
     }
     else {
         func(b);
     }

     a++;
     if (a == b) {
         func(a);
     }
     
     b--;
     func(b);

     if (--a == b) {
         write_char('h');
         write_string("kkkk\n");
     }
}