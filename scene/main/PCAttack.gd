extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const Shop := preload("res://scene/main/Shop.gd")

var _new_Colours := preload("res://library/Colours.gd").new()
var _new_Skills := preload("res://library/Skills.gd").new()
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule
var _ref_Shop: Shop

signal pc_attacked
signal turn_visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(group_name: String, x: int, y: int, damage: int = 1) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	var sprite = _ref_DungeonBoard.get_sprite(group_name, x, y)
	var groups = sprite.get_groups()
	await _animate_sprite_injury(sprite)
	sprite.remove_health(damage)
	if sprite._health <= 0:
		for i in range(0, groups.size()):
			await _ref_RemoveObject.remove(groups[i], x, y)
		if !_ref_Shop.has_skill(_new_Skills.SKILL_INVISIBILITY_4):
			var _pc = _ref_Schedule.get_pc()
			#remove bad code
			_pc._on_PCAttack_turn_visible()
		pc_attacked.emit("You killed the enemy.")

func _animate_sprite_injury(sprite: Sprite2D):
	var tween = sprite.create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "modulate", Color(_new_Colours.LIGHT_GREY), 0.2)
	await tween.finished
