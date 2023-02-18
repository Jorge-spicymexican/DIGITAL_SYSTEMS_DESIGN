LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY component_n_bits is 
generic(
	      n: natural := 4
	);
	
PORT(
	c_clk, c_rstb, c_dir, c_key : in std_logic;
	c_input : in std_logic_vector(n-1 downto 0);
	cr_output : out std_logic_vector(n-1 downto 0);
	c_ouput: out std_logic_vector(n-1 downto 0)
	);
end component_n_bits;

-------------------------------------------------------------------------

--architecture
-------------------------------------------------------------------------
Architecture struct of component_n_bits is
	signal s1: std_logic_vector(n-1 downto 0);
	--component declarations
	component ccjorge is 
	generic(
	      n: natural := 4
	);
	
	port ( 
	   i_clk: in std_logic;
		i_rstb: in std_logic;
		i_dir: in std_logic;
		i_input: in std_logic_vector(n-1 downto 0);
		o_cnt: out std_logic_vector(n-1 downto 0)
	);
	
end component;

	component register_n_bits is

   generic (k : positive := 4
	);

   port (
		r_clk: in std_logic;
		r_rstb: in std_logic; -- same as counter (ccjorge)
		r_key: in std_logic;  --input that will decide when the register will hold memory
		r_input: in std_logic_vector(k-1 downto 0); --input value 
		r_output : out std_logic_vector(k-1 downto 0)
   );

end component;
   --end of component declarations
	
	Begin 
	-- instantiate componentsr
	counter: ccjorge port map (i_clk => c_clk, i_rstb => c_rstb , i_dir => c_dir, i_input => c_input, o_cnt =>s1 );
	reg: register_n_bits port map( r_clk => c_clk, r_rstb => c_rstb , r_key => c_key, r_input=> s1, r_output => cr_output);
	
	c_ouput <= s1;
	end struct;