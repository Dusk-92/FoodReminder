------------------------------------------------------------------------------------------
-- Imports
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";
import "Turbine.Gameplay";
import "Turbine.Gameplay.Attributes";

-- Localization: every unknown/legacy language safely falls back to English.
if Turbine.Engine.GetLanguage() == Turbine.Language.German then
    import "Dusk.FoodReminder.Localization.GlobalsDE";
    GLocale = "de";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
    import "Dusk.FoodReminder.Localization.GlobalsFR";
    GLocale = "fr";
else
    import "Dusk.FoodReminder.Localization.GlobalsEN";
    GLocale = "en";
end

import "Dusk.FoodReminder.VindarPatch";
import "Dusk.FoodReminder.Notification";
import "Dusk.FoodReminder.LoadAndSave";
import "Dusk.FoodReminder.MinimizedIcon";
import "Dusk.FoodReminder.FCT";

import "Dusk.FoodReminder.Init";
import "Dusk.FoodReminder.Activation";

import "Dusk.FoodReminder.UI";
import "Dusk.FoodReminder.OptionsWindow";
import "Dusk.FoodReminder.Commands";
