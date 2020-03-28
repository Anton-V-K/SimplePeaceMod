require("lib/config")
require("lib/func")
require("lib/helpers")

local const = require("lib/const")
local techno = require("lib/technologies")

local last_peace_tick = 0 -- game.tick when peace was "established" last time
local peace_is_on = false -- only for peace initiation

-- types of natural enemies
local etypes = { "turret", "unit", "unit-spawner"
               }

-- names of weapons which are to be removed from inventories periodically (so keep it short)
local inames = { "cluster-grenade"
               , "firearm-magazine"
               , "grenade"                      -- also in New hope / Level 03
               , "gun-turret"
               , "land-mine"
               , "piercing-rounds-magazine"     -- also in New hope / Level 03 (count="2000")
               }

-- types of weapons which can be built on land
local wtypes = { "ammo-turret", "artillery-turret", "electric-turret", "fluid-turret" --, "gun-turret"
               }

-- types of weapons which can be placed on the ground in stacks
local wtypes_on_ground = { "ammo", "gun" }

local function RemoveItem(recipe, player, inventory)
    -- 'player.force' has 'recipes' (c) https://forums.factorio.com/viewtopic.php?t=31743#p200091
	if player.force.recipes[recipe] == null or player.force.recipes[recipe].enabled == false then
		player.remove_item{name=recipe}
	end
end

