% This file should be generated from the ontology.
% Axioms
% The form of the axioms is:
%	axiom(formula,name).
axiom(forall(v1,implies(edam_topping(tv1),pizza_topping(tv1))),edam_topping).
axiom(forall(v1,implies(mozzarella_topping(tv1),pizza_topping(tv1))),mozzarella_topping).
axiom(forall(v1,implies(cheddar_topping(tv1),pizza_topping(tv1))),cheddar_topping).
axiom(forall(v1,implies(parmezan_topping(tv1),pizza_topping(tv1))),parmezan_topping).
axiom(forall(v1,forall(v2,implies(has_topping(tv1,tv2),and(pizza(tv1),pizza_topping(tv2))))),has_topping_range_domain).
axiom(forall(v1,implies(exists(v2,and(edam_topping(tv2),has_topping(tv1,tv2))),lnot(exists(v2,and(mozzarella_topping(tv2),has_topping(tv1,tv2)))))),if_edam_not_mozzarella).
axiom(forall(v1,implies(exists(v2,and(mozzarella_topping(tv2),has_topping(tv1,tv2))),lnot(exists(v2,and(edam_topping(tv2),has_topping(tv1,tv2)))))),if_mozzarella_not_edam).
axiom(forall(v1,implies(edamozzarella_topping(tv1),edam_topping(tv1))),edamozzarella_is_edam).
axiom(forall(v1,implies(edamozzarella_topping(tv1),mozzarella_topping(tv1))),edamozzarella_is_mozzarella).

% Axioms added because the prover cannot prove them.
axiom(lnot(exists(v1,and(edamozzarella_topping(tv1),exists(v2,has_topping(tv1,tv2))))),edamozzarella_not_domain).
axiom(lnot(exists(v1,and(edamozzarella_topping(tv1),exists(v2,has_topping(tv2,tv1))))),edamozzarella_not_range).
