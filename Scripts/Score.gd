extends Node

const DELIMITER = ": "

const scoring = {
	90: "S",
	80: "A",
	70: "B",
	60: "C",
	50: "D",
	40: "FAIL",
}

var _scores = {
	"overall": "",
	"good": 0.0,
	"ok": 0.0,
	"bad": 0.0,
	"maxCombo": 0.0,
	"accuracy": 0.0,
}

func _ready():
	display_all_scores(_scores)

func display_all_scores(scores):
	$Results.text = ""
	
	_update_accuracy()
	_get_overall_score()
	
	_display_score("SCORE", scores.overall)
	_display_score("GOOD", scores.good)
	_display_score("OK", scores.ok)
	_display_score("BAD", scores.bad)
	_display_score("MAX COMBO", scores.maxCombo)
	_display_score("ACCURACY", str(scores.accuracy) + "%")	

func _display_score(scoreText, scoreValue):
	$Results.text += scoreText + DELIMITER + str(scoreValue) + '\n'

func set_scores(score):
	_scores = score

func _update_accuracy():
	var total = _scores.good + _scores.ok + _scores.bad
	if total == 0: return
	
	var accuracy = _scores.good / total * 100.0
	_scores.accuracy = round(accuracy)

func _get_overall_score():
	var score_bands = scoring.keys()
	
	for i in score_bands:
		if _scores.accuracy >= i:
			_scores.overall = scoring[i]
			return
