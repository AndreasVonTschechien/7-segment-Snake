library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity snake_score is
    port (
        snake_len : in  integer range 1 to 32;
        led       : out std_logic_vector(15 downto 0)
    );
end entity snake_score;

architecture Behavioral of snake_score is
begin
    process(snake_len) begin
        led <= (others => '0');
        for i in 0 to 15 loop
            if i < (snake_len - 1) then 
                led(i) <= '1';
            end if;
        end loop;
    end process;
end architecture Behavioral;