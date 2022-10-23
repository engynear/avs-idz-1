#include <stdio.h>

extern int ARRAY_A[];
extern int ARRAY_B[];

void Create(int n) {
    int i, j = 0, k = 0;
    for (i = 0; i < n; ++i) {
        if (ARRAY_A[i] % 2 != 0) {
            ARRAY_B[j] = ARRAY_A[i];
            ++j;
        } else {
            ARRAY_B[n - 1 - k] = ARRAY_A[i];
            ++k;
        }
    }
}