minetest.register_node("mapgen:white",{
	description = "Mapgen Block - White (Hacker!)",
	short_description = "Mapegn Block - White",
	diggable = false,
	tiles = {"white_1px.png^[colorize:#FFF"}
})

minetest.register_node("mapgen:black",{
	description = "Mapgen Block - Black (Hacker!)",
	short_description = "Mapegn Block - Black",
	diggable = false,
	tiles = {"white_1px.png^[colorize:#000"}
})

local white_id = minetest.get_content_id("mapgen:white")

minetest.register_on_generated(function(minp,maxp,seed)
	if minp.y > -1 or maxp.y < -1 then return end
	local vm,emin,emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()
	local y = -1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			data[area:index(x,y,z)] = white_id
		end
	end

	vm:set_data(data)
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:write_to_map(data)
end)
