% Each fault suggestion consists on a list, indicating that at least one element in the list is faulty (equivalently, should be repaired). Elements in this lists are mainly textual. They might
% include some structure in order to better express the fault, but no rules are defined by them, at least at this level.

% Choosing which method to prove things.
do_proof(F,S,A) :- use_unbounded_provable, get_id(ID), no_repeat(unboundedprovable(F,S,0,0,A),[F,S],do_proof_unbounded(ID)).
do_proof(F,S,A) :- use_iterative_provable(M), get_id(ID), no_repeat(iterativeprovable(F,S,M,0,A),[F,S],do_proof_iterative(ID)).
do_proof(F,S,A) :- use_bounded_provable(M), get_id(ID), no_repeat(boundedprovable(F,S,M,A),[F,S],do_proof_bounded(ID)).
do_proof(F,A) :- build_axioms(S), do_proof(F,S,A).

% Spreading faultiness
consider_faulty(X,A) :- faulty_direct(X,A).
consider_faulty(X,spread(A,B)) :- consider_faulty(Y,A), spread_in_in_individual_fault(X,Y,B).	

spread_individual_fault(incompatible(F),incompatible(G),derive_incompatible(F,G,P)) :- do_proof(G,[F],P), F \== G.

spread_in_individual_fault([G|R],[F|R],A) :- spread_individual_fault(G,F,A).
spread_in_individual_fault([F|RG],[F|RF],A) :- spread_in_individual_fault(RG,RF,A).
spread_in_in_individual_fault([G|R],[F|R],A) :- spread_in_individual_fault(G,F,A).
spread_in_in_individual_fault([F|RG],[F|RF],A) :- spread_in_in_individual_fault(RG,RF,A).

% Actually outputting faults.
detect_faults(X,A) :- source_fault(A), consider_faulty(X,A).
detect_faults_iter(X,A) :- detect_faults(L,A), is_in(X,L).
detect_faults_pretty :- detect_faults(X,A), pretty_faultses(X,TX), pretty_explanation(A,TA), format(atom(T),'A fault was detected. The fault description is: ~n ~w ~n The reason for considering this a fault is: ~w',[TX,TA]), write(T).

% Pretty printing of faults
pretty_fault(incompatible(X),T) :- format(atom(T),'~w is incompatible',[X]), !.
pretty_fault(insufficient(X),T) :- format(atom(T),'~w is insufficient',[X]), !.
pretty_fault(misrepresentation(owl_defined(X),owl_primitive(X)),T) :- format(atom(T),'~w is primitive and it should be defined',[X]), !.
pretty_fault(misrepresentation(X,Y),T) :- format(atom(T),'There is a misrepresentation, ~w is used instead of ~w',[Y,X]), !.
pretty_fault(unconnected(X),T) :- format(atom(T),'~w cannot be connected with the rest of the ontology through any of its properties',[X]), !.
pretty_fault(X,T) :- format(atom(T),'Generic fault: ~w',[X]), !.

pretty_faults(N,[],T) :- format(atom(T),'Alternative ~w (all of the following hold): ~n',[N]).
pretty_faults(N,[X|R],T) :- pretty_faults(N,R,TR), pretty_fault(X,TF), format(atom(T),'~w ~w ~n',[TR,TF]).

pretty_faultses_rec([],T,0) :- format(atom(T),'Either: ~n',[]).
pretty_faultses_rec([X|R],T,N) :- pretty_faultses_rec(R,TR,M), is(N,M+1), pretty_faults(N,X,TF), format(atom(T),'~w ~w ~n',[TR,TF]).
pretty_faultses(L,T) :- pretty_faultses_rec(L,T,_).

