library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.snake_pkg.all;

entity tb_snake_display is
end entity tb_snake_display;

architecture test of tb_snake_display is
    signal sig_mux_cnt : std_logic_vector(2 downto 0) := "000";
    signal sig_snake   : t_snake_data;
    signal sig_food    : t_food_data;
    signal sig_seg     : std_logic_vector(6 downto 0);
    signal sig_an      : std_logic_vector(7 downto 0);

begin
    -- Instance testovaného modulu
    uut : entity work.snake_display
        port map (
            mux_cnt  => sig_mux_cnt,
            snake_in => sig_snake,
            food_in  => sig_food,
            seg      => sig_seg,
            an       => sig_an
        );

    -- Stimulus: Nastavení statické scény
    p_stimulus : process
    begin
        -- Nastavení hada: Hlava na x=0, y=0 (Levý horní roh, segment A a F)
        sig_snake.len <= 1;
        sig_snake.x(0) <= 0;
        sig_snake.y(0) <= 0;
        
        -- Nastavení jídla: x=15, y=4 (Pravý dolní roh, segment D)
        sig_food.x <= 15;
        sig_food.y <= 4;

        -- Cyklování přes všechny anody (0 až 7)
        for i in 0 to 7 loop
            sig_mux_cnt <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
        end loop;

        wait;
    end process;
end architecture test;