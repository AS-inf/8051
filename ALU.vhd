
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
    generic(
            constant ALU_READ_SUB_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            constant ALU_READ_ADD_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            constant ALU_READ_OR_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            constant ALU_READ_AND_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            constant CMP : STD_LOGIC_VECTOR (7 downto 0):=x"00"    
             );
    Port ( 
           TEMP_A_IN :  in STD_LOGIC_VECTOR (7 downto 0);
           TEMP_B_IN :  in STD_LOGIC_VECTOR (7 downto 0);
           STATUS :  inout STD_LOGIC_VECTOR (7 downto 0):= x"00";
           RESULT_OUT : out STD_LOGIC_VECTOR (7 downto 0):= "ZZZZZZZZ";
           INSTR      : in  STD_LOGIC_VECTOR (15 downto 0):= x"0000";
           ACK_CLK :    in STD_LOGIC;
           CLK :        in STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    SIGNAL SUB_MEM : STD_LOGIC_VECTOR(8 downto 0):= "000000000";
    SIGNAL ADD_MEM : STD_LOGIC_VECTOR(8 downto 0):= "000000000";
    SIGNAL OR_MEM : STD_LOGIC_VECTOR(7 downto 0):= x"00";
    SIGNAL AND_MEM : STD_LOGIC_VECTOR(7 downto 0):= x"00";
    --SIGNAL STAT : STD_LOGIC_VECTOR(7 downto 0):= x"00";
begin
--    process(ACK_CLK) begin
--        if rising_edge(ACK_CLK) then
--            --carry flag update
--        end if;
--    end process;
    process(CLK) begin
        if rising_edge(CLK) then
            if INSTR(7 downto 0)= ALU_READ_SUB_ADDR then
                RESULT_OUT <= SUB_MEM(7 downto 0);
                if SUB_MEM = "000000000" then STATUS(7) <= '1'; end if;
                if SUB_MEM(8) = '1' then STATUS(6) <= '1'; else STATUS(6) <= '0'; end if;
            elsif INSTR(7 downto 0)= ALU_READ_ADD_ADDR then
                RESULT_OUT <= ADD_MEM  (7 downto 0);
                if ADD_MEM = "000000000" then STATUS(7) <= '1'; end if;
                if ADD_MEM(8) = '1' then STATUS(6) <= '1'; else STATUS(6) <= '0'; end if;
            elsif INSTR(7 downto 0)= ALU_READ_OR_ADDR  then
                RESULT_OUT <= OR_MEM;
                if OR_MEM = x"00" then STATUS(7) <= '1'; end if;
            elsif INSTR(7 downto 0)= ALU_READ_AND_ADDR then
                RESULT_OUT <= AND_MEM;
                if AND_MEM = x"00" then STATUS(7) <= '1'; end if;
            elsif INSTR(7 downto 0)= CMP then
                if SUB_MEM = "000000000" then STATUS(7) <= '1'; end if;
                if SUB_MEM(8) = '1' then STATUS(6) <= '1'; else STATUS(6) <= '0'; end if;
            else
                RESULT_OUT <= "ZZZZZZZZ";
            end if;
        end if;
    end process;


    SUB_MEM <= std_logic_vector(resize(unsigned(TEMP_A_IN), 9) - resize(unsigned(TEMP_B_IN), 9));
    ADD_MEM <= std_logic_vector(resize(unsigned(TEMP_A_IN), 9) + resize(unsigned(TEMP_B_IN), 9));
     OR_MEM <= TEMP_A_IN OR TEMP_B_IN;
    AND_MEM <= TEMP_A_IN AND TEMP_B_IN;
    --STATUS <= STAT;
end Behavioral;
