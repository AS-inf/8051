
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aR_REGISTER_8bit is
    Generic
    (
        constant R_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0) 
    );
    Port 
    ( 
        CLK : in STD_LOGIC;
        ACK_CLK : in STD_LOGIC;
        INSTR : in STD_LOGIC_VECTOR (15 downto 0);
        DATA_IN : in STD_LOGIC_VECTOR (7 downto 0) := x"00";
        DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0):= x"00"
    );

end aR_REGISTER_8bit;

architecture Behavioral of aR_REGISTER_8bit is

signal MEMORY : STD_LOGIC_VECTOR (7 downto 0) := x"00";

begin 

    process(ACK_CLK)    begin
        if rising_edge(ACK_CLK) then
            if INSTR(15 downto 8) = R_WRITE_ADDR then
                MEMORY <= DATA_IN;
            end if;        
        end if;
    end process;
 DATA_OUT <= MEMORY;  
end Behavioral;
