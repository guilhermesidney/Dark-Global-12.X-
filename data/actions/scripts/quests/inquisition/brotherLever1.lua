function onUse(cid, item, fromPosition, item2, toPosition)

local teleport = {x=32320, y=32259, z=9} -- Coordenadas para onde o player irá ser teleportado.

doTeleportThing(cid, teleport)

doSendMagicEffect(getPlayerPosition(cid), 10)

doPlayerSendTextMessage(cid, 22, "Teleportado!") -- configure a msg que quiser, se n quiser msg apague esta linha.

end