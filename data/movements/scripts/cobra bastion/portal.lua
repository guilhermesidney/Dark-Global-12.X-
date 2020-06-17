local config = {
	[65534] = Position(33384, 32627, 7),
	[65535] = Position(33314, 32647, 8)
}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local teleport = config[item.actionid]
	if teleport then
		player:teleportTo(teleport)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		teleport:sendMagicEffect(CONST_ME_TELEPORT)
	end
end