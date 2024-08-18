library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;



entity gth_top is
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
end gth_top;

architecture Behavioral of gth_top is

component gth is
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
end component;

COMPONENT vio_0
    port(
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC;
        probe_in1 : IN STD_LOGIC;
        probe_in2 : IN STD_LOGIC;
        probe_in3 : IN STD_LOGIC;
        probe_out0 : OUT STD_LOGIC;
        probe_out1 : OUT STD_LOGIC;
        probe_out2 : OUT STD_LOGIC;
        probe_out3 : OUT STD_LOGIC
        ) ;
END COMPONENT;


COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;

	probe0 : IN STD_LOGIC; 
	probe1 : IN STD_LOGIC; 
	probe2 : IN STD_LOGIC;
	probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	probe4 : in std_logic_vector(31 downto 0)
);
END COMPONENT  ;


component clk_freerun is
    Port ( 
        clk_in_p : in std_logic;
        clk_in_n : in std_logic;
        clk_freerun : out std_logic
    );
end component;

signal active_tx_async, active_rx_async : std_logic;
signal active_tx, active_rx : std_logic;

-- clocks
signal gth_rx_clk_s : std_logic;
signal gth_tx_clk_s : std_logic;
signal rx_buf_gt_clk_s : std_logic;
signal tx_buf_gt_clk_s : std_logic;
signal clk_freerun_s : std_logic;
signal clk_gtref : std_logic;

-- DEBUG
signal vio_tx_en :  std_logic;
signal vio_tx_pll_en :  std_logic;
signal vio_rx_en :  std_logic;
signal vio_rx_pll_en :  std_logic;        
signal vio_gtpowergood_out :  std_logic;
signal vio_rxpmaresetdone_out :  std_logic;
signal vio_txpmaresetdone_out :  std_logic;
signal data_out_s : std_logic_VECTOR(31 DOWNTO 0);

begin

    tx_clk_out <= tx_buf_gt_clk_s;
    rx_clk_out <= rx_buf_gt_clk_s; 
    data_out <= data_out_s;

-- DEBUG

VIO : vio_0
      port map(
        clk => rx_buf_gt_clk_s,
        probe_in0 => vio_gtpowergood_out,
        probe_in1 => vio_rxpmaresetdone_out,
        probe_in2 => vio_txpmaresetdone_out,
        probe_in3 => rst_n,
        probe_out0 => vio_tx_en,
        probe_out1 => vio_tx_pll_en,
        probe_out2 => vio_rx_en,
        probe_out3 => vio_rx_pll_en
     );
      
ILA : ila_0
PORT MAP (
	clk => rx_buf_gt_clk_s,



	probe0 => vio_tx_en,  
	probe1 => vio_tx_pll_en, 
	probe2 => vio_rx_en,
	probe3 => data_out_s,
	probe4 => data_in
);

-- synch

ACT_TX : process(tx_buf_gt_clk_s, rst_n)
    begin
        if rst_n = '0' then
            active_tx_async <= '0';
            active_tx <= '0';
        elsif rising_edge(tx_buf_gt_clk_s) then  
            active_tx_async <= '1';
            active_tx <= active_tx_async;
        end if;
    end process;

ACT_RX : process(rx_buf_gt_clk_s, rst_n)
    begin
        if rst_n = '0' then
            active_rx_async <= '0';
            active_rx <= '0';
        elsif rising_edge(rx_buf_gt_clk_s) then  
            active_rx_async <= '1';
            active_rx <= active_rx_async;
        end if;
    end process;
    


-- clk

implt_clk_freerun : clk_freerun
    Port map ( 
        clk_in_p => clk_in_p,
        clk_in_n => clk_in_n,
        clk_freerun => clk_freerun_s
    );
    
    
 impl_IBUFDS_GTE3 : IBUFDS_GTE3 
    generic map(
    REFCLK_EN_TX_PATH  => '0',
    REFCLK_HROW_CK_SEL => "00",
    REFCLK_ICNTL_RX    => "00"
  )
  port map (
    I     => mgt_clk_in_p,
    IB   => mgt_clk_in_n,
    CEB   => '0',
    O    => clk_gtref
  );   
    
impl_RX_BUFG_GT : BUFG_GT 
    port map (
        CE      => '1',
        CEMASK  => '0',
        CLR     => '0',
        CLRMASK => '0',
        DIV     => "000",
        I       => gth_rx_clk_s,
        O       => rx_buf_gt_clk_s
      );

impl_TX_BUFG_GT : BUFG_GT 
    port map (
        CE      => '1',
        CEMASK  => '0',
        CLR     => '0',
        CLRMASK => '0',
        DIV     => "000",
        I       => gth_tx_clk_s,
        O       => tx_buf_gt_clk_s
      );


impl_GTH : GTH
  PORT MAP (
    gtwiz_userclk_tx_active_in => active_tx,    --active 1
    gtwiz_userclk_rx_active_in => active_rx,    --active 1
    gtwiz_reset_clk_freerun_in => clk_freerun_s,  -- board clock
    gtwiz_reset_all_in => rst_n,
    gtwiz_reset_tx_pll_and_datapath_in => vio_tx_pll_en,    -- vio
    gtwiz_reset_tx_datapath_in => vio_tx_en,                -- vio
    gtwiz_reset_rx_pll_and_datapath_in => vio_rx_pll_en,    -- vio
    gtwiz_reset_rx_datapath_in => vio_rx_en,                -- vio
    gtwiz_userdata_tx_in => data_in,
    gtwiz_userdata_rx_out => data_out_s,
    gtrefclk00_in => clk_gtref,    -- gth clock reference, only for test
    gthrxn_in => gthrxn_in,      -- entrada no definida (dejar al aire)
    gthrxp_in => gthrxp_in,      -- entrada no definida (dejar al aire)
    rxusrclk_in => rx_buf_gt_clk_s,    -- gth clock x N canales
    rxusrclk2_in => rx_buf_gt_clk_s,   -- gth clock 2 x N canales
    txusrclk_in => tx_buf_gt_clk_s,    -- gth clock x N canales
    txusrclk2_in => tx_buf_gt_clk_s,    -- gth clock x N canales
    gthtxn_out => gthtxn_out,     -- salida no definida (dejar al aire)
    gthtxp_out => gthtxp_out,     -- salida no definida (dejar al aire)
    gtpowergood_out => vio_gtpowergood_out,    -- a un vio
    rxoutclk_out => gth_rx_clk_s,   -- reloj a BUFG_GT
    rxpmaresetdone_out => vio_rxpmaresetdone_out, -- a un vio
    txoutclk_out => gth_tx_clk_s,       -- reloj a BUFG_GT
    txpmaresetdone_out => vio_txpmaresetdone_out  -- a un vio
  );

end Behavioral;
