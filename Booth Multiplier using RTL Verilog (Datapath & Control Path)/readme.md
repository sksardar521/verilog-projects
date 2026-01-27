# Booth Multiplier using RTL Verilog (Datapath & Control Path)

## 📌 Project Overview

This project implements a **signed Booth Multiplier** using **RTL Verilog**, following a clear **datapath–control path architecture**. The design correctly performs multiplication of signed numbers in **2’s complement representation**, verified through simulation and waveform analysis.

The project was developed, debugged, and validated end‑to‑end, including fixing real-world RTL issues such as FSM initialization, control signal completeness, output validity, and termination conditions.

---

## 🎯 Objectives

* Implement Booth’s algorithm for **signed binary multiplication**
* Separate **datapath** and **control (FSM)** logic
* Design reusable RTL modules (ALU, shifters, registers, counter)
* Verify correct operation through simulation waveforms
* Obtain correct final product `{A, Q}` for signed inputs

---

## 🧠 Booth Algorithm (Concept)

Booth’s algorithm optimizes signed multiplication by encoding the multiplier bits and reducing unnecessary additions.

### Decision Rule

Based on `(Q0, Q-1)`:

| Q0 | Q-1          | Operation   |
| -- | ------------ | ---------   |
| 0 | 0 |   Right Shift           |
| 0 |  1            | A = A + M , Right Shift  |
| 1 |  0            | A = A − M , Right Shift             |
| 1 | 1|    Right Shift          |

After every step:

* Perform **Arithmetic Right Shift** on `{A, Q, Q-1}`
* Decrement iteration counter

Final product is obtained as:

```
Product = {A, Q}
```

---

## 🏗️ Architecture Overview

### 1️⃣ Datapath

Responsible for all data operations.

**Main Components:**

* **A Register (Accumulator)** – arithmetic right shift register
* **Q Register (Multiplier)** – shift register with LSB feedback
* **Q-1 Flip‑Flop** – stores previous LSB of Q
* **M Register (Multiplicand)** – PIPO register
* **ALU** – performs add / subtract
* **Counter** – controls Booth iterations
* **Product Register** – latches final `{A, Q}` when `done` is asserted

---

### 2️⃣ Control Path (FSM)

Controls the sequencing of Booth operations.

**FSM Responsibilities:**

* Initialization of registers
* Loading multiplicand and multiplier
* Selecting add / subtract / shift operations
* Detecting completion using counter (`eqz`)
* Generating `done` signal

**FSM States:**

* `S0` – Idle / wait for start
* `S1` – Clear and initialize
* `S2` – Load multiplier
* `S3` – Add (A = A + M)
* `S4` – Subtract (A = A − M)
* `S5` – Arithmetic shift + decrement counter
* `S6` – Done (final result valid)

---

## 📁 RTL Module Description

### 🔹 `datapath.v`

* Integrates all datapath components
* Latches final output `{A, Q}` when `done = 1`
* Generates `eqz` when counter reaches zero

### 🔹 `controller.v`

* FSM controlling Booth sequencing
* Uses default signal assignments to avoid X‑propagation
* Proper state initialization ensures correct simulation start

### 🔹 `shift_register.v`

* Supports load, clear, and arithmetic right shift
* Used for both A and Q registers

### 🔹 `alu.v`

* Performs signed addition or subtraction
* Controlled by `addsub` signal

### 🔹 `counter.v`

* Initializes iteration count
* Decrements once per Booth cycle
* Drives `eqz` condition

### 🔹 `d_ff.v`

* Stores Q‑1 bit required for Booth decision logic

### 🔹 `pipo_reg.v`

* Parallel‑in parallel‑out register for multiplicand storage

---

## 🧪 Testbench

The testbench applies signed inputs:

```
M = -10
Q = 13
```

Expected result:

```
-10 × 13 = -130
```

Binary (2’s complement):

```
1101111110
```

The waveform confirms:

* Correct FSM sequencing
* Proper arithmetic right shifts
* Stable final output after `done = 1`

---

## 🐞 Debugging & Fixes (Key Learnings)

This project involved resolving real RTL design issues:

* ✅ Corrected `eqz` logic (`count == 0` instead of reduction AND)
* ✅ Initialized FSM state to avoid X‑states
* ✅ Added default assignments in FSM to prevent X‑propagation
* ✅ Latched output only when `done` is asserted
* ✅ Ensured deterministic testbench stimulus timing

These fixes resulted in a clean, stable waveform and correct signed output.

---

## 📊 Results

| Input    | Expected | Output |
| -------- | -------- | ------ |
| -10 × 13 | -130     | -130   |

Binary output:

```
1101111110
```

---

## 🚀 Applications

* Processor ALUs
* Signed arithmetic units
* Computer architecture studies
* Foundation for Modified Booth (Radix‑4 / Radix‑8)

---

## 🔮 Possible Extensions

* Modified Booth (Radix‑4)
* Carry Save Adder (CSA) integration
* Synthesis and timing analysis
* Parameterized bit‑width design

---

## 🧾 Author

**SK Sardar Basha**
M.Tech – VLSI Design

---

## 📌 Conclusion

This project demonstrates a complete RTL‑level implementation of a Booth Multiplier, highlighting both **algorithmic understanding** and **practical hardware debugging skills**, making it suitable for academic evaluation as well as VLSI internship and placement interviews.
