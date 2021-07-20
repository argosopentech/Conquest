extends StateMachine

class_name PlayerState

var player_states = {
	"placement": load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd"),
	"attack": load("res://Source/Gameplay/StateMachine/PlayerStates/AttackState.gd"),
	"draft": load("res://Source/Gameplay/StateMachine/PlayerStates/DraftState.gd"),
	"fortify": load("res://Source/Gameplay/StateMachine/PlayerStates/FortifyState.gd"),
}

func enter(player: Player):
	.enter(player)

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	pass

func all_troops_placed(player: Player):
	pass

func go_pressed(player: Player):
	pass

func player_attacked(player: Player, win_chance_percentage, troops: int, player_country: Country, opponent_country: Country):
	pass

func troops_moved(player: Player, troops: int, source_country: Country, destination_country: Country):
	pass

func change_player_state(player: Player, state_name = ""):
	pass

func get_state_name():
	return "player_state"
