#!/usr/bin/env ruby
require 'thor'
require 'octokit'

class Array

  def most_common_element
    self.group_by { |e| e }.values.max_by(&:count).first
  end

end

class GitHubFavouriteLanguage < Thor
  package_name "GitHub Favourite Language"

  def repositories(username)
    Octokit.repositories(username)
  end

  def favourite_language(username)
    repositories(username).map(&:language).most_common_element
  end

end

GitHubFavouriteLanguage.start
