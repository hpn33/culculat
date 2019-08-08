extends TextEdit

signal text_change(text)

export(float) var delay = 1.0

func _on_Input_text_changed():
	$Timer4.start(delay)


func _on_Timer4_timeout():
	emit_signal('text_change', text)
