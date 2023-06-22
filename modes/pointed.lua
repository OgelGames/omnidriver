
local S = omnidriver.translator

local description = S("Push Edge / Rotate Pointed")

local function raycast_pointed(player, pointed)
	local pos = player:get_pos()
	pos.y = pos.y + player:get_properties().eye_height
	local dir = vector.multiply(player:get_look_dir(), 10)
	local raycast = minetest.raycast(pos, vector.add(pos, dir), false)
	local hit = raycast:next()
	if hit and hit.type == "node"
			and vector.equals(hit.under, pointed.under)
			and vector.equals(hit.above, pointed.above)
			and vector.length(hit.intersection_normal) ~= 0 then
		return
			hit.intersection_normal,
			vector.subtract(hit.intersection_point, hit.under)
	end
end

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
	-- Handle pointed rotation
	local axis = "y"
	if controls.dig then
		local normal, offset = raycast_pointed(player, pointed)
		if not normal then
			return node.param2
		end
		local torque = vector.cross(normal, offset)
		local longest = 0
		for a, v in pairs(torque) do
			if math.abs(v) > longest then
				longest = math.abs(v)
				axis = a
			end
		end
		direction = math.sign(torque[axis]) * direction
	elseif controls.place then
		local dir = vector.subtract(pointed.under, pointed.above)
		for a, v in pairs(dir) do
			if v ~= 0 then
				axis = a
				direction = math.sign(v) * direction * -1
				break
			end
		end
	end
	if pt == "facedir" or pt == "colorfacedir" then
		return omnidriver.rotate_facedir(node.param2, direction, axis)
	end
	if pt == "wallmounted" or pt == "colorwallmounted" then
		return omnidriver.rotate_wallmounted(node.param2, direction, axis, pos)
	end
	return node.param2
end

return {
	name = "pointed",
	description = description,
	handler = handler,
}
