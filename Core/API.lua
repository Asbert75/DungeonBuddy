local ADDON_NAME, Q = ...

Q.API = {}

local ProfessionIcons = {
    Alchemy = "Trade_Alchemy",
    Blacksmithing = "Trade_Blacksmithing",
    Enchanting = "Trade_Engraving",
    Engineering = "Trade_Engineering",
    Herbalism = "Trade_Herbalism",
    Leatherworking = "Inv_misc_armorkit_17",
    Mining = "Trade_Mining",
    Skinning = "INV_Misc_Pelt_Wolf_01",
    Tailoring = "Trade_Tailoring",
    Cooking = "INV_Misc_Food_15",
    ["First Aid"] = "Spell_Holy_SealOfSacrifice",
    Fishing = "Trade_Fishing",
}

local function FilterArray(table, predicate)
    local writeIndex = 1

    for readIndex = 1, #table do
        local value = table[readIndex]

        if predicate(value) then
            table[writeIndex] = value
            writeIndex = writeIndex + 1
        end
    end

    for i = #table, writeIndex, -1 do
        table[i] = nil
    end
end

local function CopyArray(source)
    local copy = {}
    for index = 1, #source do
        copy[index] = source[index]
    end
    return copy
end

function Q.API:BuildLookupTables()
    if not Q.API.QuestsBackup then
        Q.API.QuestsBackup = CopyArray(Q.Quests)
    else
        Q.Quests = CopyArray(Q.API.QuestsBackup)
    end

    wipe(Q.QuestById)
    wipe(Q.QuestsByInstanceId)
    wipe(Q.InstanceById)
    wipe(Q.InstanceByQuestId)

    -- Filter out quests that do not match the player's faction and class, we do this when building lookups so that we can completely ignore faction/class in all other functions
    FilterArray(Q.Quests, function(quest)
        return quest and (quest.faction == self:GetPlayerFaction() or not quest.faction) and
        (quest.class == self:GetPlayerClass() or not quest.class)
    end)

    for _, quest in ipairs(Q.Quests) do
        Q.QuestById[quest.id] = quest
        for _, instance in ipairs(quest.instances or {}) do
            local quests = Q.QuestsByInstanceId[instance.id]
            if not quests then
                quests = {}
                Q.QuestsByInstanceId[instance.id] = quests
            end
            table.insert(quests, quest)
        end
    end

    for _, instance in pairs(Q.Instances) do
        Q.InstanceById[instance.id] = instance
    end

    local function addQuestInstance(questId, instance)
        local instances = Q.InstanceByQuestId[questId]
        if not instances then
            instances = {}
            Q.InstanceByQuestId[questId] = instances
        end

        for _, existingInstance in ipairs(instances) do
            if existingInstance.id == instance.id then
                return
            end
        end
        table.insert(instances, instance)
    end

    -- Instance relevance follows every unlock path back to its starting quests.
    local function AddInstanceToLineage(quest, instance, visited)
        if not quest or visited[quest.id] then
            return
        end
        visited[quest.id] = true
        addQuestInstance(quest.id, instance)

        for _, prerequisite in ipairs(quest.prerequisites or {}) do
            AddInstanceToLineage(self:GetQuestById(prerequisite.id), instance, visited)
        end
    end

    for _, quest in ipairs(Q.Quests) do
        for _, instance in ipairs(quest.instances or {}) do
            AddInstanceToLineage(quest, instance, {})
        end
    end
end

function Q.API:GetPlayerLevel()
    return Q.Debug.Enabled and Q.Debug.Level or UnitLevel("player")
end

function Q.API:GetPlayerFaction()
    return Q.Debug.Enabled and Q.Debug.Faction or UnitFactionGroup("player")
end

function Q.API:GetPlayerClass()
    return Q.Debug.Enabled and Q.Debug.Class or select(2, UnitClass("player"))
end

function Q.API:GetPlayerInfo()
    return {
        level = self:GetPlayerLevel(),
        faction = self:GetPlayerFaction(),
        class = self:GetPlayerClass(),
    }
end

function Q.API:GetProfessionIconTexture(profession)
    local icon = profession and ProfessionIcons[profession]
    return icon and ("Interface\\Icons\\" .. icon) or nil
end

function Q.API:PlayerHasProfession(profession)
    if not profession then
        return true
    end

    if Q.Debug.Enabled then
        return true
    end

    if GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local skillName, isHeader = GetSkillLineInfo(i)
            if not isHeader and skillName == profession then
                return true
            end
        end
        return false
    end

    if GetProfessions and GetProfessionInfo then
        for _, index in pairs({ GetProfessions() }) do
            if index and GetProfessionInfo(index) == profession then
                return true
            end
        end
    end

    return false
