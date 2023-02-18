library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter_5bit_load_tb is

end entity;

architecture testbench of barrel_shifter_5bit_load_tb is 

		signal DATA: std_logic_vector( 7 downto 0);
		signal LOAD : std_logic;
		signal SHIFT: std_logic_vector(2 downto 0);
		signal DIR:    std_logic;
		signal OUT_D:  std_logic_vector(7 downto 0);
		
	component barrel_shifter_Nbit_load is
		port(
		i_data_in:  in std_logic_vector(7 downto 0);
		i_loadbar :   in std_logic;
		i_shift_amount: in std_logic_vector(2 downto 0);
		i_dir:       in std_logic;
		o_data_out:  out std_logic_vector(7 downto 0)
		);
	end component;
	
	Begin 
	
	DUT: barrel_shifter_Nbit_load
		port map(
				i_data_in => DATA,
				i_loadbar => LOAD,
				i_shift_amount => SHIFT,
				i_dir => DIR,
				o_data_out => OUT_D
				);
		
		direction: process
		begin
			DIR <= '0';
			wait for 50 ns;
			DIR <= '1';
			wait for 50 ns;
		end process;
		
		shifter: process
		begin
		infinite: loop
			SHIFT <= "001";
			wait for 15 ns;
			SHIFT <= "010";
			wait for 15 ns;
			SHIFT <= "100";
			wait for 15 ns;
		end loop;
		end process;
		
		loading: process
		begin
			LOAD <= '0';
			wait for 5 ns;
			infinite: loop
			LOAD <= not LOAD;
			wait for 5 ns;
			end loop;
		end process;
		
		datas: process
		begin
		  infinite: loop
			DATA <= "00000111";
			wait for 20 ns;
			DATA <= "00000001";
			wait for 20ns;
			end loop;
		end process;
		
end architecture;
		
		
			
		
		
		