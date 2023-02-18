----------------------------------------------
--
--Timer_n_sec.vhdl
--
--created 9/11/21
--jorge jurado-garcia
--
--rev 0
------------------------------
--
-- Timer_n_sec for 1 seconds using a clock cycles
--
--assummes a 50 MHZ external clock 
--
--------------------------------------------
--
--Inputs: rstb, clock_50MHZ
--Outputs: clk_out
--
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Timer_n_sec is
	generic(
	      k: natural := 1
	);
	port( 
			i_clk_50MHZ: in std_logic;
			i_rstb: in std_logic;
			
			o_clk_nHz: out std_logic 
	);
end entity;

architecture behavioral of Timer_n_sec is
	--internal signals
	--
	SIGNAL nextstate, Qint: INTEGER RANGE 0 TO (5000000):= 0;
	SIGNAL en, clk, num1, nextnum1 : STD_LOGIC;
	
begin 
		o_clk_nHz <= num1;
		clk <= i_clk_50MHZ;
		
		-- generate clock enable - active for one CLOCK_50 pulse every 100 ms
		en <= '1' WHEN Qint = (4999999) ELSE
			'0';
		nextstate <= Qint + 1 WHEN Qint < (4999999) ELSE
			0;
		process(clk)
			begin
			--
			if(rising_edge(clk) ) then
				Qint <= nextstate;
				end if;
			end process;
			--end of gneratate clock enabled
			
			nextnum1 <= num1 WHEN en = '0'
			else
			not num1;
			
		process (clk)
		BEGIN
			IF (rising_edge(clk)) THEN -- rising clock edge
			num1 <= nextnum1;
			END IF;
			
		END PROCESS;
			
		--output logic 

end behavioral;					