end

function Q.API:GetClassIconTexture(class)
    if not class then
        return nil
    end

    local className = class:lower():gsub("^%l", string.upper)
    return "Interface\\Addons\\" .. ADDON_NAME .. "\\Media\\Icons\\ClassIcon_" .. className
end

function Q.API:GetDifficultyColor(playerLevel, comparisonLevel)
    if type(playerLevel) ~= "number" or type(comparisonLevel) ~= "number" then
        return nil
    end

    local grayLevel
    if playerLevel <= 5 then
        grayLevel = 0
    elseif playerLevel <= 39 then
        grayLevel = playerLevel - math.floor(playerLevel / 10) - 5
    elseif playerLevel <= 59 then
        grayLevel = playerLevel - math.floor(playerLevel / 5) - 1
    else
        grayLevel = playerLevel - 9
    end

    local levelDifference = comparisonLevel - playerLevel
    if levelDifference >= 5 then
        return Q.Theme.DifficultyColors.Red
    elseif levelDifference >= 3 then
        return Q.Theme.DifficultyColors.Orange
    elseif levelDifference >= -2 then
        return Q.Theme.DifficultyColors.Yellow
    elseif comparisonLevel <= grayLevel then
        return Q.Theme.DifficultyColors.Gray
    else
        return Q.Theme.DifficultyColors.Green
    end
end

function Q.API:GetWaypointText(quest, source)
    local title = string.format("%s (%s)", source.name, quest.name)

    if source.text then
        title = string.format("%s - %s (%s)", source.name, source.text, quest.name)
    end

    return title
end

function Q.API:GetQuests()
    return Q.Quests
end

function Q.API:GetQuestById(questId)
    return Q.QuestById[questId]
end

function Q.API:GetInstanceById(instanceId)
    return Q.InstanceById[instanceId]
end

function Q.API:GetInstances()
    local instances = {}
    for _, instance in pairs(Q.Instances) do
        table.insert(instances, instance)
    end

    table.sort(instances,
        function(a, b) return a.minLevel < b.minLevel or (a.minLevel == b.minLevel and a.maxLevel < b.maxLevel) end)
    return instances
end

