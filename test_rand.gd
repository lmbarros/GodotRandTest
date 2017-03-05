extends Panel

func _ready():
	pass


func test_distributions(rng):
	for i in range(1000):
		$LstOutput.add_item("=> " + str(rng.uniform_float()))

# Compares generated values with values obtained from reference implementations
func test_sequence(rng, the_seed, expected_values):
	rng.seed(the_seed)

	for i in range(1000):
		rng.random()

	for expected in expected_values:
		var actual = rng.random()
		if actual != expected:
			$LstOutput.add_item("")
			$LstOutput.add_item("ERROR! Unexpected random sequence!")
			$LstOutput.add_item("")
			return


func _on_BtnKnuthLCG_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandKnuthLCG ----")
	$LstOutput.add_item("")

	var rng = RandKnuthLCG.new()

	test_sequence(rng, 112233, [14373087394460283212, 17919820627726294955,
		2374928239783487326, 1355612529541287637, 14300717203320031168])

	test_sequence(rng, 97531, [2475730772265627958, 16585264879776313805,
	   	10829226592693777752, 4337668493995821511, 13619766792622649930])

	test_distributions(rng)


func _on_BtnPCG32_pressed():
	$LstOutput.clear()
	$LstOutput.add_item("---- RandPCG32 ----")
	$LstOutput.add_item("")

	var rng = RandPCG32.new()

	test_sequence(rng, 112233, [2742036491, 2245988297, 365294676, 2892959733,
		268736847])

	test_sequence(rng, 97531, [107914430, 376050961, 4272170875, 909441240,
		2368777700])

	test_distributions(rng)
