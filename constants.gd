extends Node

enum DIRECTION {LEFT, RIGHT, UP, DOWN}
const LEFT = DIRECTION.LEFT
const RIGHT = DIRECTION.RIGHT
const UP = DIRECTION.UP
const DOWN = DIRECTION.DOWN

func delta(dir: Constants.DIRECTION) -> Vector2i:
	match dir:
		Constants.LEFT: return Vector2i.LEFT
		Constants.RIGHT: return Vector2i.RIGHT
		Constants.UP: return Vector2i.UP
		Constants.DOWN: return Vector2i.DOWN
		_: return Vector2i.ZERO

func dir_name(dir: Constants.DIRECTION):
	match dir:
		Constants.LEFT: return "LEFT"
		Constants.RIGHT: return "RIGHT"
		Constants.UP: return "UP"
		Constants.DOWN: return "DOWN"
		_: return ""
