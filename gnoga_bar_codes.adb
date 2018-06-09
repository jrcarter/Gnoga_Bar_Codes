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
      Code.Box := (Left   => 0.0,
                   Bottom => Bar_Codes.Real (Height),
                   Width  => Bar_Codes.Real (Width),
                   Height => Bar_Codes.Real (Height) );
   end Create;

   procedure Generate (Code : in out Bar_Code; Kind : In Bar_Codes.Kind_Of_Code; Text : in String) is
      Rectangle : constant Gnoga.Types.Rectangle_Type :=
         (X => 0, Y => 0, Width => Integer (Code.Box.Width), Height => Integer (Code.Box.Height) );

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
   begin -- Generate
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.White);
      Context.Fill_Rectangle (Rectangle => Rectangle);
      Code.Draw (Kind => Kind, Bounding => Code.Box, Text => Text);
   end Generate;

   procedure Filled_Rectangle (Code : in Bar_Code; Shape : in Bar_Codes.Box) is
      use type Bar_Codes.Real;

      Rectangle : constant Gnoga.Types.Rectangle_Type := (X      => Integer (Shape.Left),
                                                          Y      => Integer (Shape.Bottom - Shape.Height),
                                                          Width  => Integer (Shape.Width),
                                                          Height => Integer (Shape.Height) );

      Context : Gnoga.Gui.Element.Canvas.Context_2D.Context_2D_Type;
   begin -- Filled_Rectangle
      Context.Get_Drawing_Context_2D (Canvas => Code.Canvas.all);
      Context.Fill_Color (Value => Gnoga.Types.Colors.Black);
      Context.Fill_Rectangle (Rectangle => Rectangle);
   end Filled_Rectangle;
end Gnoga_Bar_Codes;
