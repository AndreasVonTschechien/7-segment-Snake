library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity movement_logic is
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           rst : in STD_LOGIC; 
           direction_up : in STD_LOGIC;
           direction_down : in STD_LOGIC;
           direction_right : in STD_LOGIC;
           direction_left : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR(7 downto 0)
         );
end movement_logic;

architecture Behavioral of movement_logic is

type state_seg is (seg_A, seg_B, seg_C, seg_D, seg_E, seg_F, seg_G);
type shift_reg_seg is array (55 downto 0) of state_seg;
signal sig_shift_reg_seg : shift_reg_seg;

type state_an is (an_0, an_1, an_2, an_3, an_4, an_5, an_6);
type shift_reg_an is array (55 downto 0) of state_an;
signal sig_shift_reg_an : shift_reg_an;

signal sig_game_over : std_logic;

begin

    movement : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
            
                sig_shift_reg_seg <= (others => seg_A);
                sig_shift_reg_an <= (others => an_0);
                sig_game_over <= '0';
                                
            elsif ce = '1' then
            
                case sig_shift_reg_seg(0) is
                
                    when seg_A =>
                        if direction_down = '1' and (sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_an(1) < sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_A)) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);  
                        
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_B or (sig_shift_reg_an(1) > sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_A)) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);  
                            
                        elsif direction_right = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;                           
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_left = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;                           
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case;
                        
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_B =>
                
                        if direction_down = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);     
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_C or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_C or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;   
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;
                                                    
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_C =>
                
                        if direction_left = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                
                        elsif direction_up = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;     
                
                        else
                            sig_game_over <= '1';
                        end if;
                               
                    when seg_D =>
                
                        if direction_up = '1' and (sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_an(1) > sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_D)) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_up = '1' and (sig_shift_reg_seg(1) = seg_E or (sig_shift_reg_an(1) < sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_D)) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_right = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case; 
                          
                        elsif direction_left = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case;
                                
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_E =>
                
                        if direction_up = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_F or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G; 
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case;
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_F or sig_shift_reg_seg(1) = seg_G) then     
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_D;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case; 
                                   
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_F =>
                
                        if direction_down = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case; 
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_A;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case;     
                            
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_G =>
                
                        if direction_up = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) < sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_up = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) > sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) < sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) > sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_right = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_5;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_6;
                                when an_6 => 
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_left = '1' then
                            sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                            sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                            sig_shift_reg_seg(0) <= seg_G;
                            
                            case sig_shift_reg_an(0) is                            
                                when an_0 => 
                                    sig_game_over <= '1';
                                when an_1 => 
                                    sig_shift_reg_an(0) <= an_0;
                                when an_2 => 
                                    sig_shift_reg_an(0) <= an_1;
                                when an_3 => 
                                    sig_shift_reg_an(0) <= an_2;
                                when an_4 => 
                                    sig_shift_reg_an(0) <= an_3;
                                when an_5 => 
                                    sig_shift_reg_an(0) <= an_4;
                                when an_6 => 
                                    sig_shift_reg_an(0) <= an_5;
                            end case;       
                            
                        else
                            sig_game_over <= '1';
                        end if;
                                
                    when others =>
                        sig_game_over <= '1';
                
                end case;
            end if; 
        end if;
    end process movement;

end Behavioral;