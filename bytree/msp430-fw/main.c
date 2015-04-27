/*
    Projeto:
        - Ocupação Digital UFPR: bytree

    Plataforma:
        - MSP430G2553

*/


#include <msp430.h>
#include <stdlib.h> // atoi
#include <string.h> // strcat

#define RX_pin BIT1 // P1.1
#define TX_pin BIT2 // P1.2
#define OPTO   BIT3 // optoacoplador P1.3
#define LED_A  BIT4 // TRIAC P1.4
#define LED_B  BIT5 // TRIAC P1.5

// período total para o Algoritmo de Bresenham
#define TOTAL_CICLOS 10


void Serial_config(void);
void Serial_receive(void);
void P1_interrupcao(void);

// pontuação do jogador A
int pontosPlayerA;
// pontuação recebida pela UART
char serialString[4];
// contador de cilcos para o Algoritmo de Bresenham
uint8_t contCiclos = 0;

void main(void){
    
    // desabilita wdt
    WDTCTL = WDTPW + WDTHOLD;

    // configura clock 8MHz
    BCSCTL1 = CALBC1_8MHZ;
    DCOCTL = CALDCO_8MHZ;

    // configura saídas
    P1DIR = (LED_A | LED_B);
    // habilita e ativa o resistor pullup do opto e apaga os leds
    P1REN = P1OUT = OPTO;
    // habilita int. somente no opto
    P1IE = OPTO;
    // config. como borda de subida
    P1IES &= ~OPTO;
    // limpa int. P1
    P1IFG = 0;

    // limpa a string
    // strcpy(serialString, "");
    serialString[0] = '\0';

    Serial_config();

    // habilita GIE
    __enable_interrupt();
        
    // while(1);
    __bis_SR_register(LPM4_bits); // low power mode 4
}

void Serial_config(void){
    // configura pinos serial
    P1SEL |= (RX_pin + TX_pin);
    P1SEL2 |= (RX_pin + TX_pin);

    // USCI reset: desabilitado para operacao
    // UCSWRST (BIT1) = 1
    UCA0CTL1 |= UCSWRST; // |= 0x01

    // modo UART:
        // UCMODE1 (BIT2) = 0
        // UCMODE0 (BIT1) = 0
    // modo assincrono:
        // UCSYNC (BIT0) = 0
    UCA0CTL0 &= ~(UCMODE1 + UCMODE0 + UCSYNC); // &= ~0x07

    // USCI clock: modo 2 (SMCLK):
    // UCSSEL (BIT7 e BIT6):
            // (BIT7) = 1
            // (BIT6) = 0
    UCA0CTL1 |= UCSSEL_2; // |= 0x80

    // Oversampling desabilitado
        //  UCOS16 (BIT1) = 0
    UCA0MCTL &= ~UCOS16;

    // 9600 bps: 8M / 9600 = 833,333
    // int(8M / 9600) = 833 = 0x[03][41]
    // round((833,333 - 833)*8) = [3]
    UCA0BR1 = 0x03;
    UCA0BR0 = 0x41;
    UCA0MCTL |= 0x06; // |= (0x[3]) << 1;

    // USCI reset: liberado para operacao
    UCA0CTL1 &= ~UCSWRST; // &= ~0x01

    // Habilita int. de recepcao
    IE2 |= UCA0RXIE;
}

#pragma vector = USCIAB0RX_VECTOR
__interrupt void Serial_receive(void){

    // concatena
    strcat(serialString, UCA0RXBUF);

    if(UCA0RXBUF != '\0'){
        // converte a string para (int)
        playerA = atoi(serialString);
        
        // limpa a string
        //strcpy(serialString, "");
        serialString[0] = '\0';

        // força o reset
        contCiclos = TOTAL_CICLOS;
    }

    // limpa flag interrupt serial
    IFG2 &= ~UCA0RXIFG;
}

#pragma vector = PORT1_VECTOR
__interrupt void P1_interrupcao(void){

    /* implementação do Algoritmo de Bresenham */

    // qtde de ciclos a serem distribuídos
    uint8_t ciclosPlayerA = (uint8_t) (((float)pontosPlayerA / 100.0) * TOTAL_CICLOS);
    uint8_t ciclosPlayerB = (uint8_t) (((float)(100-pontosPlayerA) / 100.0) * TOTAL_CICLOS);

    // cte de Bresenham
    static uint8_t E_A = 2*ciclosPlayerA - TOTAL_CICLOS;
    static uint8_t E_B = 2*ciclosPlayerB - TOTAL_CICLOS;

    // reset após o período TOTAL_CICLOS
    if(contCiclos++ >= TOTAL_CICLOS){
        contCiclos = 0;
        E_A = 2*ciclosPlayerA - TOTAL_CICLOS;
        E_B = 2*ciclosPlayerB - TOTAL_CICLOS;
    }

    // ativa o TRIAC caso este ciclo seja selecionado. desativa caso contrário
    if(E_A){
        E_A += 2*(ciclosPlayerA - TOTAL_CICLOS);
        P1OUT |= LED_A;
    }else{
        E_A += 2*ciclosPlayerA;
        P1OUT &= ~LED_A;
    }

    if(E_B){
        E_B += 2*(ciclosPlayerB - TOTAL_CICLOS);
        P1OUT |= LED_B;
    }else{
        E_B += 2*ciclosPlayerB;
        P1OUT &= ~LED_B;
    }       
    
    // aguarda o OPTO saturar
    while((P1IN & OPTO));

    // limpa os pinos (* porém os TRIACs continuam ativados)
    P1OUT &= ~(LED_A | LED_B);

    // limpa flag interrupt P1
    P1IFG &= ~OPTO;
}