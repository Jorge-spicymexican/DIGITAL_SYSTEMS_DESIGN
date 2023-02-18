--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 2 FINITE STATE MACHINE LOGIC DESIGN
--FOR BREAD MAKER_tb
--DATE: 9/14/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 1
		--included output logic of fsm 9/15/21
--
--INPUTS: BREAD TYPE: REGULAR OR DOUGH 
--			 START, RESET(RSTB)
--
--OUTPUTS: HEATER(1), HEATER(2), BEATER, BEEPER.
--PROCESS:
--1.Mix – HEATER[1] & HEATER [2] off, BEATER ON for (2) seconds, off (3) seconds (3x)
--2.Knead – BEATER ON for (10) seconds
--3.Rise1 – BEATER OFF, HEATER[1] for (10) seconds
--4.Beat down – HEATER[1] OFF, BEATER ON For (2) seconds
--5.Rise2 - BEATER OFF, HEATER[1] for (12) seconds
--6.Bake – HEATER[1] and HEATER[2] ON for (7) seconds
--7.Done – HEATER[1] AND HEATER[2] OFF, BEATER OFF, BEEPER ON for (5) seconds,
--         then light the Done LED until either a reset or the start of another cycle.
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bread_machine_tb is 
	--non entry 
end entity; 
		
architecture testbench of Bread_machine_tb is 
	signal CLK: std_logic;
	signal START: std_logic;
	signal RSTB: std_logic;
	signal DOUGH: std_logic;
	signal REGULAR: std_logic;
	signal CNT: std_logic_vector(3 downto 0);
	signal HEATER1: std_logic;
	signal HEATER2: std_logic;
	signal BEATER: std_logic;
	signal BEEPER: std_logic;
	signal FINISHED: std_logic;
	constant PER: time := 15 ns;
	
------------------------------------
--Component Protype
------------------------------------
component Bread_machine is 
	port(
			clk,start,rstb, dough,regular: IN std_logic;
			count: OUT std_logic_vector(3 downto 0);
			heater1, heater2, beater, beeper, finished : OUT std_logic
		 );
end component Bread_machine;

--end component
----------------------------------------------

begin

------------------------------------
--DUT(Device under testing)
------------------------------------
DUT: Bread_machine
	port map(
	--inputs
		clk => CLK,
		start=> START,
		rstb => RSTB,
		dough  => DOUGH,
		regular  => REGULAR,
		
	--outputs
		count => CNT,
		heater1 => HEATER1,
		heater2 => HEATER2,
		beater => BEATER,
		beeper => BEEPER,
		finished => FINISHED
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
	RSTB <= '0'; wait for 2*PER;
	RSTB <= '1'; wait;
end process reset;

--run process
run: process
begin 
	-- intitalize inputs 
		DOUGH <= '0';
		REGULAR <= '0';
		START <= '0'; 
		wait for 4*PER;
		
		DOUGH <= '1';
		REGULAR <= '1';
		START <= '1';
		wait for 5*PER;
		
	--wait for reset
		wait for PER;
		DOUGH <= '1';
		REGULAR <= '0';
		START <= '1'; 
		wait for 45*PER;
		
		DOUGH <= '0';
		REGULAR <= '1';
		START <= '1'; 
		wait;
end process run;
-----------------------------
--End test processes
--------------------------------

end architecture;

	