with HAL; use HAL;
with HAL.I2C;
with Rover.I2C; use Rover.I2C;
with RP.Device;

package body Rover.Servos is

   PCA9685_Addr : constant := 16#40# * 2;

   PCA9685_MODE1_REG    : constant := 16#00#;
   --  PCA9685_MODE2_REG    : constant := 16#01#;
   --  PCA9685_SUBADR1_REG  : constant := 16#02#;
   --  PCA9685_SUBADR2_REG  : constant := 16#03#;
   --  PCA9685_SUBADR3_REG  : constant := 16#04#;
   --  PCA9685_ALLCALL_REG  : constant := 16#05#;
   PCA9685_LED0_REG     : constant := 16#06#;
   PCA9685_PRESCALE_REG : constant := 16#FE#;
   --  PCA9685_ALLLED_REG   : constant := 16#FA#;

   --  Mode1 register values
   MODE1_RESTART : constant := 16#80#;
   --  MODE1_EXTCLK  : constant := 16#40#;
   MODE1_AUTOINC : constant := 16#20#;
   MODE1_SLEEP   : constant := 16#10#;
   --  MODE1_SUBADR1 : constant := 16#08#;
   --  MODE1_SUBADR2 : constant := 16#04#;
   --  MODE1_SUBADR3 : constant := 16#02#;
   --  MODE1_ALLCALL : constant := 16#01#;

   --  Mode2 register values
   --  MODE2_OUTDRV_TPOLE : constant := 16#04#;
   --  MODE2_INVRT        : constant := 16#10#;
   --  MODE2_OUTNE_TPHIGH : constant := 16#01#;
   --  MODE2_OUTNE_HIGHZ  : constant := 16#02#;
   --  MODE2_OCH_ONACK    : constant := 16#08#;

   type Channel_Id is range 0 .. 15;
   type PWM_Range is range 0 .. 4096;

   --------------------
   -- Write_Register --
   --------------------

   procedure Write_Register (Reg, Val : UInt8) is
      use HAL.I2C;

      Status : HAL.I2C.I2C_Status;

   begin

      Mem_Write
        (Addr => PCA9685_Addr,
         Mem_Addr => HAL.UInt16 (Reg),
         Mem_Addr_Size => HAL.I2C.Memory_Size_8b,
         Data => [1 => Val],
         Status => Status);

      if Status /= HAL.I2C.Ok then
         raise Program_Error;
      end if;
   end Write_Register;

   -------------
   -- Set_PWM --
   -------------

   procedure Set_PWM (Chan : Channel_Id; PWM : PWM_Range) is
      use HAL.I2C;

      Reg : constant UInt8 := PCA9685_LED0_REG + UInt8 (Chan) * 4;
      Phase_Begin : constant UInt16 := 0;
      Phase_End   : constant UInt16 := UInt16 (PWM);

      Status : HAL.I2C.I2C_Status;

   begin

      Mem_Write
        (Addr => PCA9685_Addr,
         Mem_Addr => HAL.UInt16 (Reg),
         Mem_Addr_Size => HAL.I2C.Memory_Size_8b,
         Data => [1 => UInt8 (Phase_Begin and 16#FF#),
                  2 => UInt8 (Shift_Right (Phase_Begin, 8) and 16#FF#),
                  3 => UInt8 (Phase_End and 16#FF#),
                  4 => UInt8 (Shift_Right (Phase_End, 8) and 16#FF#)],
         Status => Status);

      if Status /= HAL.I2C.Ok then
         raise Program_Error;
      end if;
   end Set_PWM;

   -------------------
   -- Set_Frequency --
   -------------------

   procedure Set_Frequency (Freq : Float) is
      Prescaler : Integer;
   begin

      if Freq <= 0.0 then
         return;
      end if;

      Prescaler := Integer (25_000_000.0 / (4096.0 * Freq)) - 1;
      Prescaler := Integer'Min (Prescaler, 255);
      Prescaler := Integer'Max (Prescaler, 3);

      Write_Register (PCA9685_MODE1_REG, MODE1_SLEEP); -- Sleep
      Write_Register (PCA9685_PRESCALE_REG, UInt8 (Prescaler));

      Write_Register (PCA9685_MODE1_REG, 0); -- Not Sleep
      RP.Device.Timer.Delay_Milliseconds (500);
   end Set_Frequency;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Set_Frequency (50.0);
      Write_Register (PCA9685_MODE1_REG, MODE1_RESTART or MODE1_AUTOINC);
   end Initialize;

   ---------------
   -- Set_Wheel --
   ---------------

   procedure Set_Wheel (Wheel : Steering_Wheel_Id;
                        Side  : Side_Id;
                        V     : Integer)
   is
   begin
      case Side is
         when Left =>
            case Wheel is
               when Front =>
                  Set_PWM (9, PWM_Range (V));
               when Back =>
                  Set_PWM (11, PWM_Range (V));
            end case;

         when Right =>
            case Wheel is
               when Front =>
                  Set_PWM (15, PWM_Range (V));
               when Back =>
                  Set_PWM (13, PWM_Range (V));
            end case;
      end case;
   end Set_Wheel;

   --------------
   -- Set_Mast --
   --------------

   procedure Set_Mast (V : Mast_Angle) is
      Center     : constant := 327.0;
      Side_Range : constant := 200.0;
      Move_Step  : constant := Side_Range / 90.0;

      Offset : constant Integer := Integer (-Float (V) * Move_Step);
      Pos : constant PWM_Range := PWM_Range (Integer (Center) + Offset);
   begin
      Set_PWM (0, Pos);
   end Set_Mast;

begin
   Initialize;
end Rover.Servos;
