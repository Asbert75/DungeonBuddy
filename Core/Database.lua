local _, Q = ...

local function CopyTable(source)
    if type(source) ~= "table" then
        return source
    end

    local out = {}
    for key, value in pairs(source) do
        out[key] = CopyTable(value)
    end
    return out
end

local SharedDefaults = {
    MinimapButton = {
        Hide = false,
        MinimapPos = 225,
    },
    NotificationFrame = {
        X = 0,
        Y = 0,
    },
    QuestLogFrame = {
        X = -250,
        Y = 0,
    },
    ShowRemindersOnLevelUp = true,
    RemindOnZoneChange = true,
    HideCompletedQuests = false,
    AutoWaypoint = false,
    CollapsedDungeons = {},
    CollapsedQuests = {},

    QuestColorUnavailable = { r = 163/255, g = 59/255, b = 57/255 },
    QuestColorAvailable = { r = 35/255, g = 213/255, b = 0/255 },
    QuestColorInProgress = { r = 255/255, g = 239/255, b = 0/255 },
    QuestColorCompleted = { r = 146/255, g = 146/255, b = 146/255 },
}

local Defaults = {
    profile = CopyTable(SharedDefaults),
    global = {
        version = 1,
        ProfileBindings = {
            EnableSpecProfiles = false,
            SpecProfiles = {},
        },
    },
}

function Q:GetDefaultDB()
    return Defaults
end

-- Splits a dot-separated path ("Theme.Text.Primary") into its individual keys.
local function SplitPath(path)
    local keys = {}
    for key in path:gmatch("[^.]+") do
        table.insert(keys, key)
    end
    return keys
end

-- Reads a value from the active profile using a dot-separated path.
function Q:GetSetting(path)
    local keys = SplitPath(path)
    local node = self.DB.profile
    for _, key in ipairs(keys) do
        if type(node) ~= "table" then
            return nil
        end
        node = node[key]
    end
    return node
end

-- Writes a value to the active profile using a dot-separated path.
function Q:SetSetting(path, value)
    local keys = SplitPath(path)
    local lastKey = table.remove(keys)
    local node = self.DB.profile
    for _, key in ipairs(keys) do
        node = node[key]
    end
    node[lastKey] = value
end
