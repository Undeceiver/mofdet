% This file should be generated from the ontology.
% Axioms
% The form of the axioms is:
%	axiom(formula,name).
axiom(forall(v1,implies(spicy_topping(tv1),pizza_topping(tv1))),spicy_topping_pizza_topping).
axiom(forall(v1,implies(meat_topping(tv1),pizza_topping(tv1))),meat_topping_pizza_topping).
axiom(forall(v1,implies(spicy_beef_topping(tv1),spicy_topping(tv1))),spicy_beef_topping_spicy_topping).
axiom(forall(v1,implies(spicy_beef_topping(tv1),meat_topping(tv1))),spicy_beef_topping_meat_topping).
