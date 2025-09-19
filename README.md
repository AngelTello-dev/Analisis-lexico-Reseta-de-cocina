# Analisis-lexico-Reseta-de-cocina

Este es un programa hecho en C utilizando Flex para crear un analizador léxico capaz de interpretar un lenguaje de programación simple diseñado para escribir recetas de cocina.

## Requisitos
-   Flex
-   Un compilador de C (como GCC)
-   Make (opcional, para usar el Makefile)

## ¿Cómo se usa?
1.  **Compilar:**
    ```bash
    flex compilador.l
    cc lex.yy.c -o a.out -lfl
    ```
2.  **Ejecutar:**
    Pasa un archivo de receta como argumento para que el programa lo analice.
    ```bash
    ./a.out < mi_receta.txt
    ```
    O tambien escribe make en el compilador. 
