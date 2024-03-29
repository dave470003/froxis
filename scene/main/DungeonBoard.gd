extends Node2D

var _new_DungeonSize := preload("res://library/DungeonSize.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _sprite_dict: Dictionary
var _rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_dict()
	_rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_inside_dungeon(x: int, y: int) -> bool:
	return (x > -1) and (x < _new_DungeonSize.MAX_X) \
			and (y > -1) and (y < _new_DungeonSize.MAX_Y)

func has_sprite(group_name: String, x: int, y: int) -> bool:
	return get_sprite(group_name, x, y) != null


func get_sprite(group_name: String, x: int, y: int) -> Sprite2D:
	if not is_inside_dungeon(x, y):
		return null
	return _sprite_dict[group_name][x][y]

func reset():
	_init_dict()

func update_sprite_position(sprite: Sprite2D, x: int, y: int):
	var oldPos: Array
	var groups: Array

	if sprite.is_in_group(_new_GroupName.ENEMY):
		groups.append(_new_GroupName.ENEMY)
	elif sprite.is_in_group(_new_GroupName.WALL):
		groups.append(_new_GroupName.WALL)
	elif sprite.is_in_group(_new_GroupName.PC):
		groups.append(_new_GroupName.PC)
	elif sprite.is_in_group(_new_GroupName.LADDER):
		groups.append(_new_GroupName.LADDER)
	elif sprite.is_in_group(_new_GroupName.SHRINE):
		groups.append(_new_GroupName.SHRINE)
	elif sprite.is_in_group(_new_GroupName.TRAP):
		groups.append(_new_GroupName.TRAP)
	elif sprite.is_in_group(_new_GroupName.DWARF):
		groups.append(_new_GroupName.DWARF)
	elif sprite.is_in_group(_new_GroupName.ELF):
		groups.append(_new_GroupName.ELF)
	elif sprite.is_in_group(_new_GroupName.TROLL):
		groups.append(_new_GroupName.TROLL)
	elif sprite.is_in_group(_new_GroupName.DEMON):
		groups.append(_new_GroupName.DEMON)
	elif sprite.is_in_group(_new_GroupName.HARPY):
		groups.append(_new_GroupName.HARPY)
	elif sprite.is_in_group(_new_GroupName.FLYING):
		groups.append(_new_GroupName.FLYING)
	elif sprite.is_in_group(_new_GroupName.GROUND):
		groups.append(_new_GroupName.GROUND)
	else:
		return

	for i in range(0, groups.size()):
		var group = groups[i]
		oldPos = _new_ConvertCoord.vector_to_array(sprite.position)
		_sprite_dict[group][oldPos[0]][oldPos[1]] = null

		sprite.position = _new_ConvertCoord.index_to_vector(x, y)
		_sprite_dict[group][x][y] = sprite


func _on_InitLevel_sprite_created(new_sprite: Sprite2D) -> void:
	var pos: Array
	var groups: Array = []

	if new_sprite.is_in_group(_new_GroupName.ENEMY):
		groups.append(_new_GroupName.ENEMY)
	elif new_sprite.is_in_group(_new_GroupName.WALL):
		groups.append(_new_GroupName.WALL)
	elif new_sprite.is_in_group(_new_GroupName.PC):
		groups.append(_new_GroupName.PC)
	elif new_sprite.is_in_group(_new_GroupName.LADDER):
		groups.append(_new_GroupName.LADDER)
	elif new_sprite.is_in_group(_new_GroupName.SHRINE):
		groups.append(_new_GroupName.SHRINE)
	elif new_sprite.is_in_group(_new_GroupName.TRAP):
		groups.append(_new_GroupName.TRAP)
	elif new_sprite.is_in_group(_new_GroupName.DWARF):
		groups.append(_new_GroupName.DWARF)
	elif new_sprite.is_in_group(_new_GroupName.ELF):
		groups.append(_new_GroupName.ELF)
	elif new_sprite.is_in_group(_new_GroupName.TROLL):
		groups.append(_new_GroupName.TROLL)
	elif new_sprite.is_in_group(_new_GroupName.DEMON):
		groups.append(_new_GroupName.DEMON)
	elif new_sprite.is_in_group(_new_GroupName.HARPY):
		groups.append(_new_GroupName.HARPY)
	elif new_sprite.is_in_group(_new_GroupName.FLYING):
		groups.append(_new_GroupName.FLYING)
	elif new_sprite.is_in_group(_new_GroupName.GROUND):
		groups.append(_new_GroupName.GROUND)
	else:
		return

	for i in range(0, groups.size()):
		var group = groups[i]
		pos = _new_ConvertCoord.vector_to_array(new_sprite.position)
		_sprite_dict[group][pos[0]][pos[1]] = new_sprite


func _init_dict() -> void:
	var groups = [
		_new_GroupName.DWARF,
		_new_GroupName.ENEMY,
		_new_GroupName.ELF,
		_new_GroupName.HARPY,
		_new_GroupName.TROLL,
		_new_GroupName.DEMON,
		_new_GroupName.FLYING,
		_new_GroupName.GROUND,
		_new_GroupName.WALL,
		_new_GroupName.PC,
		_new_GroupName.LADDER,
		_new_GroupName.SHRINE,
		_new_GroupName.TRAP
	]

	for g in groups:
		_sprite_dict[g] = {}
		for x in range(_new_DungeonSize.MAX_X):
			_sprite_dict[g][x] = []
			_sprite_dict[g][x].resize(_new_DungeonSize.MAX_Y)

func _on_RemoveObject_sprite_removed(_sprite: Sprite2D, group_name: String,
		x: int, y: int) -> void:
	_sprite_dict[group_name][x][y] = null

func _get_closest_enemy_in_range(x, y, range):
	var enemy = null
	var dist = range;
	for i in range(0, _new_DungeonSize.MAX_X):
		for j in range(0, _new_DungeonSize.MAX_Y):
			if _sprite_dict[_new_GroupName.ENEMY][i][j] is Sprite2D:
				if (abs(i - x) + abs(j - y)) <= dist:
					enemy = _sprite_dict[_new_GroupName.ENEMY][i][j]
					dist = abs(i - x) + abs(j - y)
	return enemy

func get_teleport_destination():
	var x
	var y
	while true:
		x = _rng.randi_range(1, _new_DungeonSize.MAX_X - 1)
		y = _rng.randi_range(1, _new_DungeonSize.MAX_Y - 1)
		if has_sprite(_new_GroupName.ENEMY, x, y) || has_sprite(_new_GroupName.WALL, x, y):
			continue
		break
	return _new_ConvertCoord.index_to_vector(x, y)
