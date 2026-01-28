# Four-Stage Pipelined Datapath in Verilog

This repository implements a **4-stage pipelined processor datapath** using **Verilog HDL**, along with a complete **testbench** and simulation results. The design is based on classical pipeline modeling concepts commonly taught in **Computer Architecture and VLSI Design** courses.

---

## 📌 Overview

The pipeline is divided into **four stages**, each triggered using a **non-overlapping two-phase clock (clk1 and clk2)** to avoid race conditions:

1. **Stage 1 – Register Fetch**
   Reads operands from the register bank using source register addresses.

2. **Stage 2 – ALU Operation**
   Performs arithmetic or logical operation based on the function code.

3. **Stage 3 – Register Write Back**
   Writes the ALU result back to the destination register.

4. **Stage 4 – Memory Write**
   Stores the result into memory at the specified address.

---

## 🧠 Design Assumptions

* **Register Bank**:

  * 16 registers, each **16-bit wide**
  * 4-bit addressing (rs1, rs2, rd)
  * Two read ports and one write port

* **Memory**:

  * 256 × 16-bit memory
  * 8-bit address bus
  * Single-cycle write

* **Clocking**:

  * Two-phase non-overlapping clocks (clk1, clk2)
  * Used to safely separate consecutive pipeline stages

---

## 🧩 Pipeline Registers

| Latch | Purpose                     |
| ----- | --------------------------- |
| L12   | Between Stage 1 and Stage 2 |
| L23   | Between Stage 2 and Stage 3 |
| L34   | Between Stage 3 and Stage 4 |

These latches hold operands, ALU results, destination register IDs, and memory addresses as data flows through the pipeline.


<img width="521" height="221" alt="image" src="https://github.com/user-attachments/assets/81e45a78-1c53-43b5-a8b6-d89fc232f503" />

---

## 🔢 ALU Operations Supported

| Func Code | Operation     |
| --------- | ------------- |
| 0000      | ADD           |
| 0001      | SUB           |
| 0010      | MUL           |
| 0011      | SELA (Z = A)  |
| 0100      | SELB (Z = B)  |
| 0101      | AND           |
| 0110      | OR            |
| 0111      | XOR           |
| 1000      | NOT A         |
| 1001      | NOT B         |
| 1010      | Shift Right A |
| 1011      | Shift Left A  |

---

## 🗂️ File Structure

```
├── pipeline_4.v      # Main 4-stage pipelined datapath design
├── testbench.v      # Testbench for simulation and verification
├── README.md        # Project documentation
```

---

## 🧪 Testbench Description

The testbench performs the following:

* Generates **two-phase clock signals** (clk1 and clk2)
* Initializes the register bank with known values
* Applies multiple instructions with different:

  * Source registers (rs1, rs2)
  * Destination registers (rd)
  * ALU functions (func)
  * Memory addresses (addr)
* Displays final memory contents to verify correct pipeline behavior

---

## ⏱️ Simulation Flow

* Instructions enter the pipeline every cycle
* Results appear after passing through all four stages
* Due to pipelining, multiple instructions are processed **simultaneously** in different stages

The waveform clearly shows:

* Correct data propagation through pipeline registers
* Proper synchronization using clk1 and clk2
* Final ALU results written to both register bank and memory

---

## 📈 Sample Output (Memory)

```
mem[155] =  8
mem[156] = 24
mem[157] =  3
mem[158] = 14
```

This confirms correct execution of ADD, MUL, SUB, and SHIFT operations through the pipeline.

---

## 🎯 Key Learning Outcomes

* Understanding of **pipeline modeling in Verilog**
* Use of **two-phase clocking** to avoid race conditions
* Practical implementation of **register bank + ALU + memory**
* Pipeline register design and data forwarding through stages

---

## 🚀 How to Run

1. Open the project in any Verilog simulator (ModelSim / Vivado / Icarus)
2. Compile `pipeline_4.v` and `testbench.v`
3. Run the simulation
4. Observe waveforms and console output

---

## 📚 References

* Hennessy & Patterson – *Computer Architecture*
* Digital Design and Computer Architecture
* VLSI Design lecture notes

---

## 👤 Author
**Shaik Sardar Basha**  
M.Tech (VLSI), NIT Jamshedpur  


---

⭐ If you find this helpful for learning pipelining, feel free to star the repository!
