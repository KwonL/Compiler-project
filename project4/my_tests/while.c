int main() {
    int i;

    i = 0;
    while (i < 10) {
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