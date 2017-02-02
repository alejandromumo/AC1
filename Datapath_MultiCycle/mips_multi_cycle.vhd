library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity mips_multi_cycle is
port(
		CLOCK_50	: 	in std_logic;
		KEY		:	in std_logic_vector(3 downto 0); -- KEY[0] Sinal de clock. KEY[1] sinal de reset.
		HEX0		: out std_logic_vector(6 downto 0);		-- Display Unit HEX displays
		HEX1		: out std_logic_vector(6 downto 0);		--
		HEX2		: out std_logic_vector(6 downto 0);		--
		HEX3		: out std_logic_vector(6 downto 0);		--
		HEX4		: out std_logic_vector(6 downto 0);		--
		HEX5		: out std_logic_vector(6 downto 0);		--	
		HEX6		: out std_logic_vector(6 downto 0);		--
		HEX7		: out std_logic_vector(6 downto 0);		--
		SW			: in std_logic_vector(17 downto 0)
		
);


end mips_multi_cycle;

architecture Structural of mips_multi_cycle is
-- Debouncer
signal s_clk															: std_logic;

-- PC Update
signal s_PC4,s_BTA,s_PC												: std_logic_vector(31 downto 0);

-- Mux4N
signal s_out0															: std_logic_vector(31 downto 0);

-- Control Unit
signal s_PCWrite,s_PCWriteCond,s_IRWrite 						: std_logic;
signal s_IorD,s_RegDest,s_MemRead,s_MemWrite					: std_logic;
signal s_MemToReg,s_ALUSelA,s_RegWrite							: std_logic;
signal s_PCSource,s_ALUSelB,S_ALUop								: std_logic_vector(1 downto 0);

-- Instruction Splitter
signal s_opcode,s_funct												: std_logic_vector(5 downto 0);
signal s_rs,s_rt,s_rd,s_shamt										: std_logic_vector(4 downto 0);
signal s_imm															: std_logic_vector(15 downto 0);
signal s_jAddr															: std_logic_vector(25 downto 0);

-- Register ALUOUt
signal s_ALUOut														: std_logic_vector(31 downto 0);

-- Register Instruction Regsiter
signal s_InstructionRegister_out									: std_logic_vector(31 downto 0);

-- Register Data Register
signal s_DataRegister_out											: std_logic_vector(31 downto 0);

-- Register A
signal s_RegA_out														: std_logic_vector(31 downto 0);

-- Register B
signal s_RegB_out														: std_logic_vector(31 downto 0);

-- Mux2N saída do PC
signal s_mux2N_Out													: std_logic_vector(31 downto 0);

-- Mux2N entrada do banco de registos (RegDest)
signal s_Mux2NReg_out												: std_logic_vector(4 downto 0);

-- Mux2N entrada do banco de registos (MemToReg)
signal s_Mux2NMemToReg_out											: std_logic_vector(31 downto 0);

-- RAM
signal s_readData,s_readDataDebug								: std_logic_vector(31 downto 0);
signal s_addressDebug												: std_logic_vector(5 downto 0);

-- Left Shifter Jump Addr
signal s_lsj_out														: std_logic_vector(27 downto 0);

-- Left Shifter Immediate
signal s_lsi_out														: std_logic_vector(31 downto 0);

-- Signal Extender
signal s_signExtend_out												: std_logic_vector(31 downto 0);

-- Register File
signal s_read_data1,s_read_data2,s_read_data_debug			: std_logic_vector(31 downto 0);
signal s_read_reg_debug												: std_logic_vector(4 downto 0);

-- ALU Control
signal s_alucontrol													: std_logic_vector(2 downto 0);

-- ALU
signal s_zero															: std_logic;
signal s_result														: std_logic_vector(31 downto 0);

-- Mux2N entrada da ALU
signal s_mux2n_alu_out												: std_logic_vector(31 downto 0);

begin

--Debouncer
debnc: entity work.DebounceUnit(Behavioral)
		generic map(mSecMinInWidth => 200)
		port map( 	refClk => CLOCK_50,
						dirtyIn => KEY(0),
						pulsedOut => s_clk);
						
						
-- Display Unit
display: entity work.DisplayUnit(Behavioral)
port map(	PC => s_pc,
				IM_data => s_readData,
				DispMode => SW(2),
				RefClk => CLOCK_50,
				InputSel => SW(1 downto 0),
				Dir => KEY(2),
				NextAddr => KEY(3),
				RF_data => s_read_data_debug,
				RF_addr => s_read_reg_debug,
				DM_data => s_readDataDebug,
				DM_addr => s_addressDebug,
				disp0 => HEX0,
				disp1 => HEX1,
				disp2 => HEX2,
				disp3 => HEX3,
				disp4 => HEX4,
				disp5 => HEX5,
				disp6 => HEX6,
				disp7 => HEX7
				);

-- PC Update
pcupdate: entity work.PCUpdate(Behavioral)
port map(
			zero 			=> s_zero,
			PCWrite 		=> s_PCWrite,
			PCWriteCond => s_PCWriteCond,
			PCSource		=> s_PCSource,
			jAddr			=> s_jAddr,
			PC4			=> s_PC4,
			BTA			=> s_BTA,
			reset			=> not KEY(1),
			clk 			=> s_clk,
			PC				=> s_PC
			);

