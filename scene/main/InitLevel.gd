extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const Schedule := preload("res://scene/main/Schedule.gd")

@onready var Player := preload("res://sprite/PC.tscn") as PackedScene
@onready var Dwarf := preload("res://sprite/Dwarf.tscn") as PackedScene
@onready var Elf := preload("res://sprite/Elf.tscn") as PackedScene
@onready var Harpy := preload("res://sprite/Harpy.tscn") as PackedScene
@onready var Demon := preload("res://sprite/Demon.tscn") as PackedScene
@onready var Troll := preload("res://sprite/Troll.tscn") as PackedScene
@onready var Wall := preload("res://sprite/Wall.tscn") as PackedScene
@onready var Floor := preload("res://sprite/Floor.tscn") as PackedScene
@onready var Ladder := preload("res://sprite/Ladder.tscn") as PackedScene
@onready var Shrine := preload("res://sprite/Shrine.tscn") as PackedScene

var _level: int
var _rng := RandomNumberGenerator.new()
var _ref_DungeonBoard: DungeonBoard
var _ref_Schedule: Schedule
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_Levels := preload("res://library/Levels.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://library/DungeonSize.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()
var _initialized: bool = false

signal sprite_created(new_sprite)
signal level_started(level_number)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rng.randomize()

func _create_sprite(prefab: PackedScene, groups: Array, x: int, y: int,
		x_offset: int = 0, y_offset: int = 0) -> void:
	var sprite = _create_silent_sprite(prefab, groups, x, y, x_offset, y_offset)

	sprite_created.emit(sprite)

func _create_silent_sprite(prefab: PackedScene, groups: Array, x: int, y: int,
		x_offset: int = 0, y_offset: int = 0) -> Sprite2D:
	var sprite = prefab.instantiate()
	sprite.position = _new_ConvertCoord.index_to_vector(x, y)
	for i in range(0, groups.size()):
		sprite.add_to_group(groups[i])

	add_child(sprite)

	return sprite

func _create_player():
	_create_sprite(Player, [_new_GroupName.PC], _new_DungeonSize.PLAYER_SPAWN_X, _new_DungeonSize.PLAYER_SPAWN_Y)

func _create_ladder():
	if _level < 10:
		_create_sprite(Ladder, [_new_GroupName.LADDER], _new_DungeonSize.LADDER_SPAWN_X, _new_DungeonSize.LADDER_SPAWN_Y)

func _create_shrine():
	_create_sprite(Shrine, [_new_GroupName.SHRINE], _new_DungeonSize.SHRINE_SPAWN_X, _new_DungeonSize.SHRINE_SPAWN_Y)

func _create_enemies():
	var types = [_new_GroupName.DWARF, _new_GroupName.ELF, _new_GroupName.HARPY, _new_GroupName.DEMON, _new_GroupName.TROLL]
	for i in range(0, types.size()):
		var type = types[i]
		if !_new_Levels.LEVELS_DICT[_level].has(type):
			continue
		var enemy = _new_Levels.LEVELS_DICT[_level][type]
		var x: int
		var y: int

		while enemy > 0:
			x = _rng.randi_range(1, _new_DungeonSize.MAX_X - 1)
			y = _rng.randi_range(1, _new_DungeonSize.MAX_Y - 1)

			if _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y) \
					or _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y) \
					or _ref_DungeonBoard.has_sprite(_new_GroupName.PC, x, y):
				continue
			_create_enemy(type, x, y)
			enemy -= 1

func _create_enemy(type, x, y):
	match type:
		_new_GroupName.DWARF:
			_create_sprite(Dwarf, [_new_GroupName.DWARF, _new_GroupName.GROUND, _new_GroupName.ENEMY], x, y)
		_new_GroupName.ELF:
			_create_sprite(Elf, [_new_GroupName.ELF, _new_GroupName.GROUND, _new_GroupName.ENEMY], x, y)
		_new_GroupName.TROLL:
			_create_sprite(Troll, [_new_GroupName.TROLL, _new_GroupName.GROUND, _new_GroupName.ENEMY], x, y)
		_new_GroupName.DEMON:
			_create_sprite(Demon, [_new_GroupName.DEMON, _new_GroupName.FLYING, _new_GroupName.ENEMY], x, y)
		_new_GroupName.HARPY:
			_create_sprite(Harpy, [_new_GroupName.HARPY, _new_GroupName.FLYING, _new_GroupName.ENEMY], x, y)

func _create_walls_and_floor():
	# for now will just be one big room.
	for x in range(0, _new_DungeonSize.MAX_X):
		for y in range(0, _new_DungeonSize.MAX_Y):
			if (x == 0 || y == 0 || x == _new_DungeonSize.MAX_X - 1 || y == _new_DungeonSize.MAX_Y - 1):
				_create_sprite(Wall, [_new_GroupName.WALL], x, y)
			else:
				_create_sprite(Floor, [_new_GroupName.FLOOR], x, y)

	for i in range(0, 10):
		var rand_x = _rng.randi_range(1, _new_DungeonSize.MAX_X - 1)
		var rand_y = _rng.randi_range(1, _new_DungeonSize.MAX_Y - 1)

		if _ref_DungeonBoard.has_sprite(_new_GroupName.SHRINE, rand_x, rand_y) \
			or _ref_DungeonBoard.has_sprite(_new_GroupName.PC, rand_x, rand_y) \
			or _ref_DungeonBoard.has_sprite(_new_GroupName.LADDER, rand_x, rand_y):
			continue
		_create_sprite(Wall, [_new_GroupName.WALL], rand_x, rand_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func start_level(level_number):
	_level = level_number
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	_ref_DungeonBoard.reset()
	_ref_Schedule.reset()
	_create_shrine()
	_create_ladder()
	_create_player()
	_create_walls_and_floor()
	_create_enemies()
	level_started.emit(_level)

func next_level():
	start_level(_level + 1)
