#name for the class so its static throughout the project
class_name CardUI
extends Control

#Designed to reparent it depending on where you drag it
#Otherwise it will be restriced to its bounding box in the hbox container
signal reparent_requested(which_card_ui: CardUI)

@export var card:Card

#reference to ready variables
@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

var parent: Control
var tween: Tween

#initialize card state machine
func _ready() -> void:
	card_state_machine.init(self)

#call back functions to when certain inputs are met
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

#when we enter an area, check if target array has this area, if not append to the target area
func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

#when we exit an area we erase the area from current target area
func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
