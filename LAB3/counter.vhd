----------------------------------------------
--counter.vhdl
--
--created 9/21/21
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
use ieee.std_logic_unsigned.all;

-----------------------------------------------------------------------------
---ENtity 
-------------------------------------------------------------------------------
--created a 8 bit generic counter with clk, rstb, and direction as inputs with a 4 bit output
entity counter is 
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
	
end entity;

-------------------------------------------------------------------------

--architecture
-------------------------------------------------------------------------

architecture behavioral of counter is
 --
 --internal signals, signals are unsigned in order to start from 0 to 2^(n-1)
 --
 signal cnt_sig: unsigned(n-1 downto 0); 
 signal rcnt_sig: unsigned(n-1 downto 0);
 signal state: unsigned(n-1 downto 0);
 
begin 

	process(i_clk, i_rstb, i_key) --sequential processing
	begin 
	  --
	  --reset
	  --
	  	--when rstb is 0 signal is 0
	  if(i_rstb = '0') then      
		cnt_sig  <= (others => '0'); --make sure all signals are zero when rstb is zzero
		rcnt_sig <= (others => '0');	
		state <= (others => '0');
	  --rising clk edge	
	  elsif(rising_edge(i_clk)) then
	   if(i_key = '0' ) then --button logic 
				cnt_sig <= cnt_sig;
				state <= rcnt_sig;  --when state rcnt_sig
		end if; --end of if statement for i-rstb
		if( (i_dir = '0') and (i_key = '1') )then 
			cnt_sig <= cnt_sig + 1; --adding one
			if(cnt_sig = "11111111") then --0x	11001
			cnt_sig <= "00000000";
			end if;--end if of wrapping up
		end if; --end of if statement for i-rstb
		end if;
		
	end process;
	
 --
 --Output logic
 --
 
 o_cnt <= std_logic_vector(cnt_sig);
 r_cnt <= std_logic_vector(state);

end behavioral; --end of counter architerial
