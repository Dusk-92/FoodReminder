------------------------------------------------------------------------------------------
-- Load and save file
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

local function CopyPosition(source, target, xKey, yKey)
    if type(source) ~= "table" then return; end

    local x = tonumber(source[xKey]);
    local y = tonumber(source[yKey]);

    if x ~= nil then target[xKey] = x; end
    if y ~= nil then target[yKey] = y; end
end

local function CopyNestedBoolean(source, sourceKey, valueKey, target)
    if type(source) ~= "table" or type(source[sourceKey]) ~= "table" then return; end

    local value = source[sourceKey][valueKey];
    if type(value) == "boolean" then
        target[sourceKey][valueKey] = value;
    end
end

local function ClampLayout()
    local lines = math.floor(tonumber(settings["nbrLine"]["nbr"]) or 1);
    local slots = math.floor(tonumber(settings["nbrSlots"]["nbr"]) or 7);

    if lines < 1 then lines = 1; end
    if lines > 24 then lines = 24; end
    if slots < 3 then slots = 3; end
    if slots > 24 then slots = 24; end

    if (lines * slots) > NbrSlotsMax then
        lines = math.max(1, math.floor(NbrSlotsMax / slots));
    end

    settings["nbrLine"]["nbr"] = lines;
    settings["nbrSlots"]["nbr"] = slots;
end

------------------------------------------------------------------------------------------
-- Load settings without replacing the complete default table.
-- Missing/new fields are filled from Init.lua and existing shortcuts are preserved.
------------------------------------------------------------------------------------------
function LoadSettings()
    local loaded = PatchDataLoad(dataScope, settingsFileName, settings);

    if type(loaded) == "table" then
        CopyPosition(loaded.windowPosition, settings.windowPosition, "xPos", "yPos");
        CopyPosition(loaded.optionsWindowPosition, settings.optionsWindowPosition, "xPos", "yPos");
        CopyPosition(loaded.IconPosition, settings.IconPosition, "xPosIcon", "yPosIcon");

        if type(loaded.shortcuts) == "table" then
            for i = 1, NbrSlotsMax do
                local dataKey = "Data" .. i;
                local typeKey = "Type" .. i;

                if loaded.shortcuts[dataKey] ~= nil then
                    settings.shortcuts[dataKey] = loaded.shortcuts[dataKey];
                end
                if loaded.shortcuts[typeKey] ~= nil then
                    settings.shortcuts[typeKey] = loaded.shortcuts[typeKey];
                end
            end
        end

        CopyNestedBoolean(loaded, "isMinimizeEnabled", "isMinimizeEnabled", settings);
        CopyNestedBoolean(loaded, "isWindowVisible", "isWindowVisible", settings);
        CopyNestedBoolean(loaded, "isOptionsWindowVisible", "isOptionsWindowVisible", settings);
        CopyNestedBoolean(loaded, "escEnable", "escEnable", settings);
        CopyNestedBoolean(loaded, "altEnable", "altEnable", settings);
        CopyNestedBoolean(loaded, "borderShow", "value", settings);

        if type(loaded.nbrLine) == "table" and tonumber(loaded.nbrLine.nbr) ~= nil then
            settings.nbrLine.nbr = tonumber(loaded.nbrLine.nbr);
        end
        if type(loaded.nbrSlots) == "table" and tonumber(loaded.nbrSlots.nbr) ~= nil then
            settings.nbrSlots.nbr = tonumber(loaded.nbrSlots.nbr);
        end

        -- Older saves sometimes stored isLocked as a table.
        if type(loaded.isLocked) == "boolean" then
            settings.isLocked = loaded.isLocked;
        elseif type(loaded.isLocked) == "table" then
            if type(loaded.isLocked.value) == "boolean" then
                settings.isLocked = loaded.isLocked.value;
            elseif type(loaded.isLocked.isLocked) == "boolean" then
                settings.isLocked = loaded.isLocked.isLocked;
            end
        end
    end

    ClampLayout();
end

------------------------------------------------------------------------------------------
-- Save settings. UI positions are sampled only when their controls exist.
------------------------------------------------------------------------------------------
function SaveSettings()
    if FoodAndDrinks ~= nil then
        settings.windowPosition.xPos = FoodAndDrinks:GetLeft();
        settings.windowPosition.yPos = FoodAndDrinks:GetTop();
    end

    if OptionsWindow ~= nil then
        settings.optionsWindowPosition.xPos = OptionsWindow:GetLeft();
        settings.optionsWindowPosition.yPos = OptionsWindow:GetTop();
    end

    if MainMinimizedIcon ~= nil then
        settings.IconPosition.xPosIcon = MainMinimizedIcon:GetLeft();
        settings.IconPosition.yPosIcon = MainMinimizedIcon:GetTop();
    end

    ClampLayout();

    local ok, err = pcall(function()
        PatchDataSave(dataScope, settingsFileName, settings);
    end);

    if not ok then
        Turbine.Shell.WriteLine("[FoodReminder] Save error: " .. tostring(err));
    end
end
