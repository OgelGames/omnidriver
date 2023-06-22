
local S = omnidriver.translator

local description = S("Rotate Face / Rotate Axis")

local facedir = {
	[screwdriver.ROTATE_FACE] = {
		[ 1] = {
			[0]  = 1,  [1]  = 2,  [2]  = 3,  [3]  = 0,
			[4]  = 5,  [5]  = 6,  [6]  = 7,  [7]  = 4,
			[8]  = 9,  [9]  = 10, [10] = 11, [11] = 8,
			[12] = 13, [13] = 14, [14] = 15, [15] = 12,
			[16] = 17, [17] = 18, [18] = 19, [19] = 16,
			[20] = 21, [21] = 22, [22] = 23, [23] = 20,
		},
		[-1] = {},
	},
	[screwdriver.ROTATE_AXIS] = {
		[ 1] = {
			[0]  = 4,  [1]  = 4,  [2]  = 4,  [3]  = 4,
			[4]  = 8,  [5]  = 8,  [6]  = 8,  [7]  = 8,
			[8]  = 12, [9]  = 12, [10] = 12, [11] = 12,
			[12] = 16, [13] = 16, [14] = 16, [15] = 16,
			[16] = 20, [17] = 20, [18] = 20, [19] = 20,
			[20] = 0,  [21] = 0,  [22] = 0,  [23] = 0,
		},
		[-1] = {},
	},
}

local wallmounted = {
	[screwdriver.ROTATE_FACE] = {
		[ 1] = {[2] = 5, [3] = 4, [4] = 2, [5] = 3, [1] = 0, [0] = 1},
		[-1] = {},
	},
	[screwdriver.ROTATE_AXIS] = {
		[ 1] = {[2] = 5, [3] = 4, [4] = 2, [5] = 1, [1] = 0, [0] = 3},
		[-1] = {},
	},
}

-- Create reverse rotation tables
do
	local tbl = facedir[screwdriver.ROTATE_FACE]
	for from, to in pairs(tbl[1]) do
		tbl[-1][to] = from
	end
	tbl = facedir[screwdriver.ROTATE_AXIS]
	for from, to in pairs(tbl[1]) do
		tbl[-1][from] = tbl[1][(from + 16) % 24]
	end
end
for _,tbl in pairs(wallmounted) do
	for from, to in pairs(tbl[1]) do
		tbl[-1][to] = from
	end
end

local function rotate_facedir(node, direction, mode)
	local rotation = node.param2 % 32
	local color = node.param2 - rotation
	rotation = facedir[mode][direction][rotation] or 0
	return rotation + color
end

local function rotate_wallmounted(node, direction, mode, pos)
	local rotation = node.param2 % 8
	local color = node.param2 - rotation
	rotation = wallmounted[mode][direction][rotation] or 0
	return rotation + color
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
	-- Handle other rotation types like default screwdriver, but reversable
	local mode = controls.place and 2 or 1
	if pt == "facedir" or pt == "colorfacedir" then
		return rotate_facedir(node, direction, mode)
	end
	if pt == "wallmounted" or pt == "colorwallmounted" then
		return rotate_wallmounted(node, direction, mode, pos)
	end
	return node.param2
end

return {
	name = "default",
	description = description,
	handler = handler,
}
