function Deaggro( event )
    local beast = event.caster
    local beast_loc = beast:GetAbsOrigin()
    local shredder = Entities:FindByNameNearest("npc_dota_hero_shredder",beast_loc,600)
    if shredder ~= nil and shredder:IsAlive() == true then
        --shredder:ForceKill(false)
        StartAnimation(beast, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1})
    end
end