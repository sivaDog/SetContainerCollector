# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.1] - 2026-06-21

### Changed

- Manifest uses `.txt` extension (PC-only; avoids console emulation load)
- Dependency version checks: LibAddonMenu-2.0>=43, LibSets>=9020, AwesomeGuildStore>=3282
- SavedVariables scoped per megaserver via `GetWorldName()`
- Localization via `lang/en.lua` and `lang/$(language).lua` with `SI_SCC_*` string constants
- Gamepad / controller UI tooltips use ZO section API (`bodyDescription`) instead of keyboard `KB_` fonts
- Tooltip font size setting disabled in gamepad-preferred mode (uses ZO default styles)

## [1.0.0] - 2026-06-21

### Added

- Account-wide set collection progress (`Collected: X/Y`) on equipment container tooltips
- Registered containers for:
  - Cyrodiil AP Elite Gear Vendor (87710–87746) and monster elite mask/shoulder boxes (711–713)
  - Imperial City Tel Var vendors (gear boxes and curated monster shoulder coffers)
  - Undaunted curated coffers and Mystery Coffer pools
  - Battleground Merchant weapon containers
  - Regional Equipment Vendor zone bags
  - LibSets-based pools (AP elite, Tel Var lockbox, Cyrodiil quartermasters, etc.)
- Auto-detection for unregistered single-set containers via `GetItemLinkContainerSetInfo`
- Settings (LibAddonMenu-2.0): auto-resolve toggle, tooltip font size
- Slash commands: `/scc pool <key>`, `/scc debuglink <itemLink>`
- Japanese UI strings

[1.0.1]: https://github.com/sivaDog/SetContainerCollector/releases/tag/v1.0.1
[1.0.0]: https://github.com/sivaDog/SetContainerCollector/releases/tag/v1.0.0
