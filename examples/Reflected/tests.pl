:- multifile do_test/6.

do_test(detect_faults(X,A),[X,A],
	[
		[
			[[insufficient(exists(v1, edam_topping(v1)))]],
			reflect_complete(exists(v1, edam_topping(v1)), unsatisfiable_class(edam_topping, assumption(lnot(exists(v1, edam_topping(v1))))))
		],
		[
			[[insufficient(exists(v1, mozzarella_topping(v1)))]],
			reflect_complete(exists(v1, mozzarella_topping(v1)), unsatisfiable_class(mozzarella_topping, assumption(lnot(exists(v1, mozzarella_topping(v1))))))
		],
		[
			[[insufficient(exists(v1, cheddar_topping(v1)))]],
			reflect_complete(exists(v1, cheddar_topping(v1)), unsatisfiable_class(cheddar_topping, assumption(lnot(exists(v1, cheddar_topping(v1))))))
		],
		[
			[[insufficient(exists(v1, parmezan_topping(v1)))]],
			reflect_complete(exists(v1, parmezan_topping(v1)), unsatisfiable_class(parmezan_topping, assumption(lnot(exists(v1, parmezan_topping(v1))))))
		],
		[
			[[insufficient(exists(v1, pizza(v1)))]],
			reflect_complete(exists(v1, pizza(v1)), unsatisfiable_class(pizza, assumption(lnot(exists(v1, pizza(v1))))))
		]		
	],
	'Starting test for fault detection on reflection over completeness and consistency',
	'Output correct',
	'*** \n*** MISTAKES FOUND, OUTPUT WAS NOT THE ONE EXPECTED!!! \n***'
	).
