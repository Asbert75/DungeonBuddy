# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.5.5] - 2026-10-15

### Added

- Added the Wolfsbane quest line for horde paladins
- Updated the design to be more "futuristic"

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
