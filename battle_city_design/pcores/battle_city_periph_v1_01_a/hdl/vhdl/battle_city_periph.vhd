------------------------------------------------------------------------------
-- battle_city_periph.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          battle_city_periph.vhd
-- Version:           1.01.a
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Mon Jul 06 14:45:41 2015 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library battle_city_periph_v1_01_a;
	use battle_city_periph_v1_01_a.vga_ctrl;
	use battle_city_periph_v1_01_a.battle_city;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_S_AXI_DATA_WIDTH           -- AXI4LITE slave: Data width
--   C_S_AXI_ADDR_WIDTH           -- AXI4LITE slave: Address Width
--   C_S_AXI_MIN_SIZE             -- AXI4LITE slave: Min Size
--   C_USE_WSTRB                  -- AXI4LITE slave: Write Strobe
--   C_DPHASE_TIMEOUT             -- AXI4LITE slave: Data Phase Timeout
--   C_BASEADDR                   -- AXI4LITE slave: base address
--   C_HIGHADDR                   -- AXI4LITE slave: high address
--   C_FAMILY                     -- FPGA Family
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of address-ranges
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   S_AXI_ACLK                   -- AXI4LITE slave: Clock 
--   S_AXI_ARESETN                -- AXI4LITE slave: Reset
--   S_AXI_AWADDR                 -- AXI4LITE slave: Write address
--   S_AXI_AWVALID                -- AXI4LITE slave: Write address valid
--   S_AXI_WDATA                  -- AXI4LITE slave: Write data
--   S_AXI_WSTRB                  -- AXI4LITE slave: Write strobe
--   S_AXI_WVALID                 -- AXI4LITE slave: Write data valid
--   S_AXI_BREADY                 -- AXI4LITE slave: Response ready
--   S_AXI_ARADDR                 -- AXI4LITE slave: Read address
--   S_AXI_ARVALID                -- AXI4LITE slave: Read address valid
--   S_AXI_RREADY                 -- AXI4LITE slave: Read data ready
--   S_AXI_ARREADY                -- AXI4LITE slave: read addres ready
--   S_AXI_RDATA                  -- AXI4LITE slave: Read data
--   S_AXI_RRESP                  -- AXI4LITE slave: Read data response
--   S_AXI_RVALID                 -- AXI4LITE slave: Read data valid
--   S_AXI_WREADY                 -- AXI4LITE slave: Write data ready
--   S_AXI_BRESP                  -- AXI4LITE slave: Response
--   S_AXI_BVALID                 -- AXI4LITE slave: Resonse valid
--   S_AXI_AWREADY                -- AXI4LITE slave: Wrte address ready
------------------------------------------------------------------------------

entity battle_city_periph is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER ports added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
		clk_24MHz_i		: in  std_logic; -- TODO Remote this later. Also remove from MPD file.
		rst_in			: in  std_logic; -- TODO Remote this later. Also remove from MPD file.

		vga_clk_o		: out std_logic;
		red_o				: out std_logic_vector(7 downto 0);
		green_o			: out std_logic_vector(7 downto 0);
		blue_o			: out std_logic_vector(7 downto 0);
		blank_on			: out std_logic;
		h_sync_on		: out std_logic;
		v_sync_on		: out std_logic;
		sync_on			: out std_logic;
		pow_save_on		: out std_logic;
		
		interrupt_o		: out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of S_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN       : signal is "Rst";
