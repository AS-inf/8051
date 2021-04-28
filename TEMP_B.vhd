
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity TEMP_REG is
Generic
    (
        constant WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   --
        constant WRITE_REG_ADDR : STD_LOGIC_VECTOR (7 downto 0)    -- c-
    );
    Port ( REG_IN : in STD_LOGIC_VECTOR (7 downto 0):= x"00";
           DATA_IN : in STD_LOGIC_VECTOR (7 downto 0):= x"00";
           ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0):= x"00";
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end TEMP_REG;

architecture Behavioral of TEMP_REG is

signal MEMORY : STD_LOGIC_VECTOR (7 downto 0):=x"00";

begin 
    process(ACK_CLK)    begin
        if rising_edge(ACK_CLK) then        
            if INSTR(15 downto 8)= WRITE_ADDR then
                MEMORY <= DATA_IN;
            elsif INSTR(15 downto 8)= WRITE_REG_ADDR then
               MEMORY <= REG_IN;
            end if;
               
        end if;
    end process;
ALU_OUT <= MEMORY;      
--    process(CLK)    begin
--        if falling_edge(CLK) then        
--            if INSTR(15 downto 8)= WRITE_ADDR then
--                MEMORY <= DATA_IN;
--                --ALU_OUT <= DATA_IN;
--            elsif INSTR(15 downto 8)= WRITE_REG_ADDR then
--                MEMORY <= REG_IN;
--                --ALU_OUT <= REG_IN;
--            else
--                 --ALU_OUT <= MEMORY;     
--            end if;
               
--        end if;
--    end process;
           
end Behavioral;
