--Initialize all librarys
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity adc0181s021_spi is
      port ( 
        clk   : in std_logic;  --125MHz system clock
        cs_n  : out std_logic; --Active low chip select
        sclk  : out std_logic; --Serial clock (1.25MHz)
        sdata : in std_logic;  --Serial data from chip
        sync  : in std_logic;  --Sync pulse to request new data
        data  : out std_logic_vector(7 downto 0) --Parallel 8 bit data out
      );
end adc0181s021_spi;

architecture Behavioral of adc0181s021_spi is

signal sclk_cnt : unsigned(7 downto 0) := (others => '0');
signal cs_n_sig : std_logic := '1';
signal sclk_sig : std_logic := '1';
signal bit_counter : unsigned(4 downto 0) := (others => '0');
signal data_sig : std_logic_vector(15 downto 0);
signal sclk_rising : std_logic := '0';

begin

--When sync = '1', drive cs_n low for 16 sclk cycles
cs_proc : process(clk)
begin
    if rising_edge(clk) then
        if sync = '1' then
            cs_n_sig <= '0';
        elsif bit_counter = 16 then
            cs_n_sig <= '1';
        end if;
    end if;
end process cs_proc;

--Create sclk as clk div by 100
--Flag when sclk has a rising edge to clock in data
sclk_proc : process(clk)
begin
    if rising_edge(clk) then
        if cs_n_sig = '0' then
            if sclk_cnt = 49 then
                sclk_sig <= not sclk_sig;
                if sclk_sig = '0' then --rising edge detected
                    sclk_rising <= '1';
                else
                    sclk_rising <= '0';
                end if;
                sclk_cnt <= (others => '0');
            else
                sclk_cnt <= sclk_cnt + 1;
                sclk_rising <= '0';
            end if;
        end if;
    end if;
end process sclk_proc;

--Clock in new data bit on the rising edge of sclk
data_proc : process(clk)
begin
    if rising_edge(clk) then
        if cs_n_sig = '1' then
            bit_counter <= (others => '0');
        elsif sclk_rising = '1' then
            data_sig(to_integer(15-bit_counter)) <= sdata;
            bit_counter <= bit_counter + 1;
        end if;
    end if;
end process data_proc;


cs_n <= cs_n_sig;
sclk <= sclk_sig;
data <= data_sig(12 downto 5); --Data starts with 3 leading zeros

end Behavioral;
