# A taste of ontology-powered robotics
A small sketch of a declarative robotic scheduler in Prolog.

## Getting started
The following has only been tested on [Scryer Prolog].

```prolog
% Load the file main.pl in Scryer
?- [main].


%% Example queries

% See all flasks (declared in devices.pl). Keep pressing ; to see all possible answers.
?- flask(F).
   F = flask0
;  F = flask1
;  F = flask2
;  F = flask3
;  F = flask4
;  F = flask5
;  F = flask6
;  F = flask7
;  F = flask8
;  F = flask9
;  F = flask10.

% See all actions the setup is capable of.
?- can(Capability).
   Capability = source(flask0,0)
   ...

% Find all possible operations for transferring liquid between flask5 and and separator1.
?- operations(source(flask5, Port1), sink(separator1, Port2), Ops).
   Ops = [source(flask5,0),route(valve3,1,-1),pull(pump3,Port1),push(pump3,Port1),route(valve3,-1,2),sink(separator1,top)], Port1 = 0, Port2 = top
   ...
```

[Scryer prolog]: https://github.com/mthom/scryer-prolog