class_name GridObject

extends Sprite2D

@onready
var level := get_parent() as TileMap
@onready
var tile_size := level.tile_set.tile_size
#@onready
var grid_coords = Vector2i(0, 0)

func _process(delta):
	position.x = grid_coords.x * tile_size.x
	position.y = grid_coords.y * tile_size.y

