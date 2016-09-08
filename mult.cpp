#include <iostream>
#include <stdlib.h>
#include <time.h>

using namespace std;

void fillMatrix(int **, int);
void matrixMult(int **, int **, int **, int);
void printMatrix(int **, int);

int main(int argc, const char * argv[]) {

    if (argc != 3) {
        cout << "Se necesita dos argumentos para correr este programa, el primero para el tamano de las matrices, y "
                "otra que es 1 o 0 para indicar para imprimir o no las matrices\n";
        exit(-1);
    }

    clock_t start_t, end_c, end_t, start_c;
    double total_t, total_c;

    start_t = clock();

    int n = atoi(argv[1]);
    int print = atoi(argv[2]);

    int **matA = (int **) malloc(n * sizeof(int *));
    int **matB = (int **) malloc(n * sizeof(int *));
    int **matC = (int **) malloc(n * sizeof(int *));

    for (int i = 0; i < n; ++i) {
        matA[i] = (int *) malloc(n * sizeof(int *));
        matB[i] = (int *) malloc(n * sizeof(int *));
        matC[i] = (int *) malloc(n * sizeof(int *));
    }

    srand((int) time(NULL));

    fillMatrix(matA, n);
    fillMatrix(matB, n);

    start_c = clock();
    matrixMult(matA, matB, matC, n);
    end_c = clock();

    total_c = (double) (end_c - start_c) / (CLOCKS_PER_SEC / 1000);

    if (print) {
        printMatrix(matA, n);
        printMatrix(matB, n);
        printMatrix(matC, n);
    }

    free(matA);
    free(matB);
    free(matC);

    end_t = clock();
    total_t = (double) (end_t - start_t) / (CLOCKS_PER_SEC / 1000);

    cout << "Tiempo de cálculo: " << total_c << " , tiempo total: " << total_t << endl;

    return 0;
}

void fillMatrix(int **m, int n) {

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            m[i][j] = (rand() % 991) + 10;
        }
    }

}

void matrixMult(int **a, int **b, int **c, int n){

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            int sum = 0;
            for (int k = 0; k < n; ++k) {
                sum += a[i][k] * b[k][j];
            }
            c[i][j] = sum;
        }
    }

}

void printMatrix(int **m, int n) {

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            cout << "m[" << i << "][" << j << "]=" << m[i][j] << " " ;
        }
        cout << endl;
    }

}
