----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Steffen Mauch [steffen.mauch (at) gmail.com]
-- Create Date:    10:33:30 11/28/2013 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name:   si5338-vhdl implementation
-- Target Devices: Xilinx Kintex-7
-- Tool versions: 
-- Description: 		LICENSE: BSD!
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
--
-- The MIT License (MIT)
--
-- Copyright (c) 2014 Steffen Mauch
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity main is
PORT(
    CPLD_XIO_clk		: in  std_logic;
    --reset	  			: in  std_logic;
	 
	 LED 					: out std_logic_vector( 7 downto 0 );
	 BOARD_LED_RED		: out std_logic;
	 BOARD_LED_GREEN	: out std_logic;
	 SI5338_SCL			: inout std_logic;
	 SI5338_SDA			: inout std_logic;
	 CLK0_SI5338		: in  std_logic;
	 SI5338_CLK_EN		: out std_logic;
	 SI5338_IN4			: out std_logic
	 );
end main;

architecture Behavioral of main is

component si5338 is
	GENERIC(
    input_clk 		: INTEGER := 50_000_000; --input clock speed from user logic in Hz
	 i2c_address	: std_logic_vector(6 downto 0) := "111" & "0000";
    bus_clk   		: INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
	port
		(
			clk     		: in std_logic;
			reset			: in std_logic;
			
			done			: out std_logic;
			error			: out std_logic;
						
			SCL 			: inout std_logic;
			SDA 			: inout std_logic
		);
end component;

signal done : std_logic;
signal reset_internal : std_logic;

signal error : std_logic;

signal clk0 : std_logic;

begin

IBUFG_inst : IBUFG
port map (
   O => clk0,  				-- Clock buffer output
   I => CLK0_SI5338
);


SI5338_IN4 <= '0';
SI5338_CLK_EN <= '1';

reset_internal <= '0';

BOARD_LED_RED <= '1';
BOARD_LED_GREEN <= '0';

LED(7) <= error;
LED( 6 downto 4 ) <= "101";
LED(3) <= clk0;
LED(2) <= SI5338_SCL;
LED(1) <= CPLD_XIO_clk;
LED(0) <= done;

si5338_inst : si5338 
	generic map(
		input_clk 		=> 25_000_000, --input clock speed from user logic in Hz
		i2c_address		=> "111" & "0000",
		bus_clk   		=> 400_000    --speed the i2c bus (scl) will run at in Hz
	)
	port map(
		clk     		=> CPLD_XIO_clk,
		reset			=> reset_internal,
				
		done			=> done,
		error			=> error,
		
		SCL 			=> SI5338_SCL,
		SDA 			=> SI5338_SDA
	);



end Behavioral;

