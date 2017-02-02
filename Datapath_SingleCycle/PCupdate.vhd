library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PCupdate is
port( zero : in std_logic;
		branch : in std_logic;
		jump : in std_logic;
		offset32: in std_logic_vector(31 downto 0);
		jAddr : in std_logic_vector(25 downto 0);
		reset : in std_logic;
		clk : in std_logic;
		PC : out std_logic_vector(31 downto 0));
		
end PCupdate;

architecture Behavioral of PCupdate is
signal s_pc : unsigned(31 downto 0);
signal s_pc4: unsigned(31 downto 0);
signal s_offset : unsigned(31 downto 0);
begin
s_offset <= unsigned(offset32(29 downto 0)) & "00";
s_pc4 <= s_pc + 4;
process(clk)
	begin
		if(rising_edge(clk)) then
			if (reset = '1') then			-- Se reset está ativo, a saída está a 0
				s_pc <= (others => '0');
			else
				if(zero = '1' and branch = '1') then -- Se há uma situação de branch e a comparação é válida, 
					s_pc <= s_pc4 + s_offset;--	salta para o target address
				elsif(jump = '1') then
					s_pc <= s_pc4(31 downto 28) & unsigned(jAddr) & "00" ; 
				else
					s_pc <= s_pc4;
				end if;
				
			end if;
		end if;
	end process;
PC <= std_logic_vector(s_pc);
end Behavioral;