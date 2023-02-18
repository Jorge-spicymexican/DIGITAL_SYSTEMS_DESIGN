----------------------------------------------
--Counter_DE10_n_bits
--created 9/11/21
--Jorge Jurado-Garcia
--rev 0
----------------------------------------------
--Inputs: rstb, clk, dir 
--outputs: cnt
----------------------------------------------
--counts up when dir = 0
--counts down when dir = 1
----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter_DE10_n_bits is
 port( 
			CLOCK_50: in std_logic;
			SW: in std_logic_vector(1 downto 0);
			HEX0: out std_logic_vector(7 downto 0);
			HEX1: out std_logic_vector(7 downto 0);
			KEY: in std_Logic_vector(1 downto 0); --key 1
			LEDR: out std_logic_vector(7 downto 0) );
end entity Counter_DE10_n_bits;

Architecture behavioral of Counter_DE10_n_bits is
---signals that will be used
	signal CLK_SIG: std_logic; --intermediate value
	signal INPUT_SIG: std_logic_vector(3 downto 0);
	signal INPUT_SIG2: std_logic_vector(3 downto 0);
---------------------------------
--component declarations 
---------------------------------
component Timer_n_sec is
	generic(
	      k: natural := (1)
	);
	port( 
			i_clk_50MHZ: in std_logic;
			i_rstb: in std_logic;		
			o_clk_nHz: out std_logic 
	);
end component;


component ccjorge is 
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

component to_7seg is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (7 downto 0)
             );
end component;


end component;

--------------------------------------------
begin 
-----------------------------------
--Device under test (DUT)
-----------------------------------
CK: Timer_n_sec 
	port map(
				 i_clk_50MHZ  => CLOCK_50,
				 i_rstb => SW(1),
				 o_clk_nHz => CLK_SIG
		);

DUT: ccjorge
	port map(
				 i_clk  => CLK_SIG,
				 i_rstb => SW(1),
				 i_dir  => SW(0),
				 i_key  => KEY(1),
				 o_cnt(3 downto 0)  => INPUT_SIG,
				 o_cnt(7 downto 4)  => INPUT_SIG2,
				 r_cnt  => LEDR(7 downto 0)
		);

JFK: to_7seg
	port map(
				 input  => INPUT_SIG,
				 seg7   => HEX0(7 downto 0)
		);

FJK: to_7seg
	port map(
				 input => INPUT_SIG2,
				 seg7   => HEX1(7 downto 0)
		);
end architecture;
				 