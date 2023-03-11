extends CanvasLayer

onready var score_text = $Score

func update_score(new_score):
	score_text.text = str(new_score)
