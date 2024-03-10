extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const PC_ATTACK: String = "PCAttack"

var _new_InputName := preload("res://library/InputName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _pc: Sprite2D

signal pc_moved(message)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_InitWorld_sprite_created(sprite: Sprite2D):
	if sprite.is_in_group(_new_GroupName.PC):
		_pc = sprite
		set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	# print("pc: {0}".format([_pc]))
	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var x: int = source[0]
	var y: int = source[1]

	if _is_move_input(event):
		if event.is_action_pressed(_new_InputName.MOVE_LEFT) && !event.is_echo():
			x -= 1
		elif event.is_action_pressed(_new_InputName.MOVE_RIGHT) && !event.is_echo():
			x += 1
		elif event.is_action_pressed(_new_InputName.MOVE_UP) && !event.is_echo():
			y -= 1
		elif event.is_action_pressed(_new_InputName.MOVE_DOWN) && !event.is_echo():
			y += 1
	elif _is_reload_input(event):
		print("reload")
	else:
		return

	await _try_move(x,y)
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

func _try_move(x: int, y: int) -> void:
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		pc_moved.emit("Cannot leave dungeon.")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		pc_moved.emit("Cannot pass wall.")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, x, y):
		set_process_unhandled_input(false)
		await get_node(PC_ATTACK).attack(_new_GroupName.DWARF, x, y)
	else:
		set_process_unhandled_input(false)
		_ref_DungeonBoard.update_sprite_position(_pc, x, y)
		# after moving PC tries to attack dwarves in range
		for a in range(x-1, x+2):
			for b in range(y-1, y+2):
				if _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, a, b):
					print('attacking dwarf after move')
					await get_node(PC_ATTACK).attack(_new_GroupName.DWARF, a, b)

