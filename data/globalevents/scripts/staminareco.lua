function onThink(pid, interval, lastExecution, thinkInterval)
	local refuel = 42 * 60 * 1000 -- full
	local add = 30000 -- 30 segundos
	for _, pid in ipairs(getPlayersOnline()) do
		if getTilePzInfo(getCreaturePosition(pid)) and getPlayerStamina(pid) < refuel then
			doPlayerSetStamina(pid, getPlayerStamina(pid) + add)
		end
	end
	return true 
end