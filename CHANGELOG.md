# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.18] - 2026-11-07

### Fixed

- Removed dungeon status for quest 'The Day After' which is just a prequest
- Corrected the location of Brother Crowley in SW

## [2.0.17] - 2026-11-07

### Fixed

- Fixed an issue causing minimap button to not hide correctly

## [2.0.16] - 2026-11-06

### Fixed

- Updated location for High Sorcerer Andromath
- Updated Elemental Aid to support faction specific versions so that dwarf shamans version is correctly reflected in the log

### Changed

- Breadcrumb quests are now hidden in the tracker when the player has the followup quest in their quest log

### Added

- Added new WoW Forever Deadmines questline Destruction in Deadmines

## [2.0.15] - 2026-11-06

### Fixed

- Added quest line required for Horror in the Highlands (Excavation Site: Wetlands)

## [2.0.14] - 2026-11-06

### Changed

- Notifications no longer automatically pop up for quests started within a dungeon

### Fixed

- Added the missing Young Crocolisk Skins prerequisite for Highlands Hides in Excavation Site: Wetlands
- Updated Nikova Raskol location and info text

## [2.0.13] - 2026-11-06

### Added

- Added breadcrumb quest for Excavation Site: Wetlands quest Lost in the Thicket Things
- Added new Ruins of Lordaeron chains

### Changed

- Updated auto reminder quest cooldown from 60 seconds to 15 minutes

## [2.0.12] - 2026-11-05

### Added

- Added 2 new quests for The Drowned City (with unknown sources)

## [2.0.11] - 2026-11-05

### Fixed

- Updated the requirement quest of Red Silken Bandanas to The Defias Brotherhood (Escort)

## [2.0.10] - 2026-11-05

### Fixed

- Updated the source location for Argos Nightwhisper

## [2.0.9] - 2026-11-05

### Changed

- The Find Source and Set Waypoint buttons no longer show for quests that are located inside the dungeon to stop confusion

## [2.0.8] - 2026-11-05

### Fixed

- Update quest giver locations for Deadmines quests
- Corrected The Defias Brotherhood chain quest ids

## [2.0.7] - 2026-11-05

### Fixed

- Updated the level requirement of "Knowledge in the Deep" to level 18 (was 10 in Classic)

## [2.0.6] - 2026-11-05

### Fixed

- Collapse button is now hidden when the previous quest is hidden

## [2.0.5] - 2026-11-05

### Fixed

- Updated version

## [2.0.4] - 2026-11-05

### Added

- Added resizing for the quest tracker

## [2.0.3] - 2026-11-05

### Fixed

- Updated source location for quest Underground Map

## [2.0.2] - 2026-11-05

### Fixed

- Fixed an issue causing level up notifications not to show properly

## [2.0.1] - 2026-11-04

### Added

- Added a setting to allow toggling clear visual guides to distinguish which quests are part of the same chain in the quest tracker

### Changed

- Changed how quest class requirements are built, so that we can handle multiple classes for a single quest
- Updated Sources to be its own table to deduplicate sources and avoid location issues
- All Ruins of Lordaeron quests now require level 15, in line with Blizzards latest update
- Changed how the scroll wheel functions in the tracker to scroll 5% of the total height per rotation (down to a minimum of what it is now). This should hopefully make scrolling large lists easier while leaving some precision.

## [2.0.0] - 2026-11-03

### Added

- Added color themes that you can switch between from the Settings-window.
- Instance rows in the tracker now show a tooltip with location, level range and quest counts (total, completed, in your quest log and available now, hidden if count is 0)
- Added a Filter/Sort window to the quest tracker that allows for changing sort, filters and grouping.

### Changed

