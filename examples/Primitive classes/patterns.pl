:- discontiguous faulty/2.
:- discontiguous source_fault/1.

% Utility definitions for patterns.
class(X) :- ground_pred(X,1).

owl_subsumption(A,B,forall(v1,implies(TB,TA))) :- class(A), class(B), TA =.. [A,tv1], TB =.. [B,tv1].
owl_subsumes(A,B,P) :- owl_subsumption(A,B,F), do_proof(F,P).
% owl_subsumes(A,B,P) :- class(A), class(B), TA =.. [A,tv1], TB =.. [B,tv1], do_proof(forall(v1,implies(TB,TA)),P).

% The equality verifications on the below rule could be moved before to improve performance, but for now we leave it in the end for maximum expressivity.
owl_cycle(A,B,C,D,[A1,A2,A3,A4]) :- owl_subsumes(A,B,A1), owl_subsumes(A,C,A2), owl_subsumes(B,D,A3), owl_subsumes(C,D,A4),
	not(owl_subsumes(B,C,_)), not(owl_subsumes(C,B,_)), A \== B, A \== C, A \== D, B \== C, B \== D, C \== D.

extract_fault(incompatible(F),make_break(X,Y)) :- owl_subsumption(X,Y,F).
extract_fault(insufficient(F),make_order(X,Y)) :- owl_subsumption(X,Y,F).
extract_fault(misrepresentation(owl_defined(X),owl_primitive(X)),make_defined(X)).
extract_fault(incompatible(X),incompatible(X)).
extract_fault(insufficient(X),insufficient(X)).
extract_fault(misrepresentation(X,Y),misrepresentation(X,Y)).

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

% Example 3.1. - Defined classes should not subsume primitive classes
faulty([incompatible(owl_subsumes(X,Y))],defined_subsume_primitive(X,Y)) :- owl_defined(X), owl_primitive(Y), owl_subsumes(X,Y).
source_fault(defined_subsume_primitive(_,_)).
