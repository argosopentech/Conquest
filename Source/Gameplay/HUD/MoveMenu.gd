extends TextureRect

class_name MoveMenu

onready var troops_range = $Info/TroopsRange
onready var source_country_label = $Info/SourceCountry
onready var destination_country_label = $Info/DestinationCountry
onready var left_margin = $Info/HMenu/MarginLeft
onready var cancel_button = $Info/HMenu/Cancel

var source_country: Country = null
var destination_country: Country = null

signal moved

func _ready():
	move_troops()

func move_troops(c1: Country = null, c2: Country = null, state = ""):
	if state == "Attack":
		left_margin.hide()
		cancel_button.hide()
	elif state == "Fortify":
		left_margin.show()
		cancel_button.show()
	source_country = c1
	destination_country = c2
	if source_country:
		troops_range.max_value = c1.troops - 1
		troops_range.value = troops_range.max_value
		value_changed(troops_range.value)
		source_country_label.text = "from " + source_country.get_name()
	if destination_country:
		destination_country_label.text = "to " + destination_country.get_name()

func cancel():
	GamePlay.game.active_player.overlay.hide()
	hide()

func move():
	emit_signal("moved", troops_range.value, source_country, destination_country)
	source_country = null
	destination_country = null
	hide()

func value_changed(value):
	if value == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"

