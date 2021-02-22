extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var drumObject = preload("res://Scripts/drum.gd")

const LAST_TIME = 5000

const songFile = {
	"hits": {
		500: Enums.HitType.Blue,
		750: Enums.HitType.Red,
		1000: Enums.HitType.Blue,
		2000: Enums.HitType.Red,
		4000: Enums.HitType.Blue,
		LAST_TIME: Enums.HitType.Blue
	}
}

var elapsedTime = 0
var comboStreak = 0

const _score = {
	"overall": "",
	"good": 0.0,
	"ok": 0.0,
	"bad": 0.0,
	"maxCombo": 0.0,
	"accuracy": "",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	elapsedTime += 10
	_create_hit()
	$HitStream.position.x -= 5;
	_delete_node()
	
	if (elapsedTime == LAST_TIME + 2000):
		$Timer.stop()
		print('end of song')
	
func _has_hit(drumHit):
	var node = $HitStream.get_children()[0]
	print(node.global_position.x - 260)
	var goalXLate = $goal.global_position.x - 20
	var goalXEarly = $goal.global_position.x + 20
	if (node.global_position.x >= goalXLate && node.global_position.x <= goalXEarly):
		node.queue_free()
		update_combo_streak(1)
		
		$Hit.text = 'GOOD'
		_score.good += 1
		return true
		
	$Hit.text = 'BAD'
	_score.bad += 1
	update_combo_streak(0)
	return false

func update_combo_streak(comboValue):
	if comboValue == 0:
		comboStreak = 0
		return

	comboStreak += comboValue
	
	_score.maxCombo = max(_score.maxCombo, comboStreak)

func _input(event):
	var isRed = event.is_action_pressed("drum_red")
	var isBlue = event.is_action_pressed("drum_blue")
	if($HitStream.get_child_count() == 0):
		return
	
	if isRed:
		print(_has_hit(Enums.HitType.Red))
	if isBlue:
		print(_has_hit(Enums.HitType.Blue))
		
	$Combo.text = str(comboStreak)
	
	$Score.set_scores(_score)
	$Score.display_all_scores(_score)
		
func _create_hit():
	var key = elapsedTime
	if(songFile.hits.has(key)):
		var hit = songFile.hits[key]
		var drum = null
		drum = drumObject.new(hit)
		$HitStream.add_child(drum)
		drum.set_global_position(Vector2(1090, $HitStream.position.y))

func _delete_node():
	if($HitStream.get_child_count() == 0):
		return
	var node = $HitStream.get_children()[0]
	if (node.global_position.x <= 200):
		node.queue_free()
