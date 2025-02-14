with Rover_HAL;
with Rover.Tasks;

with Mars_Rover_Config;
pragma Unreferenced (Mars_Rover_Config);

procedure Mars_Rover
  with SPARK_Mode
is
begin
   Rover_HAL.Initialize;

   loop
      Rover.Tasks.Demo;
   end loop;
end Mars_Rover;
