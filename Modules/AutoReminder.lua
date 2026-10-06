local _, Q = ...
local AutoReminder = Q.Addon:NewModule("AutoReminder", "AceEvent-3.0")
Q.AutoReminder = AutoReminder

function AutoReminder:ZoneChangedEventHandler()
    local quests = Q.API:GetRelevantQuestsForZone()
    if #quests == 0 then
        return
    end

    Q.Notification:AddToQueue(quests)
end

function AutoReminder:OnDisable()
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEventHandler")
end

function AutoReminder:OnEnable()
    if not Q:GetSetting("ShowRemindersOnLevelUp") or not Q:GetSetting("RemindOnZoneChange") then
        return
    end
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEventHandler")
end
