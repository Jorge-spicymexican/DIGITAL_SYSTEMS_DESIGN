----------------------------------------------
--ccjorge.vhdl
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
use ieee.std_logic_unsigned.all;

-----------------------------------------------------------------------------
---ENtity 
-------------------------------------------------------------------------------
--created a 8 bit generic counter with clk, rstb, and direction as inputs with a 4 bit output
entity ccjorge is 
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

architecture behavioral of ccjorge is
 --
 --internal signals, signals are unsigned in order to start from 0 to 2^(n-1)
 --
 signal cnt_sig: unsigned(n-1 downto 0); 
 signal rcnt_sig: unsigned(n-1 downto 0);
 signal state: unsigned(n-1 downto 0);
 
begin 

	process(i_clk, i_rstb) --sequential processing
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
	   if(i_dir = '0') then 
			cnt_sig <= cnt_sig + 1; --adding one
			if(cnt_sig = "11111111") then --0xFF
			cnt_sig <= "00000000";
			end if;--end if of wrapping up
		else 
			cnt_sig <= cnt_sig - 1; --subtracting one 
			if(cnt_sig = "00000000") then
			cnt_sig <= "11111111";
			end if; --end if of wrapping down
		end if; --end of if statement for i_dir
		--	
		end if; --end of if statement for i-rstb
		if(i_key = '1' ) then --button logic 
				state <= rcnt_sig;  --when state rcnt_sig
		else
				rcnt_sig <= cnt_sig; --will start at zero but rcnt_sig wil constantly 
				--change then when button is not pressed.
				state <= (others => '0'); --state will be shown as zero on LEDR 
		end if; --end of if statement for i-rstb
		
	end process;
	
 --
 --Output logic
 --
 
 o_cnt <= std_logic_vector(cnt_sig);
 r_cnt <= std_logic_vector(state);

end behavioral; --end of counter architerial
