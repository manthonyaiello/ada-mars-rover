with RP.Device;

with Rover; use Rover;
with Rover.Driving; use Rover.Driving;
with Rover.Remote;
with Rover.Sonar;

procedure Mars_Rover is
   Buttons : Rover.Remote.Buttons_State;
   Dist : Natural;

   type Remote_Command is (None,
                           Forward,
                           Backward,
                           Turn_Left,
                           Turn_Right,
                           Forward_Left,
                           Forward_Right,
                           Back_Left,
                           Back_Right);

   Cmd, Last_Cmd : Remote_Command := None;
begin

   loop
      Buttons := Rover.Remote.Update;
      Dist := Rover.Sonar.Distance;
      Last_Cmd := Cmd;

      if Dist < 20 then
         --  Ignore forward commands when close to an obstacle
         Buttons (Rover.Remote.Up) := False;
      end if;

      if Buttons (Rover.Remote.Up) and then  Buttons (Rover.Remote.Left)
      then
         Cmd := Forward_Left;
      elsif Buttons (Rover.Remote.Up) and then Buttons (Rover.Remote.Right)
      then
         Cmd := Forward_Right;
      elsif Buttons (Rover.Remote.Down) and then Buttons (Rover.Remote.Left)
      then
         Cmd := Back_Left;
      elsif Buttons (Rover.Remote.Down) and then Buttons (Rover.Remote.Right)
      then
         Cmd := Back_Right;
      elsif Buttons (Rover.Remote.Up)  then
         Cmd := Forward;
      elsif Buttons (Rover.Remote.Right) then
         Cmd := Turn_Right;
      elsif Buttons (Rover.Remote.Left) then
         Cmd := Turn_Left;
      elsif Buttons (Rover.Remote.Down) then
         Cmd := Backward;
      else
         Cmd := None;
      end if;

      if Cmd /= Last_Cmd then

         case Cmd is
            when None =>
               Rover.Driving.Set_Power (Left, 0);
               Rover.Driving.Set_Power (Right, 0);
            when Forward =>
               Rover.Driving.Set_Turn (Straight);
               Rover.Driving.Set_Power (Left, 100);
               Rover.Driving.Set_Power (Right, 100);
            when Backward =>
               Rover.Driving.Set_Turn (Straight);
               Rover.Driving.Set_Power (Left, -100);
               Rover.Driving.Set_Power (Right, -100);
            when Turn_Left =>
               Rover.Driving.Set_Turn (Around);
               Rover.Driving.Set_Power (Left, -100);
               Rover.Driving.Set_Power (Right, 100);
            when Turn_Right =>
               Rover.Driving.Set_Turn (Around);
               Rover.Driving.Set_Power (Left, 100);
               Rover.Driving.Set_Power (Right, -100);
            when Forward_Left =>
               Rover.Driving.Set_Turn (Left);
               Rover.Driving.Set_Power (Left, 50);
               Rover.Driving.Set_Power (Right, 100);
            when Forward_Right =>
               Rover.Driving.Set_Turn (Right);
               Rover.Driving.Set_Power (Left, 100);
               Rover.Driving.Set_Power (Right, 50);
            when Back_Left =>
               Rover.Driving.Set_Turn (Right);
               Rover.Driving.Set_Power (Left, -100);
               Rover.Driving.Set_Power (Right, -50);
            when Back_Right =>
               Rover.Driving.Set_Turn (Left);
               Rover.Driving.Set_Power (Left, -50);
               Rover.Driving.Set_Power (Right, -100);
         end case;
      end if;

      RP.Device.Timer.Delay_Milliseconds (30);
   end loop;
end Mars_Rover;
