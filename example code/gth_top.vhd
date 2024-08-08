library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;



entity gth_top is
    Port ( 
        gth_ref : in std_logic;
        rst_n : in std_logic;
        clk_freerun : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0);
        -- vio
        vio_tx_en : in std_logic;
        vio_tx_pll_en : in std_logic;
        vio_rx_en : in std_logic;
        vio_rx_pll_en : in std_logic;        
        vio_gtpowergood_out : out std_logic;
        vio_rxpmaresetdone_out : out std_logic;
        vio_txpmaresetdone_out : out std_logic;
        -- unconnected
        gthrxn_in : in std_logic;
        gthrxp_in : in std_logic;
        gthtxn_out : out std_logic;
        gthtxp_out : out std_logic
    );
end gth_top;

architecture Behavioral of gth_top is

COMPONENT gtwizard_ultrascale_0
  PORT (
    gtwiz_userclk_tx_active_in : IN STD_LOGIC;
    gtwiz_userclk_rx_active_in : IN STD_LOGIC;
    gtwiz_reset_clk_freerun_in : IN STD_LOGIC;
    gtwiz_reset_all_in : IN STD_LOGIC;
    gtwiz_reset_tx_pll_and_datapath_in : IN STD_LOGIC;
    gtwiz_reset_tx_datapath_in : IN STD_LOGIC;
    gtwiz_reset_rx_pll_and_datapath_in : IN STD_LOGIC;
    gtwiz_reset_rx_datapath_in : IN STD_LOGIC;
    gtwiz_reset_rx_cdr_stable_out : OUT STD_LOGIC;
    gtwiz_reset_tx_done_out : OUT STD_LOGIC;
    gtwiz_reset_rx_done_out : OUT STD_LOGIC;
    gtwiz_userdata_tx_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    gtwiz_userdata_rx_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    gtrefclk00_in : IN STD_LOGIC;
    qpll0outclk_out : OUT STD_LOGIC;
    qpll0outrefclk_out : OUT STD_LOGIC;
    gthrxn_in : IN STD_LOGIC;
    gthrxp_in : IN STD_LOGIC;
    rxusrclk_in : IN STD_LOGIC;
    rxusrclk2_in : IN STD_LOGIC;
    txusrclk_in : IN STD_LOGIC;
    txusrclk2_in : IN STD_LOGIC;
    gthtxn_out : OUT STD_LOGIC;
    gthtxp_out : OUT STD_LOGIC;
    gtpowergood_out : OUT STD_LOGIC;
    rxoutclk_out : OUT STD_LOGIC;
    rxpmaresetdone_out : OUT STD_LOGIC;
    txoutclk_out : OUT STD_LOGIC;
    txpmaresetdone_out : OUT STD_LOGIC
  );
END COMPONENT;

signal active_tx_async, active_rx_async : std_logic;
signal active_tx, active_rx : std_logic;
signal gth_rx_clk, gth_tx_clk : std_logic;
signal rx_buf_gt_clk : std_logic;
signal tx_buf_gt_clk : std_logic;

begin


-- separar frecuencias en caso de tener dos frecuencias diferentes
ACT_TX : process(clk_freerun, rst_n)
    begin
        if rst_n = '0' then
            active_tx_async <= '0';
            active_tx <= '0';
        elsif rising_edge(clk_freerun) then  
            active_tx_async <= '1';
            active_tx <= active_tx_async;
        end if;
    end process;

ACT_RX : process(clk_freerun, rst_n)
    begin
        if rst_n = '0' then
            active_rx_async <= '0';
            active_rx <= '0';
        elsif rising_edge(clk_freerun) then  
            active_rx_async <= '1';
            active_rx <= active_rx_async;
        end if;
    end process;
    
    
    
    
    
impl_RX_BUFG_GT : BUFG_GT 
    port map (
        CE      => '1',
        CEMASK  => '0',
        CLR     => '0',
        CLRMASK => '0',
        DIV     => "000",
        I       => gth_rx_clk,
        O       => rx_buf_gt_clk
      );

impl_TX_BUFG_GT : BUFG_GT 
    port map (
        CE      => '1',
        CEMASK  => '0',
        CLR     => '0',
        CLRMASK => '0',
        DIV     => "000",
        I       => gth_tx_clk,
        O       => tx_buf_gt_clk
      );


GTH : gtwizard_ultrascale_0
  PORT MAP (
    gtwiz_userclk_tx_active_in => active_tx,    --active 1
    gtwiz_userclk_rx_active_in => active_rx,    --active 1
    gtwiz_reset_clk_freerun_in => clk_freerun,  -- board clock
    gtwiz_reset_all_in => rst_n,
    gtwiz_reset_tx_pll_and_datapath_in => vio_tx_pll_en,    -- vio
    gtwiz_reset_tx_datapath_in => vio_tx_en,                -- vio
    gtwiz_reset_rx_pll_and_datapath_in => vio_rx_pll_en,    -- vio
    gtwiz_reset_rx_datapath_in => vio_rx_en,                -- vio
    gtwiz_reset_rx_cdr_stable_out => open,
    gtwiz_reset_tx_done_out => open,
    gtwiz_reset_rx_done_out => open,
    gtwiz_userdata_tx_in => data_in,
    gtwiz_userdata_rx_out => data_out,
    gtrefclk00_in => gth_ref,    -- gth clock reference, only for test
    qpll0outclk_out => open,
    qpll0outrefclk_out => open,
    gthrxn_in => gthrxn_in,      -- entrada no definida (dejar al aire)
    gthrxp_in => gthrxp_in,      -- entrada no definida (dejar al aire)
    rxusrclk_in => rx_buf_gt_clk,    -- gth clock x N canales
    rxusrclk2_in => rx_buf_gt_clk,   -- gth clock 2 x N canales
    txusrclk_in => tx_buf_gt_clk,    -- gth clock x N canales
    txusrclk2_in => tx_buf_gt_clk,    -- gth clock x N canales
    gthtxn_out => gthtxn_out,     -- salida no definida (dejar al aire)
    gthtxp_out => gthtxp_out,     -- salida no definida (dejar al aire)
    gtpowergood_out => vio_gtpowergood_out,    -- a un vio
    rxoutclk_out => gth_rx_clk,   -- reloj a BUFG_GT
    rxpmaresetdone_out => vio_rxpmaresetdone_out, -- a un vio
    txoutclk_out => gth_tx_clk,       -- reloj a BUFG_GT
    txpmaresetdone_out => vio_txpmaresetdone_out  -- a un vio
  );

end Behavioral;
