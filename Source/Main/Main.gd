extends Control

class_name Main

onready var ip_edit = $Server/IP
onready var error_label = $Error
onready var success_label = $Success

func _ready():
	connect_signals()
	setup()

func connect_signals():
	Server.connect("server_connected", self, "server_connected")
	Server.connect("server_disconnected", self, "server_not_connected")
	return
	get_tree().connect("connected_to_server", self, "server_connected")
	get_tree().connect("connection_failed", self, "server_not_connected")

func setup():
	setup_music()
	setup_server()
	setup_mode()

func setup_music():
	GamePlay.set_music_volume(GamePlay.main_menu_volume)

func setup_server():
	ip_edit.text = str(Server.SERVER_IP)
	if Server.connected:
		server_connected()
	else:
		server_not_connected()

func setup_mode():
	GamePlay.online = true

func options_saved():
	setup_music()

func _on_Connect_pressed(ip=ip_edit.text):
	if not ip:
		return
	Server.disconnect_server()
	server_not_connected()
	Server.SERVER_IP = ip
	Server.connect_to_server()

func server_connected():
	success_label.show()
	error_label.hide()
	get_node("MenuBorder/Menu/PlayOnline").disabled = false
	get_node("MenuBorder/Menu/Overlay/OptionsOverlay/OptionsMenu/Info/NameEdit").editable = true

func server_not_connected():
	success_label.hide()
	error_label.show()
	get_node("MenuBorder/Menu/PlayOnline").disabled = true
	get_node("MenuBorder/Menu/Overlay/OptionsOverlay/OptionsMenu/Info/NameEdit").editable = false


func _on_ResetIP_pressed():
	Server.SERVER_IP = Server.default_ip
	ip_edit.text = Server.SERVER_IP
