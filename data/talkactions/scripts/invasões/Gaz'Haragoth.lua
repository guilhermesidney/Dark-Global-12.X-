-- 1� script de invasao de Subwat--
function onSay(cid, words, param)
monstro = "Gaz'Haragoth" -- Nome Do Boss Que Ser� Sumonado.



pos1 = {x=33537, y=32380, z=12} -- Posi��o QUe o Boss Ser� Sumonado.


if getPlayerAccess(cid) >= 1 then --Gods apenas Usam o comando.
doSummonCreature(monstro, pos1)

broadcastMessage("Gaz'haragoth will shatter your dreams in a barrage of nightmares!", MESSAGE_EVENT_ADVANCE)

end
end