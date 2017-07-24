:- discontiguous provable/6.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% About the provable predicate
%% provable indicates that a formula is provable under a context.
%% provable takes 6 arguments.
%% - F - Formula: Formula that is provable.
%%	- S - Assumptions: Set of assumptions that are used to prove the formula.
%%	- M - Max depth: Indicates the maximum depth to which the proof search algorithm is let go in the current attempt to find a proof to the formula.
%%	- D - Depth: Indicates the current depth of the proof search algorithm.
%%	- L - Goals: Maintains a set of goals that are being attempted to prove in the proof search algorithm. Each goal is of the form [F,S], meaning that formula F is being attempted to be
%%		proven using assumptions S. This is to cut out proof attempts where the same goal is more than once in the tree (circular proofs).
%%	- A - Proof: Output argument that generates a proof tree with the proof of the formula.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Axioms are handled through assumptions now.
% provable(F,_,_,_,_,A) :- axiom(F,A).

% Var predicate
% If we are checking whether a free meta-variable is a variable, then it is not. We know this because it matches anything, and use cuts to deal with it.
vardep(unstructured(_)) :- !, fail.
vardep(T) :- ground_var(_,T).
%vardep(tv).
%vardep(tu).
vardep(T) :- functor(T,F,A), ground_func(F,A), rec_vardep(T,1,A).
rec_vardep(_,N,A) :- N > A, !, fail.
rec_vardep(T,N,A) :- single_vardep(T,N); is(NN,N+1), rec_vardep(T,NN,A).
single_vardep(T,N) :- arg(N,T,X), vardep(X).
%vardep(f(X,Y)) :- vardep(X); vardep(Y).

% By assumption
provable(F,S,_,_,_,A) :- is_in(F,S), axiom(F,A).
provable(F,S,_,_,_,assumption(F)) :- is_in(F,S), not(axiom(F,_)).

% Reducing rules

% Not rules
% Because I am only enumerating true theorems; the only way in which I need to worry about negation is double negation.
provable(lnot(lnot(F)),S,M,D,L,double_negation_introduction(F,A)) :- expressivity(double_negation_introduction), rec_provable(F,S,M,D+1,L,A).
% Distribution of not with all the other constructs.
provable(lnot(and(F,G)),S,M,D,L,distribute_in_not_and(F,G,A)) :- expressivity(distribute_in_not_and), rec_provable(or(lnot(F),lnot(G)),S,M,D+1,L,A).
provable(lnot(or(F,G)),S,M,D,L,distribute_in_not_or(F,G,A)) :- expressivity(distribute_in_not_or), rec_provable(and(lnot(F),lnot(G)),S,M,D+1,L,A).
provable(lnot(implies(F,G)),S,M,D,L,distribute_in_not_implication(F,G,A)) :- expressivity(distribute_in_not_implication), rec_provable(and(F,lnot(G)),S,M,D+1,L,A).
provable(lnot(forall(V,F)),S,M,D,L,distribute_in_not_forall(V,F,A)) :- expressivity(distribute_in_not_forall), rec_provable(exists(V,lnot(F)),S,M,D+1,L,A).
provable(lnot(exists(V,F)),S,M,D,L,distribute_in_not_exists(V,F,A)) :- expressivity(distribute_in_not_exists), rec_provable(forall(V,lnot(F)),S,M,D+1,L,A).

% And rules
provable(and(F,G),S,M,D,L,and_introduction(F,G,[A1,A2])) :- expressivity(and_introduction), rec_provable(F,S,M,D+1,L,A1), rec_provable(G,S,M,D+1,L,A2).

% Or rules
provable(or(F,G),S,M,D,L,or_introduction_left(F,G,A)) :- expressivity(or_introduction_left), rec_provable(F,S,M,D+1,L,A).
provable(or(F,G),S,M,D,L,or_introduction_right(F,G,A)) :- expressivity(or_introduction_right), rec_provable(G,S,M,D+1,L,A).

% Implication rules
provable(implies(F,G),S,M,D,L,implication_introduction(F,G,A)) :- expressivity(implication_introduction), rec_provable(G,[F|S],M,D+1,L,A).

% Forall rules
provable(forall(V,F),_,_,_,_,forall_variable) :- expressivity(forall_variable), vardep(x(V,F)).
provable(forall(V,F),S,M,D,L,forall_introduction(V,F,A)) :- expressivity(forall_introduction), rec_substf(V,x(V,F),F,R,M,D+1), rec_provable(R,S,M,D+1,L,A).

