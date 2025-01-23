package Rover.Servos is

   procedure Set_Wheel (Wheel : Steering_Wheel_Id;
                        Side  : Side_Id;
                        V     : Integer);

   type Mast_Angle is new Integer range -90 .. 90;
   procedure Set_Mast (V : Mast_Angle);

end Rover.Servos;
