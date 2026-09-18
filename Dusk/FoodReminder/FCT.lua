------------------------------------------------------------------------------------------
-- Functions
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

local foodReminderHudHidden = false;

function ClearWindow()
    for i = 1, NbrSlotsMax do
        settings.shortcuts["Data" .. i] = "";
        settings.shortcuts["Type" .. i] = 0;

        if centerQS[i] ~= nil then
            centerQS[i]:SetShortcut(Turbine.UI.Lotro.Shortcut());
        end
    end
end

function commandsHelp()
    notification(
        rgb.start ..
        T["PluginHelp1"] ..
        rgb.clear ..
        T["PluginHelp2"] ..
        T["PluginHelp3"] ..
        T["PluginHelp4"] ..
        T["PluginHelp5"] ..
        T["PluginHelp6"] ..
        T["PluginHelp7"] ..
        T["PluginHelp8"] ..
        T["PluginHelp9"] ..
        T["PluginHelp10"] ..
        T["PluginHelp11"] ..
        T["PluginHelp12"]
    );
end

function ClosingTheOptionsWindow()
    OptionsWindow.Closing = function(sender, args)
        args.Cancel = true;
        sender:SetVisible(false);
        settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
        SaveSettings();
    end
end

function EscapeKeyPressed()
    FoodAndDrinks.KeyDown = function(sender, args)
        local escapeAction = Turbine.UI.Lotro.Action.EscapeKey or Turbine.UI.Lotro.Action.Escape;
        if args.Action == escapeAction then
            if settings.escEnable.escEnable == true then
                FoodAndDrinks:SetVisible(false);
                settings.isWindowVisible.isWindowVisible = false;
                SaveSettings();
            end

            if OptionsWindow ~= nil and OptionsWindow:IsVisible() then
                OptionsWindow:SetVisible(false);
                settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
                SaveSettings();
            end
        end

        -- F12 / HUD toggle.
        if args.Action == 268435635 then
            foodReminderHudHidden = not foodReminderHudHidden;

            if foodReminderHudHidden then
                FoodAndDrinks:SetVisible(false);
                if OptionsWindow ~= nil then OptionsWindow:SetVisible(false); end
                if MainMinimizedIcon ~= nil then MainMinimizedIcon:SetVisible(false); end
            else
                FoodAndDrinks:SetVisible(settings.isWindowVisible.isWindowVisible == true);
                if OptionsWindow ~= nil then
                    OptionsWindow:SetVisible(settings.isOptionsWindowVisible.isOptionsWindowVisible == true);
                end
                if MainMinimizedIcon ~= nil then MainMinimizedIcon:SetVisible(true); end
            end
        end
    end
end

function WindowPositionChanged()
    FoodAndDrinks.PositionChanged = function(sender, args)
        settings.windowPosition.xPos = FoodAndDrinks:GetLeft();
        settings.windowPosition.yPos = FoodAndDrinks:GetTop();
    end
end

function OptionsWindowPositionChanged()
    OptionsWindow.PositionChanged = function(sender, args)
        settings.optionsWindowPosition.xPos = OptionsWindow:GetLeft();
        settings.optionsWindowPosition.yPos = OptionsWindow:GetTop();
    end
end

function CreateAndHandleMinimizeIcon()
    MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32);
    MainMinimizedIcon:SetPosition(
        tonumber(settings.IconPosition.xPosIcon) or 20,
        tonumber(settings.IconPosition.yPosIcon) or 20
    );
    MainMinimizedIcon:SetZOrder(0);

    FoodAndDrinks:SetVisible(settings.isWindowVisible.isWindowVisible == true);
end
