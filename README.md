# vote-schulze

This gem is a Ruby implementation of the Schulze voting method (with help of the Floyd–Warshall algorithm), a type of the Condorcet voting methods.

Wikipedia:

* [Schulze method](http://en.wikipedia.org/wiki/Schulze_method) ([deutsch](http://de.wikipedia.org/wiki/Schulze-Methode))
* [Floyd–Warshall algorithm](http://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm)

## Install

``` bash
gem install vote-schulze
```

## Usage

``` ruby
require 'vote-schulze'
vs = SchulzeBasic.do candidate_count, vote_list
vs.ranking_array
```

`SchulzeBasic.do` - SchulzeBasic is a short term for `Vote::Condorcet::Schulze::Basic` and `.do` is a method of this class!

Input:

* `candidate_count` Integer: number of candidates
* `vote_list` Array of Arrays: votes of each voter as weights `[ [A,B,C,...],[A,B,C,...],[A,B,C,...] ]`

preference order to weight example:

```
voter  => A D C B

weight => 4,1,2,3

A is on first position = highest prio == 4
B is on last position                 == 1
C is on third position                == 2
D is on second position               == 3
```

Later versions will have an automatic Preference-to-Weight algorithm.
(Internally only integers are used for calculation of ranking.)

### _SchulzeBasic_

It doesn't matter if you start counting at 0 (zero) or 1 (one).

Also it's not important, if you use jumps (like `1 3 5 9`).

Internally it will only check if candidate X > candidate Y

Output:

* `.ranking_array` Array: numbers of total wins for each candidate `[candidate A, candidate B, candidate C, ...]`

## Contributing to vote-schulze

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Use git-flow
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Christoph Grabo. See LICENSE.txt for further details.