-- Mux2N (saída do PC)
mux2N: entity work.Mux2N(Behavioral)
port map(
			input1 		=> s_PC4,
			input2 		=> s_ALUOut,
			output0 		=> s_mux2N_Out,
			selection 	=> s_IorD
);			
-- Mux4N (entrada da ALU)
mux4n: entity work.Mux4N(Behavioral)
port map(
			sel		=> s_ALUSelB,
			in0		=> s_regB_out,
			in1		=> x"00000004",
			in2		=> s_signExtend_out,
			in3		=> s_lsi_out,
			out0 		=> s_out0
			);

-- RAM
ram: entity work.RAM(Behavioral)
port map(
			clk				=> s_clk,
			readEn			=> s_MemRead,
			writeEn 			=> s_MemWrite,
			address 			=> s_mux2N_Out(5 downto 0),
			writeData 		=> s_RegB_Out,
			readData			=> s_readData,
			addressDebug 	=> s_addressDebug,
			readDataDebug 	=> s_readDataDebug
			);

-- Instruction Register
ireg: entity work.Reg(Behavioral)
port map(
			dataIn 		=> s_readData,
			dataOut		=> s_InstructionRegister_out,
			enable		=> s_IRWrite,
			reset			=> not KEY(1),
			clk			=> s_clk
);

-- Data Register	
dreg: entity work.Reg(Behavioral)
port map(
			dataIn 		=> s_readData,
			dataOut		=> s_DataRegister_out,
			enable		=> '1',
			reset			=> not KEY(1),
			clk			=> s_clk
);
		
-- LeftShifter Immediate
lefsh1: entity work.LeftShifter(Behavioral)
port map(
			in0		=> s_signExtend_out,
			out0		=> s_lsi_out
			);

-- Register A TODO
regA: entity work.Reg(Behavioral)
port map(
			dataIn 		=> s_read_data1,
			dataOut		=> s_RegA_out,
			enable		=> '1',
			reset			=> not KEY(1),
			clk			=> s_clk
			);
			
-- Register B TODO
regB: entity work.Reg(Behavioral)
port map(
			dataIn 		=> s_read_data2,
			dataOut		=> s_RegB_out,
			enable		=> '1',
			reset			=> not KEY(1),
			clk			=> s_clk
	 );
	 
-- Register ALUOut
regALU: entity work.Reg(Behavioral)
port map(
			dataOut 	=> s_ALUOut,
			dataIn 	=> s_result,
			clk		=> s_clk,
			reset		=> not KEY(1),
			enable	=> '1'
			);
	 
-- Mux2N à entrada do Register File ( MemToReg )
mux2nmr : entity work.Mux2N(Behavioral)
port map(
			input1 		=> s_DataRegister_out,
			input2		=> s_ALUOut,
			selection	=> s_MemToReg,
			output0		=> s_Mux2NMemToReg_out
);

-- Mux2N à entrada do Register File (RegDest = RS ou RT)
mux2nr : entity work.Mux2N(Behavioral)
generic map(N => 5)
port map(
			input1 		=> s_rt,
			input2 		=> s_rd,
			selection 	=> s_RegDest,
			output0		=> s_Mux2NReg_out
); 

-- Register File
regfile: entity work.RegFile(Behavioral)
port map(
			clk => s_clk,
			writeEn => s_RegWrite,
			readReg1 => s_rs,
			readReg2 => s_rt,
			writeReg => s_Mux2NReg_out,
			writeData => s_Mux2NMemToReg_out,
			readData1 => s_read_data1,
			readData2 => s_read_data2,
			readRegDebug => s_read_reg_debug,
			readDataDebug => s_read_data_debug 
			);

-- Instruction Splitter
isplit: entity work.InstrSplitter(Behavioral)
port map(
			instruction => s_InstructionRegister_out,
			opcode		=> s_opcode,
			rs				=> s_rs,
			rt				=> s_rt,
			rd				=> s_rd,
			shamt			=> s_shamt,
			funct			=> s_funct,
			imm			=> s_imm,
			jAddr			=> s_jAddr
);

-- Control Unit
ctrl: entity work.ControlUnit(Behavioral)
port map(
			Clock			=> s_clk,
			Reset			=> not key(1),
			OpCode 		=> s_opcode,
			PCWrite 		=> s_PCWrite,
			IRWrite 		=> s_IRWrite,
			IOrD			=> s_IOrD,
			PCSource 	=> s_PCSource,
			RegDest  	=> s_RegDest,
			PCWriteCond => s_PCWriteCond,
			MemRead		=> s_MemRead,
			MemWrite		=> s_MemWrite,
			MemToReg		=> s_MemToReg,
			ALUSelA		=> s_ALUSelA,
			ALUSelB		=> s_ALUSelB,
			RegWrite		=> s_RegWrite,
			ALUOp			=> s_ALUOp
			);

-- ALU Control
aluctrl: entity work.ALUcontrol(Behavioral)
port map(
			ALUop 		=> s_aluop,
			funct 		=> s_funct,
			ALUcontrol 	=> s_alucontrol
);

-- Mux2N entrada da ALU
mux2nal: entity work.Mux2N(Behavioral)
port map(
			input1 		=> s_PC4,
			input2 		=> s_RegA_out,
			output0 		=> s_mux2n_alu_out,
			selection 	=> s_ALUSelA
);
-- ALU
alu: entity work.ALU32(Behavioral)
port map(
		aluop 		=> s_alucontrol,
		opnd1 		=> s_mux2n_alu_out,
		opnd2 		=> s_out0,
		zero		 	=> s_zero,
		result 		=> s_result
);

end Structural;