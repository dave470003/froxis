extends Node2D

const INIT_LEVEL = 'InitLevel'

var _new_InputName := preload("res://library/InputName.gd").new()
var _initialized: bool = false

signal set_health(health)
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func _create_level(level_number):
	get_node(INIT_LEVEL).start_level(level_number)

func _set_health():
	set_health.emit(3)

func _on_PCMove_next_level():
	get_node(INIT_LEVEL).next_level()

func _unhandled_input(event):
	if event.is_action_pressed(_new_InputName.INIT_GAME):
		if not _initialized:
			reset_game()
			start_game.emit()

func reset_game():
	_initialized = true
	_set_health()
	_create_level(1)
	set_process_unhandled_input(false)
