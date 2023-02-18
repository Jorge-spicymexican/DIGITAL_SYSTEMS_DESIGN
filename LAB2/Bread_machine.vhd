--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--LAB 2 FINITE STATE MACHINE LOGIC DESIGN
--FOR BREAD MAKER
--DATE: 9/14/2021
--AUTHOR: JORGE JURADO-GARCIA
--REV 2
		--included output logic of fsm 9/15/21
		--created  RESET state and fixed output logic in MIX state 9/16/21
		--fixed project setup and redid logic for mix state 9/17/21 
		--DE10lite qsf implemented.
--
--INPUTS: BREAD TYPE: REGULAR OR DOUGH 
--			 START, RESET(RSTB)
--
--OUTPUTS: HEATER(1), HEATER(2), BEATER, BEEPER.
--PROCESS:
--1.Mix – HEATER[1] & HEATER [2] off, BEATER ON for (2) seconds, off (3) seconds (3x)
--2.Knead – BEATER ON for (10) seconds
--3.Rise1 – BEATER OFF, HEATER[1] for (10) seconds
--4.Beat down – HEATER[1] OFF, BEATER ON For (2) seconds
--5.Rise2 - BEATER OFF, HEATER[1] for (12) seconds
--6.Bake – HEATER[1] and HEATER[2] ON for (7) seconds
--7.Done – HEATER[1] AND HEATER[2] OFF, BEATER OFF, BEEPER ON for (5) seconds,
--         then light the Done LED until either a reset or the start of another cycle.
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Bread_machine is 
	port(
			clk,start,rstb, dough,regular: IN std_logic;
			count: OUT std_logic_vector(3 downto 0);
			heater1, heater2, beater, beeper, finished : OUT std_logic
		 );
end entity Bread_machine;

Architecture behavioral of Bread_machine is 
	-----name of the states that fsm will be in
   TYPE state_type is (Reset, Starting, Mix, Knead, Rise1, Beat_down, Rise2, Bake, Done); 
	---signals for names of transitions between states
	SIGNAL current, next_state : state_type;
	--singals for counter 
	SIGNAL cnt: unsigned(3 downto 0);
	SIGNAL start_cnt: std_logic;
	--constant values for timers and etc
	CONSTANT time_2: unsigned(3 downto 0) := to_unsigned(2,4);
	CONSTANT time_3: unsigned(3 downto 0) := to_unsigned(3,4);
	CONSTANT time_5: unsigned(3 downto 0) := to_unsigned(5,4);
	CONSTANT time_6: unsigned(3 downto 0) := to_unsigned(6,4);
	CONSTANT time_7: unsigned(3 downto 0) := to_unsigned(7,4);
	CONSTANT time_10: unsigned(3 downto 0) := to_unsigned(10,4);
	CONSTANT time_12: unsigned(3 downto 0) := to_unsigned(12,4);
	CONSTANT time_15: unsigned(3 downto 0) := to_unsigned(15,4);

BEGIN 
	count <= std_logic_vector(cnt);
	
	--logic for rstb and rising clock edge 
	PROCESS(clk, rstb)
	BEGIN
				IF(rstb = '0') THEN
					current <= Reset;
				ELSIF(rising_edge(clk)) THEN
					current <= next_state;
				END IF;
		END PROCESS;
		
--logic for timer and counter
	 counterr: PROCESS(clk, start_cnt) 
	 BEGIN 
				IF(rising_edge(clk)) THEN
					IF(start_cnt = '0') THEN
							cnt <= (OTHERS => '0');
				ELSE cnt <= cnt + 1;
				END IF;
			END IF;
		END PROCESS counterr;	
			
--combinationals next state logic

