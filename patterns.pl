:- discontiguous faulty/2.
:- discontiguous source_fault/1.
:- discontiguous pretty_explanation/2.

% Utility definitions for patterns.
class(X) :- ground_pred(X,1).
property(X) :- ground_pred(X,2).

get_any_vars_rec(0,[],_) :- !.
get_any_vars_rec(N,[[V,TV]|R],P) :- ground_var(V,TV), not(is_exactly_in(V,P)), !, is(M, N-1), get_any_vars_rec(M,R,[V|P]).
get_any_vars(N,L) :- get_any_vars_rec(N,L,[]).

owl_subsumption(A,B,forall(V,implies(TB,TA))) :- class(A), class(B), get_any_vars(1,[[V,TV]]), TA =.. [A,TV], TB =.. [B,TV].
owl_subsumes(A,B,P) :- owl_subsumption(A,B,F), do_proof(F,P).

% The equality verifications on the below rule could be moved before to improve performance, but for now we leave it in the end for maximum expressivity.
owl_cycle(A,B,C,D,[A1,A2,A3,A4]) :- owl_subsumes(A,B,A1), owl_subsumes(A,C,A2), owl_subsumes(B,D,A3), owl_subsumes(C,D,A4),
	not(owl_subsumes(B,C,_)), not(owl_subsumes(C,B,_)), A \== B, A \== C, A \== D, B \== C, B \== D, C \== D.

owl_satisfiable(A,exists(V,TA)) :- class(A), get_any_vars(1,[[V,TV]]), TA =.. [A,TV].

owl_not_connected_domain(P,A,lnot(exists(V1,and(TA,exists(V2,TP))))) :- property(P), class(A), get_any_vars(2,[[V1,TV1],[V2,TV2]]), TA =.. [A,TV1], TP =.. [P,TV1,TV2].
owl_not_connected_range(P,A,lnot(exists(V1,and(TA,exists(V2,TP))))) :- property(P), class(A), get_any_vars(2,[[V1,TV1],[V2,TV2]]), TA =.. [A,TV1], TP =.. [P,TV2,TV1].

owl_possibly_connected_domain(P,A) :- owl_not_connected_domain(P,A,F), not(do_proof(F,_)).
owl_possibly_connected_range(P,A) :- owl_not_connected_range(P,A,F), not(do_proof(F,_)).

owl_not_possibly_connected(A) :- class(A), not(owl_possibly_connected_domain(_,A)), not(owl_possibly_connected_range(_,A)).

extract_fault(incompatible(F),make_break(X,Y)) :- owl_subsumption(X,Y,F).
extract_fault(insufficient(F),make_order(X,Y)) :- owl_subsumption(X,Y,F).
extract_fault(misrepresentation(owl_defined(X),owl_primitive(X)),make_defined(X)).
extract_fault(incompatible(X),incompatible(X)).
extract_fault(insufficient(X),insufficient(X)).
extract_fault(misrepresentation(X,Y),misrepresentation(X,Y)).
extract_fault(incompatible(lnot(F)),unsatisfiable(X)) :- owl_satisfiable(X,F).
extract_fault(unconnected(X),unconnected(X)).

extract_faults_from([R1|R],X,S) :- extract_fault(R1,X), not(is_in(R1,S)), extract_faults_from(R,X,[R1|S]), !.
extract_faults_from([],_,_).

extract_faults(R,L) :- extract_faults_rec(R,L,[]).
extract_faults_rec([R1|R],[X|Y],S) :- extract_faults_from(R1,X,S), append(S2,S,R1), extract_faults_rec(R,Y,S2).
extract_faults_rec([],[],_).

extract_faults_iter(X,L) :- extract_faults(R,L), is_in(X,R).

faulty_direct(R,A) :- faulty(L,A), extract_faults(R,L).
faulty_direct_iter(X,A) :- faulty(L,A), extract_faults_iter(X,L).

faulty_iter(X,A) :- faulty(L,A), is_in(X,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Actual fault patterns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example 3.1 - Primitive versus defined classes
faulty([make_break(A,B),make_break(A,C),make_break(B,D),make_break(C,D),make_order(B,C),make_order(C,B),make_defined(B),make_defined(C)],primitive_tree(A,B,C,D,P)) :- owl_primitive(A), owl_primitive(B), owl_primitive(C), owl_primitive(D), owl_cycle(A,B,C,D,P).
source_fault(primitive_tree(_,_,_,_,_)).
pretty_explanation(primitive_tree(A,B,C,D,[P1,P2,P3,P4]),T) :- pretty_proof(P1,TP1), pretty_proof(P2,TP2), pretty_proof(P3,TP3), pretty_proof(P4,TP4),
	format(atom(T),
	'Classes ~w, ~w, ~w and ~w form an undirected subsumption cycle, and they are all primitive. Proofs of subsumptions: ~n ~w subsumes ~w: ~n ~w ~n ~w subsumes ~w: ~n ~w ~n ~w subsumes ~w: ~n ~w ~n ~w subsumes ~w: ~n ~w',[A,B,C,D,A,B,TP1,A,C,TP2,B,D,TP3,C,D,TP4]).

% Example 3.1. - Defined classes should not subsume primitive classes
faulty([incompatible(owl_subsumes(X,Y))],defined_subsume_primitive(X,Y)) :- owl_defined(X), owl_primitive(Y), owl_subsumes(X,Y).
source_fault(defined_subsume_primitive(_,_)).
pretty_explanation(defined_subsume_primitive(X,Y),T) :- format(atom(T),'~w is a defined class, and it subsumes ~w, which is primitive. Defined classes should not subsume primitive classes.',[X,Y]).

% Example 3.2 - Unsatisfiable primitive classes are faulty
faulty([unsatisfiable(X)],unsatisfiable_class(X,P)) :- owl_primitive(X), owl_satisfiable(X,F), do_proof(lnot(F),P).
source_fault(unsatisfiable_class(_,_)).
pretty_explanation(unsatisfiable_class(X,P),T) :- pretty_proof(P,TP), format(atom(T),'~w is unsatisfiable, and it is a primitive class. Proof that it is unsatisfiable: ~n ~w.',[X,TP]).

% Example 3.2 - Unconnected primitive classes are faulty
faulty([unconnected(X)],unconnected_class(X)) :- owl_primitive(X), owl_not_possibly_connected(X).
source_fault(unconnected_class(_)).
pretty_explanation(unconnected_class(X),T) :- format(atom(T),'~w is a class which cannot possibly be connected to any other class through any property.',[X]).
