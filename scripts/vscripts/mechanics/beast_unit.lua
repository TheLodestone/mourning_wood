function Deaggro( event )
    local beast = event.caster
    local shredder = Entities:FindByNameNearest("npc_dota_hero_shredder",beast:GetAbsOrigin(),350)
    if shredder ~= nil and shredder:IsAlive() == true then
        shredder:ForceKill(false)
        StartAnimation(beast, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1})
    end
end