extends StateMachine

class_name PlayerState

var player_states = {
	"placement": load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd"),
	"attack": load("res://Source/Gameplay/StateMachine/PlayerStates/AttackState.gd"),
	"draft": load("res://Source/Gameplay/StateMachine/PlayerStates/DraftState.gd"),
	"fortify": load("res://Source/Gameplay/StateMachine/PlayerStates/FortifyState.gd"),
}

func enter(player: Player):
	pass

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	pass

func country_clicked(player: Player, country: Country):
	pass