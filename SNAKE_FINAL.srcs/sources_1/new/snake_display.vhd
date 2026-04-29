library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.snake_pkg.all;

entity snake_display is
    port (
        mux_cnt   : in  std_logic_vector(2 downto 0);
        snake_in  : in  t_snake_data;
        food_in   : in  t_food_data;
        seg       : out std_logic_vector(6 downto 0);
        an        : out std_logic_vector(7 downto 0)
    );
end entity snake_display;

architecture Behavioral of snake_display is
begin
    p_mux : process(mux_cnt, snake_in, food_in)
        variable v_seg : std_logic_vector(6 downto 0);
        variable v_idx : integer;
    begin
        v_idx := to_integer(unsigned(mux_cnt));
        v_seg := "1111111";
        -- Vykreslení hada [cite: 88-100]
        for i in 0 to 31 loop
            if i < snake_in.len and (snake_in.x(i) / 2) = v_idx then
                if (snake_in.x(i) mod 2) = 0 then
                    case snake_in.y(i) is
                        when 0 => v_seg(0) := '0'; when 1 => v_seg(5) := '0';
                        when 2 => v_seg(6) := '0'; when 3 => v_seg(4) := '0';
                        when 4 => v_seg(3) := '0';
                    end case;
                else
                    case snake_in.y(i) is
                        when 0 => v_seg(0) := '0'; when 1 => v_seg(1) := '0';
                        when 2 => v_seg(6) := '0'; when 3 => v_seg(2) := '0';
                        when 4 => v_seg(3) := '0';
                    end case;
                end if;
            end if;
        end loop;
        -- Jídlo [cite: 101-107]
        if (food_in.x / 2) = v_idx then
            if (food_in.x mod 2) = 0 then
                case food_in.y is
                    when 0 => v_seg(0) := '0'; when 1 => v_seg(5) := '0';
                    when 2 => v_seg(6) := '0'; when 3 => v_seg(4) := '0';
                    when 4 => v_seg(3) := '0';
                end case;
            else
                case food_in.y is
                    when 0 => v_seg(0) := '0'; when 1 => v_seg(1) := '0';
                    when 2 => v_seg(6) := '0'; when 3 => v_seg(2) := '0';
                    when 4 => v_seg(3) := '0';
                end case;
            end if;
        end if;
        an <= (others => '1'); an(v_idx) <= '0'; seg <= v_seg;
    end process;
end architecture Behavioral;