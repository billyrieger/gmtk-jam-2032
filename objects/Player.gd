extends GridObject

var moves = [Constants.LEFT, Constants.UP, Constants.DOWN]
var next_move_index = 0

func _ready():
	grid_coords = level.local_to_map(position)


func _on_timer_timeout():
	level.move_player(grid_coords)
