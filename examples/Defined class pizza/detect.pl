:- multifile pretty_explanation/2.
:- multifile lemma/3.

% Each fault suggestion consists on a list, indicating that at least one element in the list is faulty (equivalently, should be repaired). Elements in this lists are mainly textual. They might
% include some structure in order to better express the fault, but no rules are defined by them, at least at this level.

% Choosing which method to prove things.
do_proof(F,S,A) :- use_unbounded_provable, get_id(ID), no_repeat(unboundedprovable(F,S,0,0,A),[F,S],do_proof_unbounded(ID)).
do_proof(F,S,A) :- use_iterative_provable(M), get_id(ID), no_repeat(iterativeprovable(F,S,M,0,A),[F,S],do_proof_iterative(ID)).
do_proof(F,S,A) :- use_bounded_provable(M), get_id(ID), no_repeat(boundedprovable(F,S,M,A),[F,S],do_proof_bounded(ID)).
do_proof(F,S,A) :- lemma(F,SS,A), sublist(SS,S).
do_proof(F,A) :- build_axioms(S), do_proof(F,S,A).
lemma(unstructured(_),[unstructured(_)],dummy_lemma).

% Spreading faultiness
rec_consider_faulty(X,S,L,D,A) :- D >= 0, consider_faulty(X,S,L,D,A).
consider_faulty(X,_,L,_,assumed_fault(X)) :- is_in(X,L).
consider_faulty(X,S,_,D,A) :- faulty_direct(X,S,D,A).
consider_faulty([[incompatible(G)]],S,L,_,spread_incompatible(F,G,P,Q)) :- find_incompatible_top(F,L), do_proof(F,[G],P), do_proof(G,S,Q).
consider_faulty([[insufficient(G)]],S,L,_,spread_insufficient(F,G,P)) :- find_insufficient_top(F,L), do_proof(G,[F],P), not(do_proof(G,S,_)).
consider_faulty([[insufficient(H)]],S,L,D,reflect_complete(H,R)) :- assume_complete, rec_consider_faulty(X,[lnot(H)|S],L,D-1,R), not(do_proof(H,S,_)), not(do_proof(lnot(H),S,_)), find_incompatible_mid(lnot(H),X).
consider_faulty([[incompatible(H)]],S,L,D,reflect_consistent(H,R)) :- assume_consistent, sublist(SS,S), rec_consider_faulty(X,SS,L,D-1,R), do_proof(H,S,_), do_proof(lnot(H),S,_), find_insufficient_mid(lnot(H),X).
% This rule should take lists of faulty formulas rather than just one, but for performance reasons we only consider this case.
consider_faulty(X,S,[],D,consequence(F,X,A,B)) :- faulty_direct(F,S,D,A), consider_faulty(X,S,[F],D,B).

% This predicate takes a list of faults (each of which is a disjunction of conjunctions)
% and iteratively looks for incompatible formulas within it, and for each of them it tries to spread incompatibility to a new formula.
% In theory, we would need to build all subsets (or, at least, the smallest one) that fulfil this, including combinations of incompatible formulas
% from different faults, but we restrict ourselves to subsets of size 1 for performance.
% IMPORTANT: The fault passed as second parameter needs to be non-variable, otherwise this incurs in infinite search!
find_incompatible_bottom(_,unstructured(_)) :- !, fail.
find_incompatible_bottom(F,[incompatible(F)|_]).
find_incompatible_bottom(F,[_|R]) :- find_incompatible_bottom(F,R).
find_incompatible_mid(_,unstructured(_)) :- !, fail.
find_incompatible_mid(F,[X|_]) :- find_incompatible_bottom(F,X).
find_incompatible_mid(F,[_|R]) :- find_incompatible_mid(F,R).
find_incompatible_top(_,unstructured(_)) :- !, fail.
find_incompatible_top(F,[X|_]) :- find_incompatible_mid(F,X).
find_incompatible_top(F,[_|R]) :- find_incompatible_top(F,R).

