library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity CPU is
--    Port 
--    ( 
--        CLK : in STD_LOGIC;
--        INSTR: in STD_LOGIC_VECTOR (15 downto 0);
--        INSTR_out: out STD_LOGIC_VECTOR (15 downto 0);  
--        DATA_IN_CPU : in STD_LOGIC_VECTOR (7 downto 0);
--        DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0)
        
--    );
end CPU;

architecture Behavioral of CPU is
component A_REG_TEMP_REG is
    GENERIC(    REG_WRITE_ADDR  : STD_LOGIC_VECTOR (7 downto 0);       --H
                REG_READ_ADDR  : STD_LOGIC_VECTOR (7 downto 0);        --L
                TEMP_WRITE_ADDR  : STD_LOGIC_VECTOR (7 downto 0);      --H
                TEMP_WRITE_REG_ADDR  : STD_LOGIC_VECTOR (7 downto 0)   --L 
                );
    
    PORT(       DATA : inout STD_LOGIC_VECTOR (7 downto 0);
                ALU_OUT : out STD_LOGIC_VECTOR (7 downto 0);
                INSTR : in STD_LOGIC_VECTOR (15 downto 0);
                ACK_CLK : in STD_LOGIC;
                CLK : in STD_LOGIC);
end component;
component ALU is
    GENERIC(
                ALU_READ_SUB_ADDR : STD_LOGIC_VECTOR (7 downto 0);
                ALU_READ_ADD_ADDR : STD_LOGIC_VECTOR (7 downto 0);
                ALU_READ_OR_ADDR : STD_LOGIC_VECTOR (7 downto 0);
                ALU_READ_AND_ADDR : STD_LOGIC_VECTOR (7 downto 0));
    PORT ( 
                TEMP_A_IN :  in STD_LOGIC_VECTOR (7 downto 0);
                TEMP_B_IN :  in STD_LOGIC_VECTOR (7 downto 0);
                ACK_CLK :    in STD_LOGIC;
                CLK :        in STD_LOGIC;
                STATUS :  inout STD_LOGIC_VECTOR (7 downto 0);
                RESULT_OUT : out STD_LOGIC_VECTOR (7 downto 0);
                INSTR      : in  STD_LOGIC_VECTOR (15 downto 0));
end component;
component RAM
     GENERIC(
             REG_WRITE_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0);
             MEM_SAVE_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0);
             MEM_LOAD_ADDR: STD_LOGIC_VECTOR (7 DOWNTO 0)
            );
     PORT   (
             DATA: inout STD_LOGIC_VECTOR (7 DOWNTO 0);
             INSTR: in STD_LOGIC_VECTOR (15 DOWNTO 0);
             ACK_CLK : in STD_LOGIC;
             CLK: in STD_LOGIC
            );
