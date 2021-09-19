if (not HydraUIGlobal) then
	return
end

local HydraUI = HydraUIGlobal:get()
local Player = UnitName("player") .. "-" .. GetRealmName()

local gsub = string.gsub
local lower = string.lower
local format = string.format
local gmatch = string.gmatch

local Keywords = {
	["reinvite"] = true,
	["invite"] = true,
	["inv"] = true,
}

local FindInvites = function(self, event, msg, sender, ...)
	if (sender == Player) then
		return
	end

	for word in gmatch(msg, "(%w+)") do
		if Keywords[word] then
			msg = gsub(lower(msg), word, format("|cFFFFEB3B|Hcommand:/invite %s|h[%s]|h|r", sender, word))

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

HydraUI:NewPlugin("HydraUI_InviteLinks")