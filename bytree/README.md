###bytree

**Bytree** é um jogo multiplayer de captura baseado em colisões.  

O programa é escrito em [Processing](http://processing.org/), e a interface visual (LEDs conectados à rede elétrica AC) é controlada por um microcontrolador MSP430{G2553}.

Diretórios:
- [msp430-fw](https://github.com/ocupacaoDigital/okupa2015/tree/master/bytree/msp430-fw)
	- firmware do uControlador MSP430G2553
    - dimmer com implementação do algorítmo de Bresenham
- [p5-sketch](https://github.com/ocupacaoDigital/okupa2015/tree/master/bytree/p5-sketch)
	- arquivos P5
    - interface serial com o msp430
- [schematic](https://github.com/ocupacaoDigital/okupa2015/tree/master/bytree/schematic)
	- esquemático do projeto
- [tests](https://github.com/ocupacaoDigital/okupa2015/tree/master/bytree/tests)
	- testes gerais
    	- comunicação serial
        - Bresenham