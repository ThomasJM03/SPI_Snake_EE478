--/////////////////////////////////////////////////////////////////////////////////////////
-- Company: University at Buffalo
-- Engineer: Thomas Mehok
-- 
-- Create Date:    11/26/2024
-- Module Name:    SPI_Snake_EE478Final
-- Project Name:   SPI_Snake_EE478Final 
-- Target Devices: ZYBO Z7
-- Tool Version:   Vivado 2024.1
-- Description:
--                 This module will take in axis data from the ADXL 345 chip into the ZYBO Z7 board in 
--                  order to get game inputs for the final project of EE 478. This module will take the data from the three different axes and find the greatest of the 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- ====================================================================================
-- 										  Define Module
-- ====================================================================================

entity DDmodule is
    Port (
            CLK : 		in STD_LOGIC;
            DDirection: out STD_LOGIC_VECTOR(3 downto 0); -- (up, down, left, right)
            xAxis : 	in STD_LOGIC_VECTOR(9 downto 0);
            yAxis :		in STD_LOGIC_VECTOR(9 downto 0);
            zAxis : 	in STD_LOGIC_VECTOR(9 downto 0)
    );
end DDmodule;

architecture Behavioral of DDmodule is

-- ====================================================================================
-- 							       Signals and Constants
-- ====================================================================================

        signal XaxisSIG : STD_LOGIC; --If X is negative or positive
        signal YaxisSIG : STD_LOGIC; --If X is negative or positive
        signal ZaxisSIG : STD_LOGIC; --If X is negative or positive

        --The absolute values of all the AXES
        signal xAxisABS : STD_LOGIC_VECTOR(8 downto 0);
        signal yAxisABS : STD_LOGIC_VECTOR(8 downto 0); 
        signal zAxisABS : STD_LOGIC_VECTOR(8 downto 0);

        signal SIG_CheckDone       : STD_LOGIC := '0'; --Signal to set in order to not let the SIG check get overwritten by the changing values of the Axes input

        signal DeBounceChecker     : STD_LOGIC_VECTOR(3 downto 0); --This signal is to keep track of the output of our Current dominant axis

        --This signal will be dedicated to the output of the XY Mux
        signal XorY                : STD_LOGIC := '0';

        -- Sig, X, Y, Z
        signal PastDominant        : STD_LOGIC_VECTOR(3 downto 0); --A way to keep track of the past signal 
        signal CurrentDominant     : STD_LOGIC_VECTOR(3 downto 0); --The output of the mux 
        

--  ===================================================================================
-- 							  				Implementation
--  ===================================================================================

    begin

        --First process that will update internal signals
        --This is a sequential process
        InternalUpdate : process(CLK) begin 
            if rising_edge(CLK) then
                --If sig check is not done make sure to do that
                if(SIG_CheckDone = '0') then
                    --Getting the signifier bit
                    XaxisSIG <= xAxis(9);
                    YaxisSIG <= YAxis(9);
                    ZaxisSIG <= ZAxis(9);

                    --Getting the ABS value for the axis
                    --THIS IS SOMETHING WE NEED TO CONFIRM, WE GOT THIS IDEA FROM THE SEL FILE
                    xAxisABS <= xAxis(8 downto 0);
                    yAxisABS <= yAxis(8 downto 0);
                    zAxisABS <= zAxis(8 downto 0);

                    --Check the Debounce Counter and adjust the output value as nessasary 
                    if (DeBounceChecker = "1111") then
                        DDirection <= CurrentDominant;
--                    else 
--                        DDirection <= "1111";
                    end if ;

                    --Make sure to flip the SIG bit so the other process runs on the next clock cycle
                    SIG_CheckDone <= '1';
               else 
                    --Make sure to flip the SIG bit so the other process runs on the next clock cycle
                    SIG_CheckDone <= '0';

                end if;
            end if;

        end process;


        --Second process that will check for the axis with the greatest acceleration
        --This is a sequential process
        Dominant_Calc : process(CLK) begin 
            if rising_edge(CLK) then


                --If sig check is done do calculation for new dominant axis
                if(SIG_CheckDone = '1') then

                    -- THIS WAS THE FIRST ATTEMPT AT THE LOGIC FOR THE LIGHTS
                    --===================================================================================
                    --Plan, Check two Axes, then Z will be based off 
                    -- 0 is X, 1 is Y
                    -- if(xAxisABS > yAxisABS) then 
                    --     XorY <= '0'
                    -- else 
                    --     XorY <= '1'
                    -- end if;
                    -- -- XorY <= '0' when xAxisABS > yAxisABS
                    -- --    else '1';
                    
                    -- if(XorY = '0') then

                    --     if(xAxisABS > zAxisABS and XaxisSIG /= '1')

                    --     CurrentDominant <= "0100" when xAxisABS > zAxisABS and XaxisSIG /= '1'
                    --     else               "1100" when xAxisABS > zAxisABS and XaxisSIG = '1'
                    --     else               "0001" when xAxisABS < zAxisABS and ZaxisSIG /= '1'
                    --     else               "1001" when xAxisABS < zAxisABS and ZaxisSIG = '1';

                    
                    -- else

                    --     CurrentDominant <= "0010" when yAxisABS > zAxisABS and XaxisSIG /= '1'
                    --     else               "1010" when yAxisABS > zAxisABS and XaxisSIG = '1'
                    --     else               "0001" when yAxisABS < zAxisABS and ZaxisSIG /= '1'
                    --     else               "1001" when yAxisABS < zAxisABS and ZaxisSIG = '1'; 

                    -- end if; 
                    --===================================================================================

                    --This is the second implementation of the logics for the LED's  
                    if xAxisABS > yAxisABS then -- X > Y
                        if xAxisABS > zAxisABS and XaxisSIG /= '1' then -- DOM = X
                            CurrentDominant <= "0100";

                        elsif xAxisABS > zAxisABS and XaxisSIG = '1' then -- DOM = -X
                            CurrentDominant <= "1100";

                        elsif xAxisABS < zAxisABS and ZaxisSIG /= '1' then -- DOM = Z
                            CurrentDominant <= "0001";

                        elsif xAxisABS < zAxisABS and ZaxisSIG = '1' then -- DOM = -Z
                            CurrentDominant <= "1001";
                        end if;

                    else -- Y > X
                         if yAxisABS > zAxisABS and YaxisSIG /= '1' then -- DOM = Y
                            CurrentDominant <= "0010";

                        elsif yAxisABS > zAxisABS and YaxisSIG = '1' then -- DOM = -Y
                            CurrentDominant <= "1010";

                        elsif yAxisABS < zAxisABS and ZaxisSIG /= '1' then -- DOM = Z
                            CurrentDominant <= "0001";

                        elsif yAxisABS < zAxisABS and ZaxisSIG = '1' then -- DOM = -Z
                            CurrentDominant <= "1001";
                        end if;
                    end if;
                     

                    --Now we want to also increment the debouncing counter
                    if(PastDominant = CurrentDominant) then

                        DeBounceChecker <= DeBounceChecker(2 downto 0) & '1';

                    else

                        DeBounceChecker <= (others => '0');

                    end if;

                else 
                    --When we are on the off clock signal it will update the PastDominant properly 
                    PastDominant <= CurrentDominant;

                end if; 
                
            end if;


        end process;

    end Behavioral;
