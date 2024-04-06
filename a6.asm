// File: a6.asm
// Chantal del Carmen
// Student #30129615

            .data



            .text
define(fd, w19)

buf_size = 8
alloc   = -(16 + buf_size) & -16
dealloc = -alloc

buf_s = 16

path_name:  .string "input.bin"

            .balign 4
            .global main
main:       stp     x29, x30, [sp, alloc]!
            mov     x29, sp

            // Opening input file
            mov     w0, -100                    // 1st argument
            adrp    x1, path_name               // 2nd argument: path_name
            add     x1, x1, :lo12:path_name
            mov     w2, 0                       // 3rd argument: read only
            mov     w3, 0                       // 4th argument: not used
            mov     x8, 56                      // Openat I/O request

            svc     0                           // Supervisor call to system
            mov     fd, w0                      // fd (file descriptor) is in w0 and moved into fd reg

            // Error-handling
            cmp     fd, 0                       // Check if file opened successfully
            b.ge    open_ok                     // If fd is 0 or more, open successful
                                                // Jump to open_ok 

            // File has opened successfully
open_ok:    
            mov     w0, fd
            add     x1, x29, buf_s              // 2nd arg

            mov     x2, 8                       // 3rd arg: number of bytes to write (must be <= buf_size)
            mov     x8, 64                      // Write I/O request

            svc     0                           // Call system function

            ldp     x29, x30, [sp], dealloc



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