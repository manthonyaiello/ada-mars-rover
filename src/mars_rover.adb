with Rover.Autonomous;
with Rover.Remote_Controlled;

procedure Mars_Rover is
begin

   --  Alternate between autonomous and remote controlled mode. Automous will
   --  run until a command is received from the remote, remote controlled will
   --  run as long as commands are received from the remote.
   loop
      Rover.Autonomous.Run;
      Rover.Remote_Controlled.Run;
   end loop;

end Mars_Rover;
