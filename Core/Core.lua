local ADDON_NAME, Q = ...
local Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")

Q.Instances = {}
Q.Quests = {}
Q.InstanceById = {}
Q.QuestById = {}
Q.QuestsByInstanceId = {}
Q.InstanceByQuestId = {}

Q.Debug = {
    Enabled = false,
    Level = nil,
    Faction = nil,
    Class = nil
}


function Addon:OnInitialize()
    Q.DB = LibStub("AceDB-3.0"):New("DungeonBuddyCharDB", Q.GetDefaultDB())
    Q:LoadTheme()

    Addon:RegisterChatCommand("db", "HandleCommand")
    Addon:RegisterChatCommand("dungeonbuddy", "HandleCommand")
    Addon:RegisterChatCommand("dbdebug", "HandleDebugCommand")

    Q:CreateMinimapButton()

    Q.API:BuildLookupTables()
    Q:PrettyPrint("Addon loaded, use /db help for commands")
end

--#region Debug Functions
local function TestNotificationQuest()
    local quest = Q.API:GetRandomQuest()
    local quest2 = Q.API:GetRandomQuest()
    local quests = { quest, quest2 }

    Q.Notification:AddToQueue(quests)
end

function Addon:HandleDebugCommand(input)
    local arg1, arg2 = input:match("^(%S*)%s*(.-)$")

    if arg1 == "quest" then
        TestNotificationQuest()
    elseif arg1 == "levelup" then
        Q.Notification:LevelUpEventHandler()
    elseif arg1 == "status" then
        if Q.Debug.Enabled then
            Q:PrettyPrint("Debug mode is currently enabled")
            Q:PrettyPrint("Level: " .. tostring(Q.Debug.Level))
            Q:PrettyPrint("Faction: " .. tostring(Q.Debug.Faction))
            Q:PrettyPrint("Class: " .. tostring(Q.Debug.Class))
        else
            Q:PrettyPrint("Debug mode is currently disabled")
        end
    elseif arg1 == "level" then
        Q.Debug.Level = tonumber(arg2) or Q.Debug.Level
        Q:PrettyPrint("Debug level set to " .. tostring(Q.Debug.Level))
    elseif arg1 == "faction" then
        local faction = arg2:lower()
        if faction == "horde" then
            Q.Debug.Faction = "Horde"
        elseif faction == "alliance" then
            Q.Debug.Faction = "Alliance"
        else
            Q:PrettyPrint("Usage: /dbdebug faction horde|alliance")
        end
        Q:PrettyPrint("Debug faction set to " .. tostring(Q.Debug.Faction))
    elseif arg1 == "class" then
        if arg2 ~= "" then
            Q.Debug.Class = arg2:upper()
        end
        Q:PrettyPrint("Debug class set to " .. tostring(Q.Debug.Class))
    else
        Q.Debug.Enabled = not Q.Debug.Enabled
        Q:PrettyPrint("Debug mode " .. (Q.Debug.Enabled and "enabled" or "disabled"))
    end
    if arg1 ~= "status" and arg1 ~= "quest" then
        Q.API:BuildLookupTables()
        Q.QuestLog:Reload()
    end
end

function Q:DumpTable(table)
    for key, value in pairs(table) do
        if type(value) == "table" then
            Q:PrettyPrint(key .. " = {")
            Q:DumpTable(value)
            Q:PrettyPrint("}")
        else
            Q:PrettyPrint(key .. " = " .. tostring(value))
        end
    end
end

--#endregion

local function PrintHelpCommands()
    Q:PrettyPrint("Available commands:")
    Q:PrettyPrint("/db minimap - Toggle the minimap button")
    Q:PrettyPrint("/db settings - Open the settings window")
    Q:PrettyPrint("/db notification on|off - Enable or disable level-up notifications")
    Q:PrettyPrint("/db tracker - Toggle the quest tracker")
end

function Addon:HandleCommand(input)
    local command, args = input:match("^(%S*)%s*(.-)$")

    if command == "help" then
        PrintHelpCommands()
    elseif command == "minimap" then
        Q.MinimapButton:Toggle()
    elseif command == "settings" then
        Q.Settings:Toggle()
    elseif command == "notification" then
        if args == "on" or args == "off" then
            local enabled = args == "on"
            Q:SetSetting("ShowNotificationOnLevelUp", enabled)
            Q.Notification:UpdateLevelUpRegistration()
            Q.Settings:RefreshCheckbox("ShowNotificationOnLevelUp")
            Q:PrettyPrint("Level-up notifications " .. (enabled and "enabled." or "disabled."))
        else
            PrintHelpCommands()
        end
    elseif command == "tracker" then
        Q.QuestLog:Toggle()
    else
        PrintHelpCommands()
    end
end

Q.Addon = Addon
