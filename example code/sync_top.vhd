library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sync_top is
    Port ( 
        clk_in : in std_logic;
        input0 : in std_logic;
        output0 : out std_logic
    );
end sync_top;

architecture Behavioral of sync_top is

component sync is
    Port ( 
        clk : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end component;

begin

SYNCH : sync
    Port map ( 
        clk => clk_in,
        input => input0,
        output => output0
    );


end Behavioral;
