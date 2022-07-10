extends Node2D

func playStream(stream_name):
	find_node(stream_name, true, false).play()

func StopStream(stream_name):
	find_node(stream_name, true, false).stop()
	

func getStream(stream_name):
	find_node(stream_name, true, false).get(stream_name)