% Exists rules
provable(exists(V,F),S,M,D,L,exists_introduction(V,F,X,A)) :- expressivity(exists_introduction), rec_substf(V,X,F,R,M,D+1), not(vardep(X)), rec_provable(R,S,M,D+1,L,A).

% Axiomatization of equality
provable(equal(X,X),_,_,_,_,reflexive_equality(X)) :- expressivity(reflexive_equality), not(vardep(X)).
provable(equal(X1,X2),S,M,D,L,symmetric_equality(X1,X2,A)) :- expressivity(symmetric_equality), X1 \== X2, rec_provable(equal(X2,X1),S,M,D+1,L,A).
provable(equal(X1,X2),S,M,D,L,transitive_equality(X1,Y,X2,[A1,A2])) :- expressivity(transitive_equality), rec_provable(equal(X1,Y),S,M,D+1,L,A1), X1 \== Y, X2 \== Y, rec_provable(equal(X2,Y),S,M,D+1,L,A2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% About the substf predicate
%% substf is a relation between two formulas, where one is the result of substituting a variable with a (semantic) term into the other
%% substf takes 6 arguments.
%%	- V - Variable: Variable being substituted.
%%	- X - Value: Value for which the variable is being substituted (a semantic term).
%%	- F - Formula: Formula in which the variable is being substituted.
%%	- R - Result: Formula which results after performing the substitution.
%%	- M - Max depth: Indicates the maximum depth to which the proof search algorithm is let go in the current attempt to find a proof to the formula.
%%	- D - Depth: Indicates the current depth of the proof search algorithm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Substf rules
% For not
substf(V,X,lnot(F),lnot(R),M,D) :- expressivity(substf_not), rec_substf(V,X,F,R,M,D+1).
% For and
substf(V,X,and(F1,F2),and(R1,R2),M,D) :- expressivity(substf_and), rec_substf(V,X,F1,R1,M,D+1), rec_substf(V,X,F2,R2,M,D+1).
% For or
substf(V,X,or(F1,F2),or(R1,R2),M,D) :- expressivity(substf_or), rec_substf(V,X,F1,R1,M,D+1), rec_substf(V,X,F2,R2,M,D+1).
% For implies
substf(V,X,implies(F1,F2),implies(R1,R2),M,D) :- expressivity(substf_implication), rec_substf(V,X,F1,R1,M,D+1), rec_substf(V,X,F2,R2,M,D+1).
% For equal
substf(V,X,equal(F1,F2),equal(R1,R2),M,D) :- expressivity(substf_equal), rec_substt(V,X,F1,R1,M,D+1), rec_substt(V,X,F2,R2,M,D+1).
% For forall
substf(V1,X,forall(V2,F),forall(V2,R),M,D) :- expressivity(substf_forall), V1 \== V2, rec_substf(V1,X,F,R,M,D+1).
% For exists
substf(V1,X,exists(V2,F),exists(V2,R),M,D) :- expressivity(substf_exists), V1 \== V2, rec_substf(V1,X,F,R,M,D+1).
% For ground predicates
substf(V,X,F1,F2,M,D) :- expressivity(substf_predicates), F1 \= unstructured(_), !, F1 =.. [P|A1], length(A1,A), length(A2,A), F2 =.. [P|A2], ground_pred(P,A), rec_rec_substt(V,X,F1,F2,M,D,1,A).
substf(V,X,F1,F2,M,D) :- expressivity(substf_predicates), F2 \= unstructured(_), F2 =.. [P|A2], length(A2,A), length(A1,A), F1 =.. [P|A1], ground_pred(P,A), rec_rec_substt(V,X,F1,F2,M,D,1,A).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% About the substt predicate
%% substt is a relation between two semantic terms, where one is the result of substituting a variable with a (semantic) term into the other
%% substt takes 6 arguments.
%%	- V - Variable: Variable being substituted.
%%	- X - Value: Value for which the variable is being substituted (a semantic term).
%%	- T - Term: Term in which the variable is being substituted.
%%	- R - Result: Formula which results after performing the substitution.
%%	- M - Max depth: Indicates the maximum depth to which the proof search algorithm is let go in the current attempt to find a proof to the formula.
%%	- D - Depth: Indicates the current depth of the proof search algorithm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Substt rules
% Just variables
substt(V,X,T,X,_,_) :- ground_var(V,T).
substt(V,_,T,T,_,_) :- ground_var(U,T), U \= V.
%substt(v,X,tv,X,_,_).
%substt(v,_,tu,tu,_,_).
%substt(u,X,tu,X,_,_).
%substt(u,_,tv,tv,_,_).
% Non-variable replacement
substt(_,_,Y,Y,_,_) :- not(vardep(Y)).
% Functions
%substt(_,_,one,one,_,_).
%substt(_,_,two,two,_,_).
%substt(_,_,three,three,_,_).
%substt(V,X,T1,T2,M,D) :- expressivity(substt_functions), functor(T1,F,A), functor(T2,F,A), ground_func(F,A), rec_rec_substt(V,X,T1,T2,M,D+1,1,A).
% The cut in the line below, I am terribly afraid about it. It is supposed to avoid trying to use the second term to unify if the first already failed, but it certainly seems dangerous.
substt(V,X,T1,T2,M,D) :- expressivity(substt_functions), T1 \= unstructured(_), !, T1 =.. [F|A1], length(A1,A), length(A2,A), T2 =.. [F|A2], ground_func(F,A), rec_rec_substt(V,X,T1,T2,M,D,1,A).
substt(V,X,T1,T2,M,D) :- expressivity(substt_functions), T2 \= unstructured(_), T2 =.. [F|A2], length(A2,A), length(A1,A), T1 =.. [F|A1], ground_func(F,A), rec_rec_substt(V,X,T1,T2,M,D,1,A).
rec_rec_substt(_,_,_,_,_,_,N,A) :- N > A, !.
rec_rec_substt(V,X,T1,T2,M,D,N,A) :- arg(N,T1,X1), arg(N,T2,X2), rec_substt(V,X,X1,X2,M,D+1), is(NN,N+1), rec_rec_substt(V,X,T1,T2,M,D,NN,A).
%substt(V,X,f(X1,X2),f(R1,R2),M,D) :- expressivity(substt_functions), rec_substt(V,X,X1,R1,M,D+1), rec_substt(V,X,X2,R2,M,D+1).

% Extending rules. Only if everything failed at the previous level. This introduces formulas with no structure to the search, which makes it noticeably more inefficient.
% Not rules
% Because I am only enumerating true theorems; the only way in which I need to worry about negation is double negation.
provable(F,S,M,D,L,double_negation_elimination(F,A)) :- expressivity(double_negation_elimination), rec_provable(lnot(lnot(F)),S,M,D+1,L,A).
% Distribution of not with all the other rules.
provable(or(F,G),S,M,D,L,distribute_out_or_not(F,G,A)) :- expressivity(distribute_out_or_not), rec_provable(lnot(and(lnot(F),lnot(G))),S,M,D+1,L,A).
provable(and(F,G),S,M,D,L,distribute_out_and_not(F,G,A)) :- expressivity(distribute_out_and_not), rec_provable(lnot(or(lnot(F),lnot(G))),S,M,D+1,L,A).
provable(forall(V,F),S,M,D,L,distribute_out_forall_not(V,F,A)) :- expressivity(distribute_out_forall_not), rec_provable(lnot(exists(V,lnot(F))),S,M,D+1,L,A).
provable(exists(V,F),S,M,D,L,distribute_out_exists_not(V,F,A)) :- expressivity(distribute_out_exists_not), rec_provable(lnot(forall(V,lnot(F))),S,M,D+1,L,A).

% And rules
provable(F,S,M,D,L,and_elimination_left(F,G,A)) :- expressivity(and_elimination_left), rec_provable(and(F,G),S,M,D+1,L,A).
provable(F,S,M,D,L,and_elimination_right(F,G,A)) :- expressivity(and_elimination_right), rec_provable(and(G,F),S,M,D+1,L,A).

% Or rules
provable(R,S,M,D,L,or_elimination(F,G,R,[A1,A2,A3])) :- expressivity(or_elimination), rec_provable(or(F,G),S,M,D+1,L,A1), rec_provable(R,[F|S],M,D+1,L,A2), rec_provable(R,[G|S],M,D+1,L,A3).

% Implication rules
provable(G,S,M,D,L,modus_ponens(F,G,[A1,A2])) :- expressivity(modus_ponens), rec_provable(implies(F,G),S,M,D+1,L,A1), rec_provable(F,S,M,D,L,A2).

% Forall rules
provable(R,S,M,D,L,forall_elimination(V,F,X,A)) :- expressivity(forall_elimination), rec_substf(V,X,F,R,M,D+1), F \== R, not(vardep(X)), rec_provable(forall(V,F),S,M,D+1,L,A).

% Exists rules
provable(R,S,M,D,L,exists_elimination(V,F,A)) :- expressivity(exists_elimination), rec_substf(V,y(V,F),F,R,M,D+1), F \== R, rec_provable(exists(V,F),S,M,D+1,L,A).
