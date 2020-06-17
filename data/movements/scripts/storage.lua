local storage = Storage.InServiceofYalahar.Mission10
local storagevalue = 1
local text = ""

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if getPlayerStorageValue(cid, storage) <= 0 then
        setPlayerStorageValue(cid, storage, storagevalue)
        return true
    end

    doPlayerSendCancel(cid, text)
    doTeleportThing(cid, fromPosition)
end