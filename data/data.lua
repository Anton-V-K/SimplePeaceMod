require("lib/config")
require("lib/helpers")

require("prototypes/recipe")

if enemiesSpawn==false then
    -- Disable the enemies at start and during chunk generation
    for index, unitspawner in pairs(data.raw["unit-spawner"]) do
        if unitspawner.autoplace.force == "enemy" then
            unitspawner.autoplace = null
        end
    end
    for index, turret in pairs(data.raw["turret"]) do
        if turret.autoplace.force == "enemy" then
            turret.autoplace = null
        end
    end

    -- Make sure no enemy will evolve or spawn (not sure if needed but just in case)
    data.raw["map-settings"]["map-settings"].enemy_evolution.enabled = false;
    data.raw["map-settings"]["map-settings"].enemy_expansion.enabled = false;

    -- Remove enemy options from map generator dialog
    -- data.raw["autoplace-control"]["enemy-base"] = null
end

if removeMilitaryTech==true then
    -- You can also tune technologies at game time:
    -- game.force.technologies["technology-name"].researched = true
    -- (c) https://forums.factorio.com/viewtopic.php?t=29728#p188294

    for i=1,6 do
        data.raw["technology"]["cannon-shell-damage-" .. i] = null
    end
    for i=1,5 do
        data.raw["technology"]["cannon-shell-speed-" .. i] = null
    end
    for i=1,6 do
        data.raw["technology"]["combat-robot-damage-" .. i] = null
    end
    for i=1,7 do
        data.raw["technology"]["grenade-damage-" .. i] = null
    end
    for i=1,7 do
        data.raw["technology"]["flamethrower-damage-" .. i] = null
    end
    for i=1,7 do
        data.raw["technology"]["gun-turret-damage-" .. i] = null
    end
    for i=1,7 do
        data.raw["technology"]["rocket-damage-" .. i] = null
    end
    --[[ 'rocket-speed-5' is needed for 'rocket-silo'
    for i=1,7 do
        data.raw["technology"]["rocket-speed-" .. i] = null
    end
    ]]
    data.raw["technology"]["artillery-shell-range-1"] = null
    data.raw["technology"]["artillery-shell-speed-1"] = null
    data.raw["technology"]["atomic-bomb"] = null
    data.raw["technology"]["battery-equipment"] = null
    data.raw["technology"]["battery-mk2-equipment"] = null
    data.raw["technology"]["cliff-explosives"] = null
    data.raw["technology"]["cluster-grenade"] = null
    data.raw["technology"]["discharge-defense-equipment"] = null
    -- data.raw["technology"]["fusion-reactor-equipment"] = null -- needed since 1.0
    data.raw["technology"]["night-vision-equipment"] = null
    data.raw["technology"]["personal-laser-defense-equipment"] = null
    data.raw["technology"]["personal-roboport-equipment-2"] = null
    data.raw["technology"]["power-armor-2"] = null
    -- data.raw["technology"]["rocketry"] = null
    
    RemoveRecipe("basic-bullet-magazine")
    RemoveRecipe("firearm-magazine", true) -- Required for First steps / Level 03
    RemoveRecipe("explosives", true)
    RemoveRecipe("grenade", true)                   -- Required for loading pre-mod saves
    RemoveRecipe("light-armor", true) -- First steps / Level 03
    RemoveRecipe("piercing-bullet-magazine")
    RemoveRecipe("piercing-rounds-magazine", true)  -- Required for loading pre-mod saves
    RemoveRecipe("pistol", true) -- Required for First steps / Level 03
    RemoveRecipe("poison-capsule")
    RemoveRecipe("rocket")
    RemoveRecipe("shotgun")
    RemoveRecipe("shotgun-shell")
    RemoveRecipe("slowdown-capsule")
    RemoveRecipe("rocket-launcher")
    RemoveRecipe("submachine-gun", true) -- Required for New hope / Level 03..04
    RemoveRecipe("uranium-ammo", true)              -- Required for loading pre-mod saves

    -- Some technologies are just hidden for standard campaign's level + other mods to work
    RemoveTech("artillery", true)                           -- for Aircraft mod
    for i=1,7 do
        RemoveTech("bullet-damage-" .. i, true) -- 'bullet-damage-1' is required for New hope / Level 01..03
    end
    for i=1,6 do
        RemoveTech("bullet-speed-" .. i, true) -- 'bullet-speed-3' is required for New hope / Level 04
    end
    RemoveTech("combat-robotics", true) -- Required for New hope / Level 03
    RemoveTech("combat-robotics-2", true)
    RemoveTech("combat-robotics-3", true) -- Required for New hope / Level 04
    RemoveTech("energy-shield-equipment", true) -- for Aircraft mod
    RemoveTech("energy-shield-mk2-equipment", true) -- for Aircraft mod
    RemoveTech("exoskeleton-equipment", true)               -- 0.17.x
    RemoveTech("explosive-rocketry", true)                  -- for Aircraft mod
    RemoveTech("flamethrower", true)
    for i=1,7 do
        RemoveTech("follower-robot-count-" .. i, true) -- follower-robot-count-4 is required for New hope / Level 04
    end
    RemoveTech("heavy-armor", true)
    RemoveTech("laser", true)
    for i=1,8 do
        RemoveTech("laser-turret-damage-" .. i, true) -- laser-turret-damage-1 is required for New hope / Level 04
    end
    for i=1,7 do
        RemoveTech("laser-turret-speed-" .. i, true) -- laser-turret-speed-1 is required for New hope / Level 04
    end
    RemoveTech("laser-turrets", true) -- Required for New hope / Level 04
    RemoveTech("land-mine", true) -- Required for New hope / Level 04
    --RemoveTech("military", true) -- Required for New hope / Level 01 + rockets
    --RemoveTech("military-2", true) -- Required for New hope / Level 01 and 'flamethrower' + rockets
    RemoveTech("military-3", true) -- Required for New hope / Level 04
    RemoveTech("military-4", true) -- Required for New hope / Level 04
    RemoveTech("modular-armor", true) -- for Aircraft mod
    RemoveTech("personal-roboport-equipment", true)         -- 0.17.x
    RemoveTech("power-armor", true)                         -- 0.17.x
    for i=1,7 do
        RemoveTech("shotgun-shell-damage-" .. i, true) -- Required for New hope / Level 04
    end
    for i=1,6 do
        RemoveTech("shotgun-shell-speed-" .. i, true) -- Required for New hope / Level 04
    end
    RemoveTech("solar-panel-equipment", true)               -- 0.17.x
    RemoveTech("tanks", true) -- for Aircraft mod
    RemoveTech("turrets", true)
    RemoveTech("uranium-ammo", true)

    --[[
    for index, prerequisite in pairs(data.raw["technology"]["military-3"].prerequisites) do
        if prerequisite == "laser" then
            data.raw["technology"]["military-3"].prerequisites[index] = null
        end
    end
    ]]

--[[
    -- Allow 'gates' without 'military-2'
    for index, prerequisite in pairs(data.raw["technology"]["gates"].prerequisites) do
        if prerequisite == "military-2" then
            data.raw["technology"]["gates"].prerequisites[index] = null
        end
    end
]]
--[[
    -- Allow 'explosives' without 'military-2' (https://stable.wiki.factorio.com/Explosives)
    for index, prerequisite in pairs(data.raw["technology"]["explosives"].prerequisites) do
        if prerequisite == "military-2" then
            data.raw["technology"]["explosives"].prerequisites[index] = null
        end
    end
]]
--[[
    -- Allow 'rocketry' without 'military-2'
    for index, prerequisite in pairs(data.raw["technology"]["rocketry"].prerequisites) do
        if prerequisite == "military-2" then
            data.raw["technology"]["rocketry"].prerequisites[index] = null
        end
    end
]]

--[[ TODO game isn't avalable yet
    -- Remove 'pistol' from slot
    for index,player in pairs(game.players) do
        player.get_inventory(defines.inventory.player_guns).remove{name="pistol", count=1}
    end
]]
end
