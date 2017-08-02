#!/usr/bin/prolog

:- [main].

:- initialization main.

main :- run_tests, write('\n'), halt(0).
