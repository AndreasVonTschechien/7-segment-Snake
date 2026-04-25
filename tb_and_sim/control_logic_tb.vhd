library IEEE;
use ieee.std_logic_1164.all;

entity tb_control_logic is
end tb_control_logic;

architecture tb of tb_control_logic is

    component control_logic
        port (clk             : in std_logic;
              rst             : in std_logic;
              btn_up          : in std_logic;
              btn_down        : in std_logic;
              btn_right       : in std_logic;
              btn_left        : in std_logic;
              direction_up    : out std_logic;
              direction_down  : out std_logic;
              direction_right : out std_logic;
              direction_left  : out std_logic);
    end component;

    signal clk             : std_logic;
    signal rst             : std_logic;
    signal btn_up          : std_logic;
    signal btn_down        : std_logic;
    signal btn_right       : std_logic;
    signal btn_left        : std_logic;
    signal direction_up    : std_logic;
    signal direction_down  : std_logic;
    signal direction_right : std_logic;
    signal direction_left  : std_logic;

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : control_logic
    port map (clk             => clk,
              rst             => rst,
              btn_up          => btn_up,
              btn_down        => btn_down,
              btn_right       => btn_right,
              btn_left        => btn_left,
              direction_up    => direction_up,
              direction_down  => direction_down,
              direction_right => direction_right,
              direction_left  => direction_left);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        btn_up <= '0';
        btn_down <= '0';
        btn_right <= '0';
        btn_left <= '0';

        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 10 * TbPeriod;

        btn_up <= '1';
        wait for 30 ms; 
        btn_up <= '0';
        wait for 30 ms;

        btn_down <= '1';
        wait for 30 ms;
        btn_down <= '0';
        wait for 30 ms;

        btn_right <= '1';
        wait for 30 ms;
        btn_right <= '0';
        wait for 30 ms;

        btn_left <= '1';
        wait for 30 ms;
        btn_left <= '0';
        wait for 30 ms;

        btn_down <= '1';
        wait for 30 ms;
        btn_down <= '0';
        wait for 30 ms;

        btn_left <= '1';
        wait for 30 ms;
        btn_left <= '0';
        wait for 30 ms;
        
        rst <= '1';
        wait for 30 ms;
        rst <= '1';
        wait for 30 ms;
        
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_control_logic of tb_control_logic is
    for tb
    end for;
end cfg_tb_control_logic;