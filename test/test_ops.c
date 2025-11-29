#include <stdio.h>
#include "../src/ops.h"

int main() {
    int result = add(2, 3);
    if (result == 5) {
        printf("Test passed: add(2, 3) = %d\n", result);
        return 0;
    } else {
        printf("Test failed: add(2, 3) = %d, expected 5\n", result);
        return 1;
    }
}
