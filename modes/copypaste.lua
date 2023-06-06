
local S = omnidriver.translator

local description = S("Paste / Copy")

local function handler(pos, node, player, pointed, stack)
	local controls = player:get_player_control()
	local pt = minetest.registered_nodes[node.name].paramtype2
	local val = node.param2
	local meta = stack:get_meta()
	if controls.place then
		-- Copy
		local name = player:get_player_name()
		if controls.aux1 then
			meta:set_string("stored_type_b", pt)
			meta:set_int("stored_value_b", val)
			minetest.sound_play("omnidriver_rotate_backward", {pos = pos, to_player = name}, true)
		else
			meta:set_string("stored_type_a", pt)
			meta:set_int("stored_value_a", val)
			minetest.sound_play("omnidriver_rotate_forward", {pos = pos, to_player = name}, true)
		end
		return
	elseif controls.dig then
		-- Paste
		local spt, sval
		if controls.aux1 then
			spt = meta:get("stored_type_b")
			sval = meta:get_int("stored_value_b")
		else
			spt = meta:get("stored_type_a")
			sval = meta:get_int("stored_value_a")
		end
		if not spt then
			omnidriver.popup(player, S("No rotation stored"))
			return
		end
		if pt == spt then
			val = sval
		elseif pt == "facedir" and spt == "colorfacedir" then
			val = spt % 32
		elseif pt == "colorfacedir" and spt == "facedir" then
			local color = val - (val % 32)
			val = spt + color
		elseif pt == "wallmounted" and spt == "colorwallmounted" then
			val = spt % 8
		elseif pt == "colorwallmounted" and spt == "wallmounted" then
			local color = val - (val % 8)
			val = spt + color
		elseif pt == "4dir" and spt == "color4dir" then
			val = spt % 4
		elseif pt == "color4dir" and spt == "4dir" then
			local color = val - (val % 4)
			val = spt + color
		else
			omnidriver.popup(player, S("Cannot paste @1 rotation to @2 node", spt, pt))
			return
		end
	end
	return val
end

return {
	description = description,
	handler = handler,
}
