package Rover.Driving is

   type Turn_Kind is (Straight, Left, Right, Around);

   procedure Set_Turn (Turn : Turn_Kind);

   type Motor_Power is range -100 .. 100;

   procedure Set_Power (Side : Side_Id;
                        Pwr  : Motor_Power);

end Rover.Driving;
