extends Node

class_name StateMachine

var player_states = {
	"placement": load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd"),
	"attack": load("res://Source/Gameplay/StateMachine/PlayerStates/AttackState.gd"),
	"draft": load("res://Source/Gameplay/StateMachine/PlayerStates/DraftState.gd"),
	"fortify": load("res://Source/Gameplay/StateMachine/PlayerStates/FortifyState.gd"),
}

var country_states = {
	"in_active": load("res://Source/Gameplay/StateMachine/CountryStates/InActiveState.gd"),
	"active": load("res://Source/Gameplay/StateMachine/CountryStates/ActiveState.gd"),
	"selected": load("res://Source/Gameplay/StateMachine/CountryStates/SelectedState.gd"),
}

func enter(player):
	pass

func handle_input(player, input: InputEvent):
	return null

func update(player):
	pass

func exit(player):
	pass
