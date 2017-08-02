:- multifile do_test/6.

% Verify result.
verify(G,P,R) :- findall(P,G,XS), XS =@= R.

% Tests to be performed ought to be specified by the do_test(G,P,R,I,S,F) predicate, where
%	- G is the goal to run.
%	- P is the argument or set of arguments to check.
%	- R is the list of expected results (syntactic), in order.
%	- I is the initialization message for the test.
%	- S is the success message for the test.
%	- F is the fail message for the test.
run_tests :- findall(_,run_test(_,_,_,_,_,_),_), write('End of tests\n').
run_test(G,P,R,I,S,F) :- do_test(G,P,R,I,S,F), write(I), write('\n'), (verify(G,P,R) *-> (write(S),write('\n')); (write(F),write('\n'))). 
do_test(true,_,[_],'','','').
