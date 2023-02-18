----------------------------------------------------------
--
--NIOS2_IO_DE10_VHDL
--
--CREATED: 10/1/2021
--BY: JORGE JURADO-GARCIA
--REV: 0
--
----------------------------------------------------------   
--
--ADVANCE NIOSE SYSTEM -WITH HEX0-3 WITH SW/PERIPHERALS
--
----------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LAB4_DE10LAB IS
		PORT(
			clock_50 : IN STD_LOGIC;
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0,HEX1,HEX2,HEX3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavioral OF LAB4_DE10LAB is


	component NIOS_2_ADVANCE is
        port (
            clk_clk                                   : in  std_logic                     := 'X';             -- clk
            reset_reset_n                             : in  std_logic                     := 'X';             -- reset_n
            led_pio_external_connection_export        : out std_logic_vector(15 downto 0);                    -- export
            sw_pio_external_connection_export         : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
            seven_seg_pio2_external_connection_export : out std_logic_vector(15 downto 0)                     -- export
        );
    end component NIOS_2_ADVANCE;

	 BEGIN
	 
    u0 : component NIOS_2_ADVANCE
        port map (
            clk_clk                                   => clock_50,                              				     --                                clk.clk
            reset_reset_n                             => '1',                           								  --                              reset.reset_n
            led_pio_external_connection_export(7 downto 0)      => HEX0(7 DOWNTO 0),							        --        led_pio_external_connection.export
            led_pio_external_connection_export(15 downto 8)      => HEX1(7 DOWNTO 0),							        --        led_pio_external_connection.export
				sw_pio_external_connection_export         => SW(7 DOWNTO 0),      										     --         sw_pio_external_connection.export
            seven_seg_pio2_external_connection_export(7 downto 0) => HEX2(7 DOWNTO 0),  								  -- seven_seg_pio2_external_connection.export
				seven_seg_pio2_external_connection_export(15 downto 8) => HEX3(7 DOWNTO 0)  								  -- seven_seg_pio2_external_connection.export
		  );

END ARCHITECTURE; 