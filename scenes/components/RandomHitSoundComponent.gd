extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
@export var randomize_pitch: bool = true
@export var min_pitch: float = .9
@export var max_pitch: float = 1.1

func play_random_sound():
	if(streams == null or streams.size() == 0):
		return
	
	if(randomize_pitch):
		pitch_scale = randf_range(min_pitch, max_pitch)
	
	stream = streams.pick_random()
	
	play()
