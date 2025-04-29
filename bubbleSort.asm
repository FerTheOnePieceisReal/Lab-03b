# BUBBLE SORT
.data
Primero: .asciiz "Ingrese el primer numero del array:"
Segundo: .asciiz "Ingrese el segundo numero del array:"
Tercero: .asciiz "Ingrese el tercer numero del array:"
Cuarto: .asciiz "Ingrese el cuarto numero del array:"
coma: .asciiz ", "
endl: .asciiz "\n"
Ordenado: .asciiz "El arreglo ordenado es: "
array: .word 0:4  # Arreglo de 4 enteros inicializados a 0
n: .word 4        # Número de elementos

.text
.globl main
main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Entrada de datos
    li $v0, 4
    la $a0, Primero
    syscall
    li $v0, 5
    syscall
    sw $v0, array
    li $v0, 4
    la $a0, endl
    syscall

    li $v0, 4
    la $a0, Segundo
    syscall
    li $v0, 5
    syscall
    sw $v0, array+4
    li $v0, 4
    la $a0, endl
    syscall

    li $v0, 4
    la $a0, Tercero
    syscall
    li $v0, 5
    syscall
    sw $v0, array+8
    li $v0, 4
    la $a0, endl
    syscall

    li $v0, 4
    la $a0, Cuarto
    syscall
    li $v0, 5
    syscall
    sw $v0, array+12
    li $v0, 4
    la $a0, endl
    syscall

    # Llamar a bubble_sort
    jal bubble_sort

    # Imprimir el arreglo ordenado
    li $v0, 4
    la $a0, Ordenado
    syscall

    la $t0, array
    li $t1, 0

print_loop:
    beq $t1, 4, exit

    lw $a0, 0($t0)
    li $v0, 1
    syscall

    addi $t1, $t1, 1
    beq $t1, 4, skip_comma

    li $v0, 4
    la $a0, coma
    syscall

skip_comma:
    addi $t0, $t0, 4
    j print_loop

exit:
    # Restaurar registros
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    li $v0, 10
    syscall

# BUBBLE SORT FUNCTION
bubble_sort:
    # Guardar registros
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s1, 4($sp)
    sw   $s0, 0($sp)

    la   $s0, array      # Base del arreglo
    li   $s1, 4          # Tamaño del arreglo

external_loop:
    addi $t7, $zero, 0   # flag = 0 (no intercambio)

    li $t0, 0            # i = 0

loop_for:
    addi $t2, $s1, -1    # t2 = n-1
    bge $t0, $t2, exit_for

    sll $t3, $t0, 2      # offset = i*4
    add $t4, $s0, $t3    # dirección de array[i]
    lw  $t5, 0($t4)      # cargar array[i]

    addi $t3, $t3, 4     # offset = (i+1)*4
    add $t6, $s0, $t3    # dirección de array[i+1]
    lw  $t8, 0($t6)      # cargar array[i+1]

    ble $t5, $t8, no_swap

    # Hacer swap
    move $t9, $t5
    move $t5, $t8
    move $t8, $t9

    sw $t5, 0($t4)
    sw $t8, 0($t6)

    addi $t7, $zero, 1   # hubo intercambio

no_swap:
    addi $t0, $t0, 1
    j loop_for

exit_for:
    bnez $t7, external_loop

    # Restaurar registros
    lw $ra, 8($sp)
    lw $s1, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 12

    jr $ra
