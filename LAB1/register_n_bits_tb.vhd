----------------------------------------------------------
--
--register_n_bits_tb.vhdl
--
--created: 9/10/21 
--by Jorge Jurado-Garcia
--rev: 0;
--
--testbench for for register_n_bits_tb on register_n_bits
--
---------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_n_bits_tb is 
	generic(
	      N: positive := 4
	);
end entity; 

architecture testbench of register_n_bits_tb is 
	signal CLK: std_logic;
	signal RSTB: std_logic;
	signal KEY: std_logic;
	signal INPUT: std_logic_vector(N-1 downto 0); --input value 
	signal INPUT_unsigned: unsigned(N-1 downto 0);
	signal CNT: std_logic_vector((N - 1) downto 0);
	
	constant PER: time := 15 ns;
	
------------------------------------
--Component Protype
------------------------------------
component register_n_bits is

   generic (k : positive := 4
	);

   port (
		r_clk: in std_logic;
		r_rstb: in std_logic; -- same as counter (ccjorge)
		r_key: in std_logic;  --input that will decide when the register will hold memory
		r_input: in std_logic_vector(k-1 downto 0); --input value 
		r_output : out std_logic_vector(k-1 downto 0)
   );

end component;
----------------------------------------------

begin

------------------------------------
--DUT
------------------------------------
DUT: register_n_bits
	generic map(
				k => N
				)
	port map(
			r_clk => CLK,
			r_rstb => RSTB,
			r_key  => KEY,
			r_input => INPUT,
		
			r_output => CNT
		);
		
----------------------------------------
--Test Processes
----------------------------------------

--clock process
clock: process 
begin 
	CLK <= '0';
	wait for PER/2;
	infinite: loop
		CLK <= not CLK; wait for PER/2;
	end loop;
end process clock;

 --Reset Process
 reset: process 
 begin 
	RSTB <= '0'; wait for 2*PER;
	RSTB <= '1'; wait;
end process reset;


--run process
run: process
begin 
	-- intitalize inputs 
		KEY <= '0';
		
	--wait for reset
	wait for 2*PER;
	
	--run code 
	wait for (1**N)*PER;
	KEY <= '1';
	wait for (1**N)*PER;
	
end process run;

look: process
begin 
INPUT_unsigned <= "0000";
wait for 10 ns;
 
 loop
  INPUT_unsigned <= INPUT_unsigned + 1;
  wait for PER;
  end loop;
 end process;
 
 INPUT <= std_logic_vector(INPUT_unsigned);
-----------------------------
--End test processes
--------------------------------

end architecture;

	