end entity battle_city_periph;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of battle_city_periph is
	
	

	constant BASE_ADDR : signed(C_S_AXI_ADDR_WIDTH-1 downto 0) := signed(C_BASEADDR);
	subtype t_addr is signed(C_S_AXI_ADDR_WIDTH-1 downto 2);
	subtype t_word is std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	
	
	signal accept_write     : std_logic;
	signal r_write_response : std_logic;
	
	signal local_write_addr : t_addr;
	signal write_regs_en    : boolean;
	signal we_en : std_logic;
	
	
	
	-- Same as in battle_city_standalone BELOW THIS LINE ------------------
	constant ADDR_WIDTH : natural := 13;

	signal clk_100MHz			: std_logic;
	signal n_reset				: std_logic;
	
	signal rgb_s					: std_logic_vector(23 downto 0);
 	signal pixel_x_s				: unsigned(9 downto 0);
	signal pixel_y_s				: unsigned(8 downto 0);
	signal phase_s					: unsigned(1 downto 0);
	
	signal bus_addr		      : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal bus_data            : std_logic_vector(31 downto 0);
	signal bus_we              : std_logic;
	
begin

-------------  ovo je nas interrupt   ---------------------

--process(pixel_y) begin
--	if pixel_y_= "111100000" then
--		interrupt_o	<= '1';
--	else
--		interrupt_o	<= '0';
--	end if;
--	
--end process;

-------------------------------------------------------------
	
	vga_ctrl_i : entity vga_ctrl
		port map
		(
			i_clk_100MHz   => clk_100MHz,
			in_reset       => n_reset,
			
			o_phase			=> phase_s,
			o_pixel_x		=> pixel_x_s,
			o_pixel_y		=> pixel_y_s, 
			i_red				=> rgb_s(7 downto 0),
			i_green			=> rgb_s(15 downto 8),
			i_blue			=> rgb_s(23 downto 16),

			o_vga_clk		=> vga_clk_o,
			o_red				=> red_o,
			o_green			=> green_o,
			o_blue			=> blue_o,
			on_blank			=> blank_on,
			on_h_sync		=> h_sync_on,
			on_v_sync		=> v_sync_on,
			on_sync			=> sync_on,
			on_pow_save		=> pow_save_on
		);
		
	battle_city_i : entity battle_city
		port map
		(
			clk_i				=> clk_100MHz,
			rst_n_i			=> n_reset,
			pixel_row_i		=> pixel_y_s,
			pixel_col_i		=> pixel_x_s,
			bus_addr_i		=> bus_addr,
			bus_data_i		=> bus_data,
			bus_we_i			=> bus_we,
			phase_i			=> phase_s,
			rgb_o				=> rgb_s
		);
    -- Same as in battle_city_standalone ABOVE THIS LINE ------------------


	clk_100MHz <= S_AXI_ACLK;
	n_reset <= S_AXI_ARESETN;
			
	-- Read transaction.

    S_AXI_ARREADY <= '0';
    S_AXI_RDATA <= (others => '0');
    S_AXI_RRESP <= (others => '0');
    S_AXI_RVALID <= '0';
	 
	 

	-- Write transaction.
	
	-- When both valid signals are asserted and response is not in progress
	-- then say valid to master, write data and give response.
	
	accept_write <= S_AXI_AWVALID and S_AXI_WVALID and not r_write_response;
	S_AXI_AWREADY <= accept_write;
	S_AXI_WREADY <= accept_write;
	
	local_write_addr <= signed(S_AXI_AWADDR(t_addr'range)) - BASE_ADDR(t_addr'range);
	write_regs_en <= accept_write = '1' and local_write_addr(t_addr'left downto ADDR_WIDTH+2) = 0;
	we_en <= '1' when write_regs_en else '0';

	write_regs: process(S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				--r_regs <= (others => (others => '0'));
				r_write_response <= '0';
			else
				if accept_write = '1' then
					r_write_response <= '1';
				else
					if S_AXI_BREADY = '1' then
						r_write_response <= '0';
					end if;
				end if;
			end if;
		end if;
	end process write_regs;
	
	S_AXI_BRESP  <= "00"; -- Always OK response.
	S_AXI_BVALID <= r_write_response;
	
	bus_addr <= std_logic_vector(local_write_addr(ADDR_WIDTH+1 downto 2));
	bus_data <= S_AXI_WDATA;
	bus_we <= we_en;

end IMP;
