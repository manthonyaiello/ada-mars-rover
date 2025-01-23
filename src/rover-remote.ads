package Rover.Remote is

   type Buttons is (Up, Down, Left, Right,
                    A, B, C, D,
                    L1, L2, R1, R2,
                    Sel, Start);

   type Buttons_State is array (Buttons) of Boolean;
   --  True if the button is pressed

   function Update return Buttons_State;

end Rover.Remote;
