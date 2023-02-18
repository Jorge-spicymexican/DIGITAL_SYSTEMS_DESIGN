-- countN_en3.vhd
-- Counter
-- K. Widder
-- 11/05/21

-- Count up/down based on input sel: 0 = down, 1 = up
-- Max count determined by Generic parameter, N (255 max)
-- Time between counts determined by Generic parameter, M (in ____)
-- count enable based on input counten: 0 = disable, 1 = enable

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY countN_en3 IS
	GENERIC (N : integer:=255;
				M : integer:= 1);
	PORT ( clk, sel, counten: IN STD_LOGIC;
			outval: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END countN_en3;

ARCHITECTURE behav OF countN_en3 IS

	SIGNAL Qint, nextstate: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL intcnt: integer;
	SIGNAL cntenable: STD_LOGIC:='0';
	SIGNAL nexttic, currtic: integer RANGE 0 TO 4170000:=0;
	SIGNAL numpasses: integer RANGE 0 TO 31:=M-1;
	
BEGIN

	-- timed enable ----------------
	cntenable <= '1' WHEN currtic = 4169999 ELSE '0';
	nexttic <= currtic + 1 WHEN currtic < 4169999 ELSE 0;
	outval <= Qint;
	
	PROCESS (clk)
	BEGIN
	IF (rising_edge(clk)) THEN
		If(cntenable = '1') THEN
			IF(numpasses > 0) THEN
				numpasses <= numpasses - 1;
			ELSE
				numpasses <= M - 1;
			END IF;
		END IF;
		END IF;
	END PROCESS;
	
	-- counter implementation ----------------
	PROCESS (sel, Qint, cntenable, numpasses)   
	BEGIN
			IF(sel = '1') THEN
				IF (Qint < N) THEN
					nextstate <= Qint + 1;
				ELSE
					nextstate <= std_logic_vector(to_unsigned(0, nextstate'length));
				END IF;
			ELSE
				IF (Qint > 0) THEN
					nextstate <= Qint - 1;
				ELSE
					nextstate <= std_logic_vector(to_unsigned(N, nextstate'length));
				END IF;
			END IF;
		
	END PROCESS;
	
	PROCESS (clk)   
	BEGIN
		IF (rising_edge(clk)) THEN
			IF(cntenable = '1' AND numpasses = 0) THEN
				Qint <= nextstate;
			END IF;
			IF(counten = '1') THEN
				currtic <= nexttic;
			END IF;
		END IF;
	END PROCESS;
	-- end: counter implementation ----------------
END behav;
