extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")

var _new_Colours := preload("res://library/Colours.gd").new()
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule

signal pc_attacked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(group_name: String, x: int, y: int) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	var sprite = _ref_DungeonBoard.get_sprite(group_name, x, y)
	await _animate_sprite_injury(sprite)
	await _ref_RemoveObject.remove(group_name, x, y)
	pc_attacked.emit("You killed the dwarf.")

func _animate_sprite_injury(sprite: Sprite2D):
	var tween = sprite.create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "modulate", Color(_new_Colours.LIGHT_GREY), 0.2)
	await tween.finished
