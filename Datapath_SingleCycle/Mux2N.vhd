library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Mux2N is
generic( N : positive := 32);
port(
		input1: in std_logic_vector(N-1 downto 0);
		input2: in std_logic_vector(N-1 downto 0);
		selection: in std_logic;
		output0: out std_logic_vector(N-1 downto 0));
end mux2N;



architecture Behavioral of Mux2N is
begin
	output0 <= input1 when (selection = '0') else input2;

end Behavioral;