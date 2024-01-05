#gdscript
class_name ClassTest extends Object
## Run all tests
func run() -> Dictionary:
	return {}

## Call run() and print results
func run_verbose():
	var results = run()
	if results.size() == 0:
		print("❔ No tests found")
		return
	var i = 1
	var length = str(results.size()).length()
	for test in results:
		# 1 /10: ✅ passed 'test 1'
		# 10/10: ❌ failed 'test 10'
		print(
			pad(str(i), length, " "), "/", results.size(), ": ",
			"✅ passed" if results[test] else "❌ failed",
			" '", test, "'"
		)
		i += 1
	print(
		"✅" if results.values().all(func(x): return x) else "❌",
		" ", pad(results.values().count(true), length, " "), "/", results.size(), " tests passed."
	)
	

func pad(
	subject,
	## Desired length of the string
	length,
	## Character to pad with, if not set or not length 1, it defaults to " "
	character = " ",
	## Pad to the left
	left = false
) -> String:
	if character.length() != 1:
		character = " "
	var result = str(subject)
	while result.length() < length:
		result = character + result if left else result + character
	return result
