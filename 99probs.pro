% P01 (*) Find the last element of a list.
my_last([X], X) :- !.
my_last([_ | Xs], Y) :- my_last(Xs, Y).

% P02 (*) Find the last but one element of a list.
my_but_last([X, _], X) :- !.
my_but_last([_, X | Xs], Y) :- my_but_last([X | Xs], Y).

% P03 (*) Find the K'th element of a list.
at(0, [X | _], X) :- !.
at(N, [_ | Xs], Y) :- M is N - 1, at(M, Xs, Y).

% P04 (*) Find the number of elements of a list.
count([], 0) :- !.
count([_ | Xs], N) :- count(Xs, M), N is M + 1.

% P05 (*) Reverse a list.
cn(Xs, [], Xs).
cn([], Xs, Xs).
cn([X | Xs], Ys, [X | Zs]) :- cn(Xs, Ys, Zs).

rev([], []).
rev([X | Xs], Zs) :- rev(Xs, Ys), cn(Ys, [X], Zs).

% P06 (*) Find out whether a list is a palindrome.
palindrome(Xs) :- rev(Xs, Ys), Xs = Ys.

% P07 (**) Flatten a nested list structure.
flat([], []).
flat([X | Xs], Ys) :- is_list(X), flat(X, Z), flat(Xs, Zs), cn(Z, Zs, Ys), !.
flat([X | Xs], [X | Zs]) :- flat(Xs, Zs).

% P08 (**) Eliminate consecutive duplicates of list elements.
compress([], []) :- !.
compress([X], [X]) :- !.
compress([X, X | Xs], Ys) :- compress([X | Xs], Ys), !.
compress([X | Xs], [X | Ys]) :- compress(Xs, Ys).

% P09 (**) Pack consecutive duplicates of list elements into sublists.
pack([[X | Xs], X | Ys], Zs) :- !, pack([[X, X | Xs] | Ys], Zs).
pack([[X | Xs], Y | Ys], [[X | Xs] | Zs]) :- X \= Y, !, pack([[Y] | Ys], Zs).
pack([X | Ys], [X | Zs]) :- is_list(X), !, pack(Ys, Zs).
pack([X | Xs], Zs) :- !, pack([[X] | Xs], Zs).
pack([], []).

% P10 (*) Run-length encoding of a list.
encode([[N, X], X | Ys], Zs) :- !, M is N + 1, encode([[M, X] | Ys], Zs).
encode([[N, X], Y | Ys], [[N, X] | Zs]) :- X \= Y, !, encode([[1, Y] | Ys], Zs).
encode([X | Ys], [X | Zs]) :- is_list(X), !, encode(Ys, Zs).
encode([X | Ys], Zs) :- !, encode([[1, X] | Ys], Zs).
encode([], []).

% P11 (*) Modified run-length encoding.
remove_singles([], []) :- !.
remove_singles([[1, X] | Xs], [X | Ys]) :- !, remove_singles(Xs, Ys).
remove_singles([X | Xs], [X | Ys]) :- !, remove_singles(Xs, Ys).

encode_modified(Xs, Zs) :- encode(Xs, Ys), remove_singles(Ys, Zs).

% P12 (**) Decode a run-length encoded list.
decompress_decode_modified([], []) :- !.
decompress_decode_modified([[_, X] | Xs], [X | Ys]) :- !, decompress_decode_modified(Xs, Ys).
decompress_decode_modified([X | Xs], [X | Ys]) :- !, decompress_decode_modified(Xs, Ys).

% P13 (**) Run-length encoding of a list (direct solution).


% P14 (*) Duplicate the elements of a list.
dupli([], []) :- !.
dupli([X | Xs], [X, X | Ys]) :- dupli(Xs, Ys).

% P15 (**) Duplicate the elements of a list a given number of times.


% P16 (**) Drop every N'th element from a list.
dropn([], _, _, []) :- !.
dropn([_ | Xs], N, 1, Ys) :- !, dropn(Xs, N, N, Ys).
dropn([X | Xs], N, M, [X | Ys]) :- !, L is M - 1, dropn(Xs, N, L, Ys).

drop(Xs, N, Ys) :- dropn(Xs, N, N, Ys).

% P17 (*) Split a list into two parts; the length of the first part is given.
split([X | Xs], N, [X | Ys], Zs) :- split(Xs, M, Ys, Zs), N is M + 1.
split(Xs, 0, [], Xs).

% This is cleaner, but disallowed:
%split(Xs, N, Ys, Zs) :- cn(Ys, Zs, Xs), count(Ys, N).

% P18 (**) Extract a slice from a list.
slice(Xs, I, J, Ys) :- split(Xs, I, _, Zs), split(Zs, K, Ys, _), J is I + K.

% P19 (**) Rotate a list N places to the left.
rotate(Xs, 0, Xs) :- !.
rotate(Xs, N, Ys) :- N > 0, !, split(Xs, N, XLs, XRs), cn(XRs, XLs, Ys).
rotate(Xs, N, Ys) :- !, count(Xs, L), M is L + N, split(Xs, M, XLs, XRs), cn(XRs, XLs, Ys).
