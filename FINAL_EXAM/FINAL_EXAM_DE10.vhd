----------------------------
--LAB: FINAL LAB
--Author: Jorge Jurado-Garica
--REV 1
--INPUTS: key(0), clock50, sw(9)-sw(0)
--OUTPUTS: HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
--
-----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity FINAL_EXAM_DE10 is
 port( 
			KEY: in std_logic_vector(1 downto 0);
			CLOCK_50: in std_logic;
			SW: in std_logic_vector(9 downto 0);
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(7 downto 0)
		);
end entity FINAL_EXAM_DE10;

Architecture behavioral of FINAL_EXAM_DE10 is
---signals that will be used
	signal INPUT_D0_SIGNAL: std_logic_vector(3 downto 0);
	signal INPUT_D1_SIGNAL: std_logic_vector(3 downto 0);
	signal INPUT_D2_SIGNAL: std_logic_vector(3 downto 0);
	signal INPUT_D3_SIGNAL: std_logic_vector(3 downto 0);
	signal INPUT_out_SIGNAL: std_logic_vector(7 downto 0);
	
	---------------------------------
--component declarations 
---------------------------------
Component milli_timer1 IS
PORT (
    resetN, start : STD_LOGIC;
	clk : IN STD_LOGIC;
	dig0, dig1, dig2, dig3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) );
END component;

Component countN_en3 IS
	GENERIC (N : integer:=255;
				M : integer:= 1);
	PORT ( clk, sel, counten: IN STD_LOGIC;
			outval: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END component;

component to_7seg is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (7 downto 0)
             );
end component;

component to_7seg2 is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (7 downto 0)
             );
end component;


Component rom_1 IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;

--------------------------------------------
begin
---------------------------
--device under test (DUT)
---------------------------
RMM: rom_1
	PORT MAP(
			address(7 downto 0) => INPUT_out_SIGNAL,
			clock => CLOCK_50,
			q(7 downto 0) => HEX4(7 downto 0),
			q(15 downto 8) => HEX5(7 downto 0)
	
		);
	
	
CK: milli_timer1
	PORT MAP(
				resetN => KEY(1),
				start => SW(0),
				clk => CLOCK_50,
				dig0 => INPUT_D0_SIGNAL,
				dig1 => INPUT_D1_SIGNAL,
				dig2 => INPUT_D2_SIGNAL,
				dig3 => INPUT_D3_SIGNAL
	
			);
			
--uses the input_d3_signal from milli_timer to configure the count enabler 
--for this component
cnt: countN_en3 
	PORT MAP(
				clk => CLOCK_50,
				sel => SW(9),
				counten => INPUT_D3_SIGNAL(0),
				outval(7 downto 0) => INPUT_out_SIGNAL
			);
	
JFK0: to_7seg 
	port map(
				 input  => INPUT_D0_SIGNAL,
				 seg7   => HEX0(7 downto 0)
			);

JFK1: to_7seg 
	port map(
				 input  => INPUT_D1_SIGNAL,
				 seg7   => HEX1(7 downto 0)
			);

JFK2: to_7seg 
	port map(
				 input  => INPUT_D2_SIGNAL,
				 seg7   => HEX2(7 downto 0)
			);

--seconds timer 
JFK3: to_7seg2 
	port map(
				 input  => INPUT_D3_SIGNAL,
				 seg7   => HEX3(7 downto 0)
			);
						
end architecture;