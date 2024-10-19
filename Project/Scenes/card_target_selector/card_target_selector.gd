extends Node2D

const ARC_POINTS := 8

@onready var area_2d : Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: CardUI
var targeting := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)

func _process(_delta: float) -> void:
	if not targeting:
		return
		
	area_2d.position = get_local_mouse_position()
	card_arc.points = _get_points()
	
func _get_points() -> Array:
	var points := []
	var start := current_card.global_position
	start.x += (current_card.size.x/2)
	var target := get_local_mouse_position()
	var distance := (target - start)
	
	#loop for range of arc points
	for i in range(ARC_POINTS):
		var t := (1.0/ ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	
	points.append(target)
	
	return points
	
func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)

func _on_card_aim_started(card: CardUI) -> void:
	#check if card is single targeted, if it is not you should not engage in aiming -> return
	if not card.card.is_single_targeted():
		return
	#but if it is then set targeting, monitoring and monitorable to true
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	#set current_card to the card being passed on to this signal
	current_card = card

func _on_card_aim_ended(_card: CardUI) -> void:
	#when card aiming has ended set targeting to false
	targeting = false
	#clear points to arc so line disappears
	card_arc.clear_points()
	#set area 2d back to topleft corner of the screen
	area_2d.position = Vector2.ZERO
	#set monitoring and monitorable to false
	area_2d.monitoring = false
	area_2d.monitorable = false
	#then empty variable current_card to null
	current_card = null

#to determine whether you are properly targeting an enemy or not
func _on_area_2d_area_entered(area: Area2D) -> void:
	#check if we have a current card or in the middle of a targeting process
	if not current_card or not targeting:
		return
	#if we have a current card and we are targeting and the targets array does not have enemy yet
	if not current_card.targets.has(area):
		#append it to the valid targets
		current_card.targets.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	current_card.targets.erase(area)
	
