extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")

var _ref_Schedule: Schedule
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../Schedule").turn_started.connect(_on_Schedule_turn_started)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(_new_GroupName.DWARF):
		return

	var _pc = _ref_Schedule._actors[0]

	if _pc_is_close(_pc, current_sprite):
		print("Too close!")
	_ref_Schedule.end_turn()

func _pc_is_close(source: Sprite2D, target: Sprite2D) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x + delta_y < 2
