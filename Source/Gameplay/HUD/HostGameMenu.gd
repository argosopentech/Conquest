extends Control

onready var host_button = $Host/Info/HMenu/Host
onready var cancel_button = $Host/Info/HMenu/Cancel

onready var lobby_name = $Host/Info/LobbyName
onready var lobby_players = $Host/Info/PlayersRange
onready var lobby_pass = $Host/Info/LobbyPassword

func _on_Cancel_pressed():
	get_tree().change_scene("res://Source/Main/Main.tscn")


func _on_Host_pressed():
	host_button.disabled = true
	cancel_button.disabled = true
	
	var lobby_data = {
		"code": null,
		"name": lobby_name.text,
		"pass": lobby_pass.text,
		"max_players": lobby_players.value,
		"players": {}
	}
	
	Server.create_lobby(lobby_data)
