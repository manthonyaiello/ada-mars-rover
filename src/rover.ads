package Rover
with Elaborate_Body
is

   type Side_Id is (Left, Right);

   type Wheel_Id is (Front, Back, Mid);

   subtype Steering_Wheel_Id is Wheel_Id range Front .. Back;

end Rover;
