package Rover.Motors is

   type Motor_Power is range -100 .. 100;

   procedure Set_Power (Side : Side_Id;
                        Pwr  : Motor_Power);

end Rover.Motors;
