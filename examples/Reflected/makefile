FILES=detect.pl patterns.pl depth.pl expressivity.pl metalogic.pl util.pl run.pl test.pl run_tests.pl

primitive_example:
	echo "Primitive classes example"
	echo "Copying files..."
	cp $(FILES) "./examples/Primitive classes"
	echo "Running tests..."
	"./examples/Primitive classes/run_tests.pl"
	echo "Done!\n"

unconnected_example:
	echo "Unconnected class example"
	echo "Copying files..."
	cp $(FILES) "./examples/Unconnected class/"
	echo "Running tests..."
	"./examples/Unconnected class/run_tests.pl"
	echo "Done!\n"

unsatisfiable_example:
	echo "Unsatisfiable class example"
	echo "Copying files..."
	cp $(FILES) "./examples/Unsatisfiable class/"
	echo "Running tests..."
	"./examples/Unsatisfiable class/run_tests.pl"
	echo "Done!\n"

defined_subsumes_example:
	echo "Defined class subsuming primitives example"
	echo "Copying files..."
	cp $(FILES) "./examples/Defined class pizza/"
	echo "Running tests..."
	"./examples/Defined class pizza/run_tests.pl"
	echo "Done!\n"

examples: primitive_example unconnected_example unsatisfiable_example defined_subsumes_example
