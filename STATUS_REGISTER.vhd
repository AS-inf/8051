library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity STATUS_REGISTER is
  GENERIC(constant READ_PSW : STD_LOGIC_VECTOR (7 downto 0));
  Port ( ALU: INOUT STD_LOGIC_VECTOR (7 downto 0):= "ZZZZZZZZ";
         DATA: OUT STD_LOGIC_VECTOR (7 downto 0):="ZZZZZZZZ";
         FAST_CU: OUT STD_LOGIC_VECTOR (7 downto 0); 
         INSTR : in STD_LOGIC_VECTOR (15 downto 0);
         ACK_CLK : in STD_LOGIC;
         CLK : in STD_LOGIC);
end STATUS_REGISTER;

architecture Behavioral of STATUS_REGISTER is
SIGNAL STATUS : STD_LOGIC_VECTOR (7 downto 0):=x"00";
SIGNAL NEW_STATUS : STD_LOGIC_VECTOR (7 downto 0);
--signal diff : STD_LOGIC;
begin

FAST_CU <= STATUS;
process(CLK) begin
     if rising_edge(CLK) then
        if INSTR(7 downto 0) = READ_PSW then
            DATA<=STATUS;
        else
            DATA<="ZZZZZZZZ";
        end if;
        
          if NEW_STATUS /= STATUS then
            FAST_CU <= NEW_STATUS;
            STATUS <= NEW_STATUS;
        end if;
        
    end if;
end process;

process(ACK_CLK) begin
    if rising_edge(ACK_CLK) then
    -- potential AL:U ADRESS for update
        NEW_STATUS<= ALU;
      
    end if;
end process;
end Behavioral;
