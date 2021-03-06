-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = true 

_G.player_tracker = {}
_G.player_tracker_discon = {}
_G.boss_unit = nil
  
if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(0, false)
  
  local player = hero:GetPlayerID()
  local team = hero:GetTeam()
  
  abil = hero:GetAbilityByIndex(0)
  hero:UpgradeAbility(abil)
  
  player_tracker[team] = {}
  
  player_tracker[team]["lumber"] = 0
  player_tracker[team]["status"] = 0
  player_tracker[team]["hero"] = hero
  player_tracker[team]["player"] = player
  player_tracker[team]["block"] = 0
  player_tracker[team]["checkpoint"] = 0

  SendToConsole("dota_camera_center")

  --hero:AddNewModifier(hero,nil,"modifier_stunned", nil)
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  

  local point = Entities:FindByName(nil,"start_of_line"):GetAbsOrigin()
  boss_unit = CreateUnitByName("npc_beast_unit", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
  local waypoint = Entities:FindByName(nil,"start_of_line")
  boss_unit:SetInitialGoalEntity(waypoint)
  
  local num_players = 0
  
  for Index,Value in pairs(player_tracker) do
    player_tracker[Index]["hero"]:RemoveModifierByName("modifier_stunned")
    num_players = num_players + 1
  end
  
    for Index,Value in pairs(player_tracker) do
        local hero = player_tracker[Index]["hero"]
        local ability_level = hero:GetAbilityByIndex(0):GetLevel()
        hero:RemoveAbility(hero:GetAbilityByIndex(0):GetAbilityName())
        if num_players == 1 then
            hero:AddAbility("cut_tree_1_player")
        end
        if num_players == 2 then
            hero:AddAbility("cut_tree_2_players")
        end
        if num_players == 3 then
            hero:AddAbility("cut_tree_3_players")
        end
        if num_players == 4 then
            hero:AddAbility("cut_tree_4_players")
        end
        if num_players == 5 then
            hero:AddAbility("cut_tree_5_players")
        end
        if num_players == 6 then
            hero:AddAbility("cut_tree_6_players")
        end
        if num_players == 7 then
            hero:AddAbility("cut_tree_7_players")
        end
        if num_players == 8 then
            hero:AddAbility("cut_tree_8_players")
        end
        hero:GetAbilityByIndex(0):SetLevel(ability_level)
    end
  
  _G.new_time = 0.25
  GameRules:SetTimeOfDay(new_time)

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
    
  Timers:CreateTimer(60,
    function()
        for Index,Value in pairs(player_tracker) do
            player_tracker[Index]["hero"]:HeroLevelUp(true)
        end
        if boss_unit:IsAlive() == true then
            local beast_ms = boss_unit:GetBaseMoveSpeed()
            boss_unit:SetBaseMoveSpeed(beast_ms + 12)
        end
        return 60
    end)
    
  Timers:CreateTimer(0.1,
    function()
        new_time = new_time + 0.5 / 600
        if new_time >= 1 then
            new_time = new_time - 1
        end
        GameRules:SetTimeOfDay( new_time )
        if new_time >= 0.75 or new_time < 0.25 then
            mode:SetFogOfWarDisabled(false)
            local most_lumber = 0
            local highest_lumber = 0
            local give_vision = {}
            local give_vision_hero = {}
            local remaining_teams = {}
            for Index,Value in pairs(player_tracker) do
                if most_lumber < player_tracker[Index]["lumber"] and player_tracker[Index]["status"] == 0 then
                    highest_lumber = player_tracker[Index]["lumber"]
                    most_lumber = player_tracker[Index]["lumber"]
                end
            end
            for Index,Value in pairs(player_tracker) do
                if highest_lumber <= player_tracker[Index]["lumber"] and player_tracker[Index]["status"] == 0 then
                    table.insert(give_vision,Index)
                    table.insert(give_vision_hero,player_tracker[Index]["hero"])
                    most_lumber = player_tracker[Index]["lumber"]
                end
            end
            for Index,Value in pairs(player_tracker) do
                for k,v in pairs(give_vision) do
                    if v ~= Index then
                        table.insert(remaining_teams, Index)
                    end
                end
            end
            for Index,Value in pairs(remaining_teams) do
                for k,v in pairs(give_vision_hero) do
                    if Value ~= v:GetTeam() then
                        AddFOWViewer(remaining_teams[Index],v:GetAbsOrigin(),500,0.1,false)
                    end
                end
            end
        else
            mode:SetFogOfWarDisabled(true)
        end
        return 0.1
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end