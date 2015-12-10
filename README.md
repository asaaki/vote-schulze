# Schulze Vote

This gem is a Ruby implementation of the Schulze voting method (with help of the Floyd–Warshall algorithm), 
a type of the Condorcet voting methods.


Wikipedia:

* [Schulze method](http://en.wikipedia.org/wiki/Schulze_method) ([deutsch](http://de.wikipedia.org/wiki/Schulze-Methode))
* [Floyd–Warshall algorithm](http://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm)

## Install

``` bash
gem install schulze-vote
```

## Usage

``` ruby
require 'schulze-vote'
vs = SchulzeBasic.do vote_list, candidate_count
vs.ranks
vs.ranks_abc
```

`SchulzeBasic.do` - SchulzeBasic is a short term for `Vote::Condorcet::Schulze::Basic` and `.do` is a method of this class!

Input:

* `vote_list`
  * Array of Arrays: votes of each voter as weights `[ [A,B,C,...],[A,B,C,...],[A,B,C,...] ]`
  * String: "A;B;C\nA;B;C\n;3=A;B;C..."
  * File: first line **must** be a single integer, following lines like vote_list type String (see vote lists under `examples` directory)
* `candidate_count` Integer: number of candidates
  * **required** for vote_list types of Array and String
  * _leave empty if vote_list is a File handle!_

### String/File format:

A typical voters line looks like this:

```
A;B;C;D;E;F
```

You also can say that _n_ voters have the same preferences:

```
n=F;E;D;C;B;A
```

where _n_ is an integer value for the count.

Also it's possible to say that a voter has candidates equally weighted:

```
A,B;C,D;E,F
```

which means, that A + B, C + D and E + F are on the same weight level.

Here only 3 weight levels are used: (A,B) = 3, (C,D) = 2, (E,F) = 1

### Why I must write the candidate count in the first line of the vote file?

_or: Why I must give a candidate count value for Array/String inputs?_

Very easy: The reason is, that voters can leave out candidates (they give no special preferences).

So, schulze-vote needs to know, how many real candidates are in the voting process.

Okay, for Array inputs it's currently a little bit overhead, because the voters array normally should have the size of the candidates count.
See it as an visual reminder while coding with this gem.

### Examples

#### Array

(Only weight values, no letters here! See section "_preference order to weight_ example")

``` ruby
require 'schulze-vote'
vote_list_array = [[3,2,1],[1,3,2],[3,1,2]]
vs = SchulzeBasic.do vote_list_array, 3
```

#### String

``` ruby
require 'schulze-vote'
vote_list_string = <<EOF
A;B;C
B;C;A
A;C;B
A,C,B
4=C;A;B
EOF
vs = SchulzeBasic.do vote_list_string, 3
```

#### File

``` ruby
require 'schulze-vote'
vs = SchulzeBasic.do File.open('path/to/vote.list')
```

### _preference order to weight_ example

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

* `.ranks` Array: numbers of total wins for each candidate `[candidate A, candidate B, candidate C, ...]`
* `.winners_array` Array: set 1 if the candidate is a potential winner `[candidate A, candidate B, candidate C, ...]`

## Example

Reference calculation: [Schulze Methode | blog.cgiesel.de (german)](http://blog.cgiesel.de/schulze-methode/)

Example file under `examples/vote4.list`

Result should be:

``` ruby
sb = SchulzeBasic.do File.open('../examples/vote4.list')
sb.rank_abc
#=> ["C:1", "D:2", "B:3", "A:4"]
```

which is the same result of the reference above.

The result strings are always in format `Candidate:Position`, because it's possible that multiple candidates can be on the same rank.

## Contributing to schulze-vote

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Use git-flow
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Problems? Questions?

![Alessandro Rodi](http://www.gravatar.com/avatar/32d80da41830a6e6c1bb3eb977537e3e)

## Copyright

See LICENSE for further details.

