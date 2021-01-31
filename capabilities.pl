can(source(Flask, 0)) :- flask(Flask).

can(source(Filter, 'bottom')) :- filter(Filter).
can(sink(Filter, 'bottom')) :- filter(Filter).
can(sink(Filter, 'top')) :- filter(Filter).

can(pull(Pump, 0)) :- pump(Pump).
can(push(Pump, 0)) :- pump(Pump).

can(sink(Reactor, 0)) :- reactor(Reactor).
can(source(Reactor, 0)) :- reactor(Reactor).

can(source(Separator, 'bottom')) :- separator(Separator).
can(sink(Separator, 'bottom')) :- separator(Separator).
can(sink(Separator, 'top')) :- separator(Separator).

can(route(Valve, -1, 0)) :- valve(Valve).
can(route(Valve, -1, 1)) :- valve(Valve).
can(route(Valve, -1, 2)) :- valve(Valve).
can(route(Valve, -1, 3)) :- valve(Valve).
can(route(Valve, -1, 4)) :- valve(Valve).
can(route(Valve, -1, 5)) :- valve(Valve).
can(route(Valve, 0, -1)) :- valve(Valve).
can(route(Valve, 1, -1)) :- valve(Valve).
can(route(Valve, 2, -1)) :- valve(Valve).
can(route(Valve, 3, -1)) :- valve(Valve).
can(route(Valve, 4, -1)) :- valve(Valve).
can(route(Valve, 5, -1)) :- valve(Valve).

can(sink(Waste, 0)) :- waste(Waste).
