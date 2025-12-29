# MIPS Assembly Programming Fundamentals (MARS)

This repository contains several programs written in **MIPS assembly**, developed and tested using the **MARS MIPS simulator**.  
The programs focus on core low-level programming concepts such as arithmetic operations, branching, loops, procedures, stack usage, and bit-level manipulation.

**Author:** Justin Thiadi — 112006234

---

## 📁 Project Structure

```text
.
├── Program1/
│   └── arch_hw2_112006234.asm
├── Program2/
│   └── arch_hw3_112006234.asm
└── README.md
(Directory names are only for organization — rename them however you like.)

🧠 Program 1 — Integer Power & Hamming Weight
File: arch_hw2_112006234.asm

Functionality
This program:

Prompts the user to input an integer base

Prompts the user to input an integer exponent

Handles special/error cases:

0^0 → prints a message and exits

Negative exponent → prints an error message

Computes base^exponent using fast binary exponentiation

Prints the result

Computes the Hamming Weight (number of 1-bits in the binary result)

Prints the Hamming Weight

Repeats for the next input pair

Concepts Reinforced
✔ Register usage
✔ Arithmetic & multiplication
✔ Branching & loops
✔ Bit masking & shifting
✔ Syscall-based I/O

▶️ Running in MARS
Open MARS

Load arch_hw2_112006234.asm

Assemble the program

Run it

Enter integer inputs when prompted

🧠 Program 2 — Fibonacci via Matrix Exponentiation + Bit Count
File: arch_hw3_112006234.asm

Functionality
This program:

Continuously prompts the user to enter an integer n

Input Rules
Enter -1 to exit

Negative values (other than -1) are rejected with an error message

For valid n ≥ 0, it computes Fibonacci(n) using
fast matrix exponentiation & recursion on the matrix:

Copy code
|1 1|
|1 0|
It then:

Prints the result in the format:

Copy code
fib[n] = value
Counts the number of 1-bits in the lower 32 bits of the result

Prints that count

Concepts Reinforced
✔ Recursion in assembly
✔ Stack usage & register conventions
✔ Matrix multiplication logic
✔ Bit-level counting
✔ Syscall-based I/O

▶️ Running in MARS
Open MARS

Load arch_hw3_112006234.asm

Assemble the program

Run it

Enter values for n repeatedly

Enter -1 to terminate

🛠 Tools Used
MARS MIPS Simulator — writing & testing assembly programs

Any text editor / IDE — editing source code
