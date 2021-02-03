:- use_module(library(lists)).

% Interpolation rules
interpolation(A, B, C) :- findall(X, can(X), Ops), interpolation(A, B, C, Ops).
interpolation(A, B, [], _) :- can(A), can(B), can_follow(A, B).
interpolation(A, B, [C|Cs], D) :- can(A), can_follow(A, C), select(C, D, E), interpolation(C, B, Cs, E).
%% convenience predicate that adds the beginning and end operations as well
operations(A, B, C) :- interpolation(A, B, D), append([A|D], [B], C).

% Liquid flow rules
%% source
can_follow(source(Node1, Port1), sink(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(source(Node1, Port1), pull(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(source(Node1, Port1), route(Node2, Port2, _)) :- edge(_, Node1, Node2, Port1, Port2).
%% route
can_follow(route(Node1, _, Port1), route(Node2, Port2, _)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(route(Node1, _, Port1), sink(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(route(Node1, _, Port1), pull(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
%% sink
can_follow(pull(Node, _), push(Node, _)).
%% push
can_follow(push(Node1, Port1), sink(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(push(Node1, Port1), pull(Node2, Port2)) :- edge(_, Node1, Node2, Port1, Port2).
can_follow(push(Node1, Port1), route(Node2, Port2, _)) :- edge(_, Node1, Node2, Port1, Port2).

% move
expand(move(Node1, Node2, Port1, Port2), Ops) :-
    (Op1 = source(Node1, Port1); Op1 = push(Node1, Port1)),
    (Op2 = sink(Node2, Port2); Op2 = pull(Node2, Port2)),
    can(Op1), can(Op2),
    operations(Op1, Op2, Ops),
    %% make sure there is at least one non-passive action
    active_seq(Ops).
expand(move(Node1, Node2), C) :- expand(move(Node1, Node2, _, _), C).

% connect
expand(connect(Node1, Node2), Ops) :-
    node(Op1, Node1), node(Op2, Node2),
    (operations(Op1, Op2, Ops); operations(Op2, Op1, Ops)),
    %% make sure ops can happen simultaneously
    queue_ops(Ops, seq([_])).

% shortest expansion
shortest(List, Item) :- member(Item, List), maplist(length, List, Ls), min_list(Ls, L), length(Item, L).
expand_shortest(Action, Ops) :- setof(A, expand(Action, A), AllOps), shortest(AllOps, Ops).

% node
node(source(N, E), N) :- can(source(N, E)).
node(sink(N, E), N) :- can(sink(N, E)).
node(push(N, E), N) :- can(push(N, E)).
node(pull(N, E), N) :- can(pull(N, E)).
node(route(N, E1, E2), N) :- can(route(N, E1, E2)).

% active and passive ops/sequences
active(push(_, _)).
active(pull(_, _)).
active_seq(Xs) :- member(X, Xs), active(X).
passive(source(_, _)).
passive(sink(_, _)).
passive(route(_, _)).
passive_seq([X|Xs]) :- length(Xs, _), maplist(passive, [X|Xs]).

% compatibility
compatible(Op, []) :- can(Op).
compatible(Op1, [Op2|Ops]) :- compatible(Op1, Ops), node(Op1, N1), node(Op2, N2), dif(N1, N2).

incompatible(Op1, Ops) :- node(Op1, N), node(Op2, N), dif(Op1, Op2), member(Op2, Ops).


% scheduling
%% data structures:
%% seq([...]): list of actions to be performed sequentially
%% par([...]): list of actions to be performed in parallel
%% each action can in turn be a seq([...]) or par([...])
insert(I, seq([]), seq([par([I])])).
insert(I, seq([par(L)|X]), seq([par([I|L])|X])) :- compatible(I, L).
insert(I, seq([par(L)|X]), seq([par([I]), par(L)|X])) :- incompatible(I, L).

queue_ops(Ops, Sched) :- reverse(Ops, Js), foldl(insert, Js, seq([]), Sched).