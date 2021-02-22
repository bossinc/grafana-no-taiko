extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var drumObject = preload("res://Scripts/drum.gd")

const LAST_TIME = 24100
const SONG_VELOCITY = 15
const START_OFFSET = 550

const songFile = {
	"hits": {
		1070: Enums.HitType.Red,
		1530: Enums.HitType.Red,
		2000: Enums.HitType.Red,
		2490: Enums.HitType.Blue,
		2950: Enums.HitType.Blue,
		3200: Enums.HitType.Red,
		3460: Enums.HitType.Red,
		3700: Enums.HitType.Blue,
		3940: Enums.HitType.Red,
		4140: Enums.HitType.Red,
		4250: Enums.HitType.Red,
		4400: Enums.HitType.Red,
		4650: Enums.HitType.Red,
		4900: Enums.HitType.Blue,
		5380: Enums.HitType.Blue,
		5860: Enums.HitType.Blue,
		6320: Enums.HitType.Red,
		6820: Enums.HitType.Red,
		7060: Enums.HitType.Red,
		7300: Enums.HitType.Blue,
		7550: Enums.HitType.Blue,
		7790: Enums.HitType.Blue,
		8040: Enums.HitType.Red,
		8260: Enums.HitType.Red,
		8500: Enums.HitType.Blue,
		8750: Enums.HitType.Blue,
		9210: Enums.HitType.Red,
		9700: Enums.HitType.Red,
		10180: Enums.HitType.Red,
		10660: Enums.HitType.Red,
		10890: Enums.HitType.Blue,
		11150: Enums.HitType.Blue,
		11390: Enums.HitType.Blue,
		11640: Enums.HitType.Red,
		11770: Enums.HitType.Blue,
		11870: Enums.HitType.Blue,
		11970: Enums.HitType.Blue,
		12120: Enums.HitType.Red,
		12350: Enums.HitType.Blue,
		12590: Enums.HitType.Blue,
		13060: Enums.HitType.Blue,
		13540: Enums.HitType.Red,
		14010: Enums.HitType.Red,
		14490: Enums.HitType.Red,
		14960: Enums.HitType.Red,
		15450: Enums.HitType.Blue,
		15940: Enums.HitType.Red,
		16420: Enums.HitType.Red,
		16890: Enums.HitType.Red,
		17390: Enums.HitType.Red,
		17870: Enums.HitType.Blue,
		18330: Enums.HitType.Blue,
		18820: Enums.HitType.Red,
		19300: Enums.HitType.Blue,
		19400: Enums.HitType.Blue,
		19500: Enums.HitType.Blue,
		19780: Enums.HitType.Red,
		20250: Enums.HitType.Red,
		20750: Enums.HitType.Red,
		21220: Enums.HitType.Red,
		21710: Enums.HitType.Red,
		22190: Enums.HitType.Blue,
		22670: Enums.HitType.Blue,
		23140: Enums.HitType.Blue,
		23390: Enums.HitType.Red,
		23620: Enums.HitType.Red,
		23860: Enums.HitType.Red,
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
	"accuracy": 0.0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	if elapsedTime == START_OFFSET:
		$Song.play()
		
		
	if elapsedTime == LAST_TIME:
		$Song.stop()
		$Timer.stop()
		print('end of song')
		return
		
	elapsedTime += 10
	_create_hit()
	$HitStream.position.x -= SONG_VELOCITY;
	_delete_node()

	
func _has_hit(drumHit):
	var node = $HitStream.get_children()[0]
	print(node.global_position.x - 260)
	var goalXLate = $goal.global_position.x - 25
	var goalXEarly = $goal.global_position.x + 25
	if (node.global_position.x >= goalXLate && node.global_position.x <= goalXEarly):
		node.queue_free()
		update_combo_streak(1)
		
		$Hit.text = 'GOOD'
		_score.good += 1
		return true
	
	if (node.global_position.x >= 250 && node.global_position.x <= 310 ):
		node.queue_free()
		update_combo_streak(1)
		
		$Hit.text = 'OK'
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
	
	# for logging out the hits to create the map manually	
	if isRed:
		_has_hit(Enums.HitType.Red)
		print(str(elapsedTime) + ": Enums.HitType.Red,")
	if isBlue:
		_has_hit(Enums.HitType.Blue)
		print(str(elapsedTime) + ": Enums.HitType.Blue,")
		
	$Combo.text = str(comboStreak)
	
	$Score.set_scores(_score)
	$Score.display_all_scores(_score)
		
func _create_hit():
	var key = elapsedTime
	
	key += START_OFFSET
	
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
