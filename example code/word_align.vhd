library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity word_align is
    Port ( 
        clk : in std_logic;
        rst_n : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end word_align;

architecture arch_word_align of word_align is

signal data_in_reg : std_logic_vector(31 downto 0);
signal align : std_logic;
begin
    
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            data_in_reg <= (others=>'0');
        elsif rising_edge(clk) then
            data_in_reg <= data_in;
        end if;
    end process; 
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            align <= '1';
        elsif rising_edge(clk) then
            if data_in(7 downto 0) = x"BC" then
                align <= '1';
            else
                align <='0'; 
            end if;
        end if;
    end process;
    
    data_out <= data_in when align = '1' else
                data_in(15 downto 0) & data_in_reg(31 downto 16);


end arch_word_align;
