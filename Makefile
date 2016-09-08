ALL: Mult OMP CUDAMult C1B C1T 
CFLAGS=-fopenmp

.PHONY:clean

clean:
	\rm -f *.o Mult OMP CUDAMult C1B C1T

Mult: mult.cpp
	g++ mult.cpp -g -o Mult

OMP: multomp.cpp
	g++ $(CFLAGS) multomp.cpp -g -o OMP

CUDAMult: cudamult.cu
	nvcc cudamult.cu -g -o CUDAMult

C1B: cuda1b.cu
	nvcc cuda1b.cu -g -o C1B

C1T: cuda1t.cu
	nvcc cuda1t.cu -g -o C1T
