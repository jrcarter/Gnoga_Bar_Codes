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

   Fit : Bar_Codes.Module_Box;

   procedure Generate (Code : in out Bar_Code; Kind : In Bar_Codes.Kind_Of_Code; Text : in String) is
      Rectangle  : constant Gnoga.Types.Rectangle_Type := (X => 0, Y => 0, Width => Code.Box.Width, Height => Code.Box.Height);

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
      Last    : Natural := Text'Last;
      Scale   : Natural := 2;
   begin -- Generate
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.White);
      Context.Fill_Rectangle (Rectangle => Rectangle);

      Truncate : loop
         exit Truncate when Last < Text'First;

         Fit := Bar_Codes.Fitting (Kind, Text (Text'First .. Last) );

         case Kind is
         when Bar_Codes.Code_128 =>
            null;
         when Bar_Codes.Code_QR =>
            Scale := Code.Box.Width / Fit.Width;
         end case;

         exit Truncate when Scale * Fit.Width <= Rectangle.Width;

         Last := Last - 1;
      end loop Truncate;

      Fit := Bar_Codes.Fitting (Kind, Text (Text'First .. Last) );
      Code.Kind := Kind;
      Code.Draw (Kind => Kind, Text => Text (Text'First .. Last) );
   end Generate;

   procedure Filled_Rectangle (Code : in Bar_Code; Shape : in Bar_Codes.Module_Box) is
      use type Bar_Codes.Real;

      Scale_X : constant Positive := Code.Box.Width / Fit.Width;
      Scale_Y : constant Positive := Code.Box.Height / Fit.Height;

      Rectangle : Gnoga.Types.Rectangle_Type;

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
   begin -- Filled_Rectangle
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.Black);

      case Code.Kind is
      when Bar_Codes.Code_128 => -- And all other 1D bar codes
         Rectangle := (X => 2 * Shape.Left, Y => 0, Width => 2 * Shape.Width, Height => Code.Box.Height);
      when Bar_Codes.Code_QR => -- And all other 2D bar codes
         Rectangle := (X      => Scale_X * Shape.Left,
                       Y      => Code.Box.Bottom - Scale_Y * Shape.Bottom - Scale_Y * Shape.Height,
                       Width  => Scale_X * Shape.Width,
                       Height => Scale_Y * Shape.Height);
      end case;

      Context.Fill_Rectangle (Rectangle => Rectangle);
   end Filled_Rectangle;
end Gnoga_Bar_Codes;
