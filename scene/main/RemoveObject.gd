extends Node2D

signal sprite_removed(remove_sprite, group_name, x, y)

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove(group_name: String, x: int, y: int) -> void:
	var sprite: Sprite2D = _ref_DungeonBoard.get_sprite(group_name, x, y)

	sprite_removed.emit(sprite, group_name, x, y)
	sprite.queue_free()
