extends Node

var players = 3
var colors = {
	"1": Color.orange,
	"2": Color.lightblue,
	"3": Color.yellow,
	"4": Color.lightsalmon,
	"5": Color.lightgreen,
	"6": Color.lightcoral
}
var total_countries_in_continents = {
	"NorthAmerica": 9,
	"SouthAmerica": 4,
	"Europe": 7,
	"Africa": 6,
	"Asia": 12,
	"Australia": 4
}

var bordering_countries = {
	"Afghanistan": ["China", "India", "MiddleEast", "Ukraine", "Ural"],
	"Alaska": ["Kamchatka", "NorthwestTerritory", "Alberta"],
	"Alberta": ["Alaska", "NorthwestTerritory", "Ontario", "WesternUnitedStates"],
	"Argentina": ["Brazil", "Peru"],
	"Brazil": ["NorthAfrica", "Argentina", "Peru", "Venezuela"],
	"CentralAmerica": ["EasternUnitedStates", "WesternUnitedStates", "Venezuela"],
	"China": ["India", "Afghanistan", "Mongolia", "Siberia", "Ural", "Siam"],
	"Congo": ["NorthAfrica", "EastAfrica", "SouthAfrica"],
	"EastAfrica": ["NorthAfrica", "Congo", "SouthAfrica", "Madagascar", "Egypt"],
	"EasternAustralia": ["NewGuinea", "WesternAustralia"],
	"EasternUnitedStates": ["WesternUnitedStates", "CentralAmerica", "Ontario", "Quebec"],
	"Egypt": ["NorthAfrica", "EastAfrica", "MiddleEast", "SouthernEurope"],
	"GreatBritain": ["WesternEurope", "NorthernEurope", "Iceland", "Scandinavia"],
	"Greenland": ["Quebec", "NorthwestTerritory", "Iceland", "Ontario"],
	"Iceland": ["GreatBritain", "Scandinavia", "Greenland"],
	"India": ["Afghanistan", "China", "MiddleEast", "Siam"],
	"Indonesia": ["NewGuinea", "WesternAustralia", "Siam"],
	"Irkutsk": ["Mongolia", "Siberia", "Yakutsk", "Kamchatka"],
	"Japan": ["Mongolia", "Kamchatka"],
	"Kamchatka": ["Mongolia", "Japan", "Yakutsk", "Irkutsk", "Alaska"],
	"Madagascar": ["SouthAfrica", "EastAfrica"],
	"MiddleEast": ["Egypt", "EastAfrica", "SouthernEurope", "Ukraine", "Afghanistan", "India"],
	"Mongolia": ["China", "Japan", "Siberia", "Irkutsk", "Kamchatka"],
	"NewGuinea": ["WesternAustralia", "EasternAustralia", "Indonesia"],
	"NorthAfrica": ["Brazil", "Congo", "EastAfrica", "Egypt", "SouthernEurope", "WesternEurope"],
	"NorthernEurope": ["GreatBritain", "Ukraine", "Scandinavia", "SouthernEurope", "WesternEurope"],
	"NorthwestTerritory": ["Alaska", "Greenland", "Alberta", "Ontario"],
	"Ontario": ["Quebec", "NorthwestTerritory", "Alberta", "Greenland", "WesternUnitedStates", "EasternUnitedStates"],
	"Peru": ["Argentina", "Brazil", "Venezuela"],
	"Quebec": ["EasternUnitedStates", "Ontario", "Greenland"],
	"Scandinavia": ["Iceland", "GreatBritain", "Ukraine", "NorthernEurope"],
	"Siam": ["Indonesia", "India", "China"],
	"Siberia": ["Irkutsk", "Mongolia", "China", "Yakutsk", "Ural"],
	"SouthAfrica": ["Congo", "EastAfrica", "Madagascar"],
	"SouthernEurope": ["Egypt", "NorthAfrica", "MiddleEast", "Ukraine", "NorthernEurope", "WesternEurope"],
	"Ukraine": ["Afghanistan", "Scandinavia", "MiddleEast", "Ural", "NorthernEurope", "SouthernEurope"],
	"Ural": ["Afghanistan", "China", "Siberia", "Ukraine"],
	"Venezuela": ["Brazil", "Peru", "CentralAmerica"],
	"WesternAustralia": ["EasternAustralia", "NewGuinea", "Indonesia"],
	"WesternEurope": ["NorthAfrica", "GreatBritain", "NorthernEurope", "SouthernEurope"],
	"WesternUnitedStates": ["Alberta", "Ontario", "EasternUnitedStates", "CentralAmerica"],
	"Yakutsk": ["Kamchatka", "Irkutsk", "Siberia"],
}

