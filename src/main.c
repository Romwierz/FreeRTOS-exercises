#include "stm32l4xx.h"
#include "stdint.h"

void SystemInit(void)
{
    
}

void SystemClock_Config(void);
void GPIO_Init(void);
void GPIO_WritePin(uint8_t PinState);
void GPIO_TogglePin(void);

int main(void)
{
    // SystemClock_Config();
    GPIO_Init();
    GPIO_WritePin(1);

    int ticks = 1000000;

    while (1)
    {
        while (ticks--)
        {
            asm("nop");
        }
        
        GPIO_TogglePin();
        ticks = 1000000;
    }
}

void SystemClock_Config(void)
{
}

void GPIO_Init(void)
{
    RCC->AHB2ENR |= (1<<0);                 // Enable the GPIOA clock
    GPIOA->MODER |= (1<<10);                // pin PA5(bits 11:10) as Output (01)
    GPIOA->MODER &= ~(1<<11);               // pin PA5(bits 11:10) as Output (01)
    GPIOA->OTYPER &= ~(1<<5);               // bit 5=0 --> Output push pull
    GPIOA->OSPEEDR |= (1<<11);              // Pin PA5 (bits 11:10) as Fast Speed (1:0)
    GPIOA->PUPDR &= ~((1<<10) | (1<<11));   // Pin PA5 (bits 11:10) are 0:0 --> no pull up or pulldown
    
}

void GPIO_WritePin(uint8_t PinState)
{
    if (PinState == 0U)
    {
        GPIOA->ODR &= ~GPIO_ODR_OD5;
    }
    else if (PinState == 1U)
    {
        GPIOA->ODR = GPIO_ODR_OD5;
    }
}

void GPIO_TogglePin(void)
{
    uint32_t odr = READ_REG(GPIOA->ODR);

    if ((odr & GPIO_ODR_OD5) != 0U)
    {
        GPIOA->ODR &= ~(1<<5);
    }
    else if ((odr & GPIO_ODR_OD5) == 0U)
    {
        GPIOA->ODR = 1<<5;
    }
}
