#include <stdio.h>

int ARRAY_A[1048576];
int ARRAY_B[1048576];

extern void Input(int n);
extern void Create(int n);
extern void Print(int n);

int main(int argc, char **argv) {
    int n;
    scanf("%d", &n);

    Input(n);
    Create(n);
    Print(n);
}