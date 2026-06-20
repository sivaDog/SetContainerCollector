SetContainerCollector = SetContainerCollector or {}
local SCC = SetContainerCollector

local FONT_STYLE = "MEDIUM_FONT"
local FONT_WEIGHT = "soft-shadow-thin"

local function GetTooltipFontSize()
  local size = SCC.savedVariables and SCC.savedVariables.tooltip_font_size
  if size == nil then
    size = SCC.defaultSetting.tooltip_font_size
  end
  return zo_clamp(size, 12, 28)
end

local function GetLineFormat(size)
  return string.format("$(%s)|$(KB_%s)|%s", FONT_STYLE, size, FONT_WEIGHT)
end

local function GetEquipSlotHintText(equipSlot)
  if equipSlot == EQUIP_TYPE_HEAD then
    return SCC.Strings.tooltipAutoResolvedSlotHead
  end
  if equipSlot == EQUIP_TYPE_SHOULDERS then
    return SCC.Strings.tooltipAutoResolvedSlotShoulders
  end
  return nil
end

local function AppendAutoResolvedHint(tooltipControl, containerDef, fontSize)
  if not containerDef.autoResolved then return end

  local hintSize = zo_clamp(fontSize - 2, 12, fontSize)
  local hintColor = SCC.savedVariables.colorUnknown or SCC.defaultSetting.colorUnknown
  local setLabel = containerDef.label or GetItemSetName(containerDef.setId)
  local slotHint = containerDef.inferredEquipSlot and GetEquipSlotHintText(containerDef.equipSlot) or nil
  local hintText = slotHint
    and zo_strformat(SCC.Strings.tooltipAutoResolvedWithSlot, setLabel, slotHint)
    or zo_strformat(SCC.Strings.tooltipAutoResolved, setLabel)

  tooltipControl:AddLine(
    string.format("|c%06X%s|r", hintColor, hintText),
    GetLineFormat(hintSize)
  )
end

local function AppendContainerTooltip(tooltipControl, itemLink)
  local itemId = GetItemLinkItemId(itemLink)
  local containerDef = SCC.GetContainerDefinition(itemId, itemLink)
  if not containerDef then return end

  local summary = SCC.GetContainerCollectionSummary(containerDef)
  local fontSize = GetTooltipFontSize()

  ZO_Tooltip_AddDivider(tooltipControl)

  if not summary then
    tooltipControl:AddLine(SCC.Strings.tooltipNoData, GetLineFormat(fontSize))
    return
  end

  tooltipControl:AddLine(SCC.FormatProgressText(summary.known, summary.total), GetLineFormat(fontSize))
  AppendAutoResolvedHint(tooltipControl, containerDef, fontSize)
end

local function TooltipHook(tooltipControl, method, linkFunc)
  local origMethod = tooltipControl[method]
  tooltipControl[method] = function(self, ...)
    origMethod(self, ...)
    local itemLink = linkFunc(...)
    if itemLink and itemLink ~= "" then
      AppendContainerTooltip(tooltipControl, itemLink)
    end
  end
end

local function TooltipHook_Gamepad(tooltipControl, method, linkFunc)
  local origMethod = tooltipControl[method]
  tooltipControl[method] = function(self, ...)
    local result = origMethod(self, ...)
    local itemLink = linkFunc(...)
    if itemLink and itemLink ~= "" then
      AppendContainerTooltip(tooltipControl, itemLink)
    end
    return result
  end
end

local function ItemLinkPassthrough(itemLink)
  return itemLink
end

local function HookTradingHouseTooltips()
  TooltipHook(ItemTooltip, "SetTradingHouseItem", GetTradingHouseSearchResultItemLink)
  TooltipHook(ItemTooltip, "SetTradingHouseListing", GetTradingHouseListingItemLink)
end

function SCC.HookTooltips()
  TooltipHook(PopupTooltip, "SetLink", ItemLinkPassthrough)
  TooltipHook(ItemTooltip, "SetLink", ItemLinkPassthrough)
  TooltipHook(ItemTooltip, "SetBagItem", GetItemLink)
  TooltipHook(ItemTooltip, "SetTradeItem", GetTradeItemLink)
  TooltipHook(ItemTooltip, "SetBuybackItem", GetBuybackItemLink)
  TooltipHook(ItemTooltip, "SetStoreItem", GetStoreItemLink)
  TooltipHook(ItemTooltip, "SetAttachedMailItem", GetAttachedItemLink)
  TooltipHook(ItemTooltip, "SetLootItem", GetLootItemLink)
  TooltipHook(ItemTooltip, "SetReward", GetItemRewardItemLink)
  TooltipHook(ItemTooltip, "SetQuestReward", GetQuestRewardItemLink)

  if AwesomeGuildStore then
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.AFTER_INITIAL_SETUP, HookTradingHouseTooltips)
  else
    HookTradingHouseTooltips()
  end

  TooltipHook_Gamepad(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_LEFT_TOOLTIP), "LayoutItem", ItemLinkPassthrough)
  TooltipHook_Gamepad(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_RIGHT_TOOLTIP), "LayoutItem", ItemLinkPassthrough)
  TooltipHook_Gamepad(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_MOVABLE_TOOLTIP), "LayoutItem", ItemLinkPassthrough)
end
