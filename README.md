GitHub Favourite Language
=========================

This code test was set by a London tech company.

The challenge
-------------

To write a command line utility, or web application that tries to guess the
favourite programming language of a GitHub user using the [GitHub API].

My response
-----------

I wrote a command line utility in Ruby using [Thor] that interacts with
the GitHub API using [Octokit]. The API provides a list of repositories
and their predominant language. I calculated the favourite by comparing
the total size of all repositories for each predominant language.

I used [RSpec] for TDD with [Guard] for continous testing. To run the tests
`bundle install` and run `rspec`.

### Usage

Clone this repository, `bundle install` and run:

```
$ ./hub_favourite -u USERNAME
```

where USERNAME is the GitHub username you're interested in.

### Example

```
$ ./hub_favourite -u jamesjoshuahill
jamesjoshuahill's favourite language on GitHub is Ruby.
```

  [GitHub API]: http://developer.github.com/
  [Thor]: http://whatisthor.com/
  [Octokit]: http://octokit.github.io/octokit.rb/
  [RSpec]: https://www.relishapp.com/rspec/rspec-core/docs
  [Guard]: http://guardgem.org/
  
