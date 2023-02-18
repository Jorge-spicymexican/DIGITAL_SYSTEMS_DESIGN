----------------------------------------------
--Counterjorge.vhdl
--
--created 9/10/21
--Jorge Jurado-Garcia
--rev 0
----------------------------------------------
--
--Inputs: rstb, clk, dir 
--outputs: cnt
--
----------------------------------------------
--
--counts up when dir = 0
--counts down when dir = 1
--
----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counterjorge is 
	generic(
	      n: natural := 8
	);
	
	port ( 
	   i_clk: in std_logic;
		i_rstb: in std_logic;
		i_dir: in std_logic;
		
		o_cnt: out std_logic_vector(n-1 downto 0)
	);
	
end entity;

architecture behavioral of Counterjorge is
 --
 --internal signals
 --
 signal cnt_sig: unsigned(n-1 downto 0);
 
begin 

	process(i_clk, i_rstb)
	begin 
	  --
	  --reset
	  --
	  if(i_rstb = '0') then
		cnt_sig <= (others => '0');
	  --
	  --rising clk edge
	  --
	  elsif(rising_edge(i_clk)) then
	   if(i_dir = '0') then 
			cnt_sig <= cnt_sig + 1;
		else 
			cnt_sig <= cnt_sig - 1;
		end if;
		end if;
	end process;
	
 --
 --Output logic
 --
 
 o_cnt <= std_logic_vector(cnt_sig);

end behavioral;