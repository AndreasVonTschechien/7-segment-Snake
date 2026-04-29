library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end entity tb_debounce;

architecture test of tb_debounce is
    constant C_CLK_PERIOD : time := 10 ns;

    signal sig_clk       : std_logic := '0';
    signal sig_rst       : std_logic := '0';
    signal sig_btn_in    : std_logic := '0';
    signal sig_btn_state : std_logic;
    signal sig_btn_press : std_logic;

begin
    -- Instance testované komponenty [cite: 27, 28]
    uut : entity work.debounce
        port map (
            clk       => sig_clk,
            rst       => sig_rst,
            btn_in    => sig_btn_in,
            btn_state => sig_btn_state,
            btn_press => sig_btn_press
        );

    -- Generátor hodin
    p_clk_gen : process
    begin
        while now < 1 us loop
            sig_clk <= '0'; wait for C_CLK_PERIOD / 2;
            sig_clk <= '1'; wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    -- Stimulus proces: Simulace mechanických zámitů
    p_stimulus : process
    begin
        sig_rst <= '1'; wait for 25 ns;
        sig_rst <= '0'; wait for 20 ns;

        -- Simulace stisku s kmitáním (bouncing)
        sig_btn_in <= '1'; wait for 10 ns;
        sig_btn_in <= '0'; wait for 15 ns;
        sig_btn_in <= '1'; wait for 12 ns;
        sig_btn_in <= '0'; wait for 8 ns;
        sig_btn_in <= '1'; -- Konečně stabilní stisk
        
        wait for 200 ns; -- Čekáme na potvrzení (debounce time)

        -- Simulace uvolnění s kmitáním
        sig_btn_in <= '0'; wait for 10 ns;
        sig_btn_in <= '1'; wait for 15 ns;
        sig_btn_in <= '0'; -- Konečně stabilní puštění

        wait;
    end process p_stimulus;

end architecture test;