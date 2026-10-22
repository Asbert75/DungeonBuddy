# DungeonBuddy

DungeonBuddy helps you remember to pick up quest chains that leads into instance quests by adding notifications when you reach a level that unlocks the start of such a chain. 
It also adds a quest tracker that shows quests by instance, and shows the chain steps that lead to them, making it easier to see what you can pick up, what you are already working on, and what you have completed.

## Features

- Receive a notification on level-up to remind you when you have quest chains that lead into instance quests available. A setting can be toggled that allowes notifications for all instance quests when they become available.
- Browse instance quests in a scrollable quest log, organized by instance. Instances are only visible while you have quests available and you are not above the max level for the instance (Visible next to the instance name).
- Class/profession specific quests have a class icon appended before (in notifications) or after (in quest log) their names.
- Get extra automatic notifications when entering a zone with relevant available quests to pick up, can be turned off in settings.
- Add directions to a quest source from the quest log or a notification (Requires TomTom).
- Optionally show every quest for a instance as soon as one of its quests is available. Quests you are not high enough level for get a "Requires Level" row below them, like a step in a chain.
- Customize the quest colors (available, unavailable, in quest log, completed) in settings to your liking, with a button to reset them to defaults.

## Available commands

| Command | Action |
| --- | --- |
| `/db help` | Show available commands |
| `/db tracker` | Toggle the quest tracker |
| `/db notification on` | Enable level-up notifications |
| `/db notification off` | Disable level-up notifications |
| `/db settings` | Open settings |
| `/db minimap` | Show or hide the minimap button |