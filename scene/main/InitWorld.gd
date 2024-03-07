extends Node2D

signal sprite_created(new_sprite)

@onready var Player := preload("res://sprite/PC.tscn") as PackedScene
@onready var Dwarf := preload("res://sprite/Dwarf.tscn") as PackedScene
@onready var Wall := preload("res://sprite/Wall.tscn") as PackedScene
@onready var Floor := preload("res://sprite/Floor.tscn") as PackedScene

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://library/DungeonSize.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()
var _initialized: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _create_sprite(prefab: PackedScene, group: String, x: int, y: int,
		x_offset: int = 0, y_offset: int = 0) -> void:
	var sprite = prefab.instantiate()
	sprite.position = _new_ConvertCoord.index_to_vector(x, y)
	sprite.add_to_group(group)

	add_child(sprite)

	sprite_created.emit(sprite)

func _create_player():
	_create_sprite(Player, _new_GroupName.PC, 1, 1)

func _create_dwarves():
	_create_sprite(Dwarf, _new_GroupName.DWARF, 10, 1)
	_create_sprite(Dwarf, _new_GroupName.DWARF, 3, 13)
	_create_sprite(Dwarf, _new_GroupName.DWARF, 7, 8)

func _create_walls_and_floor():
	# for now will just be one big room.
	for x in range(0, _new_DungeonSize.MAX_X):
		for y in range(0, _new_DungeonSize.MAX_Y):
			if (x == 0 || y == 0 || x == _new_DungeonSize.MAX_X - 1 || y == _new_DungeonSize.MAX_Y - 1):
				_create_sprite(Wall, _new_GroupName.WALL, x, y)
			else:
				_create_sprite(Floor, _new_GroupName.FLOOR, x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func _unhandled_input(event):
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		if not _initialized:
			_initialized = true
			_create_walls_and_floor()
			_create_player()
			_create_dwarves()
			set_process_unhandled_input(false)
