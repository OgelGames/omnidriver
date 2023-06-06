
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











-- Push Edge / Rotate Pointed
-- Rotate Vertical / Rotate Horizontal
-- Rotate Face / Rotate Axis
-- Paste Rotation / Copy Rotation

--[[





function omnidriver.can_rotate(pos, node, player)
	local def = minetest.registered_nodes[node.name]
	if not def or def.on_rotate == false or def.on_rotate == screwdriver.disallow then
		return false
	end
	local player_name = player and player:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		return false
	end
	return true
end

function omnidriver.rotate_node(pos, node, player, new_param2)
	local def = minetest.registered_nodes[node.name]
	if type(def.on_rotate) == "function" then
		local pos_copy = vector.new(pos)
		local node_copy = table.copy(node)
		local result
		-- We don't use screwdriver modes, but some nodes only allow "simple" rotation,
		-- so we use mode 1 when the new param2 is suitable.
		if new_param2 < 4 then
			result = def.on_rotate(pos_copy, node_copy, player, 1, new_param2)
		else
			result = def.on_rotate(pos_copy, node_copy, player, 2, new_param2)
		end
		if result ~= nil then
			return result
		end
	end
	node.param2 = new_param2
	minetest.swap_node(pos, node)
	return true
end

local face_to_rotation = {
	["+y"] = {
		[ 0] =  1, [ 1] =  2, [ 2] =  3, [ 3] =  0,
		[ 4] = 13, [ 5] = 14, [ 6] = 15, [ 7] = 12,
		[ 8] = 17, [ 9] = 18, [10] = 19, [11] = 16,
		[12] =  9, [13] = 10, [14] = 11, [15] =  8,
		[16] =  5, [17] =  6, [18] =  7, [19] =  4,
		[20] = 23, [21] = 22, [22] = 21, [23] = 20,
	}
}

function omnidriver.pointed_to_face(pointed)
	local dir = vector.subtract(pointed.above, pointed.under)
	for axis, value in pairs(dir) do
		if value > 0 then
			return "+"..axis
		elseif value < 0 then
			return "-"..axis
		end
	end
	-- Player is inside node, default to top face
	return "+y"
end

function omnidriver.rotate_by_axis(node, axis, direction)
	local def = minetest.registered_nodes[node.name]
	if not def or not def.paramtype2 then
		return node
	end
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	if def.paramtype2 == "facedir" or def.paramtype2 == "colorfacedir" then
		local param2 = node.param2 % 32
		if rotate_facedir[axis] and param2 >= 0 and param2 <= 23 then
			node.param2 = rotate_facedir[axis][direction][param2]
		end
	elseif def.paramtype2 == "wallmounted" or def.paramtype2 == "colorwallmounted" then
		local param2 = node.param2 % 8
		if rotate_wallmounted[axis] and param2 >= 0 and param2 <= 5 then
			node.param2 = rotate_wallmounted[axis][direction][param2]
		end
	end
	return node
end
--]]
