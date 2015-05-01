/*
    $ gcc main.c -o brese.run -std=gnu99
    $ ./brese.run N
    $ ./brese.run 6
*/

#include "stdio.h"  // prinf
#include "stdlib.h" // atoi

#define TOTAL_CICLOS 10

int main(int argc, char const *argv[]){
    
    if(argc < 2){
        printf("{erro} informe um número entre [0, 10]. Por exemplo:\n"
                "$ ./brese.run 7\n");
        return 1;
    }

    int placar_A = atoi(argv[1]);
    int placar_B = TOTAL_CICLOS - placar_A;

    if(placar_A < 0 || placar_A > 10){
        printf("{erro} o número deve estar entre [0, 10].\n");
        return 1;
    }

    int E_A = 2*placar_A - TOTAL_CICLOS;
    int E_B = 2*placar_B - TOTAL_CICLOS;

    int placar[2] = {placar_A, placar_B};
    int E[2] = {E_A, E_B};
    char L[2] = {'A', 'B'};

    printf("\n");

    for(int X = 0; X < 2; X++){
        
        printf("%c: [", L[X]);
        for(int i = 0; i < placar[X]; i++)
            printf("1");
        for(int i = 0; i < TOTAL_CICLOS - placar[X]; i++)
            printf("0");
        printf("]:[");

        for(int contCiclos = 0; contCiclos <= TOTAL_CICLOS; contCiclos++){
            if(E[X] >= 0){
                E[X] += 2*(placar[X] - TOTAL_CICLOS);
                printf("%d", 1);
            }else{
                E[X] += 2*placar[X];
                printf("%d", 0);
            }
        }

        printf("]\n");
    }

    printf("\n");

    return 0; 
}