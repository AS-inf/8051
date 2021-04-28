library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity A_REG_TEMP_REG is
    GENERIC(    REG_WRITE_ADDR  : STD_LOGIC_VECTOR (7 downto 0);        --H
                REG_READ_ADDR  : STD_LOGIC_VECTOR (7 downto 0);         --L
                TEMP_WRITE_ADDR  : STD_LOGIC_VECTOR (7 downto 0);       --H
                TEMP_WRITE_REG_ADDR  : STD_LOGIC_VECTOR (7 downto 0)   --L 
                );
    
    Port(       DATA : inout STD_LOGIC_VECTOR (7 downto 0):= "00000000";
                ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0):= "00000000";
                INSTR : in STD_LOGIC_VECTOR (15 downto 0);
                ACK_CLK : in STD_LOGIC;
                clk : in STD_LOGIC);
end A_REG_TEMP_REG;

architecture Behavioral of A_REG_TEMP_REG is
COMPONENT A_B_REGISTER
    GENERIC (   WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);
                READ_ADDR : STD_LOGIC_VECTOR (7 downto 0));
    PORT (      DATA : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                TEMP_OUT :OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                INSTR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                ACK_CLK : in STD_LOGIC;
                CLK : IN STD_LOGIC );
END COMPONENT;
        
COMPONENT TEMP_REG
    GENERIC (   WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);
                WRITE_REG_ADDR : STD_LOGIC_VECTOR (7 downto 0));
    PORT(       REG_IN : in STD_LOGIC_VECTOR (7 downto 0);
                DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
                ALU_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                INSTR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                ACK_CLK : in STD_LOGIC;
                CLK : IN STD_LOGIC );
END COMPONENT;

    signal TEMP_B_B : STD_LOGIC_VECTOR (7 downto 0);

begin
A: A_B_REGISTER     GENERIC MAP(WRITE_ADDR => REG_WRITE_ADDR, READ_ADDR => REG_READ_ADDR) 
                    PORT MAP(DATA => DATA, TEMP_OUT => TEMP_B_B, INSTR=> INSTR, CLK=> CLK, ACK_CLK=>ACK_CLK);
TEMP_A: TEMP_REG    GENERIC MAP(WRITE_ADDR => TEMP_WRITE_ADDR, WRITE_REG_ADDR => TEMP_WRITE_REG_ADDR) 
                    PORT MAP(DATA_IN => DATA, REG_IN=>TEMP_B_B, ALU_OUT => ALU_OUT, INSTR=> INSTR, CLK=> CLK, ACK_CLK=>ACK_CLK);

end Behavioral;
