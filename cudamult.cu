#include <time.h>
#include "../../common/book.h"

void fillMatrix(int **, int);
void printMatrix(int **, int);

__global__ void matrixMult(int **a, int **b, int *c, int *n) {

    int tid_i = threadIdx.x + blockIdx.x * blockDim.x;	
    
    for (int i = 0; i < *n; ++i) 
    	for(int j = 0; j < *n; ++j)
	    c[(tid_i * (*n)) + i] += a[tid_i][j] * b[j][i];
}

int main(int argc, const char *argv[]) {
 
    if (argc != 3) {
        	printf("Se necesita dos argumentos para correr este programa, el primero para el tamano de las matrices, y "
                "otra que es 1 o 0 para indicar para imprimir o no las matrices\n");
        exit(-1);
    }

    int n = atoi(argv[1]);
    int print = atoi(argv[2]);

    int **matA = (int **) malloc(n * sizeof(int *));
    int **matB = (int **) malloc(n * sizeof(int *));
    int *matC = (int *) malloc(n * n * sizeof(int));

    for (int i = 0; i < n; ++i) {
        matA[i] = (int *) malloc(n * sizeof(int *));
        matB[i] = (int *) malloc(n * sizeof(int *));
    }

    int **dev_ma, **dev_mb, *dev_mc, **tempa, **tempb;
    int *dev_n;

    tempa = (int **) malloc(n * sizeof(int *));
    tempb = (int **) malloc(n * sizeof(int *));

    HANDLE_ERROR(cudaMalloc((void ***) &dev_ma, n * sizeof(int *)));
    HANDLE_ERROR(cudaMalloc((void ***) &dev_mb, n * sizeof(int *)));
    HANDLE_ERROR(cudaMalloc((void **) &dev_mc, n * n * sizeof(int)));

    HANDLE_ERROR(cudaMalloc((void **) &dev_n, n * sizeof(int)));

    srand((int) time(NULL));

    fillMatrix(matA, n);
    fillMatrix(matB, n);

    HANDLE_ERROR(cudaMemcpy(dev_n, &n, sizeof(int), cudaMemcpyHostToDevice));

    for (int i = 0; i < n; ++i) {
	HANDLE_ERROR(cudaMalloc((void **) &tempa[i], n * sizeof(int)));
	HANDLE_ERROR(cudaMemcpy (tempa[i], matA[i], n * sizeof(int), cudaMemcpyHostToDevice));
   	HANDLE_ERROR(cudaMalloc((void **) &tempb[i], n * sizeof(int)));
	HANDLE_ERROR(cudaMemcpy (tempb[i], matB[i], n * sizeof(int), cudaMemcpyHostToDevice));
    }

    HANDLE_ERROR(cudaMemcpy (dev_ma, tempa, n * sizeof(int *), cudaMemcpyHostToDevice) );
    HANDLE_ERROR(cudaMemcpy (dev_mb, tempb, n * sizeof(int *), cudaMemcpyHostToDevice) );
    HANDLE_ERROR(cudaMemcpy (dev_mc, matC, n * n * sizeof(int), cudaMemcpyHostToDevice) );

    matrixMult<<<10,100>>>(dev_ma, dev_mb, dev_mc, dev_n);

    HANDLE_ERROR(cudaMemcpy(matC, dev_mc, n * n * sizeof(int), cudaMemcpyDeviceToHost));

    if (print) {
        printMatrix(matA, n);
        printMatrix(matB, n);

  	for(int i = 0; i < n; ++i) {
	    for(int j = 0; j < n; ++j)
    		printf("m[%d][%d]= %d ", i, j, matC[(i * n) + j]);
	    printf("\n");
   	}
    }

    HANDLE_ERROR( cudaFree( dev_ma ) );
    HANDLE_ERROR( cudaFree( dev_mb ) );
    HANDLE_ERROR( cudaFree( dev_mc ) );

    free(tempa);
    free(tempb);
    free(matA);
    free(matB);
    free(matC);

    return 0;
}

void fillMatrix(int **m, int n) {

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            m[i][j] = (rand() % 991) + 10;
        }
    }

}

void printMatrix(int **m, int n) {

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("m[%d][%d]= %d ", i, j, m[i][j]);
        }
        printf("\n");
    }

}

