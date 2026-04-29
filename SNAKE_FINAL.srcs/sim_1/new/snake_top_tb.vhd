library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Testbench entita nemá žádné porty
------------------------------------------------------------------------
entity tb_snake_top is
end entity tb_snake_top;

------------------------------------------------------------------------
-- Architektura testbenche
------------------------------------------------------------------------
architecture testbench of tb_snake_top is

    -- Konstanty
    constant C_CLK_PERIOD : time := 10 ns; -- 100 MHz hodiny pro Nexys A7

    -- Signály pro připojení k testované entitě (DUT - Device Under Test)
    signal s_clk  : std_logic := '0';
    signal s_btnc : std_logic := '0';
    signal s_btnu : std_logic := '0';
    signal s_btnd : std_logic := '0';
    signal s_btnl : std_logic := '0';
    signal s_btnr : std_logic := '0';
    signal s_seg  : std_logic_vector(6 downto 0);
    signal s_an   : std_logic_vector(7 downto 0);
    signal s_led  : std_logic_vector(15 downto 0);

begin

    --------------------------------------------------------------------
    -- Instanciace testované entity (DUT)
    --------------------------------------------------------------------
    DUT: entity work.snake_top
        port map (
            clk  => s_clk,
            btnc => s_btnc,
            btnu => s_btnu,
            btnd => s_btnd,
            btnl => s_btnl,
            btnr => s_btnr,
            seg  => s_seg,
            an   => s_an,
            led  => s_led
        );

    --------------------------------------------------------------------
    -- Proces: Generování hodinových pulzů
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 50 ms loop -- Omezení maximální doby simulace
            s_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            s_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------------------
    -- Proces: Generování resetu
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_btnc <= '1'; -- Aktivace resetu (Tlačítko BTNC)
        wait for 10 * C_CLK_PERIOD;
        s_btnc <= '0'; -- Deaktivace
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Proces: Generování stimulů (Data generation)
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        -- Výchozí stav tlačítek na začátku simulace
        s_btnu <= '0';
        s_btnd <= '0';
        s_btnl <= '0';
        s_btnr <= '0';

        report "--- ZACATEK SIMULACE ---" severity note;

        -- Čekáme na dokončení resetu a uvolnění tlačítka
        wait for 20 * C_CLK_PERIOD;

        -- Kontrola, zda jsou skóre LEDky po resetu správně zhasnuté
        assert s_led = x"0000"
            report "Chyba resetu: LED indikujici skore by mely byt na zacatku zhasnute!"
            severity error;

        wait for 1 ms;

        -- 1. Simulace stisku tlačítka BTNL (v kódu nastaveno jako krok doprava)
        -- Tlačítka procházejí debouncerem, musíme je podržet delší dobu
        report "Stisk BTNL (Pohyb doprava)" severity note;
        s_btnl <= '1';
        wait for 2 ms; -- Podržíme tlačítko dostatečně dlouho pro překonání debounceru
        s_btnl <= '0';

        wait for 5 ms;

        -- 2. Simulace stisku tlačítka BTNU (Pohyb nahoru)
        report "Stisk BTNU (Pohyb nahoru)" severity note;
        s_btnu <= '1';
        wait for 2 ms;
        s_btnu <= '0';

        wait for 5 ms;
        
        -- 3. Simulace stisku tlačítka BTNR (V kódu nastaveno jako krok doleva)
        report "Stisk BTNR (Pohyb doleva)" severity note;
        s_btnr <= '1';
        wait for 2 ms;
        s_btnr <= '0';

        wait for 10 ms;

        report "--- KONEC SIMULACE ---" severity note;
        wait; -- Zastavení procesu
    end process p_stimulus;

end architecture testbench;