
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RW_MEM is
    generic(
            constant READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            constant WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0)
            );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0):= x"00";
           ADDR : in STD_LOGIC_VECTOR (7 downto 0) := x"00";
           INSTR : in STD_LOGIC_VECTOR (15 downto 0) := x"0003";
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end RW_MEM;

architecture Behavioral of RW_MEM is
    TYPE mem IS ARRAY(0 to 255) OF std_logic_vector(7 DOWNTO 0);
    SIGNAL ram_block : mem;
begin
     
PROCESS (ACK_CLK)  BEGIN
      IF rising_edge(ACK_CLK) THEN
         IF INSTR(15 downto 8) = WRITE_ADDR THEN
            ram_block(to_integer(unsigned(ADDR))) <= DATA;
         end if;
      END IF;
END PROCESS;

PROCESS (CLK)  BEGIN
      IF rising_edge(CLK) THEN
         if INSTR(7 downto 0) = READ_ADDR then
            DATA <= ram_block(to_integer(unsigned(ADDR)));
         else
            DATA <= "ZZZZZZZZ";
         END IF;
      END IF;
END PROCESS;
        

end Behavioral;
