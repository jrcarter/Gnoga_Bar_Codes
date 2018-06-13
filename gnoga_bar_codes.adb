-- Widget for creating bar codes with Gnoga
--
-- Copyright (C) 2018 by PragmAda Software Engineering
--
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Gnoga.Gui.Element.Canvas.Context_2D;
with Gnoga.Types.Colors;

package body Gnoga_Bar_Codes is
   procedure Create (Code   : in out Bar_Code;
                     Parent : in out Gnoga.Gui.Base.Base_Type'Class;
                     Width  : in     Integer;
                     Height : in     Integer;
                     ID     : in     String := "")
   is
      use type Gnoga.Gui.Element.Canvas.Canvas_Access;
   begin -- Create
      Code.Canvas := new Gnoga.Gui.Element.Canvas.Canvas_Type;
      Code.Canvas.Create (Parent => Parent, Width => Width, Height => Height, ID => ID);
      Code.Canvas.Dynamic;
      Code.Box := (Left => 0, Bottom => Height, Width => Width, Height => Height);
   end Create;

   procedure Generate (Code : in out Bar_Code; Kind : In Bar_Codes.Kind_Of_Code; Text : in String) is
      Rectangle  : constant Gnoga.Types.Rectangle_Type := (X => 0, Y => 0, Width => Code.Box.Width, Height => Code.Box.Height);

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
      Last    : Natural := Text'Last;
   begin -- Generate
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.White);
      Context.Fill_Rectangle (Rectangle => Rectangle);

      Truncate : loop
         exit Truncate when Last < Text'First or else
                            2 * Bar_Codes.Fitting (Kind, Text (Text'First .. Last) ).Width <= Rectangle.Width;

         Last := Last - 1;
      end loop Truncate;

      Code.Kind := Kind;
      Code.Draw (Kind => Kind, Text => Text (Text'First .. Last) );
   end Generate;

   procedure Filled_Rectangle (Code : in Bar_Code; Shape : in Bar_Codes.Module_Box) is
      use type Bar_Codes.Real;

      Rectangle : Gnoga.Types.Rectangle_Type := (X => 2 * Shape.Left, Width => 2 * Shape.Width, others => <>);

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
   begin -- Filled_Rectangle
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.Black);

      case Code.Kind is
      when Bar_Codes.Code_128 => -- And all other 1D bar codes
         Rectangle.Y := 0;
         Rectangle.Height := Code.Box.Height;
      end case;
      -- 2D bar codes will have Y := Code.Box.Bottom - 2 * Shape.Bottom - 2 * Shape.Height and Height := 2 * Shape.Height

      Context.Fill_Rectangle (Rectangle => Rectangle);
   end Filled_Rectangle;
end Gnoga_Bar_Codes;
