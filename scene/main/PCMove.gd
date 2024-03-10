extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const MainScene := preload("res://scene/main/MainScene.gd")
const PC_ATTACK: String = "PCAttack"

var _new_InputName := preload("res://library/InputName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_MainScene: MainScene
var _pc: Sprite2D
var _trigger_next_level: bool = false
var _is_charge_primed: bool = false

signal pc_moved(message)
signal next_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_InitLevel_sprite_created(sprite: Sprite2D):
	if sprite.is_in_group(_new_GroupName.PC):
		_pc = sprite
		set_process_unhandled_input(true)

func _on_Charge_skill_primed():
	_is_charge_primed = true

func _on_Charge_skill_unprimed():
	_is_charge_primed = false

func _unhandled_input(event: InputEvent) -> void:
	if _ref_MainScene._game_paused == true:
		return

	# print("pc: {0}".format([_pc]))
	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var x: int = source[0]
	var y: int = source[1]
	var distance = 1
	var dir: String

	if _is_charge_primed:
		distance = 2

	if _is_move_input(event):
		if event.is_action_pressed(_new_InputName.MOVE_LEFT) && !event.is_echo():
			dir = _new_InputName.MOVE_LEFT
		elif event.is_action_pressed(_new_InputName.MOVE_RIGHT) && !event.is_echo():
			dir = _new_InputName.MOVE_RIGHT
		elif event.is_action_pressed(_new_InputName.MOVE_UP) && !event.is_echo():
			dir = _new_InputName.MOVE_UP
		elif event.is_action_pressed(_new_InputName.MOVE_DOWN) && !event.is_echo():
			dir = _new_InputName.MOVE_DOWN
	elif _is_reload_input(event):
		print("reload")
	else:
		return

	await _try_move(x, y, distance, dir)
	await _after_move()
	_trigger_end_turn()

func _trigger_end_turn():
	_is_charge_primed = false
	if _trigger_next_level:
		_trigger_next_level = false
		next_level.emit()
	else:
		_ref_Schedule.end_turn()

func _is_move_input(event):
	if (event.is_action_pressed(_new_InputName.MOVE_LEFT)
		|| event.is_action_pressed(_new_InputName.MOVE_RIGHT)
		|| event.is_action_pressed(_new_InputName.MOVE_UP)
		|| event.is_action_pressed(_new_InputName.MOVE_DOWN)
	):
		if !event.is_echo():
			return true
	return false

func _is_reload_input(event):
	if event.is_action_pressed(_new_InputName.RELOAD):
		return true
	return false

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)
	else:
		# print(current_sprite.name)
		pass

func _try_move(x: int, y: int, distance: int, dir: String) -> void:
	var awaited
	print(x, y)

	if dir == _new_InputName.MOVE_LEFT:
		for i in range(1, distance + 1):
			awaited = await _try_singular_move(x - i, y)
			if (!awaited):
				break
	elif dir == _new_InputName.MOVE_RIGHT:
		for i in range(1, distance + 1):
			awaited = await _try_singular_move(x + i, y)
			if (!awaited):
				break
	elif dir == _new_InputName.MOVE_UP:
		for i in range(1, distance + 1):
			awaited = await _try_singular_move(x, y - i)
			if (!awaited):
				break
	elif dir == _new_InputName.MOVE_DOWN:
		for i in range(1, distance + 1):
			awaited = await _try_singular_move(x, y + i)
			if (!awaited):
				break

	var pc_array = _new_ConvertCoord.vector_to_array(_pc.position)
	var pc_x = pc_array[0]
	var pc_y = pc_array[1]

	if _ref_DungeonBoard.has_sprite(_new_GroupName.LADDER, pc_x, pc_y):
		_trigger_next_level = true

func _after_move():
	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var x: int = source[0]
	var y: int = source[1]

	var slash_radius = 1
	if _is_charge_primed:
		slash_radius = 2
	# after moving PC tries to attack dwarves in range
	for a in range(x - slash_radius, x + slash_radius + 1):
		for b in range(y - slash_radius, y + slash_radius + 1):
			if _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, a, b):
				print('attacking dwarf after move')
				await get_node(PC_ATTACK).attack(_new_GroupName.DWARF, a, b)

func _try_singular_move(x: int, y: int):
	print(x, y)
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		pc_moved.emit("Cannot leave dungeon.")
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		pc_moved.emit("Cannot pass wall.")
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, x, y):
		set_process_unhandled_input(false)
		await get_node(PC_ATTACK).attack(_new_GroupName.DWARF, x, y)
		return false
	else:
		set_process_unhandled_input(false)
		_ref_DungeonBoard.update_sprite_position(_pc, x, y)
		return true

