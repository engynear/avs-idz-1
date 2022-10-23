#include <stdio.h>

extern int ARRAY_B[];

void Print(int n) {
    int i;
    for (i = 0; i < n; i++) {
        printf("%d ", ARRAY_B[i]);
    }
}