extends Node

const DELIMITER = ": "

var _scores = {
	"overall": "",
	"good": 0.0,
	"ok": 0.0,
	"bad": 0.0,
	"maxCombo": 0.0,
	"accuracy": "",
}

func _ready():
	display_all_scores(_scores)

func display_all_scores(scores):
	$Results.text = ""
	
	_update_accuracy()
	
	_display_score("SCORE", scores.overall)
	_display_score("GOOD", scores.good)
	_display_score("OK", scores.ok)
	_display_score("BAD", scores.bad)
	_display_score("MAX COMBO", scores.maxCombo)
	_display_score("ACCURACY", scores.accuracy)	

func _display_score(scoreText, scoreValue):
	$Results.text += scoreText + DELIMITER + str(scoreValue) + '\n'

func set_scores(score):
	_scores = score

func _update_accuracy():
	var total = _scores.good + _scores.ok + _scores.bad
	if total == 0: return
	
	var accuracy = _scores.good / total * 100.0
	_scores.accuracy = str(round(accuracy)) + '%'
