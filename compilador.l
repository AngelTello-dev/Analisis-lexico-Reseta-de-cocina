%{
#include <stdio.h>
#include <string.h>

/* Contadores para las estadísticas finales */
int num_acciones = 0, num_ingredientes = 0, num_recetas = 0, num_cantidades = 0;
int num_unidades = 0, num_instrucciones = 0, num_notas = 0, num_simbolos = 0, num_errores = 0;
%}

/* DEFINICIONES DE TOKENS COCINA */
ACCION_CULINARIA  preparar|sazonar|mezclar|hornear|servir|deglasar|reposar|marinar|cortar|batir|freir|hervir|picar|refrigerar
TIPO_DECLARACION  ingrediente|receta
NOMBRE_INGREDIENTE [a-záéíóú][a-z0-9áéíóú_]*
TITULO_RECETA      [A-ZÁÉÍÓÚ][A-Z0-9ÁÉÍÓÚ_]*
CANTIDAD           -?[0-9]+(\.[0-9]+)?
UNIDAD_MEDIDA      tazas|gramos|cucharadas|ml|piezas
INSTRUCCION_PASO   \"([^"\\]|\\.)*\"
NOTA_CHEF          "#".*
NOTA_EXTENDIDA     "<##"([^*]|\*[^/])*"##>"
OPERADOR           [=+-\/*]
SIMBOLO_ESTRUCTURA [(){},;]

%%

{ACCION_CULINARIA}  { num_acciones++; printf("-> Acción: [%s]\n", yytext); }
{TIPO_DECLARACION}  { num_recetas++; printf("-> Declaración: [%s]\n", yytext); }
{UNIDAD_MEDIDA}     { num_unidades++; printf("-> Unidad: [%s]\n", yytext); }
{NOMBRE_INGREDIENTE} { num_ingredientes++; printf("-> Ingrediente: [%s]\n", yytext); }
{TITULO_RECETA}     { num_recetas++; printf("-> Título de Receta: [%s]\n", yytext); }
{CANTIDAD}          { num_cantidades++; printf("-> Cantidad: [%s]\n", yytext); }
{INSTRUCCION_PASO}  { num_instrucciones++; printf("-> Instrucción: %s\n", yytext); }
{NOTA_CHEF}         { num_notas++; printf("-> Nota del Chef: %s\n", yytext); }
{NOTA_EXTENDIDA}    { num_notas++; printf("-> Nota de Receta: %s\n", yytext); }
{OPERADOR}          { num_simbolos++; printf("-> Operador de ajuste: [%s]\n", yytext); }
{SIMBOLO_ESTRUCTURA} { num_simbolos++; printf("-> Símbolo de estructura: [%s]\n", yytext); }

[ \t\n]+            { /* Ignorar espacios en blanco */ }
.                   { num_errores++; printf("!! ERROR: Utensilio no reconocido en la cocina -> '%s'\n", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    } else {
        printf("--- Analizando receta ---\n\n");
    }

    yylex();

    printf("\n======== RESUMEN DE LA RECETA ========\n");
    printf("Acciones culinarias encontradas: %d\n", num_acciones);
    printf("Ingredientes y recetas declarados: %d\n", num_recetas);
    printf("Nombres de ingredientes: %d\n", num_ingredientes);
    printf("Cantidades especificadas: %d\n", num_cantidades);
    printf("Unidades de medida: %d\n", num_unidades);
    printf("Instrucciones detalladas: %d\n", num_instrucciones);
    printf("Notas y comentarios: %d\n", num_notas);
    printf("Símbolos y utensilios: %d\n", num_simbolos);
    printf("Errores de sintaxis: %d\n", num_errores);
    printf("\n¡Análisis completado!\n");

    return 0;
}

int yywrap() {
    return 1;
}
