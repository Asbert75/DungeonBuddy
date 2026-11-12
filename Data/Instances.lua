local _, Q = ...

Q.Instances = {
    --#region Dungeons
    ["Hall of Thanes"] = {
        id = 1,
        name = "Hall of Thanes",
        continent = "Eastern Kingdoms",
        zone = "Ironforge",
        location = { mapId = 1455, x = 0.466, y = 0.522 },
        minLevel = 13,
        suggestedLevel = 14,
        maxLevel = 18
    },
    ["Ragefire Chasm"] = {
        id = 2,
        name = "Ragefire Chasm",
        continent = "Kalimdor",
        zone = "Orgrimmar",
        location = { mapId = 1454, x = 0.53, y = 0.50 },
        minLevel = 13,
        suggestedLevel = 12,
        maxLevel = 19
    },
    ["Ruins of Lordaeron"] = {
        id = 3,
        name = "Ruins of Lordaeron",
        continent = "Eastern Kingdoms",
        zone = "Tirisfal Glades",
        location = { mapId = 1420, x = 0.61, y = 0.60 },
        minLevel = 15,
        suggestedLevel = 17,
        maxLevel = 20
    },
    ["The Deadmines"] = {
        id = 4,
        name = "The Deadmines",
        continent = "Eastern Kingdoms",
        zone = "Westfall",
        location = { mapId = 1436, x = 0.42, y = 0.71 },
        minLevel = 18,
        suggestedLevel = 17,
        maxLevel = 24
    },
    ["Wailing Caverns"] = {
        id = 5,
        name = "Wailing Caverns",
        continent = "Kalimdor",
        zone = "The Barrens",
        location = { mapId = 1413, x = 0.465, y = 0.36 },
        minLevel = 19,
        suggestedLevel = 18,
        maxLevel = 25
    },
    ["Shadowfang Keep"] = {
        id = 6,
        name = "Shadowfang Keep",
        continent = "Eastern Kingdoms",
        zone = "Silverpine Forest",
        location = { mapId = 1421, x = 0.45, y = 0.68 },
        minLevel = 23,
        suggestedLevel = 22,
        maxLevel = 29
    },
    ["Excavation Site: Wetlands"] = {
        id = 7,
        name = "Excavation Site: Wetlands",
        continent = "Eastern Kingdoms",
        zone = "Wetlands",
        location = { mapId = 1437, x = 0.385, y = 0.470 },
        minLevel = 24,
        suggestedLevel = 26,
        maxLevel = 29
    },
    ["Blackfathom Deeps"] = {
        id = 8,
        name = "Blackfathom Deeps",
        continent = "Kalimdor",
        zone = "Ashenvale",
        location = { mapId = 1440, x = 0.14, y = 0.15 },
        minLevel = 25,
        suggestedLevel = 27,
        maxLevel = 31
    },
    ["The Stockade"] = {
        id = 9,
        name = "The Stockade",
        continent = "Eastern Kingdoms",
        zone = "Stormwind City",
        location = { mapId = 1453, x = 0.422, y = 0.590 },
        minLevel = 26,
        suggestedLevel = 26,
        maxLevel = 32
    },
    ["City of Dalaran"] = {
        id = 10,
        name = "City of Dalaran",
        continent = "Eastern Kingdoms",
        zone = "Silverpine Forest",
        location = { mapId = 1421, x = 0.693, y = 0.455 },
        minLevel = 28,
        suggestedLevel = 30,
        maxLevel = 33
    },
    ["Razorfen Kraul"] = {
        id = 11,
        name = "Razorfen Kraul",
        continent = "Kalimdor",
        zone = "The Barrens",
        location = { mapId = 1413, x = 0.43, y = 0.90 },
        minLevel = 30,
        suggestedLevel = 29,
        maxLevel = 36
    },
    ["Gnomeregan"] = {
        id = 12,
        name = "Gnomeregan",
        continent = "Eastern Kingdoms",
        zone = "Dun Morogh",
        location = { mapId = 1426, x = 0.245, y = 0.396 },
        minLevel = 31,
        suggestedLevel = 30,
        maxLevel = 37
    },
    ["Scarlet Monastery: Graveyard"] = {
        id = 13,
        name = "Scarlet Monastery: Graveyard",
        continent = "Eastern Kingdoms",
        zone = "Tirisfal Glades",
        location = { mapId = 1420, x = 0.825, y = 0.336 },
        minLevel = 31,
        suggestedLevel = 30,
        maxLevel = 37
    },
    ["Scarlet Monastery: Library"] = {
        id = 14,
        name = "Scarlet Monastery: Library",
        continent = "Eastern Kingdoms",
        zone = "Tirisfal Glades",
        location = { mapId = 1420, x = 0.825, y = 0.336 },
        minLevel = 34,
        suggestedLevel = 33,
        maxLevel = 40
    },
    ["The Drowned City"] = {
        id = 30,
        name = "The Drowned City",
        continent = "Eastern Kingdoms",
        zone = "Stranglethorn Vale",
        location = { mapId = 1434, x = 0.215, y = 0.278 },
        minLevel = 35,
        suggestedLevel = 37,
        maxLevel = 40
    },
    ["Scarlet Monastery: Armory"] = {
        id = 15,
        name = "Scarlet Monastery: Armory",
        continent = "Eastern Kingdoms",
        zone = "Tirisfal Glades",
        location = { mapId = 1420, x = 0.825, y = 0.336 },
        minLevel = 37,
        suggestedLevel = 36,
        maxLevel = 43
    },
    ["Razorfen Downs"] = {
        id = 16,
        name = "Razorfen Downs",
        continent = "Kalimdor",
        zone = "The Barrens",
        location = { mapId = 1413, x = 0.489, y = 0.936 },
        minLevel = 38,
        suggestedLevel = 37,
        maxLevel = 44
    },
    ["Scarlet Monastery: Cathedral"] = {
        id = 17,
        name = "Scarlet Monastery: Cathedral",
        continent = "Eastern Kingdoms",
        zone = "Tirisfal Glades",
        location = { mapId = 1420, x = 0.825, y = 0.336 },
        minLevel = 39,
        suggestedLevel = 38,
        maxLevel = 45
    },
    ["Krol'dok Stronghold"] = {
        id = 32,
        name = "Krol'dok Stronghold",
        continent = "Eastern Kingdoms",
        zone = "Riverglades",
        location = { mapId = 2548, x = 0.40, y = 0.31 },
        minLevel = 40,
        suggestedLevel = 42,
        maxLevel = 45
    },
    ["Uldaman"] = {
        id = 18,
        name = "Uldaman",
        continent = "Eastern Kingdoms",
        zone = "Badlands",
        location = { mapId = 1418, x = 0.42, y = 0.10 },
        minLevel = 44,
        suggestedLevel = 43,
        maxLevel = 50
    },
    ["Zul'Farrak"] = {
        id = 19,
        name = "Zul'Farrak",
        continent = "Kalimdor",
        zone = "Tanaris",
        location = { mapId = 1446, x = 0.39, y = 0.21 },
        minLevel = 45,
        suggestedLevel = 44,
        maxLevel = 51
    },
    ["Alcaz Prison"] = {
        id = 33,
        name = "Alcaz Prison",
        continent = "Kalimdor",
        zone = "Dustwallow Marsh",
        location = { mapId = 1445, x = 0.755, y = 0.178 },
        minLevel = 48,
        suggestedLevel = 50,
        maxLevel = 53
    },
    ["Maraudon"] = {
        id = 20,
        name = "Maraudon",
        continent = "Kalimdor",
        zone = "Desolace",
        location = { mapId = 1443, x = 0.29, y = 0.62 },
        minLevel = 48,
        suggestedLevel = 48,
        maxLevel = 54
    },
    ["Temple of Atal'Hakkar"] = {
        id = 21,
        name = "Temple of Atal'Hakkar",
        continent = "Eastern Kingdoms",
        zone = "Swamp of Sorrows",
        location = { mapId = 1435, x = 0.69, y = 0.54 },
        minLevel = 52,
        suggestedLevel = 51,
        maxLevel = 58
    },
    ["Blackrock Depths"] = {
        id = 22,
        name = "Blackrock Depths",
        continent = "Eastern Kingdoms",
        zone = "Burning Steppes",
        location = { mapId = 1428, x = 0.292, y = 0.382 },
        minLevel = 52,
        suggestedLevel = 55,
        maxLevel = 60
    },
    ["Blackmaw Hold"] = {
        id = 34,
        name = "Blackmaw Hold",
        continent = "Kalimdor",
        zone = "Azshara",
        location = { mapId = 1447, x = 0.393, y = 0.322 },
        minLevel = 55,
        suggestedLevel = 57,
        maxLevel = 60
    },
    ["Dire Maul: East"] = {
        id = 23,
        name = "Dire Maul: East",
        continent = "Kalimdor",
        zone = "Feralas",
        location = { mapId = 1444, x = 0.59, y = 0.45 },
        minLevel = 55,
        suggestedLevel = 54,
        maxLevel = 60
    },
    ["Shaper's Terrace"] = {
        id = 35,
        name = "Shaper's Terrace (INCOMPLETE)",
        continent = "Kalimdor",
        zone = "Un'Goro Crater",
        location = { mapId = 1449, x = 0.329, y = 0.197 },
        minLevel = 58,
        suggestedLevel = 59,
        maxLevel = 60
    },
    ["Dire Maul: West"] = {
        id = 24,
        name = "Dire Maul: West",
        continent = "Kalimdor",
        zone = "Feralas",
        location = { mapId = 1444, x = 0.59, y = 0.45 },
        minLevel = 58,
        suggestedLevel = 57,
        maxLevel = 60
    },
    ["Lower Blackrock Spire"] = {
        id = 25,
        name = "Lower Blackrock Spire",
        continent = "Eastern Kingdoms",
        zone = "Burning Steppes",
        location = { mapId = 1428, x = 0.292, y = 0.382 },
        minLevel = 57,
        suggestedLevel = 56,
        maxLevel = 60
    },
    ["Scholomance"] = {
        id = 26,
        name = "Scholomance",
        continent = "Eastern Kingdoms",
        zone = "Western Plaguelands",
        location = { mapId = 1422, x = 0.69, y = 0.73 },
        minLevel = 58,
        suggestedLevel = 58,
        maxLevel = 60
    },
    ["Dire Maul: North"] = {
        id = 27,
        name = "Dire Maul: North",
        continent = "Kalimdor",
        zone = "Feralas",
        location = { mapId = 1444, x = 0.59, y = 0.45 },
        minLevel = 59,
        suggestedLevel = 58,
        maxLevel = 60
    },
    ["Upper Blackrock Spire"] = {
        id = 28,
        name = "Upper Blackrock Spire",
        continent = "Eastern Kingdoms",
        zone = "Burning Steppes",
        location = { mapId = 1428, x = 0.292, y = 0.382 },
        minLevel = 59,
        suggestedLevel = 58,
        maxLevel = 60
    },
    ["Stratholme"] = {
        id = 29,
        name = "Stratholme",
        continent = "Eastern Kingdoms",
        zone = "Eastern Plaguelands",
        location = { mapId = 1423, x = 0.479, y = 0.237 },
        minLevel = 59,
        suggestedLevel = 58,
        maxLevel = 60
    },
    --#endregion
    --#region Raids
    ["Onyxia's Lair"] = {
        id = 36,
        name = "Onyxia's Lair",
        continent = "Kalimdor",
        zone = "Dustwallow Marsh",
        location = { mapId = 1445, x = 0.526, y = 0.766 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Molten Core"] = {
        id = 37,
        name = "Molten Core",
        continent = "Eastern Kingdoms",
        zone = "Burning Steppes",
        location = { mapId = 1428, x = 0.292, y = 0.382 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Blackwing Lair"] = {
        id = 38,
        name = "Blackwing Lair",
        continent = "Eastern Kingdoms",
        zone = "Burning Steppes",
        location = { mapId = 1428, x = 0.292, y = 0.382 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["The Barrow Deeps"] = {
        id = 39,
        name = "The Barrow Deeps (INCOMPLETE)",
        continent = "Kalimdor",
        zone = "Mount Hyjal",
        location = { mapId = 2482, x = 0.36, y = 0.68 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Hyjal Summit"] = {
        id = 40,
        name = "Hyjal Summit (INCOMPLETE)",
        continent = "Kalimdor",
        zone = "Mount Hyjal",
        location = { mapId = 2482, x = 0.36, y = 0.68 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Temple of Ahn'Qiraj"] = {
        id = 41,
        name = "Temple of Ahn'Qiraj",
        continent = "Kalimdor",
        zone = "Silithus",
        location = { mapId = 1451, x = 0.284, y = 0.923 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Ruins of Ahn'Qiraj"] = {
        id = 42,
        name = "Ruins of Ahn'Qiraj",
        continent = "Kalimdor",
        zone = "Silithus",
        location = { mapId = 1451, x = 0.35, y = 0.79 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    },
    ["Naxxramas"] = {
        id = 43,
        name = "Naxxramas",
        continent = "Eastern Kingdoms",
        zone = "Eastern Plaguelands",
        location = { mapId = 1423, x = 0.27, y = 0.17 },
        minLevel = 60,
        suggestedLevel = 60,
        maxLevel = 60
    }
    --#endregion
}

-- Unknown keys (typos) return nil; record them so Validation.lua can report them.
Q.MissingInstanceKeys = {}
setmetatable(Q.Instances, {
    __index = function(_, key)
        Q.MissingInstanceKeys[#Q.MissingInstanceKeys + 1] = tostring(key)
    end
})
