library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RegFile is
generic( ADDR_BUS_SIZE : positive := 5;
			DATA_BUS_SIZE : positive := 32
		 );
port(
		clk:	in std_logic;
		writeEn: in std_logic;
		readReg1: in std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		readReg2: in std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		writeReg: in std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		writeData : in std_logic_vector(DATA_BUS_SIZE-1 downto 0);
		readData1: out std_logic_vector(DATA_BUS_SIZE-1 downto 0);
		readData2: out std_logic_vector(DATA_BUS_SIZE-1 downto 0);
		-- Portos extra para debug : Confirm -- 
		readRegDebug : in std_logic_vector(ADDR_BUS_SIZE-1 downto 0);
		readDataDebug : out std_logic_vector(DATA_BUS_SIZE-1 downto 0)
		);

end RegFile;


architecture Behavioral of RegFile is

subtype TWord is std_logic_vector(DATA_BUS_SIZE-1 downto 0);
type TMemory is array (0 to DATA_BUS_SIZE-1) of TWord;
signal s_memory : TMemory;

begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(writeEn = '1') then
				s_memory(to_integer(unsigned(writeReg))) <= writeData;
			end if;
		end if;
	end process;
	
	readData1     <= (others => '0') when (readReg1     = "00000") else s_memory(to_integer(unsigned(readReg1)));
	readData2     <= (others => '0') when (readReg2     = "00000") else s_memory(to_integer(unsigned(readReg2)));
	readDataDebug <= (others => '0') when (readRegDebug = "00000") else s_memory(to_integer(unsigned(readRegDebug)));
				
end Behavioral;