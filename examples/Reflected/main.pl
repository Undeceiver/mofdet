:- multifile expressivity/1.

:- [util].

% Reasoner expressivity
% Change the antecedent of these rules to true to set a particular expressivity.
full_expressivity :- false.
almost_full_expressivity :- false.
conservative_expressivity :- false.
no_new_elements_expressivity :- false.
no_free_elements_expressivity :- false.
no_free_elements_ndn_expressivity :- false.
standard_expressivity :- true.

:- [expressivity].

:- [alphabet].
:- [axioms].
:- [context].

:- [depth].
:- [metalogic].

:- [detect].
:- [patterns].

% Proof method
% Change the antecedent or the max depth of one of these statements to set a particular proof method.
use_unbounded_provable :- false.
use_iterative_provable(4) :- true.
use_bounded_provable(_) :- false.

% Assume completeness or consistency for the preferred ontology
assume_complete :- true.
assume_consistent :- true.

:- [test].
:- [tests].
