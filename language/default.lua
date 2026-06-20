SetContainerCollector = SetContainerCollector or {}
local SCC = SetContainerCollector

SCC.Strings = {
  tooltipProgress = "Collected: <<1>>/<<2>>",
  tooltipAutoResolved = "Auto-detected: <<1>>",
  tooltipAutoResolvedWithSlot = "Auto-detected: <<1>> (<<2>>)",
  tooltipAutoResolvedSlotHead = "head only",
  tooltipAutoResolvedSlotShoulders = "shoulders only",
  tooltipNoData = "Container data not configured yet.",
  slashPoolUsage = "Usage: /scc pool <poolKey>  (e.g. maj_mystery, ap_elite, battleground_merchant)",
  slashPoolUnknown = "Unknown pool: <<1>>",
  slashPoolResult = "<<1>>: <<2>>/<<3>> collected",
  settingsDescription = "Shows account-wide set collection progress on equipment container tooltips.",
  settingsAutoResolve = "Auto-detect unregistered containers",
  settingsAutoResolveTooltip = "When enabled, unidentified set boxes not listed in the addon database are resolved via the game's container set info API.",
  settingsTooltipFontSize = "Tooltip font size",
  settingsTooltipFontSizeTooltip = "Font size for the collection progress line in container tooltips.",
  settingsSlashHelp = "/scc pool <key> — print pool progress. /scc debuglink <itemLink> — inspect a container link.",
}
