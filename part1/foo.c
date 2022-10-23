#include <stdio.h>

static int ARRAY_A[1048576];
static int ARRAY_B[1048576];

int main(int argc, char** argv) {
    int n, i, j = 0, k = 0;
    scanf("%d", &n);

    for (i = 0; i < n; ++i) {
        scanf("%d", &ARRAY_A[i]);
    }

    for (i = 0; i < n; ++i) {
        if (ARRAY_A[i] % 2 != 0) {
            ARRAY_B[j] = ARRAY_A[i];
            ++j;
        } else {
            ARRAY_B[n - 1 - k] = ARRAY_A[i];
            ++k;
        }
    }

    for (i = 0; i < n; ++i) {
        printf("%d ", ARRAY_B[i]);
    }
}