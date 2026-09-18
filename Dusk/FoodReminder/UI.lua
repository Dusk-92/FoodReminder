------------------------------------------------------------------------------------------
-- Main UI
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

centerWindow = {};
centerQS = {};

local function ClampMainWindowPosition(window)
    local x = tonumber(settings.windowPosition.xPos) or 500;
    local y = tonumber(settings.windowPosition.yPos) or 500;
    local maxX = math.max(0, Turbine.UI.Display:GetWidth() - window:GetWidth());
    local maxY = math.max(0, Turbine.UI.Display:GetHeight() - window:GetHeight());

    x = math.max(0, math.min(maxX, math.floor(x)));
    y = math.max(0, math.min(maxY, math.floor(y)));

    settings.windowPosition.xPos = x;
    settings.windowPosition.yPos = y;
    return x, y;
end

function GenerateWindow()
    local iconSize = 40;
    local horizontalPosition = 20;
    local verticalPosition = 40;
    local nbrSlot = 0;
    local slotsPerLine = tonumber(settings.nbrSlots.nbr) or 7;
    local lines = tonumber(settings.nbrLine.nbr) or 1;
    local totalSlots = math.min(NbrSlotsMax, slotsPerLine * lines);
    local windowWidth = (slotsPerLine * (iconSize + 2)) + 38;
    local windowHeight = (lines * (iconSize + 4)) + 60;

    if settings.borderShow.value == true then
        FoodAndDrinks = Turbine.UI.Lotro.GoldWindow();
    else
        FoodAndDrinks = Turbine.UI.Extensions.SimpleWindow();
    end

    FoodAndDrinks:SetSize(windowWidth, windowHeight);
    FoodAndDrinks:SetText(T["PluginName"]);

    FoodAndDrinks.Message = Turbine.UI.Label();
    FoodAndDrinks.Message:SetParent(FoodAndDrinks);
    FoodAndDrinks.Message:SetSize(150, 10);
    FoodAndDrinks.Message:SetPosition(windowWidth / 2 - 75, windowHeight - 20);
    FoodAndDrinks.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    FoodAndDrinks.Message:SetText(settings.borderShow.value == true and T["PluginText"] or "");

    FoodAndDrinks:SetZOrder(0);
    FoodAndDrinks:SetWantsKeyEvents(true);

    local x, y = ClampMainWindowPosition(FoodAndDrinks);
    FoodAndDrinks:SetPosition(x, y);

    for i = 1, totalSlots do
        if nbrSlot == slotsPerLine then
            verticalPosition = verticalPosition + 40;
            nbrSlot = 0;
            horizontalPosition = 20;
        end

        centerWindow[i] = Turbine.UI.Extensions.SimpleWindow();
        centerWindow[i]:SetSize(iconSize, iconSize);
        centerWindow[i]:SetParent(FoodAndDrinks);
        centerWindow[i]:SetPosition(horizontalPosition, verticalPosition);
        centerWindow[i]:SetVisible(true);
        centerWindow[i]:SetBackColor(Turbine.UI.Color(.3, .5, .7, .5));

        local label = Turbine.UI.Label();
        label:SetParent(centerWindow[i]);
        label:SetPosition(0, 0);
        label:SetSize(iconSize, iconSize);
        label:SetText("");
        label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        label:SetZOrder(-1);
        label:SetMouseVisible(false);

        centerQS[i] = Turbine.UI.Lotro.Quickslot();
        centerQS[i]:SetParent(centerWindow[i]);
        centerQS[i]:SetPosition(1, 1);
        centerQS[i]:SetSize(iconSize - 4, iconSize - 4);
        centerQS[i]:SetUseOnRightClick(false);

        nbrSlot = nbrSlot + 1;
        horizontalPosition = horizontalPosition + 42;
    end

    SettingTheShortCuts();
    DragAndDrop();
    DeleteShortCutes();
    EscapeKeyPressed();
    ClosingTheWindow();
    WindowPositionChanged();

    FoodAndDrinks:SetVisible(settings.isWindowVisible.isWindowVisible == true);
end

function SettingTheShortCuts()
    local totalSlots = math.min(
        NbrSlotsMax,
        (tonumber(settings.nbrSlots.nbr) or 7) * (tonumber(settings.nbrLine.nbr) or 1)
    );

    for i = 1, totalSlots do
        local data = settings.shortcuts["Data" .. i];
        local shortcutType = settings.shortcuts["Type" .. i];

        if data ~= nil and data ~= "" then
            centerQS[i]:SetShortcut(Turbine.UI.Lotro.Shortcut(shortcutType, data));
        end
    end
end

local function RestoreSavedShortcut(slotIndex)
    local data = settings.shortcuts["Data" .. slotIndex];
    local shortcutType = settings.shortcuts["Type" .. slotIndex];

    if data ~= nil and data ~= "" then
        centerQS[slotIndex]:SetShortcut(Turbine.UI.Lotro.Shortcut(shortcutType, data));
    else
        centerQS[slotIndex]:SetShortcut(Turbine.UI.Lotro.Shortcut());
    end
end

function DragAndDrop()
    local totalSlots = math.min(
        NbrSlotsMax,
        (tonumber(settings.nbrSlots.nbr) or 7) * (tonumber(settings.nbrLine.nbr) or 1)
    );

    for i = 1, totalSlots do
        local slotIndex = i;

        centerQS[slotIndex].DragDrop = function(sender, args)
            if settings.isLocked == true then
                RestoreSavedShortcut(slotIndex);
                return;
            end

            local shortcut = centerQS[slotIndex]:GetShortcut();
            settings.shortcuts["Data" .. slotIndex] = shortcut:GetData();
            settings.shortcuts["Type" .. slotIndex] = shortcut:GetType();
            SaveSettings();
        end
    end
end

function DeleteShortcut(slotIndex)
    if settings.isLocked == true then
        return;
    end

    settings.shortcuts["Data" .. slotIndex] = "";
    settings.shortcuts["Type" .. slotIndex] = 0;
    centerQS[slotIndex]:SetShortcut(Turbine.UI.Lotro.Shortcut());
    SaveSettings();
end

function DeleteShortCutes()
    local totalSlots = math.min(
        NbrSlotsMax,
        (tonumber(settings.nbrSlots.nbr) or 7) * (tonumber(settings.nbrLine.nbr) or 1)
    );

    for i = 1, totalSlots do
        local slotIndex = i;

        centerQS[slotIndex].MouseWheel = function(sender, args)
            DeleteShortcut(slotIndex);
        end

        centerQS[slotIndex].MouseClick = function(sender, args)
            if args.Button == Turbine.UI.MouseButton.Right then
                DeleteShortcut(slotIndex);
            end
        end
    end
end

function ClosingTheWindow()
    FoodAndDrinks.Closing = function(sender, args)
        args.Cancel = true;
        sender:SetVisible(false);
        settings.isWindowVisible.isWindowVisible = false;
        SaveSettings();
    end
end

function UpdateWindow()
    if FoodAndDrinks ~= nil then
        FoodAndDrinks:SetVisible(false);
    end

    centerWindow = {};
    centerQS = {};
    GenerateWindow();
end

function UpdateOptionsWindow()
    if OptionsWindow ~= nil then
        OptionsWindow:SetVisible(false);
    end

    GenerateOptionsWindow();
end
