local _, Q = ...
local InfoFrame = Q.Addon:NewModule('InfoFrame')
Q.InfoFrame = InfoFrame

function InfoFrame:Show(row)
    if not self.frame then
        local frame = Q:CreateBackdropFrame("DungeonBuddy_InfoFrameFrame", UIParent, 620, 360, "DIALOG", "Primary", "Default", 0.9, 0.5)
        self.frame = frame
        Q:SetPixelPerfectPoint(frame, "CENTER", UIParent, "CENTER", 0, 200)

        Q:CreateCloseButton(frame, "DungeonBuddy_InfoFrameCloseButton")
    end
end

