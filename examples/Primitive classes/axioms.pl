% This file should be generated from the ontology.
% Axioms
% The form of the axioms is:
%	axiom(formula,name).
axiom(forall(v1,implies(spicy_topping(v1),pizza_topping(v1))),spicy_topping_pizza_topping).
axiom(forall(v1,implies(meat_topping(v1),pizza_topping(v1))),meat_topping_pizza_topping).
axiom(forall(v1,implies(spicy_beef_topping(v1),spicy_topping(v1))),spicy_beef_topping_spicy_topping).
%axiom(forall(v1,implies(spicy_beef_topping(v1),meat_topping(v1))),spicy_beef_topping_meat_topping).
axiom(forall(v2,forall(v1,implies(spicy_beef_topping(v1),meat_topping(v1)))),spicy_beef_topping_meat_topping).
