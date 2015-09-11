function winner(trigger)
    local player = trigger.activator
    local count = 1
    local most_lumber = 0
    local winning_team = 0
    local lumber_comparison = {}
    player:AddNewModifier(player,nil,"modifier_stunned",nil)
    player_tracker[player:GetTeam()][2] = 2
    for Index,Value in pairs(player_tracker) do
        DebugPrint("Player:",Index,player_tracker[Index][1],player_tracker[Index][2])
        count = player_tracker[Index][2] * count
    end
    if count == 0 then
        DebugPrint("The game continues!")
    else
        DebugPrint("The game is over!")
        for Index,Value in pairs(player_tracker) do
            if most_lumber < player_tracker[Index][1] and player_tracker[Index][2] > 1 then
                most_lumber = player_tracker[Index][1]
                winning_team = Index
                DebugPrint(winning_team,most_lumber)
            end
        end
        GameRules:SetGameWinner(winning_team)
    end
end