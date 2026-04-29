library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.snake_pkg.all;

entity snake_top is
    port (
        clk : in std_logic;
        btnc, btnu, btnd, btnl, btnr : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an  : out std_logic_vector(7 downto 0);
        led : out std_logic_vector(15 downto 0)
    );
end entity snake_top;

architecture Structural of snake_top is
    signal sig_ce_mux, sig_ce_game : std_logic;
    signal sig_mux_cnt : std_logic_vector(2 downto 0);
    signal sig_u, sig_d, sig_l, sig_r, sig_c : std_logic;
    -- Zabalené vnitřní sběrnice
    signal s_snake : t_snake_data;
    signal s_food  : t_food_data;
begin
    CLK_MUX : entity work.clk_en generic map(G_MAX=>100000) port map(clk=>clk, rst=>btnc, ce=>sig_ce_mux);
    CLK_GM  : entity work.clk_en generic map(G_MAX=>50000000) port map(clk=>clk, rst=>btnc, ce=>sig_ce_game);
    CNT_MUX : entity work.counter generic map(G_BITS=>3) port map(clk=>clk, rst=>btnc, en=>sig_ce_mux, cnt=>sig_mux_cnt);
    DEB_U : entity work.debounce port map(clk=>clk, rst=>'0', btn_in=>btnu, btn_press=>sig_u);
    DEB_D : entity work.debounce port map(clk=>clk, rst=>'0', btn_in=>btnd, btn_press=>sig_d);
    DEB_L : entity work.debounce port map(clk=>clk, rst=>'0', btn_in=>btnl, btn_press=>sig_r);
    DEB_R : entity work.debounce port map(clk=>clk, rst=>'0', btn_in=>btnr, btn_press=>sig_l);
    DEB_C : entity work.debounce port map(clk=>clk, rst=>'0', btn_in=>btnc, btn_press=>sig_c);

    GAME_CTRL : entity work.snake_control port map (
        clk=>clk, ce_game=>sig_ce_game, rst_btn=>sig_c,
        btn_u=>sig_u, btn_d=>sig_d, btn_l=>sig_l, btn_r=>sig_r,
        snake_out=>s_snake, food_out=>s_food, game_over=>open
    );

    DISP_DRV : entity work.snake_display port map (
        mux_cnt=>sig_mux_cnt, snake_in=>s_snake, food_in=>s_food, 
        seg=>seg, an=>an
    );

    SCORE_DRV : entity work.snake_score port map (
        snake_len => s_snake.len, led => led
    );
end architecture Structural;