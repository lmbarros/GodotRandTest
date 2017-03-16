extends Panel

var sample_size = 10000
var mark_size = 125

func test_boolean(rng, p):
	$LstOutput.add_item("")
	$LstOutput.add_item("boolean(" + str(p) + ")")
	var num_trues = 0
	var num_falses = 0

	for i in range(sample_size):
		if rng.boolean(p):
			num_trues += 1
		else:
			num_falses += 1

	var p_true = " (" + str(float(num_trues) / sample_size * 100) + "%)"
	var p_false = " ("+ str(float(num_falses) / sample_size * 100) + "%)"

	$LstOutput.add_item("      Trues: " + str(num_trues) + p_true)
	$LstOutput.add_item("      Falses: " + str(num_falses) + p_false)

func test_uniform_float(rng, a, b):
	$LstOutput.add_item("")
	$LstOutput.add_item("uniform_float(" + str(a) + ", " + str(b) + ")")

	var values = [ ]
	values.resize(21)

	for i in range(-10, 11):
		values[i+10] = 0

	for i in range(sample_size):
		var n = int(rng.uniform(a, b))
		values[n+10] += 1

	for i in range(-10, 11):
		var line = ""
		if i > 0:
			line += "+"
		line += str(i)
		while line.length() < 5:
			line += " "
		line += "|"

		for j in range(values[i+10]/mark_size):
			line += "#"

		$LstOutput.add_item(line)


func test_uniform_int(rng, a, b):
	$LstOutput.add_item("")
	$LstOutput.add_item("uniform_int(" + str(a) + ", " + str(b) + ")")

	var values = [ ]
	values.resize(21)

	for i in range(-10, 11):
		values[i+10] = 0

	for i in range(sample_size):
		var n = int(rng.uniform_int(a, b))
		values[n+10] += 1

	for i in range(-10, 11):
		var line = ""
		if i > 0:
			line += "+"
		line += str(i)
		while line.length() < 5:
			line += " "
		line += "|"

		for j in range(values[i+10]/mark_size):
			line += "#"

		$LstOutput.add_item(line)


func test_normal(rng, mean, std_dev):
	$LstOutput.add_item("")
	$LstOutput.add_item("normal(" + str(mean) + ", " + str(std_dev) + ")")

	var values = [ ]
	values.resize(21)

	for i in range(-10, 11):
		values[i+10] = 0

	for i in range(sample_size):
		var n = int(rng.normal(mean, std_dev))
		var j = n+10
		if j < 0:
			j = 0
		if j > 20:
			j= 20
		values[j] += 1

	for i in range(-10, 11):
		var line = ""
		if i > 0:
			line += "+"
		line += str(i)
		while line.length() < 5:
			line += " "
		line += "|"

		for j in range(values[i+10]/mark_size):
			line += "#"

		$LstOutput.add_item(line)


func test_exponential(rng, mean):
	$LstOutput.add_item("")
	$LstOutput.add_item("exponential(" + str(mean) + ")")

	var values = [ ]
	values.resize(21)

	for i in range(-10, 11):
		values[i+10] = 0

	for i in range(sample_size):
		var n = int(rng.exponential(mean))
		var j = n+10
		if j < 0:
			j = 0
		if j > 20:
			j= 20
		values[j] += 1

	for i in range(-10, 11):
		var line = ""
		if i > 0:
			line += "+"
		line += str(i)
		while line.length() < 5:
			line += " "
		line += "|"

		for j in range(values[i+10]/mark_size):
			line += "#"

		$LstOutput.add_item(line)



func test_unitialized(rng):
	$LstOutput.add_item("Samples from an unitialized generator:")
	for i in range(10):
		$LstOutput.add_item("    " + str(rng.random()))



func test_randomized(rng):
	$LstOutput.add_item("Samples from a randomized generator:")
	for i in range(10):
		$LstOutput.add_item("    " + str(rng.random()))



func test_distributions(rng):
	test_uniform_float(rng, 0.0, 8.0)
	test_uniform_float(rng, 3.0, -2.0)
	test_uniform_float(rng, -6.0, -6.0)

	test_normal(rng, 0.0, 1.0)
	test_normal(rng, 4.0, 3.0)
	test_normal(rng, -3.0, 5.0)
	test_normal(rng, 1.0, 0.1)
#
	test_exponential(rng, 1.0)
	test_exponential(rng, -1.0)
	test_exponential(rng, 2.5)

	test_uniform_int(rng, 3, 4)
	test_uniform_int(rng, -5, 2)
	test_uniform_int(rng, 0, 0)

	test_boolean(rng, 0.5)
	test_boolean(rng, 0.2)
	test_boolean(rng, 1.5)
	test_boolean(rng, -0.2)


# Compares generated values with values obtained from reference implementations
func test_sequence(rng, the_seed, expected_values):
	rng.seed(the_seed)

	for i in range(1000):
		rng.random()

	for expected in expected_values:
		var actual = rng.random()
		if actual != expected:
			$LstOutput.add_item("")
			$LstOutput.add_item("!!!! ERROR! Unexpected random sequence!")
			$LstOutput.add_item("    expected = " + str(expected))
			$LstOutput.add_item("    actual = " + str(actual))
			$LstOutput.add_item("")
			return


func _on_BtnRunTest_pressed():
	$LstOutput.clear()

	var rng = Random.new()

	test_unitialized(rng)

	test_sequence(rng, 112233, [7123399788724425941, 7121477978731735727, 8574975519304090956, 21762176221704839, 7464068290198254667])
	test_sequence(rng, 97531, [5329517847764692888, 7995606249192798244, 247274493191693947, 1989713738571351565, 6862052227764695708])

	rng.randomize()
	test_randomized(rng)
	test_distributions(rng)
