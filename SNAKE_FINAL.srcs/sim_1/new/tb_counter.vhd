library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter is
-- Entity testbenche je vždy prázdná
end entity tb_counter;

architecture test of tb_counter is
    -- 1. Deklarace konstant a signálů
    constant C_BITS : positive := 3; -- Testujeme 3bitový čítač (0 až 7) [cite: 12]
    constant C_CLK_PERIOD : time := 10 ns;

    signal sig_clk : std_logic := '0';
    signal sig_rst : std_logic := '0';
    signal sig_en  : std_logic := '0';
    signal sig_cnt : std_logic_vector(C_BITS - 1 downto 0);

begin
    -- 2. Instance testované komponenty (Device Under Test) [cite: 12-15]
    uut : entity work.counter
        generic map ( G_BITS => C_BITS )
        port map (
            clk => sig_clk,
            rst => sig_rst,
            en  => sig_en,
            cnt => sig_cnt
        );

    -- 3. Generátor hodinového signálu
    p_clk_gen : process
    begin
        while now < 500 ns loop -- Simulace poběží 500 nanosekund
            sig_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            sig_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    -- 4. Stimulus proces (tady "mačkáme tlačítka")
    p_stimulus : process
    begin
        -- Počáteční stav a Reset [cite: 18]
        sig_rst <= '1';
        wait for 25 ns;
        sig_rst <= '0';
        wait for 20 ns;

        -- Test 1: Čítání povoleno (en = '1') [cite: 19]
        sig_en <= '1';
        wait for 100 ns; -- Necháme ho dojet až k wrap-around (přetečení) [cite: 20]

        -- Test 2: Pozastavení čítání (en = '0')
        sig_en <= '0';
        wait for 40 ns; -- Čítač musí držet stejnou hodnotu

        -- Test 3: Opětovné spuštění a Reset za běhu
        sig_en <= '1';
        wait for 30 ns;
        sig_rst <= '1'; -- Synchronní reset [cite: 18]
        wait for 10 ns;
        sig_rst <= '0';

        wait;
    end process p_stimulus;

end architecture test;