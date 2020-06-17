local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
    
    local msg = string.lower(msg)
    local item = 15515 -- ID do token
    
    local t = { 
        
        ["golden helmet"] = {100, 2471, 1},
        ["gold token"] = {50, 25377, 1}, 	
        ["silver token"] = {30, 25172, 1}, 	
        ["assassin doll"] = {300, 32594, 1},	-- ["Nome do item"] = {Qnt de tokens, ID do item a ser vendido, Count do item que será vendido}
        ["blessed shield"] = {100, 2523, 1}
        
    }
    
    if(msgcontains(msg, 'itens')) then
        
        local str = ""
        str = str .. "I can trade these items: "
        for name, pos in pairs(t) do
            str = str.." {"..name.."} for "..pos[1].." Bar of Gold, "
        end
        str = str .. "."
        npcHandler:say(str, cid)
    elseif t[msg] then
        if doPlayerRemoveItem(cid, item, t[msg][1]) then
            doPlayerAddItem(cid, t[msg][2], t[msg][3])
            selfSay("Thank you!! now I can brag to my friends, hehe.", cid)
        else
            selfSay("I only change if you have ".. t[msg][1] .." Bar of Gold!", cid)
        end
    end
    return true
end 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())