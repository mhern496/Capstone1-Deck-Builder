extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "RELEASED"
	
	
	played = false
	
	#check if newly defined array for targets ui is empty or not, is there a valid target or not
	if not card_ui.targets.is_empty():
		played = true
		print("play card for target(s):", card_ui.targets)

#check if we played a card or not
func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
