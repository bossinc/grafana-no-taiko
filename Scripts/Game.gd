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
		1070: global.HitType.Red,
		1530: global.HitType.Red,
		2000: global.HitType.Red,
		2490: global.HitType.Blue,
		2950: global.HitType.Blue,
		3200: global.HitType.Red,
		3460: global.HitType.Red,
		3700: global.HitType.Blue,
		3940: global.HitType.Red,
		4140: global.HitType.Red,
		4250: global.HitType.Red,
		4400: global.HitType.Red,
		4650: global.HitType.Red,
		4900: global.HitType.Blue,
		5380: global.HitType.Blue,
		5860: global.HitType.Blue,
		6320: global.HitType.Red,
		6820: global.HitType.Red,
		7060: global.HitType.Red,
		7300: global.HitType.Blue,
		7550: global.HitType.Blue,
		7790: global.HitType.Blue,
		8040: global.HitType.Red,
		8260: global.HitType.Red,
		8500: global.HitType.Blue,
		8750: global.HitType.Blue,
		9210: global.HitType.Red,
		9700: global.HitType.Red,
		10180: global.HitType.Red,
		10660: global.HitType.Red,
		10890: global.HitType.Blue,
		11150: global.HitType.Blue,
		11390: global.HitType.Blue,
		11640: global.HitType.Red,
		11770: global.HitType.Blue,
		11870: global.HitType.Blue,
		11970: global.HitType.Blue,
		12120: global.HitType.Red,
		12350: global.HitType.Blue,
		12590: global.HitType.Blue,
		13060: global.HitType.Blue,
		13540: global.HitType.Red,
		14010: global.HitType.Red,
		14490: global.HitType.Red,
		14960: global.HitType.Red,
		15450: global.HitType.Blue,
		15940: global.HitType.Red,
		16420: global.HitType.Red,
		16890: global.HitType.Red,
		17390: global.HitType.Red,
		17870: global.HitType.Blue,
		18330: global.HitType.Blue,
		18820: global.HitType.Red,
		19300: global.HitType.Blue,
		19400: global.HitType.Blue,
		19500: global.HitType.Blue,
		19780: global.HitType.Red,
		20250: global.HitType.Red,
		20750: global.HitType.Red,
		21220: global.HitType.Red,
		21710: global.HitType.Red,
		22190: global.HitType.Blue,
		22670: global.HitType.Blue,
		23140: global.HitType.Blue,
		23390: global.HitType.Red,
		23620: global.HitType.Red,
		23860: global.HitType.Red,
	}
}

var elapsedTime = 0
var comboStreak = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global.score = {
		"overall": "",
		"good": 0.0,
		"ok": 0.0,
		"bad": 0.0,
		"maxCombo": 0.0,
		"accuracy": 0.0,
	}

func _on_Timer_timeout():
	if elapsedTime == START_OFFSET:
		$Song.play()
		
		
	if elapsedTime == LAST_TIME:
		$Song.stop()
		$Timer.stop()
		print('end of song')
		get_tree().change_scene("res://End.tscn")
		return
		
	elapsedTime += 10
	_create_hit()
	$HitStream.position.x -= SONG_VELOCITY;
	_delete_node()
	
	$Combo.text = 'Combo: ' + str(comboStreak)
	
	$Score.set_scores(global.score)
	$Score.display_all_scores(global.score)

	
const goodRange = 25
const okRange = 50

func _has_hit(drumHit):
	var node = $HitStream.get_children()[0]
	print(str(drumHit) + "/" + str(node.hitType))
	var goalXLate = $goal.global_position.x - goodRange
	var goalXEarly = $goal.global_position.x + goodRange
	if (node.global_position.x >= goalXLate && node.global_position.x <= goalXEarly && drumHit == node.hitType):
		node.queue_free()
		update_combo_streak(1)
		
		$Hit.text = 'GOOD'
		global.score.good += 1
		return true
	
	goalXLate = $goal.global_position.x - okRange
	goalXEarly = $goal.global_position.x + okRange
	if (node.global_position.x >= goalXLate && node.global_position.x <= goalXEarly && drumHit == node.hitType):
		node.queue_free()
		update_combo_streak(1)
		
		$Hit.text = 'OK'
		global.score.ok += 1
		return true
	_miss()

func _miss():
	$Hit.text = 'BAD'
	global.score.bad += 1
	update_combo_streak(0)

func update_combo_streak(comboValue):
	if comboValue == 0:
		comboStreak = 0
		return

	comboStreak += comboValue
	
	global.score.maxCombo = max(global.score.maxCombo, comboStreak)

func _input(event):		
	var isRed = event.is_action_pressed("drum_red")
	var isBlue = event.is_action_pressed("drum_blue")
	if($HitStream.get_child_count() == 0):
		return
	
	# for logging out the hits to create the map manually	
	if isRed:
		_has_hit(global.HitType.Red)
		print(str(elapsedTime) + ": globals.HitType.Red,")
	if isBlue:
		_has_hit(global.HitType.Blue)
		print(str(elapsedTime) + ": globals.HitType.Blue,")
		
	$Combo.text = str(comboStreak)
	
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
		_miss()