% Equivalent, but for insufficient.
find_insufficient_bottom(_,unstructured(_)) :- !, fail.
find_insufficient_bottom(F,[incompatible(F)|_]).
find_insufficient_bottom(F,[_|R]) :- find_insufficient_bottom(F,R).
find_insufficient_mid(_,unstructured(_)) :- !, fail.
find_insufficient_mid(F,[X|_]) :- find_insufficient_bottom(F,X).
find_insufficient_mid(F,[_|R]) :- find_insufficient_mid(F,R).
find_insufficient_top(_,unstructured(_)) :- !, fail.
find_insufficient_top(F,[X|_]) :- find_insufficient_mid(F,X).
find_insufficient_top(F,[_|R]) :- find_insufficient_top(F,R).


% Actually outputting faults.
detect_faults(X,A) :- get_id(ID), no_repeat(detect_one_fault(X,A),X,ID).
detect_one_fault(X,A) :- output_fault(A), build_axioms(S), consider_faulty(X,S,[],1,A).
output_fault(A) :- source_fault(A).
output_fault(A) :- shape_fault(A).
detect_faults_iter(X,A) :- detect_faults(L,A), is_in(X,L).
detect_faults_pretty :- detect_faults(X,A), pretty_faultses(X,TX), pretty_explanation(A,TA), format(atom(T),'~nA fault was detected. The fault description is: ~n ~w ~n The reason for considering this a fault is: ~w',[TX,TA]), write(T).

% Pretty printing of faults
pretty_explanation(assumed_fault(X),T) :- format(atom(T),'~w is assumed to be faulty.',[X]).
pretty_explanation(spread_incompatible(F,G,P,Q),T) :- pretty_proof(P,LP), pretty_proof(Q,LQ), format(atom(T),'~w is considered incompatible due to spreading. The ontology proves it, ~w is considered incompatible and implies(~w,~w) is valid. ~n  Proof of ~w: ~n  ~w ~n  Proof of implies(~w,~w): ~n  ~w ~n',[G,F,G,F,G,LQ,G,F,LP]).
pretty_explanation(spread_insufficient(F,G,P),T) :- pretty_proof(P,LP), format(atom(T),'~w is considered insufficient due to spreading. The ontology does not prove it, ~w is considered insufficient and implies(~w,~w) is valid. ~n  Proof of implies(~w,~w): ~n  ~w ~n',[G,F,F,G,F,G,LP]).
pretty_explanation(consequence(F,X,A,B),T) :- pretty_explanation(A,LA), pretty_explanation(B,LB), format(atom(T),'The fault ~w is a consequence (propagation) of the fault ~w. ~n  The reason for considering ~w a fault is: ~n  ~w ~n  The reason for considering ~w a propagation of ~w is: ~n  ~w',[X,F,F,LA,X,F,LB]).
pretty_explanation(reflect_complete(H,R),T) :- pretty_explanation(R,TR), format(atom(T),'~w is considered insufficient because the ontology is assumed complete and assuming its negation to be true would imply it being incompatible.~n  Explanation of lnot(~w) being incompatible:~n  ~w',[H,H,TR]).
pretty_explanation(reflect_consistent(H,R),T) :- pretty_explanation(R,TR), format(atom(T),'~w is considered incompatible because the ontology is assumed consistent and assuming its negation to be false would imply it being insufficient.~n  Explanation of lnot(~w) being insufficient:~n  ~w',[H,H,TR]).

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


% Shapes
%shape_fault(consequence(_,_,_,_)).
shape_not_reflect(_) :- !, fail.
shape_fault(X) :- shape_not_reflect(X).
shape_fault(reflect_complete(_,R)) :- source_fault(R).
shape_fault(reflect_complete(_,R)) :- shape_not_reflect(R).
shape_fault(reflect_consistent(_,R)) :- source_fault(R).
shape_fault(reflect_consistent(_,R)) :- shape_not_reflect(R).
shape_fault(_) :- !, fail.
