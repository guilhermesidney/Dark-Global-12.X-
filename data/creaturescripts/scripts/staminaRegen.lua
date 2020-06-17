local staminaBonus = {
		period = 60000, -- 1 "min"
		bonus = 3, -- gain stamina per min
		events ={}
	{
function onLogin(player)
	if not getTileInfo(getThingPos(cid)).protection then
		staminaBonus.events[name] = nil
		doPlayerSendCancel(cid, "Sua stamina vai se recuperar no pz")
		 else
	            player:setStamina(player:getStamina() + staminaBonus.bonus)
            staminaBonus.events[name] = addEvent(staminaBonus.period, name)
				end
			end
		end
	end