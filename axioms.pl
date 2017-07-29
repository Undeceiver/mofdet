% This file should be generated from the ontology.
% Axioms
% The form of the axioms is:
%	axiom(formula,name).
axiom(forall(v1,implies(edam_topping(v1),pizza_topping(v1))),edam_topping).
axiom(forall(v1,implies(mozzarella_topping(v1),pizza_topping(v1))),mozzarella_topping).
axiom(forall(v1,implies(cheddar_topping(v1),pizza_topping(v1))),cheddar_topping).
axiom(forall(v1,implies(parmezan_topping(v1),pizza_topping(v1))),parmezan_topping).
axiom(forall(v1,forall(v2,implies(has_topping(v1,v2),and(pizza(v1),pizza_topping(v2))))),has_topping_range_domain).
axiom(forall(v1,implies(exists(v2,and(edam_topping(v2),has_topping(v1,v2))),lnot(exists(v2,and(mozzarella_topping(v2),has_topping(v1,v2)))))),if_edam_not_mozzarella).
axiom(forall(v1,implies(exists(v2,and(mozzarella_topping(v2),has_topping(v1,v2))),lnot(exists(v2,and(edam_topping(v2),has_topping(v1,v2)))))),if_mozzarella_not_edam).
axiom(forall(v1,implies(edamozzarella_topping(v1),edam_topping(v1))),edamozzarella_is_edam).
axiom(forall(v1,implies(edamozzarella_topping(v1),mozzarella_topping(v1))),edamozzarella_is_mozzarella).

% Lemmas added as axioms because the prover cannot prove them.
axiom(lnot(exists(v1,and(edamozzarella_topping(v1),exists(v2,has_topping(v1,v2))))),edamozzarella_not_domain).
axiom(lnot(exists(v1,and(edamozzarella_topping(v1),exists(v2,has_topping(v2,v1))))),edamozzarella_not_range).
