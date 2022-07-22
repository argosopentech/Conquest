extends Node2D

class_name PlayersQueue

var active_player = null
var active_index = -1

signal active_player_changed(active_index, active_player)

func _ready():
	setup()

func setup():
	connect_signals()
	play_first_turn()

func connect_signals():
	for child in get_children():
		if child.has_signal("turn_completed"):
			child.connect("turn_completed", self, "next_turn")

func play_first_turn():
	if get_child_count() > 0:
		next_turn(true)

func next_turn(net_call = false):
	active_index += 1
	if active_index >= get_child_count():
		active_index = 0
	active_player  = get_child(active_index)
	while active_player.eliminated:
		active_index += 1
		if active_index >= get_child_count():
			active_index = 0
		active_player  = get_child(active_index)
	active_player.set_active(true)
	emit_signal("active_player_changed", active_index, active_player)
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "next_turn")
