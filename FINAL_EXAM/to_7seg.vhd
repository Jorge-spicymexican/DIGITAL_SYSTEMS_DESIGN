----------------------------------------------
--
-- to_7seg.vhdl
--
--created 9/11/21
--jorge jurado-garcia
--
--rev 0
------------------------------
--
-- takes a for bit bit value and then translates into a seven segment display
--
--------------------------------------------
--
--Inputs: input
--Outputs: seg7
--
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity to_7seg is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (7 downto 0)
             );
end to_7seg;

architecture Behavioral of to_7seg is

begin

--'input' corresponds to MSB of seg7 and 'g' corresponds to LSB of seg7.
-- when a  bit is low the led on the seg7 will be on else '0'
process (input)
BEGIN
    case input is
        when "0000"=> seg7 <="11000000";  -- '0'
        when "0001"=> seg7 <="11111001";  -- '1'
        when "0010"=> seg7 <="10100100";  -- '2'
        when "0011"=> seg7 <="10110000";  -- '3'
        when "0100"=> seg7 <="10011001";  -- '4' 
        when "0101"=> seg7 <="10010010";  -- '5'
        when "0110"=> seg7 <="10000010";  -- '6'
        when "0111"=> seg7 <="11111000";  -- '7'
        when "1000"=> seg7 <="10000000";  -- '8'
        when "1001"=> seg7 <="10011000";  -- '9'
        when "1010"=> seg7 <="10001000";  -- 'A'
        when "1011"=> seg7 <="10000000";  -- 'b'
        when "1100"=> seg7 <="11000110";  -- 'C'
		  when "1101"=> seg7 <="10000000";  -- 'D'
		  when "1110"=> seg7 <="10000110";  -- 'E'
		  when "1111"=> seg7 <="10001110";  -- 'F'
        when others =>  NULL;
    end case;
	 
end process;

end Behavioral;