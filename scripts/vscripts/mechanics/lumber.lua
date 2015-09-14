function LumberStacks( event )
    local caster = event.caster
    local player = caster:GetTeam()
    local ability = event.ability
    local caster_pos = caster:GetAbsOrigin()
    local radius = ability:GetLevelSpecialValueFor("radius", 0)
    local stacks = caster:GetModifierStackCount("modifier_lumber", caster)
    local trees = {}
    local count = 0
    
    trees = GridNav:GetAllTreesAroundPoint(caster_pos, radius, false)
    
    for Index, Value in pairs(trees) do
        count = count + 1
    end
    
    player_tracker[player]["lumber"] = player_tracker[player]["lumber"] + count
    
end