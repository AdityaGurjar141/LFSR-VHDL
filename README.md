# LFSR-VHDL

 Linear Feedback Shift Register(LFSR) are used to generate pseudo-random numbers.
 
 The code I have written exhibits the following states.
1) Reset = 0; (active low) The value in register stays 0x02468ACD
2) Reset =1, get_random = 0, load_seed = 0; The register keeps shifting in value to the MSB
3) get_random = 1, load_seed = 0; The shifting stops for 4 clock cycles. These 4 clock cycles are used to transmit data from the 32 bit registers to the 8 bit register.
4) get_random = 0, load_seed = 1; The shifting stops for 4 clock cycles. These 4 clock cycles are used to load the 32 bit seed into a 32 bit register but only 8 bits at a time. It also takes 4 clock cycles to complete.a�f
