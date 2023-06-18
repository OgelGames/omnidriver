
local MP = minetest.get_modpath("omnidriver")

omnidriver = {
	tool_uses = tonumber(minetest.settings:get("omnidriver_tool_uses")) or 0,
	translator = minetest.get_translator("omnidriver"),
}

-- Minetest 5.5.0 added math.round, but omnidriver supports 5.4.0+
if not math.round then
	function math.round(x)
		if x >= 0 then
			return math.floor(x + 0.5)
		end
		return math.ceil(x - 0.5)
	end
	function vector.round(v)
		return {
			x = math.round(v.x),
			y = math.round(v.y),
			z = math.round(v.z)
		}
	end
end

-- Some mods require the screwdriver mod to exist
-- We can't pretend to be the mod, but we can add the global variables
if not minetest.global_exists("screwdriver") then
	screwdriver = {}
	screwdriver.ROTATE_FACE = 1
	screwdriver.ROTATE_AXIS = 2
	screwdriver.disallow = function(pos, node, user, mode, new_param2)
		return false
	end
	screwdriver.rotate_simple = function(pos, node, user, mode, new_param2)
		if mode ~= 1 then
			return false
		end
	end
end

-- Not an API
dofile(MP.."/common.lua")
dofile(MP.."/popup.lua")

-- Each file returns a table
omnidriver.modes = {
	dofile(MP.."/modes/basic.lua"),      -- Basic horizontal and vertical rotation
	dofile(MP.."/modes/pointed.lua"),    -- Like rhotator/screwdriver2
	dofile(MP.."/modes/default.lua"),    -- Like default screwdriver
	dofile(MP.."/modes/copypaste.lua"),  -- Paramtype2-specific copy/paste
}

-- Tool and craft recipes
dofile(MP.."/tool.lua")
dofile(MP.."/crafting.lua")
