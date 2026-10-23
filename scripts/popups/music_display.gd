extends Control


func Show(song_name, author_name) -> void:
	$song_name.text = "♪ : "+song_name
	$author_name.text = author_name
