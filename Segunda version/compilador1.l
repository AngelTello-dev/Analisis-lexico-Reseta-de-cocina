%{
#include <stdio.h>
#include <string.h>

/* Contadores para las estadísticas del análisis léxico */
int num_acciones = 0;       // Cuenta las acciones culinarias (verbos)
int num_ingredientes = 0;   // Cuenta los identificadores de ingredientes (variables)
int num_recetas = 0;        // Cuenta los identificadores de recetas (constantes)
int num_cantidades = 0;     // Cuenta los números enteros
int num_medidas = 0;        // Cuenta los números con decimales
int num_cientificas = 0;    // Cuenta los números en notación científica
int num_instrucciones = 0;  // Cuenta las cadenas de texto (instrucciones)
int num_notas_chef = 0;     // Cuenta los comentarios de una línea
int num_notas_receta = 0;   // Cuenta los comentarios multilínea
int num_utensilios = 0;     // Cuenta los operadores y herramientas
int num_errores = 0;        // Cuenta los caracteres no reconocidos

%}


/* PALABRAS RESERVADAS COCINA: verbos que representan pasos en una receta */
ACCION              preparar|sazonar|mezclar|hornear|servir|deglasar|reposar|marinar|cortar|batir

/* TIPO DE DATO: palabras clave para declarar si algo es un ingrediente o una receta */
INGREDIENTE_TIPO    ingrediente|receta

/* IDENTIFICADORES: nombres para ingredientes y recetas */

/* Ingredientes: inician con minúscula */
VARIABLE            [a-záéíóú][a-z0-9áéíóú_]*
/* Recetas: inician con mayúscula (como constantes) */ 
CONSTANTE           [A-ZÁÉÍÓÚ][A-Z0-9ÁÉÍÓÚ_]*

/* NÚMEROS: diferentes formatos numéricos */

/* Enteros, ej: 10, -5 */
CANTIDAD            -?[0-9]+ 
/* Decimales, ej: 2.5, .50 */                   
MEDIDA              -?[0-9]*\.[0-9]+            
/* Notación científica, ej: 3e10, 1.5E-2 */
CIENTIFICA          -?[0-9]*\.?[0-9]+[Ee][10][-+]?[0-9]+

/* CADENAS Y COMENTARIOS */

/* Cadenas de texto entre comillas dobles */
INSTRUCCION         \"([^"\\]|\\.)*\"  
/* Comentarios de una línea que empiezan con # */         
NOTA_CHEF           "#".* 
/* Comentarios multilínea encerrados en <## ... ##> */
NOTA_RECETA         "<##"([^*]|\*[^/])*"##>"    

/* UTENSILIOS (OPERADORES Y SÍMBOLOS) */

/* Operadores aritméticos y lógicos */
UTENSILIO           [=+-\/*<>!&|] 
/* Símbolos de agrupación y puntuación */              
HERRAMIENTA         [(){},;]                    

%%


{ACCION}            { num_acciones++; printf("ACCION_CULINARIA -> %s\n", yytext); } /* Cuando se encuentra una ACCION, incrementa el contador y la imprime */

{INGREDIENTE_TIPO}  { num_acciones++; printf("TIPO_INGREDIENTE -> %s\n", yytext); } /* Cuando se encuentra un TIPO de ingrediente, incrementa contador y lo imprime */

{VARIABLE}          { num_ingredientes++; printf("INGREDIENTE -> %s\n", yytext); } /* Para un nombre de ingrediente (VARIABLE), incrementa su contador y lo imprime */

{CONSTANTE}         { num_recetas++; printf("RECETA -> %s\n", yytext); } /* Para un nombre de receta (CONSTANTE), incrementa su contador y lo imprime */

{CANTIDAD}          { num_cantidades++; printf("CANTIDAD -> %s\n", yytext); } /* Para un número entero (CANTIDAD), incrementa su contador y lo imprime */

{MEDIDA}            { num_medidas++; printf("MEDIDA -> %s\n", yytext); } /* Para un número decimal (MEDIDA), incrementa su contador y lo imprime */

{CIENTIFICA}        { num_cientificas++; printf("MEDIDA_CIENTIFICA -> %s\n", yytext); } /* Para un número científico (CIENTIFICA), incrementa su contador y lo imprime */

{INSTRUCCION}       { num_instrucciones++; printf("INSTRUCCION -> %s\n", yytext); } /* Para una instrucción (INSTRUCCION), incrementa su contador y la imprime */

{NOTA_CHEF}         { num_notas_chef++; printf("NOTA_CHEF -> %s\n", yytext); } /* Para una nota de chef (NOTA_CHEF), incrementa su contador y la imprime */

{NOTA_RECETA}       { num_notas_receta++; printf("NOTA_RECETA -> %s\n", yytext); } /* Para una nota de receta (NOTA_RECETA), incrementa su contador y la imprime */

{UTENSILIO}         { num_utensilios++; printf("UTENSILIO -> %s\n", yytext); } /* Para un utensilio (UTENSILIO), incrementa su contador y lo imprime */

{HERRAMIENTA}       { num_utensilios++; printf("HERRAMIENTA -> %s\n", yytext); } /* Para una herramienta (HERRAMIENTA), incrementa su contador y la imprime */

[ \t\n]             { /* No hace nada, efectivamente los ignora */ } /* Regla para ignorar espacios en blanco, tabuladores y saltos de línea */

.                   { num_errores++; printf("ERROR -> '%s'\n", yytext); } /* Regla "atrapa-todo": cualquier otro carácter que no coincida con las reglas anteriores */

%%

// Función principal del programa
int main(int argc, char **argv) {
    // Si se proporciona un archivo como argumento, se lee de él.
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    } else {
        // Si no, se prepara para leer de la entrada estándar (aunque aquí solo imprime un mensaje).
        printf("Analizando receta.\n\n");
    }
    
    // Llama a la función yylex() para iniciar el análisis léxico.
    yylex();
    
    // Al finalizar, imprime las estadísticas recolectadas.
    printf("\n=== ESTADISTICAS COMPILADOR ===\n");
    printf("Acciones culinarias: %d\n", num_acciones);
    printf("Ingredientes: %d\n", num_ingredientes);
    printf("Recetas: %d\n", num_recetas);
    printf("Cantidades: %d\n", num_cantidades);
    printf("Medidas: %d\n", num_medidas);
    printf("Medidas cientificas: %d\n", num_cientificas);
    printf("Instrucciones: %d\n", num_instrucciones);
    printf("Notas chef: %d\n", num_notas_chef);
    printf("Notas receta: %d\n", num_notas_receta);
    printf("Utensilios: %d\n", num_utensilios);
    printf("Errores: %d\n", num_errores);
    printf("\n¡Receta compilada!\n");
    
    return 0;
}
int yywrap() {
    return 1;
}
