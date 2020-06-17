function Player.sendTibiaTime(self, hours, minutes)
	local msg = NetworkMessage()
	msg:addByte(0xEF)
	msg:addByte(hours)
	msg:addByte(minutes)
	msg:sendToPlayer(self)
	msg:delete()
	return true
end

local function onMovementRemoveProtection(cid, oldPosition, time)
    local player = Player(cid)
    if not player then
        return true
    end

    local playerPosition = player:getPosition()
    if (playerPosition.x ~= oldPosition.x or playerPosition.y ~= oldPosition.y or playerPosition.z ~= oldPosition.z) or player:getTarget() then
        player:setStorageValue(Storage.combatProtectionStorage, 0)
        return true
    end

    addEvent(onMovementRemoveProtection, 1000, cid, oldPosition, time - 1)
end

function onLogin(player)
	local loginStr = 'Welcome to ' .. configManager.getString(configKeys.SERVER_NAME) .. '!'
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. ' Please choose your outfit.'
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format('Your last visit was on %s.', os.date('%a %b %d %X %Y', player:getLastLoginSaved()))
	end

    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

    local playerId = player:getId()

	DailyReward.init(playerId)

    player:loadSpecialStorage()

    --[[-- Maintenance mode
    if (player:getGroup():getId() < 2) then
        return false
    else

    end--]]

    if (player:getGroup():getId() >= 4) then
        player:setGhostMode(true)
    end

    -- Stamina
    nextUseStaminaTime[playerId] = 1

    -- EXP Stamina
    nextUseXpStamina[playerId] = 1

	-- Prey Small Window
	if player:getClient().version > 1110 then
		for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
			player:sendPreyData(slot)
		end
	end	 

    -- Free bless
    local freeBless = {
        level = 80,
        blesses = {1, 2, 3, 4, 5}
    }

    if player:getLevel() <= freeBless.level then
        for i=1, #freeBless.blesses do
            player:addBlessing(freeBless.blesses[i])
        end
    end

    -- New Prey
    nextPreyTime[playerId] = {
        [CONST_PREY_SLOT_FIRST] = 1,
        [CONST_PREY_SLOT_SECOND] = 1,
        [CONST_PREY_SLOT_THIRD] = 1
    }

    if (player:getAccountType() == ACCOUNT_TYPE_TUTOR) then
        local msg = [[:: Tutor Rules
            1 *> 3 Warnings you lose the job.
            2 *> Without parallel conversations with players in Help, if the player starts offending, you simply mute it.
            3 *> Be educated with the players in Help and especially in the Private, try to help as much as possible.
            4 *> Always be on time, if you do not have a justification you will be removed from the staff.
            5 *> Help is only allowed to ask questions related to tibia.
            6 *> It is not allowed to divulge time up or to help in quest.
            7 *> You are not allowed to sell items in the Help.
            8 *> If the player encounters a bug, ask to go to the website to send a ticket and explain in detail.
            9 *> Always keep the Tutors Chat open. (required).
            10 *> You have finished your schedule, you have no tutor online, you communicate with some CM in-game or ts and stay in the help until someone logs in, if you can.
            11 *> Always keep a good Portuguese in the Help, we want tutors who support, not that they speak a satanic ritual.
            12 *> If you see a tutor doing something that violates the rules, take a print and send it to your superiors. "
            - Commands -
            Mute Player: / mute nick, 90. (90 seconds)
            Unmute Player: / unmute nick.
            - Commands -]]
        player:popupFYI(msg)
    end

 	-- OPEN CHANNELS
	if table.contains({"Rookgaard", "Dawnport"}, player:getTown():getName())then
		player:openChannel(3) -- world chat
		player:openChannel(6) -- advertsing rook main
	else
		player:openChannel(3) -- world chat
		player:openChannel(5) -- advertsing main
	end

    -- Rewards
    local rewards = #player:getRewardList()
    if(rewards > 0) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You have %d %s in your reward chest.", rewards, rewards > 1 and "rewards" or "reward"))
    end

    -- Update player id
    local stats = player:inBossFight()
    if stats then
        stats.playerId = player:getId()
    end

 	if player:getStorageValue(Storage.combatProtectionStorage) < 1 then
        player:setStorageValue(Storage.combatProtectionStorage, 1)
        onMovementRemoveProtection(playerId, player:getPosition(), 10)
        player:setStorageValue(Storage.WrathoftheEmperor.Questline, 10)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission01, 3)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission02, 3)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission03, 3)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission04, 3)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission05, 3)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission06, 4)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission07, 6)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission08, 2)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 2)
        player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 6)
        player:setStorageValue(Storage.WrathoftheEmperor.CrateStatus, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.GuardcaughtYou, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.ZumtahStatus, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest01, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest02, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest03, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion, 1)
        player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.Questline, 53)
        player:setStorageValue(Storage.InServiceofYalahar.Mission01, 6)
        player:setStorageValue(Storage.InServiceofYalahar.Mission02, 8)
        player:setStorageValue(Storage.InServiceofYalahar.Mission03, 6)
        player:setStorageValue(Storage.InServiceofYalahar.Mission04, 6)
        player:setStorageValue(Storage.InServiceofYalahar.Mission05, 8)
        player:setStorageValue(Storage.InServiceofYalahar.Mission06, 5)
        player:setStorageValue(Storage.InServiceofYalahar.Mission07, 5)
        player:setStorageValue(Storage.InServiceofYalahar.Mission08, 4)
        player:setStorageValue(Storage.InServiceofYalahar.Mission09, 2)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedDan, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedBill, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedFred, 1)
        player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 1)
        player:setStorageValue(Storage.InServiceofYalahar.BadSide, 1)
        player:setStorageValue(Storage.InServiceofYalahar.GoodSide , 1)
        player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MorikSummon, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraSplasher, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraSharptooth, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraInky, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MatrixState, 1)
        player:setStorageValue(Storage.InServiceofYalahar.NotesPalimuth, 1)
        player:setStorageValue(Storage.InServiceofYalahar.NotesAzerus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DoorToAzerus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DoorToBog, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DoorToLastFight, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DoorToMatrix, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DoorToQuara, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
        player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedDan, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedBill, 1)
        player:setStorageValue(Storage.InServiceofYalahar.DiseasedFred, 1)
        player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 1)
        player:setStorageValue(Storage.InServiceofYalahar.BadSide, 1)
        player:setStorageValue(Storage.InServiceofYalahar.GoodSide, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 1)
        player:setStorageValue(Storage.InServiceofYalahar.MorikSummon, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraSplasher, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraSharptooth, 1)
        player:setStorageValue(Storage.InServiceofYalahar.QuaraInky, 1)
        player:setStorageValue(Storage.postman.Mission01, 6)
        player:setStorageValue(Storage.postman.Mission02, 3)
        player:setStorageValue(Storage.postman.Mission03, 3)
        player:setStorageValue(Storage.postman.Mission04, 2)
        player:setStorageValue(Storage.postman.Mission05, 4)
        player:setStorageValue(Storage.postman.Mission06, 13)
        player:setStorageValue(Storage.postman.Mission07, 8)
        player:setStorageValue(Storage.postman.Mission08, 3)
        player:setStorageValue(Storage.postman.Mission09, 4)
        player:setStorageValue(Storage.postman.Mission10, 3)
        player:setStorageValue(Storage.postman.Door, 1)
	player:setStorageValue(Storage.TheInquisition.Questline, 25)
	player:setStorageValue(Storage.TheInquisition.Mission01, 7)
	player:setStorageValue(Storage.TheInquisition.Mission02, 3)
	player:setStorageValue(Storage.TheInquisition.Mission03, 6)
	player:setStorageValue(Storage.TheInquisition.Mission04, 3)
	player:setStorageValue(Storage.TheInquisition.Mission05, 3)
	player:setStorageValue(Storage.TheInquisition.Mission06, 3)
	player:setStorageValue(Storage.TheInquisition.Mission07, 1)
	player:setStorageValue(Storage.TheInquisition.GrofGuard, 1)
	player:setStorageValue(Storage.TheInquisition.KulagGuard, 1)
	player:setStorageValue(Storage.TheInquisition.TimGuard, 1)
	player:setStorageValue(Storage.TheInquisition.WalterGuard, 1)
	player:setStorageValue(Storage.TheInquisition.StorkusVampiredust, 1)
	player:setStorageValue(Storage.TheNewFrontier.Questline, 28)
	player:setStorageValue(Storage.TheNewFrontier.Mission01, 3)
	player:setStorageValue(Storage.TheNewFrontier.Mission02, 6)
	player:setStorageValue(Storage.TheNewFrontier.Mission03, 3)
	player:setStorageValue(Storage.TheNewFrontier.Mission04, 2)
	player:setStorageValue(Storage.TheNewFrontier.Mission05, 7)
	player:setStorageValue(Storage.TheNewFrontier.Mission06, 3)
	player:setStorageValue(Storage.TheNewFrontier.Mission07, 3)
	player:setStorageValue(Storage.TheNewFrontier.Mission08, 2)
	player:setStorageValue(Storage.TheNewFrontier.Mission09, 3)
	player:setStorageValue(Storage.TheNewFrontier.Mission10, 1)
	player:setStorageValue(Storage.TheNewFrontier.TomeofKnowledge, 12)
	player:setStorageValue(Storage.TheNewFrontier.Beaver1, 1)
	player:setStorageValue(Storage.TheNewFrontier.Beaver2, 1)
	player:setStorageValue(Storage.TheNewFrontier.Beaver3, 1)
	player:setStorageValue(Storage.TheNewFrontier.BribeKing, 1)
	player:setStorageValue(Storage.TheNewFrontier.BribeLeeland, 1)
	player:setStorageValue(Storage.TheNewFrontier.BribeExplorerSociety, 1)
	player:setStorageValue(Storage.TheNewFrontier.BribeWydrin, 1)
	player:setStorageValue(Storage.TheNewFrontier.BribeTelas, 1)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Questline, 21)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission00, 2)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission01, 3)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission02, 5)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission03, 3)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission04, 6)
	player:setStorageValue(Storage.ChildrenoftheRevolution.Mission05, 3)
	player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding01, 1)
	player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding02, 1)
	player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding03, 1)
	player:setStorageValue(Storage.ChildrenoftheRevolution.StrangeSymbols, 1)
        player:setStorageValue(Storage.TheShatteredIsles.DefaultStart, 3)
        player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 3)
        player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 2)
        player:setStorageValue(Storage.TheShatteredIsles.AccessToMeriana, 1)
        player:setStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid, 3)
        player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 5)
        player:setStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland, 1)
        player:setStorageValue(Storage.TheShatteredIsles.AccessToGoroma, 1)
        player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 2)
        player:setStorageValue(Storage.TheShatteredIsles.DragahsSpellbook, 1)
        player:setStorageValue(Storage.TheShatteredIsles.TheCounterspell, 4)
        player:setStorageValue(Storage.DjinnWar.EfreetFaction.Start, 3)
        player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3)
        player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 3)
        player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission03, 3)
        player:setStorageValue(Storage.DjinnWar.MaridFaction.Start, 4)
        player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 2)
        player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission02, 2)
        player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 2)
        player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 3)
        player:setStorageValue(Storage.Factions, 1)
        player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 2)
        player:setStorageValue(Storage.DjinnWar.Faction.Marid, 2)
        player:setStorageValue(Storage.TheWayToYalahar.Questline, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.TownsCounter, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.AbDendriel, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.Darashia, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.Venore, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.Ankrahmun, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.PortHope, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.Thais, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.LibertyBay, 1)
        player:setStorageValue(Storage.SearoutesAroundYalahar.Carlin, 1)
        player:setStorageValue(Storage.BigfootBurden.QuestLine, 30)
        player:setStorageValue(Storage.BigfootBurden.QuestLineComplete, 2)
        player:setStorageValue(Storage.BigfootBurden.Rank, 1440)
        player:setStorageValue(Storage.BigfootBurden.WarzoneStatus, 1)
        player:setStorageValue(Storage.BigfootBurden.Warzone1Access, 2)
        player:setStorageValue(Storage.BigfootBurden.Warzone2Access, 2)
        player:setStorageValue(Storage.BigfootBurden.Warzone3Access, 2)
        player:setStorageValue(Storage.DangerousDepths.Scouts.Status, 15)
        player:setStorageValue(Storage.DangerousDepths.Acessos.LavaPumpWarzoneVI, 1)
        player:setStorageValue(Storage.DangerousDepths.Acessos.TimerWarzoneVI, 1)
        player:setStorageValue(Storage.DangerousDepths.Acessos.LavaPumpWarzoneV, 1)
        player:setStorageValue(Storage.DangerousDepths.Acessos.TimerWarzoneV, 1)
        player:setStorageValue(Storage.DangerousDepths.Acessos.LavaPumpWarzoneIV, 1)
        player:setStorageValue(Storage.DangerousDepths.Acessos.TimerWarzoneIV, 1)
        player:setStorageValue(Storage.ExplorerSociety.QuestLine, 61)
        player:setStorageValue(Storage.ExplorerSociety.CalassaQuest, 2)
        player:setStorageValue(Storage.ForgottenKnowledge.Tomes, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.LadyTenebrisKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.LloydKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.ThornKnightKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.DragonkingKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.HorrorKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.TimeGuardianKilled, 1522018605)
        player:setStorageValue(Storage.ForgottenKnowledge.LastLoreKilled, 1522018605)	
        player:setStorageValue(Storage.ForgottenKnowledge.AccessDeath, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessViolet, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessEarth, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessFire, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessIce, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessGolden, 1)
        player:setStorageValue(Storage.ForgottenKnowledge.AccessLast, 1)
        player:setStorageValue(Storage.TheIceIslands.Questline, 12)
	player:setStorageValue(Storage.TheIceIslands.Mission01, 3)
	player:setStorageValue(Storage.TheIceIslands.Mission02, 5)
	player:setStorageValue(Storage.TheIceIslands.Mission03, 3)
	player:setStorageValue(Storage.TheIceIslands.Mission04, 2)
	player:setStorageValue(Storage.TheIceIslands.Mission05, 6)
	player:setStorageValue(Storage.TheIceIslands.Mission06, 8)
	player:setStorageValue(Storage.TheIceIslands.Mission07, 3)
	player:setStorageValue(Storage.TheIceIslands.Mission08, 4)
	player:setStorageValue(Storage.TheIceIslands.Mission09, 2)
	player:setStorageValue(Storage.TheIceIslands.Mission10, 2)
	player:setStorageValue(Storage.TheIceIslands.Mission11, 2)
	player:setStorageValue(Storage.TheIceIslands.Mission12, 6)
	player:setStorageValue(Storage.WhiteRavenMonasteryQuest.QuestLog, 2)
	player:setStorageValue(Storage.WhiteRavenMonasteryQuest.Passage, 1)
	player:setStorageValue(Storage.WhiteRavenMonasteryQuest.Diary, 2)
	player:setStorageValue(Storage.CultsOfTibia.Questline, 7)
	player:setStorageValue(Storage.CultsOfTibia.Minotaurs.jamesfrancisTask, 1)
	player:setStorageValue(Storage.CultsOfTibia.Minotaurs.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Minotaurs.bossTimer, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra1, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra2, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra3, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Respostas, 1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Perguntaid, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.sulphur, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.tar, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.ice, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.Objects, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.Temp, 1)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.bossTimer, 1)
	player:setStorageValue(Storage.CultsOfTibia.Orcs.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Orcs.lookType, 1)
	player:setStorageValue(Storage.CultsOfTibia.Orcs.bossTimer, 1)
	player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Life.bossTimer, 1)
	player:setStorageValue(Storage.CultsOfTibia.Humans.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Humans.Vaporized, 1)
	player:setStorageValue(Storage.CultsOfTibia.Humans.Decaying, 1)
	player:setStorageValue(Storage.CultsOfTibia.Humans.bossTimer, 1)
	player:setStorageValue(Storage.CultsOfTibia.Misguided.Mission, 1)
	player:setStorageValue(Storage.CultsOfTibia.Misguided.Monsters, 1)
	player:setStorageValue(Storage.CultsOfTibia.Misguided.Exorcisms, 1)
	player:setStorageValue(Storage.CultsOfTibia.Misguided.Time, 1)
	player:setStorageValue(Storage.CultsOfTibia.Misguided.bossTimer, 1)
	player:setStorageValue(Storage.FriendsandTraders.DefaultStart, 1)
	player:setStorageValue(Storage.FriendsandTraders.TheBlessedStake, 12)
	end

	-- Set Client XP Gain Rate
	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		displayRate = Game.getExperienceStage(player:getLevel())
		else
		displayRate = 1
	end
	local staminaMinutes = player:getStamina()
	local storeBoost = player:getExpBoostStamina()
	player:setStoreXpBoost(storeBoost > 0 and 50 or 0)
	if staminaMinutes > 2400 and player:isPremium() and storeBoost > 0 then
		player:setBaseXpGain(displayRate*2*100) -- Premium + Stamina boost + Store boost
		player:setStaminaXpBoost(150)
	elseif staminaMinutes > 2400 and player:isPremium() and storeBoost <= 0 then
		player:setBaseXpGain(displayRate*1.5*100) -- Premium + Stamina boost
		player:setStaminaXpBoost(150)
	elseif staminaMinutes <= 2400 and staminaMinutes > 840 and player:isPremium() and storeBoost > 0 then
		player:setBaseXpGain(displayRate*1.5*100) -- Premium + Store boost
		player:setStaminaXpBoost(100)
	elseif staminaMinutes > 840 and storeBoost > 0 then
		player:setBaseXpGain(displayRate*1.5*100) -- FACC + Store boost
		player:setStaminaXpBoost(100)
	elseif staminaMinutes <= 840 and storeBoost > 0 then
		player:setBaseXpGain(displayRate*1*100) -- ALL players low stamina + Store boost
		player:setStaminaXpBoost(50)
	elseif staminaMinutes <= 840 then
		player:setBaseXpGain(displayRate*0.5*100) -- ALL players low stamina
		player:setStaminaXpBoost(50)
	end

	if player:getClient().version > 1110 then
		local worldTime = getWorldTime()
		local hours = math.floor(worldTime / 60)
		local minutes = worldTime % 60
		player:sendTibiaTime(hours, minutes)
	end
	
	if player:getStorageValue(Storage.isTraining) == 1 then -- redefinir storage de exercise weapon
		player:setStorageValue(Storage.isTraining,0)
	end
 	
    if player:getStorageValue(Storage.combatProtectionStorage) <= os.time() then
        player:setStorageValue(Storage.combatProtectionStorage, os.time() + 10)
        onMovementRemoveProtection(playerId, player:getPosition(), 10)
    end
    return true
end