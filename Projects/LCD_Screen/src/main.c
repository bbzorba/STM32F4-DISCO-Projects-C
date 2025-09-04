#include "lcd.h"
#include "stm32f4xx_hal.h"
#include "stm32f4xx_hal_gpio.h"
#ifndef __HAL_RCC_GPIOA_CLK_ENABLE
#define __HAL_RCC_GPIOA_CLK_ENABLE() (RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN)
#endif
#include "stm32f4xx_hal_conf.h"
#include <stdint.h>

int main(void)
{
    HAL_Init();
    __HAL_RCC_GPIOA_CLK_ENABLE();

    pinStruct_t rs = {GPIOA, GPIO_PIN_0};
    pinStruct_t en = {GPIOA, GPIO_PIN_1};
    pinStruct_t d4 = {GPIOA, GPIO_PIN_4};
    pinStruct_t d5 = {GPIOA, GPIO_PIN_5};
    pinStruct_t d6 = {GPIOA, GPIO_PIN_6};
    pinStruct_t d7 = {GPIOA, GPIO_PIN_7};

    LCD_HandleTypeDef lcd;
    LCD_Init(&lcd, rs, en, d4, d5, d6, d7);

    while (1)
    {
        LCD_PrintString(&lcd, "Hello world!");
        HAL_Delay(1000);
        LCD_Clear(&lcd);
        HAL_Delay(1000);
        LCD_PrintString(&lcd, "Random Stuff:");
        LCD_SetCursor(&lcd, 1, 0);
        LCD_PrintString(&lcd, "!'^+%&/()=?_;");
        HAL_Delay(1000);
        LCD_Clear(&lcd);
    }
}