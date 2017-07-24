% This file should be generated from the ontology.
% The particular form of the context may differ.
owl_primitive(edam_topping).
owl_primitive(mozzarella_topping).
owl_primitive(cheddar_topping).
owl_primitive(parmezan_topping).
owl_primitive(edamozzarella_topping).
owl_primitive(pizza).
owl_domain(has_topping,pizza).
owl_range(has_topping,pizza_topping).
owl_defined(_) :- !, fail.
