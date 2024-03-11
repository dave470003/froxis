extends PanelContainer

@onready var popupOption := preload("res://scene/gui/PopupOptionPanel1.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		popup_option.setup_callable(Callable(self, "callback"), [popup_options[i][2], popup_options[i][3]])
		get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

func callback(args):
	var outer_callback = args[0]
	var outer_args = args[1]
	outer_callback.callv(outer_args)
	self.queue_free()
