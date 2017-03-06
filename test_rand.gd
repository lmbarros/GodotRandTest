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
		var n = int(rng.uniform_float(a, b))
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


func test_distributions(rng):
	test_uniform_float(rng, 0.0, 8.0)
	test_uniform_float(rng, 3.0, -2.0)
	test_uniform_float(rng, -6.0, -6.0)

	test_normal(rng, 0.0, 1.0)
	test_normal(rng, 4.0, 3.0)
	test_normal(rng, -3.0, 5.0)
	test_normal(rng, 1.0, 0.1)
	
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
			$LstOutput.add_item("")
			return


func _on_BtnKnuthLCG_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandKnuthLCG ----")
	$LstOutput.add_item("")

	var rng = RandKnuthLCG.new()

	test_sequence(rng, 112233, [14373087394460283212, 17919820627726294955, 2374928239783487326, 1355612529541287637, 14300717203320031168])
	test_sequence(rng, 97531, [2475730772265627958, 16585264879776313805, 10829226592693777752, 4337668493995821511, 13619766792622649930])
	test_distributions(rng)


func _on_BtnPCG32_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandPCG32 ----")
	$LstOutput.add_item("")

	var rng = RandPCG32.new()

	test_sequence(rng, 112233, [102148438, 2290673564, 2768362330, 564360816, 3408622802])
	test_sequence(rng, 97531, [3442234210, 3111326070, 2927093750, 2463984830, 4287579801])
	test_distributions(rng)


func _on_BtnSplitMix64_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandSplitMix64 ----")
	$LstOutput.add_item("")

	var rng = RandSplitMix64.new()

	test_sequence(rng, 112233, [17521931875799178301, 14383456051838709316, 2828063782273925862, 11956729851173419597, 15283991741788426049])
	test_sequence(rng, 97531, [14309215551682402496, 13331760577475424929, 6476874722340802351, 13089128203191675115, 7925169073796594034])
	test_distributions(rng)


func _on_BtnXoroshiro128Plus_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandXoroshiro128Plus ----")
	$LstOutput.add_item("")

	var rng = RandXoroshiro128Plus.new()

	test_sequence(rng, 13579, [5883773771842788424, 9989605189133216712, 7811117801491353185, 4706773927854861091, 17379387784680010921])
	test_distributions(rng)


func _on_tnMT19937_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandMT19937_64 ----")
	$LstOutput.add_item("")

	var rng = RandMT19937.new()

	test_sequence(rng, 112233, [2749130340, 394058186, 424636858, 3006322354, 2662410484])
	test_sequence(rng, 97531, [3873955303, 573781378, 3704291903, 1481365957, 2780134746])
	test_distributions(rng)


func _on_BtnMT19937_64_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandMT19937_64 ----")
	$LstOutput.add_item("")

	var rng = RandMT19937_64.new()

	test_sequence(rng, 112233, [18385898271542208877, 10388062775371028914, 6652856830127087739, 1890554855370499999, 14650261722016513395])
	test_sequence(rng, 97531, [6788201074649841524, 11921711492735785818, 9983243477236236108, 5762306495090730538, 636925918925826639])
	test_distributions(rng)
