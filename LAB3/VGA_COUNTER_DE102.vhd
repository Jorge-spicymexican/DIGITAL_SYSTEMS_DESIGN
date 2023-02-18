--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 3 ROM COUNTER
--DATE: 9/21/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 1
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_COUNTER_DE102 is
 port( 
	      CLOCK_50: in std_logic;
			SW : in std_logic_vector(3 downto 0);
			HEX0,HEX1,HEX2,HEX3: out std_logic_vector(7 downto 0);
			KEY: in std_logic_vector(1 downto 0)
			);
end entity VGA_COUNTER_DE102;

Architecture behavioral of VGA_COUNTER_DE102 is
---signals that will be used
	signal CLK_1HZ: std_logic;
	signal null_value: std_logic_vector(7 downto 0);
	signal ADDRESS_SIG: std_logic_vector(7 downto 0);
	signal q_sig: std_logic_vector(7 downto 0);
---------------------------------
--component declarations 
---------------------------------
component counter is 
	generic(
	      n: natural := 8 --this parameters controls the parameter of are counter
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


component ROM_1
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component clk_3hz is
	port(
		i_clk_50MHz: in std_logic;
		i_rstb: in std_logic;
		o_clk_3Hz: out std_logic
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
TPP: clk_3hz
	port map(
				i_clk_50MHz => CLOCK_50,
				i_rstb => SW(0),
				o_clk_3Hz => CLK_1HZ
	
	);
DUT: counter
	port map(
				 i_clk  => CLK_1HZ,
				 i_rstb => SW(0),
				 i_dir  => SW(1),
				 i_key  => KEY(1),
				 o_cnt(7 downto 0)  => ADDRESS_SIG,
				 r_cnt  => null_value
				
		);

ROM_1_inst : ROM_1 
	 PORT MAP (
		address(7 downto 0) => ADDRESS_SIG(7 downto 0),
		clock	 => CLK_1HZ,
		q	 => q_sig
	);	


HEX_0:  to_7seg
	 PORT MAP(
			input => q_sig(3 downto 0),
			seg7 => HEX0	
	 );
	
HEX_1:  to_7seg
	 PORT MAP(
			input => q_sig(7 downto 4),
			seg7 => HEX1	
	 );
	 
HEX_2:  to_7seg
	 PORT MAP(
			input => ADDRESS_SIG(3 downto 0),
			seg7 => HEX2	
	 );

HEX_3:  to_7seg
	 PORT MAP(
			input => ADDRESS_SIG(7 downto 4),
			seg7 => HEX3	
	 );	 
end architecture;