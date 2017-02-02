library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity PCUpdate is
port(
			zero 			: in std_logic;
			PCWrite 		: in std_logic;
			PCWriteCond : in std_logic;
			PCSource 	: in std_logic_vector(1 downto 0);
			jaddr			: in std_logic_vector(25 downto 0);
			PC4			: in std_logic_vector(31 downto 0);
			BTA			: in std_logic_vector(31 downto 0);
			reset			: in std_logic;
			clk			: in std_logic;
			PC				: out std_logic_vector(31 downto 0)
);

end PCUpdate;

architecture Behavioral of PCUpdate is
	signal s_pc 	: unsigned(31 downto 0);
	signal s_jaddr	: unsigned(31 downto 0);
begin
	process(clk)
		begin
			if(rising_edge(clk)) then
				s_pc <= unsigned(PC4);
				s_jaddr <= unsigned(PC4(31 downto 28) & jaddr & "00");
				if(reset = '1') then
					s_pc <= (others => '0');
				else
					if(PCWrite = '1' and PCSource = "10") then
						s_pc <= s_jaddr;
					elsif(zero = '1' and PCWriteCond = '1') then
						s_pc <= unsigned(BTA);
					end if;
				end if;
			end if;
		end process;




PC <= std_logic_vector(s_pc);

end Behavioral;