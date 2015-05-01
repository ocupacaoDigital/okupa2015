/*

    Compilar e gravar:
        $ msp430-gcc -mmcu=msp430g2553 -o mspSerialTest.elf mspSerialTest.c
        $ mspdebug rf2500
        (mspdebug) prog mspSerialTest.elf
        (mspdebug) Ctrl+D

*/


#include <msp430.h>
#include <stdlib.h> // atoi

#define RX_pin BIT1 // P1.1
#define TX_pin BIT2 // P1.2
#define LED_A  BIT0 
#define LED_B  BIT6 

void Serial_config(void);
void Serial_receive(void);
void String_cat(char *str, char dado);
void P1_interrupcao(void);

char serial_str[5] = {'\0'}; // 5: NNN\n\0

void pisca(int count){
    if(!count) return;

    P1OUT |= LED_A;

    while(count--){
        P1OUT ^= (LED_A|LED_B);
        __delay_cycles(400000); // 50m s
    }

    P1OUT &= ~(LED_A|LED_B);
}

void main(void){
    
    // desabilita wdt
    WDTCTL = WDTPW + WDTHOLD;

    // configura clock 8MHz
    BCSCTL1 = CALBC1_8MHZ;
    DCOCTL = CALDCO_8MHZ;

    // configura saídas
    P1DIR = (LED_A | LED_B);
    // apaga os LEDs
    P1OUT &= ~(LED_A|LED_B);

    Serial_config();

    // habilita GIE
    __enable_interrupt();

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
    char dado = UCA0RXBUF;
    String_cat(serial_str, UCA0RXBUF);

    if(dado == '\n'){
        pisca(atoi(serial_str));
        // limpa a string
        serial_str[0] = '\0';
    }

    // limpa flag interrupt serial
    IFG2 &= ~UCA0RXIFG;
}

void String_cat(char *str, char dado){
    while(*str) str++;
    *str = dado;
    *(str+1) = '\0';
}