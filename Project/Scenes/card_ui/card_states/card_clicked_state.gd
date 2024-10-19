extends CardState

#function for when entering the clicked state
func enter() ->  void:
	#will change the card ui, helpful for debugging
	card_ui.color.color = Color.ORANGE
	card_ui.state.text = "CLICKED"
	#drop point starts monitoring for purpose of tracking where card goes. this is used for detecting collision area
	card_ui.drop_point_detector.monitoring = true

#if the event is an input event mouse movement this will transition to a dragging state
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
