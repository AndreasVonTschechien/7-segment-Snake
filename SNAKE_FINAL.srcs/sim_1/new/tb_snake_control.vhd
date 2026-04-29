library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.snake_pkg.all;

entity tb_snake_control is
end entity tb_snake_control;

architecture test of tb_snake_control is
    constant C_CLK_PERIOD : time := 10 ns;
    
    signal sig_clk     : std_logic := '0';
    signal sig_ce_game : std_logic := '0';
    signal sig_rst_btn : std_logic := '0';
    signal sig_u, sig_d, sig_l, sig_r : std_logic := '0';
    
    signal sig_snake_out : t_snake_data;
    signal sig_food_out  : t_food_data;
    signal sig_game_over : std_logic;

begin
    -- Instance herního jádra [cite: 60]
    uut : entity work.snake_control
        port map (
            clk       => sig_clk,
            ce_game   => sig_ce_game,
            rst_btn   => sig_rst_btn,
            btn_u => sig_u, btn_d => sig_d, 
            btn_l => sig_l, btn_r => sig_r,
            snake_out => sig_snake_out,
            food_out  => sig_food_out,
            game_over => sig_game_over
        );

    -- Generátor hodin
    p_clk_gen : process
    begin
        while now < 2 us loop
            sig_clk <= '0'; wait for C_CLK_PERIOD / 2;
            sig_clk <= '1'; wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Generátor herních tiků (každých 100 ns jeden krok)
    p_ce_gen : process
    begin
        while now < 2 us loop
            sig_ce_game <= '0'; wait for 90 ns;
            sig_ce_game <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus: Ovládání hada
    p_stimulus : process
    begin
        -- Reset hry [cite: 68-69]
        sig_rst_btn <= '1'; wait for 20 ns;
        sig_rst_btn <= '0'; wait for 20 ns;

        -- Test 1: Pohyb doprava (nastavení směru před tikem) [cite: 73]
        sig_r <= '1'; wait for 10 ns; sig_r <= '0';
        wait for 200 ns; -- Počkáme na 2 herní tiky

        -- Test 2: Pohyb nahoru [cite: 70]
        sig_u <= '1'; wait for 10 ns; sig_u <= '0';
        wait for 200 ns;

        wait;
    end process;
end architecture test;