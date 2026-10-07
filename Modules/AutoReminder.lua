local _, Q = ...
local AutoReminder = Q.Addon:NewModule("AutoReminder", "AceEvent-3.0")
Q.AutoReminder = AutoReminder
AutoReminder.lastNotifiedAt = {}

function AutoReminder:ZoneChangedEventHandler()
    local now = GetTime()
    local questsToNotify = {}

    for _, quest in ipairs(Q.API:GetRelevantQuestsForZone()) do
        local lastNotifiedAt = self.lastNotifiedAt[quest.id]
        if not lastNotifiedAt or now - lastNotifiedAt >= Q:GetSetting("ReminderCooldown") then
            table.insert(questsToNotify, quest)
            self.lastNotifiedAt[quest.id] = now
        end
    end

    if #questsToNotify == 0 then
        return
    end

    Q.Notification:AddToQueue(questsToNotify)
end

function AutoReminder:OnDisable()
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEventHandler")
end

function AutoReminder:OnEnable()
    if not Q:GetSetting("ShowNotificationOnLevelUp") or not Q:GetSetting("RemindOnZoneChange") then
        return
    end
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEventHandler")
end
