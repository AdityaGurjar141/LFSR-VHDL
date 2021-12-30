
-- Create Date: 10/24/2021 04:05:39 PM


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR is
    Port ( clk : in STD_LOGIC;
           rstn : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           get_random, load_seed : in STD_LOGIC);
           
end LFSR;

architecture Behavioral of LFSR is
signal A: STD_LOGIC_VECTOR (31 downto 0);
signal Atemp: STD_LOGIC_VECTOR (31 downto 0);
signal res: STD_LOGIC;
signal sender, loader: STD_LOGIC:='0';
signal i_cnt, i_cnt2: STD_LOGIC_VECTOR(1 downto 0):="00";
--signal ctrl: STD_LOGIC_VECTOR(3 downto 0);

begin

res<=A(31) xor A(27) xor A(19) xor A(17) xor A(11) xor A(7);
-- The numbers bits fed into res are derived from the student N number. My N number modulo 32 are 07, 11, 17, 19, 27, 31



Atemp<= A(30 downto 0) & res;
--Shifts and concats the xor result to MSB(0)

process(clk, rstn, sender, loader)
begin
if (rstn='0') then
A<=X"02468ACD";
elsif (sender='0' and loader='0') then
if (clk'event and clk='1') then
A<=Atemp;
end if;
elsif (sender='0' and loader='1') then
--sequential A load
case i_cnt2 is
when "00"=>A(31 downto 24)<=data_in;
when "01"=>A(23 downto 16)<=data_in;
when "10"=>A(15 downto 8)<=data_in;
when "11"=>A(7 downto 0)<=data_in;
when others => null;
end case;
end if;
end process;
--Above process resets if active.  Or puts the shifted value in main 32 bit register


counter1:process(clk,sender, get_random)
begin
if(get_random='1' and rstn ='1' and loader='0') then
sender<='1';
end if;
if (clk'EVENT AND clk='1' and sender='1') then 
if(i_cnt="11") then
sender<='0';
i_cnt<="00";
else
i_cnt<=std_logic_vector(unsigned(i_cnt)+"1");
end if;
end if;
end process;
--Above process counts to 0,1,2,3 to wait for 4 clock cycles for transmission of 32 bit register value through the 8 bit output


counter2:process(clk,loader, load_seed)
begin
if(load_seed='1' and rstn ='1' and sender='0') then
loader<='1';
end if;
if (clk'EVENT AND clk='1' and loader='1') then 
if(i_cnt2="11") then
loader<='0';
i_cnt2<="00";
else
i_cnt2<=std_logic_vector(unsigned(i_cnt2)+"1");
end if;
end if;
end process;


with i_cnt & sender select data_out<=
A(31 downto 24) when "001",
A(23 downto 16) when "011",
A(15 downto 8) when "101",
A(7 downto 0) when "111",
"00000000" when others;
--Output assignment


--concurrent A load
end Behavioral;
