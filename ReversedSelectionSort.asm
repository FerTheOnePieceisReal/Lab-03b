#REVERSED SELECTION SORT :D
.data
Primero: .asciiz "Ingrese el primer numero del array:"
Segundo: .asciiz "Ingrese el segundo numero del array:"
Tercero: .asciiz "Ingrese el tercer numero del array:"
Cuarto: .asciiz "Ingrese el cuarto numero del array:"
coma: .asciiz ", "
endl: .asciiz "\n"
Ordenado: .asciiz "El arreglo ordenado es: "
array:   .word 0:4  # Arreglo de 4 enteros inicializados a 0 (Hay que reservar memoria)
.text
.globl main

main:
#Guardar registros usados
addi $sp,$sp,-4
sw $ra,0($sp)
#Input/Output de los valores para el array
#Primero
li $v0,4
la $a0,Primero
syscall
li $v0,5
syscall
sw $v0, array
li $v0,4
la $a0,endl
syscall
#Segundo
li $v0,4
la $a0,Segundo
syscall
li $v0,5
syscall
sw $v0, array+4
li $v0,4
la $a0,endl
syscall
#Tercero
li $v0,4
la $a0,Tercero
syscall
li $v0,5
syscall
sw $v0, array+8
li $v0,4
la $a0,endl
syscall
#Cuarto
li $v0,4
la $a0,Cuarto
syscall
li $v0,5
syscall
sw $v0, array+12
li $v0,4
la $a0,endl
syscall
jal selection_sort
 # Imprimir el arreglo ordenado
li $v0, 4
la $a0, Ordenado
syscall
# Mostrar cada elemento del arreglo ordenado
la $t0, array         # Dirección base del arreglo
li $t1, 0             # Contador de elementos

print_loop:
beq $t1, 4, exit      # Si imprimimos 4 elementos, salir
    # Cargar el valor actual
    lw $a0, 0($t0)
    li $v0, 1             # Imprimir entero
    syscall
    # Imprimir coma excepto para el último elemento
    addi $t1, $t1, 1
    beq $t1, 4, skip_comma
    li $v0, 4
    la $a0, coma
    syscall

skip_comma:
    addi $t0, $t0, 4      # Avanzar al siguiente elemento
    j print_loop

exit:
    # Restaurar registros
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    
    # Terminar programa
    li $v0, 10
    syscall

selection_sort:
    # Guardar registros que usamos
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s1, 4($sp)
    sw   $s0, 0($sp)
    
    # Inicializar variables
    li $s0, 3           
    
outer_loop:
    # Si ya ordenamos todo, salir
    bltz $s0, sort_done  
    
    # Preparamos para encontrar máximo en sub-arreglo[0..$s0]
    la $s1, array        # $s1 = dirección base del arreglo
    lw $t0, 0($s1)       # $t0 = initialize maximum to A[0]
    li $t1, 0   
    li $t5, 0
    
    # Ahora usamos el código para buscar el máximo
find_max:
    add $t1, $t1, 1     
    bgt $t1, $s0, max_found 
    sll $t2, $t1, 2    
    add $t2, $t2, $s1    # compute 4i in $t2
    lw $t3, 0($t2)       # load value of A[i] into $t3
    slt $t4, $t3, $t0    # maximum < A[i]?
    beq $t4, $zero, find_max # if not, repeat with no change
    move $t0, $t3        # if so, A[i] is the new maximum
    move $t5, $t1        # guarda el índice del máximo
    j find_max           # change completed; now repeat
    
max_found:
    # Ya tenemos el máximo en $t0 y su índice en $t5
    # Intercambiamos con la posición $s0 (fin del subarreglo)
    
    # Calcular dirección del elemento en posición $s0
    sll $t6, $s0, 2      # $t6 = $s0 * 4
    add $t6, $t6, $s1    # $t6 = dirección de array[$s0]
    lw $t7, 0($t6)       # $t7 = valor en array[$s0]
    
    # Calcular dirección del máximo
    sll $t8, $t5, 2      # $t8 = índice_max * 4
    add $t8, $t8, $s1    # $t8 = dirección de array[índice_max]
    
    # Intercambiar valores si son diferentes posiciones
    beq $t5, $s0, no_swap # si el máximo ya está en posición, no intercambiar
    sw $t7, 0($t8)       # array[índice_max] = array[$s0]
    sw $t0, 0($t6)       # array[$s0] = máximo
    
no_swap:
    # Decrementar $s0 para trabajar con el siguiente subarreglo
    addi $s0, $s0, -1
    j outer_loop
    
sort_done:
    # Restaurar registros
    lw   $s0, 0($sp)
    lw   $s1, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    
    jr   $ra
