library IEEE;
use ieee.std_logic_1164.all;

entity barrel_shifter_Nbit_load is
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
		
		end entity;
		
architecture behavioral of barrel_shifter_Nbit_load is 

signal data_sig: std_logic_vector( (n-1) downto 0);

Begin
	load: process(i_loadbar)
	begin
		if (falling_edge(i_loadbar)) then
			data_sig <= i_data_in;
		end if;
	end process;
	
	shift: process(data_sig, i_data_in, i_dir, i_shift_amount)
	begin
		if (falling_edge(i_loadbar) AND (i_dir = '0')) then
		--Counterclockwise Rotation
			if (i_shift_amount = "001") then 
				o_data_out <= (data_sig((n-2) downto 0) & data_sig((n-1)));
			elsif (i_shift_amount = "010") then
				o_data_out <= (data_sig((n-3) downto 0) & data_sig((n-1) downto (n-2)));
			elsif (i_shift_amount = "011") then
				o_data_out <= (data_sig((n-4) downto 0) & data_sig((n-1) downto (n-3)));
			elsif (i_shift_amount = "100") then
				o_data_out <= (data_sig(0) & data_sig((n-1) downto 1));
			else
				o_data_out <= data_sig;
			end if;
		--Clockwise Rotation
		elsif (falling_edge(i_loadbar) AND (i_dir = '1')) then
			if (i_shift_amount = "001") then
				o_data_out <= (data_sig(0) & data_sig((n-1) downto 1));
			elsif (i_shift_amount = "010") then 
				o_data_out <= (data_sig(1 downto 0) & data_sig((n-1) downto 2));
			elsif (i_shift_amount = "011") then
				o_data_out <= (data_sig(2 downto 0) & data_sig((n-1) downto 3));
			elsif (i_shift_amount = "100") then
				o_data_out <= (data_sig(6 downto 0) & data_sig((n-1)));
			else
				o_data_out <= data_sig;
			end if;
		end if;
	
end process;

end architecture;
				