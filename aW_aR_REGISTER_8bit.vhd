library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity aW_aR_REGISTER_8bit is
    Generic
    (
        constant WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant READ_ADDR : STD_LOGIC_VECTOR (7 downto 0)    -- c->registers  even->READ
    );
    Port ( DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end aW_aR_REGISTER_8bit;

architecture Behavioral of aW_aR_REGISTER_8bit is

signal MEMORY : STD_LOGIC_VECTOR (7 downto 0);

begin 
    process(CLK)    begin
        if rising_edge(CLK) and CLK = '1'  then
            if INSTR(15 downto 8) = WRITE_ADDR then
                MEMORY <= DATA_IN;
                DATA_OUT <= "ZZZZZZZZ";
            elsif INSTR(7 downto 0) = READ_ADDR then
                DATA_OUT <= MEMORY;
            else 
                DATA_OUT <= "ZZZZZZZZ";
            end if;
        end if;
    end process;
    
end Behavioral;
