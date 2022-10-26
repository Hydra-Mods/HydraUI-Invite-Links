local sub = string.sub
local gsub = string.gsub
local lower = string.lower
local format = string.format
local gmatch = string.gmatch

local Player = UnitName("player") .. "-" .. GetRealmName()
local SetHyperlink = ItemRefTooltip.SetHyperlink

local Keywords = {}

Keywords["inv"] = true
Keywords["reinv"] = true
Keywords["invite"] = true
Keywords["reinvite"] = true
Keywords[gsub(_G.SLASH_INVITE2, "/", "")] = true -- /inv
Keywords[gsub(_G.SLASH_INVITE3, "/", "")] = true -- /invite

for word in next, Keywords do
	print(word)
end

ItemRefTooltip.SetHyperlink = function(self, link, text, button, frame)
	if (sub(link, 1, 7) == "command") then
		local EditBox = ChatEdit_ChooseBoxForSend()
		local Command = sub(link, 9)
		
		EditBox:SetText("")
		
		if (not EditBox:IsShown()) then
			ChatEdit_ActivateChat(EditBox)
		else
			ChatEdit_UpdateHeader(EditBox)
		end
		
		EditBox:Insert(Command)
		ChatEdit_ParseText(EditBox, 1)
	else
		SetHyperlink(self, link, text, button, frame)
	end
end

local FindInvites = function(self, event, msg, sender, ...)
	if (sender == Player) then
		return
	end

	for word in gmatch(msg, "(%w+)") do
		if Keywords[lower(word)] then
			msg = gsub(lower(msg), lower(word), format("|cFFFFEB3B|Hcommand:/invite %s|h[%s]|h|r", sender, word))

			return false, msg, sender, ...
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", FindInvites)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", FindInvites)

if IsAddOnLoaded("HydraUI_InviteLinks") then -- Temp, disable the addons predecessor
	DisableAddOn("HydraUI_InviteLinks")
end