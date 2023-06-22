extends Node

enum TrackList { DEATH_SOUND, MUSIC, NONE }

@export var death_sound = AudioStream
@export var music = AudioStream

var tracks: Dictionary = {}


func _ready():
	tracks = {
		TrackList.DEATH_SOUND: death_sound,
		TrackList.MUSIC: music,
		TrackList.NONE: null,
	}


func _swap_stream(new_stream: AudioStream):
	if new_stream != $Player.stream:
		if $Player.stream:
			$Player.stop()

		$Player.stream = new_stream


func play_track(track_name: TrackList):
	var new_stream: AudioStream = tracks[track_name]
	_swap_stream(new_stream)
	$Player.play()


func stop():
	$Player.stop()
