# RTL Design and Verification of a 32-bit 5-Stage Pipelined Processing Unit

This repository implements a **32-bit Five-Stage Pipelined RISC Processor** using **Verilog HDL**, along with a complete **testbench** for functional verification. The processor demonstrates fundamental concepts of pipelined execution, instruction decoding, arithmetic and logical operations, memory access, branch handling, and write-back mechanisms commonly used in modern processor architectures.

---

## 📌 Overview

The processor follows a classical **five-stage pipeline architecture** consisting of Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB) stages. A **two-phase non-overlapping clocking scheme (clk1 and clk2)** is employed to safely separate pipeline stages and prevent race conditions. Multiple instructions are processed simultaneously in different stages, improving instruction throughput and overall processor efficiency. The design supports arithmetic, logical, memory, branch, and halt instructions. This project provides practical insight into pipelined processor implementation using Verilog HDL.

---

## 🏛️ Processor Architecture

The processor consists of the following major components:

* Program Counter (PC)
* Instruction/Data Memory
* Register Bank (32 × 32-bit)
* Arithmetic Logic Unit (ALU)
* Pipeline Registers
* Branch Control Logic
* Write-Back Unit

The datapath is organized into five stages, enabling concurrent execution of multiple instructions.

<!-- Add datapath diagram here -->

<!-- ![Processor Architecture](images/datapath.png) -->

---

## ⚙️ Pipeline Stages

### Stage 1 – Instruction Fetch (IF)

The Instruction Fetch stage retrieves instructions from memory using the Program Counter (PC). The fetched instruction and next PC value are stored in the IF/ID pipeline register. During branch execution, the PC is updated with the branch target address whenever the branch condition is satisfied. This stage ensures a continuous supply of instructions to the pipeline.

### Stage 2 – Instruction Decode / Register Fetch (ID)

The fetched instruction is decoded and source operands are read from the register bank. Immediate values are sign-extended to 32 bits when required. Instructions are categorized into different execution types such as ALU, memory, branch, or halt operations. The decoded information is then forwarded to the ID/EX pipeline register.

### Stage 3 – Execute (EX)

The Execute stage performs arithmetic, logical, comparison, and branch operations. ALU computations are performed based on the instruction type and operand values. For memory instructions, effective memory addresses are generated. Branch conditions and branch target addresses are also evaluated during this stage.

### Stage 4 – Memory Access (MEM)

The Memory stage handles data transfer operations. Load instructions fetch data from memory, while store instructions write data into memory. Arithmetic instructions simply pass their ALU results to the next stage without accessing memory.

### Stage 5 – Write Back (WB)

The Write Back stage updates the destination register with the computed result. Depending on the instruction type, either the ALU output or loaded memory data is written back to the register bank. This stage completes the execution of an instruction.

---

## 🧠 Design Specifications

### Register Bank

* 32 General Purpose Registers
* Register Width: 32 bits
* 5-bit Register Addressing
* Two Read Ports
* One Write Port

### Memory

* 1024 × 32-bit Memory Array
* Shared Instruction and Data Memory
* Supports Load and Store Operations

### Clocking Scheme

* Two-phase Non-Overlapping Clocking
* Clock Signals:

  * `clk1`
  * `clk2`
* Eliminates race conditions between adjacent pipeline stages

---

## 🧩 Pipeline Registers

| Pipeline Register | Purpose                                                   |
| ----------------- | --------------------------------------------------------- |
| IF/ID             | Stores fetched instruction and next PC                    |
| ID/EX             | Stores decoded operands, immediate value, and instruction |
| EX/MEM            | Stores ALU result, branch information, and memory data    |
| MEM/WB            | Stores memory output or ALU result before write-back      |

These pipeline registers enable multiple instructions to be executed concurrently while maintaining correct data flow.

---

## 🔢 Supported Instruction Set

### Register-to-Register ALU Instructions

| Opcode | Operation      |
| ------ | -------------- |
| ADD    | Addition       |
| SUB    | Subtraction    |
| MUL    | Multiplication |
| AND    | Bitwise AND    |
| OR     | Bitwise OR     |
| SLT    | Set Less Than  |

### Register-to-Immediate ALU Instructions

