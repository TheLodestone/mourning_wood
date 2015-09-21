function checkpoint_trigger(trigger)
    local player = trigger.activator
    local team = player:GetTeam()
    local checkpoint = 0
    local checkpoint_check = 1
    local checkpoint_check_player = 0
    local checkpoint_name = trigger.caller:GetName()
    
    player:AddNewModifier(player,nil,"modifier_stunned", nil)
    
    player_tracker[team]["checkpoint"] = 1
    
    for Index,Value in pairs(player_tracker) do
        if player_tracker[Index]["status"] == 1 then
            checkpoint_check_player = 1
        elseif player_tracker[Index]["checkpoint"] == 1 then
            checkpoint_check_player = 1
        else
            checkpoint_check_player = 0
        end
        checkpoint_check = checkpoint_check_player * checkpoint_check
    end
    
    if checkpoint_check ~= 0 then
        checkpoint = 1
    end
    
    if checkpoint == 1 then
        for Index,Value in pairs(player_tracker) do
            local hero = player_tracker[Index]["hero"]
            player = player_tracker[Index]["player"]
            local respawn_point = Entities:FindByName(nil,checkpoint_name .. "_player" .. player):GetAbsOrigin()
            if player_tracker[Index]["status"] == 1 then
                hero:RespawnHero(false,false,false)
            end
            FindClearSpaceForUnit(hero, respawn_point, false)
            hero:AddNewModifier(hero,nil,"modifier_stunned", nil)
        end
    end
end