----------------------------------------------------------
--
--Counter_n_bit_tb.vhdl
--
--created: 9/10/21 
--by Jorge Jurado-Garcia
--rev: 0;
--
--testbench for up down counter
-- of counter_n bit
--
---------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Counter_n_bit_tb is 
	generic(
	      N: natural := 8
	);
end entity; 

architecture testbench of Counter_n_bit_tb is 
	signal CLK: std_logic;
	signal RSTB: std_logic;
	signal DIR: std_logic;
	signal KEY: std_logic;
	signal CNT: std_logic_vector((N - 1) downto 0);
	signal RCNT: std_logic_vector((N-1) downto 0);
	
	constant PER: time := 15 ns;
	
------------------------------------
--Component Protype
------------------------------------
component counter is 
	generic(
	      n: natural := 8
	);
	
	port ( 
	   i_clk: in std_logic;
		i_rstb: in std_logic;
		i_dir: in std_logic;
		i_key: in std_logic;
		o_cnt: out std_logic_vector(n-1 downto 0);
		r_cnt: out std_logic_vector(n-1 downto 0)
	);
	
end component;

----------------------------------------------

begin

------------------------------------
--DUT
------------------------------------
DUT: counter
	generic map(
				n => N
				)
	port map(
			i_clk => CLK,
		i_rstb => RSTB,
		i_dir  => DIR,
		i_key  => KEY,
		
		
		o_cnt   =>CNT,
		r_cnt => RCNT
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
end process;

 --Reset Process
 reset: process 
 begin 
	RSTB <= '0'; wait for PER;
	RSTB <= '1'; wait;
end process reset;

--run process
run: process
begin 
	-- intitalize inputs 
		DIR <= '0';
		
	--wait for reset
	wait for 2*PER;
	
	--run code 
	wait for (2**N)*PER;
	DIR <= '1';
	wait for (2**N)*PER;
	
end process run;

--run process
runn: process
begin 
	-- intitalize inputs 
		KEY <= '0';
		
	--wait for reset
	wait for 3*PER;
	
	infinite: loop
		KEY <= not KEY; wait for 3*PER;
	end loop;
	
end process runn;


-----------------------------
--End test processes
--------------------------------

end architecture;

	