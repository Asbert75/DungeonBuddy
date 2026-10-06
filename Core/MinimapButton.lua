local _, Q = ...

local LDB = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

function Q:CreateMinimapButton()
    local primaryFontColor = Q.Theme.Text.Primary;

    self.dataObject = LDB:NewDataObject("DungeonBuddy", {
        type = "launcher",
        text = "DungeonBuddy",
        icon = "Interface\\Addons\\DungeonBuddy\\Media\\Icons\\Minimap.png",

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
            tooltip:AddLine("Left-click: Toggle Quest Log", primaryFontColor[1], primaryFontColor[2], primaryFontColor[3])
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

function Q:ToggleMinimapButton()
    if Q:GetSetting("MinimapButton.Hide") then
        Q:SetSetting("MinimapButton.Hide", false)
        LibDBIcon:Show("DungeonBuddy")
        Q:PrettyPrint("Minimap button enabled.")
    else
        Q:SetSetting("MinimapButton.Hide", true)
        LibDBIcon:Hide("DungeonBuddy")
        Q:PrettyPrint("Minimap button disabled.")
    end
end