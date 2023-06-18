
local rotatable = {
	["facedir"] = true,
	["colorfacedir"] = true,
	["wallmounted"] = true,
	["colorwallmounted"] = true,
	["degrotate"] = true,
	["colordegrotate"] = true,
	["4dir"] = true,
	["color4dir"] = true,
}

function omnidriver.can_rotate(pos, node, player)
	local def = minetest.registered_nodes[node.name]
	if not def or not def.paramtype2 or not rotatable[def.paramtype2] then
		return false
	end
	if def.on_rotate == false or def.on_rotate == screwdriver.disallow then
		return false
	end
	local player_name = player and player:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		return false
	end
	return true
end

function omnidriver.rotate_node(pos, node, player, param2)
	local def = minetest.registered_nodes[node.name]
	if def.on_rotate then
		local mode = 1
		if def.paramtype2 == "facedir" or def.paramtype2 == "colorfacedir" then
			local rotation = param2 % 32
			if rotation > 3 then
				mode = 2
			end
		end
		local node_copy = {name = node.name, param1 = node.param1, param2 = node.param2}
		local result = def.on_rotate(vector.new(pos), node_copy, player, mode, param2)
		if result == false then
			return false
		elseif result == true then
			return true
		end
	end
	if def.groups.attached_node and def.groups.attached_node ~= 0 then
		local attached = def.groups.attached_node
		local dir = vector.new(0, -1, 0)
		if attached == 4 then
			dir.y = 1
		elseif attached == 2 then
			if def.paramtype2 == "facedir" or def.paramtype2 == "colorfacedir" then
				dir = minetest.facedir_to_dir(param2)
			elseif def.paramtype2 == "4dir" or def.paramtype2 == "color4dir" then
				dir = minetest.fourdir_to_dir(param2)
			else
				return false
			end
		elseif def.paramtype2 == "wallmounted" or def.paramtype2 == "colorwallmounted" then
			dir = minetest.wallmounted_to_dir(param2)
		end
		local other = minetest.get_node(vector.add(pos, dir))
		local other_def = minetest.registered_nodes[other.name]
		if other_def and not other_def.walkable then
			return false
		end
	end
	node.param2 = param2
	minetest.swap_node(pos, node)
	if def.after_rotate then
		def.after_rotate(pos)
	end
	return true
end

--------------------------------------------------

local rotate_facedir = {
	x = {
		[ 1] = {[0]= 4, 5, 6, 7,22,23,20,21, 0, 1, 2, 3,13,14,15,12,19,16,17,18,10,11, 8, 9},
		[-1] = {[0]= 8, 9,10,11, 0, 1, 2, 3,22,23,20,21,15,12,13,14,17,18,19,16, 6, 7, 4, 5},
	},
	y = {
		[ 1] = {[0]= 1, 2, 3, 0,13,14,15,12,17,18,19,16, 9,10,11, 8, 5, 6, 7, 4,23,20,21,22},
		[-1] = {[0]= 3, 0, 1, 2,19,16,17,18,15,12,13,14, 7, 4, 5, 6,11, 8, 9,10,21,22,23,20},
	},
	z = {
		[ 1] = {[0]=16,17,18,19, 5, 6, 7, 4,11, 8, 9,10, 0, 1, 2, 3,20,21,22,23,12,13,14,15},
		[-1] = {[0]=12,13,14,15, 7, 4, 5, 6, 9,10,11, 8,20,21,22,23, 0, 1, 2, 3,16,17,18,19},
	},
}

function omnidriver.rotate_facedir(param2, direction, axis)
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	local rotation = param2 % 32
	local color = param2 - rotation
	if not rotate_facedir[axis] or rotation < 0 or rotation > 23 then
		return param2
	end
	return rotate_facedir[axis][direction][rotation] + color
end

--------------------------------------------------

local rotate_wallmounted = {
	x = {
		[ 1] = {[0]= 4, 5, 2, 3, 1, 0},
		[-1] = {[0]= 5, 4, 2, 3, 0, 1},
	},
	y = {
		[ 1] = {[0]= 0, 1, 5, 4, 2, 3},
		[-1] = {[0]= 0, 1, 4, 5, 3, 2},
	},
	z = {
		[ 1] = {[0]= 3, 2, 0, 1, 4, 5},
		[-1] = {[0]= 2, 3, 1, 0, 4, 5},
	},
}

function omnidriver.rotate_wallmounted(param2, direction, axis)
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	local rotation = param2 % 8
	local color = param2 - rotation
	if not rotate_wallmounted[axis] or rotation < 0 or rotation > 5 then
		return param2
	end
	return rotate_wallmounted[axis][direction][rotation] + color
end

--------------------------------------------------

local degrotate_steps = minetest.features.degrotate_240_steps and 240 or 180

function omnidriver.rotate_degrotate(param2, direction, fine)
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	local amount = fine and 1 or 10
	return (param2 + amount * direction + degrotate_steps) % degrotate_steps
end

function omnidriver.rotate_colordegrotate(param2, direction)
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	local rotation = param2 % 32
	local color = param2 - rotation
	rotation = (rotation + direction + 24) % 24
	return rotation + color
end

--------------------------------------------------

function omnidriver.rotate_4dir(param2, direction)
	if direction ~= 1 and direction ~= -1 then
		direction = 1
	end
	local rotation = param2 % 4
	local color = param2 - rotation
	rotation = (rotation + direction + 4) % 4
	return rotation + color
end
