with Rover.Servos;

package body Rover.Driving is

   Turn_Offset : constant := 75;

   Left_Offset  : constant := -Turn_Offset;
   Right_Offset : constant := Turn_Offset;
   type Servo_Positions is array (Steering_Wheel_Id, Side_Id) of Integer;

   Straight_Point : constant Servo_Positions := [Front => [Left =>  300 - 20,
                                                           Right => 300 - 15],
                                                 Back  => [Left =>  300 - 20,
                                                           Right => 300 + 00]];

   procedure Set_Turn (Turn : Turn_Kind) is
      Positions : Servo_Positions := Straight_Point;
   begin
      case Turn is
         when Straight =>
            null;
         when Left =>
            Positions (Front, Left)  := @ + Left_Offset;
            Positions (Front, Right) := @ + Left_Offset;
            Positions (Back, Left)   := @ + Right_Offset;
            Positions (Back, Right)  := @ + Right_Offset;
         when Right =>
            Positions (Front, Left)  := @ + Right_Offset;
            Positions (Front, Right) := @ + Right_Offset;
            Positions (Back, Left)   := @ + Left_Offset;
            Positions (Back, Right)  := @ + Left_Offset;
         when Around =>
            Positions (Front, Left)  := @ + Right_Offset;
            Positions (Front, Right) := @ + Left_Offset;
            Positions (Back, Left)   := @ + Left_Offset;
            Positions (Back, Right)  := @ + Right_Offset;
      end case;

      for Side in Side_Id loop
         for Wheel in Steering_Wheel_Id loop
            Servos.Set_Wheel (Wheel, Side, Positions (Wheel, Side));
         end loop;
      end loop;
   end Set_Turn;

end Rover.Driving;
