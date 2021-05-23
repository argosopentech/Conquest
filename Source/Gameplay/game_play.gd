extends Node

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
	"Brazil": ["Argentina", "Peru", "Venezuela"],
	"CentralAmerica": ["EesternUnitedStates", "WesternUnitedStates", "Venezuela"],
	"China": ["India", "Afghanistan", "Mongolia", "Siberia", "Ural", "Siam"],
}

var game: Game

func _ready():
	pass
