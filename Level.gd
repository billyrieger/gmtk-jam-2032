extends TileMap

var block_scene = preload("res://block.tscn")
@export_global_file("*.tscn") var next_scene

const WALL_TILE_COORDS = Vector2i(1, 2)
const SENSOR_TILE_COORDS = Vector2i(2, 0)
const ACTIVE_SENSOR_TILE_COORDS = Vector2i(0, 1)
const FONT_SIZE_NORMAL = 24
const FONT_SIZE_LARGE = 48

var sensor_coords = []
@export var player_moves: Array[Constants.DIRECTION]
var next_move_index = 0

func _ready():
	set_move_text()
	for coords in get_used_cells(0):
		if get_cell_atlas_coords(0, coords) == SENSOR_TILE_COORDS:
			sensor_coords.append(coords)

func _process(delta):
	update_sensors()
	update_move_text()

func set_move_text():
	for move in player_moves:
		var node = Label.new()
		node.text = Constants.dir_name(move)
		node.add_theme_color_override("font_color", Color.WHITE)
		node.add_theme_font_size_override("font_size", FONT_SIZE_NORMAL)
		$MoveTextContainer.add_child(node)


func update_move_text():
	for i in range(len($MoveTextContainer.get_children())):
		var node = $MoveTextContainer.get_child(i)
		if (i+1) % len(player_moves) == next_move_index:
			node.add_theme_font_size_override("font_size", FONT_SIZE_LARGE)
		else:
			node.add_theme_font_size_override("font_size", FONT_SIZE_NORMAL)

func move_player(grid_coords):
	var move = player_moves[next_move_index]
	if can_move(grid_coords, move):
		do_move(grid_coords, move)
	next_move_index = (next_move_index + 1) % len(player_moves)


func update_sensors():
	var all_done = true
	for sensor in sensor_coords:
		var node = get_child_at(sensor)
		if node and node.is_in_group("blocks"):
			set_cell(0, sensor, tile_set.get_source_id(0), ACTIVE_SENSOR_TILE_COORDS, 0)
		else:
			set_cell(0, sensor, tile_set.get_source_id(0), SENSOR_TILE_COORDS, 0)
			all_done = false
	if all_done:
		get_tree().change_scene_to_file(next_scene)


func is_wall(grid_coords) -> bool:
	return get_cell_atlas_coords(0, grid_coords) == WALL_TILE_COORDS


func get_child_at(coords) -> Node:
	for node in get_children():
		if "grid_coords" in node and node.grid_coords == coords:
			return node
	return null

func spawn_block(grid_coords):
	var instance = block_scene.instantiate()
	instance.grid_coords = grid_coords
	add_child(instance)


func can_move(from: Vector2i, dir: Constants.DIRECTION):
	var next = from + Constants.delta(dir)
	if is_wall(next):
		return false
	var node = get_child_at(next)
	if not node:
		return true
	if node.is_in_group("blocks"):
		return can_move(next, dir)


func do_move(from: Vector2i, dir: Constants.DIRECTION):
	var node = get_child_at(from)
	if not node:
		return
	var next_coords = from + Constants.delta(dir)
	var next_node = get_child_at(next_coords)
	if next_node:
		do_move(next_coords, dir)
	node.grid_coords = next_coords
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var map_coords = local_to_map(to_local(event.position))
		if event.pressed:
			# don't spawn a block if something is already there
			if get_child_at(map_coords):
				return
			# don't spawn a block directly on a sensor
			if get_cell_atlas_coords(0, map_coords) in [SENSOR_TILE_COORDS, ACTIVE_SENSOR_TILE_COORDS]:
				return 
			print("spawning block at ", map_coords)
			spawn_block(map_coords)
