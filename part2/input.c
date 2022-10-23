#include <stdio.h>

extern int ARRAY_A[];

void Input(int n) {
    int i;
    for (i = 0; i < n; ++i) {
        scanf("%d", &ARRAY_A[i]);
    }
}