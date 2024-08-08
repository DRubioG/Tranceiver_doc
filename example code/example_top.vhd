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
end component;

component send_message is
    Port ( 
        clk : in std_logic;
        rst_n : in std_logic;
        data : out std_logic_vector(31 downto 0) --;
--        tx_paket_req : in std_logic
    );
end component;


COMPONENT vio_0
    port(
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC;
        probe_in1 : IN STD_LOGIC;
        probe_in2 : IN STD_LOGIC;
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
	probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT  ;

component clk_wiz_0
port
 (
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;


signal clk_freerun : std_logic;
signal clk_100MHz : std_logic;
signal data_in : std_logic_vector(31 downto 0);
signal data_out : std_logic_vector(31 downto 0);
signal clk_gth_ref : std_logic;
signal clk_in : std_logic;

signal vio_tx_en :  std_logic;
signal vio_tx_pll_en :  std_logic;
signal vio_rx_en :  std_logic;
signal vio_rx_pll_en :  std_logic;        
signal vio_gtpowergood_out :  std_logic;
signal vio_rxpmaresetdone_out :  std_logic;
signal vio_txpmaresetdone_out :  std_logic;

begin

impl_IBUFGDS : IBUFGDS
    port map(
        I => clk_in_p,
        IB => clk_in_n,
        O => clk_in
    );
    
    
PLL : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_100MHz,
   -- Clock in ports
   clk_in1 => clk_in
 );
 
impl_IBUF :  IBUF 
    port map(
   I => clk_100MHz,
   O => clk_freerun
);

impl_IBUFDS_GTE3 : IBUFDS_GTE3 
    generic map(
    REFCLK_EN_TX_PATH  => '0',
    REFCLK_HROW_CK_SEL => "00",
    REFCLK_ICNTL_RX    => "00"
  )
  port map (
    I     => gth_clk_p,
    IB   => gth_clk_n,
    CEB   => '0',
    O    => clk_gth_ref
  );


SEND : send_message
    Port map ( 
        clk => clk_freerun,
        rst_n => rst_n,
        data => data_in --,
--        tx_paket_req =>
    );


VIO : vio_0
      port map(
        clk => clk_freerun,
        probe_in0 => vio_gtpowergood_out,
        probe_in1 => vio_rxpmaresetdone_out,
        probe_in2 => vio_txpmaresetdone_out,
        probe_out0 => vio_tx_en,
        probe_out1 => vio_tx_pll_en,
        probe_out2 => vio_rx_en,
        probe_out3 => vio_rx_pll_en
     );
      
      ILA : ila_0
PORT MAP (
	clk => clk_freerun,



	probe0 => vio_tx_en,  
	probe1 => vio_tx_pll_en, 
	probe2 => vio_rx_en,
	probe3 => data_out
);


GTH : gth_top
    Port map ( 
        gth_ref => clk_gth_ref,
        rst_n => rst_n,
        clk_freerun => clk_freerun,
        data_in => data_in,
        data_out => data_out,
        -- vio
        vio_tx_en => vio_tx_en,
        vio_tx_pll_en => vio_tx_pll_en,
        vio_rx_en => vio_rx_en,
        vio_rx_pll_en => vio_rx_pll_en,
        vio_gtpowergood_out => vio_gtpowergood_out,
        vio_rxpmaresetdone_out => vio_rxpmaresetdone_out,
        vio_txpmaresetdone_out => vio_txpmaresetdone_out,
        -- unconnected
        gthrxn_in => gthrxn_in,
        gthrxp_in => gthrxp_in,
        gthtxn_out => gthtxn_out,
        gthtxp_out => gthtxp_out
    );

end Behavioral;
