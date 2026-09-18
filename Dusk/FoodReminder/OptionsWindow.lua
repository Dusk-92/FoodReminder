------------------------------------------------------------------------------------------
-- Options window
-- FoodReminder - Dusk
------------------------------------------------------------------------------------------

local windowWidth = 400;
local windowHeight = 300;
local positionInitiale = 40;

local function ClampOptionsPosition()
    local x = tonumber(settings.optionsWindowPosition.xPos);
    local y = tonumber(settings.optionsWindowPosition.yPos);

    if x == nil or y == nil then
        x = math.floor((Turbine.UI.Display:GetWidth() - windowWidth) / 2);
        y = math.floor((Turbine.UI.Display:GetHeight() - windowHeight) / 2);
    end

    local maxX = math.max(0, Turbine.UI.Display:GetWidth() - windowWidth);
    local maxY = math.max(0, Turbine.UI.Display:GetHeight() - windowHeight);

    x = math.max(0, math.min(maxX, math.floor(x)));
    y = math.max(0, math.min(maxY, math.floor(y)));

    settings.optionsWindowPosition.xPos = x;
    settings.optionsWindowPosition.yPos = y;
    return x, y;
end

function GenerateOptionsWindow()
    OptionsWindow = Turbine.UI.Lotro.GoldWindow();
    OptionsWindow:SetSize(windowWidth, windowHeight);
    OptionsWindow:SetText(T["PluginOptionsText"]);
    OptionsWindow:SetZOrder(0);
    OptionsWindow:SetWantsKeyEvents(true);

    local x, y = ClampOptionsPosition();
    OptionsWindow:SetPosition(x, y);
    OptionsWindow:SetVisible(false);
    settings.isOptionsWindowVisible.isOptionsWindowVisible = false;

    local footer = Turbine.UI.Label();
    footer:SetParent(OptionsWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(windowWidth / 2 - 75, windowHeight - 17);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local lineTitle = Turbine.UI.Label();
    lineTitle:SetParent(OptionsWindow);
    lineTitle:SetSize(300, 20);
    lineTitle:SetPosition(windowWidth / 2 - 150, positionInitiale);
    lineTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    lineTitle:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    lineTitle:SetText(T["PluginOption1"]);

    local lineHint = Turbine.UI.Label();
    lineHint:SetParent(OptionsWindow);
    lineHint:SetSize(300, 20);
    lineHint:SetPosition(windowWidth / 2 - 150, positionInitiale + 15);
    lineHint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    lineHint:SetFont(Turbine.UI.Lotro.Font.Verdana12);
    lineHint:SetText("1 - 24");

    textBoxLines = Turbine.UI.Lotro.TextBox();
    textBoxLines:SetParent(OptionsWindow);
    textBoxLines:SetSize(100, 30);
    textBoxLines:SetText(tostring(settings.nbrLine.nbr));
    textBoxLines:SetPosition(windowWidth / 2 - 50, positionInitiale + 30);
    textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    textBoxLines:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    textBoxLines:SetBackColor(Turbine.UI.Color(.9, .5, .7, .5));

    local slotsTitle = Turbine.UI.Label();
    slotsTitle:SetParent(OptionsWindow);
    slotsTitle:SetSize(300, 20);
    slotsTitle:SetPosition(windowWidth / 2 - 150, positionInitiale + 80);
    slotsTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    slotsTitle:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    slotsTitle:SetText(T["PluginOption2"]);

    local slotsHint = Turbine.UI.Label();
    slotsHint:SetParent(OptionsWindow);
    slotsHint:SetSize(300, 20);
    slotsHint:SetPosition(windowWidth / 2 - 150, positionInitiale + 95);
    slotsHint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    slotsHint:SetFont(Turbine.UI.Lotro.Font.Verdana12);
    slotsHint:SetText("3 - 24 (max 240)");

    textBoxSlots = Turbine.UI.Lotro.TextBox();
    textBoxSlots:SetParent(OptionsWindow);
    textBoxSlots:SetSize(100, 30);
    textBoxSlots:SetText(tostring(settings.nbrSlots.nbr));
    textBoxSlots:SetPosition(windowWidth / 2 - 50, positionInitiale + 125);
    textBoxSlots:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    textBoxSlots:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    textBoxSlots:SetBackColor(Turbine.UI.Color(.9, .5, .7, .5));

    checkBoxKeep = Turbine.UI.Lotro.CheckBox();
    checkBoxKeep:SetParent(OptionsWindow);
    checkBoxKeep:SetSize(350, 20);
    checkBoxKeep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    checkBoxKeep:SetText(T["PluginOption3"]);
    checkBoxKeep:SetPosition(windowWidth / 2 - 100, 210);
    checkBoxKeep:SetChecked(settings.borderShow.value == true);
    checkBoxKeep:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));

    buttonValider = Turbine.UI.Lotro.GoldButton();
    buttonValider:SetParent(OptionsWindow);
    buttonValider:SetPosition(windowWidth / 2 - 125, 250);
    buttonValider:SetSize(300, 20);
    buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    buttonValider:SetText(T["PluginOptionValidate"]);
    buttonValider:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);

    ValidateChanges();
    ClosingTheOptionsWindow();
    OptionsWindowPositionChanged();
end

function ValidateChanges()
    buttonValider.MouseClick = function(sender, args)
        local lines = math.floor(tonumber(textBoxLines:GetText()) or tonumber(settings.nbrLine.nbr) or 1);
        local slots = math.floor(tonumber(textBoxSlots:GetText()) or tonumber(settings.nbrSlots.nbr) or 7);

        lines = math.max(1, math.min(24, lines));
        slots = math.max(3, math.min(24, slots));

        if (lines * slots) > NbrSlotsMax then
            lines = math.max(1, math.floor(NbrSlotsMax / slots));
        end

        settings.nbrLine.nbr = lines;
        settings.nbrSlots.nbr = slots;
        settings.borderShow.value = checkBoxKeep:IsChecked() == true;
        settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
        settings.isWindowVisible.isWindowVisible = true;

        textBoxLines:SetText(tostring(lines));
        textBoxSlots:SetText(tostring(slots));

        OptionsWindow:SetVisible(false);
        SaveSettings();
        UpdateWindow();
        UpdateOptionsWindow();
    end
end
