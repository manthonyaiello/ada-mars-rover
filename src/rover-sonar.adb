with RP.Device;
with RP.Timer; use RP.Timer;
with RP.GPIO; use RP.GPIO;
with Pico;

package body Rover.Sonar is

   Pin  : GPIO_Point renames Pico.GP3;
   Timeout : constant RP.Timer.Time := RP.Timer.Milliseconds (50);

   --------------
   -- One_Shot --
   --------------

   function One_Shot return Natural is
      T1, T2, T3 : RP.Timer.Time;
   begin
      Pin.Configure (Output, Floating);
      Pin.Set;
      RP.Device.Timer.Delay_Microseconds (10);
      Pin.Clear;
      Pin.Configure (Input, Floating);
      T1 := RP.Timer.Clock;
      while not Pin.Set loop
         if Clock > T1 + Timeout then
            return 0;
         end if;
      end loop;
      T2 := RP.Timer.Clock;
      while Pin.Set loop
         if Clock > T2 + Timeout then
            return 0;
         end if;
      end loop;
      T3 := RP.Timer.Clock;

      return Natural (T3 - T2);
   end One_Shot;

   --------------
   -- Distance --
   --------------

   function Distance return Natural is
      Raw : constant Natural := One_Shot;
      Raw_Cm : constant Float := (Float (Raw) * 0.034) / 2.0;
   begin
      return Natural (Raw_Cm);
   end Distance;

end Rover.Sonar;
