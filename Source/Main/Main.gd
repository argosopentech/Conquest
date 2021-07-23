extends Control

class_name Main

onready var ip_edit = $Server/IP
onready var error_label = $Error
onready var success_label = $Success

func _ready():
	connect_signals()
	setup()

func connect_signals():
	get_tree().connect("connected_to_server", self, "server_connected")
	get_tree().connect("connection_failed", self, "server_not_connected")

func setup():
	setup_music()
	setup_server()

func setup_music():
	GamePlay.set_music_volume(GamePlay.main_menu_volume)

func setup_server():
	ip_edit.text = str(Server.SERVER_IP)
	if Server.connected:
		server_connected()
	else:
		server_not_connected()

func options_saved():
	setup_music()

func _on_Connect_pressed():
	if not ip_edit.text.is_valid_ip_address():
		return
	Server.disconnect_server()
	server_not_connected()
	Server.SERVER_IP = ip_edit.text
	Server.connect_to_server()

func server_connected():
	success_label.show()
	error_label.hide()
	get_node("MenuBorder/Menu/Play").disabled = false

func server_not_connected():
	success_label.hide()
	error_label.show()
	get_node("MenuBorder/Menu/Play").disabled = true
