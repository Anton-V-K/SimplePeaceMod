-- Hides given recipe for given player
function HideRecipe(recipe, player)
    if player.force.recipes and player.force.recipes[recipe] then
        player.force.recipes[recipe].enabled = false
        -- player.force.recipes[recipe].visible_when_disabled = false
    end
end

-- Hides given technology for given player
function HideTech(tech, player)
    if player.force.technologies and player.force.technologies[tech] then
        player.force.technologies[tech].enabled = false
        player.force.technologies[tech].researched = false
        -- player.force.technologies[tech].visible_when_disabled = false
    end
end

-- Removes given recipe (or just hides it) in global data (can be used from 'data.lua' only)
function RemoveRecipe(recipe, just_hide)
    --Remove the recipe
    if data.raw["recipe"][recipe] then
        if just_hide then
            data.raw["recipe"][recipe].enabled = false
            -- data.raw["recipe"][recipe].visible_when_disabled = false
            -- DEL global.recipes_disabled[recipe] = true
        else
            data.raw["recipe"][recipe] = null
        end
    end
    --Remove all unlocks for recipe in tech tree
    for i, technology in pairs(data.raw["technology"]) do
        if technology.effects then
            for j, effect in pairs(technology.effects) do
                if effect.recipe == recipe then
                    technology.effects[j] = null
                end
            end
        end
    end
end

-- Removes given technology (or just hides it) in global data (can be used from 'data.lua' only)
function RemoveTech(tech, just_hide)
    if data.raw["technology"][tech] then
        if just_hide then
            data.raw["technology"][tech].enabled = false
            data.raw["technology"][tech].visible_when_disabled = false
        else
            data.raw["technology"][tech] = null
        end
    end
end
