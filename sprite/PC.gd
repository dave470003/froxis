extends Sprite2D

var _new_GroupName := preload("res://library/GroupName.gd").new()

var _is_invisible: bool = false
var _invisible_turns: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_PCMove_turn_invisible(turns):
	turn_invisible(turns)

func _on_PCAttack_turn_visible():
	_set_is_invisible(false)
	_invisible_turns = 0

func turn_invisible(turns):
	_set_is_invisible(true)
	_invisible_turns = turns

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		if _invisible_turns > 0:
			_invisible_turns = _invisible_turns - 1
		if _invisible_turns == 0:
			_set_is_invisible(false)

func _set_is_invisible(setter: bool):
	_is_invisible = setter
	if setter:
		modulate.a = 0.25
	else:
		modulate.a = 1
