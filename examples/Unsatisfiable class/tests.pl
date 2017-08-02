:- multifile do_test/6.

do_test(detect_faults(X,A),[X,A],
	[
		[
			[[incompatible(lnot(exists(v1, four_cheese_pizza(v1))))]],
			unsatisfiable_class(four_cheese_pizza, unsat_four_cheese)
		]
	],
	'Starting test for fault detection on unsatisfiable classes',
	'Output correct',
	'*** \n*** MISTAKES FOUND, OUTPUT WAS NOT THE ONE EXPECTED!!! \n***'
	).