function Q.API:IsInstanceQuestChainStart(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end

    local isChainStart = true

    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        if prerequisite.type == Q.PrerequisiteType.CHAIN or
            prerequisite.type == Q.PrerequisiteType.REQUIRED or
            prerequisite.type == Q.PrerequisiteType.ANY
        then
            isChainStart = false
            break
        end
    end

    return isChainStart
end

function Q.API:IsQuestLineageStart(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end

    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        if prerequisite.type == Q.PrerequisiteType.CHAIN or
            prerequisite.type == Q.PrerequisiteType.REQUIRED or
            prerequisite.type == Q.PrerequisiteType.ANY
        then
            return false
        end
    end

    return true
end

function Q.API:IsInstanceQuestLineageStart(questId)
    if not self:IsQuestLineageStart(questId) then
        return false
    end
    return #self:GetInstancesForQuest(questId) > 0
end

function Q.API:GetRelevantQuestsForZone()
    local quests = {}
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = mapID and C_Map.GetMapInfo(mapID)
    if not mapInfo then
        return quests
    end
    local zone = mapInfo.name
    local playerInfo = Q.API:GetPlayerInfo()

    for _, quest in ipairs(self:GetQuests()) do
        for _, source in ipairs(quest.sources or { quest.source }) do
            if self:IsQuestAvailable(quest.id) and
                not self:IsQuestInQuestLog(quest.id) and
                source.faction == playerInfo.faction and
                source.zone == zone and
                playerInfo.level <= (quest.suggestedLevel or quest.requiredLevel or 0) + 3 -- Allow a buffer of 3 levels above the suggested level before it doesn't count as "relevant" anymore
            then
                table.insert(quests, quest)
                break
            end
        end
    end
    return quests
end

function Q.API:GetQuestsByInstanceId(instanceId)
    return Q.QuestsByInstanceId[instanceId] or {}
end

function Q.API:GetInstancesForQuest(questId)
    return Q.InstanceByQuestId[questId] or {}
end

function Q.API:IsQuestRelatedToInstance(questId, instanceId)
    if not questId or not instanceId then
        return false
    end

    local quests = Q.QuestsByInstanceId[instanceId] or {}
    for _, quest in ipairs(quests) do
        if quest.id == questId then
            return true
        end
    end
    return false
end

function Q.API:GetAvailableQuestsByInstanceId(instanceId, playerInfo)
    local quests = {}
    for _, quest in ipairs(self:GetQuestsByInstanceId(instanceId) or {}) do
        if self:IsQuestAvailableToLevel(quest.id, playerInfo) and self:PlayerHasProfession(quest.profession) then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:InstanceHasAvailableQuests(instanceId, playerInfo)
    for _, quest in ipairs(self:GetQuestsByInstanceId(instanceId)) do
        if self:IsQuestAvailableToLevel(quest.id, playerInfo) and
            self:PlayerHasProfession(quest.profession) and
            (Q:GetSetting("HideCompletedQuests") == false or not self:IsQuestCompleted(quest.id))
        then
            return true
        end
    end

    return false
end

function Q.API:IsQuestWatched(questId)
    return C_QuestLog.GetQuestWatchType(questId) ~= nil
end

function Q.API:IsPrerequisiteSatisfied(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end

    local function IsRequiredQuestCompleted(requiredQuestId)
        -- Quest definitions filtered by faction or class are not requirements for this character, so do not query their completion state.
        return not self:GetQuestById(requiredQuestId) or self:IsQuestCompleted(requiredQuestId)
    end

    local hasKnownAnyPrerequisite = false
    local hasCompletedAnyPrerequisite = false

    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        local prerequisiteQuestId = prerequisite.id
        local prerequisiteType = prerequisite.type

        if prerequisiteType == Q.PrerequisiteType.CHAIN or prerequisiteType == Q.PrerequisiteType.REQUIRED
        then
            if not IsRequiredQuestCompleted(prerequisiteQuestId) then
                return false
            end
        elseif prerequisiteType == Q.PrerequisiteType.ANY then
            if self:GetQuestById(prerequisiteQuestId) then
                hasKnownAnyPrerequisite = true
                if self:IsQuestCompleted(prerequisiteQuestId) then
                    hasCompletedAnyPrerequisite = true
                end
            end
        end
    end

    if hasKnownAnyPrerequisite and not hasCompletedAnyPrerequisite then
        return false
    end

    return true
end

function Q.API:IsQuestCompleted(questId)
    return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

function Q.API:IsQuestInQuestLog(questId)
    return C_QuestLog.IsOnQuest(questId)
end

function Q.API:IsQuestAvailableToLevel(questId, playerInfo)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end
    local playerLevel = playerInfo and playerInfo.level or Q.API:GetPlayerLevel()
    if quest.requiredLevel and playerLevel < quest.requiredLevel then
        return false
    end
    return true
end

function Q.API:IsQuestAvailable(questId)
    if not self:GetQuestById(questId) then
        return false
    end

    local playerInfo = Q.API:GetPlayerInfo()
    local quest = self:GetQuestById(questId)

    return
        not self:IsQuestCompleted(questId)
        and self:IsQuestAvailableToLevel(questId, playerInfo)
        and self:PlayerHasProfession(quest.profession)
        and self:IsPrerequisiteSatisfied(questId)
end

function Q.API:GetRandomQuest()
    local chainStartQuests = {}
    for _, quest in ipairs(self:GetQuests()) do
        if self:IsQuestLineageStart(quest.id) then
            table.insert(chainStartQuests, quest)
        end
    end

    if #chainStartQuests == 0 then
        return nil, {}
    end

    local quest = chainStartQuests[math.random(#chainStartQuests)]

    return quest
end

local function AddWaypoint(location, title)
    if not (location and location.mapId and location.x and location.y) then
        Q:PrettyPrint("No waypoint location is available.")
        return
    end

    local tomtom = rawget(_G, "TomTom")
    if not tomtom or not tomtom.AddWaypoint then
        local point = CreateVector2D(location.x, location.y)
        local waypoint = UiMapPoint.CreateFromVector2D(location.mapId, point)
        C_Map.SetUserWaypoint(waypoint)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)

        return
    end

    tomtom:AddWaypoint(tonumber(location.mapId), tonumber(location.x), tonumber(location.y), {
        title = title,
        from = "Dungeon Buddy",
        persistent = true,
    })
end

function Q.API:SetWaypoint(entity, isInstance)
    if isInstance then
        AddWaypoint(entity.location, entity.name .. " (Entrance)")
    else
        local playerInfo = Q.API:GetPlayerInfo()
        if entity.source then
            local title = self:GetWaypointText(entity, entity.source)
            AddWaypoint(entity.source.location, title)
        else
            for _, source in ipairs(entity.sources or {}) do
                if source.faction and source.faction ~= playerInfo.faction then
                    break
                end
                local title = self:GetWaypointText(entity, source)
                AddWaypoint(source.location, title)
            end
        end
    end
end
