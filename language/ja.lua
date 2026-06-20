-- Japanese strings (override defaults when client language is Japanese)
if GetCVar("language.2") ~= "jp" then return end

local SCC = SetContainerCollector

SCC.Strings.tooltipProgress = "コレクション: <<1>>/<<2>>"
SCC.Strings.tooltipAutoResolved = "自動検出: <<1>>"
SCC.Strings.tooltipAutoResolvedWithSlot = "自動検出: <<1>>（<<2>>）"
SCC.Strings.tooltipAutoResolvedSlotHead = "頭のみ"
SCC.Strings.tooltipAutoResolvedSlotShoulders = "肩のみ"
SCC.Strings.tooltipNoData = "コンテナデータが未登録です。"
SCC.Strings.slashPoolUsage = "使い方: /scc pool <poolKey>  (例: maj_mystery, ap_elite, battleground_merchant)"
SCC.Strings.slashPoolUnknown = "不明なプール: <<1>>"
SCC.Strings.slashPoolResult = "<<1>>: <<2>>/<<3>>"
SCC.Strings.settingsDescription = "装備コンテナのツールチップに、アカウント全体のセットコレクション進捗を表示します。"
SCC.Strings.settingsAutoResolve = "未登録コンテナの自動解決"
SCC.Strings.settingsAutoResolveTooltip = "有効にすると、DB未登録の未鑑定セット箱をゲームAPI（ContainerSetInfo）から自動的に判別して進捗を表示します。"
SCC.Strings.settingsTooltipFontSize = "ツールチップの文字サイズ"
SCC.Strings.settingsTooltipFontSizeTooltip = "コンテナツールチップの進捗表示に使う文字サイズです。"
SCC.Strings.settingsSlashHelp = "/scc pool <key> — プール進捗を表示。/scc debuglink <itemLink> — コンテナリンクを調査。"
