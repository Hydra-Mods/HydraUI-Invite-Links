local sub = string.sub
local gsub = string.gsub
local lower = string.lower
local format = string.format
local gmatch = string.gmatch
local Player = format("%s-%s", UnitName("player"), GetRealmName())
local SetHyperlink = ItemRefTooltip.SetHyperlink
local CmdFormat = "|cFFFFEB3B|Hcommand:%s %s|h[%s]|h|r"
local Keywords = {}

Keywords.inv = true
Keywords.reinv = true
Keywords.invite = true
Keywords.reinvite = true
Keywords[gsub(SLASH_INVITE2, "/", "")] = true -- /inv
Keywords[gsub(SLASH_INVITE3, "/", "")] = true -- /invite

ItemRefTooltip.SetHyperlink = function(self, link, text, button, frame)
	if (sub(link, 1, 7) == "command") then
		local Box = ChatEdit_ChooseBoxForSend()

		Box:SetText("")

		if (not Box:IsShown()) then
			ChatEdit_ActivateChat(Box)
		else
			ChatEdit_UpdateHeader(Box)
		end

		Box:Insert(sub(link, 9))
		ChatEdit_ParseText(Box, 1)
	else
		SetHyperlink(self, link, text, button, frame)
	end
end

local FindInvites = function(self, event, msg, sender, ...)
	if (sender == Player) then
		return
	end

	local IsGuildInv = IsInGuild() and IsModifierKeyDown()

	for word in gmatch(msg, "(%w+)") do
		if Keywords[lower(word)] then
			if IsGuildInv then
				msg = gsub(lower(msg), lower(word), format(CmdFormat, SLASH_GUILD_INVITE1, sender, word))
			else
				msg = gsub(lower(msg), lower(word), format(CmdFormat, SLASH_INVITE1, sender, word))
			end

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