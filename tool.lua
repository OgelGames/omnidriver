
local S = omnidriver.translator

local function create_description(mode)
	local mode_def = omnidriver.modes[mode]
	local mode_desc = mode_def.description or S("Mode @1", mode)
	return S("Omnidriver (@1)", mode_desc)
end

function omnidriver.handler(stack, player, pointed)
	if type(player) ~= "userdata" or not pointed then
		return stack
	end
	local name = player:get_player_name()
	local meta = stack:get_meta()
	local mode = meta:get_int("mode")
	if mode <= 0 or not omnidriver.modes[mode] then
		mode = 1
		meta:set_int("mode", 1)
	end
	local controls = player:get_player_control()
	if controls.dig and controls.sneak then
		mode = mode < #omnidriver.modes and mode + 1 or 1
		meta:set_int("mode", mode)
		meta:set_string("description", create_description(mode))
		omnidriver.popup(player, S("Omnidriver mode changed to @1", omnidriver.modes[mode].description))
		minetest.sound_play("omnidriver_beeps", {to_player = name}, true)
		return stack
	end
	if pointed.type ~= "node" or not pointed.under then
		omnidriver.popup(player, S("Invalid target"))
		return stack
	end
	local pos = pointed.under
	local node = minetest.get_node_or_nil(pos)
	if not node then
		omnidriver.popup(player, S("Invalid target"))
		return stack
	end
	if controls.place and not controls.sneak then
		local def = minetest.registered_nodes[node.name]
		if def and def.on_rightclick then
			return def.on_rightclick(pos, node, player, stack, pointed) or stack
		end
	end
	local param2
	if omnidriver.can_rotate(pos, node, player) then
		local handler = omnidriver.modes[mode].handler
		param2 = handler(pos, node, player, pointed, stack)
		if not param2 then
			return stack
		end
	else
		omnidriver.popup(player, S("This node cannot be rotated"))
		return stack
	end
	if omnidriver.rotate_node(pos, node, player, param2) then
		if controls.aux1 then
			minetest.sound_play("omnidriver_rotate_backward", {pos = pos, to_player = name}, true)
		else
			minetest.sound_play("omnidriver_rotate_forward", {pos = pos, to_player = name}, true)
		end
		if omnidriver.tool_uses > 0 then
			stack:add_wear(65535 / omnidriver.tool_uses)
		end
	else
		omnidriver.popup(player, S("Unable to rotate node"))
	end
	return stack
end

minetest.register_tool("omnidriver:omnidriver", {
	description = create_description(1),
	inventory_image = "omnidriver.png",
	groups = {tool = 1},
	on_use = omnidriver.handler,
	on_place = omnidriver.handler,
	on_secondary_use = omnidriver.handler,
})