| Opcode | Operation               |
| ------ | ----------------------- |
| ADDI   | Add Immediate           |
| SUBI   | Subtract Immediate      |
| SLTI   | Set Less Than Immediate |

### Memory Instructions

| Opcode | Operation  |
| ------ | ---------- |
| LW     | Load Word  |
| SW     | Store Word |

### Branch Instructions

| Opcode | Operation                   |
| ------ | --------------------------- |
| BEQZ   | Branch if Equal to Zero     |
| BNEQZ  | Branch if Not Equal to Zero |

### Control Instruction

| Opcode | Operation                |
| ------ | ------------------------ |
| HLT    | Halt Processor Execution |

---

## 🏗️ Instruction Categories

| Type   | Description                                           |
| ------ | ----------------------------------------------------- |
| RR_ALU | Register-to-Register Arithmetic and Logic Operations  |
| RM_ALU | Register-to-Immediate Arithmetic and Logic Operations |
| LOAD   | Memory Read Operations                                |
| STORE  | Memory Write Operations                               |
| BRANCH | Conditional Branch Operations                         |
| HALT   | Program Termination                                   |

---

## 🌿 Branch Handling

The processor incorporates branch control logic to support conditional execution. Branch instructions evaluate conditions during the Execute stage and calculate the branch target address. A dedicated control signal named `TAKEN_BRANCH` indicates successful branch execution. When a branch is taken, the Program Counter is updated accordingly, and incorrect instructions are prevented from modifying memory or registers. This mechanism ensures correct program flow and reliable execution.

---

## 🗂️ File Structure

```text
├── pipe_32.v          # 32-bit Five-Stage Pipelined Processor
├── test_pipev_32.v    # Functional Testbench
├── README.md          # Project Documentation
```

---

## 🧪 Testbench Description

The testbench verifies the functionality of the pipelined processor through simulation. It generates the required two-phase clock signals, initializes the register bank, loads machine instructions into memory, and sets processor control signals. The simulation demonstrates instruction movement through each pipeline stage while allowing observation of internal signals and waveforms. Execution continues until the halt instruction is encountered.

---

## ⏱️ Simulation Flow

* Initialize register bank and memory.
* Load instructions into instruction memory.
* Generate two-phase clock signals.
* Fetch instructions using the Program Counter.
* Decode instructions and read operands.
* Execute ALU and branch operations.
* Perform memory access when required.
* Write results back to destination registers.
* Halt execution when the HLT instruction is executed.

Due to pipelining, multiple instructions are active simultaneously in different stages of execution.

---

## 📈 Example Program Execution

The supplied testbench executes a simple sequence of instructions that initialize register values and perform arithmetic computations. Immediate instructions are used to load constants into registers, followed by register-to-register arithmetic operations. The processor successfully propagates instructions through all pipeline stages while maintaining correct data flow. Simulation results verify proper ALU functionality, register updates, and pipeline synchronization.

<!-- Add simulation waveform here -->

<!-- ![Simulation Waveform](images/waveform.png) -->

---

## 🎯 Key Learning Outcomes

* Understanding Five-Stage Pipeline Architecture
* Verilog-Based Processor Design
* Register Bank and Memory Implementation
* ALU Design and Operation
* Pipeline Register Synchronization
* Branch Handling Techniques
* Two-Phase Clocking Methodology
* Functional Verification using Testbenches
* Computer Architecture and RISC Processor Fundamentals

---

## 🚀 How to Run

1. Open the project in a Verilog simulator:

   * ModelSim
   * Vivado Simulator
   * Icarus Verilog

2. Compile the source files:

```bash
pipe_32.v
test_pipev_32.v
```

3. Run the simulation.

4. Observe:

   * Program Counter updates
   * Pipeline register activity
   * ALU outputs
   * Register bank contents
   * Memory transactions
   * Branch execution behavior

5. Analyze the generated waveforms to verify pipeline operation.

---

## 📚 References

* Hennessy & Patterson – *Computer Architecture: A Quantitative Approach*
* Computer Organization and Design
* Digital Design and Computer Architecture
* VLSI System Design Lecture Notes

---

## 👤 Author

**Shaik Sardar Basha**
M.Tech (VLSI), NIT Jamshedpur

---

⭐ If you find this project useful for learning pipelined processor design and Verilog HDL, feel free to star the repository!

