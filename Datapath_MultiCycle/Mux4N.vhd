library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Mux4N is
generic(	N 	: positive := 32);
port(
		sel	:	in std_logic_vector(1 downto 0);
		in0	:	in std_logic_vector(N-1 downto 0);
		in1	:	in std_logic_vector(N-1 downto 0);
		in2	:	in std_logic_vector(N-1 downto 0);
		in3	:	in std_logic_vector(N-1 downto 0);
		out0	:	out std_logic_vector(N-1 downto 0)
);
end Mux4N;

architecture Behavioral of Mux4N is
begin
	process(sel,in0,in1,in2,in3)
	begin
		if(sel = "00") then
			out0 <= in0;
		elsif(sel = "01") then
			out0 <= in1;
		elsif(sel = "10") then
			out0 <= in2;
		else
			out0 <= in3;
		end if;
	end process;



end Behavioral;