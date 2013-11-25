#!/usr/bin/env ruby
require 'thor'
require 'octokit'

class GitHubFavouriteLanguage < Thor
  package_name "GitHub Favourite Language"

  def repositories(username)
    Octokit.repositories(username)
  end

end

GitHubFavouriteLanguage.start
