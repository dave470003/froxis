extends PanelContainer

@onready var popupOption := preload("res://scene/gui/PopupOptionPanel1.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(popup_text, popup_options):
	var popup_text_node = get_node("PopupMargin/PopupText")
	popup_text_node.text = popup_text

	for i in range(0, popup_options.size()):
		var popup_option = popupOption.instantiate()
		popup_option.setup_trigger_char(popup_options[i][0])
		popup_option.get_node("PopupOptionMargin/PopupOption").text = popup_options[i][1]
		popup_option.setup_callable(Callable(self, "callback"), popup_options[i][2])
		get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

func callback(outer_callback: Callable):
	outer_callback.call()
	self.queue_free()
