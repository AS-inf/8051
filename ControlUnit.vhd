library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    GENERIC(
            CONSTANT DATA_TO_INSTR : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
    Port ( 
           DATA : inout STD_LOGIC_VECTOR(7 downto 0):="ZZZZZZZZ";
           STATUS : in STD_LOGIC_VECTOR(7 downto 0);
           ROM_FAST_DATA : in STD_LOGIC_VECTOR(7 downto 0);
           MICROCODE_OUT : inout STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           ACK_CLK : in STD_LOGIC;
           CLK : in STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
--component aW_REGISTER_8bit
--    generic(    WRITE_ADDR : STD_LOGIC_VECTOR(7 DOWNTO 0));
--    port(       DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);   
--                DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
--                INSTR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                
--                CLK : IN STD_LOGIC );
    
--end component;

SIGNAL INSTRUCTION : STD_LOGIC_VECTOR(7 DOWNTO 0):= x"00";

SIGNAL FLOW_CONTROLL : STD_LOGIC_VECTOR(1 DOWNTO 0):= "00";   -- cf of zf

TYPE mem IS ARRAY(0 to 255, 0 to 16) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL rom_block : mem := 
    (
    (x"11AF",x"BB00",x"FFD3",others => x"0000"),                          --00] CLEAR PC      ()
    (x"BB00", x"FFD3",others => x"0000"),                                  --01] NOP           (1)
    (x"BB00",x"C1D3",x"BB00",x"FFD3", others => x"0000"),                   --02] MOVB $x, %A   (2)
    (x"BB00",x"C2D3",x"BB00",x"FFD3",others => x"0000"),                    --03] MOVB $x, %B   (2)
    (x"C1C2",x"BB00",x"FFD3", others => x"0000"),                           --04] MOVB %B, %A   (1)
    (x"C2C1",x"BB00",x"FFD3",others => x"0000"),                            --05] MOVB %A, %B   (1)
    (x"F1AF",x"F400",x"C2C1",x"C1A2",x"BB00",x"FFD3",others => x"0000"),          --06] SWAP %A, %B   (1)      --clear temp A; copy B to TEMP B copy A to B copy alu_or to A
    (x"F200",x"F400",x"C1A1",x"BB00",x"FFD3",others => x"0000"),                    --07] ADDB %A, %B   (1)
    (x"F200",x"F400",x"C1A0",x"BB00",x"FFD3",others => x"0000"),                    --08] SUBB %A, %B   (1)
    (x"F200",x"F400",x"C1A2",x"BB00",x"FFD3",others => x"0000"),                    --09] ORB %A, %B    (1)
    (x"F200",x"F400",x"C1A3",x"BB00",x"FFD3",others => x"0000"),                    --0A] ANDB %A, %B   (1)
    (x"11C1",x"FFD3",others => x"0000"),                                            --0B] JMP %A,       (1)
    (x"BB00",x"11D3",x"FFD3",others => x"0000"),                                    --0C] JMP $x,       (2)
    (x"CCCA",x"11C1",x"FFD3",others => x"0000"),                                    --0D] JZ %A,       (1)
    (x"CCCB",x"11C1",x"FFD3",others => x"0000"),                                    --0E] JNZ %A,       (1)
    (x"CCCC",x"11C1",x"FFD3",others => x"0000"),                                    --0F] JZ %A,       (1)
    (x"CCCD",x"11C1",x"FFD3",others => x"0000"),                                    --10] JNZ %A,       (1)
    (x"CCCA",x"BB00",x"11D3",x"FFD3",others => x"0000"),                                    --11] JZ $x,       (2)
    (x"CCCB",x"BB00",x"11D3",x"FFD3",others => x"0000"),                                    --12] JNZ $x,       (2)
    (x"CCCC",x"BB00",x"11D3",x"FFD3",others => x"0000"),                                    --13] JZ $x,       (2)
    (x"CCCD",x"BB00",x"11D3",x"FFD3",others => x"0000"),                                    --14] JNZ $x,       (2)

    others=> ((x"BB00", x"FFD3",others => x"0000")));


begin
INSTRUCTION <= data;
FLOW_CONTROLL <= STATUS(7 downto 6);

process (ACK_CLK) begin
    if rising_edge(ACK_CLK) then

        
    end if;
end process;


process (CLK)
    variable INSTRUCTION_LATCH : STD_LOGIC_VECTOR(7 DOWNTO 0):= x"00";
    variable MICRO_CODE_COUNTER : INTEGER RANGE 0 TO 15;
     begin

    if falling_edge(CLK) then
        if MICROCODE_OUT = x"CCCA" then 
            if FLOW_CONTROLL(1) = '1' then
                
            else
                INSTRUCTION_LATCH := x"01";
                MICRO_CODE_COUNTER := 0;
            end if;
        elsif MICROCODE_OUT = x"CCCB" then 
            if FLOW_CONTROLL(1) = '0' then
                
            else
                INSTRUCTION_LATCH := x"01";
                MICRO_CODE_COUNTER := 0;
            end if;
        elsif MICROCODE_OUT = x"CCCC" then 
            if FLOW_CONTROLL(0) = '1' then
                
            else
                INSTRUCTION_LATCH := x"01";
                MICRO_CODE_COUNTER := 0;
            end if;
        elsif MICROCODE_OUT = x"CCCD" then 
            if FLOW_CONTROLL(0) = '0' then
                
            else
                INSTRUCTION_LATCH := x"01";
                MICRO_CODE_COUNTER := 0;
            end if;
        end if;
    
         if rom_block(to_integer(unsigned(INSTRUCTION_LATCH)), MICRO_CODE_COUNTER) = x"0000" then 
            MICROCODE_OUT<=rom_block(to_integer(unsigned(INSTRUCTION)), 0); 
            MICRO_CODE_COUNTER := 1;
            INSTRUCTION_LATCH := INSTRUCTION;         
        else
            MICROCODE_OUT<=rom_block(to_integer(unsigned(INSTRUCTION_LATCH)), MICRO_CODE_COUNTER);
            MICRO_CODE_COUNTER := MICRO_CODE_COUNTER+1;
        end if;
       
    end if;
end process;

end Behavioral;
