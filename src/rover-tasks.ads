package Rover.Tasks is

   procedure Demo
     with No_Return;

   pragma Export (C, Demo, "mars_rover_demo_task");

end Rover.Tasks;
