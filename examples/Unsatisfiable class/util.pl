% Append
append(X,X,[]).
append([X|Y],Z,[X|W]) :- append(Y,Z,W) .

is_in(F,[F|_]).
is_in(F,[_|Y]) :- is_in(F,Y).

is_exactly_in(F,[X|_]) :- F == X.
is_exactly_in(F,[_|Y]) :- is_exactly_in(F,Y).

first(G) :- G, !, asserta(G).

:- dynamic noted/2.
no_repeat(G,ID) :- G, not(noted(G,ID)), asserta(noted(X,ID) :- X == G).
no_repeat(_,ID) :- retractall(noted(_,ID)), fail.
no_repeat(G,P,ID) :- G, not(noted(P,ID)), asserta(noted(X,ID) :- X == P).
no_repeat(_,_,ID) :- retractall(noted(_,ID)), fail.

not_ground(X,Y) :- not(ground(X)); not(ground(Y)).

:- dynamic cur_id/1.
:- asserta(cur_id(1)).
get_id(X) :- cur_id(X), retract(cur_id(X)), is(Y,X+1), asserta(cur_id(Y)).

sublist(S,L) :- get_id(ID), no_repeat(sublist_rec(S,L),S,ID).
sublist_rec(L,L).
sublist_rec(S,[_|R]) :- sublist(S,R).
sublist_rec([X|S],[X|R]) :- sublist(S,R).
