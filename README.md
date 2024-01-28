# ENGR 399/599 Lab 2: Obfuscation
Adapted from Swarup Bhunia at the University of Florida. v2024.0

<span style="color:red">Due: 11:59pm, Friday Feb. 23, 2024</span>

## Overview

In this lab you will implement different hardware obfuscation techniques for securing hardware intellectual properties (IPs) against piracy, tampering attacks, and overproduction.

==TODO add resources for students to look through and potentially hints for lab==

## Lab
### Part 1: Brute Force an Obfuscated Circuit

1. Each group is given a different bitstream implementing combinational circuit obfuscation.

	- The provided bitstream will show 4 blinking LEDs on pins LD0 (U16), LD1 (E19), LD2 (U19), LD3 (V19) on the Basys3 board.
	- The underlying design is obfuscated within the combinational logic - it will only function correctly when supplied with the correct key input.

Your group's bitstreams are available to download [here](https://github.com/ENGR599/P2_Obfuscation)

2. Program the Basys3 board with the appropriate bitstream for your group through the Vivado hardware manager.
3. The key is set by toggling eight different DIP switches on the board (SW7-SW0). These switches represent 1-bit in an 8-bit vector for the key input.

| Key Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Switch | SW7 | SW6 | SW5 | SW4 | SW3 | SW2 | SW1 | SW0 |

4. One way to attack combinational obfuscation is to simply try enough keys until we observe the circuit functions correctly.
	- Carry out a brute-force attack on the obfuscated circuit by using the DIP switches to guess the key. Try this at least 20 times and record the keys that you tried in your report.
	- Observe how long it took (approximately) to try the 20 different keys. Calculate how many total keys you would have to test to solve an 8-bit key and how long it would take you to test these keys based upon your previous observation. Now calculate how long it would take to test a 256-bit key. Do you think it would be possible to test that many keys through a brute-force attack? Record your calculations and answer to the previous question in your report.
	- If you discovered the key, great! Skip down to step 6. If not, then continue to the next step.

*Note* 
Due to using the DIP switches to break the key taking some time, we have provided a UART interface within the blinking LEDs IP that you can communicate with over the micro USB cable plugged into the Basys3 board.

5. Use the provided `uart.py` python file to send bytes of data over UART (i.e. the key) to the Basys3 board. The Basys3 will send a byte back of either `0xFF` (the key is correct) or `0x11` (the key is incorrect). Determine the key either through the received byte from the board or the LEDs starting to blink.
6. Once you have discovered the key record your group number and that key in your report.

### Part 2: Design a Circuit with Combinational Obfuscation.

1. In this section you will extend the provided `blink.v` circuit with combinational obfuscation.
2. Start by creating a Vivado project like you did in the first lab. Make sure to add the `blink.v` (under the `rtl/` directory) as a verilog source and the `p2_constraints.xdc` as a constraints source when creating the project.
3. You must make the `blink.v` circuit dependent on the correct key inputs from the same DIP switches used previously (SW0-SW7).

==TODO: continue step 3 hint and step 4. maybe add in overview section==

5. Incorporate all 8 bits of the key vector input in `blink.v` such that the circuit will correctly pulse the LEDs when all 8 bits of the key are set correctly. Submit your extended `blink.v` as well as the correct key used to unlock the circuit.
	- *You may change the circuit or extend it with additional signals to accomplish this task.*
	- Ensure you use good key practices, therefore do not use easily guessable keys, i.e., `0x00` and `0xFF`.

### Part 3: Design a Circuit with Sequential Obfuscation

The state machine of an integrated circuit (IC) can be obfuscated to lock the design. In regular state machine design, usually not all possible states are in operation. These are often states that never occur, or are not reachable.

These states can be used to introduce additional locking mechanisms into the design. Another way to obfuscate the state machine is hiding the startup state. Designers can add an extra state machine before the actual desired state machine which will make the access to the initial state of the original state reachable for only a specific input sequence.

1. Import the provided `p3.v` verilog module into your Vivado project.
	- *Note*: Make sure you set the `p3.v` as your top module.
2. Update your `p2_constraints.xdc` to match the following:
==TODO: Update this section with proper constraints for seven segment==
3. The `p3.v` verilog file implements a state machine that increments the 7-segment LED display on the Basys3 board from 0 to 9. Extend the states of `p3.v` to sequentially obfuscate the startup state with 8 additional states (one state for each bit of the key).
==TODO Create figure to showcase the state machine==
4. Your additional states should function as follows:
	1. User will input a key using the DIP switches on the board.
	2. Each state will validate an individual bit of the key before progressing to the next state and finally the original state machine to count up from 0 to 9.
	3. **If a state detects the incorrect bit, the state machine should transition to a "black hole" state that cannot be escaped from without reprogramming the bitstream.**
5. Submit your extended `p3.v` RTL, along with capturing the 8-bit key you used to obfuscate the state machine in your report.

## What to Turn In

***Please upload a zipped folder to Canvas containing the following:***

- A report containing your brute forced key & short answer from parts 1.4 and 1.6.
- Extended `blink.v` source code from part 2.5 and the key used to obfuscate the design in the report.
- Extended `p3.v` source code from part 3.4 and the key used to obfuscate the design in the report.

