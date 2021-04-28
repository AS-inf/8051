

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INCR_REG is
    GENERIC
        (
            CONSTANT READ_INSTR : STD_LOGIC_VECTOR(7 DOWNTO 0)
            
        );
    Port ( DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end INCR_REG;

architecture Behavioral of INCR_REG is
signal MEMORY : STD_LOGIC_VECTOR (7 downto 0);
signal step : STD_LOGIC_VECTOR (7 downto 0):= x"01";

begin 

    process(CLK)    begin
        
        if rising_edge(CLK) then 
         if INSTR(7 downto 0) = READ_INSTR then
                DATA_OUT <= MEMORY;
          else
                DATA_OUT <= "ZZZZZZZZ";
                MEMORY <= STD_LOGIC_VECTOR(unsigned(DATA_IN) + unsigned(step));
            end if;
        end if;
        
    end process;
    
    
end Behavioral;
