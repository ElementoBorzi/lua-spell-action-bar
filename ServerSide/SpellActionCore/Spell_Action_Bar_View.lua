local AIO = AIO or require("AIO")
if AIO.AddAddon() then return end

local Server = AIO.AddHandlers("Spell_Action_Bar", {})
local Spell_Action_Bar = { }

function Spell_Action_Bar.Generate(texture, spell_id)
    if (not Spell_Action_Bar.Frame) then
        Spell_Action_Bar.GenerateMainFrame()
    end
    Spell_Action_Bar.SetTexture(texture)

    Spell_Action_Bar.GenerateSpellIcon(spell_id)
    Spell_Action_Bar.GenerateCoolDown(Spell_Action_Bar.ExtraIcon)
    Spell_Action_Bar.SetCooldown(Spell_Action_Bar.ExtraIcon)
end

function Spell_Action_Bar.GenerateMainFrame()
    Spell_Action_Bar.Frame = CreateFrame("Frame", "ExtraButtonFrame", UIParent)

    Spell_Action_Bar.Frame:EnableMouse(true)
    Spell_Action_Bar.Frame:SetToplevel(true)
    Spell_Action_Bar.Frame:SetMovable(true)
    Spell_Action_Bar.Frame:SetClampedToScreen(true)

    Spell_Action_Bar.Frame:SetSize(250, 120)

    Spell_Action_Bar.Frame:SetPoint("CENTER")
    Spell_Action_Bar.Frame:RegisterForDrag("LeftButton")
    Spell_Action_Bar.Frame:SetScript("OnDragStart", Spell_Action_Bar.Frame.StartMoving)
    Spell_Action_Bar.Frame:SetScript("OnHide", Spell_Action_Bar.Frame.StopMovingOrSizing)
    Spell_Action_Bar.Frame:SetScript("OnDragStop", Spell_Action_Bar.Frame.StopMovingOrSizing)

    AIO.SavePosition(Spell_Action_Bar.Frame)
end

function Spell_Action_Bar.GenerateSpellIcon(spellId)
    Spell_Action_Bar.ExtraButtonIcon = CreateFrame("Button", Spell_Action_Bar.ExtraButtonIcon, Spell_Action_Bar.Frame, "SecureActionButtonTemplate")
    Spell_Action_Bar.ExtraButtonIcon:SetSize(50, 50)
    Spell_Action_Bar.ExtraButtonIcon:SetPoint("Center", 1, 0)

    local _, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellId)
    Spell_Action_Bar.ExtraButtonIcon:SetFrameLevel(Spell_Action_Bar.ExtraButtonIcon:GetParent():GetFrameLevel() - 1)
    Spell_Action_Bar.ExtraButtonIcon:SetNormalTexture(icon)

    Spell_Action_Bar.ExtraIcon = CreateFrame("Button", Spell_Action_Bar.ExtraIcon, Spell_Action_Bar.Frame, "SecureActionButtonTemplate")
    Spell_Action_Bar.ExtraIcon:SetSize(45, 45)
    Spell_Action_Bar.ExtraIcon:SetPoint("Center", 0, 0)
    Spell_Action_Bar.ExtraIcon:SetAttribute("spellId", spellId)
    Spell_Action_Bar.ExtraIcon:SetFrameLevel(Spell_Action_Bar.ExtraIcon:GetParent():GetFrameLevel() + 1)

    Spell_Action_Bar.ExtraIcon:SetScript("OnClick", function()
        AIO.Handle("Spell_Action_Bar", "Cast", spellId)
    end)

    Spell_Action_Bar.ExtraIcon:SetScript("OnEnter", function(self, button, down)
        Tooltip:SetOwner(self, "ANCHOR_CURSOR")
        Tooltip:SetHyperlink("spell:" .. spellId)
        Tooltip:Show()
    end)

    Spell_Action_Bar.ExtraIcon:SetScript("OnLeave", function (self, button, down)
        Tooltip:Hide()
    end)
end

function Spell_Action_Bar.GenerateCoolDown(parent)
    Spell_Action_Bar.Cooldown = CreateFrame("Cooldown", Spell_Action_Bar.Cooldown, parent, "CooldownFrameTemplate")
    Spell_Action_Bar.Cooldown:SetAllPoints()

    Spell_Action_Bar.Cooldown:SetCooldown(0, 0)
    Spell_Action_Bar.Cooldown:Show()

    Spell_Action_Bar.Cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    Spell_Action_Bar.Cooldown:SetScript("OnEvent", function(_, event, ...)
        if (event == "SPELL_UPDATE_COOLDOWN") then
            Spell_Action_Bar.SetCooldown(parent)
        end

    end)
end

function Spell_Action_Bar.SetCooldown(parent)
    if (not Spell_Action_Bar.Cooldown) then
        Spell_Action_Bar.GenerateCoolDown(parent)
    end

    local start, duration, _ = GetSpellCooldown(parent:GetAttribute("spellId"));
    if (duration and duration > 0) then
        Spell_Action_Bar.Cooldown:SetCooldown(start, duration)
    else
        Spell_Action_Bar.Cooldown:SetCooldown(0, 0)
    end
    Spell_Action_Bar.Cooldown:Show()
end

function Spell_Action_Bar.SetTexture(texture)
    Spell_Action_Bar.Texture = Spell_Action_Bar.Frame:CreateTexture()
    Spell_Action_Bar.Texture:SetSize(250, 120)
    Spell_Action_Bar.Texture:SetPoint("CENTER")
    Spell_Action_Bar.Texture:SetTexture("Interface/actionbttns/" .. texture)
end

function Server.StartCooldown()
    Spell_Action_Bar.ExtraIcon:SetCooldown(Spell_Action_Bar.ExtraIcon)
end

function Server.ShowFrame(_, texture, spell_id)
    if (Spell_Action_Bar.Frame) then
        Spell_Action_Bar.Frame:Hide()

        Spell_Action_Bar.Frame = nil
        Spell_Action_Bar.ExtraIcon = nil
        Spell_Action_Bar.ExtraButtonIcon = nil
        Spell_Action_Bar.Cooldown = nil
        Spell_Action_Bar.Texture = nil
    end

    Spell_Action_Bar.Generate(texture, spell_id)

    if (not Spell_Action_Bar.Frame:IsShown()) then
        Spell_Action_Bar.Frame:Show()
    end
end

function Server.HideFrame(_)
    if (not Spell_Action_Bar.Frame) then
        return
    end

    Spell_Action_Bar.Frame:Hide()
end
