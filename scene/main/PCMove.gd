extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const MainScene := preload("res://scene/main/MainScene.gd")
const InitLevel := preload("res://scene/main/InitLevel.gd")
const Shop := preload("res://scene/main/Shop.gd")
const PC_ATTACK: String = "PCAttack"

@onready var trap := preload("res://sprite/Trap.tscn") as PackedScene

var _new_InputName := preload("res://library/InputName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_Skills := preload("res://library/Skills.gd").new()

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_MainScene: MainScene
var _ref_InitLevel: InitLevel
var _ref_Shop: Shop
var _pc: Sprite2D
var _trigger_next_level: bool = false
var _is_charge_primed: bool = false
var _is_trap_primed: bool = false
var _is_invisibility_primed: bool = false
var _is_shuriken_primed: bool = false
var _is_teleport_primed: bool = false
var _did_kill: bool = false

signal pc_moved(message)
signal next_level()
signal turn_invisible(turns: int)
signal visit_shrine()
signal teleport_kill
signal display_message(message)

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

func _on_Trap_skill_primed():
	_is_trap_primed = true

func _on_Trap_skill_unprimed():
	_is_trap_primed = false

func _on_Invisibility_skill_primed():
	_is_invisibility_primed = true

func _on_Invisibility_skill_unprimed():
	_is_invisibility_primed = false

func _on_Shuriken_skill_primed():
	_is_shuriken_primed = true

func _on_Shuriken_skill_unprimed():
	_is_shuriken_primed = false

func _on_Teleport_skill_primed():
	_is_teleport_primed = true

func _on_Teleport_skill_unprimed():
	_is_teleport_primed = false

func _unhandled_input(event: InputEvent) -> void:
	if _ref_MainScene._game_paused == true:
		return

	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var x: int = source[0]
	var y: int = source[1]
	var distance = 1
	var dir: String

	if _pc._is_invisible and _ref_Shop.has_skill(_new_Skills.SKILL_INVISIBILITY_5):
		distance = 2

	if _is_charge_primed:
		distance = 2
		if _ref_Shop.has_skill(_new_Skills.SKILL_CHARGE_3):
			distance = 3

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
		return
	else:
		return

	if _is_trap_primed:
		lay_trap(x, y)

	if _is_invisibility_primed:
		var invisibility_turns = 3
		if _ref_Shop.has_skill(_new_Skills.SKILL_INVISIBILITY_2):
			invisibility_turns = 4
		_pc.turn_invisible(invisibility_turns)
		display_message.emit("Turned inivisble!")

	if _is_teleport_primed:
		var vector = _ref_DungeonBoard.get_teleport_destination()
		var teleport_array = _new_ConvertCoord.vector_to_array(vector)
		if _ref_Shop.has_skill(_new_Skills.SKILL_TELEPORT_4):
			for a in range(x - 1, x + 2):
				for b in range(y - 1, y + 2):
					await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, a, b, 1)
		try_teleport(teleport_array[0], teleport_array[1])
	else:
		await _try_move(x, y, distance, dir)

	await _after_move()
	_trigger_end_turn()

func _trigger_end_turn():
	_is_charge_primed = false
	_is_trap_primed = false
	_is_shuriken_primed = false
	_is_teleport_primed = false
	_is_invisibility_primed = false
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
	# this is hacky. please connect this to signals properly
	_pc._on_Schedule_turn_started(current_sprite)
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)
	else:
		# print(current_sprite.name)
		pass

func _try_move(x: int, y: int, distance: int, dir: String) -> void:
	var awaited

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
	if _ref_Shop.has_skill(_new_Skills.SKILL_ATTACK_1):
		slash_radius = 2
	var damage = 1
	if _ref_Shop.has_skill(_new_Skills.SKILL_ATTACK_3):
		damage = 2
		# after moving PC tries to attack dwarves in range in circular arc
	display_message.emit("Sword sweep!")
	for a in range(x - slash_radius, x + slash_radius + 1):
		for b in range(y - slash_radius, y + slash_radius + 1):
			if _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, a, b):
				if (abs(x - a) + abs(y - b)) <= slash_radius:
					await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, a, b, damage)

	if _is_charge_primed and _ref_Shop.has_skill(_new_Skills.SKILL_CHARGE_1):
		var stomp_radius = 2
		if _ref_Shop.has_skill(_new_Skills.SKILL_CHARGE_4):
			stomp_radius = 3
		display_message.emit("Stomp attack after charge!")
		for a in range(x - stomp_radius, x + stomp_radius + 1):
			for b in range(y - stomp_radius, y + stomp_radius + 1):
				if _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, a, b):
					await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, a, b)

	if _is_shuriken_primed:
		var throws = 1
		if _ref_Shop.has_skill(_new_Skills.SKILL_SHURIKEN_4):
			throws = 2
		for i in range(0, throws):
			var range = 3
			if _ref_Shop.has_skill(_new_Skills.SKILL_SHURIKEN_2):
				range = 4
			var enemy = _ref_DungeonBoard._get_closest_enemy_in_range(x, y, range)
			if enemy is Sprite2D:
				var enemyPos = _new_ConvertCoord.vector_to_array(enemy.position)
				await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, enemyPos[0], enemyPos[1])
				pc_moved.emit("Threw Shuriken at " + enemy.name)
				# bounce once
				if _ref_Shop.has_skill(_new_Skills.SKILL_SHURIKEN_5):
					var enemy2 = _ref_DungeonBoard._get_closest_enemy_in_range(enemyPos[0], enemyPos[1], range)
					if enemy is Sprite2D:
						var enemy2Pos = _new_ConvertCoord.vector_to_array(enemy.position)
						await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, enemy2Pos[0], enemy2Pos[1])
						pc_moved.emit("Shuriken bounced to " + enemy2.name)

	if _ref_DungeonBoard.has_sprite(_new_GroupName.SHRINE, x, y):
		visit_shrine.emit()

func _try_singular_move(x: int, y: int):
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		pc_moved.emit("Cannot leave dungeon.")
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		pc_moved.emit("Cannot pass wall.")
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y):
		var damage = 1
		if _ref_Shop.has_skill(_new_Skills.SKILL_ATTACK_2):
			damage = 2
		set_process_unhandled_input(false)
		await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, x, y, damage)
		return false
	else:
		set_process_unhandled_input(false)
		_ref_DungeonBoard.update_sprite_position(_pc, x, y)
		return true

func lay_trap(x, y):
	_ref_InitLevel._create_sprite(trap, [_new_GroupName.TRAP], x, y)
	display_message.emit("Laid down a trap.")

func try_teleport(x, y):
	display_message.emit("Teleporting!")
	_did_kill = false
	_ref_DungeonBoard.update_sprite_position(_pc, x, y)
	if _ref_Shop.has_skill(_new_Skills.SKILL_TELEPORT_2):
		for a in range(x - 2, x + 3):
			for b in range(y - 2, y + 3):
				var damage = 1
				var enemy = _ref_DungeonBoard.get_sprite(_new_GroupName.ENEMY, a, b)
				if _ref_Shop.has_skill(_new_Skills.SKILL_TELEPORT_5) and !enemy.is_in_group(_new_GroupName.DEMON):
					damage = 999
				await get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, a, b, damage)

	if _did_kill and _ref_Shop.has_skill(_new_Skills.SKILL_TELEPORT_3):
		teleport_kill.emit()
		display_message.emit("Teleport killed enemies - cooldown reset")

func _on_PCAttack_pc_attacked(msg):
	_did_kill = true
