:- module(test_union,
          [ test_union/0
          ]).

:- use_module(library(plunit)).
:- use_module('../prolog/cinvoke').

:- c_import("#include \"test/test_union.c\"",
            [ 'test/test_union' ],
            [ set_d(-union(convert), +double)
            ]).

test_union :-
    run_tests([c_union]).

:- begin_tests(c_union).

                                                % assumes little endian double
test(float_bytes, Bytes == [31,-123,-21,81,-72,30,19,64]) :-
    Float = 4.78,
    set_d(Union, Float),
    c_load(Union[d], Copy),
    assertion(Copy == Float),
    numlist(0,7,Indexes),
    maplist(float_byte(Union), Indexes, Bytes).

:- end_tests(c_union).

float_byte(Union, N, B) :-
    c_load(Union[s][N], B).
