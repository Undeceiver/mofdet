:- multifile do_test/6.

do_test(detect_faults(X,A),[X,A],
	[
		[
			[[unconnected(edamozzarella_topping)]],
			unconnected_class(edamozzarella_topping)
		]
	],
	'Starting test for fault detection on unconnected classes',
	'Output correct',
	'*** \n*** MISTAKES FOUND, OUTPUT WAS NOT THE ONE EXPECTED!!! \n***'
	).
