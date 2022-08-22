# Compilación de bucles anidados

En este repositorio se alojan ejemplos sobre cómo compilar bucles anidados. En la práctica, los bucles anidados se utilizan comúnmente para procesar arreglos; sin embargo, la compilación de los arreglos requiere del manejo de la memoria, por lo que los problemas de esta índole se tratarán en este [repositorio](https://github.com/Ryuuba/risc-v-array.git).

## Compilación de bucle *while* anidado

En el archivo `nested_while.cc` se encuentra un bucle anidado que acumula el valor de las variables `i` y `j` en la variable `accum`, de tal manera que la suma final resulta en 900 si las constantes `ROW_MAX` y `ROW_COL` valen 10 cada una.

Para compilar un bucle *while* anidado se requiere aplicar individualmente la estrategia de traducción del bucle sencillo.
