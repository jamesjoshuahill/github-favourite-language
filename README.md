GitHub Favourite Language
=========================

This code test was set by London tech company.

The challenge
-------------

To create a command line utility or a web application that tries to guess the
favourite programming language of a GitHub user using the GitHub API.

My response
-----------

I decided to write a command line utility using [Thor] and interact with the
GitHub API using [Octokit]. The API provides a list of repositories and the
predominant language of each of them. To make a better guess I compared each
language by total size of repositories.

I used [RSpec] for TDD with [Guard] for continous testing.

### Usage

Clone this repository, `bundle install` and run:

```
$ ./github_favourite_language.rb -u USERNAME
```

  [Thor]: http://whatisthor.com/
  [Octokit]: http://octokit.github.io/octokit.rb/
  [RSpec]: https://www.relishapp.com/rspec/rspec-core/docs
  [Guard]: http://guardgem.org/
  
