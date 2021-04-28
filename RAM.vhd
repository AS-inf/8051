library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAM is
     GENERIC(
              REG_WRITE_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0);
              MEM_SAVE_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0);
              MEM_LOAD_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0)
            );
     PORT   (
             DATA: inout STD_LOGIC_VECTOR (7 DOWNTO 0):= x"00";
             INSTR: in STD_LOGIC_VECTOR (15 DOWNTO 0);
             ACK_CLK :    in STD_LOGIC;
             CLK: in STD_LOGIC
            );
end RAM;

architecture Behavioral of RAM is

component aR_REGISTER_8bit
    Generic (  R_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0) );
    Port 
    ( 
        CLK : in STD_LOGIC;
        ACK_CLK : in STD_LOGIC;
        INSTR : in STD_LOGIC_VECTOR (15 downto 0);
        DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0)
    );
end component;

component RW_MEM
   generic( READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);
            WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0)
            );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0);
           ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end component;

signal mem_addr : std_logic_vector (7 DOWNTO 0);
begin
    RAM_ADDR_REG : aR_REGISTER_8bit GENERIC MAP(R_WRITE_ADDR=>REG_WRITE_ADDR) 
                    PORT MAP(DATA_IN=>DATA, DATA_OUT=>mem_addr, INSTR=>INSTR, CLK=>CLK, ACK_CLK=> ACK_CLK);
                    
    RAM_MEM:    RW_MEM GENERIC MAP(WRITE_ADDR => MEM_SAVE_ADDR, READ_ADDR=> MEM_LOAD_ADDR)
                PORT MAP(DATA=>DATA, ADDR=>mem_addr, INSTR=>INSTR, CLK=>CLK, ACK_CLK=> ACK_CLK);
                
end Behavioral;
