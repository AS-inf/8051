library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;
entity ROM_MEM is
    GENERIC( constant ADDR_READ : std_logic_vector(7 DOWNTO 0);
             constant data_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);
             constant INCR_PC : STD_LOGIC_VECTOR (7 downto 0)
             );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
           ADDR : in STD_LOGIC_VECTOR (7 downto 0) := x"00";
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end ROM_MEM;

architecture Behavioral of ROM_MEM is
    TYPE mem IS ARRAY(0 to 255) OF std_logic_vector(7 DOWNTO 0);
    SIGNAL rom_block : mem := 
    (x"00",x"01", x"02", x"ff", x"03",x"08", x"06", x"0B", x"0C", x"01",others => x"FF");
    --(x"00",x"01", x"02", x"01", x"0E",x"08", x"06", x"0B", x"0C", x"01",others => x"FF");
    --signal inner_temp :std_logic_vector (7 downto 0) :=x"00";
    signal buffor :std_logic_vector (7 downto 0) :=x"00";
begin


PROCESS (ACK_CLK) BEGIN
IF rising_edge(ACK_CLK) THEN   
    IF INSTR(15 DOWNTO 8) = data_WRITE_ADDR THEN 
           buffor <= rom_block(to_integer(unsigned(DATA))); 
    ELSIF INSTR(15 DOWNTO 8) = INCR_PC THEN
            buffor <= rom_block(to_integer(unsigned(ADDR + x"01"))); 
    ELSE
            buffor <= rom_block(to_integer(unsigned(ADDR))); 
    END IF;
END IF;
END PROCESS;

PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN   
        IF INSTR(7 DOWNTO 0) = ADDR_READ THEN
            DATA <= buffor;         
        else
            DATA <= "ZZZZZZZZ";
        END IF; 
    END IF;
END PROCESS;


end Behavioral;