PROCESS(current, cnt, rstb, start)
	BEGIN 
			CASE current is 
				WHEN Reset =>
					start_cnt <= '1'; --keep timer going
					beater <= '0'; 
					beeper <= '0';
					finished <= '0'; 
					IF((rstb = '1') and (start = '1')) THEN
						next_state <= Starting;
						start_cnt <= '0';
					ELSE 
						next_state <= Reset;
						start_cnt <= '0';
					END IF;
					
				WHEN Starting =>
					start_cnt <= '1';
					beater <= '0';
					beeper <= '0';
					finished <= '0'; 
					IF( (dough = '1') and (start = '1') and (regular = '0') ) THEN
							next_state <= Mix;
							start_cnt <= '0'; --starting fresh
					ELSIF( (regular = '1') and (start = '1') and (dough = '0') ) THEN
							next_state <= Mix;
							start_cnt <= '0'; --starting fresh
					ELSE 
							next_state <= Reset;
							start_cnt <= '0'; --starting fresh
					END IF;
					
				WHEN Mix =>
						start_cnt <= '1'; --keeps timer at one 
						finished <= '0';
						beeper <= '0';
						IF(cnt < time_3) THEN
							beater <= '1';
						ELSIF((cnt >= time_3) and (cnt <= time_5)) THEN
							beater <= '0';
						ELSIF( (cnt > time_5) and (cnt <= time_7) ) THEN
							beater <= '1';
						ELSIF((cnt > time_7) and (cnt <= time_10)) THEN
							beater <= '0';
						ELSIF( (cnt > time_10) and (cnt <= time_12)) THEN
							beater <= '1';
						ELSIF((cnt > time_12) and (cnt < time_15)) THEN
							beater <= '0';
						ELSE 
							beater <= '0';
							next_state <= Knead;
							start_cnt <= '0';
					END IF;
					
				WHEN Knead =>
					start_cnt <= '1'; --keeps timer at one
					finished <= '0'; 
					beeper <= '0';	
					beater <= '0';
					IF(cnt <= time_10) THEN
						beater <= '1'; 
					ELSIF( (dough = '1') and (regular = '0') ) THEN
						beater <= '0';
						next_state <= Done;
						start_cnt <= '0';
					ELSIF( (dough = '0') and (regular = '1') ) THEN
						beater <= '0';
						next_state <= Rise1;
						start_cnt <= '0'; --starting fresh
					ELSE
						beater <= '0';
						next_state <= Reset;
						start_cnt <= '0'; --starting fresh
					END IF;
					
				WHEN Rise1 => 
					 start_cnt <= '1'; --keeps timer at one
					 finished <= '0'; 
					 beater <= '0';
					 beeper <= '0';
					IF(cnt <= time_10) THEN
					--	heater1 <= '1'; 
					ELSE 
						next_state <= Beat_down;
						start_cnt <= '0'; --starting fresh
					END IF; 
					
				WHEN Beat_down =>
						start_cnt <= '1'; --keeps timer at one
						finished <= '0'; 
						beater <= '0';
						beeper <= '0';
					--	heater1 <= '0';
					IF(cnt <= time_2) THEN
						beater <= '1'; 
					ELSE 
						beater <= '0'; 
						next_state <= Rise2;
						start_cnt <= '0'; --starting fresh
					END IF;
					
				WHEN Rise2 =>
						start_cnt <= '1'; --keeps timer at one
						beeper <= '0';
						finished <= '0'; 
						beater <= '0';
						IF(cnt <= time_12) THEN
					--	heater1 <= '1'; 
					ELSE 
						next_state <= Bake;
						start_cnt <= '0'; --starting fresh
					END IF;
					
				WHEN Bake =>
						start_cnt <= '1'; --keeps timer at one
						finished <= '0'; 
						beeper <= '0';
						beater <= '0';  
						IF(cnt <= time_7) THEN
					--	heater1 <= '1'; 
					--	heater2 <= '1'; 
					ELSE 
						next_state <= Done;
						start_cnt <= '0'; --starting fre
					END IF;
					
				WHEN Done =>
					start_cnt <= '1';
					--heater1 <= '0'; 
					--heater2 <= '0';
					 beater <= '0'; 
					 finished <= '1';
					 beeper <= '1';
					IF(cnt <= time_5) THEN
						finished <= '1';
						beeper <= '1';
					ELSE 
						finished <= '0';
						beeper <= '0';
						next_state <= Reset;
						start_cnt <= '0'; --starting fresh
					END IF;
		END CASE;
END PROCESS;
--output logic
heater1 <= '1' WHEN ((current = Rise1) OR (current = Rise2) OR (current = Bake)) ELSE '0';
heater2 <= '1' WHEN (current = Bake) ELSE '0';

END behavioral;

