##Created by Adam Kurbiel
##Here, any functions runned by console will be executed.
##syntax: command(a,b,..n)
extends Control

func execute_command(source: String) -> void:
	var command := source.strip_edges()
	if command.is_empty():
		return

	var open_paren := command.find("(")
	var method_name := command
	var arguments: Array = []
	if open_paren >= 0:
		if not command.ends_with(")"):
			printerr("[console]: expected ')' in command: ", command)
			return
		method_name = command.left(open_paren).strip_edges()
		var argument_text := command.substr(open_paren + 1, command.length() - open_paren - 2)
		var parsed = _parse_arguments(argument_text)
		if parsed == null:
			return
		arguments = parsed

	if method_name.is_empty() or not has_method(method_name):
		printerr("[console]: no command named '", method_name, "'")
		return

	callv(method_name, arguments)

func _parse_arguments(source: String) -> Variant:
	if source.strip_edges().is_empty():
		return []
	var values: Array[String] = []
	var current := ""
	var quote := ""
	var escaped := false
	for character in source:
		if escaped:
			current += character
			escaped = false
		elif character == "\\" and not quote.is_empty():
			escaped = true
		elif not quote.is_empty():
			if character == quote:
				quote = ""
			else:
				current += character
		elif character == "\"" or character == "'":
			quote = character
		elif character == ",":
			values.append(current.strip_edges())
			current = ""
		else:
			current += character
	if not quote.is_empty():
		printerr("[console]: unterminated quoted argument")
		return null
	values.append(current.strip_edges())
	var result: Array = []
	for value in values:
		if value.is_empty():
			printerr("[console]: empty argument")
			return null
		var lower := value.to_lower()
		if lower == "true":
			result.append(true)
		elif lower == "false":
			result.append(false)
		elif lower == "null":
			result.append(null)
		elif value.is_valid_int():
			result.append(value.to_int())
		elif value.is_valid_float():
			result.append(value.to_float())
		else:
			result.append(value)
	return result

func hello() -> void:
	print("Hello, World!");

func say(content: Variant) -> void:
	print(content)
