:- multifile do_test/6.

do_test(detect_faults(X,A),[X,A],
	[
		[
			[[incompatible(forall(v1, implies(spicy_topping(v1), pizza_topping(v1))))], [incompatible(forall(v1, implies(meat_topping(v1), pizza_topping(v1))))], [incompatible(forall(v1, implies(spicy_beef_topping(v1), spicy_topping(v1))))], [incompatible(forall(v1, implies(spicy_beef_topping(v1), meat_topping(v1))))], [insufficient(forall(v1, implies(meat_topping(v1), spicy_topping(v1))))], [insufficient(forall(v1, implies(spicy_topping(v1), meat_topping(v1))))], [misrepresentation(owl_defined(spicy_topping), owl_primitive(spicy_topping))], [misrepresentation(owl_defined(meat_topping), owl_primitive(meat_topping))]],
			primitive_tree(pizza_topping, spicy_topping, meat_topping, spicy_beef_topping, [spicy_topping_pizza_topping, meat_topping_pizza_topping, spicy_beef_topping_spicy_topping, forall_elimination(v2, forall(v1, implies(spicy_beef_topping(v1), meat_topping(v1))), _G3624, spicy_beef_topping_meat_topping)])
		],
		[
			[[incompatible(forall(v1, implies(meat_topping(v1), pizza_topping(v1))))], [incompatible(forall(v1, implies(spicy_topping(v1), pizza_topping(v1))))], [incompatible(forall(v1, implies(spicy_beef_topping(v1), meat_topping(v1))))], [incompatible(forall(v1, implies(spicy_beef_topping(v1), spicy_topping(v1))))], [insufficient(forall(v1, implies(spicy_topping(v1), meat_topping(v1))))], [insufficient(forall(v1, implies(meat_topping(v1), spicy_topping(v1))))], [misrepresentation(owl_defined(meat_topping), owl_primitive(meat_topping))], [misrepresentation(owl_defined(spicy_topping), owl_primitive(spicy_topping))]],
			primitive_tree(pizza_topping, meat_topping, spicy_topping, spicy_beef_topping, [meat_topping_pizza_topping, spicy_topping_pizza_topping, forall_elimination(v2, forall(v1, implies(spicy_beef_topping(v1), meat_topping(v1))), _G5874, spicy_beef_topping_meat_topping), spicy_beef_topping_spicy_topping])
		],
		[
			[[unconnected(pizza_topping)]],
			unconnected_class(pizza_topping)
		],
		[
			[[unconnected(spicy_topping)]],
			unconnected_class(spicy_topping)
		],
		[
			[[unconnected(meat_topping)]],
			unconnected_class(meat_topping)
		],
		[
			[[unconnected(spicy_beef_topping)]],
			unconnected_class(spicy_beef_topping)
		]
	],
	'Starting test for fault detection on primitive classes',
	'Output correct',
	'*** \n*** MISTAKES FOUND, OUTPUT WAS NOT THE ONE EXPECTED!!! \n***'
	).
