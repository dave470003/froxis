extends PanelContainer

var _pages
var _page_number
var _close_callback

@onready var popupOption := preload("res://scene/gui/PopupOptionPanel1.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_pages(pages, close_callback):
	_pages = pages
	_page_number = 0
	_close_callback = close_callback
	var popup_text_node = get_node("PopupMargin/PopupText")
	popup_text_node.text = _pages[_page_number]

	var popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_ESCAPE)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "ESC: Close"
	popup_option.setup_callable(Callable(self, "callback"), [_close_callback, []])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

	popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_N)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "n: Next Page"
	popup_option.setup_callable(Callable(self, "next_page"), [])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

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

func next_page(args):
	for n in get_node('PopupOptionsContainer/PopupOptions').get_children():
		get_node('PopupOptionsContainer/PopupOptions').remove_child(n)
		n.queue_free()
	_page_number = _page_number + 1

	var popup_text_node = get_node("PopupMargin/PopupText")
	popup_text_node.text = _pages[_page_number]

	var popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_ESCAPE)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "ESC: Close"
	popup_option.setup_callable(Callable(self, "callback"), [_close_callback, []])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

	popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_P)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "p: Prev Page"
	popup_option.setup_callable(Callable(self, "prev_page"), [])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

	if _page_number < _pages.size() - 1:
		popup_option = popupOption.instantiate()
		popup_option.setup_trigger_char(KEY_N)
		popup_option.get_node("PopupOptionMargin/PopupOption").text = "n: Next Page"
		popup_option.setup_callable(Callable(self, "next_page"), [])
		get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

func prev_page(args):
	for n in get_node('PopupOptionsContainer/PopupOptions').get_children():
		get_node('PopupOptionsContainer/PopupOptions').remove_child(n)
		n.queue_free()
	_page_number = _page_number - 1

	var popup_text_node = get_node("PopupMargin/PopupText")
	popup_text_node.text = _pages[_page_number]

	var popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_ESCAPE)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "ESC: Close"
	popup_option.setup_callable(Callable(self, "callback"), [_close_callback, []])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

	popup_option = popupOption.instantiate()
	popup_option.setup_trigger_char(KEY_N)
	popup_option.get_node("PopupOptionMargin/PopupOption").text = "n: Next Page"
	popup_option.setup_callable(Callable(self, "next_page"), [])
	get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

	if _page_number > 0:
		popup_option = popupOption.instantiate()
		popup_option.setup_trigger_char(KEY_P)
		popup_option.get_node("PopupOptionMargin/PopupOption").text = "p: Prev Page"
		popup_option.setup_callable(Callable(self, "prev_page"), [])
		get_node('PopupOptionsContainer/PopupOptions').add_child(popup_option)

