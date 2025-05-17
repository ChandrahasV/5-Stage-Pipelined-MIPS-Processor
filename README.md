# 5-Stage Pipelined MIPS Processor in Verilog

## Overview

This project implements a 5-stage pipelined MIPS processor in Verilog, developed as part of the CS F342 Computer Architecture course at BITS Pilani.

The processor supports six MIPS instructions — `lw`, `sw`, `j`, `xori`, `ori`, and `addi` — using a five-stage pipeline:

1. **IF** (Instruction Fetch)  
2. **ID** (Instruction Decode / Register Fetch)  
3. **EX** (Execute / ALU Operation)  
4. **MEM** (Memory Access)  
5. **WB** (Write Back)

To support pipelining, four intermediate pipeline registers are implemented:

- `IF/ID`
- `ID/EX`
- `EX/MEM`
- `MEM/WB`

The design includes a **Forwarding Unit** to resolve data hazards by bypassing data between pipeline stages, and a **Stalling Mechanism** to pause the pipeline in cases where data dependencies cannot be resolved immediately.

<p align="center">
  <img src="Src/Architecture.png" alt="Architecture">
</p>

## Supported Instructions

### 1. `lw destinationReg, offset(sourceReg)`

- **Function**: Loads a 32-bit word from memory to `destinationReg`.
- **Opcode**: `100011`
- **Format**:  
  ```
  [31:26] opcode  
  [25:21] rs (sourceReg)  
  [20:16] rt (destinationReg)  
  [15:0]  imm (offset)  
  ```

### 2. `sw sourceReg1, offset(sourceReg2)`

- **Function**: Stores a 32-bit word from `sourceReg1` to memory.
- **Opcode**: `101011`
- **Format**:  
  ```
  [31:26] opcode  
  [25:21] rs (sourceReg2)  
  [20:16] rt (sourceReg1)  
  [15:0]  imm (offset)  
  ```

### 3. `j address`

- **Function**: Jump to a new address.
- **Opcode**: `000010`
- **Format**:  
  ```
  [31:26] opcode  
  [25:0]  address  
  ```
- The final jump address is calculated by left-shifting the 26-bit address by 2 and concatenating it with the upper 4 bits of the current PC.

### 4. `xori destinationReg, sourceReg, imm`

- **Function**: Performs bitwise XOR between `sourceReg` and the immediate, stores result in `destinationReg`.
- **Opcode**: `101010`
- **Format**:  
  ```
  [31:26] opcode  
  [25:21] rs (sourceReg)  
  [20:16] rt (destinationReg)  
  [15:0]  imm (offset)  
  ```

### 5. `ori destinationReg, sourceReg, imm`

- **Function**: Performs bitwise OR between `sourceReg` and the immediate, stores result in `destinationReg`.
- **Opcode**: `001101`
- **Format**:  
  ```
  [31:26] opcode  
  [25:21] rs (sourceReg)  
  [20:16] rt (destinationReg)  
  [15:0]  imm (offset)  
  ```

### 6. `addi destinationReg, sourceReg, imm`

- **Function**: Adds `sourceReg` and sign-extended immediate, stores result in `destinationReg`.
- **Opcode**: `000111`
- **Format**:  
  ```
  [31:26] opcode  
  [25:21] rs (sourceReg)  
  [20:16] rt (destinationReg)  
  [15:0]  imm (offset)  
  ```
---

**Note**: Memory operations use byte-addressable data memory. A 32-bit word is stored using 4 consecutive memory locations in **big-endian** order.

---

## License

This project is for educational purposes. Do not plagiarize.
