int main() {
    int i;
    int j;

    i = 0;
    while (i < 6) {
        j = 0;
        while (j < 3) {
            write_int(j);
            write_string("\n");
            j++;
        }
        if (i == 5) {
            i++;
            continue;
        }
        write_int(i);
        write_string("\n");
        i++;
    }
    
    for (i = 0; i < 10; i++) {
        if (i == 5) {
            break;
        }
        write_int(i);
        write_string("\n");
    }
}