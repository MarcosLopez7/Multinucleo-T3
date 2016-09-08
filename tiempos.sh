#!/bin/bash

tiempos=`ls tiempos.txt`

make

if [ $tiempos == "tiempos.txt" ]; then
	rm tiempos.txt
fi

touch tiempos.txt

N=100

echo "" >> tiempos.txt
echo "CPU secuencial" >> tiempos.txt
echo "" >> tiempos.txt

for (( I = 0; I < 10; I++ ))
do
	contc=0
	contt=0
	echo "N = $N" >> tiempos.txt
	for (( J = 0; J < 10; J++ ))
	do
		linea=`./Mult $N 0`
		echo "$linea" >> tiempos.txt
		K=0
		for word in $linea; do
			if [ $K -eq 3 ]; then
				contc=`echo "$contc+$word" | bc -l`
			fi
			if [ $K -eq 7 ]; then
                                contt=`echo "$contt+$word" | bc -l`
                        fi
			let K=K+1
		done
	done
	promc=`echo "$contc/10" | bc -l`
	promt=`echo "$contt/10" | bc -l`

	echo "Los promedios son: $promc $promt" >> tiempos.txt	

	let N=N+100
done 


N=100

echo "" >> tiempos.txt
echo "CPU OMP" >> tiempos.txt
echo "" >> tiempos.txt

for (( I = 0; I < 10; I++ ))
do
        contc=0
        contt=0
        echo "N = $N" >> tiempos.txt
        for (( J = 0; J < 10; J++ ))
        do
                linea=`./OMP $N 0`
                echo "$linea" >> tiempos.txt
                K=0
                for word in $linea; do
                        if [ $K -eq 3 ]; then
                                contc=`echo "$contc+$word" | bc -l`
                        fi
                        if [ $K -eq 7 ]; then
                                contt=`echo "$contt+$word" | bc -l`
                        fi
                        let K=K+1
                done
        done
        promc=`echo "$contc/10" | bc -l`
        promt=`echo "$contt/10" | bc -l`

        echo "Los promedios son: $promc $promt" >> tiempos.txt

        let N=N+100
done

N=200

echo "" >> tiempos.txt
echo "GPU 1 bloque n threads" >> tiempos.txt
echo "" >> tiempos.txt

for (( I = 0; I < 10; I++ ))
do
        contc=0
        contt=0
        echo "N = $N" >> tiempos.txt
        for (( J = 0; J < 10; J++ ))
        do
                linea=`./C1B $N 0`
                echo "$linea" >> tiempos.txt
                K=0
                for word in $linea; do
                        if [ $K -eq 3 ]; then
                                contc=`echo "$contc+$word" | bc -l`
                        fi
                        if [ $K -eq 7 ]; then
                                contt=`echo "$contt+$word" | bc -l`
                        fi
                        let K=K+1
                done
        done
        promc=`echo "$contc/10" | bc -l`
        promt=`echo "$contt/10" | bc -l`

        echo "Los promedios son: $promc $promt" >> tiempos.txt

        let N=N+200
done

N=200

echo "" >> tiempos.txt
echo "GPU 1 THREAD N BLOQUES" >> tiempos.txt
echo "" >> tiempos.txt

for (( I = 0; I < 10; I++ ))
do
        contc=0
        contt=0
        echo "N = $N" >> tiempos.txt
        for (( J = 0; J < 10; J++ ))
        do
                linea=`./C1T $N 0`
                echo "$linea" >> tiempos.txt
                K=0
                for word in $linea; do
                        if [ $K -eq 3 ]; then
                                contc=`echo "$contc+$word" | bc -l`
                        fi
                        if [ $K -eq 7 ]; then
                                contt=`echo "$contt+$word" | bc -l`
                        fi
                        let K=K+1
                done
        done
        promc=`echo "$contc/10" | bc -l`
        promt=`echo "$contt/10" | bc -l`

        echo "Los promedios son: $promc $promt" >> tiempos.txt

        let N=N+200
done

N=200

echo "" >> tiempos.txt
echo "GPU n/10 BLOQUES X N/5 THREADS" >> tiempos.txt
echo "" >> tiempos.txt

for (( I = 0; I < 10; I++ ))
do
        contc=0
        contt=0
        echo "N = $N" >> tiempos.txt
        for (( J = 0; J < 10; J++ ))
        do
                linea=`./OMP $N 0`
                echo "$linea" >> tiempos.txt
                K=0
                for word in $linea; do
                        if [ $K -eq 3 ]; then
                                contc=`echo "$contc+$word" | bc -l`
                        fi
                        if [ $K -eq 7 ]; then
                                contt=`echo "$contt+$word" | bc -l`
                        fi
                        let K=K+1
                done
        done
        promc=`echo "$contc/10" | bc -l`
        promt=`echo "$contt/10" | bc -l`

        echo "Los promedios son: $promc $promt" >> tiempos.txt

        let N=N+200
done

echo "" >> tiempos.txt
echo "Caracteristicas de la computadora: " >> tiempos.txt

echo "GPU max clock rate	980 MHz" >> tiempos.txt
echo "CUDA Cores	1344" >> tiempos.txt
echo "GPU 	geforce  GTX 670" >> tiempos.txt
echo "CPU 	i7-4770" >> tiempos.txt
echo "CPU speed	3.4 GHz" >> tiempos.txt
echo "CPU CORES	4 fisicos + 4 virtuales" >> tiempos.txt

echo "en GPU de 1 bloque con n thread, fue mejor apartir de 1200 mayor a N" >> tiempos.txt
echo "en GPU de 1 thread con n bloques, fue mejor en N = 1000, por una extraña razón, ya no podía calcular después de esa N
" >> tiempos.txt
echo "en GPU de n/10 bloques con n/5 threads, fue mejor desde N = 1000" >> tiempos.txt

rm OMP Mult C1B C1T CUDAMult
