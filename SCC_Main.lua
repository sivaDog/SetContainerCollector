SetContainerCollector = SetContainerCollector or {}
local SCC = SetContainerCollector

SCC.Name = "SetContainerCollector"
SCC.DisplayName = "Set Container Collector"
SCC.Author = "sivaDog"
SCC.Version = "1.0.0"

SCC.defaultSetting = {
  auto_resolve = true,
  tooltip_font_size = 18,
  colorKnown = 0x55ff1c,
  colorPartial = 0x3399FF,
  colorUnknown = 0x777766,
}

local function InitializeAfterLibSets()
  SCC.BuildPoolPieceCache()
  SCC.HookTooltips()
end

local function RegisterSettings()
  local panelData = {
    type = "panel",
    name = SCC.DisplayName,
    displayName = SCC.DisplayName,
    author = SCC.Author,
    version = SCC.Version,
    registerForRefresh = true,
    registerForDefaults = true,
  }

  local options = {
    {
      type = "description",
      text = SCC.Strings.settingsDescription,
    },
    {
      type = "divider",
    },
    {
      type = "checkbox",
      name = SCC.Strings.settingsAutoResolve,
      tooltip = SCC.Strings.settingsAutoResolveTooltip,
      getFunc = function() return SCC.IsAutoResolveEnabled() end,
      setFunc = function(value) SCC.savedVariables.auto_resolve = value end,
      default = SCC.defaultSetting.auto_resolve,
    },
    {
      type = "slider",
      name = SCC.Strings.settingsTooltipFontSize,
      tooltip = SCC.Strings.settingsTooltipFontSizeTooltip,
      min = 12,
      max = 28,
      step = 1,
      getFunc = function()
        return SCC.savedVariables.tooltip_font_size or SCC.defaultSetting.tooltip_font_size
      end,
      setFunc = function(value)
        SCC.savedVariables.tooltip_font_size = value
      end,
      default = SCC.defaultSetting.tooltip_font_size,
    },
    {
      type = "description",
      text = SCC.Strings.settingsSlashHelp,
    },
  }

  LibAddonMenu2:RegisterAddonPanel(SCC.Name .. "Options", panelData)
  LibAddonMenu2:RegisterOptionControls(SCC.Name .. "Options", options)
end

local function OnSlashCommand(input)
  if input == nil or input == "" then
    d(SCC.Strings.slashPoolUsage)
    return
  end

  local poolKey = string.match(input, "^pool%s+(%S+)$")
  if poolKey then
    SCC.PrintPoolSummary(poolKey)
    return
  end

  local debugLink = string.match(input, "^debuglink%s+(.+)$")
  if debugLink then
    SCC.DebugItemLink(debugLink)
  end
end

local function RegisterSlashCommands()
  if IsConsoleUI() then return end

  if LibSlashCommander then
    local cmd = LibSlashCommander:Register()
    cmd:AddAlias("/scc")
    cmd:SetCallback(OnSlashCommand)
    cmd:SetDescription("Set Container Collector")
  else
    SLASH_COMMANDS["/scc"] = OnSlashCommand
  end
end

local function OnLoad(eventCode, name)
  if name ~= SCC.Name then return end
  EVENT_MANAGER:UnregisterForEvent(SCC.Name, EVENT_ADD_ON_LOADED)

  SCC.savedVariables = ZO_SavedVars:NewAccountWide(
    "SetContainerCollectorSavedVariables",
    1,
    nil,
    SCC.defaultSetting
  )

  RegisterSettings()
  RegisterSlashCommands()
  SCC.WaitForLibSets(InitializeAfterLibSets)
end

EVENT_MANAGER:RegisterForEvent(SCC.Name, EVENT_ADD_ON_LOADED, OnLoad)
