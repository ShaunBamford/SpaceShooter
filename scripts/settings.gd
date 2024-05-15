extends Control

@onready var resolutions_option_button = $Panel/OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	add_resolutions()
	update_button_values()
	
var resolutions = {
	"540x960": Vector2i(540, 960),
	"720x1280": Vector2i(720, 1280),
	"1080x1920": Vector2i(1080, 1920),
	"1440x2560": Vector2i(1440, 2560),
	"2160x3840": Vector2i(2160, 3840)
}



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Add resolutions to drop down menu
func add_resolutions():
	for r in resolutions:
		resolutions_option_button.add_item(r)
	
# Change resolution based on whats selected
func update_button_values():
	var window_size = str(get_window().size.x, "x", get_window().size.y, "y")
	var resolutions_index = resolutions.keys().find(window_size)
	resolutions_option_button.selected = resolutions_index

# Change resolution based on whats selected
func _on_option_button_item_selected(index):
	var key = resolutions_option_button.get_item_text(index)
	get_window().set_size(resolutions[key])
	centre_window()
	
# Centres window when resolution switched	
func centre_window():
	var screen_centre = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_centre - window_size / 2)

# Goes back to main menu when back button pressed
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
