#include "unity_fixture.h"
#include "stm32l4xx.h"

extern void runAllTests(void);

void USART3_Init(void)
{
    // Enable USART2 clock
    RCC->APB1ENR1 |= RCC_APB1ENR1_USART2EN;

    // Configure GPIO for USART2 (TX: PA2, RX: PA3)
    // Enable GPIOA clock
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;

    // DO ZNALEZIENIA W REFERENCE MANUALU
    // ZAWSZE OPISY REJESTRÓW ZNAJDUJĄ SIĘ W RM, JAK RÓWNIEŻ INFO 
    // POTRZEBNE DO URUCHOMIENIA DANEGO PERYFERIUM
    // Set alternate function AF7 to PA2 and PA3 pin
    // Pins GPIOA0-7 are in AFRL register - in GPIO definition it is AFR[0]
    // AF7 is coded as 0b0111 so we need to set bits from 0 to 2
    // PA2 pin is at AFRL2 position
    GPIOA->AFR[0] &= ~GPIO_AFRL_AFSEL2_Msk;
    GPIOA->AFR[0] |= GPIO_AFRL_AFSEL2_0 | GPIO_AFRL_AFSEL2_1 | GPIO_AFRL_AFSEL2_2;
    // PA3 pin is at AFRL3 position
    GPIOA->AFR[0] &= ~GPIO_AFRL_AFSEL3_Msk;
    GPIOA->AFR[0] |= GPIO_AFRL_AFSEL3_0 | GPIO_AFRL_AFSEL3_1 | GPIO_AFRL_AFSEL3_2;

    // set GPIO mode as AF (Alternate funciton)
    // AF mode is coded as 0b10 so we need to set bit 1 for each GPIO that we are using
    // PA2 pin confiugration
    GPIOA->MODER &= ~GPIO_MODER_MODE2_Msk;
    GPIOA->MODER |= GPIO_MODER_MODE2_1;
    GPIOA->MODER &= ~GPIO_MODER_MODE3_Msk;
    GPIOA->MODER |= GPIO_MODER_MODE3_1;
    
    // Configure USART2 to 115200bps
    // Clear all bits of control register - disable USART
    USART2->CR1 = 0;

    // We didn't configured system clocks. Default core and peripheral clock (fclk) is 16MHz.
    // Default oversampling is 16 (bit OVER8 in CR1 reset)
    //
    // We can now calculate USARTDIV:
    // for oversampling by 16:
    // baudrate = fck / USARTDIV
    //
    // After rearranging the equation
    // USARTDIV = fck / baudrate
    //
    // USARTDIV = 16000000 / 115200
    // USARTDIV = 139
    //
    // When oversampling is set to 16 (OVER8 = 0) then BRR = USARTDIV
    USART2->BRR = 35;

    // Enable receiver and transmitter
    USART2->CR1 |= USART_CR1_RE | USART_CR1_TE;
    // Enable USART3
    USART2->CR1 |= USART_CR1_UE;
}

void uart_putchar(const char c)
{
    // Wait in loop to flush previously sent data
    while (!(USART2->ISR & USART_ISR_TXE)) {}

    // Send character - put it in Transmit Data Register
    // trzeba rzutować na wartość bez znaku
    USART2->TDR = (uint8_t)c;
}

void SystemInit(void)
{
    USART3_Init();
}

int main(void)
{
    UnityMain(0, NULL, runAllTests);
}