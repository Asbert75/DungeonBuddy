local _, Q = ...
local AutoReminder = Q.Addon:NewModule("AutoReminder", "AceEvent-3.0")
Q.AutoReminder = AutoReminder
AutoReminder.lastNotifiedAt = {}

local REMINDER_COOLDOWN_SECONDS = 60

function AutoReminder:ZoneChangedEventHandler()
    local now = GetTime()
    local questsToNotify = {}

    for _, quest in ipairs(Q.API:GetRelevantQuestsForZone()) do
        local lastNotifiedAt = self.lastNotifiedAt[quest.id]
        if not lastNotifiedAt or now - lastNotifiedAt >= REMINDER_COOLDOWN_SECONDS then
            table.insert(questsToNotify, quest)
            self.lastNotifiedAt[quest.id] = now
        end
    end

    if #questsToNotify == 0 then
        return
    end

    Q.Notification:AddToQueue(questsToNotify)
end

function AutoReminder:UpdateRegistration()
    if Q:GetSetting("RemindOnZoneChange") then
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEventHandler")
    else
        self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    end
end

function AutoReminder:OnDisable()
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
end

function AutoReminder:OnEnable()
    self:UpdateRegistration()
end
