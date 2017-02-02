library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ALU32 is
port(
		aluop : in std_logic_vector(2 downto 0);
		opnd1 : in std_logic_vector(31 downto 0);
		opnd2 : in std_logic_vector(31 downto 0);
		zero  : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);

end ALU32;

--- 000 AND 
--- 001 OR
--- 010 ADD
--- 011 XOR
--- 100 NOR
--- 110 SUB
--- 111 set if less than


architecture Behavioral of ALU32 is
begin
	process(aluop,opnd1,opnd2)
	begin
		zero <= '0';
		case aluop is
			when "000" =>
					result <= opnd1 and opnd2;
			when "001" =>
					result <= opnd1 or opnd2;
			when "010" =>
					result <= std_logic_vector(unsigned(opnd1) + unsigned(opnd2));
			when "011" =>
					result <= opnd1 xor opnd2;
			when "100" =>
					result <= opnd1 nor opnd2;
			when "110" =>
					result <= std_logic_vector(unsigned(opnd1) - unsigned(opnd2));
					if result = x"00000000" then
						zero <= '1';
					end if;
			when "111" => 
					if(opnd1 < opnd2) then
						result <= x"00000001";
					else
						result <= (others => '0');
					end if;
			when others => 
					result <= (others => '0');			
		end case;
	end process;
end Behavioral;