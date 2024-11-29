with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

with Rover; use Rover;
with Rover.Servos;
with Rover.Driving; use Rover.Driving;
with Rover.Motors; use Rover.Motors;

procedure Mars_Rover is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.LED.Configure (RP.GPIO.Output);
   RP.Device.Timer.Enable;
   loop
      for X in 1 .. 2 loop
         Rover.Driving.Set_Turn (Left);
         RP.Device.Timer.Delay_Milliseconds (500);
         Rover.Motors.Set_Power (Left, 100);
         Rover.Motors.Set_Power (Right, 100);
         RP.Device.Timer.Delay_Milliseconds (2000);

         Rover.Motors.Set_Power (Left, 0);
         Rover.Motors.Set_Power (Right, 0);

         Rover.Driving.Set_Turn (Right);
         RP.Device.Timer.Delay_Milliseconds (500);
         Rover.Motors.Set_Power (Left, -100);
         Rover.Motors.Set_Power (Right, -100);
         RP.Device.Timer.Delay_Milliseconds (2000);

         Rover.Motors.Set_Power (Left, 0);
         Rover.Motors.Set_Power (Right, 0);

      end loop;

      for X in 1 .. 2 loop
         Rover.Driving.Set_Turn (Right);
         RP.Device.Timer.Delay_Milliseconds (500);
         Rover.Motors.Set_Power (Left, 100);
         Rover.Motors.Set_Power (Right, 100);
         RP.Device.Timer.Delay_Milliseconds (2000);

         Rover.Motors.Set_Power (Left, 0);
         Rover.Motors.Set_Power (Right, 0);


         Rover.Driving.Set_Turn (Left);
         RP.Device.Timer.Delay_Milliseconds (500);
         Rover.Motors.Set_Power (Left, -100);
         Rover.Motors.Set_Power (Right, -100);
         RP.Device.Timer.Delay_Milliseconds (2000);

         Rover.Motors.Set_Power (Left, 0);
         Rover.Motors.Set_Power (Right, 0);
      end loop;

      Rover.Driving.Set_Turn (Around);
      RP.Device.Timer.Delay_Milliseconds (500);
      Rover.Motors.Set_Power (Left, 100);
      Rover.Motors.Set_Power (Right, -100);
      RP.Device.Timer.Delay_Milliseconds (2000);

      Rover.Motors.Set_Power (Left, 0);
      Rover.Motors.Set_Power (Right, 0);

      Rover.Driving.Set_Turn (Around);
      RP.Device.Timer.Delay_Milliseconds (500);
      Rover.Motors.Set_Power (Left, -100);
      Rover.Motors.Set_Power (Right, 100);
      RP.Device.Timer.Delay_Milliseconds (2000);

      Rover.Motors.Set_Power (Left, 0);
      Rover.Motors.Set_Power (Right, 0);

      RP.Device.Timer.Delay_Milliseconds (5000);

   end loop;
--   loop
--      Rover.Driving.Set_Turn (Straight);
--      Rover.Servos.Set_Mast (300);
--      Pico.LED.Toggle;
--      RP.Device.Timer.Delay_Milliseconds (2000);

--      Rover.Driving.Set_Turn (Left);
--      Rover.Servos.Set_Mast (200);
--      Pico.LED.Toggle;
--      RP.Device.Timer.Delay_Milliseconds (2000);

--      Rover.Driving.Set_Turn (Right);
--      Rover.Servos.Set_Mast (400);
--      Pico.LED.Toggle;
--      RP.Device.Timer.Delay_Milliseconds (2000);

   --   Rover.Driving.Set_Turn (Around);
   --   Rover.Servos.Set_Mast (300);
   --   Pico.LED.Toggle;
   --   RP.Device.Timer.Delay_Milliseconds (2000);
   --end loop;
end Mars_Rover;
