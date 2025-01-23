with RP.Timer; use RP.Timer;
with RP.Device;

with Rover.Driving; use Rover.Driving;
with Rover.Remote;
with Rover.Sonar;
with Rover.Servos; use Rover.Servos;

package body Rover.Autonomous is

   User_Exit : Boolean := False;

   type Mast_Direction is (Left, None, Right);

   Pos : Servos.Mast_Angle := 0;
   Direction : Mast_Direction := Left;
   Last_Mast_Update : Time := 0;

   -------------------
   -- Next_Mast_Pos --
   -------------------

   procedure Next_Mast_Pos (Min, Max : Servos.Mast_Angle;
                            Period : Time)
   is
      Now : constant Time := Clock;
   begin
      if Now < Last_Mast_Update + Period then
         return;
      end if;

      case Direction is
         when None =>
            null;
         when Left =>
            if Pos <= Min then
               Direction := Right;
            else
               Pos := Pos - 1;
            end if;
         when Right =>
            if Pos >= Max then
               Direction := Left;
            else
               Pos := Pos + 1;
            end if;
      end case;

      Servos.Set_Mast (Pos);
      Last_Mast_Update := Now;
   end Next_Mast_Pos;

   ----------------------
   -- Check_User_Input --
   ----------------------

   function Check_User_Input return Boolean is
      State : constant Remote.Buttons_State := Remote.Update;
   begin
      User_Exit := (for some B in Remote.Buttons => State (B));
      return User_Exit;
   end Check_User_Input;

   ----------------
   -- Go_Forward --
   ----------------

   procedure Go_Forward is
   begin

      --  Go forward...
      Driving.Set_Turn (Driving.Straight);
      Driving.Set_Power (Left, 100);
      Driving.Set_Power (Right, 100);

      --  Rotate the mast and check for obstacle
      while not Check_User_Input loop
         Next_Mast_Pos (-45, 45, Milliseconds (10));

         exit when Sonar.Distance < 30;
         RP.Device.Timer.Delay_Milliseconds (10);
      end loop;
   end Go_Forward;

   -----------------
   -- Turn_Around --
   -----------------

   procedure Turn_Around is
   begin
      --  Turn around, full speed
      --  TODO: Ramdom direction, keep turning if an obstacle is detected

      Driving.Set_Turn (Driving.Around);
      Driving.Set_Power (Left, -100);
      Driving.Set_Power (Right, 100);
      RP.Device.Timer.Delay_Milliseconds (2000);
   end Turn_Around;

   ------------------------
   -- Find_New_Direction --
   ------------------------

   procedure Find_New_Direction is
      Left_Dist : Natural;
      Right_Dist : Natural;

      Timeout : constant Time := Clock + Milliseconds (8000);
   begin
      Driving.Set_Turn (Driving.Straight);
      Driving.Set_Power (Left, 0);
      Driving.Set_Power (Right, 0);

      --  Turn the mast back and forth and log the dected distance for the left
      --  and right side.
      while not Check_User_Input and then Clock < Timeout loop
         Next_Mast_Pos (-55, 55, Milliseconds (20));

         if Pos <= -40 then
            Left_Dist := Sonar.Distance;
         end if;
         if Pos >= 40 then
            Right_Dist := Sonar.Distance;
         end if;

         RP.Device.Timer.Delay_Milliseconds (10);
      end loop;

      if Clock > Timeout then
         if Left_Dist < 50 and then Right_Dist < 50 then
            --  Obstacles left and right, turn around to find a new direction
            Turn_Around;

         elsif Left_Dist > Right_Dist then
            --  Turn left a little
            Driving.Set_Turn (Driving.Around);
            Driving.Set_Power (Left, -100);
            Driving.Set_Power (Right, 100);
            RP.Device.Timer.Delay_Milliseconds (800);
         else
            --  Turn right a little
            Driving.Set_Turn (Driving.Around);
            Driving.Set_Power (Left, 100);
            Driving.Set_Power (Right, -100);
            RP.Device.Timer.Delay_Milliseconds (800);
         end if;
      end if;

   end Find_New_Direction;

   ---------
   -- Run --
   ---------

   procedure Run is
   begin

      User_Exit := False;

      --  Stop everything
      Driving.Set_Turn (Driving.Straight);
      Driving.Set_Power (Left, 0);
      Driving.Set_Power (Right, 0);

      while not User_Exit loop
         Go_Forward;
         Find_New_Direction;
      end loop;

      --  Stop everything before leaving the autonomous mode
      Driving.Set_Turn (Driving.Straight);
      Driving.Set_Power (Left, 0);
      Driving.Set_Power (Right, 0);

   end Run;

end Rover.Autonomous;
