extends Node2D

signal turn_started(current_sprite)

var _pointer: int = 0
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _actors: Array = [null]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../InitWorld").sprite_created.connect(_on_InitWorld_sprite_created)
	get_node("../RemoveObject").sprite_removed.connect(_on_RemoveObject_sprite_removed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(_new_GroupName.DWARF):
		_actors.append(new_sprite)


func end_turn() -> void:
	# print("{0}: End turn.".format([_get_current().name]))
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
