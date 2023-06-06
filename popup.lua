
local player_popups = {}

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local id = player:hud_add({
		name = "omnidriver_popup",
		hud_elem_type = "text",
		position = {x = 0.5, y = 0.85},
		alignment = {x = 0, y = 0},
		scale = {x = 1, y = 1},
		text = "",
		number = 0xFFFFFF,
	})
	player_popups[name] = {id = id, text = ""}
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_popups[name] = nil
end)

minetest.register_globalstep(function()
	local now = os.time()
	for name, popup in pairs(player_popups) do
		if popup.timeout and now > popup.timeout then
			local player = minetest.get_player_by_name(name)
			if player then
				player:hud_change(popup.id, "text", "")
				popup.timeout = nil
				popup.text = ""
			end
		end
	end
end)

function omnidriver.popup(player, msg)
	local name = player:get_player_name()
	local popup = player_popups[name]
	if popup then
		player:hud_change(popup.id, "text", msg)
		popup.timeout = os.time() + 2
		popup.text = msg
	end
end
