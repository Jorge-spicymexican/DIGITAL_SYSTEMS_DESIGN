library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_3hz is
	port(
		i_clk_50MHz: in std_logic;
		i_rstb: in std_logic;
		o_clk_3Hz: out std_logic
	);
end entity;

architecture behavioral of clk_3hz is
	--
	--constants and parameters
	--
	constant CLOCKS_PER_HALF_PERIOD: signed(24 downto 0) := to_signed((((50_000_000/2)/4)-2),25);
	--internal signals
	signal cnt: signed(24 downto 0);
	signal clk_sig: std_logic;
	
begin 
	process(i_clk_50MHz, i_rstb)
		begin
			
		if(i_rstb = '0') then 
			cnt <= CLOCKS_PER_HALF_PERIOD;
			clk_sig <= '0';
		elsif (rising_edge(i_clk_50MHz)) then
			cnt <= cnt - 1;
			
			if(cnt< 0) then 
				cnt <= CLOCKS_PER_HALF_PERIOD;
				clk_sig <= not clk_sig;
			end if;
		end if;
		end process;
		
		o_clk_3Hz <= clk_sig;
		
end behavioral;