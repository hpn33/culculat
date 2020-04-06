extends Node

onready var input = $screen/HBoxContainer/Input
onready var output = $screen/HBoxContainer/Container/Output

var result


func lexer():
	var text = input.text
	
	var regex = RegEx.new()
	regex.compile("(?<operator>[-*/+]+)|(?<digit>[0-9]+)")
	
	var ast = []
	var tot = []
	var tokens = []
	
	for result in regex.search_all(text):
		var token = Token.new()
		
		token.string = result.get_string()
		
		match result.names.keys()[0]:
			'digit':
				token.type = token.DIGIT
			'operator':
				token.type = token.OP
		
		tokens.append(token)
	
	
	for token in tokens:
		
		var node
		
		match token.type:
			token.DIGIT:
				node = Num.new(token.string)
			token.OP:
				match token.string:
					'+':
						node = Sum.new()
					'-':
						node = Sub.new()
					'*':
						node = Mul.new()
					'/':
						node = Div.new()
		
		tot.append(node)
	
	return tot

func parser(tokens):
	
	var end = false
	var i = 0
	var node
	var error = false
	
	var tot = tokens
	
	while not end:
		
		if tot.size() < 3 :
			print('items is less then 3')
			end = true
			error = true
			
			if tot.size() == 1:
				error = false
				print('but enouch')
			break
		
		if tot[i] is Op:
			node = tot[i]
			node.left = tot[i - 1]
			
			if i+1 <tot.size():
				node.right = tot[i + 1]
			else:
				print('need one more item')
				error = true
				end = true
				break
			
			if i + 1 < tot.size():
				for i in 3:
					tot.remove(0)
			else:
				print('need more items')
				error = true
				break
			
			tot.insert(0, node)
#			print(tot[0].eval())
			i -= 1
		
		if i+1 < tot.size():
			i += 1
		else:
			print('items is done')
			end = true
	
	if not error:
		var ast : Eval = tot[0]
		return ast.eval()
	
	return 'error'


func _on_Input_text_change(text):
	output.text = str(parser(lexer()))



class Token:
	enum {NONE, DIGIT, OP}
	var string := ''
	var type := NONE



class Eval:
	func eval():
		pass

class Num:
	extends Eval
	
	var value
	func _init(value):
		self.value = value
	
	func eval():
#		print("value: " + str(value))
		return int(value)


class Op:
	extends Eval
	var left
	var right


class Sum:
	extends Op
	
	func eval():
#		print(str(left.eval()) + ' + ' + str(right.eval()))
		return left.eval() + right.eval()


class Sub:
	extends Op
	
	func eval():
#		print(str(left.eval()) + ' - ' + str(right.eval()))
		return left.eval() - right.eval()


class Div:
	extends Op
	
	func eval():
#		print(str(left.eval()) + ' / ' + str(right.eval()))
		return left.eval() / right.eval()


class Mul:
	extends Op
	
	func eval():
#		print(str(left.eval()) + ' * ' + str(right.eval()))
		return left.eval() * right.eval()

