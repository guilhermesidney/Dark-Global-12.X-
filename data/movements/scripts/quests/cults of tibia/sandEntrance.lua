function onStepIn(creature, item, position, fromPosition)

	local player = creature:getPlayer()

	if not player then
		return true
	end

	if (player:getStorageValue(Storage.CultsOfTibia.Life.Mission) > 100 and
	player:getStorageValue(Storage.CultsOfTibia.MotA.Mission)) > 100 then
	player:teleportTo(fromPosition)
	player:sendCancelMessage("You can't go there yet.")
	end

	return true
end
