extends Node2D

var _new_GroupName := preload("res://library/GroupName.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../Schedule").turn_started.connect(_on_Schedule_turn_started)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(_new_GroupName.DWARF):
		return

	get_node("../Schedule").end_turn()