var bordering_countries_nodes = {
	"Afghanistan": ["China", "India", "MiddleEast", "Ukraine", "Ural"],
	"Alaska": ["Kamchatka", "NorthwestTerritory", "Alberta"],
	"Alberta": ["Alaska", "NorthwestTerritory", "Ontario", "WesternUnitedStates"],
	"Argentina": ["Brazil", "Peru"],
	"Brazil": ["NorthAfrica", "Argentina", "Peru", "Venezuela"],
	"CentralAmerica": ["EasternUnitedStates", "WesternUnitedStates", "Venezuela"],
	"China": ["India", "Afghanistan", "Mongolia", "Siberia", "Ural", "Siam"],
	"Congo": ["NorthAfrica", "EastAfrica", "SouthAfrica"],
	"EastAfrica": ["NorthAfrica", "Congo", "SouthAfrica", "Madagascar", "Egypt"],
	"EasternAustralia": ["NewGuinea", "WesternAustralia"],
	"EasternUnitedStates": ["WesternUnitedStates", "CentralAmerica", "Ontario", "Quebec"],
	"Egypt": ["NorthAfrica", "EastAfrica", "MiddleEast", "SouthernEurope"],
	"GreatBritain": ["WesternEurope", "NorthernEurope", "Iceland", "Scandinavia"],
	"Greenland": ["Quebec", "NorthwestTerritory", "Iceland", "Ontario"],
	"Iceland": ["GreatBritain", "Scandinavia", "Greenland"],
	"India": ["Afghanistan", "China", "MiddleEast", "Siam"],
	"Indonesia": ["NewGuinea", "WesternAustralia", "Siam"],
	"Irkutsk": ["Mongolia", "Siberia", "Yakutsk", "Kamchatka"],
	"Japan": ["Mongolia", "Kamchatka"],
	"Kamchatka": ["Mongolia", "Japan", "Yakutsk", "Irkutsk", "Alaska"],
	"Madagascar": ["SouthAfrica", "EastAfrica"],
	"MiddleEast": ["Egypt", "EastAfrica", "SouthernEurope", "Ukraine", "Afghanistan", "India"],
	"Mongolia": ["China", "Japan", "Siberia", "Irkutsk", "Kamchatka"],
	"NewGuinea": ["WesternAustralia", "EasternAustralia", "Indonesia"],
	"NorthAfrica": ["Brazil", "Congo", "EastAfrica", "Egypt", "SouthernEurope", "WesternEurope"],
	"NorthernEurope": ["GreatBritain", "Ukraine", "Scandinavia", "SouthernEurope", "WesternEurope"],
	"NorthwestTerritory": ["Alaska", "Greenland", "Alberta", "Ontario"],
	"Ontario": ["Quebec", "NorthwestTerritory", "Alberta", "Greenland", "WesternUnitedStates", "EasternUnitedStates"],
	"Peru": ["Argentina", "Brazil", "Venezuela"],
	"Quebec": ["EasternUnitedStates", "Ontario", "Greenland"],
	"Scandinavia": ["Iceland", "GreatBritain", "Ukraine", "NorthernEurope"],
	"Siam": ["Indonesia", "India", "China"],
	"Siberia": ["Irkutsk", "Mongolia", "China", "Yakutsk", "Ural"],
	"SouthAfrica": ["Congo", "EastAfrica", "Madagascar"],
	"SouthernEurope": ["Egypt", "NorthAfrica", "MiddleEast", "Ukraine", "NorthernEurope", "WesternEurope"],
	"Ukraine": ["Afghanistan", "Scandinavia", "MiddleEast", "Ural", "NorthernEurope", "SouthernEurope"],
	"Ural": ["Afghanistan", "China", "Siberia", "Ukraine"],
	"Venezuela": ["Brazil", "Peru", "CentralAmerica"],
	"WesternAustralia": ["EasternAustralia", "NewGuinea", "Indonesia"],
	"WesternEurope": ["NorthAfrica", "GreatBritain", "NorthernEurope", "SouthernEurope"],
	"WesternUnitedStates": ["Alberta", "Ontario", "EasternUnitedStates", "CentralAmerica"],
	"Yakutsk": ["Kamchatka", "Irkutsk", "Siberia"],
}

var game: Game
var music = preload("res://Assets/Audio/loops/mixkit-sports-highlights-51.mp3")
var music_player: AudioStreamPlayer
var main_menu_volume = -25
var in_game_volume = -35
var interface_sound = true
var country_sound = true
var online: bool = true
var number_of_players: int = 2
var players_data_template = {
	"0": {
		"name": "Player 1",
		"color": Color.orange,
	},
	"1": {
		"name": "Player 2",
		"color": Color.lightblue,
	},
	"2": {
		"name": "Player 3",
		"color": Color.yellow,
	},
	"3": {
		"name": "Player 4",
		"color": Color.lightsalmon,
	},
	"4": {
		"name": "Player 5",
		"color": Color.lightgreen,
	},
	"5": {
		"name": "Player 6",
		"color": Color.lightcoral,
	},
}
var players_data = players_data_template
func _ready():
	setup()

func setup():
	setup_music()

func setup_music():
	music_player = AudioStreamPlayer.new()
	music_player.stream = music
	add_child(music_player)
	music_player.play()
	set_music_volume(main_menu_volume)

func set_music_volume(volume):
	music_player.volume_db = volume
