local _, Q = ...

-- Sanity checks for the static quest data. Only runs via /dbdebug validate [all].

local SOURCE_TYPES = { npc = true, object = true, item = true }
local LOCATION_TYPES = { npc = true, object = true }
local FACTIONS = { "Alliance", "Horde" }
local NO_CLASS = "NONE" -- stands in for a class that no quest is restricted to

local QUEST_FIELDS = {
    id = true, faction = true, class = true, classes = true, name = true, suggestedLevel = true,
    requiredLevel = true, prerequisites = true, source = true, sources = true, instances = true,
    profession = true, text = true,
}
local SOURCE_FIELDS = {
    id = true, type = true, name = true, faction = true, zone = true, location = true, text = true,
    itemId = true, instance = true,
}
local INSTANCE_FIELDS = {
    id = true, name = true, continent = true, zone = true, location = true, minLevel = true,
    suggestedLevel = true, maxLevel = true,
}
local PREREQUISITE_FIELDS = { id = true, type = true }
local LOCATION_FIELDS = { mapId = true, x = true, y = true }

local NEAR_DUPLICATE_DISTANCE = 0.03

local function IsNumber(value)
    return type(value) == "number"
end

local function CheckUnknownFields(tbl, allowed, label, errors)
    for key in pairs(tbl) do
        if not allowed[key] then
            errors[#errors + 1] = label .. ": unknown field '" .. tostring(key) .. "'"
        end
    end
end

local function ValidateLocation(loc, label, errors)
    if type(loc) ~= "table" or not IsNumber(loc.mapId) or not IsNumber(loc.x) or not IsNumber(loc.y) then
        errors[#errors + 1] = label .. ": invalid location"
        return false
    end
    if loc.x < 0 or loc.x > 1 or loc.y < 0 or loc.y > 1 then
        errors[#errors + 1] = label .. ": coordinates outside 0-1"
    end
    CheckUnknownFields(loc, LOCATION_FIELDS, label .. " location", errors)
    return true
end

local function ValidateSource(source, label, errors, instanceSet)
    if type(source) ~= "table" then
        errors[#errors + 1] = label .. ": source is not a table"
        return
    end

    local name = tostring(source.name)
    CheckUnknownFields(source, SOURCE_FIELDS, label, errors)

    if not SOURCE_TYPES[source.type] then
        errors[#errors + 1] = label .. ": invalid source type '" .. tostring(source.type) .. "'"
    end
    if type(source.name) ~= "string" or source.name == "" then
        errors[#errors + 1] = label .. ": source has no name"
    end
    if source.faction ~= nil and source.faction ~= "Alliance" and source.faction ~= "Horde" then
        errors[#errors + 1] = label .. ": source '" .. name .. "' has invalid faction '" ..
            tostring(source.faction) .. "'"
    end
    if source.type == "item" and not IsNumber(source.itemId) then
        errors[#errors + 1] = label .. ": item source '" .. name .. "' has no itemId"
    end
    if source.instance and not instanceSet[source.instance] then
        errors[#errors + 1] = label .. ": source '" .. name .. "' references an instance that is not in Q.Instances"
    end

    -- Sources inside an instance don't need a world location.
    if LOCATION_TYPES[source.type] and not source.instance then
        if type(source.zone) ~= "string" then
            errors[#errors + 1] = label .. ": source '" .. name .. "' has no zone"
        end
        ValidateLocation(source.location, label .. " source '" .. name .. "'", errors)
    end
end

local function ValidateInstances(errors)
    local seenIds = {}
    local set = {}

    for key, instance in pairs(Q.Instances) do
        local label = "Instance '" .. tostring(key) .. "'"
        set[instance] = true

        CheckUnknownFields(instance, INSTANCE_FIELDS, label, errors)

        if not IsNumber(instance.id) then
            errors[#errors + 1] = label .. ": missing numeric id"
        elseif seenIds[instance.id] then
            errors[#errors + 1] = label .. ": duplicate id " .. instance.id .. " (also '" ..
                seenIds[instance.id] .. "')"
        else
            seenIds[instance.id] = tostring(key)
        end

        if instance.name ~= key then
            errors[#errors + 1] = label .. ": name '" .. tostring(instance.name) .. "' does not match its key"
        end
        if type(instance.zone) ~= "string" or type(instance.continent) ~= "string" then
            errors[#errors + 1] = label .. ": missing zone or continent"
        end
        ValidateLocation(instance.location, label, errors)

        if not (IsNumber(instance.minLevel) and IsNumber(instance.suggestedLevel) and IsNumber(instance.maxLevel)) then
            errors[#errors + 1] = label .. ": missing minLevel, suggestedLevel or maxLevel"
        elseif instance.minLevel > instance.maxLevel then
            errors[#errors + 1] = label .. ": minLevel is higher than maxLevel"
        end
    end

    return set
end

-- The same mapId should always carry the same zone name.
local function ValidateMapZones(errors)
    local zonesByMap = {}

    local function Add(mapId, zone, label)
        if not (IsNumber(mapId) and type(zone) == "string") then
            return
        end
        zonesByMap[mapId] = zonesByMap[mapId] or {}
        zonesByMap[mapId][zone] = zonesByMap[mapId][zone] or label
    end

    for key, source in pairs(Q.Sources) do
        if source.location then
            Add(source.location.mapId, source.zone, "source " .. tostring(key))
        end
    end
    for key, instance in pairs(Q.Instances) do
        if instance.location then
            Add(instance.location.mapId, instance.zone, "instance '" .. tostring(key) .. "'")
        end
    end

    for mapId, zones in pairs(zonesByMap) do
        local names = {}
        for zone, label in pairs(zones) do
            names[#names + 1] = "'" .. zone .. "' (" .. label .. ")"
        end
        if #names > 1 then
            table.sort(names)
            errors[#errors + 1] = "mapId " .. mapId .. " is used with different zone names: " ..
                table.concat(names, ", ")
        end
    end
end

local function ValidateNearDuplicateSources(errors)
    local groups = {}
    local ids = {}

    for id in pairs(Q.Sources) do
        ids[#ids + 1] = id
    end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local source = Q.Sources[id]
        local key = tostring(source.type) .. "|" .. tostring(source.name)
        groups[key] = groups[key] or {}
        table.insert(groups[key], source)
    end

    for _, group in pairs(groups) do
        for i = 1, #group - 1 do
            for j = i + 1, #group do
                local a, b = group[i], group[j]
                -- Different item ids or notes mean the entries are intentionally distinct.
                if a.itemId == b.itemId and a.text == b.text and a.faction == b.faction then
                    local duplicate = false
                    if a.instance or b.instance then
                        duplicate = a.instance == b.instance
                    elseif a.location and b.location and a.location.mapId == b.location.mapId then
                        duplicate = math.abs(a.location.x - b.location.x) < NEAR_DUPLICATE_DISTANCE and
                            math.abs(a.location.y - b.location.y) < NEAR_DUPLICATE_DISTANCE
                    end
                    if duplicate then
                        errors[#errors + 1] = string.format("Sources %s and %s look like duplicates ('%s')",
                            tostring(a.id), tostring(b.id), tostring(a.name))
                    end
                end
            end
        end
    end
end

local function FindPrerequisiteCycles(questsById, errors)
    local state = {} -- nil = unvisited, 1 = in progress, 2 = done
    local path = {}

    local function Visit(id)
        if state[id] == 2 then
            return
        end
        if state[id] == 1 then
            local cycle = {}
            for i = #path, 1, -1 do
                table.insert(cycle, 1, tostring(path[i]))
                if path[i] == id then
                    break
                end
            end
            table.insert(cycle, tostring(id))
            errors[#errors + 1] = "Prerequisite cycle: " .. table.concat(cycle, " -> ")
            return
        end

        state[id] = 1
        path[#path + 1] = id
        for _, quest in ipairs(questsById[id] or {}) do
            for _, prereq in ipairs(quest.prerequisites or {}) do
                if IsNumber(prereq.id) and prereq.id ~= id then
                    Visit(prereq.id)
                end
            end
        end
        path[#path] = nil
        state[id] = 2
    end

    local ids = {}
    for id in pairs(questsById) do
        ids[#ids + 1] = id
    end
    table.sort(ids)
    for _, id in ipairs(ids) do
        Visit(id)
    end
end

local function CollectClasses(quests)
    local set = { [NO_CLASS] = true }
    for _, quest in ipairs(quests) do
        if quest.class then
            set[quest.class] = true
        end
        for _, class in ipairs(quest.classes or {}) do
            set[class] = true
        end
    end

    -- Unrestricted first so a problem affecting everyone is reported as such.
    local list = {}
    for class in pairs(set) do
        if class ~= NO_CLASS then
            list[#list + 1] = class
        end
    end
    table.sort(list)
    table.insert(list, 1, NO_CLASS)
    return list
end

local function QuestFactions(quest)
    return quest.faction and { quest.faction } or FACTIONS
end

local function QuestSourceList(quest)
    return quest.source and { quest.source } or quest.sources or {}
end

-- Returns a list of problems and a list of informational notes.
function Q:ValidateData()
    local errors = {}
    local notes = {}
    -- Q.Quests is filtered to the current character once lookups are built, so use the full list.
    local quests = Q.API.QuestsBackup or Q.Quests
    local questsById = {}
    local firstIndexById = {}
    local referenced = {}
    local usedSources = {}
    local prereqTypes = {}

    for _, value in pairs(Q.PrerequisiteType) do
        prereqTypes[value] = true
    end
    for index, quest in ipairs(quests) do
        if IsNumber(quest.id) then
            questsById[quest.id] = questsById[quest.id] or {}
            table.insert(questsById[quest.id], quest)
            firstIndexById[quest.id] = firstIndexById[quest.id] or index
        end
        for _, prereq in ipairs(quest.prerequisites or {}) do
            if IsNumber(prereq.id) then
                referenced[prereq.id] = true
            end
        end
    end
    local classes = CollectClasses(quests)

    for _, key in ipairs(Q.MissingSourceKeys or {}) do
        errors[#errors + 1] = "Unknown Q.Sources id: " .. key
    end
    for _, key in ipairs(Q.MissingInstanceKeys or {}) do
        errors[#errors + 1] = "Unknown Q.Instances key: '" .. key .. "'"
    end

    local instanceSet = ValidateInstances(errors)

    for key, source in pairs(Q.Sources) do
        if source.id ~= key then
            errors[#errors + 1] = string.format("Source '%s': id %s does not match its key %s",
                tostring(source.name), tostring(source.id), tostring(key))
        end
        ValidateSource(source, "Source " .. tostring(key), errors, instanceSet)
    end
    ValidateMapZones(errors)
    ValidateNearDuplicateSources(errors)
    FindPrerequisiteCycles(questsById, errors)

    local liveNamesUnavailable = 0
    local canCheckNames = C_QuestLog and C_QuestLog.GetTitleForQuestID

    for index, quest in ipairs(quests) do
        local label = string.format("Quest #%d (%s, id %s)", index, tostring(quest.name), tostring(quest.id))

        CheckUnknownFields(quest, QUEST_FIELDS, label, errors)

        if not IsNumber(quest.id) then
            errors[#errors + 1] = label .. ": missing numeric id"
        elseif firstIndexById[quest.id] ~= index then
            errors[#errors + 1] = label .. ": duplicate id (first used by quest #" .. firstIndexById[quest.id] .. ")"
        end

        if type(quest.name) ~= "string" or quest.name == "" then
            errors[#errors + 1] = label .. ": missing name"
        end
        if quest.faction ~= nil and quest.faction ~= "Alliance" and quest.faction ~= "Horde" then
            errors[#errors + 1] = label .. ": invalid faction '" .. tostring(quest.faction) .. "'"
        end

        if quest.class and quest.classes then
            errors[#errors + 1] = label .. ": has both 'class' and 'classes'"
        end
        if quest.classes and #quest.classes < 2 then
            errors[#errors + 1] = label .. ": 'classes' should list at least two classes (use 'class' for one)"
        end
        for _, class in ipairs(quest.classes or { quest.class }) do
            if not RAID_CLASS_COLORS[class] then
                errors[#errors + 1] = label .. ": unknown class '" .. tostring(class) .. "'"
            end
        end

        if quest.profession and not Q.ProfessionIcons[quest.profession] then
            errors[#errors + 1] = label .. ": unknown profession '" .. tostring(quest.profession) .. "'"
        end

        if not (IsNumber(quest.requiredLevel) and IsNumber(quest.suggestedLevel)) then
            errors[#errors + 1] = label .. ": missing requiredLevel or suggestedLevel"
        elseif quest.requiredLevel > quest.suggestedLevel then
            errors[#errors + 1] = label .. ": requiredLevel is higher than suggestedLevel"
        end

        -- Sources
        if quest.source and quest.sources then
            errors[#errors + 1] = label .. ": has both 'source' and 'sources'"
        elseif not (quest.source or quest.sources) then
            errors[#errors + 1] = label .. ": has no source (check for a wrong Q.Sources id)"
        else
            local list = QuestSourceList(quest)
            if quest.sources and #list == 0 then
                errors[#errors + 1] = label .. ": 'sources' is empty (wrong Q.Sources id?)"
            end
            for _, source in ipairs(list) do
                if type(source) == "table" and source.id and Q.Sources[source.id] == source then
                    usedSources[source.id] = true
                else
                    -- Inline source, not shared through Q.Sources.
                    ValidateSource(source, label, errors, instanceSet)
                end
                if type(source) == "table" and quest.faction and source.faction and source.faction ~= quest.faction then
                    errors[#errors + 1] = label .. ": " .. quest.faction .. " quest uses " .. source.faction ..
                        " source '" .. tostring(source.name) .. "'"
                end
            end
            for _, faction in ipairs(QuestFactions(quest)) do
                local count = 0
                for _, source in ipairs(list) do
                    if type(source) == "table" and (not source.faction or source.faction == faction) then
                        count = count + 1
                    end
                end
                if count == 0 then
                    errors[#errors + 1] = label .. ": has no source available to " .. faction
                end
            end
        end

        -- Instances
        if quest.instances then
            if #quest.instances == 0 then
                errors[#errors + 1] = label .. ": 'instances' is empty (mistyped Q.Instances key?)"
            end
            for _, instance in ipairs(quest.instances) do
                if not instanceSet[instance] then
                    errors[#errors + 1] = label .. ": references an instance that is not in Q.Instances"
                end
            end
        elseif not (quest.id and referenced[quest.id]) then
            errors[#errors + 1] = label .. ": has no instances and is not a prerequisite of any quest, so it is never shown"
        end

        -- Prerequisites
        local seenPrereqs = {}
        for _, prereq in ipairs(quest.prerequisites or {}) do
            if not IsNumber(prereq.id) then
                errors[#errors + 1] = label .. ": prerequisite without a numeric id"
            else
                CheckUnknownFields(prereq, PREREQUISITE_FIELDS, label .. " prerequisite " .. prereq.id, errors)

                local required = prereq.type == Q.PrerequisiteType.CHAIN or prereq.type == Q.PrerequisiteType.REQUIRED
                local variants = questsById[prereq.id]

                if prereq.id == quest.id then
                    errors[#errors + 1] = label .. ": is its own prerequisite"
                end
                if not prereqTypes[prereq.type] then
                    errors[#errors + 1] = label .. ": prerequisite " .. prereq.id .. " has invalid type '" ..
                        tostring(prereq.type) .. "'"
                end
                if seenPrereqs[prereq.id] then
                    errors[#errors + 1] = label .. ": prerequisite " .. prereq.id .. " is listed more than once"
                end
                seenPrereqs[prereq.id] = true

                if not variants then
                    errors[#errors + 1] = label .. ": prerequisite " .. prereq.id .. " does not exist"
                elseif required then
                    local prereqQuest = variants[1]
                    if IsNumber(quest.requiredLevel) and IsNumber(prereqQuest.requiredLevel) and
                        quest.requiredLevel < prereqQuest.requiredLevel then
                        errors[#errors + 1] = string.format(
                            "%s: requiredLevel %d is lower than prerequisite %d's requiredLevel %d",
                            label, quest.requiredLevel, prereq.id, prereqQuest.requiredLevel)
                    end

                    -- Prerequisites that don't exist for a faction or class are skipped at runtime (see
                    -- IsPrerequisiteSatisfied), so only report one that NO player who can get this quest can access.
                    local reachable = false
                    local anyEligible = false
                    for _, faction in ipairs(QuestFactions(quest)) do
                        for _, class in ipairs(classes) do
                            if Q.API:IsQuestAvailableToClass(quest, class) then
                                anyEligible = true
                                for _, variant in ipairs(variants) do
                                    if (not variant.faction or variant.faction == faction) and
                                        Q.API:IsQuestAvailableToClass(variant, class) then
                                        reachable = true
                                    end
                                end
                            end
                        end
                    end
                    if anyEligible and not reachable then
                        errors[#errors + 1] = string.format(
                            "%s: required prerequisite %d is not available to any player who can get this quest",
                            label, prereq.id)
                    end
                end
            end
        end

        -- Compare with the in-game title, ignoring "(1/2)" style chain suffixes.
        if canCheckNames and IsNumber(quest.id) and firstIndexById[quest.id] == index then
            local title = C_QuestLog.GetTitleForQuestID(quest.id)
            if title and title ~= "" then
                local expected = tostring(quest.name):gsub("%s*%(%d+/%d+%)%s*$", "")
                if title:lower() ~= expected:lower() then
                    errors[#errors + 1] = string.format("%s: in-game title is '%s'", label, title)
                end
            else
                liveNamesUnavailable = liveNamesUnavailable + 1
                if C_QuestLog.RequestLoadQuestByID then
                    C_QuestLog.RequestLoadQuestByID(quest.id)
                end
            end
        end
    end

    for id, source in pairs(Q.Sources) do
        if not usedSources[id] then
            errors[#errors + 1] = string.format("Source %s ('%s') is not used by any quest", tostring(id),
                tostring(source.name))
        end
    end

    if liveNamesUnavailable > 0 then
        notes[#notes + 1] = string.format(
            "%d quest title(s) were not cached by the game yet and were not compared; run the command again in a moment.",
            liveNamesUnavailable)
    end

    return errors, notes
end

function Q:RunValidation(showAll)
    local errors, notes = Q:ValidateData()
    local limit = showAll and #errors or 20

    if #errors == 0 then
        Q:PrettyPrint("Data validation passed, no problems found")
    else
        Q:PrettyPrint(string.format("%d data validation problem(s) found:", #errors))
        for i = 1, math.min(#errors, limit) do
            Q:PrettyPrint("  " .. errors[i])
        end
        if #errors > limit then
            Q:PrettyPrint(string.format("  ...and %d more (use /dbdebug validate all to show everything)", #errors - limit))
        end
    end

    for _, note in ipairs(notes) do
        Q:PrettyPrint(note)
    end
end
