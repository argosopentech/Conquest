extends Control

var lobby_search_scene = preload("res://Source/Gameplay/HUD/LobbySearchInstance.tscn")

onready var lobbies_list = $TextureRect/Info/LobbiesContainer/Lobbies
onready var back_button = $Overlay/JoinCodeMenu/Background/Info/HMenu3/Cancel
onready var join_code_button = $TextureRect/Info/HMenu3/JoinCode
onready var refresh_button = $TextureRect/Info/HMenu3/Refresh
onready var join_code_menu = $Overlay/JoinCodeMenu
onready var error_label = $Overlay/Error

func _ready():
	error_label.hide()
	join_code_menu.hide()
	join_code_menu.connect("joining_lobby", self, "joining_lobby")
	Server.connect("got_active_lobbies_signal", self, "got_active_lobbies")
	Server.connect("failed_to_join_lobby_signal", self, "failed_to_join_lobby")
	Server.connect("lobby_updated_signal", self, "joined_lobby")
	
	_on_Refresh_pressed()

func _on_Cancel_pressed():
	get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_JoinCode_pressed():
	join_code_menu.show()

func _on_Refresh_pressed():
	Server.ask_for_active_lobbies()

func got_active_lobbies(lobbies):
	instance_lobby_search_scenes(lobbies)

func instance_lobby_search_scenes(lobbies: Dictionary):
	for child in lobbies_list.get_children():
		if child is LobbySearchInstance:
			child.queue_free()
	for lobby_code in lobbies.keys():
		var lobby_instance = lobby_search_scene.instance()
		lobby_instance.set_name(str(lobbies[lobby_code]))
		lobbies_list.add_child(lobby_instance)
		lobby_instance.connect("joining", self, "joining_lobby")
		lobby_instance.code_label.text = str(lobbies[lobby_code].code)
		lobby_instance.name_label.text = " " + str(lobbies[lobby_code].name)
		lobby_instance.players_label.text = str(lobbies[lobby_code].current_players) + "/" + str(lobbies[lobby_code].max_players)
		if not lobbies[lobby_code].pass:
			lobby_instance.pass_edit.placeholder_text = "none"
			lobby_instance.pass_edit.editable = false

func joining_lobby():
	disable_buttons()

func disable_buttons():
	for child in lobbies_list.get_children():
		if child is LobbySearchInstance:
			child.disable_join_button()
	back_button.disabled = true
	join_code_button.disabled = true
	refresh_button.disabled = true

func enable_buttons():
	for child in lobbies_list.get_children():
		if child is LobbySearchInstance:
			child.enable_join_button()
	back_button.disabled = false
	join_code_button.disabled = false
	refresh_button.disabled = false

func failed_to_join_lobby(reason = ""):
	error_label.text = reason
	error_label.show()
	enable_buttons()

func _on_ErrorTimer_timeout():
	error_label.hide()

func joined_lobby(lobby_data, reason):
	get_tree().change_scene("res://Source/Gameplay/HUD/Lobby.tscn")
