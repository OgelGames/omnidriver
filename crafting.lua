
local handle, core, shaft

if minetest.get_modpath("default") then
	handle = "default:stick"
	core = "default:diamond"
	shaft = "default:steel_ingot"
end

if minetest.get_modpath("mcl_core") then
	handle = "mcl_core:stick"
	core = "mcl_core:diamond"
	shaft = "mcl_core:iron_ingot"
end

if minetest.get_modpath("basic_materials") then
	core = "basic_materials:ic"
	shaft = "basic_materials:steel_bar"
end

if minetest.get_modpath("technic") then
	core = "technic:control_logic_unit"
	
	minetest.register_craft({
		output = "omnidriver:omnidriver",
		recipe = {
			{"technic:sonic_screwdriver"}
		}
	})
end

if minetest.get_modpath("screwdriver") and core then
	minetest.register_craft({
		output = "omnidriver:omnidriver",
		recipe = {
			{"screwdriver:screwdriver", core},
		}
	})
end

if handle and shaft and core then
	minetest.register_craft({
		output = "omnidriver:omnidriver",
		recipe = {
			{shaft, "", ""},
			{"", core, ""},
			{"", "", handle}
		}
	})
	minetest.register_craft({
		output = "omnidriver:omnidriver",
		recipe = {
			{"", "", shaft},
			{"", core, ""},
			{handle, "", ""}
		}
	})
end
