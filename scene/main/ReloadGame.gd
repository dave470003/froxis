extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload() -> void:
	var new_scene: Node2D = load("res://scene/main/MainScene.gd").instance()
	var old_scene: Node2D = get_tree().current_scene

	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

	get_tree().root.remove_child(old_scene)
	old_scene.queue_free()
