library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package snake_pkg is
    type t_coord_x is array (0 to 31) of integer range 0 to 15;
    type t_coord_y is array (0 to 31) of integer range 0 to 4;

    -- Seskupení dat o hadovi do jedné sběrnice
    type t_snake_data is record
        x   : t_coord_x;
        y   : t_coord_y;
        len : integer range 1 to 32;
    end record;

    -- Seskupení dat o jídle
    type t_food_data is record
        x   : integer range 0 to 15;
        y   : integer range 0 to 4;
    end record;
end package snake_pkg;