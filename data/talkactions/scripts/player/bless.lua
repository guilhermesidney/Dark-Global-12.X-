function onSay(cid)
    local player = Player(cid)
    local totalBlessPrice = getBlessingsCost(player:getLevel()) * 5 * 0.5
    if player:getBlessings() == 5 then
        player:sendCancelMessage("You already have been blessed!", cid)
    elseif player:removeMoneyNpc(totalBlessPrice) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been blessed by all of eight gods!")
        for b = 1, 8 do
            if not player:hasBlessing(b) then
                player:addBlessing(b, 1)
            end
        end
        player:setStorageValue(999563, 1)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
    else
        player:sendCancelMessage("You don't have enough money. You need " .. totalBlessPrice .. " to buy bless.", cid)
    end

    return false
end