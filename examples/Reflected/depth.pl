:- dynamic provable/6.
:- dynamic substf/6.
:- dynamic substt/6.
:- dynamic unboundedprovable/5.
:- dynamic iterativeprovable/5.
:- dynamic build_axioms/1.

% Building assumptions from axioms.
build_axioms(S) :- build_axioms_rec([],S), asserta(build_axioms(S) :- !).
build_axioms_rec(L,S) :- axiom(F,_), not(is_exactly_in(F,L)), !, build_axioms_rec([F|L],S).
build_axioms_rec(S,S).

% Iterative deepening and checking for cyclic proofs. Also, use only the first proof found for a statement.
% rec_provable(F,S,M,D,L,A) :- D =< M, not(is_exactly_in([F,S],L)), provable(F,S,M,D,[[F,S]|L],A), !, asserta(provable(F,S,_,_,_,A) :- !).
rec_provable(F,S,M,D,L,A) :- D =< M, not(is_exactly_in([F,S],L)), provable(F,S,M,D,[[F,S]|L],A), !.
% rec_substf(V,X,F,R,M,D) :- D =< M, substf(V,X,F,R,M,D), !, asserta(substf(V,X,F,R,_,_) :- !).
rec_substf(V,X,F,R,M,D) :- D =< M, substf(V,X,F,R,M,D), !.
% rec_substt(V,X,T,R,M,D) :- D =< M, substt(V,X,T,R,M,D), !, asserta(substt(V,X,T,R,_,_) :- !).
rec_substt(V,X,T,R,M,D) :- D =< M, substt(V,X,T,R,M,D), !.

% unboundedprovable keeps iteratively deepening the search until a proof is found (never halting if no proof is found).
unboundedprovable(F,M,0,A) :- build_axioms(S), unboundedprovable(F,S,M,0,A).
% unboundedprovable(F,S,M,0,A) :- provable(F,S,M,0,[[F,[]]],A), !, asserta(unboundedprovable(F2,S2,M,0,A) :- (F2 == F, S2 == S, !)).
unboundedprovable(F,S,M,0,A) :- provable(F,S,M,0,[[F,[]]],A).
unboundedprovable(F,S,M,0,A) :- unboundedprovable(F,S,M+1,0,A).

% iterativeprovable keeps doing bounded proof search for each depth up to the specified maximum. 
% The difference with boundedprovable is that if a short proof exists for the formula, iterativeprovable will find it without trying longer proofs before, 
% but if the proof is long, iterativeprovable will waste time trying shorter proofs before.
iterativeprovable(F,M,D,A) :- build_axioms(S), iterativeprovable(F,S,M,D,A).
% iterativeprovable(F,S,_,D,A) :- boundedprovable(F,S,D,A), !, asserta(iterativeprovable(F2,S2,_,D,A) :- (F2 == F, S2 == S, !)).
iterativeprovable(F,S,_,D,A) :- boundedprovable(F,S,D,A).
iterativeprovable(F,S,M,D,A) :- D < M, iterativeprovable(F,S,M,D+1,A).

% boundedprovable looks for proofs of a maximum depth for a given formula.
% provable/2 is a shortcoming for unboundedprovable starting with 0 depth. That is, try everything you can to prove the formula.
provable(F,A) :- unboundedprovable(F,0,0,A).
boundedprovable(F,M,A) :- build_axioms(S), boundedprovable(F,S,M,A).
boundedprovable(F,S,M,A) :- provable(F,S,M,0,[[F,[]]],A).
iterativeprovable(F,M,A) :- iterativeprovable(F,M,0,A).


