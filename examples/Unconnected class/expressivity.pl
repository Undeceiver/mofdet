:- multifile expressivity/1.
:- dynamic expressivity/1.

% Full expressivity: Everything allowed.
expressivity(_) :- full_expressivity.

% Extremely conservative expressivity.
conservative_expressivity(and_introduction).
conservative_expressivity(or_introduction_left).
conservative_expressivity(or_introduction_right).
conservative_expressivity(implication_introduction).
conservative_expressivity(forall_variable).
conservative_expressivity(reflexive_equality).
conservative_expressivity(symmetric_equality).
conservative_expressivity(substf_not).
conservative_expressivity(substf_and).
conservative_expressivity(substf_or).
conservative_expressivity(substf_implication).
conservative_expressivity(substf_equal).
conservative_expressivity(substf_forall).
conservative_expressivity(substf_exists).
conservative_expressivity(substt_functions).
conservative_expressivity(substf_predicates).
expressivity(X) :- conservative_expressivity, conservative_expressivity(X).

% All except or_elimination
almost_full_expressivity(or_elimination) :- !, fail.
almost_full_expressivity(_).
expressivity(X) :- almost_full_expressivity, almost_full_expressivity(X).

% No new elements expressivity. Allows everything except rules which generate new elements.
no_new_elements_expressivity(transitive_equality) :- !, fail.
no_new_elements_expressivity(and_elimination_left) :- !, fail.
no_new_elements_expressivity(and_elimination_right) :- !, fail.
no_new_elements_expressivity(or_elimination) :- !, fail.
no_new_elements_expressivity(forall_elimination) :- !, fail.
no_new_elements_expressivity(exists_elimination) :- !, fail.
no_new_elements_expressivity(modus_ponens) :- !, fail.
no_new_elements_expressivity(_).
expressivity(X) :- no_new_elements_expressivity, no_new_elements_expressivity(X).

% No free elements expressivity. Like no new elements, but allows unification through forall and exists elimination.
no_free_elements_expressivity(X) :- no_new_elements_expressivity(X).
no_free_elements_expressivity(forall_elimination).
no_free_elements_expressivity(exists_elimination).
expressivity(X) :- no_free_elements_expressivity, no_free_elements_expressivity(X).

% No free elements without double negation elimination.
no_free_elements_ndn_expressivity(double_negation_elimination) :- !, fail.
no_free_elements_ndn_expressivity(X) :- no_free_elements_expressivity(X).
expressivity(X) :- no_free_elements_ndn_expressivity, no_free_elements_ndn_expressivity(X).

% Standard: No new elements, but forall elimination and exists elimination are allowed. Double negation is not allowed, and transitive equality is allowed.
standard_expressivity(X) :- no_free_elements_ndn_expressivity(X).
standard_expressivity(transitive_equality).
expressivity(X) :- standard_expressivity, standard_expressivity(X).

% Assert all expressivity.
assert_expressivity(X) :- expressivity(X), asserta(expressivity(X) :- !), !.
assert_expressivity(_).
:- assert_expressivity(double_negation_introduction).
:- assert_expressivity(distribute_in_not_and).
:- assert_expressivity(distribute_in_not_or).
:- assert_expressivity(distribute_in_not_forall).
:- assert_expressivity(distribute_in_not_exists).
:- assert_expressivity(distribute_in_not_implication).
:- assert_expressivity(and_introduction).
:- assert_expressivity(or_introduction_left).
:- assert_expressivity(or_introduction_right).
:- assert_expressivity(implication_introduction).
:- assert_expressivity(forall_variable).
:- assert_expressivity(forall_introduction).
:- assert_expressivity(exists_introduction).
:- assert_expressivity(reflexive_equality).
:- assert_expressivity(symmetric_equality).
:- assert_expressivity(transitive_equality).
:- assert_expressivity(substf_not).
:- assert_expressivity(substf_and).
:- assert_expressivity(subst_or).
:- assert_expressivity(substf_implication).
:- assert_expressivity(substf_equal).
:- assert_expressivity(substf_forall).
:- assert_expressivity(substf_exists).
:- assert_expressivity(substf_predicates).
:- assert_expressivity(substt_functions).
:- assert_expressivity(double_negation_elimination).
:- assert_expressivity(distribute_out_or_not).
:- assert_expressivity(distribute_out_and_not).
:- assert_expressivity(distribute_out_forall_not).
:- assert_expressivity(distribute_out_exists_not).
:- assert_expressivity(and_elimination_left).
:- assert_expressivity(and_elimination_right).
:- assert_expressivity(or_elimination).
:- assert_expressivity(modus_ponens).
:- assert_expressivity(forall_elimination).
:- assert_expressivity(exists_elimination).
