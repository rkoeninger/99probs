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
palindrome(Xs) :- rev(Xs, Xs).

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
remove_singles([X | Xs], [X | Ys])      :- !, remove_singles(Xs, Ys).

encode_modified(Xs, Zs) :- encode(Xs, Ys), remove_singles(Ys, Zs).

% P12 (**) Decode a run-length encoded list.
decompress([], []).
decompress([[1, X] | Xs], [X | Ys]) :- decompress(Xs, Ys).
decompress([[N, X] | Xs], [X | Ys]) :- N1 is N - 1, decompress([[N1, X] | Xs], Ys).
decompress([X | Xs], [X | Ys])      :- decompress(Xs, Ys).

% P13 (**) Run-length encoding of a list (direct solution).
count_head(_, [], 0).
count_head(X, [X | Xs], N) :- count_head(X, Xs, M), N is M + 1, !.
count_head(_, _, 0).

count_head([X | Xs], N) :- count_head(X, [X | Xs], N).

skip(N, X, X) :- N =< 0, !.
skip(N, [_ | Xs], Ys) :- M is N - 1, skip(M, Xs, Ys).

encode_direct([], []).
encode_direct([X | Xs], [X      | Ys]) :- count_head([X | Xs], 1), encode_direct(Xs, Ys), !.
encode_direct([X | Xs], [[N, X] | Ys]) :- count_head([X | Xs], N), skip(N, [X | Xs], Zs), encode_direct(Zs, Ys).

% P14 (*) Duplicate the elements of a list.
dupli([], []).
dupli([X | Xs], [X, X | Ys]) :- dupli(Xs, Ys).

% P15 (**) Duplicate the elements of a list a given number of times.
repeat(0, _, []).
repeat(N, X, [X | Xs]) :- repeat(M, X, Xs), N is M + 1.

dupln([], _, []) :- !.
dupln([X | Xs], N, Ys) :- dupln(Xs, N, Zs), repeat(N, X, Ws), cn(Ws, Zs, Ys), !.

% P16 (**) Drop every N'th element from a list.
dropn([], _, _, []) :- !.
dropn([_ | Xs], N, 1, Ys) :- !, dropn(Xs, N, N, Ys).
dropn([X | Xs], N, M, [X | Ys]) :- !, L is M - 1, dropn(Xs, N, L, Ys).

drop(Xs, N, Ys) :- dropn(Xs, N, N, Ys).

% P17 (*) Split a list into two parts; the length of the first part is given.
split([X | Xs], N, [X | Ys], Zs) :- split(Xs, M, Ys, Zs), N is M + 1.
split(Xs, 0, [], Xs).

% This is cleaner, but disallowed by the prompt:
% split(Xs, N, Ys, Zs) :- cn(Ys, Zs, Xs), count(Ys, N).

% P18 (**) Extract a slice from a list.
slice(Xs, I, J, Ys) :- split(Xs, I, _, Zs), split(Zs, K, Ys, _), J is I + K.

% P19 (**) Rotate a list N places to the left.
rotate(Xs, 0, Xs) :- !.
rotate(Xs, N, Ys) :- N > 0, !, split(Xs, N, XLs, XRs), cn(XRs, XLs, Ys).
rotate(Xs, N, Ys) :- !, count(Xs, L), M is L + N, split(Xs, M, XLs, XRs), cn(XRs, XLs, Ys).

% P20 (*) Remove the K'th element from a list.
remove_at(X, Xs, N, Ys) :- count(Xs, L), M is N + 1, at(N, Xs, X), slice(Xs, 0, N, XLs), slice(Xs, M, L, XRs), cn(XLs, XRs, Ys).

% P21 (*) Insert an element at a given position into a list.
insert_at(X, Xs, N, Ys) :- split(Xs, M, XLs, XRs), N is M + 1, cn(XLs, [X], YLs), cn(YLs, XRs, Ys).

% P22 (*) Create a list containing all integers within a given range.
range(N, N, [N]) :- !.
range(N, K, [N | Ns]) :- M is N + 1, range(M, K, Ns).

% P23 (**) Extract a given number of randomly selected elements from a list.
rnd_select(_, 0, []).
rnd_select(Xs, N, [R | Rs]) :- count(Xs, L), random(0, L, I), remove_at(R, Xs, I, Ys), rnd_select(Ys, M, Rs), N is M + 1.

% P24 (*) Lotto: Draw N different random numbers from the set 1..M.
lotto(N, M, Rs) :- range(1, M, Xs), rnd_select(Xs, N, Rs), !.

% P25 (*) Generate a random permutation of the elements of a list.
rnd_permu(Xs, Ys) :- count(Xs, L), rnd_select(Xs, L, Ys), !.

% P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list.
cat(Xs, [], Xs) :- !.
cat([], Xs, Xs).
cat([X | Xs], Ys, [X | Zs]) :- cat(Xs, Ys, Zs).

in(Prefix, X, Suffix, Whole) :- cat(Prefix, [X | Suffix], Whole).

in(X, [Prefix | Suffix], Whole) :- in(Prefix, X, Suffix, Whole).

combination(0, _,  []).
combination(K, Xs, [X | Ys]) :- J is K - 1, in(X, Others, Xs), combination(J, Others, Ys).
