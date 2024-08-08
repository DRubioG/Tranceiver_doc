library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity send_message is
    Port ( 
        clk : in std_logic;
        rst_n : in std_logic;
        data : out std_logic_vector(31 downto 0) --;
--        tx_paket_req : in std_logic
    );
end send_message;

architecture Behavioral of send_message is

type fsm is (IDLE, SEND_CORRECTION, SEND_DUMMY, SEND_HEADER, SEND_SEQ_NUM, SEND_CTRL, SEND_DATA, SEND_CHECK, SEND_DATA_END);
signal state : fsm;
signal cont : unsigned(7 downto 0);

begin
    
    process(rst_n, clk)
    begin
        if rst_n = '0' then
            state <= IDLE;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
--                    if tx_paket_req = '1' then
                        state <= SEND_CORRECTION;
--                    end if;
                when SEND_CORRECTION =>
                    data <= x"F7F7F7F7";
                    state <= SEND_DUMMY;
                when SEND_DUMMY =>
                    data <= x"FF000055";
                    state <= SEND_HEADER;
                when SEND_HEADER =>
                    data <= x"FF0000BC";
                    state <= SEND_SEQ_NUM;
                when SEND_SEQ_NUM =>
                    data <= (others=>'0');
                    state <= SEND_CTRL;
                when SEND_CTRL =>
                    data <= (0=>'1', 31=> '1',others=>'0');
                    state <= SEND_DATA;
                when SEND_DATA =>
                    data <= std_logic_vector(cont) & std_logic_vector(cont) & std_logic_vector(cont) & std_logic_vector(cont);
                    if cont = (cont'range=>'1') then
                        state <= SEND_CHECK;
                    end if;
                when SEND_CHECK =>
                    data <= (0=>'1', others=>'0');                    
                when SEND_DATA_END =>
                    data <= (others=>'0');
            end case;
        end if;
    end process;
    
    process(rst_n, clk, state)
    begin
        if rst_n = '0' then
            cont <= (others=>'0');
        elsif rising_edge(clk) then
            if state = SEND_DATA then
                cont <= cont+1;
            else
                cont <= (others=>'0');
            end if;
        end if;
    end process;


end Behavioral;
