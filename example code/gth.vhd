library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gth is
    Port (
        gtwiz_userclk_tx_active_in : IN STD_LOGIC;
        gtwiz_userclk_rx_active_in : IN STD_LOGIC;
        gtwiz_reset_clk_freerun_in : IN STD_LOGIC;
        gtwiz_reset_all_in : IN STD_LOGIC;
        gtwiz_reset_tx_pll_and_datapath_in : IN STD_LOGIC;
        gtwiz_reset_tx_datapath_in : IN STD_LOGIC;
        gtwiz_reset_rx_pll_and_datapath_in : IN STD_LOGIC;
        gtwiz_reset_rx_datapath_in : IN STD_LOGIC;
        gtwiz_userdata_tx_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        gtwiz_userdata_rx_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        gtrefclk00_in : IN STD_LOGIC;
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
end gth;

architecture arch_gth of gth is

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

signal rst : std_logic;

begin

rst <= not gtwiz_reset_all_in;

impl_gtwizard_ultrascale_0 : gtwizard_ultrascale_0
  PORT MAP (
    gtwiz_userclk_tx_active_in => gtwiz_userclk_tx_active_in,    --active 1
    gtwiz_userclk_rx_active_in => gtwiz_userclk_rx_active_in,    --active 1
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,  -- board clock
    gtwiz_reset_all_in => rst,
    gtwiz_reset_tx_pll_and_datapath_in => gtwiz_reset_tx_pll_and_datapath_in,    -- vio
    gtwiz_reset_tx_datapath_in => gtwiz_reset_tx_datapath_in,                -- vio
    gtwiz_reset_rx_pll_and_datapath_in => gtwiz_reset_rx_pll_and_datapath_in,    -- vio
    gtwiz_reset_rx_datapath_in => gtwiz_reset_rx_datapath_in,                -- vio
    gtwiz_reset_rx_cdr_stable_out => open,
    gtwiz_reset_tx_done_out => open,
    gtwiz_reset_rx_done_out => open,
    gtwiz_userdata_tx_in => gtwiz_userdata_tx_in,
    gtwiz_userdata_rx_out => gtwiz_userdata_rx_out,
    gtrefclk00_in => gtrefclk00_in,    -- gth clock reference, only for test
    qpll0outclk_out => open,
    qpll0outrefclk_out => open,
    gthrxn_in => gthrxn_in,      -- entrada no definida (dejar al aire)
    gthrxp_in => gthrxp_in,      -- entrada no definida (dejar al aire)
    rxusrclk_in => rxusrclk_in,    -- gth clock x N canales
    rxusrclk2_in => rxusrclk2_in,   -- gth clock 2 x N canales
    txusrclk_in => txusrclk_in,    -- gth clock x N canales
    txusrclk2_in => txusrclk2_in,    -- gth clock x N canales
    gthtxn_out => gthtxn_out,     -- salida no definida (dejar al aire)
    gthtxp_out => gthtxp_out,     -- salida no definida (dejar al aire)
    gtpowergood_out => gtpowergood_out,    -- a un vio
    rxoutclk_out => rxoutclk_out,   -- reloj a BUFG_GT
    rxpmaresetdone_out => rxpmaresetdone_out, -- a un vio
    txoutclk_out => txoutclk_out,       -- reloj a BUFG_GT
    txpmaresetdone_out => txpmaresetdone_out  -- a un vio
  );


end arch_gth;
