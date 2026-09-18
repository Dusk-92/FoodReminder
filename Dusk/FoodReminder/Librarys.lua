------------------------------------------------------------------------------------------
-- _init_ file
-- FoodReminder - Dusk
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- import librarys
------------------------------------------------------------------------------------------
import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";
import "Turbine.Gameplay";
import "Turbine.Gameplay.Attributes";
------------------------------------------------------------------------------------------
-- Import Globals --
------------------------------------------------------------------------------------------
if Turbine.Engine.GetLanguage() == Turbine.Language.German then
	import "Dusk.FoodReminder.Localization.GlobalsDE";
	GLocale = "de";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
	import "Dusk.FoodReminder.Localization.GlobalsFR";
	GLocale = "fr";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
	import "Dusk.FoodReminder.Localization.GlobalsEN";
	GLocale = "en";
end
------------------------------------------------------------------------------------------
-- Import Utility --
------------------------------------------------------------------------------------------
import "Dusk.FoodReminder.VindarPatch";
import "Dusk.FoodReminder.Notification";
import "Dusk.FoodReminder.LoadAndSave";
import "Dusk.FoodReminder.MinimizedIcon";
import "Dusk.FoodReminder.FCT";
------------------------------------------------------------------------------------------
-- Import initialization --
------------------------------------------------------------------------------------------
import "Dusk.FoodReminder.Init";
import "Dusk.FoodReminder.Activation";
------------------------------------------------------------------------------------------
-- Import Scripts --
------------------------------------------------------------------------------------------
import "Dusk.FoodReminder.Main";
------------------------------------------------------------------------------------------
-- Import UI elements --
------------------------------------------------------------------------------------------
import "Dusk.FoodReminder.UI";
import "Dusk.FoodReminder.OptionsWindow";
------------------------------------------------------------------------------------------
-- Import Commands --
------------------------------------------------------------------------------------------
import "Dusk.FoodReminder.Commands";