--function on_init()
--if remote.interfaces.freeplay then
    if removeMilitaryTech then

        -- Removes weapons from given inventory
        local function ClearWeaponsInInventory(inv)
            if inv then
                -- inv.remove{name="gun-turret", count="100"} -- TEST
                for _, iname in pairs(inames) do
                    if inv.get_item_count(iname) > 0 then
                        -- game.print("inames - remove: " .. iname) -- DEBUG
                        while (inv.remove{name=iname, count="100"} > 0) do
                        end
                    end
                end
            end
        end

        -- Removes weapons for given player (in all inventories)
		local function ClearWeapons(player)
			local guns = player.get_inventory(defines.inventory.player_guns)
			local mags = player.get_inventory(defines.inventory.player_ammo)
            if guns then
			    guns.clear()
            end
            if mags then
			    mags.clear()
            end

			local toolbelt = player.get_quickbar()
            ClearWeaponsInInventory(toolbelt)

			local inv = player.get_inventory(defines.inventory.player_main)
            ClearWeaponsInInventory(inv)

			local car = player.get_inventory(defines.inventory.player_vehicle)
            ClearWeaponsInInventory(car)
            --[[
			if car then
				car.remove{name="piercing-rounds-magazine", count="2000"} -- New hope / Level 03
			end
            ]]
			--[[ global.creeperskilled is private for First steps / Level 02
			if global.creeperskilled == 0 then
				global.creeperskilled = 2 -- Needed to finish First steps / Level 02 without killing anyone
			end
			]]
			--[[
			if {level is First steps / Level 02} then -- you can't finish the level without killing an animal
				guns.insert{name="pistol", count="1"}
				mags.insert{name="firearm-magazine", count="1"}
			end
			]]
		end

        -- Destroys enemies for given surface in the given map area
        -- (c) https://forums.factorio.com/viewtopic.php?t=51090#p298679
        local function DestroyEnemiesInArea(surface, ltx, lty, rbx, rby)

                local square = {{ltx, lty}, {rbx, rby}}
                for key, entity in pairs(surface.find_entities_filtered({area = square, force = "enemy", type = etypes})) do
                    -- if entity.type ~= "electric-energy-interface" then -- Factorissimo2
                    if true -- has(wtypes, entity.type)
                       then
						-- game.print("DEBUG: entity.destroy() for " .. entity.name .. " AS " .. entity.type) -- DEBUG
						entity.destroy()
						game.print({"msg-peace-mode-on-no-enemies"}) -- "Peace mode is ON: no enemies, please"
                    else
                        -- game.print("enemy: " .. entity.name .. " AS " .. entity.type) -- DEBUG
					end
				end
				-- (c) https://www.reddit.com/r/factorio/comments/6khte4/is_there_a_way_to_remove_dead_biterscorpses/
				for key, entity in pairs(surface.find_entities_filtered({area = square, type = "corpse"})) do
					if entity.name:match("corpse$") then -- if it is an animal corpse...
						entity.destroy()
					else
						-- game.print(entity.name) -- DEBUG
					end
				end
        end

        local function DestroyEnemies(player)
            local surface = player.surface
            for c in surface.get_chunks() do
                -- local square = {{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}
                DestroyEnemiesInArea(surface, c.x * 32, c.y * 32, c.x * 32 + 32, c.y * 32 + 32)
			end
		end

        -- Destroys weapons for given surface in the given map area
        local function DestroyWeaponsInArea(surface, ltx, lty, rbx, rby)
			-- game.print("DEBUG: DestroyWeapons - start")

			local wnames = { "artillery-wagon", "defender-capsule", "destroyer-capsule", "distractor-capsule", "land-mine", "tank" }
			-- names of the items which can be placed on the ground
			local wnames_on_ground =
			{
				"artillery-targeting-remote", "artillery-turret",
				"cluster-grenade",
				"discharge-defense-equipment", "discharge-defense-remote",
				"flamethrower-turret",
				"grenade", "gun-turret",
				"laser-turret",
				"personal-laser-defense-equipment", "poison-capsule"
			}

                local square = {{ltx, lty}, {rbx, rby}}
			    -- Note: items on ground can be found using 'item-on-ground' as 'name'
				for _, entity in pairs(surface.find_entities_filtered({area=square, name="item-on-ground"})) do
					-- hint about 'stack' - https://forums.factorio.com/viewtopic.php?t=811#p5620
					if has(wnames_on_ground, entity.stack.name)
					   or has(wnames, entity.stack.name)
					   or has(wtypes_on_ground, entity.stack.type)
					   or has(wtypes, entity.stack.type)
					   then
						entity.destroy()
					else
                        -- game.print("item-on-ground: " .. entity.stack.name .. " AS " .. entity.stack.type) -- DEBUG
					end
				end
				for _, entity in pairs(surface.find_entities_filtered({area=square, name=wnames})) do
                    -- game.print("wnames - destroy: " .. entity.name .. " AS " .. entity.type) -- DEBUG
					entity.destroy()
				end
				for _, entity in pairs(surface.find_entities_filtered({area=square, type=wtypes})) do
                    -- game.print("wtypes - destroy: " .. entity.name .. " AS " .. entity.type) -- DEBUG
					entity.destroy()
				end

		end

        -- Destroys weapons within revealed map area
        local function DestroyWeapons(player)
            local surface = player.surface
            for c in surface.get_chunks() do
                -- local square = {{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}
                DestroyWeaponsInArea(surface, c.x * 32, c.y * 32, c.x * 32 + 32, c.y * 32 + 32)
            end
        end

		-- Hide all military recipes for given player
		local function HideMilRecipes(player)
--[[
			for recipe in const.raw["recipe"] do
				if recipe.disabled then
					HideRecipe(recipe, player)
				end
			end
]]
--
			HideRecipe("defender-capsule", player)
			HideRecipe("firearm-magazine", player)
			HideRecipe("gun-turret", player)
			-- HideRecipe("light-armor", player)
			HideRecipe("piercing-rounds-magazine", player);
			HideRecipe("pistol", player)
			HideRecipe("rocket", player)
			HideRecipe("shotgun", player)
			HideRecipe("shotgun-shell", player)
			HideRecipe("submachine-gun", player)
--]]
		end

		-- Hide all military technology for given player
		local function HideMilTech(player)
			-- TODO merge with 'data.lua'
			HideTech("aircraft-energy-shield", player) -- Aircraft mod
			HideTech("combat-robotics", player) -- Required for New hope / Level 03
			HideTech("combat-robotics-2", player)
			HideTech("combat-robotics-3", player) -- Required for New hope / Level 04
			--HideTech("military", player) -- Required for rockets
			--HideTech("military-2", player) -- Required for rockets
			HideTech("military-3", player)
			HideTech("military-4", player)
			for i=1,7 do
				HideTech("bullet-damage-" .. i, player) -- 'bullet-damage-1' is required for New hope / Level 01..03
			end
			for i=1,6 do
				HideTech("bullet-speed-" .. i, player) -- 'bullet-speed-3' is required for New hope / Level 04
			end
			HideTech("flamethrower", player)
			HideTech("flying-fortress", player) -- Aircraft mod
			for i=1,7 do
				HideTech("follower-robot-count-" .. i, player) -- follower-robot-count-4 is required for New hope / Level 04
			end
			HideTech("gunships", player) -- Aircraft mod
			HideTech("high-explosive-cannon-shells", player) -- Aircraft mod
			HideTech("jets", player) -- Aircraft mod
			for i=1,8 do
 				HideTech("laser-turret-damage-" .. i, player) -- laser-turret-damage-1 is required for New hope / Level 04
		 	end
		 	for i=1,7 do
 				HideTech("laser-turret-speed-" .. i, player) -- laser-turret-speed-1 is required for New hope / Level 04
		 	end
			HideTech("laser-turrets", player)
			HideTech("land-mine", player)
			HideTech("napalm", player) -- Aircraft mod
			for i=1,7 do
				HideTech("shotgun-shell-damage-" .. i, player) -- Required for New hope / Level 04
			end
			for i=1,6 do
				HideTech("shotgun-shell-speed-" .. i, player) -- Required for New hope / Level 04
			end
			HideTech("tanks", player)
			HideTech("turrets", player)
		end

		local function Peace(player)
			if last_peace_tick < game.tick + const.INTERVAL_LOGIC then
				ClearWeapons(player)
                -- DestroyWeapons(player) -- done in on_chunk_generated
                -- DestroyEnemies(player) -- done in on_chunk_generated
				HideMilRecipes(player)
				HideMilTech(player)
				last_peace_tick = game.tick
			end
		end

        -- To enforce peace when any production or military entity is built
		script.on_event(defines.events.on_built_entity, function(event)
			local entity = event.created_entity
			if entity.valid == true
			   and has({"assembling-machine", "furnace", "mining-drill" }, entity.type)
			   then
				-- game.print(entity.type .. " " .. entity.name) -- DEBUG
			    local player = game.players[event.player_index]
				Peace(player)
			end
            -- If you've managed to build a military entity, let's clean the entire map (just in case)
            if entity.valid == true
               and has(wtypes, entity.type) -- you could somehow build it... wow!
               then
                DestroyEnemies(player)
                DestroyWeapons(player)
            end
		end)

        script.on_event(defines.events.on_chunk_generated, function(event)
            -- https://forums.factorio.com/viewtopic.php?p=437974#p437974
            local lt = event.area.left_top      -- left/top
            local rb = event.area.right_bottom  -- right/bottom
            -- game.print("on_chunk_generated: " .. tableToString(event.area)) -- DEBUG

            for index, player in pairs(game.connected_players) do  -- loop through all online players on the server
                -- https://lua-api.factorio.com/latest/events.html#on_chunk_generated
                -- NOTE: event.surface won't work
                DestroyEnemiesInArea(player.surface, lt.x, lt.y, rb.x, rb.y)
                DestroyWeaponsInArea(player.surface, lt.x, lt.y, rb.x, rb.y)
            end
        end)

		script.on_event(defines.events.on_player_created, function(event)
			local player = game.players[event.player_index]
			Peace(player)
  		end)

        -- To enforce peace when a tree is mined (sponsored by Greenpeace :)
		script.on_event(defines.events.on_pre_player_mined_item, function(event)
			local entity = event.entity -- event.created_entity
			if entity.valid == true and entity.type == "tree" then
			    local player = game.players[event.player_index]
				Peace(player)
			end
		end)

  		script.on_nth_tick(const.INTERVAL_LOGIC, function (event)
  		    -- game.print(game.tick) -- DEBUG
  			-- https://wiki.factorio.com/Tutorial:Modding_tutorial/Gangsir#The_control_scripting
  			for index,player in pairs(game.connected_players) do  --loop through all online players on the server
				if game.tick == 0 or peace_is_on == false then
					-- game.print("Peace!") -- DEBUG
					Peace(player)
                    DestroyEnemies(player)
                    DestroyWeapons(player)
					peace_is_on = true
				else
					if last_peace_tick < game.tick + const.INTERVAL_LOGIC then
						ClearWeapons(player)
                        -- DestroyEnemies(player) -- done in on_chunk_generated
						last_peace_tick = game.tick
					end
				end
				-- game.print(game.get_map_exchange_string())
--[[ global.creeperskilled is a private variable of First steps / Level 02
				if global.creeperskilled then
					game.print("global.creeperskilled = " .. global.creeperskilled)
				end
]]
  			end
		end)

  	end
--end
--end

--[[
script.on_event(defines.events.on_player_respawned, function(event)
  local player = game.players[event.player_index]
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
end)
]]
