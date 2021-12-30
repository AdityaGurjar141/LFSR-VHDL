
-- Create Date: 10/27/2021 02:23:38 AM
-- Design Name: 
-- Module Name: LFSR_TB - Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR_TB is
--  Port ( );
end LFSR_TB;

architecture Behavioral of LFSR_TB is

component LF2 is
    Port ( clk : in STD_LOGIC;
           rstn : in STD_LOGIC;
           load_seed : in STD_LOGIC;
           data_in: in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           get_random : in STD_LOGIC);
end component;

component LFSR is
    Port ( clk : in STD_LOGIC;
           rstn : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           get_random, load_seed : in STD_LOGIC);
           
end component;


signal clk_tb, rstn_tb, load_seed_tb,get_random_tb: STD_LOGIC;
signal data_in_tb, data_out_tb: STD_LOGIC_VECTOR(7 downto 0);

signal seed: STD_LOGIC_VECTOR(31 downto 0);
signal counter:STD_LOGIC_VECTOR(1 downto 0):="00";
signal LS:STD_LOGIC:='0';


begin
--T1: LF2 port map(clk=>clk_tb, rstn=>rstn_tb, load_seed=>load_seed_tb, data_in=>data_in_tb, data_out=>data_out_tb, get_random=>get_random_tb);
T2: LFSR port map(clk=>clk_tb, rstn=>rstn_tb, load_seed=>load_seed_tb, data_in=>data_in_tb, data_out=>data_out_tb, get_random=>get_random_tb);

seed<=X"DEADBEEF";



clock_process :process
begin
     clk_tb <= '1';
     wait for 5 ns;
     clk_tb <= '0';
     wait for 5 ns;
end process;


--reset:process begin
--rstn_tb<='0';
--wait for 15 ns;
--rstn_tb<='1';
--wait for 160 ns;
--end process;


in_out:process begin
rstn_tb<='0';
wait for 10 ns;
rstn_tb<='1';
load_seed_tb<='0';
get_random_tb<='0';
wait for 50ns;

get_random_tb<='1';
wait for 20 ns; 
get_random_tb<='0';
wait for 60 ns;

load_seed_tb<='1';
wait for 20 ns; 
load_seed_tb<='0';
wait for 80 ns;

get_random_tb<='1';
wait for 20 ns; 
get_random_tb<='0';
wait for 60 ns;
rstn_tb<='0';


end process;


counter2:process(clk_tb, load_seed_tb)
begin
if(load_seed_tb='1' and rstn_tb ='1') then
LS<='1';
end if;
if (clk_tb'EVENT AND clk_tb='1' and LS='1') then 
if(counter="11") then
LS<='0';
counter<="00";
else
counter<=std_logic_vector(unsigned(counter)+"1");
end if;
end if;
end process;

with counter & LS select data_in_tb<=
seed(31 downto 24) when "001",
seed(23 downto 16) when "011",
seed(15 downto 8) when "101",
seed(7 downto 0) when "111",
"00000000" when others;

end Behavioral;
