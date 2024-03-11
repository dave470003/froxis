extends Node2D

signal turn_started(current_sprite)
signal turn_ended(current_sprite)

var _pointer: int = 0
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _actors: Array = [null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	_actors = [null]
	_pointer = 0

func _on_InitLevel_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(_new_GroupName.ENEMY):
		_actors.append(new_sprite)

func end_turn() -> void:
	turn_ended.emit(_get_current())
	_goto_next()
	turn_started.emit(_get_current())


func _get_current() -> Sprite2D:
	return _actors[_pointer] as Sprite2D


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0

func _on_RemoveObject_sprite_removed(remove_sprite: Sprite2D,
	_group_name: String, _x: int, _y: int) -> void:

	var current_sprite: Sprite2D = _get_current()

	_actors.erase(remove_sprite)
	_pointer = _actors.find(current_sprite)

func get_pc():
	return _actors[0]
