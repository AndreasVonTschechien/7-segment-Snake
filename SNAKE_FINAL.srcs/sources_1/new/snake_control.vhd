library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.snake_pkg.all;

entity snake_control is
    port (
        clk       : in  std_logic;
        ce_game   : in  std_logic;
        rst_btn   : in  std_logic;
        btn_u, btn_d, btn_l, btn_r : in std_logic;
        -- Zabalené výstupy
        snake_out : out t_snake_data;
        food_out  : out t_food_data;
        game_over : out std_logic
    );
end entity snake_control;

architecture Behavioral of snake_control is
    signal sig_snake : t_snake_data := (x => (0 => 7, others => 0), y => (0 => 4, others => 0), len => 1);
    signal sig_food  : t_food_data  := (x => 10, y => 0);
    signal sig_dir   : integer range 0 to 3 := 0;
    signal sig_rand  : unsigned(15 downto 0) := x"ACE1";
    signal sig_dead  : std_logic := '0';
begin
    p_game : process(clk)
        variable next_x : integer range 0 to 15;
        variable next_y : integer range 0 to 4;
    begin
        if rising_edge(clk) then
            sig_rand <= sig_rand(14 downto 0) & (sig_rand(15) xor sig_rand(13) xor sig_rand(12) xor sig_rand(10));
            if rst_btn = '1' then
                sig_snake.len <= 1; sig_snake.x(0) <= 7; sig_snake.y(0) <= 4;
                sig_dead <= '0'; sig_dir <= 0;
            elsif sig_dead = '0' then
                -- Logika směru [cite: 70-74]
                if btn_u = '1' and sig_dir /= 1 then sig_dir <= 0; end if;
                if btn_d = '1' and sig_dir /= 0 then sig_dir <= 1; end if;
                if btn_l = '1' and sig_dir /= 3 and (sig_snake.y(0)=0 or sig_snake.y(0)=2 or sig_snake.y(0)=4) then sig_dir <= 2; end if;
                if btn_r = '1' and sig_dir /= 2 and (sig_snake.y(0)=0 or sig_snake.y(0)=2 or sig_snake.y(0)=4) then sig_dir <= 3; end if;

                if ce_game = '1' then
                    next_x := sig_snake.x(0); next_y := sig_snake.y(0);
                    case sig_dir is
                        when 0 => if next_y = 0 then next_y := 4; else next_y := next_y - 1; end if;
                        when 1 => if next_y = 4 then next_y := 0; else next_y := next_y + 1; end if;
                        when 2 => if next_x = 0 then next_x := 15; else next_x := next_x - 1; end if;
                        when 3 => if next_x = 15 then next_x := 0; else next_x := next_x + 1; end if;
                    end case;
                    -- Kolize a jídlo [cite: 80-82]
                    for i in 1 to 31 loop
                        if i < sig_snake.len and next_x = sig_snake.x(i) and next_y = sig_snake.y(i) then sig_dead <= '1'; end if;
                    end loop;
                    if next_x = sig_food.x and next_y = sig_food.y then
                        if sig_snake.len < 32 then sig_snake.len <= sig_snake.len + 1; end if;
                        sig_food.x <= to_integer(sig_rand(3 downto 0));
                        sig_food.y <= to_integer(sig_rand(7 downto 4)) rem 5;
                    end if;
                    -- Posun [cite: 83-85]
                    for i in 31 downto 1 loop
                        sig_snake.x(i) <= sig_snake.x(i-1); sig_snake.y(i) <= sig_snake.y(i-1);
                    end loop;
                    sig_snake.x(0) <= next_x; sig_snake.y(0) <= next_y;
                end if;
            end if;
        end if;
    end process;
    snake_out <= sig_snake;
    food_out  <= sig_food;
    game_over <= sig_dead;
end architecture Behavioral;