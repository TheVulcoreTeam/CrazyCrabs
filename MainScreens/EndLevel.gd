extends Node2D

onready var text_field = $TextEdit
onready var http_request = $HTTPRequest
onready var http_results = $HTTPResults
onready var http_update = $HTTPUpdate
onready var scoreboard = $Score
onready var save = $Save

var headers = ["Content-Type: application/json"]


func _ready():
	http_request.connect('request_completed', self, '_http_request_completed')
	http_results.connect('request_completed', self, '_on_ranking_obtained')
	http_results.request('https://us-central1-vulcore-crab.cloudfunctions.net/VULCOREAPI/get_scores', headers, false, HTTPClient.METHOD_POST, JSON.print({}))


func _on_Save_pressed():
	save.disabled = true
	text_field.readonly = true
	var body = {
		'nickname': text_field.text,
		'score': 99,
		'vulcore_key': 'a2ed12be302bcacef65a424113c070bf'
	}
	var headers = ["Content-Type: application/json"]
	http_request.request('https://us-central1-vulcore-crab.cloudfunctions.net/VULCOREAPI/send_score', headers, false, HTTPClient.METHOD_POST, JSON.print(body))


func _http_request_completed(result, response_code, headers, body):
	save.hide()
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	update_scores (dict)


func _on_ranking_obtained(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict = json.result
	update_scores (dict)


func update_scores(dict):
	if dict.has('scores'):
		scoreboard.bbcode_text = '###  SCORE   NICKNAME\n'
		for score in dict.scores:
			scoreboard.bbcode_text += str(score.rank).pad_zeros(3)+'. '+str(score.score).pad_zeros(6)+' - '+score.nickname+'\n'
	else:
		scoreboard.bbcode_text = 'No scores reported, be the first!'