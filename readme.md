# Custom MIPS Processor with Stack Overflow Protection

This project implements a modified single-cycle MIPS-lite processor in Verilog. It features a custom Instruction Set Architecture (ISA) and a hardware-based Stack Guard mechanism to prevent Overflow and Underflow errors.

## Project Overview
* **Course:** CENG311 - Computer Architecture (Fall 2025)
* **Architecture:** 32-bit Single Cycle MIPS-lite
* **Language:** Verilog HDL
* **Simulation:** ModelSim

## Key Features
1.  **Custom ISA:** Implements standard MIPS instructions plus custom opcodes derived from Student ID.
2.  **Stack Protection:** A dedicated hardware module monitors the Stack Pointer ($sp).
    * **Overflow Detection:** Prevents stack from growing beyond the allocated limit.
    * **Underflow Detection:** Prevents popping from an empty stack.
    * **Interlock:** Automatically disables `MemWrite` and `RegWrite` signals upon error detection.

## Register Roles (Custom)
* `$spba` (R12): Stack Pointer Base Address (Initialized to 40)
* `$spl` (R13): Stack Pointer Limit (Initialized to 2 words)
* `$sp` (R14): Current Stack Pointer

## ISA Table (Based on ID: ...102)
| Instruction | Opcode | Type | Description |
| :--- | :--- | :--- | :--- |
| `sll` | 102 | R | Shift Left Logical |
| `subi` | 107 | I | Subtract Immediate |
| `beqi`| 109 | B-I| Branch Equal Immediate |
| ... | ... | ... | ... |