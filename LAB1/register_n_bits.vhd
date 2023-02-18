----------------------------------------------
--register_n_bits.vhdl
--
--created 9/10/21
--Jorge Jurado-Garcia
--rev 0
----------------------------------------------
--
--Inputs: rstb, clk, key, r_input
--outputs: r_output
--
----------------------------------------------
--
--counts up when dir = 0
--counts down when dir = 1
--
----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--created a 4 bit register 
entity register_n_bits is

   generic (k : positive := 4
	);

   port (
		r_clk: in std_logic;
		r_rstb: in std_logic; -- same as counter (ccjorge)
		r_key: in std_logic;  --input that will decide when the register will hold memory
		r_input: in std_logic_vector(k-1 downto 0); --input value 
		r_output : out std_logic_vector(k-1 downto 0)
   );

end register_n_bits;

architecture behavioral of register_n_bits is

signal state: std_logic_vector(k-1 downto 0);
--state(0), state(1), state(2), state(3)

begin
	
   process(r_clk, r_rstb)
		begin
		--
		--rst
		--
		
		if(r_rstb = '0') then 
			state <= (others => '0');
		
		
        elsif(rising_edge(r_clk)) then
			if(r_key = '1') then
				state <= r_input; 
			else
				state <= state;
				end if;
				end if;
			end process;
			
		---
		--output logic
		--
		r_output <= std_logic_vector(state);
		
end behavioral;
		