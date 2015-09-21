function Deaggro( event )
    local beast = event.caster
    local beast_loc = beast:GetAbsOrigin()
    local beast_dir = beast:GetAnglesAsVector()
    local left = beast_dir.y + 90
    local right = beast_dir.y - 90
    if left >= 360 then
        left = left - 360
    end
    if right < 0 then
        right = right + 360
    end
    local detection_radius = beast_loc
    local beast_loc = beast:GetAbsOrigin()
    for i=0, 450, 10 do
        detection_radius.x = beast_loc.x + i * math.cos(math.rad(left))
        detection_radius.y = beast_loc.y + i * math.sin(math.rad(left))
        local shredder = Entities:FindByNameNearest("npc_dota_hero_shredder",detection_radius,300)
        if shredder ~= nil and shredder:IsAlive() == true then
            shredder:ForceKill(false)
            StartAnimation(beast, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1})
        end
    end
    local beast_loc = beast:GetAbsOrigin()
    for i=0, 450, 10 do
        detection_radius.x = beast_loc.x + i * math.cos(math.rad(right))
        detection_radius.y = beast_loc.y + i * math.sin(math.rad(right))
        local shredder = Entities:FindByNameNearest("npc_dota_hero_shredder",detection_radius,300)
        if shredder ~= nil and shredder:IsAlive() == true then
            shredder:ForceKill(false)
            StartAnimation(beast, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1})
        end
    end
end