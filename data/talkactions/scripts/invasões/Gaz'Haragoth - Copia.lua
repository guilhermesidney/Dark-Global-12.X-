-- 1º script de invasao de Subwat--
function onSay(cid, words, param)
monstro = "devovorga" -- Nome Do Boss Que Será Sumonado.
monstro2 = "ghoul" -- Nome Do Monstro Que Será Sumonado.



pos1 = {x=457, y=263, z=7} -- Posição QUe o Boss Será Sumonado.
pos2 = {x=457, y=263, z=7} -- Posição QUe o Monstro Será Sumonado.
pos3 = {x=457, y=263, z=7} -- Posição QUe o Monstro Será Sumonado.
pos4 = {x=457, y=263, z=7} -- Posição QUe o Monstro Será Sumonado.
pos5 = {x=457, y=263, z=7} -- Posição QUe o Monstro Será Sumonado.
pos6 = {x=457, y=263, z=7} -- Posição QUe o Monstro Será Sumonado.


if getPlayerAccess(cid) >= 1 then --Gods apenas Usam o comando.
doSummonCreature(monstro, pos1)
doSummonCreature(monstro2, pos2)
doSummonCreature(monstro2, pos3)
doSummonCreature(monstro2, pos4)
doSummonCreature(monstro2, pos5)
doSummonCreature(monstro2, pos6)

broadcastMessage("An unknown evil is dwelling deep under Vengoth and strange portals have appeared all over the world...", MESSAGE_EVENT_ADVANCE)
broadcastMessage("The power of Devovorga has risen again.", MESSAGE_EVENT_ADVANCE)

end
end