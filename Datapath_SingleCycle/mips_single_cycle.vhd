library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mips_single_cycle is
port(	
		CLOCK_50:  in std_logic;
		SW : in std_logic_vector(17 downto 0);
		KEY: in std_logic_vector(3 downto 0);
		LEDR: out std_logic_vector(17 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0);
		HEX4: out std_logic_vector(6 downto 0);
		HEX5: out std_logic_vector(6 downto 0);
		HEX6: out std_logic_vector(6 downto 0);
		HEX7: out std_logic_vector(6 downto 0)
	);
end mips_single_cycle;

architecture Structural of mips_single_cycle is
signal s_clk,s_zero	  : std_logic;
signal s_offset32,s_pc : std_logic_vector(31 downto 0);
signal s_jAddr         : std_logic_vector(25 downto 0); 
signal s_data          : std_logic_vector(31 downto 0); -- código máquina 32 bits
signal s_opcode        : std_logic_vector(5 downto 0);  -- opcode 6 bits
signal s_rs            : std_logic_vector(4 downto 0);  -- rs 5 bits
signal s_rt            : std_logic_vector(4 downto 0);  -- rt 5 bits
signal s_rd            : std_logic_vector(4 downto 0);  -- rd 5 bits
signal s_shamt         : std_logic_vector(4 downto 0);  -- shamt 5 bits
signal s_funct         : std_logic_vector(5 downto 0);  -- funct 6 bits
signal s_imm           : std_logic_vector(15 downto 0); -- Imm 16 bits
signal s_muxOutReg     : std_logic_vector(4 downto 0);  -- Output do mux2N à entrada do banco de registos
signal s_aluResult     : std_logic_vector(31 downto 0); -- Registo que entra no banco de registos para escrita
signal s_readData1     : std_logic_vector(31 downto 0); -- Registo que vai entrar na ALU. 
signal s_readData2     : std_logic_vector(31 downto 0); -- Registo que entra no MUX antes da ALU
signal s_muxOutAlu     : std_logic_vector(31 downto 0); -- Output do mux2N à entrada da ALU
signal s_aluCtrl       : std_logic_vector(2 downto 0);  -- Sinal gerado pela UC para controlar a UC da ALU
signal s_readDataDebug : std_logic_vector(31 downto 0); -- Porta debug do módulo RegFile
signal s_readRegDebug  : std_logic_vector(4 downto 0);  -- Porta debug do módulo RegFile
signal s_DMaddressDebug  : std_logic_vector(5 downto 0);  -- Porta debug do módulo DataMemory
signal s_DMreadDataDebug : std_logic_vector(31 downto 0); -- Porta debug do módulo DataMemory
signal s_DMwriteEn     : std_logic; 						  -- Data memory sinal de controlo gerado pela UC
signal s_DMreadEn      : std_logic;                   -- Data memory sinal de controlo gerado pela UC
signal s_DMreadData    : std_logic_vector(31 downto 0); -- Output do módulo DataMemory
signal s_writeData 	  : std_logic_vector(31 downto 0); -- Output do Mux à saída da ALU

-- Sinais da Unidade de Controlo
signal s_RegDst        : std_logic;  -- Sinal de selecção do Mux- Registo Destino (UC)
signal s_Jump          : std_logic;  -- Sinal de selecção do Mux - PCU (UC)
signal s_Branch        : std_logic;                     -- Sinal da lógica adicional Branch (UC)
signal s_MemToReg      : std_logic;  -- Sinal de selecção do Mux - writeback (UC)
signal s_MemWrite      : std_logic;                     -- Sinal de controlo de escrita na Memória (UC)
signal s_MemRead       : std_logic;                     -- Sinal de controlo de leitura da Memória (UC)
signal s_ALUSrc        : std_logic;  -- Sinal de selecção do Mux - Offset/Reg2 (UC)
signal s_ALUop         : std_logic_vector (1 downto 0); -- Sinal de selecção da operação na ALU (UC)
signal s_RegWrite      : std_logic;                     -- Sinal de controlo de escrita no BancoReg (UC)
begin
  LEDR(0) <= s_RegDst;
  LEDR(1) <= s_Jump;
  LEDR(2) <= s_Branch;
  LEDR(3) <= s_MemToReg;
  LEDR(4) <= s_MemWrite;
  LEDR(5) <= s_MemRead;
  LEDR(6) <= s_ALUsrc;
  LEDR(8 downto 7) <= s_ALUop;
  LEDR(9) <= s_RegWrite;
  
