# MIPS Assembly Programming Fundamentals (MARS)

This repository contains several programs written in **MIPS assembly**, developed and tested using the **MARS MIPS simulator**.  
The programs focus on core low-level programming concepts such as arithmetic operations, branching, loops, procedures, stack usage, and bit-level manipulation.

---

## 📁 Program 1 — Integer Power & Hamming Weight
**File:** `arch_hw2_112006234.asm`

### 🧩 Functionality
This program:

- Prompts the user to input an integer **base**
- Prompts the user to input an integer **exponent**

### ⚠️ Special / Error Handling
- `0^0` → prints a message and exits  
- Negative exponent → prints an error message

### ⚙️ Processing
- Computes **base^exponent using fast binary exponentiation**
- Prints the result
- Computes the **Hamming Weight** (number of `1` bits in the binary result)
- Prints the Hamming Weight
- Repeats for the next input pair

### 📚 Concepts Reinforced
- ✔ Register usage  
- ✔ Arithmetic & multiplication  
- ✔ Branching & loops  
- ✔ Bit masking & shifting  
- ✔ Syscall-based I/O  

### ▶️ Running in MARS
1. Open **MARS**
2. Load `arch_hw2_112006234.asm`
3. Assemble the program
4. Run it
5. Enter integer inputs when prompted

---

## 🧠 Program 2 — Fibonacci via Matrix Exponentiation + Bit Count
**File:** `arch_hw3_112006234.asm`

### 🧩 Functionality
This program continuously prompts the user to enter an integer `n`.

### 📥 Input Rules
- Enter **`-1` to exit**
- Negative values (other than `-1`) are rejected with an error message
- For valid `n ≥ 0`, the program computes **Fibonacci(n)** using  
  **fast matrix exponentiation with recursion** on the matrix:
- Counts the number of **1-bits in the lower 32 bits** of the result
- Prints that bit-count

### 📚 Concepts Reinforced
- ✔ Recursion in assembly  
- ✔ Stack usage & register conventions  
- ✔ Matrix multiplication logic  
- ✔ Bit-level counting  
- ✔ Syscall-based I/O  

### ▶️ Running in MARS
1. Open **MARS**
2. Load `arch_hw3_112006234.asm`
3. Assemble the program
4. Run it
5. Enter values for `n` repeatedly
6. Enter **`-1` to terminate**

---

## 🛠 Tools Used
- **MARS MIPS Simulator** — writing & testing assembly programs  
- **Any text editor / IDE** — editing source code  

---

