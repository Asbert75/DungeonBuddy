local ADDON_NAME, Q = ...
local Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")

Q.Addon = {}
Q.API = {}
Q.DB = {}

Q.MinimapButton = {}
Q.Notification = {}
Q.QuestLog = {}
Q.Settings = {}

Q.Dungeons = {}
Q.Quests = {}
Q.DungeonById = {}
Q.QuestById = {}
Q.QuestsByDungeonId = {}
Q.DungeonByQuestId =  {}

Q.Theme = {}
Q.Debug = {
    Enabled = false,
    Level = nil,
    Faction = nil,
    Class = nil
}

function Addon:OnInitialize()
    Q.DB = LibStub("AceDB-3.0"):New("DungeonBuddyDB", Q.GetDefaultDB(), true)

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
        Q.Debug.Faction = (arg2 and arg2:lower() == "horde") and "Horde" or "Alliance"
        Q:PrettyPrint("Debug faction set to " .. tostring(Q.Debug.Faction))
    elseif arg1 == "class" then
        Q.Debug.Class = arg2 or Q.Debug.Class
        Q:PrettyPrint("Debug class set to " .. tostring(Q.Debug.Class))
    else
        Q.Debug.Enabled = not Q.Debug.Enabled
        Q:PrettyPrint("Debug mode " .. (Q.Debug.Enabled and "enabled" or "disabled"))
    end
    if arg1 ~= "status" and arg1 ~= "quest" then
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
        Q:OpenSettings()
    elseif command == "notification" then
        if args == "on" then
            Q:SetSetting("ShowNotificationOnLevelUp", true)
            Q.Notification:Enable()
            Q:PrettyPrint("Level-up notifications enabled.")
        end
        if args == "off" then
            Q:SetSetting("ShowNotificationOnLevelUp", false)
            Q.Notification:Disable()
            Q:PrettyPrint("Level-up notifications disabled.")
        end
    elseif command == "tracker" then
        Q.QuestLog:Toggle()
    else
        PrintHelpCommands()
    end
end

Q.Addon = Addon
