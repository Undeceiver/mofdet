% This file should be generated from the ontology.
% Axioms
% The form of the axioms is:
%	axiom(formula,name).
axiom(forall(v1,implies(exists(v2,and(edam_topping(v2),has_topping(v1,v2))),lnot(exists(v2,and(mozzarella_topping(v2),has_topping(v1,v2)))))),if_edam_not_mozzarella).
axiom(forall(v1,implies(exists(v2,and(mozzarella_topping(v2),has_topping(v1,v2))),lnot(exists(v2,and(edam_topping(v2),has_topping(v1,v2)))))),if_mozzarella_not_edam).
axiom(forall(v1,implies(four_cheese_pizza(v1),exists(v2,and(edam_topping(v2),has_topping(v1,v2))))),four_cheese_has_edam).
axiom(forall(v1,implies(four_cheese_pizza(v1),exists(v2,and(mozzarella_topping(v2),has_topping(v1,v2))))),four_cheese_has_mozzarella).
axiom(forall(v1,implies(four_cheese_pizza(v1),exists(v2,and(cheddar_topping(v2),has_topping(v1,v2))))),four_cheese_has_cheddar).
axiom(forall(v1,implies(four_cheese_pizza(v1),exists(v2,and(parmezan_topping(v2),has_topping(v1,v2))))),four_cheese_has_parmezan).

% Axioms added because the prover cannot prove them, but they are true.
axiom(lnot(exists(v1,four_cheese_pizza(v1))),unsat_four_cheese).
% axiom(forall(v1,lnot(four_cheese_pizza(v1))),unsat_four_cheese).
