------------------------------------------------------------------------------------------
-- Minimized icon class
-- Based on the original Ooz implementation
------------------------------------------------------------------------------------------

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

MinimizedIcon = class(Turbine.UI.Window);

function MinimizedIcon:Constructor(image, width, height, callback)
    Turbine.UI.Window.Constructor(self);

    self:SetOpacity(1);
    self:SetVisible(true);
    self:SetZOrder(0);
    self:SetMouseVisible(true);
    self:SetWantsUpdates(false);

    self.passiveImage = image;
    self.defaultOpacity = 1;
    self.drag = false;
    self.active = false;
    self.framesPerActiveImage = 20;

    self.icon = Turbine.UI.Control();
    self.icon:SetParent(self);
    self.icon:SetBackground(self.passiveImage);
    self.icon:SetMouseVisible(false);

    self.trigger = Turbine.UI.Button();
    self.trigger:SetParent(self);
    self.trigger:SetZOrder(1);

    self:SetSize(width, height);

    local sh = Turbine.UI.Display.GetHeight() - self:GetHeight() - 1;
    self:SetPosition(1, sh);

    self.MouseEnter = function(sender, args)
        self:SetOpacity(1.0);
    end

    self.MouseLeave = function(sender, args)
        self:SetOpacity(self.defaultOpacity);
    end

    self.trigger.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            if settings.isOptionsWindowVisible.isOptionsWindowVisible == false then
                OptionsWindow:SetVisible(true);
                OptionsWindow:SetZOrder(OptionsWindow:GetZOrder() + 1);
                FoodAndDrinks:SetVisible(false);
                settings.isWindowVisible.isWindowVisible = false;
                settings.isOptionsWindowVisible.isOptionsWindowVisible = true;
            else
                OptionsWindow:SetVisible(false);
                settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
            end
            SaveSettings();
            return;
        end

        if args.Button ~= Turbine.UI.MouseButton.Left or self.thresholdTrigger then
            return;
        end

        if self.IsShiftKeyDown() then
            settings.isLocked = not (settings.isLocked == true);
            Write(rgb.start .. T["PluginName"] .. rgb.clear .. " : "
                .. (settings.isLocked and T["PluginLocked"] or T["PluginUnlocked"]));
            SaveSettings();
            return;
        end

        local show = not FoodAndDrinks:IsVisible();
        FoodAndDrinks:SetVisible(show);
        settings.isWindowVisible.isWindowVisible = show;

        if show then
            FoodAndDrinks:SetZOrder(FoodAndDrinks:GetZOrder() + 1);
            OptionsWindow:SetVisible(false);
            settings.isOptionsWindowVisible.isOptionsWindowVisible = false;
        end

        SaveSettings();
    end

    self.trigger.MouseDown = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Left then return; end
        self.drag = true;
        self.thresholdTrigger = false;
        self.mx0 = args.X;
        self.my0 = args.Y;
    end

    self.trigger.MouseUp = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Left then return; end

        local wasMoved = self.thresholdTrigger == true;
        self.drag = false;

        if wasMoved then
            settings.IconPosition.xPosIcon = self:GetLeft();
            settings.IconPosition.yPosIcon = self:GetTop();
            SaveSettings();
        end
    end

    self.trigger.MouseMove = function(sender, args)
        if not self.drag then return; end
        if settings.altEnable.altEnable == true and not self.IsAltKeyDown() then return; end

        local dx = args.X - self.mx0;
        local dy = args.Y - self.my0;

        if self.thresholdTrigger or math.abs(dx) > 3 or math.abs(dy) > 3 then
            self.thresholdTrigger = true;

            local x = self:GetLeft() + dx;
            local y = self:GetTop() + dy;
            local maxX = Turbine.UI.Display.GetWidth() - self:GetWidth() - 1;
            local maxY = Turbine.UI.Display.GetHeight() - self:GetHeight() - 1;

            if x < 0 then x = 0; end
            if y < 0 then y = 0; end
            if x > maxX then x = maxX; end
            if y > maxY then y = maxY; end

            self:SetPosition(x, y);
        end
    end

    self.Update = function(sender, args)
        if not self.active then return; end

        if not Turbine.Gameplay.LocalPlayer.GetInstance():IsInCombat() then
            self.frameCount = self.frameCount + 1;

            if self.frameCount > self.framesPerActiveImage then
                self.frameCount = 0;
                self.currentImageIndex = self.currentImageIndex + 1;

                if self.currentImageIndex > #self.imageTable then
                    self.currentImageIndex = 1;
                end

                self.icon:SetBackground(self.imageTable[self.currentImageIndex]);

                if self.activeTickCallback ~= nil then
                    self.activeTickCallback();
                end
            end
        end
    end
end

function MinimizedIcon:SetDefaultOpacity(opacity)
    self.defaultOpacity = opacity;
    self:SetOpacity(opacity);
end

function MinimizedIcon:SetActiveAnimation(imageTable)
    self.imageTable = imageTable;
    self.currentImageIndex = 1;
    self.frameCount = 0;
end

function MinimizedIcon:SetActive(value)
    if value then
        self:SetOpacity(.90);

        if self.imageTable == nil or #self.imageTable == 0 then
            self.imageTable = { self.passiveImage };
        end

        self:SetWantsUpdates(true);
        self.active = true;
    else
        self.active = false;
        self:SetWantsUpdates(false);
        self:SetOpacity(self.defaultOpacity);
        self.icon:SetBackground(self.passiveImage);
    end
end

function MinimizedIcon:SetFramesPerActiveImage(value)
    self.framesPerActiveImage = math.max(1, tonumber(value) or 20);
end

function MinimizedIcon:SetActiveTickCallback(callback)
    self.activeTickCallback = callback;
end

function MinimizedIcon:SetSize(width, height)
    Turbine.UI.Control.SetSize(self, width, height);
    if self.icon ~= nil then self.icon:SetSize(width, height); end
    if self.trigger ~= nil then self.trigger:SetSize(width, height); end
end

function MinimizedIcon:SetHeight(height)
    self:SetSize(self:GetWidth(), height);
end

function MinimizedIcon:SetWidth(width)
    self:SetSize(width, self:GetHeight());
end

function MinimizedIcon:SetText(text)
    self.trigger:SetText(text);
end

function MinimizedIcon:SetFont(font)
    self.trigger:SetFont(font);
end

function MinimizedIcon:SetFontStyle(style)
    self.trigger:SetFontStyle(style);
end

function MinimizedIcon:SetForeColor(color)
    self.trigger:SetForeColor(color);
end

function MinimizedIcon:SetOutlineColor(color)
    self.trigger:SetOutlineColor(color);
end
