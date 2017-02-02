library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DisplayUnit is
	generic(kHzClkFreq		: positive := 50000; 
           mSecMinInWidth	: positive := 100;
			  mSecMinInRepeat	: positive := 400;
			  mSecMinInRepeatFast : positive := 100;
			  datapathType		: std_logic := '0');	-- '0': single cycle, '1': multi-cycle
	port(	RefClk	: in std_logic;
			PC			: in std_logic_vector(31 downto 0) := (others => '0');
			IM_data	: in std_logic_vector(31 downto 0) := (others => '0');
			IM_addr	: out std_logic_vector(4 downto 0);
			RF_data	: in std_logic_vector(31 downto 0) := (others => '0');
			RF_addr	: out std_logic_vector(4 downto 0);			
			DM_data	: in std_logic_vector(31 downto 0) := X"00000000";
			DM_addr	: out std_logic_vector(5 downto 0);
			InputSel	: in std_logic_vector(1 downto 0) := "00";	
			DispMode	: in std_logic := '0';
			NextAddr	: in std_logic := '0';
			Dir		: in std_logic := '0';
			State		: in std_logic_vector(4 downto 0) := (others => '0');
			disp0		: out std_logic_vector(6 downto 0);
			disp1		: out std_logic_vector(6 downto 0);
			disp2		: out std_logic_vector(6 downto 0);
			disp3		: out std_logic_vector(6 downto 0);
			disp4		: out std_logic_vector(6 downto 0);
			disp5		: out std_logic_vector(6 downto 0);
			disp6		: out std_logic_vector(6 downto 0);
			disp7		: out std_logic_vector(6 downto 0));
end DisplayUnit;

architecture Behavioral of DisplayUnit is
	subtype T7segCode	is std_logic_vector(6 downto 0);
	type TMemory is array(0 to 20) of T7segCode;
	constant s_bin7seg : TMemory := ("1000000", "1111001", "0100100", "0110000", -- 0, 1, 2, 3
												"0011001", "0010010", "0000010", "1111000", -- 4, 5, 6, 7
												"0000000", "0010000", "0001000", "0000011", -- 8, 9, A, B
												"1000110", "0100001", "0000110", "0001110", -- C, D, E, F
												"0110110", "0001100", "1000110", "0001110", "0100001"); -- ///, P, C, F, d 
		
	type TCounter is array(0 to 3) of unsigned(5 downto 0);
	signal s_addrCounters : TCounter;

	constant MIN_IN_WIDTH_CYCLES : positive := mSecMinInWidth * kHzClkFreq; 
	constant MIN_IN_REPEAT_CYCLES : positive := mSecMinInRepeat * kHzClkFreq;
	constant MIN_IN_REPEAT_FAST_CYCLES : positive := mSecMinInRepeatFast * kHzClkFreq;
	signal s_count, s_repeatCount : natural := 0;

	signal s_inc, s_dec : std_logic;
	signal s_data : unsigned(31 downto 0);
	signal s_addr : unsigned(5 downto 0);
	signal s_inputSel : natural range 0 to 3;
begin

	s_inputSel <= to_integer(unsigned(InputSel));

-- Increment / Decrement address counters	
	process(refClk)
	begin
		if(rising_edge(refClk)) then
			if(s_inc = '1') then
				s_addrCounters(s_inputSel) <= s_addrCounters(s_inputSel) + 1;
			elsif(s_dec = '1') then
				s_addrCounters(s_inputSel) <= s_addrCounters(s_inputSel) - 1;
			end if;
		end if;
	end process;		

	IM_addr <= std_logic_vector(s_addrCounters(1)(4 downto 0));
	RF_addr <= std_logic_vector(s_addrCounters(2)(4 downto 0));
	DM_addr <= std_logic_vector(s_addrCounters(3)(5 downto 0));
	
-- Select address and data do display
	process(all)
	begin
		case InputSel is
			when "00" =>	-- PC
				s_data <= unsigned(PC);
				s_addr <= "------";
			when "01" =>	-- Instruction Memory
				s_data <= unsigned(IM_data);
				s_addr <= '0' & s_addrCounters(1)(4 downto 0);
			when "10" => 	-- Register File
				s_data <= unsigned(RF_data);
				s_addr <= '0' & s_addrCounters(2)(4 downto 0);				
			when "11" =>	-- Data Memory
				s_data <= unsigned(DM_data);
				s_addr <= s_addrCounters(3);
		end case;
	end process;


-- Display address and data
	process(all)
	begin
		disp0 <= s_bin7seg(to_integer(s_data(3 downto 0)));
		disp1 <= s_bin7seg(to_integer(s_data(7 downto 4)));
		disp2 <= s_bin7seg(to_integer(s_data(11 downto 8)));
		disp3 <= s_bin7seg(to_integer(s_data(15 downto 12)));
		if(DispMode = '0') then
			disp4 <= s_bin7seg(to_integer(s_data(19 downto 16)));
			disp5 <= s_bin7seg(to_integer(s_data(23 downto 20)));
			disp6 <= s_bin7seg(to_integer(s_data(27 downto 24)));
			disp7 <= s_bin7seg(to_integer(s_data(31 downto 28)));
		else
			disp7 <= s_bin7seg(16);	-- ///
			disp6 <= s_bin7seg(17 + s_InputSel);
			if(InputSel = "00") then
				if(datapathType = '0') then	-- single-cycle
					disp5 <= "0111111"; -- -
					disp4 <= "0111111"; -- -
				else		-- multi-cycle (show current state)
					disp5 <= s_bin7seg(to_integer(unsigned(State(4 downto 4))));
					disp4 <= s_bin7seg(to_integer(unsigned(State(3 downto 0))));
				end if;
			else
				disp5 <= s_bin7seg(to_integer(s_addr(5 downto 4)));
				disp4 <= s_bin7seg(to_integer(s_addr(3 downto 0)));
			end if;
		end if;
	end process;
			
-- Debounce "NextAddr" input (active low) and generate increment/decrement enables (normal, fast)	
	process(refClk)
	begin
		if(rising_edge(refClk)) then
			s_inc <= '0';
			s_dec <= '0';
			if(NextAddr = '0') then
				if(s_count >= MIN_IN_WIDTH_CYCLES) then
					if(s_count = MIN_IN_WIDTH_CYCLES) then
						if(Dir = '1') then s_inc <= '1'; else s_dec <= '1'; end if;
					else
						if(s_repeatCount <= 3) then
							if((s_count rem MIN_IN_REPEAT_CYCLES) = 0) then
								if(Dir = '1') then s_inc <= '1'; else s_dec <= '1'; end if;
								s_repeatCount <= s_repeatCount + 1;
							end if;
						else
							if((s_count rem MIN_IN_REPEAT_FAST_CYCLES) = 0) then
								if(Dir = '1') then s_inc <= '1'; else s_dec <= '1'; end if;
							end if;
						end if;
					end if;
				end if;
				s_count <= s_count + 1;
			else
				s_count <= 0;
				s_repeatCount <= 0;
			end if;
		end if;
	end process;

end Behavioral;
