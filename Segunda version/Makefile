# Variable para el nombre del archivo Flex
A_FLEX = compilador1.l
SALIDA = a.out
FUENTE = fuente1.txt

# Regla principal para compilar y ejecutar
all: clean compile run

# Limpiar archivos generados
clean:
	rm -f lex.yy.c $(SALIDA)

# Regla para compilar el archivo de Flex
compile:
	flex $(A_FLEX)
	cc lex.yy.c -o $(SALIDA) -lfl  # Usar -o para nombrar el ejecutable

# Regla para ejecutar el programa con el archivo fuente como entrada
run: compile  # Asegurarse de que esté compilado antes de ejecutar
	./$(SALIDA) < $(FUENTE)



	


