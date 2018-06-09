-- Widget for creating bar codes with Gnoga
--
-- Copyright (C) 2018 by PragmAda Software Engineering
--
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Bar_Codes;
with Gnoga.Gui.Base;

private with Gnoga.Gui.Element.Canvas;

package Gnoga_Bar_Codes is
   type Bar_Code is new Bar_Codes.Bar_Code with private;

   procedure Create (Code   : in out Bar_Code;
                     Parent : in out Gnoga.Gui.Base.Base_Type'Class;
                     Width  : in     Integer;
                     Height : in     Integer;
                     ID     : in     String := "");
   -- Creates a Bar_Code at the currunt position in Parent Width pixels wide and Height high

   procedure Generate (Code : in out Bar_Code; Kind : In Bar_Codes.Kind_Of_Code; Text : in String);
   -- Generates a bar code of Bar_Codes.Kind Kind representing Text in the (already created) Bar_Code Code
private -- Gnoga_Bar_Codes
   type Bar_Code is new Bar_Codes.Bar_Code with record
      Canvas : Gnoga.Gui.Element.Canvas.Canvas_Access;
      Box    : Bar_Codes.Box;
   end record;

   overriding procedure Filled_Rectangle (Code : in Bar_Code; Shape : in Bar_Codes.Box);
end Gnoga_Bar_Codes;
