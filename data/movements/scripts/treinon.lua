function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Attack the Monk and you will win 1 of stamina every 2 minutes training here.')
	return true
end