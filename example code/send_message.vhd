library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity send_message is
    Port ( 
        clk : in std_logic;
        rst_n : in std_logic;
        data : out std_logic_vector(31 downto 0);
        ctrl : out std_logic_vector(3 downto 0)
    );
end send_message;

architecture Behavioral of send_message is

type fsm is (IDLE, SEND_CORRECTION, SEND_DUMMY, SEND_HEADER, SEND_SEQ_NUM, SEND_CTRL, SEND_DATA, SEND_CHECK, SEND_DATA_END);
signal state : fsm;
signal cont : unsigned(31 downto 0);
signal data_s : std_logic_vector(31 downto 0);
signal ctrl_s : std_logic_vector(3 downto 0);


begin

    data <= data_s;
    ctrl <= ctrl_s;
    
    process(rst_n, clk)
    begin
        if rst_n = '0' then
            state <= IDLE;
            data_s <= (others=>'0');
            ctrl_s <= (others=>'0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    state <= SEND_CORRECTION;
                when SEND_CORRECTION =>
                    data_s <= x"F7F7F7F7";
                    state <= SEND_DUMMY;
                    ctrl_s <= (others=>'1');
                when SEND_DUMMY =>
                    data_s <= x"FF000055";
                    state <= SEND_HEADER;
                    ctrl_s <= (others=>'0');
                when SEND_HEADER =>
                    data_s <= x"FF0000BC";
                    state <= SEND_SEQ_NUM;
                    ctrl_s <= (0=>'1', others=>'0');
                when SEND_SEQ_NUM =>
                    data_s <= (others=>'0');
                    state <= SEND_CTRL;
                    ctrl_s <= (others=>'0');
                when SEND_CTRL =>
                    data_s <= (0=>'1', 31=> '1',others=>'0');
                    state <= SEND_DATA;
                    ctrl_s <= (others=>'0');
                when SEND_DATA =>
                    data_s <= std_logic_vector(cont); -- & std_logic_vector(cont) & std_logic_vector(cont) & std_logic_vector(cont);
                    ctrl_s <= (others=>'0'); 
                    if cont = x"000000FF" then
                        state <= SEND_DATA_END;
                    end if;
                when SEND_DATA_END =>
                    data_s <= (0=>'1', others=>'0');  
                    state <= SEND_CHECK;           
                    ctrl_s <= (others=>'0');       
                when SEND_CHECK =>
                    data_s <= (others=>'0');
                    ctrl_s <= (others=>'0');
                    state <= IDLE;
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
