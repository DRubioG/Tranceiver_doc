library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity clk_freerun is
    Port ( 
        clk_in_p : in std_logic;
        clk_in_n : in std_logic;
        clk_freerun : out std_logic
    );
end clk_freerun;

architecture arch_clk_freerun of clk_freerun is

component clk_wiz_0
    port(
        clk_out1          : out    std_logic;
        clk_in1           : in     std_logic
     );
end component;

signal clk_100MHz : std_logic;
signal clk_in : std_logic;

begin

impl_IBUFGDS : IBUFGDS
    port map(
        I => clk_in_p,
        IB => clk_in_n,
        O => clk_in
    );
    
    
PLL : clk_wiz_0
   port map ( 
       clk_out1 => clk_100MHz,
       clk_in1 => clk_in
     );
 
impl_IBUF :  IBUF 
    port map(
       I => clk_100MHz,
       O => clk_freerun
    );


end arch_clk_freerun;
