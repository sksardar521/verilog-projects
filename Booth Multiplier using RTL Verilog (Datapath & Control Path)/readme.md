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



<img width="620" height="332"  alt="image" src="https://github.com/user-attachments/assets/df9070df-c300-463b-b525-d6246923caec" />


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

##  Architecture Overview

### 1️⃣ Datapath

Responsible for all data operations.


<img width="601" height="381" alt="image" src="https://github.com/user-attachments/assets/b5213abc-25b6-4a6e-9cd7-7065740b7bec" />

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


<img width="593" height="459" alt="image" src="https://github.com/user-attachments/assets/1c029e6a-077e-4181-9c76-2b5ab5fe6d7c" />

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

<img width="704" height="202" alt="image" src="https://github.com/user-attachments/assets/91563d63-4d35-459c-80e3-b8fd931ce5e2" />
<img width="148" height="253" alt="image" src="https://github.com/user-attachments/assets/aa937cb0-e058-4e34-881b-fcfbad9499b5" />

### 🔹 `shift_register.v`

* Supports load, clear, and arithmetic right shift
* Used for both A and Q registers
<img width="701" height="307" alt="image" src="https://github.com/user-attachments/assets/f5ce6b32-8423-4ec9-90aa-021b13cfb39b" />

### 🔹 `alu.v`

* Performs signed addition or subtraction
* Controlled by `addsub` signal
<img width="666" height="263" alt="image" src="https://github.com/user-attachments/assets/9be8c5e3-e59b-4b72-ad15-05fd9b861926" />

### 🔹 `counter.v`

* Initializes iteration count
* Decrements once per Booth cycle
* Drives `eqz` condition

<img width="584" height="237" alt="image" src="https://github.com/user-attachments/assets/6d03e247-f4b7-483f-b772-d6b32b7b5b36" />

### 🔹 `d_ff.v`

* Stores Q‑1 bit required for Booth decision logic
<img width="554" height="270" alt="image" src="https://github.com/user-attachments/assets/21679438-227e-4ffe-935d-c4a68ae762d8" />

### 🔹 `pipo_reg.v`

* Parallel‑in parallel‑out register for multiplicand storage

<img width="536" height="266" alt="image" src="https://github.com/user-attachments/assets/fdc523b5-811a-46a7-bde5-48b926b65e47" />

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
<img width="938" height="346" alt="image" src="https://github.com/user-attachments/assets/92f5566f-87e3-49a0-ba34-d46408a6507e" />

<img width="750" height="244" alt="image" src="https://github.com/user-attachments/assets/68c4f4a3-1e1d-464e-80a2-e6b476adf3db" />

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
