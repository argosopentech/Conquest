extends TextureRect

class_name OptionsMenu

onready var main_menu_slider = $Info/MainMenuVolume
onready var in_game_slider = $Info/InGameVolume
onready var interface_sound = $Info/InterfaceSFX/InterfaceCheckBox
onready var country_sound = $Info/CountrySFX/CountryCheckBox
onready var name_edit = $Info/NameEdit

var main_menu_volume = 75
var in_game_volume = 65
var interface_sound_on = true
var country_sound_on = true

signal options_saved

func _ready():
	setup()

func setup():
	setup_volume()
	setup_sliders()
	setup_sound_values()
	setup_sounds()
	setup_player_name()
	set_name_edit()

func set_name_edit():
	if get_owner().name == "Game":
		name_edit.editable = false

func setup_volume():
	main_menu_volume = 50 + GamePlay.main_menu_volume
	in_game_volume = 50 + GamePlay.in_game_volume

func setup_sliders():
	main_menu_slider.value = main_menu_volume
	in_game_slider.value = in_game_volume

func setup_sound_values():
	interface_sound_on = GamePlay.interface_sound
	country_sound_on = GamePlay.country_sound

func setup_sounds():
	interface_sound.pressed = interface_sound_on
	country_sound.pressed = country_sound_on

func setup_player_name():
	name_edit.text = Server.player_name

func cancel():
	if get_parent() is ColorRect:
		get_parent().hide()

func save():
	if get_parent() is ColorRect:
		get_parent().hide()
	GamePlay.main_menu_volume = main_menu_volume - 50
	GamePlay.in_game_volume = in_game_volume - 50
	GamePlay.interface_sound = interface_sound_on
	GamePlay.country_sound = country_sound_on
	if Server.connected and Server.player_name != name_edit.text:
		Server.player_name = name_edit.text
		Server.send_player_name()
	emit_signal("options_saved")

func _on_MainMenuVolume_value_changed(value):
	main_menu_volume = value

func _on_InGameVolume_value_changed(value):
	in_game_volume = value

func _on_InterfaceCheckBox_toggled(button_pressed):
	interface_sound_on = button_pressed

func _on_CountryCheckBox_toggled(button_pressed):
	country_sound_on = button_pressed
