library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity Instruction_Memory is
generic(ADDR_BUS_SIZE : positive := 5);
port(	addr : in std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		data	: out std_logic_vector(31 downto 0)
		);

end Instruction_Memory;


architecture behavioral of Instruction_Memory is
constant NUM_WORDS : positive := (2 ** ADDR_BUS_SIZE); -- 2^5 words
subtype TData is std_logic_vector(31 downto 0); -- words de 32 bits
type TMemory is array (0 to NUM_WORDS-1) of TData; -- array com 32 posições cada uma de 32 bits
constant s_memory : TMemory :=  (
											x"2002001A", -- addi $2,$0,0x1A
											x"20030052", -- addi $3,$0,0x52
											x"00432020", -- add  $4,$2,$3
											x"00432822", -- sub $5,$2,$3
											x"00433024",-- and $6,$2,$3
											x"00433825",-- or $7,$2,$3
											x"00434826",-- xor $9,$2,$3
											x"00434027",-- nor $8,$2,$3
											x"0043502a",-- slt $10,$2,$3
											x"284b0020",-- slti $11,$2,0x20
											x"298cffa6",-- slti $12,$12,-90
											others => x"00000000"-- nop
											); 
begin
	data <= s_memory(to_integer(unsigned(addr(addr'length-1 downto 2)))); -- ADDR_BUS_SIZE-1
end behavioral;