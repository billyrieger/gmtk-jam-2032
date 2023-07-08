extends GridObject

var moves = [Constants.LEFT, Constants.UP, Constants.DOWN]
var next_move_index = 0

func _ready():
	grid_coords = level.local_to_map(position)


func _on_timer_timeout():
	var move = moves[next_move_index]
	if level.can_move(grid_coords, move):
		level.do_move(grid_coords, move)
	next_move_index = (next_move_index + 1) % len(moves)

