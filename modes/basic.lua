
local S = omnidriver.translator

local description = S("Rotate Vertical / Rotate Horizontal")

local function handler(pos, node, player, pointed, stack)
	local pt = minetest.registered_nodes[node.name].paramtype2
	if not omnidriver.is_rotatable(pt) then
		return node.param2
	end
	local controls = player:get_player_control()
	local direction = controls.aux1 and -1 or 1
	-- Handle simple rotation types
	if pt == "degrotate" then
		return omnidriver.rotate_degrotate(node.param2, direction, controls.place)
	end
	if pt == "colordegrotate" then
		return omnidriver.rotate_colordegrotate(node.param2, direction)
	end
	if pt == "4dir" or pt == "color4dir" then
		return omnidriver.rotate_4dir(node.param2, direction)
	end
	-- Handle axis rotation
	local axis = "y"
	if controls.place then
		-- Get horizontal axis from player yaw
		local dir = minetest.yaw_to_dir(player:get_look_horizontal())
		if math.abs(dir.x) > math.abs(dir.z) then
			axis = "z"
			direction = math.sign(dir.x) * direction
		else
			axis = "x"
			direction = math.sign(dir.z) * direction * -1
		end
	end
	if pt == "facedir" or pt == "colorfacedir" then
		return omnidriver.rotate_facedir(node.param2, direction, axis)
	end
	if pt == "wallmounted" or pt == "colorwallmounted" then
		return omnidriver.rotate_wallmounted(node.param2, direction, axis)
	end
	return node.param2
end

return {
	name = "basic",
	description = description,
	handler = handler,
}
