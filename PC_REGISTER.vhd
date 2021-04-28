library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity PC_REGISTER is
    generic(
        constant data_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant data_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant pc_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE
        constant pc_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant pc_READ_INCR_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ
        constant INCR_PC : STD_LOGIC_VECTOR (7 downto 0)    -- c->registers  even->READ

        );
    Port ( DATA : in STD_LOGIC_VECTOR (7 downto 0);         
           MEM_ADDR_OUT : out STD_LOGIC_VECTOR (7 downto 0):= x"00";
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end PC_REGISTER;

architecture Behavioral of PC_REGISTER is

signal PC_DATA : STD_LOGIC_VECTOR (7 downto 0):=x"01";
signal INCREMENTED : STD_LOGIC_VECTOR (7 downto 0):= x"01"; 
signal step : STD_LOGIC_VECTOR (7 downto 0):= x"01";

begin 
    process(ACK_CLK)   begin
        if rising_edge(ACK_CLK) then
            if INSTR(15 downto 8) = data_WRITE_ADDR then
                PC_DATA <= DATA;
                --MEM_ADDR_OUT <= DATA;
                INCREMENTED <= DATA + step;
--            elsif INSTR(7 downto 0) = data_READ_ADDR then
--                DATA <= MEMORY;
--                MEM_ADDR_OUT <= MEMORY; 
--            elsif INSTR(7 downto 0) = pc_READ_ADDR then
--                PC_DATA_OUT <= MEMORY;
--                DATA <= "ZZZZZZZZ";
--                MEM_ADDR_OUT <= MEMORY; 
--            elsif INSTR(7 downto 0) = pc_READ_INCR_ADDR then
--                DATA <= "ZZZZZZZZ";
--                MEM_ADDR_OUT <= INCREMENTED; 
            elsif INSTR(15 downto 8) = INCR_PC then
                PC_DATA <= INCREMENTED;
                --MEM_ADDR_OUT <= INCREMENTED; 
                INCREMENTED <= INCREMENTED + step;
            else 
                --DATA <= "ZZZZZZZZ";
                --MEM_ADDR_OUT <= PC_DATA; 
            end if;
            --MEMORY<= DATA;
            --MEM_ADDR_OUT <= PC_DATA;       
        end if;
    end process;
    
    
    process(CLK)   begin
        if rising_edge(CLK) then
            MEM_ADDR_OUT <= PC_DATA;       
        end if;
    end process;
end Behavioral;