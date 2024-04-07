// File: a6.asm
// Chantal del Carmen
// Student #30129615

//-----------------------------------------------------------------------------------------

            .data
const_m:    .double 0r1.0e-10   

            .text
define(fp, x29)
define(fd_r, w19)
define(buf_base_r, x20)
define(n_read_r, x21)

define(top_r, d3)
define(bottom_r, d4)
define(term_r, d5)
define(accumulate_r, d6)
define(factorial_r, d7)
define(j_r, d8)
define(exp_r, d9)
define(i_r, d10)
define(x_r, d11)
define(const_r, d12)
define(temp_r, d13)

buf_size = 8
alloc   = -(16 + buf_size) & -16
dealloc = -alloc

buf_s = 16

path_name:  .string "input.bin"

//-----------------------------------------------------------------------------------------
// MAIN

            .balign 4
            .global main
main:       stp     x29, x30, [sp, alloc]!
            mov     fp, sp

            // Opening input file
open_file:  mov     w0, -100                    // 1st argument
            adrp    x1, path_name               // 2nd argument: path_name
            add     x1, x1, :lo12:path_name
            mov     w2, 0                       // 3rd argument: read only
            mov     w3, 0                       // 4th argument: not used
            mov     x8, 56                      // Openat I/O request

            svc     0                           // Supervisor call to system
            mov     fd_r, w0                    // fd (file descriptor) is in w0 and moved into fd reg

            // Error-handling if file opened properly
            cmp     fd_r, 0                     // Check if file opened successfully
            b.ge    test                        // If fd is 0 or more, open successful
                                                // Jump to test 

            // Reading input file
read_file:  mov     w0, fd_r                    // 1st arg: file descriptor
            add     buf_base_r, fp, buf_s       // 2nd arg: calculate buffer base address
            mov     x1, buf_base_r              // 2nd arg: a pointer to buffer
            mov     x2, 8                       // 3rd arg: number of bytes to read (must be <= buf_size)
            mov     x8, 63                      // Write I/O request

            svc     0                           // Call system function
                                                // x0 = number of bytes actually read (n_read)
            mov     n_read_r, x0                // mov x0 into n_read reg

            cmp     n_read_r, buf_size          // n_read must be <= buf_size
            b.gt    close_file                  // So if n_read > buf_size, jump to close_file
            

loop:       ldr     d0, [buf_base_r]            // d0 = x
            bl      calculate                   // Jump to calculate subroutine

            ldr     d0, [buf_base_r]            // d0 = x
            fneg    d0, d0                      // d0 = -x (negate x)
            bl      calculate                   // Jump to calculate subroutine

            // TODO

            // Loop test
test:       b       loop                        // Otherwise, n_read <= buf_s -> jump to top of loop


close_file: mov     w0, fd_r                    // 1st arg: fd
            mov     x8, 57                      // Close I/O request

            svc     0                           // Supervisor call
                                                // Status is returned in w0

end_main:   ldp     x29, x30, [sp], dealloc

//-----------------------------------------------------------------------------------------
// CALCULATE SUBROUTINE

calculate:  stp     x29, x30, [sp, -16]!
            mov     fp, sp

            adrp    x19, const_m                // constant = 1.0e-10
            add     x19, x19, :lo12:const_m     // First dereference the pointer "const_m" to obtain the 64-bit address (must be stored in x register)
            ldr     const_r, [x19]              // const_r = loaded from the address to obtain the constant           
            
            fmov    x_r, d0                     // x = d0 (passed in argument)
            fmov    i_r, 1.0                    // i = 1
            fmov    j_r, 1.0                    // j = 1
            fmov    accumulate_r, 1.0           // accumulate = 1
            fmov    exp_r, i_r                  // exp = 1
            fmov    factorial_r, i_r            // factorial = 1!

            fmov    top_r, x_r                  // top = x^1
            fmov    bottom_r, factorial_r       // bottom = 1!

            b       calc_test               

calc_loop:  fmul    top_r, top_r, x_r           // top = top * x
            fadd    j_r, j_r, 1.0               // j++
            fmul    bottom_r, factorial_r, j_r  // bottom = factorial * j
            fsub    i_r, i_r, 1.0               // i--            

calc_test:  cmp     i_r, 1.0
            b.gt    calc_loop

calc_after: fdiv    term_r, top_r, bottom_r     // term = top / bottom
            fmov    d0, temp_r            


end_calc:   ldp     x29, x30, [sp], 16


/*
            // Calculate top (exponent)
calc_loop:  fmul    top_r, top_r, top_r         // top = top * top
            
            // Calculate bottom (factorial)
            fmov    bottom_r, i_r               // bottom = i
            fmov    temp_r, i_r                 // temp = i
            fsub    temp_r, temp_r, one_r       // temp = i - 1
            fmul    bottom_r, bottom_r, temp_r  // bottom = i * (i - 1)
            fsub    i_r, i_r, one_r             // i--

calc_test:  cmp     i_r, one_r                  // If i is > 1, loop again
            b.gt    fact_top


            // Calculate 
after:      fdiv    term_r, top_r, bottom_r     // term = x^i / i!
            fadd    accumulate_r, accumulate_r, term_r
            fabs    accumulate_r, accumulate_r
one:        cmp     flag_r, 1.0
            b.eq    after2

two:        fneg     

after2:

            add     i_r, i_r, 1.0               // i++
 */









// Compute functions e^x and e^-x
// Use double precision floating-point numbers (d registers)
// Program reads a series of input values from a file whose name is specified at command line
//      Input values will be in binary format
//      Each number will be double precision (8 bytes long each)
// Read from the file using I/O
//      Generate an exception using the svc instruction
// Process the input one at a time using a loop
//      Detect end-of-file correctly
// Calculate e^x and e^-x
// Use printf to print out the input value and its corresponding output values in table form
//      In columns with headings to standard output
//      Values must be printed out with a precision of 10 decimal digits to the right of decimal point
// Functions e^x, e^-x
//      where x is a real number input to the functions
// Continue to accumulate terms in the series until |term| < 1.0e-10            

// Run program using input binary file
// Capture execution using script (script.txt)

// Skills:
//      Use of system I/O to open and read an input binary file
//      Understanding and use of floating-point single and double formats
//      Use of floating-point intructions to do simple calculations
//      Use of floating-point comparision instructions