------------------------------------------------------------------------------------------
-- Commands
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

FoodAndDrinksCommand = Turbine.ShellCommand();

local function Trim(value)
    return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""));
end

local function SetMainWindowVisible(value)
    FoodAndDrinks:SetVisible(value);
    settings.isWindowVisible.isWindowVisible = value;
end

local function RepositionLauncher(x, y)
    x = tonumber(x);
    y = tonumber(y);

    if x == nil or y == nil then
        return false;
    end

    x = math.floor(x);
    y = math.floor(y);

    local maxX = math.max(0, Turbine.UI.Display:GetWidth() - 33);
    local maxY = math.max(0, Turbine.UI.Display:GetHeight() - 33);

    if x < 0 then x = 0; end
    if y < 0 then y = 0; end
    if x > maxX then x = maxX; end
    if y > maxY then y = maxY; end

    settings.IconPosition.xPosIcon = x;
    settings.IconPosition.yPosIcon = y;

    if MainMinimizedIcon ~= nil then
        MainMinimizedIcon:SetPosition(x, y);
    end

    return true;
end

function FoodAndDrinksCommand:Execute(command, arguments)
    arguments = Trim(arguments);
    local lower = string.lower(arguments);

    if lower == "help" or lower == "" then
        commandsHelp();

    elseif lower == "show" then
        Write(rgb.start .. pluginName .. rgb.clear .. " - " .. T["PluginWindowShow"]);
        SetMainWindowVisible(true);
        if OptionsWindow ~= nil then OptionsWindow:SetVisible(false); end
        settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
        SaveSettings();

    elseif lower == "hide" then
        Write(rgb.start .. pluginName .. rgb.clear .. " - " .. T["PluginWindowHide"]);
        SetMainWindowVisible(false);
        SaveSettings();

    elseif lower == "toggle" then
        local visible = not FoodAndDrinks:IsVisible();
        SetMainWindowVisible(visible);
        Write(rgb.start .. pluginName .. rgb.clear .. " - "
            .. (visible and T["PluginWindowShow"] or T["PluginWindowHide"]));
        SaveSettings();

    elseif lower == "lock" then
        settings.isLocked = not (settings.isLocked == true);
        Write(rgb.start .. pluginName .. rgb.clear .. " : "
            .. (settings.isLocked and T["PluginLocked"] or T["PluginUnlocked"]));
        SaveSettings();

    elseif lower == "options" then
        Write(rgb.start .. pluginName .. rgb.clear .. " - " .. T["PluginOptionsWindowShow"]);
        OptionsWindow:SetVisible(true);
        SetMainWindowVisible(false);
        settings.isOptionsWindowVisible.isOptionsWindowVisible = true;
        SaveSettings();

    elseif lower == "clear" then
        Write(rgb.start .. pluginName .. rgb.clear .. " - " .. T["PluginWindowClear"]);
        ClearWindow();
        SaveSettings();

    elseif lower == "esc" then
        settings.escEnable.escEnable = not (settings.escEnable.escEnable == true);
        Write(rgb.start .. pluginName .. rgb.clear .. " - "
            .. (settings.escEnable.escEnable and T["PluginEscEnable"] or T["PluginEscDesable"]));
        SaveSettings();

    elseif lower == "repos" then
        Write(rgb.start .. pluginName .. rgb.clear .. " : " .. T["PluginPosition"]
            .. " X: " .. tostring(settings.IconPosition.xPosIcon));
        Write(rgb.start .. pluginName .. rgb.clear .. " : " .. T["PluginPosition"]
            .. " Y: " .. tostring(settings.IconPosition.yPosIcon));

    elseif string.match(lower, "^repos%s+") then
        local x, y = string.match(lower, "^repos%s+([%-]?%d+)%s+([%-]?%d+)%s*$");
        if RepositionLauncher(x, y) then
            Write(rgb.start .. pluginName .. rgb.clear .. " : " .. T["PluginResize"]
                .. tostring(settings.IconPosition.xPosIcon) .. "x"
                .. tostring(settings.IconPosition.yPosIcon));
            SaveSettings();
        else
            Write(rgb.error .. T["PluginPositionInvalid"] .. rgb.clear);
        end

    elseif lower == "alt" then
        settings.altEnable.altEnable = not (settings.altEnable.altEnable == true);
        Write(rgb.start .. pluginName .. rgb.clear .. " - "
            .. (settings.altEnable.altEnable and T["PluginAltEnable"] or T["PluginAltDesable"]));
        SaveSettings();

    else
        commandsHelp();
    end
end

Turbine.Shell.AddCommand("Fo;FoodReminder;FoodAndDrinks", FoodAndDrinksCommand);
