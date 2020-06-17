function onSay(player, words, param)
    local playersOnline = Game.getPlayers()
  
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, ( #playersOnline > 1 and "There are " .. #playersOnline .. " players online." or "You are the only player online."))

local tmp = {}
    if #playersOnline > 1 then
        local msg
        for i, p in ipairs(playersOnline) do
            tmp[i] = "[".. i .."] ".. p:getName() .. " [" .. p:getLevel() .. "]\n"
        end
        player:showTextDialog(1978, table.concat(tmp))
    end
    return true
end