--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 3 8-bit shift register 
--DATE: 9/24/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 1
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity eight_bit_register is 
	generic(
				N: natural:= 8
			 );
	port(
		i_clk : in std_logic;
		i_rstb : in std_logic;
		i_d: in std_logic;
		i_shift: in std_logic;
		i dir: in std_logic;
		
		o_Q: out std_logic_vector((N-1) downto 0)
	
	);
end entity 

architecture behavioral of eight_bit_register is
	--
	--internal signals
	--
	signal q_sig: unsigned((N-1) downto 0);

	begin 
	
		process(i_clk, i_rstb)
			begin 
				--
				--reset
				--
				if(i_rstb = '0') then 
					q_sig <= (others => '0');
				--
				--rising clk edge
				--
				elsif(rising_edge(i_clk)) then 
				--
				--shifting
				--
				if(i_shift = '0') then
					q_sig <= q_sig;
				elsif(i_dir = '0') then
					q_sig <= q_sig((N-2) downto 0) & i_d;
				else 
					q_sig <= i_d & q_sig((N-1) downto 1);
				end if;
		end if;
end process;
--
--output logic
--
	o_Q <= std_logic_vector(q_sig);

end behavioral;

					