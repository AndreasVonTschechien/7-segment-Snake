library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_layer is
    Port ( clk : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btnl : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end top_layer;

architecture Behavioral of top_layer is

    component debounce is
        port ( clk : in std_logic;
               rst : in std_logic;
               btn_in : in std_logic;
               btn_state : out std_logic;
               btn_press : out std_logic;
               btn_release: out std_logic);
    end component debounce;

    component counter is
        generic ( G_BITS : positive := 3 );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

    component control_logic is
        port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               btn_up : in STD_LOGIC;
               btn_down : in STD_LOGIC;
               btn_right : in STD_LOGIC;
               btn_left : in STD_LOGIC;
               direction_up : out STD_LOGIC;
               direction_down : out STD_LOGIC;
               direction_right : out STD_LOGIC;
               direction_left : out STD_LOGIC);
    end component control_logic;

    component movement_logic is
        Port ( clk : in STD_LOGIC;
               ce : in STD_LOGIC;
               rst : in STD_LOGIC; 
               direction_up : in STD_LOGIC;
               direction_down : in STD_LOGIC;
               direction_right : in STD_LOGIC;
               direction_left : in STD_LOGIC;
               cnt_seg : in std_logic_vector(2 downto 0);
               cnt_an : in std_logic_vector(2 downto 0);
               data_seg : out std_logic_vector(6 downto 0);
               data_an  : out std_logic_vector(7 downto 0));
    end component movement_logic;

    signal sig_press_up : std_logic;
    signal sig_press_down : std_logic;
    signal sig_press_right : std_logic;
    signal sig_press_left : std_logic;
    
    signal sig_direction_up : std_logic;
    signal sig_direction_down : std_logic;
    signal sig_direction_right : std_logic;
    signal sig_direction_left : std_logic;

    signal sig_ce_game : std_logic;
    signal sig_ce_rnd_seg : std_logic;
    signal sig_ce_rnd_an  : std_logic;

    signal sig_rnd_seg : std_logic_vector(2 downto 0);
    signal sig_rnd_an  : std_logic_vector(2 downto 0);

    signal sig_data_seg : std_logic_vector(6 downto 0);
    signal sig_data_an  : std_logic_vector(7 downto 0);

begin

    debounce_0 : debounce 
        port map (clk => clk, 
                  rst => btnc, 
                  btn_in => btnu, 
                  btn_press => sig_press_up);
              
    debounce_1 : debounce 
        port map (clk => clk, 
                  rst => btnc, 
                  btn_in => btnd, 
                  btn_press => sig_press_down);
              
    debounce_2 : debounce 
        port map (clk => clk, 
                  rst => btnc, 
                  btn_in => btnr, 
                  btn_press => sig_press_right);
                  
    debounce_3 : debounce 
        port map (clk => clk, 
                  rst => btnc, 
                  btn_in => btnl, 
                  btn_press => sig_press_left);

    control_logic_0 : control_logic
        port map (
            clk => clk,
            rst => btnc,
            btn_up => sig_press_up,
            btn_down => sig_press_down,
            btn_right => sig_press_right,
            btn_left => sig_press_left,
            direction_up => sig_direction_up,
            direction_down => sig_direction_down,
            direction_right => sig_direction_right,
            direction_left => sig_direction_left
        );

    clk_0 : clk_en 
            generic map (G_MAX => 50000000) 
            port map (clk => clk, 
                      rst => btnc, 
                      ce => sig_ce_game);
                  
    clk_1_seg : clk_en 
        generic map (G_MAX => 123) 
        port map (clk => clk, 
                  rst => btnc, 
                  ce => sig_ce_rnd_seg);
              
    clk_1_an  : clk_en 
        generic map (G_MAX => 137) 
        port map (clk => clk, 
                  rst => btnc, 
                  ce => sig_ce_rnd_an);

    cnt_seg_0 : counter 
        generic map (G_BITS => 3) 
        port map (clk => clk, 
                  rst => btnc, 
                  en => sig_ce_rnd_seg, 
                  cnt => sig_rnd_seg);
              
    cnt_an_0  : counter 
        generic map (G_BITS => 3) 
        port map (clk => clk, 
                  rst => btnc, 
                  en => sig_ce_rnd_an,  
                  cnt => sig_rnd_an);
              
    movement_logic_0 : movement_logic
        port map (
            clk => clk,
            ce => sig_ce_game,
            rst => btnc,
            direction_up => sig_direction_up,
            direction_down => sig_direction_down,
            direction_right => sig_direction_right,
            direction_left => sig_direction_left,
            cnt_seg => sig_rnd_seg,
            cnt_an => sig_rnd_an,
            data_seg => sig_data_seg,
            data_an => sig_data_an
        );

    seg <= sig_data_seg(6 downto 0);
    an  <= sig_data_an(7 downto 0);

end Behavioral;