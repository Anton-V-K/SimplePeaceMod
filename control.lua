require("lib/config")
require("lib/helpers")

local const = require("lib/const")
local techno = require("lib/technologies")

local last_peace_tick = 0 -- game.tick when peace was "established" last time
local peace_is_on = false -- only for peace initiation

-- (c) https://stackoverflow.com/a/33511182/536172
local function has(tab, val)
	if val then
	    for index, value in ipairs(tab) do
    	    if value == val then
        	    return true
	        end
    	end
    end
    return false
end

local function RemoveItem(recipe, player, inventory)
    -- 'player.force' has 'recipes' (c) https://forums.factorio.com/viewtopic.php?t=31743#p200091
	if player.force.recipes[recipe] == null or player.force.recipes[recipe].enabled == false then
		player.remove_item{name=recipe}
	end
end

--function on_init()
--if remote.interfaces.freeplay then
    if removeMilitaryTech then

		local function ClearWeapons(player)
			local guns = player.get_inventory(defines.inventory.player_guns)
			local mags = player.get_inventory(defines.inventory.player_ammo)
            if guns then
			guns.clear()
            if mags then
			mags.clear()

			local toolbelt = player.get_quickbar()
			toolbelt.remove{name="grenade", count="100"} -- New hope / Level 03
			--toolbelt.remove{type="ammo", count="100"}
			toolbelt.remove{name="gun-turret", count="100"}

			local inv = player.get_inventory(defines.inventory.player_main)
			inv.remove{name="gun-turret", count="100"}

			local car = player.get_inventory(defines.inventory.player_vehicle)
			if car then
				car.remove{name="piercing-rounds-magazine", count="2000"} -- New hope / Level 03
			end
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

		-- (c) https://forums.factorio.com/viewtopic.php?t=51090#p298679
		local function DestroyEnemies(player)
			local surface = player.surface
			for c in surface.get_chunks() do
				local square = {{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}
				for key, entity in pairs(surface.find_entities_filtered({area=square, force = "enemy"})) do
				    if entity.type ~= "electric-energy-interface" then -- Factorissimo2
						-- game.print("DEBUG: entity.destroy() for " .. entity.name .. " AS " .. entity.type) -- DEBUG
						entity.destroy()
						game.print({"msg-peace-mode-on-no-enemies"}) -- "Peace mode is ON: no enemies, please")
					end
				end
				-- (c) https://www.reddit.com/r/factorio/comments/6khte4/is_there_a_way_to_remove_dead_biterscorpses/
				for key, entity in pairs(surface.find_entities_filtered({area=square, type = "corpse"})) do
					if entity.name:match("corpse$") then -- if it is an animal corpse...
						entity.destroy()
					else
						-- game.print(entity.name) -- DEBUG
					end
				end
			end
		end

		-- Destroys weapons within revealed map area
		local function DestroyWeapons(player)
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
			local wtypes = { "ammo-turret", "artillery-turret", "electric-turret", "fluid-turret", "gun-turret" } -- types
			local wtypes_on_ground = { "ammo", "gun" } -- types of the items which can be placed on the ground

			local surface = player.surface
			for c in surface.get_chunks() do
				local square = {{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}
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
						-- game.print("item-on-ground: " .. entity.stack.name) -- DEBUG
					end
				end
				for _, entity in pairs(surface.find_entities_filtered({area=square, name=wnames})) do
					entity.destroy()
				end
				for _, entity in pairs(surface.find_entities_filtered({area=square, type=wtypes})) do
					entity.destroy()
				end
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
				DestroyWeapons(player)
				DestroyEnemies(player)
				HideMilRecipes(player)
				HideMilTech(player)
				last_peace_tick = game.tick
			end
		end

   	 	-- To destroy all enemies and weapons when any production entity is built
		script.on_event(defines.events.on_built_entity, function(event)
			local entity = event.created_entity
			if entity.valid == true
			   and has({"assembling-machine", "furnace", "mining-drill" }, entity.type)
			   then
				-- game.print(entity.type .. " " .. entity.name) -- DEBUG
			    local player = game.players[event.player_index]
				Peace(player)
			end
		end)

		script.on_event(defines.events.on_player_created, function(event)
			local player = game.players[event.player_index]
			Peace(player)
--[[
			for slot=1,#guns do
				local gun = guns[slot]
		        local mag = mags[slot]
		        if gun ~= nil and gun.name == "pistol" then
		        	guns.remove{name=gun.name}
		        end
		        if mag and has(all_mags, mag.name) then
		        	mags.remove{name=mag.name}
		        end
		    end
]]
--[[
			for i=1,#inventory do
				RemoveItem("pistol", player)
	  			player.remove_item{name=}
	  		end
]]
  		end)

   	 	-- To destroy all enemies and weapons when tree is mined
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
					peace_is_on = true
				else
					if last_peace_tick < game.tick + const.INTERVAL_LOGIC then
						ClearWeapons(player)
						DestroyEnemies(player)
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
