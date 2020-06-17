configExf = {
     Area_Arena = {{x = 31825, y = 32479, z = 7}, {x = 31873, y = 32525, z = 7}},
	 arena = {x = 31860, y = 32516, z = 7},
     teleportPos = {32365, 32498, 6},
	 teleportPla = {32365, 32498, 6},
	 stats = 201201180701,
	 timetostart = 1,
	 prize = 6571,
	 templepos = {32369,  32241,  7},
	 randpos = {{31848, 32506, 7},{31857, 32505, 7},{31862, 32499, 7},{31852, 32494, 7},{31857, 32490, 7},{31865, 32486, 7},{31868, 32484, 7},{31846, 32483, 7},{31835, 32486, 7},{31830, 32490, 7},{31836, 32502, 7},{31839, 32494, 7},{31855, 32510, 7},{31859, 32510, 7},{31863, 32510, 7},{31834, 32502, 7}}
}
local TELEPORT_POSITION = Position{32365, 32498, 6}
local TELEPORT_ACTIONID = 19027
local TELEPORT_ITEMID = 1387


function doStartExf()
	Game.broadcastMessage("Teleport for Enchanted Forest Event was created in Event Room.", MESSAGE_STATUS_WARNING)
	local tp = Game.createItem(TELEPORT_ITEMID, 1, TELEPORT_POSITION)
	if not tp then
		error("Nao foi possivel criar o teleport na posicao especificada.")
	end
	tp:setActionId(TELEPORT_ACTIONID)
	setGlobalStorageValue(configExf.stats, 0)
    Game.broadcastMessage("The Exchanted Forest event will start in " .. configExf.timetostart .. " seconds.", MESSAGE_STATUS_WARNING)
    addEvent(doInitExf, configExf.timetostart*1000)
	end
	
function doInitExf()

if getGlobalStorageValue(configExf.stats) == 0 then
	Game.broadcastMessage("The Exchanted Forest event is starting...", MESSAGE_STATUS_WARNING)
	setGlobalStorageValue(configExf.stats, 1)
end

end

function doCloseExf()

setGlobalStorageValue(configExf.stats, -1)
	local tp = Game.removeItem(TELEPORT_ITEMID, 1, TELEPORT_POSITION)
	if not tp then
		error("Nao foi possivel remover o teleport na posicao especificada.")
	end

doCleanExfRoom()
end

function doCleanExfRoom()

	local pos = player:getPosition()

	if pos.z == configExf.Area_Arena[1].z then
		if pos.x >= configExf.Area_Arena[1].x and pos.y >= configExf.Area_Arena[1].y then
			if pos.x <= configExf.Area_Arena[2].x and pos.y <= configExf.Area_Arena[2].y then
			Player(players):teleportTo(Player(players):getTown():getTemplePosition())
				return true
			end
		end
	end
	return false
end