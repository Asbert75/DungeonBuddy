local _, Q = ...
local QuestInfo = Q.Addon:NewModule('QuestInfo')
Q.QuestInfo = QuestInfo

function QuestInfo:Show(row)
    if not self.frame then
        local frame = Q:CreateBackdropFrame("DungeonBuddy_QuestInfoFrame", UIParent, 620, 360, "DIALOG", "Primary", "Default", 0.9, 0.5)
        self.frame = frame
        Q:SetPixelPerfectPoint(frame, "CENTER", UIParent, "CENTER", 0, 200)

        Q:CreateCloseButton(frame, "DungeonBuddy_QuestInfoCloseButton")
    end
end

