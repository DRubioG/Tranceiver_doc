library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sync is
    Port ( 
        clk : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end sync;

architecture Behavioral of sync is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            output <= input;
        end if;
    end process;


end Behavioral;
