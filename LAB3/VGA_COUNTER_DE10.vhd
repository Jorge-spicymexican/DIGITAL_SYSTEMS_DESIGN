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

entity VGA_COUNTER_DE10 is
 port( 
	      CLOCK_50: in std_logic;
			SW : in std_logic_vector(3 downto 0);
			HEX0,HEX1,HEX2,HEX3: out std_logic_vector(7 downto 0);
			KEY: in std_logic_vector(1 downto 0)
			);
end entity VGA_COUNTER_DE10;

Architecture behavioral of VGA_COUNTER_DE10 is
---signals that will be used
	signal ADDRESS_SIG: std_logic_vector(7 downto 0);
	signal CLK_25MHz: std_logic;
	signal R_OUT_SIG: std_logic_vector(3 downto 0);
	signal G_OUT_SIG: std_logic_vector(3 downto 0);
	signal B_OUT_SIG: std_logic_vector(3 downto 0);
	signal null_value: std_logic_vector(7 downto 0);
	signal q_sig: std_logic_vector(7 downto 0);
	signal VID_ON_SIG: std_logic;
	signal HOR_SYNC_OUT_SIG: std_logic;
	signal VER_SYNC_OUT_SIG: std_logic;
	signal pixel_row_SIG: std_logic_vector(9 downto 0);
	signal pixel_COL_SIG: std_logic_vector(9 downto 0);
	
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

component VGA_SYNC IS
	PORT(	clock_video: IN	STD_LOGIC;
			redin,greenin,bluein : in std_logic_vector(3 downto 0);
			red_out, green_out, blue_out : out std_logic_vector(3 downto 0);
			horiz_sync_out, vert_sync_out, video_on : OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END component;

component barrel_shifter_Nbit_load is
	generic(
		
				 n: natural := 8 --this parameters controls the parameter
			 );
	port(
	--Creating a 4 bit barrel shifter just like his exaxmple on HW2 notes
		i_data_in:  in std_logic_vector((n-1) downto 0);
		i_loadbar :   in std_logic;
		i_shift_amount: in std_logic_vector(2 downto 0);
		i_dir:       in std_logic; --when dir is high then shifting right else left
		o_data_out:  out std_logic_vector( (n-1) downto 0)
		);
		
end component;
--------------------------------------------
begin 
-----------------------------------
--Device under test (DUT)
-----------------------------------
DUT: counter
	port map(
				 i_clk  => CLOCK_50,
				 i_rstb => SW(1),
				 i_dir  => SW(0),
				 i_key  => KEY(1),
				 o_cnt(7 downto 0)  => ADDRESS_SIG,
				 r_cnt  => null_value
				
		);

ROM_1_inst : ROM_1 
	 PORT MAP (
		address(7 downto 3)	 => ADDRESS_SIG(7 downto 3),
		address(2 downto 0)  => pixel_row(2 downto 0),
		clock	 => CLOCK_50,
		q	 => q_sig
	);	


HDJK: VGA_SYNC
	PORT MAP(
			clock_video => CLK_25MHz,
			redin => SW(4),
			greenin => SW(3),
			bluein => SW(2),
			red_out => R_OUT_SIG,
			green_out => G_OUT_SIG ,
			blue_out => B_OUT_SIG,
			horiz_sync_out => HOR_SYNC_OUT_SIG,
			vert_sync_out => VER_SYNC_OUT_SIG,
			video_on => VID_ON_SIG,
			pixel_row => pixel_row_SIG,
			pixel_column => pixel_COL_SIG
	
	);
	
shifty: barrel_shifter_Nbit_load
		PORT MAP(
			 i_data_in => q_sig,
			 i_loadbar => SW(0),
			 i_shift_amount => SW(5 downto 3),
			 i_dir => SW(9),
			 o_data_out => 
	);
end architecture;