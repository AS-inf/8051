

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PC_SEGMENT is
    GENERIC
        (
            REGISTER_WRITE_DATA : std_logic_vector (7 DOWNTO 0);
            REGISTER_READ_DATA : std_logic_vector (7 DOWNTO 0);
            
            PC_REGISTER_WRITE : std_logic_vector (7 DOWNTO 0);
            PC_REGISTER_READ : std_logic_vector (7 DOWNTO 0);
            
            TEMP_WRITE_ADDR :std_logic_vector (7 DOWNTO 0);
            TEMP_WRITE_REG_ADDR :std_logic_vector (7 DOWNTO 0);
            PC_INCREMENTER_READ : std_logic_vector (7 DOWNTO 0);
            ROM_READ : std_logic_vector (7 DOWNTO 0);
            INCR_PC  : STD_LOGIC_VECTOR (7 downto 0)
        );
        
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end PC_SEGMENT;

architecture Behavioral of PC_SEGMENT is
COMPONENT PC_REGISTER
     generic(                                                                                          
             data_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE       
             data_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ       
             pc_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);   -- c->registers  odd->WRITE         
             pc_READ_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ         
             pc_READ_INCR_ADDR : STD_LOGIC_VECTOR (7 downto 0);    -- c->registers  even->READ    
             INCR_PC : STD_LOGIC_VECTOR (7 downto 0)    -- c->registers  even->READ               
                                                                                                   
     );                                                                                            
     Port ( DATA : in STD_LOGIC_VECTOR (7 downto 0);                                                
            MEM_ADDR_OUT : out STD_LOGIC_VECTOR (7 downto 0);                                              
            INSTR : in STD_LOGIC_VECTOR (15 downto 0); 
            ACK_CLK : in STD_LOGIC;                                                
            CLK : in STD_LOGIC);                                                                       
END COMPONENT;

COMPONENT ROM_MEM
    GENERIC  ( ADDR_READ : std_logic_vector(7 DOWNTO 0);
               data_WRITE_ADDR : STD_LOGIC_VECTOR (7 downto 0);
               INCR_PC : STD_LOGIC_VECTOR (7 downto 0)  );
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0);
           ADDR : IN STD_LOGIC_VECTOR (7 downto 0);
           INSTR : IN STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : IN STD_LOGIC);
END COMPONENT;
 
    signal MEM_ADDR : std_logic_vector (7 DOWNTO 0);  
begin
    PC_REGISTER_1 : PC_REGISTER 
    GENERIC MAP(data_WRITE_ADDR => REGISTER_WRITE_DATA, data_READ_ADDR=>REGISTER_READ_DATA,
                pc_WRITE_ADDR => PC_REGISTER_WRITE, pc_READ_ADDR=>PC_REGISTER_READ,
                pc_READ_INCR_ADDR=>PC_INCREMENTER_READ, INCR_PC =>INCR_PC)
    PORT MAP(   DATA => DATA, MEM_ADDR_OUT=>MEM_ADDR, INSTR=>INSTR, CLK=>CLK, ACK_CLK=> ACK_CLK);
             
    ROM_1 : ROM_MEM
    GENERIC MAP (ADDR_READ=> ROM_READ, data_WRITE_ADDR=> REGISTER_WRITE_DATA, INCR_PC=>INCR_PC)
    PORT MAP (DATA=>DATA, ADDR=>MEM_ADDR, INSTR=>INSTR, CLK=>CLK, ACK_CLK=> ACK_CLK);
end Behavioral;
