extends TileMap

var TILE_SIZE = Vector2(64, 64)

var num_exit = 1
var num_enterance = 1
var num_shop = 1
var num_battles = 3
var num_trash = 1

var rng = RandomNumberGenerator.new()

var map_arr


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport = get_viewport().size
	map_arr = create_2d_array(int(viewport.x/TILE_SIZE.x), int(viewport.y/TILE_SIZE.y + 1), 0)
	
	print(world_to_map(Vector2(0,0)))
	
	for y in range(map_arr.size()):
		for x in range(map_arr[y].size()):
			var tile_type = 1
			if rng.randi_range(0, 5) == 0:
				tile_type = 0
			if rng.randi_range(0, 5) == 0:
				tile_type = 3

			set_cell(x, y, tile_type, rng.randi_range(0, 1) == 0, rng.randi_range(0, 1) == 0)
	
	draw_path(Vector2(0,0), Vector2(0, 1))
	
#	Saver.load_data(0)
#	Saver.save_data()
#	print(Saver.deck[0])
#	print(JSON.parse(Saver.deck[0]))
	
func draw_path(p1: Vector2, p2: Vector2):
	var semi_pos = Vector2(p1.x, p1.y)
	var tween = 0
	while(tween < 1):
		semi_pos = p1.linear_interpolate(p2, tween)
		var path_to_draw = rng.randi_range(0, 4)
		var x_offset = 0
		var y_offset = 0
		match path_to_draw:
			0:
				x_offset = 1
			1:
				x_offset = -1
			2:
				y_offset = 1
			3:
				y_offset = -1
			4:
				pass
		
		set_cell(int(semi_pos.x) + x_offset, int(semi_pos.y) + y_offset, 2)
		
		tween += 0.05
		
	
			
func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a
