library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;


entity example_top is
    Port ( 
        gth_clk_n : in std_logic;
        gth_clk_p : in std_logic;
        clk_in_n : in std_logic;
        clk_in_p : in std_logic;
        rst_n : in std_logic;
        -- unconnected
        gthrxn_in : in std_logic;
        gthrxp_in : in std_logic;
        gthtxn_out : out std_logic;
        gthtxp_out : out std_logic
    );
end example_top;

architecture Behavioral of example_top is

component gth_top is
    Port ( 
        clk_in_p : in std_logic;
        clk_in_n : in std_logic;
        mgt_clk_in_p : in std_logic;
        mgt_clk_in_n : in std_logic;
        rst_n : in std_logic;
        rx_clk_out : out std_logic;
        data_in : in std_logic_vector(31 downto 0);
        tx_clk_out : out std_logic;
        data_out : out std_logic_vector(31 downto 0);
        -- unconnected
        gthrxn_in : in std_logic;
        gthrxp_in : in std_logic;
        gthtxn_out : out std_logic;
        gthtxp_out : out std_logic
    );
end component;

component send_message is
    Port ( 
        clk : in std_logic;
        rst_n : in std_logic;
        data : out std_logic_vector(31 downto 0) 
    );
end component;


signal data_in : std_logic_vector(31 downto 0);
signal data_out : std_logic_vector(31 downto 0);
signal clk_gth_ref : std_logic;
signal clk_tx_c : std_logic;
signal clk_rx_c : std_logic;

begin


SEND : send_message
    Port map ( 
        clk => clk_tx_c,
        rst_n => rst_n,
        data => data_in 
    );




impl_gth_top : gth_top
    Port map ( 
        clk_in_p => clk_in_p,
        clk_in_n => clk_in_n,
        mgt_clk_in_p => gth_clk_p,
        mgt_clk_in_n => gth_clk_n,
        rst_n => rst_n,
        rx_clk_out => clk_rx_c,
        data_in => data_in,
        tx_clk_out => clk_tx_c,
        data_out => data_out,
        -- unconnected
        gthrxn_in => gthrxn_in,
        gthrxp_in => gthrxp_in,
        gthtxn_out => gthtxn_out,
        gthtxp_out => gthtxp_out
    );

end Behavioral;