end component;
component PC_SEGMENT
       GENERIC
        (   REGISTER_WRITE_DATA : std_logic_vector (7 DOWNTO 0);
            REGISTER_READ_DATA : std_logic_vector (7 DOWNTO 0);
            
            PC_REGISTER_WRITE : std_logic_vector (7 DOWNTO 0);
            PC_REGISTER_READ : std_logic_vector (7 DOWNTO 0);
            
            TEMP_WRITE_ADDR :std_logic_vector (7 DOWNTO 0);
            TEMP_WRITE_REG_ADDR :std_logic_vector (7 DOWNTO 0);

            PC_INCREMENTER_READ : std_logic_vector (7 DOWNTO 0);
            ROM_READ : std_logic_vector (7 DOWNTO 0);
            INCR_PC  : STD_LOGIC_VECTOR (7 downto 0));
        
    Port ( DATA : inout STD_LOGIC_VECTOR (7 downto 0);
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end component;
component ControlUnit
    GENERIC( DATA_TO_INSTR : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
    Port ( 
           DATA : inout STD_LOGIC_VECTOR(7 downto 0);
           ROM_FAST_DATA : in STD_LOGIC_VECTOR(7 downto 0);
           STATUS: in STD_LOGIC_VECTOR(7 downto 0);
           MICROCODE_OUT : inout STD_LOGIC_VECTOR (15 downto 0);
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end component;
component STATUS_REGISTER
   GENERIC( READ_PSW : STD_LOGIC_VECTOR (7 downto 0));
  Port ( ALU: INOUT STD_LOGIC_VECTOR (7 downto 0);
         DATA: OUT STD_LOGIC_VECTOR (7 downto 0);
         FAST_CU: OUT STD_LOGIC_VECTOR (7 downto 0);   
         INSTR : in STD_LOGIC_VECTOR (15 downto 0);
         ACK_CLK : in STD_LOGIC;
         CLK : in STD_LOGIC);
end component;


    signal DATA : STD_LOGIC_VECTOR (7 downto 0):= "00000000"; 
    signal TEMP_A_ALU : STD_LOGIC_VECTOR (7 downto 0):= x"00";
    signal TEMP_B_ALU : STD_LOGIC_VECTOR (7 downto 0):= x"00";
    signal FAST_STATUS_CU : STD_LOGIC_VECTOR (7 downto 0):= x"00"; 
    signal STATUS_ALU : STD_LOGIC_VECTOR (7 downto 0):= x"00";   
    signal CLK : STD_LOGIC:= '0';
    signal ACK_CLK : STD_LOGIC:= '0';
    signal INSTR : STD_LOGIC_VECTOR (15 downto 0);

begin
    CLK<= not CLK after 10ms;
    ACK_CLK <= CLK after 1ms;
    --DATA<= "ZZZZZZZZ";
--    INSTR_out<=instr_CPU;
--    DATA_OUT <= DATA;
--    DATA <=DATA_IN_CPU;

process (CLK) begin
    if RISING_EDGE(CLK) then if INSTR(7 DOWNTO 0) = x"AF" then DATA<= x"00"; else DATA<= "ZZZZZZZZ"; end if; end if;
end process;
    
    A: A_REG_TEMP_REG 
        GENERIC MAP(REG_WRITE_ADDR=>x"c1", REG_READ_ADDR=>x"c1", TEMP_WRITE_ADDR=>x"F1", TEMP_WRITE_REG_ADDR=>x"F2") 
        PORT MAP(DATA=>DATA, ALU_OUT=>TEMP_A_ALU, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
    B: A_REG_TEMP_REG 
        GENERIC MAP(REG_WRITE_ADDR=>x"c2", REG_READ_ADDR=>x"c2", TEMP_WRITE_ADDR=>x"F3", TEMP_WRITE_REG_ADDR=>x"F4") 
        PORT MAP(DATA=>DATA, ALU_OUT=>TEMP_B_ALU, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
        
    ALU_1: ALU
        GENERIC MAP(ALU_READ_SUB_ADDR=>x"A0", ALU_READ_ADD_ADDR=>x"A1", ALU_READ_OR_ADDR=>x"A2", ALU_READ_AND_ADDR=>x"A3") --ADD SUB XOR OR AND...
        PORT MAP(TEMP_A_IN=>TEMP_A_ALU, TEMP_B_IN=>TEMP_B_ALU, STATUS=>STATUS_ALU, RESULT_OUT=>DATA, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
    
    RAM_1 : RAM
        GENERIC MAP(REG_WRITE_ADDR=>x"D0", MEM_SAVE_ADDR=>x"D1", MEM_LOAD_ADDR=>x"D2")  
        PORT MAP(DATA=>DATA, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
         
    PC : PC_SEGMENT
        GENERIC MAP(REGISTER_WRITE_DATA=>x"11", REGISTER_READ_DATA=>x"12",      --JMP
        PC_REGISTER_WRITE=>x"13", PC_REGISTER_READ=>x"14", 
        TEMP_WRITE_ADDR=>x"15", TEMP_WRITE_REG_ADDR=>x"22",
        PC_INCREMENTER_READ=> x"DD", ROM_READ=>x"D3", INCR_PC=>x"BB")
        PORT MAP(DATA=> DATA, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
        
    PSW : STATUS_REGISTER
         GENERIC MAP(READ_PSW=>x"A4")
        PORT MAP(ALU=>STATUS_ALU, DATA=>DATA, FAST_CU=>FAST_STATUS_CU, INSTR=>INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
    
    CU : ControlUnit
         GENERIC MAP( DATA_TO_INSTR => x"FF")
         Port MAP (DATA =>DATA, ROM_FAST_DATA => x"00", STATUS=> FAST_STATUS_CU, MICROCODE_OUT => INSTR, CLK=>CLK, ACK_CLK=>ACK_CLK);
    
end Behavioral;                                                                             
