int main() {
    int *a; 
    int arr[3];

    arr[0] = 100;
    arr[1] = 200;
    arr[2] = 300;

    a = arr;

    /*
    write_int(*a);
    write_string("\n");
    */
    write_int(a[1]);
    write_string("\n");
    write_int(arr[2]);
    write_string("\n");

    write_int(*(++a));
    write_string("\n");
    write_int(*(++a));
    write_string("\n");
    write_int(a[0]);
    write_string("\n");
}