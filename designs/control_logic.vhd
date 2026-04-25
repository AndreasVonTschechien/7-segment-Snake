library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_logic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_up : in STD_LOGIC;
           btn_down : in STD_LOGIC;
           btn_right : in STD_LOGIC;
           btn_left : in STD_LOGIC;
           direction_up : out STD_LOGIC;
           direction_down : out STD_LOGIC;
           direction_right : out STD_LOGIC;
           direction_left : out STD_LOGIC);
end control_logic;

architecture Behavioral of control_logic is

    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
    
    component debounce is
        port ( clk : in std_logic;
            rst : in std_logic;
            btn_in : in std_logic;
            btn_state : out std_logic;
            btn_press : out std_logic;
            btn_release: out std_logic);
    end component debounce;

    component counter is
        generic ( G_BITS : positive := 3 );  --! Default number of bits
        port (
            clk : in  std_logic;                             --! Main clock
            rst : in  std_logic;                             --! High-active synchronous reset
            en  : in  std_logic;                             --! Clock enable input
            cnt : out std_logic_vector(G_BITS - 1 downto 0));
    end component counter; 
    
    constant C_MAX : positive := 2;
    
    signal sig_press_up : std_logic;
    signal sig_press_down : std_logic;
    signal sig_press_right : std_logic;
    signal sig_press_left : std_logic;
    
    signal sig_direction_up : std_logic;
    signal sig_direction_down : std_logic;
    signal sig_direction_right : std_logic;
    signal sig_direction_left : std_logic;

    signal sig_cnt : std_logic_vector(5 downto 0);
    signal sig_ce_sample : std_logic;         
begin

    debounce_0 : debounce
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_up,
            btn_press => sig_press_up
        );

    debounce_1 : debounce
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_down,
            btn_press => sig_press_down
        );

    debounce_2 : debounce
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_right,
            btn_press => sig_press_right
        );
        
    debounce_3 : debounce
        port map (
            clk => clk,
            rst => rst,
            btn_in => btn_left,
            btn_press => sig_press_left
        );

    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => sig_ce_sample
        );
        
    counter_0 : counter
        generic map ( G_BITS => 6 )
        port map (
            clk => clk,
            rst => rst,
            cnt => sig_cnt,
            en => sig_ce_sample
        );
        
    direction : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_direction_up    <= '0';
                sig_direction_down  <= '0';
                sig_direction_left  <= '0';
                sig_direction_right <= '0'; 
            elsif sig_press_up = '1' and sig_direction_down = '0' then
                sig_direction_up <= '1';
                sig_direction_down <= '0';
                sig_direction_right <= '0';
                sig_direction_left <= '0';
            elsif sig_press_down = '1' and sig_direction_up = '0' then
                sig_direction_up <= '0';
                sig_direction_down <= '1';
                sig_direction_right <= '0';
                sig_direction_left <= '0';
            elsif sig_press_right = '1' and sig_direction_left = '0' then
                sig_direction_up <= '0';
                sig_direction_down <= '0';
                sig_direction_right <= '1';
                sig_direction_left <= '0';
            elsif sig_press_left = '1' and sig_direction_right = '0' then
                sig_direction_up <= '0';
                sig_direction_down <= '0';
                sig_direction_right <= '0';
                sig_direction_left <= '1';
            end if;
        end if;
    end process direction;
    
    direction_up    <= sig_direction_up;
    direction_down  <= sig_direction_down;
    direction_right <= sig_direction_right;
    direction_left  <= sig_direction_left;
end Behavioral;
