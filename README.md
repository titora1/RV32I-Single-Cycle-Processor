# 32-bit Single-Cycle RV32I RISC-V Processor

A complete 32-bit single-cycle RV32I RISC-V processor designed in Verilog, verified using ModelSim and Xilinx Vivado, and implemented on the PYNQ-Z2 FPGA platform.

## Project Overview

This project implements a 32-bit single-cycle processor based on the RV32I RISC-V instruction set architecture.

Each instruction is executed within a single clock cycle through an integrated datapath and control path.

The processor supports arithmetic, logical, shift, comparison, load/store, branch, jump, and upper-immediate instructions.

## Architecture

The processor consists of the following major RTL blocks:

- Program Counter
- Instruction Memory
- Register File
- Main Control Unit
- ALU Control Unit
- Immediate Generator
- Arithmetic Logic Unit
- Branch Unit
- Data Memory
- ALU Source Selection Logic
- Write-back Datapath
- Branch / Jump Target Logic
- JAL / JALR Control Logic
- Top-Level RV32I Processor Integration

## Supported Instructions

### Arithmetic and Logical

- ADD
- SUB
- AND
- OR
- XOR
- SLT
- SLTU

### Shift Instructions

- SLL
- SRL
- SRA

### Immediate Instructions

- ADDI
- ANDI
- ORI
- XORI
- SLTI
- SLTIU
- SLLI
- SRLI
- SRAI

### Load Instructions

- LB
- LH
- LW
- LBU
- LHU

### Store Instructions

- SB
- SH
- SW

### Branch Instructions

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

### Jump and Upper-Immediate Instructions

- JAL
- JALR
- LUI
- AUIPC

## Repository Structure

```text
RV32I-Single-Cycle-Processor/
├── rtl/
│   ├── ALU.v
│   ├── ALU_control.v
│   ├── Branch_Unit.v
│   ├── Immediate_Generator.v
│   ├── Instruction_Memory.v
│   ├── PC.v
│   ├── data_memory.v
│   ├── main_control_unit.v
│   ├── register.v
│   └── processor_top.v
│
├── tb/
│   ├── ALU_tb.v
│   ├── ALU_control_tb.v
│   ├── Branch_Unit_tb.v
│   ├── Control_System_tb.v
│   ├── Data_Memory_tb.v
│   ├── Immediate_Generator_tb.v
│   ├── Instruction_Memory_tb.v
│   ├── PC_tb.v
│   ├── main_control_unit_tb.v
│   ├── register_tb.v
│   └── processor_top_tb.v
│
├── docs/
│   ├── simulation_waveform.png
│   ├── rtl_schematic.png
│   ├── utilization_report.png
│   ├── timing_summary.png
│   └── pynq_z2_demo.jpg
│
└── README.md
```

## Tools and Technologies

- Verilog HDL
- ModelSim
- Xilinx Vivado
- Vivado Simulator
- RTL Simulation
- Testbench Development
- FPGA Synthesis
- FPGA Implementation
- Timing Analysis
- Bitstream Generation
- PYNQ-Z2 FPGA Board

## Verification

Each major processor block was independently verified using dedicated Verilog testbenches before top-level integration.

Module-level verification included:

- ALU operations
- Register read/write behavior
- Immediate generation
- Main control signal generation
- ALU control decoding
- Program-counter operation
- Branch-condition evaluation
- Instruction-memory access
- Data-memory load/store operations

The complete processor was then verified using full instruction sequences covering:

- Arithmetic and logical operations
- Shift operations
- Signed and unsigned comparisons
- Register write-back
- Memory reads and writes
- Conditional branches
- JAL and JALR
- LUI and AUIPC

Register and memory values were checked through simulation waveforms and testbench outputs.

## FPGA Implementation

The complete processor was synthesized and implemented using Xilinx Vivado for the PYNQ-Z2 FPGA platform.

The implementation flow included:

- RTL elaboration
- Design synthesis
- FPGA implementation
- Design-rule checking
- Resource-utilization analysis
- Static timing analysis
- Bitstream generation
- FPGA programming
- On-board hardware validation

The generated bitstream was successfully programmed onto the PYNQ-Z2 FPGA board.

Processor operation was validated on hardware using debug outputs mapped from internal processor state.

## FPGA Design Flow

```text
Verilog RTL
    ↓
Behavioral Simulation
    ↓
RTL Elaboration
    ↓
Synthesis
    ↓
Implementation
    ↓
Timing Analysis
    ↓
Bitstream Generation
    ↓
PYNQ-Z2 Programming
    ↓
Hardware Validation
```

## Key Learning Outcomes

This project provided hands-on experience with:

- RISC-V instruction-set architecture
- Processor datapath design
- Control-path design
- RTL design using Verilog
- Single-cycle processor microarchitecture
- Memory interfacing
- Branch and jump control
- RTL debugging
- Functional verification
- FPGA synthesis and implementation
- Static timing analysis
- FPGA hardware deployment

## Results

The processor successfully executed RV32I instruction sequences in simulation and on the PYNQ-Z2 FPGA platform.

The design was verified at both module level and complete-processor level before FPGA deployment.

Functional validation confirmed correct operation of:

- Register-file operations
- ALU execution
- Immediate generation
- Memory accesses
- Branch control
- Jump control
- Program-counter updates
- Write-back operations

## Future Improvements

Possible future extensions include:

- 5-stage pipelined implementation
- Forwarding and hazard-detection units
- Instruction and data caches
- AXI interface integration
- UART-based processor debugging
- Vivado Integrated Logic Analyzer support
- Performance-counter implementation
- RV32M multiplication/division extension

## Author

**Shrey Jaiswal**  
B.Tech Electronics and Communication Engineering  
SRM Institute of Science and Technology
