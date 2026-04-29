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
    
    signal sig_direction_up : std_logic;
    signal sig_direction_down : std_logic;
    signal sig_direction_right : std_logic;
    signal sig_direction_left : std_logic;
           
begin
        
    direction : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_direction_up    <= '0';
                sig_direction_down  <= '0';
                sig_direction_left  <= '0';
                sig_direction_right <= '0'; 
            elsif btn_up = '1' and sig_direction_down = '0' then
                sig_direction_up <= '1';
                sig_direction_down <= '0';
                sig_direction_right <= '0';
                sig_direction_left <= '0';
            elsif btn_down = '1' and sig_direction_up = '0' then
                sig_direction_up <= '0';
                sig_direction_down <= '1';
                sig_direction_right <= '0';
                sig_direction_left <= '0';
            elsif btn_right = '1' and sig_direction_left = '0' then
                sig_direction_up <= '0';
                sig_direction_down <= '0';
                sig_direction_right <= '1';
                sig_direction_left <= '0';
            elsif btn_left = '1' and sig_direction_right = '0' then
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
