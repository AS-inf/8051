

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity A_B_REGISTER is
    Generic
    (
        constant WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant READ_ADDR : STD_LOGIC_VECTOR (7 downto 0)    -- c->registers  even->READ
    );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0):= x"00";
           TEMP_OUT : out STD_LOGIC_VECTOR (7 downto 0):= x"00";
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end A_B_REGISTER;

architecture Behavioral of A_B_REGISTER is

signal MEMORY : STD_LOGIC_VECTOR (7 downto 0):= x"00";
begin 
    process (CLK)  begin
        if rising_edge(CLK) then
            if INSTR(7 downto 0) = READ_ADDR then
                DATA<= MEMORY;
            else
                DATA <= "ZZZZZZZZ";
            end if;
        end if;
    end process;
    
    process (ACK_CLK)  begin
    if rising_edge(ACK_CLK) then
        if INSTR(15 downto 8) = WRITE_ADDR then
            MEMORY <= DATA;
        end if;
    end if;
end process;
   TEMP_OUT <= MEMORY; 
end Behavioral;
