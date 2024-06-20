int main() {
    int x = -10;
    float y = 5.5;
    char z = 'a';

    if (x > y) {
        x = x + 1;
    } else {
        y = y - 1.0;
    }

    while (x != 0) {
        x = x - 1;
    }

    return 0;
}