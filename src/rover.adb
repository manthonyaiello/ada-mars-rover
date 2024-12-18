with RP.Clock;
with RP.Device;
with RP.GPIO;
with Pico;

package body Rover is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);
   RP.Device.Timer.Enable;
   Pico.LED.Configure (RP.GPIO.Output);
end Rover;
