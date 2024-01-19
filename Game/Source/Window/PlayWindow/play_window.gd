class_name PlayWindow extends Panel

@onready var game_modes: HBoxContainer = $MarginContainer/VBoxContainer/GameModes

var selected_game_mode: String = "OfflineMode"

func _ready():
	connect_signals()

func connect_signals():
	for game_mode: VBoxContainer in game_modes.get_children():
		game_mode.get_node("Select").pressed.connect(_on_game_mode_selected.bind(str(game_mode.name)))

func _on_game_mode_selected(game_mode_name: StringName):
	game_modes.get_node(selected_game_mode + "/Select").text = "SELECT"
	selected_game_mode = game_mode_name
	game_modes.get_node(selected_game_mode + "/Select").text = "SELECTED"
