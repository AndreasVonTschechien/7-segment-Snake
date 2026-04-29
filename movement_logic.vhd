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
           cnt_seg : in std_logic_vector(2 downto 0);
           cnt_an : in std_logic_vector(2 downto 0);
           data_seg : out std_logic_vector(6 downto 0);
           data_an  : out std_logic_vector(7 downto 0));
end movement_logic;

architecture Behavioral of movement_logic is

type state_seg is (seg_A, seg_B, seg_C, seg_D, seg_E, seg_F, seg_G);
type shift_reg_seg is array (55 downto 0) of state_seg;
type state_an is (an_0, an_1, an_2, an_3, an_4, an_5, an_6, an_7);
type shift_reg_an is array (55 downto 0) of state_an;

signal sig_shift_reg_seg : shift_reg_seg;
signal sig_shift_reg_an : shift_reg_an;
signal sig_game_over : std_logic;
signal cookie_seg : state_seg;
signal cookie_an : state_an;
signal running : std_logic := '0';
signal cookie_eaten : std_logic := '0';
signal length : integer range 0 to 56 := 1;
signal sig_index : integer range 0 to 55 := 0;
signal sig_cnt_seg : std_logic_vector(2 downto 0);

begin

    movement : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
            
                sig_shift_reg_seg <= (others => seg_A);
                sig_shift_reg_an <= (others => an_0);
                sig_game_over <= '0';
                length <= 1;
                                
            elsif ce = '1' and sig_game_over = '0' then
                
                sig_shift_reg_seg(55 downto 1) <= sig_shift_reg_seg(54 downto 0);
                sig_shift_reg_an(55 downto 1)  <= sig_shift_reg_an(54 downto 0);
                
                case sig_shift_reg_seg(0) is
                
                    when seg_A =>
                        if direction_down = '1' and (sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_an(1) < sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_A)) then                           
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);  
                        
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_B or (sig_shift_reg_an(1) > sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_A)) then
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);  
                            
                        elsif direction_right = '1' then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 =>     
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_left = '1' then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case;
                        
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_B =>
                
                        if direction_down = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);     
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_C or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(0) <= seg_A;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_C or sig_shift_reg_seg(1) = seg_G) then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 =>  
                                    sig_game_over <= '1';
                            end case;
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_A then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 => 
                                    sig_game_over <= '1';
                            end case;
                                                    
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_C =>
                
                        if direction_left = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(0) <= seg_D;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                
                        elsif direction_up = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_D then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 =>  
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_G) then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 => 
                                    sig_game_over <= '1';
                            end case;      
                
                        else
                            sig_game_over <= '1';
                        end if;
                                
                    when seg_D =>
                
                        if direction_up = '1' and (sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_an(1) > sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_D)) then
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_up = '1' and (sig_shift_reg_seg(1) = seg_E or (sig_shift_reg_an(1) < sig_shift_reg_an(0) and sig_shift_reg_seg(1) = seg_D)) then
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_right = '1' then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 => 
                                    sig_game_over <= '1';
                            end case; 
                          
                        elsif direction_left = '1' then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case;
                                
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_E =>
                
                        if direction_up = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_D then
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                            
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_F or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(0) <= seg_D;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0); 
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_D then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case;
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_F or sig_shift_reg_seg(1) = seg_G) then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case; 
                                    
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_F =>
                
                        if direction_down = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                
                        elsif direction_right = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_G) then
                            sig_shift_reg_seg(0) <= seg_A;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                
                        elsif direction_right = '1' and sig_shift_reg_seg(1) = seg_A then
                            sig_shift_reg_seg(0) <= seg_G;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                        
                        elsif direction_left = '1' and sig_shift_reg_seg(1) = seg_A then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case; 
                            
                        elsif direction_left = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_G) then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;                                    
                            end case;      
                            
                        else
                            sig_game_over <= '1';
                        end if;
                
                
                    when seg_G =>
                
                        if direction_up = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) < sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(0) <= seg_B;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_up = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) > sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(0) <= seg_F;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_E or sig_shift_reg_seg(1) = seg_F or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) < sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(0) <= seg_C;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_down = '1' and (sig_shift_reg_seg(1) = seg_B or sig_shift_reg_seg(1) = seg_C or (sig_shift_reg_seg(1) = seg_G and sig_shift_reg_an(1) > sig_shift_reg_an(0))) then
                            sig_shift_reg_seg(0) <= seg_E;
                            sig_shift_reg_an(0) <= sig_shift_reg_an(0);
                            
                        elsif direction_right = '1' then
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
                                    sig_shift_reg_an(0) <= an_7;
                                when an_7 =>
                                    sig_game_over <= '1';
                            end case;
                        
                        elsif direction_left = '1' then
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
                                when an_7 => 
                                    sig_shift_reg_an(0) <= an_6;
                            end case;        
                            
                        else
                            sig_game_over <= '1';
                        end if;
                                
                    when others =>
                        sig_game_over <= '1';
                
                end case;
                             
                
                for i in 1 to 55 loop
                    if i < length then
                        if sig_shift_reg_seg(0) = sig_shift_reg_seg(i) and sig_shift_reg_an(0) = sig_shift_reg_an(i) then
                            sig_game_over <= '1';
                        end if;
                    end if;
                end loop;                             
                
            end if; 
        end if;  
    end process movement;
    

    display_driver : process(clk)
    begin
        if rising_edge(clk) then
            
            data_seg <= (others => '1');
            data_an  <= (others => '1');

            if rst = '1' then
                sig_index <= 0;
                data_seg <= (others => '1');
                data_an  <= (others => '1');
            else
                
                if sig_index < length then
                    case sig_shift_reg_seg(sig_index) is
                        when seg_A => data_seg <= "0111111";
                        when seg_B => data_seg <= "1011111";
                        when seg_C => data_seg <= "1101111";
                        when seg_D => data_seg <= "1110111";
                        when seg_E => data_seg <= "1111011";
                        when seg_F => data_seg <= "1111101";
                        when seg_G => data_seg <= "1111110";
                        when others => data_seg <= "1111111";
                    end case;
    
                    case sig_shift_reg_an(sig_index) is
                        when an_0 => data_an <= "11111110";
                        when an_1 => data_an <= "11111101";
                        when an_2 => data_an <= "11111011";
                        when an_3 => data_an <= "11110111";
                        when an_4 => data_an <= "11101111";
                        when an_5 => data_an <= "11011111";
                        when an_6 => data_an <= "10111111";
                        when an_7 => data_an <= "01111111";
                        when others => data_an <= "11111111";
                    end case;
                end if;
    
                if sig_index < length then 
                    sig_index <= 0;
                else
                    sig_index <= sig_index + 1;
                end if;
    
            end if;
        end if;
    end process display_driver;
   
end Behavioral;
