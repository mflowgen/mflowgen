#=========================================================================
# proj-incr-asm.S
#=========================================================================
# This is the function declaration:
#
#  void incr_asm( int* array, int size );
#
# Given the standard RISCV calling convention, two arguments will be
# passed in the a0, a1, a2, a3 registers.

# Define names for argument registers

#define array_ptr a0
#define size      a1

#-------------------------------------------------------------------------
# Function definition
#-------------------------------------------------------------------------

    # Function prologue

    .text

    # Ensure that instructions are word aligned

    .balign 4

    # Entry point so that linker knows where to jump to when you call
    # this function

    .globl  incr_asm
    .type   incr_asm,@function
incr_asm:

    # Function body

loop:

    lw      t0, 0(array_ptr)
    addi    t0, t0, 1
    sw      t0, 0(array_ptr)

    # Update base pointer

    add     array_ptr, array_ptr, 4

    # Decrement loop counter and branch back to start of loop

    addi    size, size, -1
    bne     size, zero, loop

done:

    # Return from function

    jr      ra

    # Function epilogue

    .end    incr_asm

