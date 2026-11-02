local _, Q = ...
local LDB = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")
Q.MinimapButton = LibDBIcon

function Q:CreateMinimapButton()
    local primaryFontColor = Q.Theme.Text.Primary;

    self.dataObject = LDB:NewDataObject("DungeonBuddy", {
        type = "launcher",
        text = "DungeonBuddy",
        icon = "Interface\\Icons\\inv_misc_steelweaponchain",

        OnClick = function(_, button)
            if button == "LeftButton" then
                Q.QuestLog:Toggle()
            end

            if button == "RightButton" then
                Q.Settings:Toggle()
            end
        end,

        OnTooltipShow = function(tooltip)
            tooltip:AddLine("Dungeon Buddy")
            tooltip:AddLine("Left-click: Toggle Quest Log", primaryFontColor[1], primaryFontColor[2], primaryFontColor
            [3])
            tooltip:AddLine("Right-click: Open Settings", primaryFontColor[1], primaryFontColor[2], primaryFontColor[3])
        end,
    })

    LibDBIcon:Register(
        "DungeonBuddy",
        self.dataObject,
        self.DB.profile.MinimapButton
    )

    if Q:GetSetting("MinimapButton.Hide") then
        LibDBIcon:Hide("DungeonBuddy")
    end
end

function Q.MinimapButton:SetHidden(hidden)
    Q:SetSetting("MinimapButton.Hide", hidden)
    if hidden then
        LibDBIcon:Hide("DungeonBuddy")
    else
        LibDBIcon:Show("DungeonBuddy")
    end

    Q:PrettyPrint(hidden and "Minimap button disabled." or "Minimap button enabled.")
end

function Q.MinimapButton:Toggle()
    self:SetHidden(not Q:GetSetting("MinimapButton.Hide"))
end
