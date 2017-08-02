#!/usr/bin/prolog

:- [main].

:- initialization main.

main :- findall(_,detect_faults_pretty,_), write('\n'), halt(0).