- Added (X/Y) suffixes to quest chains that shared the same name (Hidden Enemies, The Defias Brotherhood, Down the Scarlet Path, Prospect of Faith, Passing Word of a Threat, The Smoldering Ruins of Thaurissan, The Restless Souls, Menethil's Gift, The Test of Righteousness and The Tome of Valor) to help distinguish between them more easily in the UI.
- Only instances and the final quest of a chain can be collapsed by default; collapsing every step in a chain is now an optional setting
- Instances with identical level ranges are now ordered by name as a fallback
- Removed the ability to change color of quest statuses

### Fixed

- Fixed an issue where the function that checked for zone related quests would only check for quests that had a faction requirement
- The level up notification now properly uses the level returned by the event instead of a GetPlayerLevel() function call that could potentially return the wrong level
- The quest tracker now refreshes when the player's profession skill lines change
- Fixed faction selection when setting waypoints for quests with multiple sources
- Fixed quest data for multiple quests
- Corrected location data for multiple quests and instances

## [1.6.3] - 2026-11-01

### Added

- Added missing quest chain for City of Dalaran

### Changed

- Available breadcrumb quests (marked with B) as well as optional quests (marked with *) are now marked in a blue color in the tracker

### Fixed

- Fixed pixel perfect scaling for borders so that they do not collapse into 0 pixels on some UI scales

## [1.6.2] - 2026-10-27

### Changed

- Updated tooltip to more clearly convey quest information (status, started by etc) to the user
- Collapsing a quest that is used in multiple different chains now only collapse it for that specific row
- Changed default settings

### Added

- Added missing chain for Allegiance to the Old Gods in Blackfathom Deeps

### Fixed

- Added truncation to the quest title text on long quest rows so that they do not overlap the waypoint/collapse buttons

## [1.6.1] - 2026-10-22

### Added

- Added some missing dungeon quests for shamans and rogues, as well as one missing Alliance quest in Scarlet Monastery
- Class colored border around class icons

### Changed

- Blizzard default waypoints are now used as a backup if TomTom is not installed
- Row-level tooltips now display source info beneath a source name if there is any

## [1.6.0] - 2026-10-22

### Added

- Added tooltip information to each quest row
- Added the ability to toggle tracking a quest with shift-click once it's in your log
- Collapsing/Expanding an entire row can now be done by just clicking the row

### Fixed

- Corrected some quest data


## [1.5.6] - 2026-10-18

### Fixed

- `/db settings` no longer causes a Lua error
- "Reminders when switching to a new zone" no longer requires level-up notifications to be enabled
- Toggling notification settings no longer calls OnEnable / OnDisable (bypassing the ACE module enable/disable handling)
- Fixed an issue causing levelup notification to crash

### Changed

- Removed the unused account-wide saved variable and unused optional dependencies from the addon metadata
- The quest tracker no longer rebuilds on every quest log event while hidden, and rapid updates are now debounced
- Checking whether a dungeon has available quests no longer scans every quest in the game

## [1.5.5] - 2026-10-15

### Added

- Added the Wolfsbane quest line for horde paladins
- Added a "Reset Colors" button to the quest color settings
- Added a setting to show all quests for a dungeon as soon as a single one of its quests is available to the player. If the setting is enabled, quests you are not high enough level for now get a separate "Requires Level" row below them

### Changed

- Updated the design of the addon
- Updated the tooltips to use the addon design

### Fixed

- Corrected some quest data that was still wrong such as The Madness Within not correctly showing DM: West and the shaman quest Material Assistance not being set as the prerequisite for The Darkreaver Menace

## [1.5.4] - 2026-10-14

### Fixed

- Entering a dungeon should no longer cause a LUA error in the Auto reminder module

## [1.5.2] - 2026-10-14

### Added

- Added new setting to hide/show suggested quest levels.
- Added support for profession-locked quests (Lorax, The Demon Forge)

### Fixed

- Corrected some incorrect quest data
- Fixed an issue with setting waypoints to quests in the tracker not working

## [1.5.1] - 2026-10-13

### Added

- Quests with shared questlines now display the chain in only one place instead of both, a new row is shown to alert you that there are shared quests
- Added breadcrumb quests with a breadcrumb-prefix, these are quests that are not required but only guide you in the right direction

### Changed

- Updated the logic behind prerequisites to support multiple optional quests where only 1 is required.

### Fixed

- Corrected the logic behind notifications to only show notifications for quests that either start a chain, or for quests that are directly inside the dungeon

## [1.5.0] - 2026-10-11

### Added
- Added character-specific settings instead of account-wide. 

### Fixed

- Fixed an issue where level up event handler returned quests for your previous level because UnitLevel did not update before trigger"

## [1.4.1] - 2026-10-10

### Fixed

- Added a missing dependency causing the addon to not load when enabled on its own

## [1.4.0] - 2026-10-10

### Added

- Added a "View Previous Quest" button on the notification view when multiple quests are available in one single popup

### Changed

- A quest may not correctly have multiple sources (Class quests for example that can be started in all major cities)
- Updated how quest/dungeon relations are built in an attempt to simplify both usage but also updates going forward

## [1.3.0] - 2026-10-09

### Changed

- Updated minimap icon to use the weapon chain enchant icon
- Updated quest tracker to hide dungeons if all quests are completed when "Hide completed quests" is checked

### Added

- Added City of Dalaran quests

### Fixed

- Updated the "No Quests Found" text to properly hide/show when refreshing tracker

## [1.2.0] - 2026-10-08

## Fixed

- Corrected an issue where the count for a chain quest would not display properly if the chain was collapsed when logging in


## [1.1.0] - 2026-10-07

### Changed

- Updated the settings pane to include sections for each type of setting

### Added

- Added a new setting that allows users to determine if they want notifications for all dungeon quests, not just ones that start a quest chain. Off by default.
