extends Control

onready var host_button = $Host/Info/HMenu/Host
onready var cancel_button = $Host/Info/HMenu/Cancel

onready var lobby_name = $Host/Info/LobbyName
onready var lobby_players = $Host/Info/PlayersRange
onready var lobby_pass = $Host/Info/LobbyPassword

func _ready():
	Server.connect("lobby_created_signal", self, "lobby_created")

func lobby_created(lobby_data):
	get_tree().change_scene("res://Source/Gameplay/HUD/Lobby.tscn")

func _on_Cancel_pressed():
	get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_Host_pressed():
	host_button.disabled = true
	cancel_button.disabled = true
	
	var players_list = {}
	
	var player_dictionary = {
		"id": null,
		"name": null,
		"color": null,
		"host": true
	}
	
	for i in range(lobby_players.value):
		players_list[Server.player_id] = player_dictionary
	
	var lobby_data = {
		"code": null,
		"name": lobby_name.text,
		"pass": lobby_pass.text,
		"max_players": lobby_players.value,
		"current_players": 0,
		"players": players_list
	}
	
	Server.create_lobby(lobby_data)
