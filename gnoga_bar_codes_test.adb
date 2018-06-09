-- Test program for Gnoga_Bar_Codes
--
-- Copyright (C) 2018 by PragmAda Software Engineering
--
-- Released under the terms of the 3-Clause BSD License. See https://opensource.org/licenses/BSD-3-Clause

with Bar_Codes;
with Gnoga.Application.Singleton;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.Window;
with Gnoga_Bar_Codes;
with Gnoga_Extra;

procedure Gnoga_Bar_Codes_Test is
   Window : Gnoga.Gui.Window.Window_Type;
   View   : Gnoga.Gui.Element.Form.Form_Type;
   Code   : Gnoga_Bar_Codes.Bar_Code;
   Input  : Gnoga_Extra.Text_Info;
   Gen    : Gnoga.Gui.Element.Common.Button_Type;
   Quit   : Gnoga.Gui.Element.Common.Button_Type;

   procedure Generate (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
   begin -- Generate
      Code.Generate (Kind => Bar_Codes.Code_128, Text => Input.Box.Value);
   exception -- Generate
   when Bar_Codes.Cannot_Encode =>
      Code.Generate (Kind => Bar_Codes.Code_128, Text => "");
   end Generate;

   procedure Quit_Now (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      -- Empty;
   begin -- Quit_Now
      Gnoga.Application.Singleton.End_Application;
   end Quit_Now;
begin -- Gnoga_Bar_Codes_Test
   Gnoga.Application.Title ("Gnoga Bar-Codes Test");
   Gnoga.Application.HTML_On_Close ("Gnoga Bar-Codes Test ended.");
   Gnoga.Application.Open_URL;
   Gnoga.Application.Singleton.Initialize (Main_Window => Window);

   View.Create (Parent => Window);
   View.Text_Alignment (Value => Gnoga.Gui.Element.Center);
   Code.Create (Parent => View, Width => 400, Height => 100);
   View.New_Line;

   Input.Create (Form => View, Label => "Text :", Width => 20);

   Gen.Create (Parent => View, Content => "Generate");
   Gen.On_Click_Handler (Handler => Generate'Unrestricted_Access);
   View.New_Line;

   Quit.Create (Parent => View, Content => "Quit");
   Quit.On_Click_Handler (Handler => Quit_Now'Unrestricted_Access);

   Gnoga.Application.Singleton.Message_Loop;
end Gnoga_Bar_Codes_Test;