--Debouncer
debnc: entity work.DebounceUnit(Behavioral)
		generic map(mSecMinInWidth => 200)
		port map( 	refClk => CLOCK_50,
						dirtyIn => KEY(0),
						pulsedOut => s_clk);
						
-- Instruction Memory module

instrmem: entity work.Instruction_Memory(Behavioral)
port map(	addr => s_pc(4 downto 0),
				data => s_data);
						
-- Splitter module

splitter: entity work.InstrSplitter(Behavioral)
port map(	instruction => s_data,
				opcode => s_opcode, 
				rs =>  s_rs,
				rt => s_rt,
				rd => s_rd,
				shamt =>  s_shamt,
				funct => s_funct,
				imm => s_imm,
				jAddr => s_jAddr);
				
-- RegMux

regmux: entity work.Mux2N(Behavioral)
generic map(N => 5)
port map(
			input1 => s_rt,
			input2 => s_rd,
			output0 => s_muxOutReg,
			selection => s_RegDst
			);
				
-- Register File

regfile: entity work.RegFile(Behavioral)
port map(
			clk => s_clk,
			writeEn => s_RegWrite,
			readReg1 => s_rs,
			readReg2 => s_rt,
			writeReg => s_muxOutReg,
			writeData => s_writeData,
			readData1 => s_readData1,
			readData2 => s_readData2,
			readRegDebug => s_readRegDebug,
			readDataDebug => s_readDataDebug
			);
			
-- Mux2N à saída do banco de registos

alumux: entity work.Mux2N(Behavioral)
port map(
			input1 => s_readData2,
			input2 => s_offset32,
			output0 => s_muxOutAlu,
			selection => s_ALUsrc
			);
			
-- ALU Control

aluctrl: entity work.ALUcontrol(Behavioral)
port map(
			ALUop => s_ALUop,
			funct => s_funct,
			ALUcontrol => s_aluCtrl 
			); 	

-- ALU

alu32: entity work.ALU32(Behavioral)
port map(
			aluop => s_aluCtrl,
			opnd1 => s_readData1,
			opnd2 => s_muxOutAlu,
			zero => s_zero,
			result => s_aluResult
			);
			
-- Mux2N à sáida da ALU/Mem
posalumux: entity work.Mux2N(Behavioral)
port map(
			input1 => s_aluResult,
			input2 => s_DMreadData,
			output0 => s_writeData,
			selection => s_MemToReg
);

		
				
-- Signal extend module
sigext: entity work.SignExtend(Behavioral)
port map(	dataIn => s_imm,
				dataOut => s_offset32);

--PC update module

pcupd: entity work.PCupdate(Behavioral)
port map( 	
				clk => s_clk,
				reset => not KEY(1),
				branch => s_Branch and s_zero,
				jump => s_Jump,
				zero => s_zero,
				offset32 => s_offset32,
				jAddr => s_jAddr,
				pc => s_pc);

-- Data Memory

datamem: entity work.DataMemory(Behavioral)
port map(
			clk => s_clk,
			readEn => s_DMreadEn, 
			writeEn => s_DMwriteEn,
			address => s_aluResult(7 downto 2),
			writeData => s_readData2,
			readData => s_DMreadData,
			addressDebug => s_DMaddressDebug,
			readDataDebug => s_DMreadDataDebug
);
-- Control Unit
ctrlunit: entity work.ControlUnit(Behavioral)
port map(
			OpCode => s_opcode,
			RegDst => s_RegDst,
			Branch => s_Branch,
			MemRead => s_MemRead,
			MemWrite => s_MemWrite,
			MemToReg => s_MemToReg,
			ALUsrc => s_ALUsrc,
			RegWrite => s_RegWrite,
			ALUop => s_ALUop
);



				
-- Display Unit
display: entity work.DisplayUnit(Behavioral)
port map(	PC => s_pc,
				IM_data => s_data,
				DispMode => SW(2),
				RefClk => CLOCK_50,
				InputSel => SW(1 downto 0),
				Dir => KEY(2),
				NextAddr => KEY(3),
				RF_data => s_readDataDebug,
				RF_addr => s_readRegDebug,
				DM_data => s_DMreadDataDebug,
				DM_addr => s_DMaddressDebug,
				disp0 => HEX0,
				disp1 => HEX1,
				disp2 => HEX2,
				disp3 => HEX3,
				disp4 => HEX4,
				disp5 => HEX5,
				disp6 => HEX6,
				disp7 => HEX7
				);
end Structural;