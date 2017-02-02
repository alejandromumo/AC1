library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity LeftShifter is
generic( N : positive := 32);
port(
		in0	: 	in std_logic_vector(N-1 downto 0);
		out0	:	out std_logic_vector(N-1 downto 0)
);

end LeftShifter;

architecture Behavioral of LeftShifter is
begin
	out0 <= in0(29 downto 0) & "00";
end Behavioral;