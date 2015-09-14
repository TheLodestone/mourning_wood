function rocket_boost( event )
    local caster = event.caster
    local caster_pos = caster:GetAbsOrigin()
    local team = caster:GetTeam()
    local caster_pos_update = caster_pos + player_tracker[team]["direction"] * player_tracker[team]["dist_interval"]
    local caster_pos_update_ground = GetGroundPosition(caster_pos_update,caster)
    if player_tracker[team]["block"] == 0 then
        caster:SetAbsOrigin(caster_pos_update_ground)
    end
end

function rocket_boost_start( event )
    local point = event.target_points[1]
    local ability = event.ability
    local caster = event.caster
    local caster_pos = caster:GetAbsOrigin()
    local distance = ability:GetLevelSpecialValueFor("distance", 0)
    local over_time = ability:GetLevelSpecialValueFor("over_time", 0)
    local difference = point - caster_pos
    local interval = over_time/0.01
    local distance_interval = distance/interval
    local direction = difference:Normalized()
    direction.z = 0
    local team = caster:GetTeam()
    local caster_pos_final = caster_pos + direction * distance
    
    player_tracker[team]["block"] = 0
    player_tracker[team]["direction"] = direction
    player_tracker[team]["dist_interval"] = distance_interval
end

function rocket_boost_end ( event )
    local caster = event.caster
    local caster_pos = caster:GetAbsOrigin()
    FindClearSpaceForUnit(caster,caster_pos,true)
end

function barrier_block ( trigger )
    player = trigger.activator
    team = player:GetTeam()
    player_pos = player:GetAbsOrigin()
    player_tracker[team]["block"] = 1
    player:SetAbsOrigin(player_pos + player_tracker[team]["direction"] * -100)
end