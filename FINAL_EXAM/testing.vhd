--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 2 FINITE STATE MACHINE LOGIC DESIGN
--FOR BREAD MAKER_tb
--DATE: 9/14/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 1
		--included output logic of fsm 11/05/21
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testing is 
	--non entry 
end entity; 
		
architecture testbench of testing is 
	signal CLK: std_logic;
	signal SEL: std_logic;
	signal ENABLE: std_logic;
	signal OUTT: std_logic_vector(7 downto 0);
	constant PER: time := 15 ns;
	
------------------------------------
--Component Protype
------------------------------------
component countN_en3 IS
	GENERIC (N : integer:=255;
				M : integer:= 2);
	PORT ( clk, sel, counten: IN STD_LOGIC;
			outval: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END component;


--end component
----------------------------------------------

begin

------------------------------------
--DUT(Device under testing)
------------------------------------
DUT: countN_en3
	port map(
	--inputs
		clk => CLK,
		sel => SEL,
		counten => ENABLE,
		outval  => OUTT
		
		);
		
----------------------------------------
--Test Processes
----------------------------------------

--clock process
clock: process 
begin 
	CLK <= '0';
	wait for (PER/2);
	infinite: loop
		CLK <= not CLK; wait for PER/2;
	end loop;
end process;

 --Reset Process
 reset: process 
 begin 
	SEL <= '0'; wait for 2*PER;
	SEL <= '1'; wait;
end process reset;


 poop: process 
 begin 
	ENABLE <= '0'; wait for 2*PER;
	ENABLE <= '1'; wait;
end process poop;

-----------------------------
--End test processes
--------------------------------

end architecture;

	