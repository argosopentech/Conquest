extends TextureRect

class_name AttackingMenu

onready var player_icon = $Info/Players/Player/IconBorder/Icon
onready var player_name_label = $Info/Players/Player/Name
onready var player_country_label = $Info/Players/Player/Country
onready var player_troops_label = $Info/Players/Player/Troops

onready var opponent_icon = $Info/Players/Opponent/IconBorder/Icon
onready var opponent_name_label = $Info/Players/Opponent/Name
onready var opponent_country_label = $Info/Players/Opponent/Country
onready var opponent_troops_label = $Info/Players/Opponent/Troops

onready var troops_range = $Info/TroopsRange

var player_country: Country = null
var opponent_country: Country = null

var player_troop_count = 0
var opponent_troop_count = 0

signal attacked

func _ready():
	attack_details()

func attack_details(pc: Country = null, oc: Country = null):
	var troops = 0
	if pc == null:
		troops = 8
		troops_range.max_value = troops - 1
		troops_range.value = troops
		player_troops_label.text = str(troops)
	
	player_country = pc
	opponent_country = oc
	
	if player_country:
		player_country_label.text = player_country.get_name()
		troops_range.max_value = player_country.troops - 1
		troops_range.value = troops_range.max_value
		player_troops_label.text = str(player_country.troops)
		if GamePlay.online:
			player_name_label.text = Server.my_lobby.players[int(player_country.occupier.name)].name
			player_icon.color = Server.my_lobby.players[int(player_country.occupier.name)].color
		else:
			player_name_label.text = GamePlay.players_data[player_country.occupier.name].name
			player_icon.color = GamePlay.players_data[player_country.occupier.name].color
#		player_icon.color = GamePlay.colors[str(int(player_country.occupier.name) + 1)]
	if opponent_country:
		opponent_country_label.text = opponent_country.get_name()
		opponent_troops_label.text = str(opponent_country.troops)
		if GamePlay.online:
			opponent_name_label.text = Server.my_lobby.players[int(opponent_country.occupier.name)].name
			opponent_icon.color = Server.my_lobby.players[int(opponent_country.occupier.name)].color
		else:
			opponent_name_label.text = GamePlay.players_data[opponent_country.occupier.name].name
			opponent_icon.color = GamePlay.players_data[opponent_country.occupier.name].color
#		opponent_icon.color = GamePlay.colors[str(int(opponent_country.occupier.name) + 1)]

	value_changed(troops_range.value)

func cancel():
	GamePlay.game.active_player.overlay.hide()
	hide()

func attack():
	emit_signal("attacked", player_troop_count, opponent_troop_count, player_country, opponent_country)
	player_country = null
	opponent_country = null
	hide()

func value_changed(value):
	if value == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"
	count_troops(value)

func count_troops(troops):
	player_troop_count = troops
	if opponent_country:
		opponent_troop_count = opponent_country.troops

