extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Shop := preload("res://scene/main/Shop.gd")

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Shop: Shop
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_Colours := preload("res://library/Colours.gd").new()
var _new_Skills := preload("res://library/Skills.gd").new()

signal enemy_warned
signal enemy_attack
signal display_message(message)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(_new_GroupName.ENEMY):
		return

	var _pc = _ref_Schedule._actors[0]

	if !_pc._is_invisible:
		var movements = current_sprite._move_speed
		for i in range(0, movements):
			move_to_pc(_pc, current_sprite)
			if await check_for_traps(current_sprite) and _ref_Shop.has_skill(_new_Skills.SKILL_TRAP_5):
				display_message.emit("Trap stuns {0}!".format([current_sprite._name]))
				_ref_Schedule.end_turn()
				return
		if (current_sprite._health > 0):
			if _pc_is_close(_pc, current_sprite):
				await _animate_enemy_attack(_pc, current_sprite)
				display_message.emit("{0} deals you damage!".format([current_sprite._name]))
				enemy_attack.emit(1)

	_ref_Schedule.end_turn()

func _pc_is_close(source: Sprite2D, target: Sprite2D) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x + delta_y <= target._attack_range and (delta_x == 0 or delta_y == 0)

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
		update_position(current, current_pos[0] - 1, current_pos[1])

func try_to_move(current_sprite, x, y):
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		return false
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y):
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
	if !_ref_Shop.has_skill(_new_Skills.SKILL_TRAP_4) and current.is_in_group(_new_GroupName.FLYING):
		display_message.emit("{0} flies over the trap.".format([current._name]))
		return false
	var current_pos: Array = _new_ConvertCoord.vector_to_array(current.position)
	if _ref_DungeonBoard.has_sprite(_new_GroupName.TRAP, current_pos[0], current_pos[1]):
		await trap_detonate(current_pos[0], current_pos[1], current)
		return true
	return false

func trap_detonate(x, y, current_sprite):
	var radius = 0
	if _ref_Shop.has_skill(_new_Skills.SKILL_TRAP_3):
		radius = 1
	display_message.emit("{0} detonates a trap!".format([current_sprite._name]))
	for a in range(x - radius, x + radius + 1):
		for b in range(y - radius, y + radius + 1):
			var sprite = _ref_DungeonBoard.get_sprite(_new_GroupName.ENEMY, a, b)
			if sprite == null:
				continue
			await _animate_sprite_injury(sprite)
			sprite.remove_health(1)
			display_message.emit("The trap deals damage to {0}".format([sprite._name]))
			if sprite._health <= 0:
				var groups = sprite.get_groups()
				for i in range(0, groups.size()):
					await _ref_RemoveObject.remove(groups[i], a, b)
	await _ref_RemoveObject.remove(_new_GroupName.TRAP, x, y)

func _animate_sprite_injury(sprite: Sprite2D):
	var tween = sprite.create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "modulate", Color(_new_Colours.LIGHT_GREY), 0.2)
	await tween.finished
