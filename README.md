# DungeonBuddy

DungeonBuddy helps you remember to pick up quest chains that leads into instance quests by adding notifications when you reach a level that unlocks the start of such a chain. 
It also adds a quest tracker that shows quests by instance, and shows the chain steps that lead to them, making it easier to see what you can pick up, what you are already working on, and what you have completed.

## Features

- Receive a notification on level-up to remind you when you have quest chains that lead into instance quests available. A setting can be toggled that allows notifications for all instance quests when they become available.
- Browse instance quests in a scrollable quest tracker, organized by instance. Instances are only visible while you have quests available and you are not above the max level for the instance (shown next to the instance name).
- Hover a quest row for a tooltip with its status, prerequisites and who or where it is started by. Instance rows show location, level range and quest counts (total, completed, in your quest log and available now).
- Sort, group and filter the tracker: sort instances by Continent, Zone, Level or Name and quests by Level or Name (each ascending or descending), group instances by Continent or Zone with collapsible headers, and hide continents.
- Class/profession specific quests have a class icon appended to the quest name so you can clearly see what is specific to your current situation.
- Get extra automatic notifications when entering a zone with relevant available quests to pick up, can be turned off in settings.
- Add directions to a quest source from the tracker or a notification. Uses TomTom if it is installed, otherwise the in-game waypoint. Quests that start inside an instance point to the instance entrance.
- Optionally show every quest for an instance as soon as one of its quests is available.
- Optionally hide completed quests, show the suggested quest level, and hide the minimap button.
- Choose between several color themes in settings.

## Available commands

| Command | Action |
| --- | --- |
| `/db help` | Show available commands |
| `/db tracker` | Toggle the quest tracker |
| `/db notification on` | Enable level-up notifications |
| `/db notification off` | Disable level-up notifications |
| `/db settings` | Open settings |
| `/db minimap` | Show or hide the minimap button |

`/dungeonbuddy` works as an alias for `/db`.