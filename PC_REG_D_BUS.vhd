
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_REG_D_BUS is
    generic(
        constant data_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant data_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant pc_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant pc_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant pc_READ_INCR_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant INCR_PC : STD_LOGIC_VECTOR (7 downto 0)    -- c->registers  even->READ

        );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0);         
           PC_DATA : inout STD_LOGIC_VECTOR (7 downto 0);    
           TEMP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end PC_REG_D_BUS;

architecture Behavioral of PC_REG_D_BUS is

signal MEMORY : STD_LOGIC_VECTOR (7 downto 0):= "ZZZZZZZZ";
signal INCREMENTED : STD_LOGIC_VECTOR (7 downto 0); 

begin 

    process(CLK)
    
    variable step : STD_LOGIC_VECTOR (7 downto 0):= x"01";
    begin
        if rising_edge(CLK) then

            if INSTR(15 downto 8) = data_WRITE_ADDR then
                MEMORY <= DATA;
                TEMP_OUT <= MEMORY;
                INCREMENTED <= STD_LOGIC_VECTOR(unsigned(DATA) + unsigned(step));
            elsif INSTR(7 downto 0) = data_READ_ADDR then
                DATA <= MEMORY;
                TEMP_OUT <= MEMORY; 
            elsif INSTR(15 downto 8) = pc_WRITE_ADDR then
                MEMORY <= PC_DATA;
                INCREMENTED <= STD_LOGIC_VECTOR(unsigned(PC_DATA) + unsigned(step));
            elsif INSTR(7 downto 0) = pc_READ_ADDR then
                --PC_DATA_OUT <= MEMORY;
                DATA <= "ZZZZZZZZ";
                TEMP_OUT <= MEMORY; 
            elsif INSTR(7 downto 0) = pc_READ_INCR_ADDR then
                PC_DATA <= INCREMENTED;
                DATA <= "ZZZZZZZZ";
                TEMP_OUT <= INCREMENTED; 
            elsif INSTR(15 downto 8) = INCR_PC then
                MEMORY <= INCREMENTED;
                TEMP_OUT <= MEMORY; 
                INCREMENTED <= STD_LOGIC_VECTOR(unsigned(INCREMENTED) + unsigned(step));
            else 
                DATA <= "ZZZZZZZZ";
                PC_DATA <= "ZZZZZZZZ";
                TEMP_OUT <= MEMORY; 
            end if;
        end if;
    end process;
              

end Behavioral;