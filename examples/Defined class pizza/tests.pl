:- multifile do_test/6.

do_test(detect_faults(X,A),[X,A],
	[
		[
			[[incompatible(forall(v1, implies(edam_topping(v1), pizza_topping(v1))))]],
			defined_subsume_primitive(pizza_topping, edam_topping, edam_topping)
		],
		[
			[[incompatible(forall(v1, implies(mozzarella_topping(v1), pizza_topping(v1))))]],
			defined_subsume_primitive(pizza_topping, mozzarella_topping, mozzarella_topping)
		],
		[
			[[incompatible(forall(v1, implies(cheddar_topping(v1), pizza_topping(v1))))]],
			defined_subsume_primitive(pizza_topping, cheddar_topping, cheddar_topping)
		],
		[
			[[incompatible(forall(v1, implies(parmezan_topping(v1), pizza_topping(v1))))]],
			defined_subsume_primitive(pizza_topping, parmezan_topping, parmezan_topping)
		],
		[
			[[unconnected(edamozzarella_topping)]],
			unconnected_class(edamozzarella_topping)
		]
	],
	'Starting test for fault detection on defined classes subsuming primitive classes',
	'Output correct',
	'*** \n*** MISTAKES FOUND, OUTPUT WAS NOT THE ONE EXPECTED!!! \n***'
	).
