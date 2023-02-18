--rom_mux_based_constant.vhdl
--
--created 11/5/2021
--
--rev: 0;
--
--inputs: address
--outputs: data
---------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity rommy is
	generic(
		mem_width: positive := 255;
		mem_depth: positive := 16
	);
	port(
			i_addr: in std_logic_vector((integer(ceil(log2(real(mem_depth))))-1) downto 0);
			o_data: out std_logic_vector((mem_width -1) downto 0)
	);
end entity;

architecture behavioral of rommy is

	--rom strucutre
	type rom_type is array (0 to (mem_depth -1)) of std_logic_vector((mem_width - 1) downto 0);
	
	--ROM contents
	constant my_ROM: rom_type :=(
	 
	 0 => "1111110011111111",
	 1 => "1111100111111111",
	 2 => "1111110111111100",
	 3 => "1111111111111000",
	 4 => "1111111111111001",
	 5 => "1111111100000001",
	 6 => "1111111100000010",
	 7 => "1111111100000100",
	 8 => "1111111100000100",
	 9 => "1111111100001000",
	 10 => "1111111100100000",
	 11 => "1111111101000000",
	 
	others =>  "111111111111111"
	
	);
	
begin 
	o_data <= my_ROM(to_integer(unsigned(i_addr)));

end architecture;
