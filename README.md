# Compilación de bucles anidados

En este repositorio se alojan ejemplos sobre cómo compilar bucles anidados. En la práctica, los bucles anidados se utilizan comúnmente para procesar arreglos; sin embargo, la compilación de los arreglos requiere del manejo de la memoria, por lo que los problemas de esta índole se tratarán en este [repositorio](https://github.com/Ryuuba/risc-v-array.git).

## Descripción del código `nested_while.cc`

En el archivo `nested_while.cc` se encuentra un bucle anidado que acumula el valor de las variables `i` y `j` en la variable `accum`, de tal manera que la suma final resulta en 900 si las constantes `ROW_MAX` y `ROW_COL` valen 10 cada una. El código contenido en dicho archivo es el siguiente:

```C++
#define ROW_MAX 10
#define COL_MAX 10

int main()
{   
    int i = 0, accum = 0;
    while (i < ROW_MAX)
    {
        int j = 0;
        while (j < COL_MAX)
        {
            accum += i + j;
            j++;
        }
        i++;
    }
    return 0;
}
```

## Compilación de la inicialización de las variables `i` y `accum`

En principio, la expresión de alto nivel `int i = 0, accum = 0;` se compila empleando la instrucción `addi` para transferir la constante cero a los registros `s1` y `s3`, los cuales corresponden a las variables `i` y ` accum`, respectivamente.

| C++                     | RISC-V             |
| ----------------------- | ------------------ |
| `int i = 0, accum = 0;` | `addi s1, zero, 0` |
|                         | `addi s3, zero, 0` |

## Compilación del bucle externo

Al encontrar la palabra reservada *while*, en ensamblador se agrega un salto incondicional cuya instrucción objetivo (aquella a donde se saltará) es la primera del conjunto que corresponde a la compilación de la condición del bucle. Después, se compilan las sentencias que forman parte del bucle *while*, sean cuales sean y, finalmente, se compila la expresión de condición de bucle.

Para observar la estructura de instrucciones propia del bucle exterior, en este apartado *no* se explica la compilación del bloque de sentencias del bucle, sino la compilación de las instrucciones que producen los saltos.

La tabla de abajo muestra la compilación de la palabra reserva *while* a un salto incondicional. En este caso, la etiqueta `wh1` se usa porque se está compilando el primer bucle *while* del código en alto nivel.

| C++                  | RISC-V  |
| -------------------- | ------- |
| `while`              | `j wh1` |

La condición `i < ROW_MAX` se traduce en dos instrucciones: la primera carga la constante `ROW_MAX` en un registro temporal y la segunda compara si el valor de `i` es menor que `ROW_MAX`. Justamente, en la instrucción de carga debe colocarse la etiqueta `wh1` porque ésta es la primera instrucción en ensamblador que resulta de la compilación de la condición.

En la siguiente tabla se muestran las instrucciones que corresponden a la compilación de la condición `i < ROW_MAX`. En este ejemplo, el valor de `ROW_MAX` es igual a diez, pero éste puede cambiar según el programador de alto nivel lo defina. El objetivo del salto condicional `blt` debe ser la primera instrucción que resulta de la compilación del bloque de instrucciones del bucle. En dicha instrucción debe colocarse la etiqueta `L1`.

| C++                  | RISC-V                   |
| -------------------- | ------------------------ |
| `i < ROW_MAX`        | `wh1: addi t0, zero, 10` |
|                      | `blt s1, t0, L1`         |


La estructura de saltos del bucle externo se presenta en la siguiente tabla. Nótese que, en lugar del bloque de instrucciones del bucle externo, se escribe el comentario «*bloque de instrucciones*» para indicar la posición donde el bloque de instrucciones del bucle comienza.

| C++                           | RISC-V                          |
| ----------------------------- | ------------------------------- |
| `while(i < ROW_MAX)`          | `j wh1`                         |
| `\\ bloque de instrucciones ` | `L1: # bloque de instrucciones` |
|                               | `wh1: addi t0, zero, 10`        |
|                               | `blt s1, t0, L1`                |


## Inicialización del la variable `j`

En este ejemplo, la variable `j` está asociada lógicamente con el registro `s3`, entonces, la compilación de la expresión de inicialización `int j = 0;` resulta en RISC-V como `addi s3, zero, 0`.

## Compilación bucle interno

Al igual que ocurre con el bucle externo, el bucle interno se sigue la misma estrategia de compilación. 

En principio, la palabra reservada *while* se compila al salto incondicional `j wh2`. En este caso, se usa la etiqueta `wh2` para denotar que se va a compilar el segundo bucle *while*.

El bloque de instrucciones `{accum += i + j; j++;}` se traduce en tres instrucciones RISC-V, donde la primera almacena la suma `i + j` en un registro temporal, la segunda acumula la suma `i + j` en el registro que corresponde a la variable `accum`, la tercera incrementa en una unidad el valor del registro asociado con la variable `j`.

La tabla de abajo presenta la relación entre las expresiones C++ del bucle interno y sus  correspondientes instrucciones RISC-V.

| C++ | RISC-V |
| --- | ------ |
| `accum += i + j;` | `add t0, s1, s3` |
|                   | `add s2, s2, t0` |
| `j++;`            | `addi s3, s3, 1` |

La condición del bucle se traduce en las siguientes dos instrucciones RISC-V. De la misma forma que en el bucle externo, la etiqueta `wh2` se coloca en la primera instrucción resultante de la compilación de la condición. La etiqueta `L2` se utiliza para indicar el objetivo del salto condicional. Nótese que dicho objetivo corresponde a la primera instrucción del bloque del bucle interno, en este caso `add t0, s1, s3`.

| C++           | RISC-V                   |
| ------------- | ------------------------ |
| `j < COL_MAX` | `wh2: addi t0, zero, 10` |
|               | `blt s1, t0, L2`         |

El resultado de compilar el bucle interno se muestra en la siguiente tabla.

| C++                   | RISC-V                   |
| --------------------- | ------------------------ |
| `while (j < COL_MAX)` | `j wh2`                  |
| `{`                   | `L2: add t0, s1, s3`     |
| `accum += i + j;`     | `add s2, s2, t0`         |
| `j++;`                | `addi s3, s3, 1`         |
| `}`                   | `wh2: addi t0, zero, 10` |
|                       | `blt s1, t0, L2`         |

## Resultado de la compilación

En el archivo `nested_while.s` se encuentra el código de la compilación del archivo `nested_while.cc`.

```
        addi s1, zero, 0
        addi s2, zero, 0
        j    wh1                # external loop
L2:     addi s3, zero, 0
        j    wh2                # internal loop
L1:     add  t0, s1, s3
        add  s2, s2, t0
        addi s3, s3, 1
wh2:    addi t0, zero, 10       # loop condition (internal)
        blt  s3, t0, L1
        addi s1, s1, 1
wh1:    addi t0, zero, 10       # loop condition (external)
        blt  s1, t0, L2
        nop
```

