extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_Colours := preload("res://library/Colours.gd").new()

signal enemy_warned
signal enemy_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(_new_GroupName.DWARF):
		return

	var _pc = _ref_Schedule._actors[0]

	if !_pc._is_invisible:
		move_to_pc(_pc, current_sprite)
		if !check_for_traps(current_sprite):
			if _pc_is_close(_pc, current_sprite):
				await _animate_enemy_attack(_pc, current_sprite)
				enemy_attack.emit(1)

	_ref_Schedule.end_turn()

func _pc_is_close(source: Sprite2D, target: Sprite2D) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x + delta_y < 2

func move_to_pc(pc: Sprite2D, current: Sprite2D):
	# very basic pathfinding. to be upgraded.
	var current_pos: Array = _new_ConvertCoord.vector_to_array(current.position)
	var pc_pos: Array = _new_ConvertCoord.vector_to_array(pc.position)

	var dir = ""

	if pc_pos[1] > current_pos[1] and try_to_move(current, current_pos[0], current_pos[1] + 1):
		update_position(current, current_pos[0], current_pos[1] + 1)
	elif (pc_pos[1] < current_pos[1]) and try_to_move(current, current_pos[0], current_pos[1] - 1):
		update_position(current, current_pos[0], current_pos[1] - 1)
	elif (pc_pos[0] > current_pos[0]) and try_to_move(current, current_pos[0] + 1, current_pos[1]):
		update_position(current, current_pos[0] + 1, current_pos[1])
	elif (pc_pos[0] < current_pos[0]) and try_to_move(current, current_pos[0] - 1, current_pos[1]):
		update_position(current, current_pos[0] - 1, pc_pos[1])

func try_to_move(current_sprite, x, y):
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, x, y):
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.PC, x, y):
		return false
	return true

func update_position(sprite: Sprite2D, x, y):
	_ref_DungeonBoard.update_sprite_position(sprite, x, y)

func _animate_enemy_attack(pc: Sprite2D, enemy: Sprite2D):
	var tween = pc.create_tween()
	tween.tween_property(pc, "modulate", Color.RED, 0.2)
	tween.tween_property(pc, "modulate", Color(_new_Colours.LIGHT_GREY), 0.2)
	await tween.finished

func check_for_traps(current):
	var current_pos: Array = _new_ConvertCoord.vector_to_array(current.position)
	if _ref_DungeonBoard.has_sprite(_new_GroupName.TRAP, current_pos[0], current_pos[1]):
		trap_detonate(current_pos[0], current_pos[1])
		return true
	return false

func trap_detonate(x, y):
	await _ref_RemoveObject.remove(_new_GroupName.TRAP, x, y)
	await _ref_RemoveObject.remove(_new_GroupName.DWARF, x, y)
