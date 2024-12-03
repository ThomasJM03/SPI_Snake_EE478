--////////////////////////////////////////////////////////////////////////////////
-- Company:  University at Buffalo
-- Engineer: Thomas Mehok
-- 
-- Create Date:    11/26/2024
-- Module Name:    ClkDiv_5Hz
-- Project Name:   SPI_Snake_EE478Final
-- Target Devices: ZYBO-Z7
-- Tool versions:  ISE 14.1
-- Description: Converts input 125MHz clock signal to a 5Hz clock signal.
--
-- Revision History: 
-- 						Revision 0.01 - File Created (Josh Sackos)
--////////////////////////////////////////////////////////////////////////////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ====================================================================================
-- 										  Define Module
-- ====================================================================================
entity ClkDiv_5Hz is
    Port ( 
		   CLK : in  STD_LOGIC;				-- 125MHz onboard clock
           RST : in  STD_LOGIC;				-- Reset
           CLKOUT : inout  STD_LOGIC);		-- New clock output
end ClkDiv_5Hz;

architecture Behavioral of ClkDiv_5Hz is

-- ====================================================================================
-- 							       Signals and Constants
-- ====================================================================================

			-- Current count value
			signal clkCount : STD_LOGIC_VECTOR(27 downto 0) := (others => '0');

			-- Value to toggle output clock at
			-- 25 M in hex
			constant cntEndVal : STD_LOGIC_VECTOR(27 downto 0) := X"17D7840";

--  ===================================================================================
-- 							  				Implementation
--  ===================================================================================
begin

			-------------------------------------------------
			--	5Hz Clock Divider Generates Send/Receive signal
			-------------------------------------------------
			FIVEhzGenerator : process(CLK) begin

					-- Reset clock
					if(RST = '1')  then
							CLKOUT <= '0';
							clkCount <= (others => '0');
					elsif rising_edge(CLK) then
							if(clkCount = cntEndVal) then
									CLKOUT <= NOT CLKOUT;
									clkCount <= (others => '0');
							else
									clkCount <= clkCount + '1';
							end if;
					end if;

			end process;

end Behavioral;

