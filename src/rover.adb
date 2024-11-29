with RP.Clock;
with RP.Device;

package body Rover is
begin
   RP.Clock.Initialize (12_000_000);
   RP.Device.Timer.Enable;
end Rover;
