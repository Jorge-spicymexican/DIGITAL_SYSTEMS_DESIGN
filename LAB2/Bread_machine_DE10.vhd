--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 2 FINITE STATE MACHINE LOGIC DESIGN
--FOR BREAD MAKER
--DATE: 9/16/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 1
--
--INPUTS: BREAD TYPE: REGULAR(SW0) OR DOUGH(SW1) 
--			 START(SW2), RESET(RSTB) (SW3)
--OUTPUTS: HEATER(1)[LEDR0], HEATER(2)[LEDR1], BEATER[LEDR2], BEEPER[LEDR3]. FINISHED[LEDR9]
--Timer count value will be displayed on HEX(0)
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

entity Bread_machine_DE10 is
 port( 
			CLOCK_50: in std_logic;
			SW: in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(7 downto 0);
			LEDR: out std_logic_vector(9 downto 0) );
end entity Bread_machine_DE10;

Architecture behavioral of Bread_machine_DE10 is
---signals that will be used
	signal CLK_SIG: std_logic; --intermediate value
	signal CNT_SIG: std_logic_vector(3 downto 0);
---------------------------------
--component declarations 
---------------------------------
component clk_3hz is
	port(
		i_clk_50MHz: in std_logic;
		i_rstb: in std_logic;
		o_clk_3Hz: out std_logic
	);
end component;

component Bread_machine is 
	port(
			clk,start,rstb, dough,regular: IN std_logic;
			count: OUT std_logic_vector(3 downto 0);
			heater1, heater2, beater, beeper, finished : OUT std_logic
		 );
end component;

component to_7seg is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (7 downto 0)
             );
end component;
--------------------------------------------
begin 
-----------------------------------
--Device under test (DUT)
-----------------------------------
CK: clk_3hz 
	port map(
				 i_clk_50MHz  => CLOCK_50,
				 i_rstb => SW(3),
				 o_clk_3Hz => CLK_SIG
		);

DUT: Bread_machine
	port map(
				 clk  => CLK_SIG,
				 start => SW(2),
				 rstb => SW(3),
				 dough  => SW(1),
				 regular  => SW(0),
				 count(3 downto 0) => CNT_SIG,
			--	 ll(3 downto 0) => CNT_SIG2,
				 heater1 => LEDR(0),
				 heater2 => LEDR(1),
				 beater =>  LEDR(2),
				 beeper =>  LEDR(3),
				 finished => LEDR(9) 
		);

JFK: to_7seg
	port map(
				 input  => CNT_SIG,
				 seg7   => HEX0(7 downto 0)
		);
	
end architecture;